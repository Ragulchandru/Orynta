import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';

class TasksCard extends ConsumerWidget {
  const TasksCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch selected date tasks for the calendar preview
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedTasks = ref.watch(selectedDateTasksProvider);
    final completedTasks = ref.watch(selectedDateCompletedTasksProvider);

    final completedCount = completedTasks.length;
    final totalCount = selectedTasks.length;

    // Watch overdue and upcoming items
    final overdueTasks = ref.watch(overdueTasksProvider);
    final nextUpcomingTask = ref.watch(nextUpcomingTaskProvider);

    final displayedTasks = selectedTasks.take(5).toList();

    // Generate dynamic card header title based on calendar selected date
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
    final headerTitle = isToday ? "Today's Tasks" : "Tasks for ${DateFormat('MMM d').format(selectedDate)}";

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title and Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  headerTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/planner');
                  },
                  child: Text(
                    totalCount > 0 ? '$completedCount / $totalCount' : 'View Planner',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),

            // 1. Overdue warning banner (always displays active overdue tasks count)
            if (overdueTasks.isNotEmpty) ...[
              InkWell(
                onTap: () => context.go('/planner'),
                borderRadius: BorderRadius.circular(AppSizes.sm),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(AppSizes.sm),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 16, color: colorScheme.error),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Text(
                          '${overdueTasks.length} task(s) overdue!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onErrorContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, size: 16, color: colorScheme.error),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),
            ],

            // 2. Checklist of Selected Date's Tasks
            if (displayedTasks.isEmpty)
              _buildEmptyState(theme, isToday, selectedDate)
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: displayedTasks.length,
                separatorBuilder: (_, __) => Divider(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final task = displayedTasks[index];
                  final priorityColor = _getPriorityColor(task.priority);
                  final formattedTime = task.dueDate != null ? DateFormat('h:mm a').format(task.dueDate!) : null;

                  return InkWell(
                    onTap: () {
                      ref.read(tasksProvider.notifier).toggleTaskCompletion(task.id);
                    },
                    borderRadius: BorderRadius.circular(AppSizes.sm),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
                      child: Row(
                        children: [
                          Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) {
                              ref.read(tasksProvider.notifier).toggleTaskCompletion(task.id);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: AppSizes.xs),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: priorityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                    color: task.isCompleted
                                        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                                        : colorScheme.onSurface,
                                  ),
                                ),
                                if (formattedTime != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    formattedTime,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],

            // 3. Next Up Banner
            if (nextUpcomingTask != null) ...[
              const SizedBox(height: AppSizes.md),
              const Divider(),
              const SizedBox(height: AppSizes.sm),
              InkWell(
                onTap: () => context.push('/tasks/${nextUpcomingTask.id}'),
                borderRadius: BorderRadius.circular(AppSizes.sm),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSizes.sm),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.next_plan_outlined, size: 16, color: colorScheme.primary),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next Up: ${nextUpcomingTask.title}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: colorScheme.primary,
                              ),
                            ),
                            if (nextUpcomingTask.dueDate != null)
                              Text(
                                DateFormat('MMM d, h:mm a').format(nextUpcomingTask.dueDate!),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, size: 16, color: colorScheme.primary),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isToday, DateTime date) {
    final dateStr = isToday ? 'today' : 'on ${DateFormat('MMMM d').format(date)}';
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
        child: Column(
          children: [
            Icon(
              Icons.checklist_rounded,
              size: 40,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'No tasks scheduled $dateStr',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Tap the center + or Action to add a task.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    return switch (priority.toLowerCase()) {
      'high' => Colors.red,
      'medium' => Colors.orange,
      _ => Colors.blueGrey,
    };
  }
}
