// lib/features/dashboard/presentation/widgets/hero/circular_score_painter.dart
//
// Orynta 2.0 — Circular Score Painter

import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularScorePainter extends CustomPainter {
  CircularScorePainter({
    required this.trackColor,
    required this.progressColor,
    required this.progress,
    this.strokeWidth = 6.0,
  });

  final Color trackColor;
  final Color progressColor;
  final double progress; // 0.0 to 1.0
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track Paint
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0.0) {
      // Progress Paint
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CircularScorePainter oldDelegate) {
    return oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
