// lib/features/onboarding/presentation/widgets/onboarding_preference_card.dart
//
// Orynta 2.0 — Preference Selection Card Widget
//
// Displays a selectable preference option with primary accent border, soft background tint,
// scale feedback, and checkmark indicator.

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/onboarding_preference_option.dart';

class OnboardingPreferenceCard<T> extends StatelessWidget {
  const OnboardingPreferenceCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onSelect,
    this.compact = false,
  });

  final OnboardingPreferenceOption<T> option;
  final bool isSelected;
  final VoidCallback onSelect;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return AnimatedScale(
      scale: isSelected ? 1.02 : 1.0,
      duration: AppDurations.fast,
      curve: AppCurves.easeOut,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: AppCurves.easeOut,
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.08)
              : context.colors.surfaceContainerLow,
          borderRadius: context.radius.borderRadiusMd,
          border: Border.all(
            color: isSelected ? primaryColor : context.colors.outlineVariant,
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected ? context.shadows.small : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onSelect,
            borderRadius: context.radius.borderRadiusMd,
            child: Padding(
              padding: compact
                  ? const EdgeInsets.symmetric(horizontal: 14, vertical: 12)
                  : context.spacing.paddingCard,
              child: Row(
                children: [
                  // Icon
                  Icon(
                    option.icon,
                    size: compact ? 20 : 24,
                    color: isSelected ? primaryColor : context.colors.textSecondary,
                  ),
                  SizedBox(width: context.spacing.md),

                  // Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          option.title,
                          style: context.typography.titleMedium.copyWith(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? primaryColor : context.colors.textPrimary,
                          ),
                        ),
                        if (option.subtitle.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            option.subtitle,
                            style: context.typography.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Checkmark indicator
                  AnimatedSwitcher(
                    duration: AppDurations.fast,
                    child: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            key: const ValueKey('check'),
                            size: 20,
                            color: primaryColor,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            key: const ValueKey('uncheck'),
                            size: 20,
                            color: context.colors.outline,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
