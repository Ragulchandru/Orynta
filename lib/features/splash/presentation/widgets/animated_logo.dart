// lib/features/splash/presentation/widgets/animated_logo.dart
//
// Orynta 2.0 — Animated Logo Widget
//
// Renders the official Orynta logo from image assets wrapped in a Hero widget.
// If the asset image is absent or fails to load, renders a sleek, stylized Orynta
// geometric brand mark (gradient diamond icon mark with zero text) to prevent
// duplicate text or button-like container boxes.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
    required this.fadeAnimation,
    required this.scaleAnimation,
    required this.heroTag,
    required this.logoAssetPath,
    this.isReducedMotion = false,
    this.size = 72.0,
  });

  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;
  final String heroTag;
  final String logoAssetPath;
  final bool isReducedMotion;
  final double size;

  @override
  Widget build(BuildContext context) {
    final logoWidget = Image.asset(
      logoAssetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Sleek geometric brand mark fallback — luxury tilted diamond icon mark with primary gradient
        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Transform.rotate(
              angle: math.pi / 4, // 45-degree diamond tilt
              child: Container(
                width: size * 0.65,
                height: size * 0.65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size * 0.18),
                  gradient: context.gradients.primary,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.primary.withValues(alpha: 0.25),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: -math.pi / 4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return Hero(
      tag: heroTag,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: isReducedMotion
            ? logoWidget
            : ScaleTransition(
                scale: scaleAnimation,
                child: logoWidget,
              ),
      ),
    );
  }
}
