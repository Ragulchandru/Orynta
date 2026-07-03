// lib/features/onboarding/presentation/widgets/onboarding_page_two_experience.dart
//
// Orynta 2.0 — Onboarding Page 2 (Workspace Preferences)
//
// Responsive scrollable layout holding selectable options for:
//   1. Starting Experience (Dashboard, Notes, Planner, Analytics)
//   2. Notes Layout (Grid, List, Comfortable)
//   3. Appearance (System, Light, Dark, AMOLED)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/onboarding_preference_option.dart';
import '../controllers/onboarding_controller.dart';
import 'onboarding_preference_card.dart';

class OnboardingPageTwoExperience extends ConsumerWidget {
  const OnboardingPageTwoExperience({super.key});

  static const List<OnboardingPreferenceOption<String>> _homeOptions = [
    OnboardingPreferenceOption(
      id: 'dashboard',
      title: 'Dashboard',
      subtitle: 'Overview of your day, quick actions & recent activity.',
      icon: Icons.space_dashboard_rounded,
      value: '/',
    ),
    OnboardingPreferenceOption(
      id: 'notes',
      title: 'Notes',
      subtitle: 'Clean grid of your active ideas and documents.',
      icon: Icons.article_outlined,
      value: '/notes',
    ),
    OnboardingPreferenceOption(
      id: 'planner',
      title: 'Planner',
      subtitle: 'Calendar, daily tasks & habit tracking.',
      icon: Icons.calendar_today_rounded,
      value: '/planner',
    ),
    OnboardingPreferenceOption(
      id: 'analytics',
      title: 'Analytics',
      subtitle: 'Focus stats & completion trends.',
      icon: Icons.insights_rounded,
      value: '/insights',
    ),
  ];

  static const List<OnboardingPreferenceOption<String>> _layoutOptions = [
    OnboardingPreferenceOption(
      id: 'grid',
      title: 'Grid',
      subtitle: 'Modern 2-column card layout.',
      icon: Icons.grid_view_rounded,
      value: 'grid',
    ),
    OnboardingPreferenceOption(
      id: 'list',
      title: 'List',
      subtitle: 'Clean vertical list format.',
      icon: Icons.view_list_rounded,
      value: 'list',
    ),
    OnboardingPreferenceOption(
      id: 'comfortable',
      title: 'Comfortable',
      subtitle: 'Spacious single card stream.',
      icon: Icons.view_agenda_rounded,
      value: 'comfortable',
    ),
  ];

  static const List<OnboardingPreferenceOption<String>> _themeOptions = [
    OnboardingPreferenceOption(
      id: 'system',
      title: 'System',
      subtitle: 'Follow device OS setting.',
      icon: Icons.brightness_auto_rounded,
      value: 'system',
    ),
    OnboardingPreferenceOption(
      id: 'light',
      title: 'Light',
      subtitle: 'Crisp warm white surfaces.',
      icon: Icons.light_mode_rounded,
      value: 'light',
    ),
    OnboardingPreferenceOption(
      id: 'dark',
      title: 'Dark',
      subtitle: 'Deep charcoal surfaces.',
      icon: Icons.dark_mode_rounded,
      value: 'dark',
    ),
    OnboardingPreferenceOption(
      id: 'amoled',
      title: 'AMOLED',
      subtitle: 'True black OLED battery saver.',
      icon: Icons.nightlight_round,
      value: 'amoled',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: context.spacing.paddingHorizontalLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.spacing.md),

          // ── Section 1: Starting Experience ─────────────────────────────────
          Text(
            'Choose your starting experience',
            style: context.typography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'What would you like to see first when opening Orynta?',
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.spacing.sm),

          ..._homeOptions.map((opt) {
            final isSelected = state.defaultHomeScreen == opt.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: OnboardingPreferenceCard<String>(
                option: opt,
                isSelected: isSelected,
                compact: true,
                onSelect: () => notifier.setHomeScreen(opt.value),
              ),
            );
          }),

          SizedBox(height: context.spacing.lg),

          // ── Section 2: Notes Layout ────────────────────────────────────────
          Text(
            'How would you like your notes to look?',
            style: context.typography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select your preferred notes display format.',
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.spacing.sm),

          ..._layoutOptions.map((opt) {
            final isSelected = state.defaultNotesLayout == opt.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: OnboardingPreferenceCard<String>(
                option: opt,
                isSelected: isSelected,
                compact: true,
                onSelect: () => notifier.setNotesLayout(opt.value),
              ),
            );
          }),

          SizedBox(height: context.spacing.lg),

          // ── Section 3: Appearance Theme ────────────────────────────────────
          Text(
            'Choose your appearance',
            style: context.typography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select your preferred workspace color theme.',
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.spacing.sm),

          ..._themeOptions.map((opt) {
            final isSelected = state.preferredTheme == opt.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: OnboardingPreferenceCard<String>(
                option: opt,
                isSelected: isSelected,
                compact: true,
                onSelect: () => notifier.setTheme(opt.value),
              ),
            );
          }),

          SizedBox(height: context.spacing.xl),
        ],
      ),
    );
  }
}
