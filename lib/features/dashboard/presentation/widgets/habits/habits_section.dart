// lib/features/dashboard/presentation/widgets/habits/habits_section.dart
//
// Orynta 2.0 — Habits Section Component

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../providers/habits_providers.dart';
import 'habit_list_item.dart';
import 'habit_progress_card.dart';
import 'habits_empty_state.dart';
import 'habits_loading.dart';

class HabitsSection extends ConsumerWidget {
  const HabitsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitsControllerProvider);
    final displayedHabits = state.habits.take(4).toList();
    final remainingCount = state.habits.length - displayedHabits.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Header Row
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.repeat_rounded,
                    size: 20,
                    color: context.colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Habits',
                        style: context.typography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Text(
                        'Build consistency every day',
                        style: context.typography.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.push('/habits'),
                borderRadius: context.radius.borderRadiusSm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'View Habits',
                        style: context.typography.labelMedium.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: context.colors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Body Grid / Empty State / Loading
        if (state.isLoading)
          const HabitsLoading()
        else if (!state.hasHabits)
          const HabitsEmptyState()
        else ...[
          HabitProgressCard(state: state),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedHabits.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final habit = displayedHabits[index];
              return HabitListItem(
                habit: habit,
                onTap: () => context.push('/habits/${habit.id}'),
              );
            },
          ),
          if (remainingCount > 0) ...[
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => context.push('/habits'),
                child: Text(
                  '+$remainingCount More',
                  style: context.typography.labelMedium.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
