// lib/features/dashboard/presentation/widgets/analytics/weekly_activity_chart.dart
//
// Orynta 2.0 — Weekly Activity Chart Component (CustomPainter)

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/weekly_activity.dart';

class WeeklyActivityChart extends StatelessWidget {
  const WeeklyActivityChart({
    super.key,
    required this.activities,
  });

  final List<WeeklyActivity> activities;

  static const List<String> _defaultDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final barColor = context.colors.primary;
    final trackColor = context.colors.outlineVariant.withValues(alpha: 0.4);
    final hasData = activities.any((a) => a.value > 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: context.radius.borderRadiusLg,
        border: Border.all(color: context.colors.outlineVariant),
        boxShadow: context.shadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Progress',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                hasData ? 'Active' : 'No Activity',
                style: context.typography.labelSmall.copyWith(
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Custom Chart Canvas
          SizedBox(
            height: 80,
            child: CustomPaint(
              size: const Size(double.infinity, 80),
              painter: _WeeklyChartPainter(
                activities: activities,
                days: _defaultDays,
                barColor: barColor,
                trackColor: trackColor,
                hasData: hasData,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyChartPainter extends CustomPainter {
  _WeeklyChartPainter({
    required this.activities,
    required this.days,
    required this.barColor,
    required this.trackColor,
    required this.hasData,
  });

  final List<WeeklyActivity> activities;
  final List<String> days;
  final Color barColor;
  final Color trackColor;
  final bool hasData;

  @override
  void paint(Canvas canvas, Size size) {
    const barWidth = 14.0;
    const count = 7;
    final spacing = (size.width - (barWidth * count)) / (count + 1);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.fill;

    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final x = spacing + i * (barWidth + spacing);
      final trackRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, 0, barWidth, size.height - 20),
        const Radius.circular(6),
      );

      // Draw Track Background
      canvas.drawRRect(trackRect, trackPaint);

      // Draw Progress Bar
      final val = (hasData && i < activities.length) ? activities[i].value : 0.15;
      final barHeight = (size.height - 20) * val.clamp(0.05, 1.0);
      final barY = (size.height - 20) - barHeight;

      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, barY, barWidth, barHeight),
        const Radius.circular(6),
      );

      canvas.drawRRect(
        fillRect,
        hasData ? barPaint : trackPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeeklyChartPainter oldDelegate) {
    return oldDelegate.activities != activities ||
        oldDelegate.barColor != barColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.hasData != hasData;
  }
}
