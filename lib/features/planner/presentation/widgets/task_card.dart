import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTapSelection,
    required this.onLongPress,
    required this.onTapDetail,
  });

  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTapSelection;
  final VoidCallback onLongPress;
  final VoidCallback onTapDetail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final priorityColor = _getPriorityColor(task.priority);
    final formattedTime = task.dueDate != null ? DateFormat('h:mm a').format(task.dueDate!) : null;

    final cardBorderColor = isSelected
        ? colorScheme.primary
        : colorScheme.outlineVariant.withValues(alpha: 0.3);

    return Dismissible(
      key: Key(task.id),
      direction: isSelectionMode ? DismissDirection.none : DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.lg),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(AppSizes.md),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: colorScheme.onErrorContainer,
        ),
      ),
      child: Card(
        elevation: isSelected ? 2 : 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.md),
          side: BorderSide(
            color: cardBorderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        color: isSelected
            ? colorScheme.primaryContainer.withValues(alpha: 0.2)
            : (task.isCompleted
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                : colorScheme.surface),
        child: InkWell(
          onTap: isSelectionMode ? onTapSelection : onTapDetail,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppSizes.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.xs,
            ),
            child: Row(
              children: [
                // Selection or Completion Checkbox
                Checkbox(
                  value: isSelectionMode ? isSelected : task.isCompleted,
                  onChanged: (_) {
                    if (isSelectionMode) {
                      onTapSelection();
                    } else {
                      onToggle();
                    }
                  },
                  activeColor: isSelectionMode ? colorScheme.primary : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: AppSizes.xs),

                // Priority Dot
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),

                // Title and metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: (!isSelectionMode && task.isCompleted) ? TextDecoration.lineThrough : null,
                          color: (!isSelectionMode && task.isCompleted)
                              ? colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
                              : colorScheme.onSurface,
                        ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          task.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.sm),

                // Metadata Column (Due Time & Estimated time)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (formattedTime != null)
                      Text(
                        formattedTime,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (task.estimatedMinutes > 0) ...[
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.hourglass_empty_rounded,
                            size: 10,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${task.estimatedMinutes}m',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: AppSizes.xs),
              ],
            ),
          ),
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
