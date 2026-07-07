import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/reminder_offset.dart';
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
  int? _earlyReminderMinutes = 15;
  String? _repeatReminderInterval = 'never';

  DateTime? _dueDate;
  TimeOfDay? _dueTime;

  bool _isEditing = false;
  TaskEntity? _existingTask;

  static const List<int> _durationPresets = [15, 30, 45, 60, 90, 120];

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
        _earlyReminderMinutes = _existingTask!.earlyReminderMinutes;
        _repeatReminderInterval = _existingTask!.repeatReminderInterval ?? 'never';
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
        earlyReminderMinutes: _earlyReminderMinutes,
        repeatReminderInterval: _repeatReminderInterval,
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
        linkedNoteId: null,
        earlyReminderMinutes: _earlyReminderMinutes,
        repeatReminderInterval: _repeatReminderInterval,
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

    final timelineOptions = [
      {'value': 0, 'label': 'Morning', 'icon': Icons.wb_sunny_outlined, 'color': Colors.amber},
      {'value': 1, 'label': 'Afternoon', 'icon': Icons.wb_cloudy_outlined, 'color': Colors.orange},
      {'value': 2, 'label': 'Evening', 'icon': Icons.nights_stay_outlined, 'color': Colors.indigo},
      {'value': 3, 'label': 'Night', 'icon': Icons.bedtime_outlined, 'color': Colors.blueGrey},
    ];

    final priorityOptions = [
      {'value': 'low', 'label': 'Low', 'color': Colors.grey},
      {'value': 'medium', 'label': 'Medium', 'color': colorScheme.primary},
      {'value': 'high', 'label': 'High', 'color': Colors.red},
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _isEditing ? 'Edit Task' : 'Create Task',
          style: theme.textTheme.titleLarge?.copyWith(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _saveTask,
            icon: Icon(Icons.check_rounded, color: colorScheme.primary, size: 24),
            tooltip: 'Save Task',
          ),
          const SizedBox(width: AppSizes.xs),
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
                style: theme.textTheme.headlineSmall?.copyWith(
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
                minLines: 3,
                maxLines: 5,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Add description or notes...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.sm),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(AppSizes.md),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.description_outlined, color: colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              // Timeline Section Header
              Text(
                'TIMELINE SECTION',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSizes.sm),

              // Responsive Choice Chips for Timeline Section
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: timelineOptions.map((opt) {
                    final isSelected = _timelineSection == opt['value'];
                    final color = opt['color'] as Color;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSizes.sm),
                      child: FilterChip(
                        selected: isSelected,
                        showCheckmark: false,
                        avatar: Icon(
                          opt['icon'] as IconData,
                          size: 16,
                          color: isSelected ? colorScheme.onPrimary : color,
                        ),
                        label: Text(opt['label'] as String),
                        selectedColor: colorScheme.primary,
                        labelStyle: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                        ),
                        onSelected: (_) {
                          setState(() {
                            _timelineSection = opt['value'] as int;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              // Priority Selector
              Text(
                'PRIORITY LEVEL',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Row(
                children: priorityOptions.map((opt) {
                  final isSelected = _priority == opt['value'];
                  final color = opt['color'] as Color;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            opt['label'] as String,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : colorScheme.onSurface,
                            ),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: color,
                        onSelected: (_) {
                          setState(() {
                            _priority = opt['value'] as String;
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.xl),

              // Date and Time Pickers Row
              Text(
                'DUE DATE & TIME',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.sm),
                        ),
                      ),
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_today_rounded, size: 18),
                      label: Text(dateText),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.sm),
                        ),
                      ),
                      onPressed: _selectTime,
                      icon: const Icon(Icons.access_time_rounded, size: 18),
                      label: Text(timeText),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl),

              // Estimated Duration with Presets
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ESTIMATED DURATION',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: colorScheme.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_estimatedMinutes}m',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xs),
              Slider(
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
              const SizedBox(height: AppSizes.xs),

              // Presets row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _durationPresets.map((preset) {
                    final isSelected = _estimatedMinutes == preset;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSizes.xs),
                      child: ActionChip(
                        label: Text('${preset}m'),
                        backgroundColor: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerLow,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            _estimatedMinutes = preset;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              // Reminder Settings
              Text(
                'REMINDER SETTINGS',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              DropdownButtonFormField<int>(
                initialValue: _earlyReminderMinutes ?? 15,
                decoration: const InputDecoration(
                  labelText: 'Reminder Alert',
                  prefixIcon: Icon(Icons.notifications_active_rounded),
                ),
                items: ReminderOffset.values.map((offset) {
                  return DropdownMenuItem<int>(
                    value: offset.minutes,
                    child: Text(offset.label),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _earlyReminderMinutes = val;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<String>(
                initialValue: _repeatReminderInterval ?? 'never',
                decoration: const InputDecoration(
                  labelText: 'Repeat Reminder',
                  prefixIcon: Icon(Icons.snooze_rounded),
                ),
                items: const [
                  DropdownMenuItem(value: 'never', child: Text('Never')),
                  DropdownMenuItem(value: '5m', child: Text('Every 5 min')),
                  DropdownMenuItem(value: '10m', child: Text('Every 10 min')),
                  DropdownMenuItem(value: '15m', child: Text('Every 15 min')),
                  DropdownMenuItem(value: '30m', child: Text('Every 30 min')),
                  DropdownMenuItem(value: 'untilCompleted', child: Text('Until completed')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _repeatReminderInterval = val;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSizes.xl),

              // Linked Note Selector (Disabled placeholder)
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppSizes.sm),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.link_rounded, color: colorScheme.outline),
                  title: Text(
                    'Link Note',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.outline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Available in a future update',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.outline.withValues(alpha: 0.7),
                    ),
                  ),
                  trailing: Icon(Icons.lock_outline_rounded, size: 18, color: colorScheme.outline),
                  onTap: null,
                ),
              ),
              const SizedBox(height: AppSizes.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
