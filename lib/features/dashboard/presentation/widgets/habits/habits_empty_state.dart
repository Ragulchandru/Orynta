// lib/features/dashboard/presentation/widgets/habits/habits_empty_state.dart
//
// Orynta 2.0 — Habits Empty State Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class HabitsEmptyState extends StatelessWidget {
  const HabitsEmptyState({super.key});

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
              Icons.repeat_rounded,
              size: 28,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No habits yet.',
            style: context.typography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Start building small daily routines.',
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
