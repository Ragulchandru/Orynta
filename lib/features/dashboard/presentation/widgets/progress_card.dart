import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';

class ProgressCard extends ConsumerWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch real tasks scheduled for today and completion rates
    final todaysTasks = ref.watch(todaysTasksProvider);
    final completedTasks = ref.watch(completedTodayTasksProvider);
    final tasksCompleted = completedTasks.length;
    final totalTasks = todaysTasks.length;

    // Habits mock data for Phase 2/3/4 (since Habits is in a future phase)
    const habitsCompleted = 3;
    const totalHabits = 4;
    const focusMinutes = 45;

    // Watch dynamic productivity percentage from computed provider
    final productivityPercentage = ref.watch(completionRateProvider);

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
            // Left: Circular Progress Ring
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: productivityPercentage,
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
                      '${(productivityPercentage * 100).toInt()}%',
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
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        const SizedBox(width: AppSizes.sm),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
