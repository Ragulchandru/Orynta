// lib/features/dashboard/presentation/widgets/analytics/analytics_empty_state.dart
//
// Orynta 2.0 — Analytics Empty State Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class AnalyticsEmptyState extends StatelessWidget {
  const AnalyticsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: context.radius.borderRadiusLg,
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: 0.6),
        ),
        boxShadow: context.shadows.small,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.insights_rounded,
              size: 28,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your insights will appear as you build momentum.',
            textAlign: TextAlign.center,
            style: context.typography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Start completing tasks and focus sessions to unlock detailed analytics.',
            textAlign: TextAlign.center,
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
