// lib/features/onboarding/presentation/widgets/onboarding_page_three_personalization.dart
//
// Orynta 2.0 — Onboarding Page 3 (Personalization & Live Greeting Preview)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingPageThreePersonalization extends ConsumerStatefulWidget {
  const OnboardingPageThreePersonalization({super.key});

  @override
  ConsumerState<OnboardingPageThreePersonalization> createState() =>
      _OnboardingPageThreePersonalizationState();
}

class _OnboardingPageThreePersonalizationState
    extends ConsumerState<OnboardingPageThreePersonalization> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    final currentName = ref.read(onboardingControllerProvider).displayName;
    _textController = TextEditingController(text: currentName);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);
    final greeting = _getTimeGreeting();

    return Padding(
      padding: context.spacing.paddingHorizontalLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),

          Text(
            'What should we call you?',
            style: context.typography.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Personalize your workspace experience.',
            style: context.typography.bodyMedium.copyWith(
              color: context.colors.textSecondary,
            ),
          ),

          SizedBox(height: context.spacing.xl),

          // Display Name TextField
          Container(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: context.radius.borderRadiusLg,
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: TextField(
              controller: _textController,
              textCapitalization: TextCapitalization.words,
              maxLength: state.config.maxDisplayNameLength,
              style: context.typography.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Your name',
                counterText: '',
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: context.colors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onChanged: (val) => notifier.updateDisplayName(val),
            ),
          ),

          SizedBox(height: context.spacing.xl),

          // Live Dynamic Greeting Preview Card
          AnimatedContainer(
            duration: AppDurations.short,
            width: double.infinity,
            padding: context.spacing.paddingCard,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.06),
              borderRadius: context.radius.borderRadiusLg,
              border: Border.all(
                color: context.colors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE PREVIEW',
                      style: context.typography.labelSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colors.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.spacing.sm),

                Text(
                  greeting,
                  style: context.typography.titleMedium.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  state.effectiveDisplayName,
                  style: context.typography.headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.colors.primary,
                  ),
                ),

                SizedBox(height: context.spacing.sm),

                Text(
                  'Today is a great day to stay organized.',
                  style: context.typography.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
