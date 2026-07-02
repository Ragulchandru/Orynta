import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/tasks_notifier.dart';

class TaskMultiselectBar extends ConsumerWidget {
  const TaskMultiselectBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedIds = ref.watch(selectedTasksProvider);
    if (selectedIds.isEmpty) return const SizedBox.shrink();

    final selectedList = selectedIds.toList();

    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Card(
        elevation: 6,
        color: colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.md),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 8.0),
          child: Row(
            children: [
              // Count details
              Text(
                '${selectedList.length} Selected',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

              // Complete Action
              IconButton(
                icon: const Icon(Icons.check_circle_outline_rounded),
                tooltip: 'Complete All',
                color: colorScheme.onSecondaryContainer,
                onPressed: () {
                  ref.read(tasksProvider.notifier).bulkCompleteTasks(selectedList, true);
                  ref.read(selectedTasksProvider.notifier).clearSelection();
                },
              ),

              // Move timeline section
              PopupMenuButton<int>(
                icon: const Icon(Icons.drive_file_move_outlined),
                tooltip: 'Move Timeline Section',
                color: colorScheme.surface,
                onSelected: (section) {
                  ref.read(tasksProvider.notifier).bulkMoveTimelineSection(selectedList, section);
                  ref.read(selectedTasksProvider.notifier).clearSelection();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 0, child: Text('Move to Morning')),
                  PopupMenuItem(value: 1, child: Text('Move to Afternoon')),
                  PopupMenuItem(value: 2, child: Text('Move to Evening')),
                  PopupMenuItem(value: 3, child: Text('Move to Night')),
                ],
              ),

              // Delete Action
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Delete Selected',
                color: colorScheme.error,
                onPressed: () {
                  _confirmBulkDelete(context, ref, selectedList);
                },
              ),

              // Close / Cancel Action
              IconButton(
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Clear Selection',
                color: colorScheme.onSecondaryContainer,
                onPressed: () {
                  ref.read(selectedTasksProvider.notifier).clearSelection();
                },
              ),
            ],
          ),
        ),
      ).animate().slideY(
            begin: 1.0,
            end: 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          ),
    );
  }

  void _confirmBulkDelete(BuildContext context, WidgetRef ref, List<String> ids) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Delete Tasks'),
          content: Text('Are you sure you want to delete ${ids.length} selected tasks? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(tasksProvider.notifier).bulkDeleteTasks(ids);
                ref.read(selectedTasksProvider.notifier).clearSelection();
                Navigator.of(ctx).pop();
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
