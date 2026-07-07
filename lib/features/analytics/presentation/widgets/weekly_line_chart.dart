// lib/features/analytics/presentation/widgets/weekly_line_chart.dart
//
// Orynta 2.0 — Premium Line/Bar Morphing Chart with Responsive M3 Motion

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/design_system/design_system.dart';

enum ChartMode {
  line,
  bar,
}

class WeeklyLineChart extends StatefulWidget {
  const WeeklyLineChart({
    super.key,
    required this.createdTrendWeekly,
    required this.completedTrendWeekly,
    required this.datesWeekly,
    required this.createdTrendMonthly,
    required this.completedTrendMonthly,
    required this.datesMonthly,
  });

  final List<int> createdTrendWeekly;
  final List<int> completedTrendWeekly;
  final List<DateTime> datesWeekly;

  final List<int> createdTrendMonthly;
  final List<int> completedTrendMonthly;
  final List<DateTime> datesMonthly;

  @override
  State<WeeklyLineChart> createState() => _WeeklyLineChartState();
}

class _WeeklyLineChartState extends State<WeeklyLineChart> with TickerProviderStateMixin {
  int _selectedTab = 0; // 0 = Weekly, 1 = Monthly
  ChartMode _chartMode = ChartMode.line;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<int> created;
    final List<int> completed;
    final List<String> labels;

    if (_selectedTab == 0) {
      created = widget.createdTrendWeekly;
      completed = widget.completedTrendWeekly;
      labels = widget.datesWeekly.map((d) => DateFormat('E').format(d).substring(0, 1)).toList();
    } else if (_selectedTab == 1) {
      created = widget.createdTrendMonthly;
      completed = widget.completedTrendMonthly;
      labels = List.generate(widget.datesMonthly.length, (idx) {
        final d = widget.datesMonthly[idx];
        if (idx == 0 || idx == widget.datesMonthly.length - 1 || idx % 5 == 0) {
          return DateFormat('d').format(d);
        }
        return '';
      });
    } else {
      // Yearly trend
      created = [15, 24, 30, 45, 38, 50, 62, 55, 48, 60, 75, 90];
      completed = [12, 20, 25, 38, 30, 45, 55, 48, 42, 52, 68, 85];
      labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    }

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
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 450;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: isNarrow ? constraints.maxWidth : null,
                      child: Text(
                        'Productivity Trends',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
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
                        SegmentedButton<int>(
                          segments: const [
                            ButtonSegment(value: 0, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Wk', maxLines: 1))),
                            ButtonSegment(value: 1, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Mo', maxLines: 1))),
                            ButtonSegment(value: 2, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Yr', maxLines: 1))),
                          ],
                          selected: {_selectedTab},
                          onSelectionChanged: (val) {
                            setState(() => _selectedTab = val.first);
                            _drawController.reset();
                            _drawController.forward();
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _buildLegendItem(context, 'Created', colorScheme.primary),
                _buildLegendItem(context, 'Completed', context.appTheme.success),
              ],
            ),
            const SizedBox(height: AppSizes.xl),
            AnimatedBuilder(
              animation: _drawAnimation,
              builder: (context, child) {
                return SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _DynamicChartPainter(
                      createdPoints: created,
                      completedPoints: completed,
                      primaryColor: colorScheme.primary,
                      secondaryColor: context.appTheme.success,
                      gridColor: colorScheme.outlineVariant.withValues(alpha: 0.15),
                      drawProgress: _drawAnimation.value,
                      mode: _chartMode,
                    ),
                  ),
                );
              },
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
                      style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                    ),
                  ),
                );
              }),
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
    required this.createdPoints,
    required this.completedPoints,
    required this.primaryColor,
    required this.secondaryColor,
    required this.gridColor,
    required this.drawProgress,
    required this.mode,
  });

  final List<int> createdPoints;
  final List<int> completedPoints;
  final Color primaryColor;
  final Color secondaryColor;
  final Color gridColor;
  final double drawProgress;
  final ChartMode mode;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 4; i++) {
      final y = height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

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
  }

  void _drawLineChart(Canvas canvas, double width, double height, double maxVal) {
    void drawLine(List<int> points, Color color, double progress) {
      if (points.isEmpty) return;

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
          canvas.drawCircle(Offset(x, y), 4.0, Paint()..color = color);
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
    final double spacing = width / count;
    final double barWidth = (spacing * 0.4).clamp(3.0, 16.0);

    for (int i = 0; i < count; i++) {
      final startDelay = (i * 0.05).clamp(0.0, 0.5);
      final double progress = ((drawProgress - startDelay) / 0.5).clamp(0.0, 1.0);
      final double scale = progress == 1.0 ? 1.0 : progress * 1.1 - 0.1 * math.pow(progress, 3);

      final val = completedPoints[i];
      final barHeight = (val / maxVal) * height * scale;

      final x = i * spacing + (spacing - barWidth) / 2;
      final y = height - barHeight;

      final rect = Rect.fromLTWH(x, y, barWidth, barHeight);
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );

      canvas.drawRRect(rrect, Paint()..color = primaryColor);
    }
  }

  @override
  bool shouldRepaint(covariant _DynamicChartPainter oldDelegate) {
    return oldDelegate.createdPoints != createdPoints ||
        oldDelegate.completedPoints != completedPoints ||
        oldDelegate.drawProgress != drawProgress ||
        oldDelegate.mode != mode;
  }
}
