import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../habits/presentation/providers/habits_notifier.dart';

class HabitCard extends ConsumerWidget {
  const HabitCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch live habit values from Riverpod
    final habits = ref.watch(todaysHabitsProvider);
    final completedHabits = ref.watch(completedHabitsProvider);
    final streak = ref.watch(activeStreakProvider);

    final completedCount = completedHabits.length;
    final totalCount = habits.length;
    final completionRatio = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: () => context.push('/habits'),
        borderRadius: BorderRadius.circular(AppSizes.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title and active streak
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Habits',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 20),
                      const SizedBox(width: 2),
                      Text(
                        '$streak Days',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xs),

              // Progress Text Summary
              Text(
                totalCount > 0
                    ? '$completedCount of $totalCount habits completed today (${(completionRatio * 100).toInt()}%)'
                    : 'No habits tracked today.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // List of Habits Checklist
              if (habits.isEmpty)
                _buildEmptyState(context)
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: habits.length.clamp(0, 4), // Show up to 4 habits in Dashboard preview
                  separatorBuilder: (_, __) => const SizedBox(height: AppSizes.xs),
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    final isDone = habit.completedToday;
                    final habitColor = Color(habit.color);

                    return InkWell(
                      onTap: () {
                        // Prevent increments if already done
                        if (isDone) {
                          ref.read(habitsProvider.notifier).decrementHabit(habit.id);
                        } else {
                          ref.read(habitsProvider.notifier).incrementHabit(habit.id);
                        }
                      },
                      borderRadius: BorderRadius.circular(AppSizes.sm),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: AppSizes.xs),
                        child: Row(
                          children: [
                            Icon(
                              isDone
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: isDone ? Colors.green : habitColor,
                              size: 20,
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: Text(
                                habit.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: isDone
                                      ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                                      : colorScheme.onSurface,
                                  decoration: isDone ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                            if (habit.targetCount > 1) ...[
                              const SizedBox(width: AppSizes.xs),
                              Text(
                                '${habit.currentCount}/${habit.targetCount}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        children: [
          const SizedBox(height: AppSizes.sm),
          Icon(Icons.spa_outlined, color: colorScheme.outline, size: 28),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Track your first daily routine',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          ElevatedButton.icon(
            onPressed: () => context.push('/habits'),
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Setup Habits', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
