import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/constants/app_sizes.dart';

class ProductivityScoreCard extends StatelessWidget {
  const ProductivityScoreCard({
    super.key,
    required this.score,
  });

  final double score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String level = switch (score) {
      >= 90 => 'Elite',
      >= 60 => 'Focused',
      _ => 'Casual',
    };

    final Color levelColor = switch (score) {
      >= 90 => Colors.amber,
      >= 60 => colorScheme.primary,
      _ => colorScheme.outline,
    };

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
          children: [
            Text(
              'TODAY\'S PRODUCTIVITY SCORE',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.outline,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(
              width: 160,
              height: 160,
              child: CustomPaint(
                painter: _GaugePainter(
                  score: score,
                  color: levelColor,
                  backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${score.toInt()}',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'POINTS',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.outline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Chip(
              backgroundColor: levelColor.withValues(alpha: 0.1),
              side: BorderSide(color: levelColor.withValues(alpha: 0.3)),
              label: Text(
                '$level Zone',
                style: TextStyle(
                  color: levelColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.score,
    required this.color,
    required this.backgroundColor,
  });

  final double score;
  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 14.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final basePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw 240 degree gauge arc starting from 150 degrees (bottom-left) to 30 degrees (bottom-right)
    const startAngle = 150.0 * math.pi / 180.0;
    const sweepAngle = 240.0 * math.pi / 180.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      basePaint,
    );

    final progressSweepAngle = (score / 100.0) * sweepAngle;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progressSweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
