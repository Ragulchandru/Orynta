import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/tasks_notifier.dart';
import '../../../focus/presentation/providers/timer_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch the full task list to get the specific task
    final tasks = ref.watch(tasksProvider);
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);

    if (taskIndex == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Details')),
        body: const Center(
          child: Text('Task not found.'),
        ),
      );
    }

    final task = tasks[taskIndex];
    final priorityColor = _getPriorityColor(task.priority);
    final formattedDueDate = task.dueDate != null
        ? DateFormat('EEEE, MMMM d, yyyy - h:mm a').format(task.dueDate!)
        : 'No due date';

    final createdDate = DateFormat('MMMM d, yyyy - h:mm a').format(task.createdAt);
    final updatedDate = DateFormat('MMMM d, yyyy - h:mm a').format(task.updatedAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Delete Task',
            onPressed: () {
              _confirmDelete(context, ref);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.lg),
          children: [
            // Status checkbox and Title Card
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.md),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              color: task.isCompleted
                                  ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                                  : colorScheme.onSurface,
                            ),
                          ),
                          if (task.description.isNotEmpty) ...[
                            const SizedBox(height: AppSizes.sm),
                            Text(
                              task.description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Metadata sections list
            _buildMetaRow(
              context: context,
              icon: Icons.priority_high_rounded,
              iconColor: priorityColor,
              label: 'Priority',
              value: task.priority.toUpperCase(),
            ),
            const Divider(),
            _buildMetaRow(
              context: context,
              icon: Icons.wb_sunny_outlined,
              iconColor: colorScheme.primary,
              label: 'Timeline Section',
              value: _getSectionName(task.timelineSection),
            ),
            const Divider(),
            _buildMetaRow(
              context: context,
              icon: Icons.calendar_today_rounded,
              iconColor: colorScheme.secondary,
              label: 'Due Date',
              value: formattedDueDate,
            ),
            const Divider(),
            _buildMetaRow(
              context: context,
              icon: Icons.timer_outlined,
              iconColor: Colors.red,
              label: 'Estimated Minutes',
              value: task.estimatedMinutes > 0 ? '${task.estimatedMinutes}m' : 'None',
            ),
            const Divider(),
            
            // Linked Note (Placeholder)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.link_rounded, color: colorScheme.outline),
              title: Text(
                'Linked Note',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
              subtitle: Text(
                'No linked note (Coming soon)',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline.withValues(alpha: 0.6),
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            const Divider(),
            
            if (!task.isCompleted) ...[
              const SizedBox(height: AppSizes.sm),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () {
                    ref.read(timerProvider.notifier).selectTask(task.id);
                    ref.read(timerProvider.notifier).selectHabit(null);
                    context.push('/focus');
                  },
                  icon: const Icon(Icons.alarm_on_rounded),
                  label: const Text('Start Focus Session'),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              const Divider(),
            ],

            const SizedBox(height: AppSizes.md),

            // Auditing info (Created & Updated stamps)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created: $createdDate',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.outline.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last Updated: $updatedDate',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.outline.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to task editor screen
          context.push('/tasks/$taskId/edit');
        },
        child: const Icon(Icons.edit_rounded),
      ),
    );
  }

  Widget _buildMetaRow({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm, horizontal: AppSizes.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: AppSizes.sm),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getSectionName(int section) {
    return switch (section) {
      0 => 'Morning',
      1 => 'Afternoon',
      2 => 'Evening',
      3 => 'Night',
      _ => 'Unscheduled',
    };
  }

  Color _getPriorityColor(String priority) {
    return switch (priority.toLowerCase()) {
      'high' => Colors.red,
      'medium' => Colors.orange,
      _ => Colors.blueGrey,
    };
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(tasksProvider.notifier).deleteTask(taskId);
                Navigator.of(ctx).pop(); // Dismiss dialog
                context.pop(); // Pop details screen back to planner
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
