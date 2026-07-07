// lib/features/planner/presentation/screens/task_detail_screen.dart
//
// Orynta 2.0 — Premium Task Details & Editor Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/design_system.dart';
import '../../domain/entities/subtask_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/reminder_offset.dart';
import '../providers/categories_notifier.dart';
import '../providers/tasks_notifier.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({
    super.key,
    this.task,
    this.taskId,
  });

  final TaskEntity? task;
  final String? taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _notesController;
  late TextEditingController _subtaskInputController;

  late TaskEntity _workingTask;
  late String _priority;
  late String _category;
  late DateTime? _dueDate;
  late TimeOfDay? _dueTime;
  late String? _recurrenceRule;
  late int? _reminderMs;
  late int? _earlyReminderMinutes;
  late String? _repeatReminderInterval;
  late int _estimatedMinutes;
  late List<SubtaskEntity> _subtasks;
  late List<String> _linkedNoteIds;

  @override
  void initState() {
    super.initState();
    _workingTask = widget.task ??
        ref.read(tasksProvider).firstWhere(
              (item) => item.id == widget.taskId,
              orElse: () => TaskEntity(
                id: widget.taskId ?? DateTime.now().millisecondsSinceEpoch.toString(),
                title: 'New Task',
                description: '',
                priority: 'medium',
                dueDate: DateTime.now(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                isCompleted: false,
                timelineSection: 0,
                estimatedMinutes: 15,
                tagIds: const [],
              ),
            );

    final t = _workingTask;
    _titleController = TextEditingController(text: t.title);
    _descController = TextEditingController(text: t.description);
    _notesController = TextEditingController(text: t.notes ?? '');
    _subtaskInputController = TextEditingController();

    _priority = t.priority;
    _category = t.category;
    _dueDate = t.dueDate;
    _dueTime = t.dueDate != null ? TimeOfDay.fromDateTime(t.dueDate!) : null;
    _recurrenceRule = t.recurrenceRule;
    _reminderMs = t.reminderMs;
    _earlyReminderMinutes = t.earlyReminderMinutes;
    _repeatReminderInterval = t.repeatReminderInterval ?? 'never';
    _estimatedMinutes = t.estimatedMinutes;
    _subtasks = List.from(t.subtasks);
    _linkedNoteIds = List.from(t.linkedNoteIds.isNotEmpty
        ? t.linkedNoteIds
        : (t.linkedNoteId != null ? [t.linkedNoteId!] : []),);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _notesController.dispose();
    _subtaskInputController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_titleController.text.trim().isEmpty) return;

    DateTime? finalDueDate = _dueDate;
    if (_dueDate != null && _dueTime != null) {
      finalDueDate = DateTime(
        _dueDate!.year,
        _dueDate!.month,
        _dueDate!.day,
        _dueTime!.hour,
        _dueTime!.minute,
      );
    }

    final updated = _workingTask.copyWith(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      priority: _priority,
      category: _category,
      dueDate: finalDueDate,
      recurrenceRule: _recurrenceRule,
      reminderMs: _reminderMs,
      earlyReminderMinutes: _earlyReminderMinutes,
      repeatReminderInterval: _repeatReminderInterval,
      estimatedMinutes: _estimatedMinutes,
      subtasks: _subtasks,
      linkedNoteIds: _linkedNoteIds,
      updatedAt: DateTime.now(),
    );

    final exists = ref.read(tasksProvider).any((item) => item.id == updated.id);
    if (exists) {
      await ref.read(tasksNotifierProvider.notifier).updateTask(updated);
    } else {
      await ref.read(tasksNotifierProvider.notifier).addTask(updated);
    }

    if (mounted) context.pop();
  }

  void _addSubtask() {
    final text = _subtaskInputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _subtasks.add(
        SubtaskEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: text,
          isCompleted: false,
        ),
      );
      _subtaskInputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        elevation: 0,
        title: Text(
          'Task Details',
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _workingTask.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: _workingTask.isFavorite ? Colors.amber : theme.outline,
            ),
            onPressed: () {
              ref.read(tasksNotifierProvider.notifier).toggleFavorite(_workingTask.id);
              setState(() {
                _workingTask = _workingTask.copyWith(isFavorite: !_workingTask.isFavorite);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          physics: const BouncingScrollPhysics(),
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              style: context.typography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
              ),
              decoration: const InputDecoration(
                hintText: 'Task Title',
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 8),

            // Description Input
            TextField(
              controller: _descController,
              maxLines: 2,
              style: context.typography.bodyMedium.copyWith(
                color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
              ),
              decoration: const InputDecoration(
                hintText: 'Add description...',
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),

            // Category & Priority Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category', style: context.typography.labelSmall),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: categories
                            .map((c) => DropdownMenuItem(value: c.name, child: Text(c.name)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _category = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Priority', style: context.typography.labelSmall),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        initialValue: _priority,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['high', 'medium', 'low']
                            .map((p) => DropdownMenuItem(value: p, child: Text(p.toUpperCase())))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _priority = val);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Due Date & Time Pickers
            ListTile(
              leading: Icon(Icons.calendar_month_rounded, color: theme.primary),
              title: const Text('Due Date & Time'),
              subtitle: Text(
                _dueDate != null
                    ? '${DateFormat('EEE, MMM d, yyyy').format(_dueDate!)}${_dueTime != null ? ' at ${_dueTime!.format(context)}' : ''}'
                    : 'No due date set',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_calendar_rounded),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    if (!context.mounted) return;
                    final tod = await showTimePicker(
                      context: context,
                      initialTime: _dueTime ?? TimeOfDay.now(),
                    );
                    setState(() {
                      _dueDate = picked;
                      _dueTime = tod;
                    });
                  }
                },
              ),
            ),

            // Recurrence Rule
            ListTile(
              leading: Icon(Icons.repeat_rounded, color: theme.secondary),
              title: const Text('Repeat'),
              subtitle: Text(_recurrenceRule ?? 'Does not repeat'),
              trailing: DropdownButton<String?>(
                value: _recurrenceRule,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Never')),
                  DropdownMenuItem(value: 'DAILY', child: Text('Daily')),
                  DropdownMenuItem(value: 'WEEKDAYS', child: Text('Weekdays (Mon-Fri)')),
                  DropdownMenuItem(value: 'WEEKLY', child: Text('Weekly')),
                  DropdownMenuItem(value: 'MONTHLY', child: Text('Monthly')),
                  DropdownMenuItem(value: 'YEARLY', child: Text('Yearly')),
                ],
                onChanged: (val) => setState(() => _recurrenceRule = val),
              ),
            ),

            // Reminder Offset dropdown
            ListTile(
              leading: Icon(Icons.notifications_active_rounded, color: theme.primary),
              title: const Text('Reminder Alert'),
              subtitle: Text(ReminderOffset.fromMinutes(_earlyReminderMinutes).label),
              trailing: DropdownButton<int>(
                value: _earlyReminderMinutes ?? 15,
                underline: const SizedBox(),
                items: ReminderOffset.values.map((offset) {
                  return DropdownMenuItem<int>(
                    value: offset.minutes,
                    child: Text(offset.label),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _earlyReminderMinutes = val);
                },
              ),
            ),

            // Repeat Alert dropdown
            ListTile(
              leading: Icon(Icons.snooze_rounded, color: theme.secondary),
              title: const Text('Repeat Reminder'),
              subtitle: Text(_getRepeatAlertLabel(_repeatReminderInterval)),
              trailing: DropdownButton<String>(
                value: _repeatReminderInterval ?? 'never',
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'never', child: Text('Never')),
                  DropdownMenuItem(value: '5m', child: Text('Every 5 min')),
                  DropdownMenuItem(value: '10m', child: Text('Every 10 min')),
                  DropdownMenuItem(value: '15m', child: Text('Every 15 min')),
                  DropdownMenuItem(value: '30m', child: Text('Every 30 min')),
                  DropdownMenuItem(value: 'untilCompleted', child: Text('Until completed')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _repeatReminderInterval = val);
                },
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),

            // Checklist / Subtasks Section
            Text('Checklist', style: context.typography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._subtasks.asMap().entries.map((entry) {
              final idx = entry.key;
              final sub = entry.value;
              return ListTile(
                leading: Checkbox(
                  value: sub.isCompleted,
                  onChanged: (val) {
                    setState(() {
                      _subtasks[idx] = sub.copyWith(isCompleted: val ?? false);
                    });
                  },
                ),
                title: Text(
                  sub.title,
                  style: TextStyle(
                    decoration: sub.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () {
                    setState(() => _subtasks.removeAt(idx));
                  },
                ),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subtaskInputController,
                    decoration: const InputDecoration(
                      hintText: 'Add a subtask...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: (_) => _addSubtask(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline_rounded, color: theme.primary),
                  onPressed: _addSubtask,
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),

            // Notes Section
            Text('Task Notes', style: context.typography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write notes or markdown text...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 24),
            // Linked Notes Section
            if (_linkedNoteIds.isNotEmpty) ...[
              Text('Linked Orynta Notes', style: context.typography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._linkedNoteIds.map((noteId) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.note_alt_rounded, color: theme.primary),
                    title: Text('Note ID: $noteId'),
                    trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                    onTap: () {
                      context.push('/notes/edit/$noteId');
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_workingTask.isArchived)
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(tasksNotifierProvider.notifier).restoreTask(_workingTask.id);
                      if (!context.mounted) return;
                      context.pop();
                    },
                    icon: const Icon(Icons.settings_backup_restore_rounded),
                    label: const Text('Restore'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.success,
                      side: BorderSide(color: theme.success),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(tasksNotifierProvider.notifier).archiveTask(_workingTask.id);
                      if (!context.mounted) return;
                      context.pop();
                    },
                    icon: const Icon(Icons.archive_outlined),
                    label: const Text('Archive'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.secondary,
                      side: BorderSide(color: theme.secondary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: theme.surface,
                        title: Text('Delete Task', style: TextStyle(color: theme.isDark ? Colors.white : Colors.black)),
                        content: Text('Are you sure you want to permanently delete this task?', style: TextStyle(color: theme.secondary)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(foregroundColor: theme.error),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (!context.mounted) return;
                    if (confirm == true) {
                      await ref.read(tasksNotifierProvider.notifier).deleteTask(_workingTask.id);
                      if (!context.mounted) return;
                      context.pop();
                    }
                  },
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.error,
                    side: BorderSide(color: theme.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getRepeatAlertLabel(String? val) {
    switch (val) {
      case '5m':
        return 'Every 5 min';
      case '10m':
        return 'Every 10 min';
      case '15m':
        return 'Every 15 min';
      case '30m':
        return 'Every 30 min';
      case 'untilCompleted':
        return 'Until completed';
      default:
        return 'Never';
    }
  }
}
