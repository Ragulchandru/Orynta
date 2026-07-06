// lib/features/splash/presentation/widgets/animated_logo.dart
//
// Orynta 2.0 — Animated Logo Widget

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_system.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
    required this.fadeAnimation,
    required this.scaleAnimation,
    required this.heroTag,
    required this.logoAssetPath,
    this.isReducedMotion = false,
    this.size = 190.0,
  });

  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;
  final String heroTag;
  final String logoAssetPath;
  final bool isReducedMotion;
  final double size;

  @override
  Widget build(BuildContext context) {
    final logoWidget = OryntaLogo(
      size: size,
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
