import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';

class TasksCard extends ConsumerWidget {
  const TasksCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch real tasks scheduled for today
    final todaysTasks = ref.watch(todaysTasksProvider);
    final displayedTasks = todaysTasks.take(5).toList();

    final completedCount = todaysTasks.where((t) => t.isCompleted).length;
    final totalCount = todaysTasks.length;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Tasks",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Go to Planner tab
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
            const SizedBox(height: AppSizes.sm),
            if (displayedTasks.isEmpty)
              _buildEmptyState(theme)
            else
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
                          // Checkbox
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
                          
                          // Priority Tag
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: priorityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),

                          // Title
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
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
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
              'No tasks scheduled today',
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
