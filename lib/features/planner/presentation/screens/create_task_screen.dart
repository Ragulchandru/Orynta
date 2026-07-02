import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/tasks_notifier.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  const CreateTaskScreen({
    super.key,
    this.taskId,
  });

  final String? taskId;

  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _priority = 'medium'; // high, medium, low
  int _timelineSection = 0;    // 0 = Morning, 1 = Afternoon, 2 = Evening, 3 = Night
  int _estimatedMinutes = 30;

  DateTime? _dueDate;
  TimeOfDay? _dueTime;

  bool _isEditing = false;
  TaskEntity? _existingTask;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _isEditing = true;
      final tasks = ref.read(tasksProvider);
      final index = tasks.indexWhere((t) => t.id == widget.taskId);
      if (index != -1) {
        _existingTask = tasks[index];
        _titleController.text = _existingTask!.title;
        _descriptionController.text = _existingTask!.description;
        _priority = _existingTask!.priority;
        _timelineSection = _existingTask!.timelineSection;
        _estimatedMinutes = _existingTask!.estimatedMinutes;
        if (_existingTask!.dueDate != null) {
          _dueDate = _existingTask!.dueDate;
          _dueTime = TimeOfDay.fromDateTime(_existingTask!.dueDate!);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _dueTime = picked;
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    // Combine date and time
    DateTime? combinedDue;
    if (_dueDate != null) {
      final time = _dueTime ?? const TimeOfDay(hour: 12, minute: 0);
      combinedDue = DateTime(
        _dueDate!.year,
        _dueDate!.month,
        _dueDate!.day,
        time.hour,
        time.minute,
      );
    }

    if (_isEditing && _existingTask != null) {
      final task = _existingTask!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        dueDate: combinedDue,
        updatedAt: DateTime.now(),
        timelineSection: _timelineSection,
        estimatedMinutes: _estimatedMinutes,
      );
      ref.read(tasksProvider.notifier).updateTask(task);
    } else {
      final task = TaskEntity(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        dueDate: combinedDue,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isCompleted: false,
        timelineSection: _timelineSection,
        estimatedMinutes: _estimatedMinutes,
        tagIds: const [],
        linkedNoteId: null, // Placeholder for linked note
      );
      ref.read(tasksProvider.notifier).addTask(task);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dateText = _dueDate == null ? 'Set Due Date' : DateFormat('yMMMd').format(_dueDate!);
    final timeText = _dueTime == null ? 'Set Time' : _dueTime!.format(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Task' : 'Create Task',
          style: const TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _saveTask,
            icon: const Icon(Icons.check_rounded),
            tooltip: 'Save Task',
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.lg),
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Task title is required';
                  }
                  return null;
                },
              ),
              const Divider(),
              const SizedBox(height: AppSizes.md),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  icon: Icon(Icons.description_outlined, color: colorScheme.primary),
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // Timeline Section
              Text(
                'Timeline',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Morning'), icon: Icon(Icons.wb_sunny_outlined, size: 14)),
                  ButtonSegment(value: 1, label: Text('After'), icon: Icon(Icons.wb_cloudy_outlined, size: 14)),
                  ButtonSegment(value: 2, label: Text('Evening'), icon: Icon(Icons.nights_stay_outlined, size: 14)),
                  ButtonSegment(value: 3, label: Text('Night'), icon: Icon(Icons.bedtime_outlined, size: 14)),
                ],
                selected: {_timelineSection},
                onSelectionChanged: (selection) {
                  setState(() {
                    _timelineSection = selection.first;
                  });
                },
              ),
              const SizedBox(height: AppSizes.lg),

              // Priority Selector
              Text(
                'Priority',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'low', label: Text('Low')),
                  ButtonSegment(value: 'medium', label: Text('Medium')),
                  ButtonSegment(value: 'high', label: Text('High')),
                ],
                selected: {_priority},
                onSelectionChanged: (selection) {
                  setState(() {
                    _priority = selection.first;
                  });
                },
              ),
              const SizedBox(height: AppSizes.lg),

              // Date and Time picker row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_today_rounded, size: 16),
                      label: Text(dateText),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectTime,
                      icon: const Icon(Icons.access_time_rounded, size: 16),
                      label: Text(timeText),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),

              // Estimated time
              Text(
                'Estimated Minutes',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: 180,
                      divisions: 12,
                      value: _estimatedMinutes.toDouble(),
                      onChanged: (val) {
                        setState(() {
                          _estimatedMinutes = val.toInt();
                        });
                      },
                    ),
                  ),
                  Text(
                    '${_estimatedMinutes}m',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),

              // Linked Note Selector (Placeholder)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.link_rounded, color: colorScheme.outline),
                title: Text(
                  'Link Note',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
                subtitle: Text(
                  'Coming soon in a future phase',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline.withValues(alpha: 0.6),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: null, // Disabled selector for Phase 3
              ),
            ],
          ),
        ),
      ),
    );
  }
}
