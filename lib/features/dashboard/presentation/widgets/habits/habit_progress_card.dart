// lib/features/dashboard/presentation/widgets/habits/habit_progress_card.dart
//
// Orynta 2.0 — Habit Progress Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/habits_state.dart';
import 'habit_progress_painter.dart';

class HabitProgressCard extends StatelessWidget {
  const HabitProgressCard({
    super.key,
    required this.state,
  });

  final HabitsState state;

  @override
  Widget build(BuildContext context) {
    final trackColor = context.colors.outlineVariant.withValues(alpha: 0.5);
    final progressColor = context.colors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: context.radius.borderRadiusLg,
        border: Border.all(color: context.colors.outlineVariant),
        boxShadow: context.shadows.small,
      ),
      child: Row(
        children: [
          // Circular Progress Indicator
          SizedBox(
            width: 64,
            height: 64,
            child: CustomPaint(
              painter: HabitProgressPainter(
                trackColor: trackColor,
                progressColor: progressColor,
                progress: state.completionPercentage,
                strokeWidth: 6.0,
              ),
              child: Center(
                child: Text(
                  '${state.percentageRatio}%',
                  style: context.typography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Completion Labels & Motivational Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${state.completedTodayCount} of ${state.totalTodayCount} Habits",
                  style: context.typography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  state.motivationalMessage,
                  style: context.typography.bodySmall.copyWith(
                    color: context.colors.textSecondary,
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
