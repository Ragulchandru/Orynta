// lib/features/onboarding/presentation/widgets/abstract_graphic_welcome.dart
//
// Orynta 2.0 — Minimalist Abstract Geometric Graphic (Welcome Page)
//
// Rendered using CustomPainter with smooth gradient overlays.

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class AbstractGraphicWelcome extends StatelessWidget {
  const AbstractGraphicWelcome({
    super.key,
    this.size = 180.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;
    final secondaryColor = context.colors.secondary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _WelcomePainter(
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
      ),
    );
  }
}

class _WelcomePainter extends CustomPainter {
  _WelcomePainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background soft glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.18),
          primaryColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glowPaint);

    // Primary overlapping ring
    final ring1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..shader = SweepGradient(
        colors: [
          primaryColor.withValues(alpha: 0.8),
          secondaryColor.withValues(alpha: 0.2),
          primaryColor.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.65));
    canvas.drawCircle(center, radius * 0.65, ring1);

    // Inner diamond accent
    final diamondPath = Path();
    final dSize = radius * 0.4;
    diamondPath.moveTo(center.dx, center.dy - dSize);
    diamondPath.lineTo(center.dx + dSize, center.dy);
    diamondPath.lineTo(center.dx, center.dy + dSize);
    diamondPath.lineTo(center.dx - dSize, center.dy);
    diamondPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.withValues(alpha: 0.4),
          secondaryColor.withValues(alpha: 0.1),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: dSize));
    canvas.drawPath(diamondPath, fillPaint);

    // Sparkle center dot
    final dotPaint = Paint()..color = primaryColor;
    canvas.drawCircle(center, 4.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _WelcomePainter oldDelegate) => false;
}
