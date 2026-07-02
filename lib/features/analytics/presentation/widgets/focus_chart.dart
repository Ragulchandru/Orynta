import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/constants/app_sizes.dart';
import '../../../focus/domain/entities/focus_session_entity.dart';

class FocusChart extends StatelessWidget {
  const FocusChart({
    super.key,
    required this.focusSessions,
  });

  final List<FocusSessionEntity> focusSessions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Filter and sum durations
    final completed = focusSessions.where((s) => s.completed).toList();
    final focusMins = completed
        .where((s) => s.sessionType == 'focus')
        .map((s) => s.actualDurationMinutes)
        .fold(0, (a, b) => a + b);

    final shortMins = completed
        .where((s) => s.sessionType == 'shortBreak')
        .map((s) => s.actualDurationMinutes)
        .fold(0, (a, b) => a + b);

    final longMins = completed
        .where((s) => s.sessionType == 'longBreak')
        .map((s) => s.actualDurationMinutes)
        .fold(0, (a, b) => a + b);

    final totalMins = focusMins + shortMins + longMins;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Focus Allocation',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Distribution of study blocks vs recovery breaks',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            if (totalMins == 0)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                  child: Column(
                    children: [
                      Icon(Icons.pie_chart_outline_rounded, size: 48, color: colorScheme.outline),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        'No focus blocks logged yet.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                      ),
                    ],
                  ),
                ),
              )
            else
              Row(
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: CustomPaint(
                      painter: _DonutChartPainter(
                        focusMins: focusMins,
                        shortMins: shortMins,
                        longMins: longMins,
                        focusColor: colorScheme.primary,
                        shortColor: Colors.green,
                        longColor: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.xl),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendRow('Focus Blocks', focusMins, colorScheme.primary, totalMins),
                        const SizedBox(height: AppSizes.sm),
                        _buildLegendRow('Short Breaks', shortMins, Colors.green, totalMins),
                        const SizedBox(height: AppSizes.sm),
                        _buildLegendRow('Long Breaks', longMins, Colors.teal, totalMins),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendRow(String label, int mins, Color color, int total) {
    final percentage = total > 0 ? (mins / total * 100).toInt() : 0;
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                '${mins}m ($percentage%)',
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  _DonutChartPainter({
    required this.focusMins,
    required this.shortMins,
    required this.longMins,
    required this.focusColor,
    required this.shortColor,
    required this.longColor,
  });

  final int focusMins;
  final int shortMins;
  final int longMins;
  final Color focusColor;
  final Color shortColor;
  final Color longColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 22.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final total = focusMins + shortMins + longMins;
    if (total == 0) return;

    final paintFocus = Paint()
      ..color = focusColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final paintShort = Paint()
      ..color = shortColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final paintLong = Paint()
      ..color = longColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    double startAngle = -math.pi / 2;

    // Focus arc
    final sweepFocus = (focusMins / total) * 2 * math.pi;
    canvas.drawArc(rect, startAngle, sweepFocus, false, paintFocus);
    startAngle += sweepFocus;

    // Short Break arc
    final sweepShort = (shortMins / total) * 2 * math.pi;
    canvas.drawArc(rect, startAngle, sweepShort, false, paintShort);
    startAngle += sweepShort;

    // Long Break arc
    final sweepLong = (longMins / total) * 2 * math.pi;
    canvas.drawArc(rect, startAngle, sweepLong, false, paintLong);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
