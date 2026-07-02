import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../habits/presentation/providers/habits_notifier.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../focus/presentation/providers/focus_notifier.dart';

class ProgressCard extends ConsumerWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch real tasks scheduled for today
    final todaysTasks = ref.watch(todaysTasksProvider);
    final completedTasks = ref.watch(completedTodayTasksProvider);
    final tasksCompleted = completedTasks.length;
    final totalTasks = todaysTasks.length;

    // Watch real habits scheduled for today
    final habits = ref.watch(todaysHabitsProvider);
    final completedHabits = ref.watch(completedHabitsProvider);
    final habitsCompleted = completedHabits.length;
    final totalHabits = habits.length;

    // Watch real focus sessions scheduled for today
    final todaysSessions = ref.watch(todaysFocusProvider);
    final focusMinutes = todaysSessions
        .where((s) => s.sessionType == 'focus' && s.completed)
        .map((s) => s.actualDurationMinutes)
        .fold(0, (a, b) => a + b);

    // Combined overall productivity percentage (tasks + habits)
    final totalItems = totalTasks + totalHabits;
    final completedItems = tasksCompleted + habitsCompleted;
    final combinedPercentage = totalItems > 0 ? completedItems / totalItems : 0.0;

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
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Row(
          children: [
            // Left: Combined Circular Progress Ring
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: combinedPercentage,
                    strokeWidth: 8,
                    backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
                    color: colorScheme.primary,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(combinedPercentage * 100).toInt()}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Progress',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: AppSizes.lg),

            // Right: Detailed Stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatRow(
                    context: context,
                    icon: Icons.checklist_rounded,
                    iconColor: colorScheme.primary,
                    label: 'Tasks',
                    value: '$tasksCompleted / $totalTasks',
                  ),
                  const SizedBox(height: AppSizes.sm),
                  _buildStatRow(
                    context: context,
                    icon: Icons.loop_rounded,
                    iconColor: Colors.orange,
                    label: 'Habits',
                    value: '$habitsCompleted / $totalHabits',
                  ),
                  const SizedBox(height: AppSizes.sm),
                  _buildStatRow(
                    context: context,
                    icon: Icons.timer_outlined,
                    iconColor: Colors.red,
                    label: 'Focus Time',
                    value: '${focusMinutes}m',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
