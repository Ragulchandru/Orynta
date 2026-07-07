// lib/features/analytics/presentation/widgets/task_completion_overview_card.dart

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

class TaskCompletionOverviewCard extends ConsumerStatefulWidget {
  const TaskCompletionOverviewCard({super.key});

  @override
  ConsumerState<TaskCompletionOverviewCard> createState() => _TaskCompletionOverviewCardState();
}

class _TaskCompletionOverviewCardState extends ConsumerState<TaskCompletionOverviewCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _selectedIndex;
  Timer? _tooltipTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: MotionTokens.emphasized,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant TaskCompletionOverviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            Text(
              'Task Completion Overview',
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Completed tasks counts distribution',
              style: context.typography.bodySmall.copyWith(color: colorScheme.outline),
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
                        final count = trendPoints.length;
                        final double spacing = count > 1 ? width / count : width;
                        final tappedIndex = (localX / spacing).floor().clamp(0, count - 1);
                        _selectIndex(tappedIndex);
                      },
                      child: RepaintBoundary(
                        child: SizedBox(
                          height: 140,
                          width: double.infinity,
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: _OverviewBarPainter(
                                  trendPoints: trendPoints,
                                  completedPoints: completed,
                                  primaryColor: colorScheme.primary,
                                  accentColor: colorScheme.secondary,
                                  gridColor: colorScheme.outlineVariant.withValues(alpha: 0.15),
                                  progress: _animation.value,
                                  selectedIndex: _selectedIndex,
                                ),
                              );
                            },
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
}

class _OverviewBarPainter extends CustomPainter {
  final List<TrendPoint> trendPoints;
  final List<int> completedPoints;
  final Color primaryColor;
  final Color accentColor;
  final Color gridColor;
  final double progress;
  final int? selectedIndex;

  _OverviewBarPainter({
    required this.trendPoints,
    required this.completedPoints,
    required this.primaryColor,
    required this.accentColor,
    required this.gridColor,
    required this.progress,
    required this.selectedIndex,
  });

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

    if (completedPoints.isEmpty) return;

    final maxVal = [
      ...completedPoints,
      3,
    ].reduce((a, b) => a > b ? a : b).toDouble();

    final count = completedPoints.length;
    final double spacing = count > 1 ? width / count : width;
    final double barWidth = (spacing * 0.45).clamp(3.0, 16.0);

    for (int i = 0; i < count; i++) {
      final startDelay = (i * 0.04).clamp(0.0, 0.4);
      final double progressScale = ((progress - startDelay) / 0.6).clamp(0.0, 1.0);
      final double scale = progressScale == 1.0 ? 1.0 : progressScale * 1.15 - 0.15 * math.pow(progressScale, 3);

      final val = completedPoints[i];
      final barHeight = (val / maxVal) * (height - 10) * scale;

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
        Paint()..color = isSelected ? accentColor : primaryColor.withValues(alpha: 0.8),
      );
    }

    _drawTooltip(canvas, width, height, maxVal);
  }

  void _drawTooltip(Canvas canvas, double width, double height, double maxVal) {
    if (selectedIndex == null || selectedIndex! >= trendPoints.length) return;

    final count = trendPoints.length;
    final double spacing = count > 1 ? width / count : width;
    final x = count > 1 ? selectedIndex! * spacing + spacing / 2 : width / 2;

    // Draw vertical line guide
    canvas.drawLine(
      Offset(x, 0),
      Offset(x, height),
      Paint()
        ..color = primaryColor.withValues(alpha: 0.25)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke,
    );

    final point = trendPoints[selectedIndex!];
    final dateStr = DateFormat('MMM d, yyyy').format(point.date);
    final tooltipText = '$dateStr\nCompleted: ${point.completed} Tasks';

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

    const double tooltipY = 6.0;

    final bgRect = Rect.fromLTWH(
      tooltipX,
      tooltipY,
      textPainter.width + 16,
      textPainter.height + 10,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(8)),
      Paint()..color = Colors.black.withValues(alpha: 0.85),
    );

    textPainter.paint(canvas, Offset(tooltipX + 8, tooltipY + 5));
  }

  @override
  bool shouldRepaint(covariant _OverviewBarPainter oldDelegate) {
    return oldDelegate.completedPoints != completedPoints ||
        oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}
