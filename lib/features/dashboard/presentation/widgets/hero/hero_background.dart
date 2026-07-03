// lib/features/dashboard/presentation/widgets/hero/hero_background.dart
//
// Orynta 2.0 — Hero Background Container Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/hero_background_style.dart';

class HeroBackground extends StatelessWidget {
  const HeroBackground({
    super.key,
    required this.child,
    this.style = HeroBackgroundStyle.subtleGlow,
    this.padding,
  });

  final Widget child;
  final HeroBackgroundStyle style;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: context.radius.borderRadiusXl,
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: 0.8),
        ),
        boxShadow: context.shadows.medium,
      ),
      child: Stack(
        children: [
          // Subtle radial glow overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: context.radius.borderRadiusXl,
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.2,
                  colors: [
                    primaryColor.withValues(alpha: 0.05),
                    context.colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          child,
        ],
      ),
    );
  }
}
