// lib/features/onboarding/presentation/widgets/onboarding_page_four_ready.dart
//
// Orynta 2.0 — Onboarding Page 4 (Ready & Personalization Summary)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../controllers/onboarding_controller.dart';
import 'abstract_graphic_ready.dart';

class OnboardingPageFourReady extends ConsumerWidget {
  const OnboardingPageFourReady({super.key});

  String _getStartupLabel(String route) => switch (route) {
        '/notes' => 'Notes',
        '/planner' => 'Planner',
        '/insights' => 'Analytics',
        _ => 'Dashboard',
      };

  String _getLayoutLabel(String layout) => switch (layout) {
        'list' => 'List',
        'comfortable' => 'Comfortable',
        _ => 'Grid',
      };

  String _getThemeLabel(String theme) => switch (theme) {
        'light' => 'Light',
        'dark' => 'Dark',
        'amoled' => 'AMOLED',
        _ => 'System',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);

    return Padding(
      padding: context.spacing.paddingHorizontalLg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Abstract Success Graphic
          const AbstractGraphicReady(size: 160),

          SizedBox(height: context.spacing.lg),

          Text(
            "You're all set!",
            textAlign: TextAlign.center,
            style: context.typography.headlineMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Welcome to Orynta. Your workspace is ready.',
            textAlign: TextAlign.center,
            style: context.typography.bodyLarge.copyWith(
              color: context.colors.textSecondary,
            ),
          ),

          SizedBox(height: context.spacing.xl),

          // Personalization Summary Card
          Container(
            width: double.infinity,
            padding: context.spacing.paddingCard,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: context.radius.borderRadiusLg,
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'WORKSPACE CONFIGURATION',
                      style: context.typography.labelSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colors.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _SummaryRow(
                  label: 'Name',
                  value: state.effectiveDisplayName,
                ),
                const SizedBox(height: 6),
                _SummaryRow(
                  label: 'Startup Screen',
                  value: _getStartupLabel(state.defaultHomeScreen),
                ),
                const SizedBox(height: 6),
                _SummaryRow(
                  label: 'Notes Layout',
                  value: _getLayoutLabel(state.defaultNotesLayout),
                ),
                const SizedBox(height: 6),
                _SummaryRow(
                  label: 'Appearance',
                  value: _getThemeLabel(state.preferredTheme),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.typography.bodySmall.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: context.typography.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
