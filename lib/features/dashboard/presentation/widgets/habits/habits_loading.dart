// lib/features/dashboard/presentation/widgets/habits/habits_loading.dart
//
// Orynta 2.0 — Habits Loading Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class HabitsLoading extends StatelessWidget {
  const HabitsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.colors.outlineVariant.withValues(alpha: 0.3);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: context.radius.borderRadiusLg,
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: baseColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 140,
                  height: 18,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: context.radius.borderRadiusSm,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: context.radius.borderRadiusSm,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
