// lib/features/onboarding/presentation/widgets/abstract_graphic_ready.dart
//
// Orynta 2.0 — Minimalist Abstract Geometric Graphic (Ready Page)

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class AbstractGraphicReady extends StatelessWidget {
  const AbstractGraphicReady({
    super.key,
    this.size = 180.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;
    final successColor = context.colors.success;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ReadyPainter(
          primaryColor: primaryColor,
          successColor: successColor,
        ),
      ),
    );
  }
}

class _ReadyPainter extends CustomPainter {
  _ReadyPainter({
    required this.primaryColor,
    required this.successColor,
  });

  final Color primaryColor;
  final Color successColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background radial glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.16),
          primaryColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glowPaint);

    // Glowing circle
    final circlePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [
          primaryColor.withValues(alpha: 0.2),
          primaryColor.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.55));
    canvas.drawCircle(center, radius * 0.55, circlePaint);

    // Stylized checkmark icon mark
    final checkPath = Path();
    final cWidth = radius * 0.35;
    checkPath.moveTo(center.dx - cWidth * 0.6, center.dy);
    checkPath.lineTo(center.dx - cWidth * 0.1, center.dy + cWidth * 0.5);
    checkPath.lineTo(center.dx + cWidth * 0.7, center.dy - cWidth * 0.5);

    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(checkPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _ReadyPainter oldDelegate) => false;
}
