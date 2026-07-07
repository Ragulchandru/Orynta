// lib/features/analytics/presentation/widgets/weekly_line_chart.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:ui' as ui;

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/design_system/design_system.dart';
import '../providers/insights_time_filter_provider.dart';
import '../providers/analytics_provider.dart';
import 'analytics_axis_formatter.dart';

enum ChartMode {
  line,
  bar,
}

class WeeklyLineChart extends ConsumerStatefulWidget {
  const WeeklyLineChart({super.key});

  @override
  ConsumerState<WeeklyLineChart> createState() => _WeeklyLineChartState();
}

class _WeeklyLineChartState extends ConsumerState<WeeklyLineChart> with SingleTickerProviderStateMixin {
  ChartMode _chartMode = ChartMode.line;
  int? _selectedIndex;
  Timer? _tooltipTimer;

  late AnimationController _drawController;
  late Animation<double> _drawAnimation;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _drawAnimation = CurvedAnimation(
      parent: _drawController,
      curve: MotionTokens.emphasized,
    );
    _drawController.forward();
  }

  @override
  void didUpdateWidget(covariant WeeklyLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _drawController.reset();
    _drawController.forward();
  }

  @override
  void dispose() {
    _drawController.dispose();
    _tooltipTimer?.cancel();
    super.dispose();
  }

  void _selectIndex(int index) {
    _tooltipTimer?.cancel();
    setState(() {
      _selectedIndex = index;
    });
    _tooltipTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _selectedIndex = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeRange = ref.watch(insightsTimeRangeProvider);
    final trendPoints = ref.watch(activeTrendProvider);

    final created = trendPoints.map((p) => p.created).toList();
    final completed = trendPoints.map((p) => p.completed).toList();
    final dates = trendPoints.map((p) => p.date).toList();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Productivity Trends',
                  style: context.typography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                IconButton.filledTonal(
                  icon: Icon(
                    _chartMode == ChartMode.line ? Icons.show_chart_rounded : Icons.bar_chart_rounded,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _chartMode = _chartMode == ChartMode.line ? ChartMode.bar : ChartMode.line;
                    });
                    _drawController.reset();
                    _drawController.forward();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _buildLegendItem(context, 'Created', colorScheme.primary),
                _buildLegendItem(context, 'Completed', context.appTheme.success),
              ],
            ),
            const SizedBox(height: AppSizes.xl),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final labels = AnalyticsAxisFormatter.getLabels(
                  dates: dates,
                  range: activeRange,
                  availableWidth: width,
                );

                return Column(
                  children: [
                    GestureDetector(
                      onTapDown: (details) {
                        if (trendPoints.isEmpty) return;
                        final localX = details.localPosition.dx;
                        final stepX = trendPoints.length > 1 ? width / (trendPoints.length - 1) : width;
                        final tappedIndex = (localX / stepX).round().clamp(0, trendPoints.length - 1);
                        _selectIndex(tappedIndex);
                      },
                      child: RepaintBoundary(
                        child: SizedBox(
                          height: 160,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: _DynamicChartPainter(
                              trendPoints: trendPoints,
                              createdPoints: created,
                              completedPoints: completed,
                              primaryColor: colorScheme.primary,
                              secondaryColor: context.appTheme.success,
                              gridColor: colorScheme.outlineVariant.withValues(alpha: 0.15),
                              drawProgress: _drawAnimation.value,
                              mode: _chartMode,
                              selectedIndex: _selectedIndex,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(labels.length, (idx) {
                        final label = labels[idx];
                        return Expanded(
                          child: Center(
                            child: Text(
                              label,
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: context.typography.labelSmall.copyWith(
                                color: colorScheme.outline,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _DynamicChartPainter extends CustomPainter {
  _DynamicChartPainter({
    required this.trendPoints,
    required this.createdPoints,
    required this.completedPoints,
    required this.primaryColor,
    required this.secondaryColor,
    required this.gridColor,
    required this.drawProgress,
    required this.mode,
    required this.selectedIndex,
  });

  final List<TrendPoint> trendPoints;
  final List<int> createdPoints;
  final List<int> completedPoints;
  final Color primaryColor;
  final Color secondaryColor;
  final Color gridColor;
  final double drawProgress;
  final ChartMode mode;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Draw horizontal grid lines at 25%, 50%, 75%, 100%
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 4; i++) {
      final y = height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    if (createdPoints.isEmpty) return;

    final maxVal = [
      ...createdPoints,
      ...completedPoints,
      5,
    ].reduce((a, b) => a > b ? a : b).toDouble();

    if (mode == ChartMode.line) {
      _drawLineChart(canvas, width, height, maxVal);
    } else {
      _drawBarChart(canvas, width, height, maxVal);
    }

    _drawTooltip(canvas, width, height, maxVal);
  }

  void _drawLineChart(Canvas canvas, double width, double height, double maxVal) {
    void drawLine(List<int> points, Color color, double progress) {
      if (points.length < 2) return;

      final path = Path();
      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;

      final stepX = width / (points.length - 1);
      final double activeWidth = width * progress;

      bool started = false;
      for (int i = 0; i < points.length; i++) {
        final x = i * stepX;
        final y = height - (points[i] / maxVal) * height;

        if (x <= activeWidth) {
          if (!started) {
            path.moveTo(x, y);
            started = true;
          } else {
            path.lineTo(x, y);
          }
          canvas.drawCircle(
            Offset(x, y),
            4.0,
            Paint()..color = selectedIndex == i ? Colors.white : color,
          );
          if (selectedIndex == i) {
            canvas.drawCircle(
              Offset(x, y),
              6.0,
              Paint()
                ..color = color
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2.0,
            );
          }
        }
      }
      canvas.drawPath(path, linePaint);
    }

    final createdProgress = ((drawProgress - 0.0) / 0.7).clamp(0.0, 1.0);
    final completedProgress = ((drawProgress - 0.3) / 0.7).clamp(0.0, 1.0);

    drawLine(createdPoints, primaryColor, createdProgress);
    drawLine(completedPoints, secondaryColor, completedProgress);
  }

  void _drawBarChart(Canvas canvas, double width, double height, double maxVal) {
    final count = completedPoints.length;
    final double spacing = count > 1 ? width / count : width;
    final double barWidth = (spacing * 0.4).clamp(3.0, 16.0);

    for (int i = 0; i < count; i++) {
      final startDelay = (i * 0.05).clamp(0.0, 0.5);
      final double progress = ((drawProgress - startDelay) / 0.5).clamp(0.0, 1.0);
      final double scale = progress == 1.0 ? 1.0 : progress * 1.1 - 0.1 * math.pow(progress, 3);

      final val = completedPoints[i];
      final barHeight = (val / maxVal) * height * scale;

      final x = count > 1 ? i * spacing + (spacing - barWidth) / 2 : (width - barWidth) / 2;
      final y = height - barHeight;

      final rect = Rect.fromLTWH(x, y, barWidth, barHeight);
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );

      final isSelected = selectedIndex == i;
      canvas.drawRRect(
        rrect,
        Paint()..color = isSelected ? secondaryColor : primaryColor,
      );
    }
  }

  void _drawTooltip(Canvas canvas, double width, double height, double maxVal) {
    if (selectedIndex == null || selectedIndex! >= trendPoints.length) return;

    final stepX = trendPoints.length > 1 ? width / (trendPoints.length - 1) : width;
    final x = selectedIndex! * stepX;

    // Draw vertical guideline
    canvas.drawLine(
      Offset(x, 0),
      Offset(x, height),
      Paint()
        ..color = primaryColor.withValues(alpha: 0.3)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke,
    );

    final point = trendPoints[selectedIndex!];
    final dateStr = DateFormat('MMM d, yyyy').format(point.date);
    final rate = point.created > 0 ? (point.completed / point.created * 100).toInt() : 0;

    final tooltipText = '$dateStr\nCreated: ${point.created} Tasks\nCompleted: ${point.completed} Tasks\nRate: $rate%';

    final textPainter = TextPainter(
      text: TextSpan(
        text: tooltipText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    double tooltipX = x + 10;
    if (tooltipX + textPainter.width + 16 > width) {
      tooltipX = x - textPainter.width - 26;
    }
    tooltipX = tooltipX.clamp(4.0, width - textPainter.width - 20);

    const double tooltipY = 8.0;

    final bgRect = Rect.fromLTWH(
      tooltipX,
      tooltipY,
      textPainter.width + 16,
      textPainter.height + 12,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(8)),
      Paint()..color = Colors.black.withValues(alpha: 0.85),
    );

    textPainter.paint(canvas, Offset(tooltipX + 8, tooltipY + 6));
  }

  @override
  bool shouldRepaint(covariant _DynamicChartPainter oldDelegate) {
    return oldDelegate.createdPoints != createdPoints ||
        oldDelegate.completedPoints != completedPoints ||
        oldDelegate.drawProgress != drawProgress ||
        oldDelegate.mode != mode ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}
