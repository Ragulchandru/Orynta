// lib/features/planner/presentation/widgets/task_card.dart
//
// Orynta 2.0 — Redesigned Premium Task Card Component

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/design_system.dart';
import '../../domain/entities/task_entity.dart';

class TaskCard extends StatefulWidget {
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
    this.onPriorityToggle,
  });

  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTapSelection;
  final VoidCallback onLongPress;
  final VoidCallback onTapDetail;
  final VoidCallback? onPriorityToggle;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final theme = context.appTheme;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surface,
        title: Text(
          'Delete Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
          ),
        ),
        content: Text(
          'Are you sure you want to permanently delete "${widget.task.title}"?',
          style: TextStyle(
            color: theme.isDark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: theme.error),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      widget.onDelete();
    }
  }

  Color _getPriorityColor(String priority, AppThemeData theme) {
    return switch (priority.toLowerCase()) {
      'high' => theme.error,
      'medium' => theme.warning,
      _ => theme.success,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final task = widget.task;
    final priorityColor = _getPriorityColor(task.priority, theme);

    final completedSubtasks = task.subtasks.where((s) => s.isCompleted).length;
    final totalSubtasks = task.subtasks.length;
    final hasSubtasks = totalSubtasks > 0;
    final hasLinkedNotes = task.linkedNoteIds.isNotEmpty || task.linkedNoteId != null;

    final formattedDate = task.dueDate != null ? DateFormat('MMM d').format(task.dueDate!) : null;
    final formattedTime = task.dueDate != null ? DateFormat('h:mm a').format(task.dueDate!) : null;

    return Dismissible(
      key: Key(task.id),
      direction: widget.isSelectionMode ? DismissDirection.none : DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Swipe Left -> Complete / Delete
          widget.onToggle();
          return false;
        } else if (direction == DismissDirection.startToEnd) {
          // Swipe Right -> Priority toggle
          if (widget.onPriorityToggle != null) {
            widget.onPriorityToggle!();
          }
          return false;
        }
        return false;
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: theme.warning.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.flag_rounded, color: theme.warning),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: theme.success.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.check_circle_rounded, color: theme.success),
      ),
      child: GestureDetector(
        onTapDown: (_) => _animController.forward(),
        onTapUp: (_) => _animController.reverse(),
        onTapCancel: () => _animController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? theme.primary.withValues(alpha: 0.12)
                  : (task.isCompleted ? theme.surfaceContainer.withValues(alpha: 0.5) : theme.surface),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected
                    ? theme.primary
                    : (task.isCompleted ? theme.outlineVariant.withValues(alpha: 0.3) : theme.outlineVariant),
                width: widget.isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (!task.isCompleted && !widget.isSelected)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: theme.isDark ? 0.3 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            child: InkWell(
              onTap: widget.isSelectionMode ? widget.onTapSelection : widget.onTapDetail,
              onLongPress: widget.onLongPress,
              borderRadius: BorderRadius.circular(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animated Completion Checkbox
                  ScaleOnPress(
                    onTap: widget.isSelectionMode ? widget.onTapSelection : widget.onToggle,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.isCompleted
                            ? theme.primary
                            : (widget.isSelected ? theme.primary : Colors.transparent),
                        border: Border.all(
                          color: task.isCompleted || widget.isSelected ? theme.primary : theme.outline,
                          width: 2,
                        ),
                      ),
                      child: task.isCompleted || widget.isSelected
                          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title, Subtasks, Badges
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: context.typography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: task.isCompleted
                                      ? (theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8))
                                      : (theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C)),
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                                child: Text(task.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Priority Indicator Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: priorityColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task.priority.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: priorityColor,
                                ),
                              ),
                            ),
                            if (!widget.isSelectionMode) ...[
                              const SizedBox(width: 4),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert_rounded, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                style: const ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onSelected: (val) {
                                  if (val == 'delete') {
                                    _confirmDelete(context);
                                  } else if (val == 'edit') {
                                    widget.onTapDetail();
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_rounded, size: 18),
                                        SizedBox(width: 8),
                                        Text('Edit Details'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline_rounded, size: 18, color: theme.error),
                                        const SizedBox(width: 8),
                                        Text('Delete Task', style: TextStyle(color: theme.error)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),

                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.typography.bodySmall.copyWith(
                              color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8),
                            ),
                          ),
                        ],

                        const SizedBox(height: 8),

                        // Badges Row (Due Date, Time, Category, Subtasks, Repeat, Reminder, Attachments, Linked Notes)
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (task.category.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  task.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primary,
                                  ),
                                ),
                              ),

                            if (formattedDate != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_today_rounded, size: 12, color: theme.secondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$formattedDate${formattedTime != null ? ' • $formattedTime' : ''}',
                                    style: TextStyle(fontSize: 11, color: theme.secondary, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),

                            if (hasSubtasks)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_box_outlined, size: 12, color: theme.secondary),
                                  const SizedBox(width: 3),
                                  Text(
                                    '$completedSubtasks/$totalSubtasks',
                                    style: TextStyle(fontSize: 11, color: theme.secondary),
                                  ),
                                ],
                              ),

                            if (task.recurrenceRule != null)
                              Icon(Icons.repeat_rounded, size: 13, color: theme.primary),

                            if (task.reminderMs != null)
                              Icon(Icons.notifications_active_outlined, size: 13, color: theme.warning),

                            if (task.attachments.isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.attach_file_rounded, size: 12, color: theme.secondary),
                                  Text('${task.attachments.length}', style: TextStyle(fontSize: 11, color: theme.secondary)),
                                ],
                              ),

                            if (hasLinkedNotes)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.link_rounded, size: 13, color: theme.primary),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Linked Note',
                                    style: TextStyle(fontSize: 11, color: theme.primary, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
