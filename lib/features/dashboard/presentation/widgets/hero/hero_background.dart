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
    final theme = context.appTheme;

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.notes.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.notes.cardBorder,
          width: 1.0,
        ),
      ),
      child: Stack(
        children: [
          // Subtle radial glow overlay (uses theme.primary)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.2,
                  colors: [
                    theme.primary.withValues(alpha: 0.05),
                    Colors.transparent,
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
