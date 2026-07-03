// lib/features/onboarding/presentation/widgets/onboarding_page_indicator.dart
//
// Orynta 2.0 — Animated Page Indicator
//
// Displays animated "Step X of 4" text and Material 3 pill dot indicators.

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Step X of 4 text switcher
        AnimatedSwitcher(
          duration: AppDurations.fast,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: child,
          ),
          child: Text(
            'Step ${currentPage + 1} of $totalPages',
            key: ValueKey(currentPage),
            style: context.typography.labelSmall.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: context.spacing.xs),

        // M3 Animated Pill Dots
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(totalPages, (index) {
            final isActive = index == currentPage;
            return AnimatedContainer(
              duration: AppDurations.normal,
              curve: AppCurves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: isActive ? 24.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: isActive
                    ? primaryColor
                    : context.colors.outlineVariant,
              ),
            );
          }),
        ),
      ],
    );
  }
}
