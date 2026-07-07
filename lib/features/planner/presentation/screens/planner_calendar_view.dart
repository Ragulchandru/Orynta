// lib/features/planner/presentation/screens/planner_calendar_view.dart
//
// Orynta 2.0 — Premium Planner Calendar View System

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/design_system.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/models/category_model.dart';
import '../providers/categories_notifier.dart';
import '../providers/tasks_notifier.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

enum CalendarMode { month, week, day, agenda }

class PlannerCalendarView extends ConsumerStatefulWidget {
  const PlannerCalendarView({super.key});

  @override
  ConsumerState<PlannerCalendarView> createState() => _PlannerCalendarViewState();
}

class _PlannerCalendarViewState extends ConsumerState<PlannerCalendarView> {
  CalendarMode _mode = CalendarMode.month;
  DateTime _focusedDate = DateTime.now();

  void _createNewTaskAtDate(DateTime date) {
    final now = DateTime.now();
    final defaultCat = ref.read(categoriesProvider.notifier).defaultCategoryId;
    final newTask = TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Task',
      description: '',
      priority: 'medium',
      dueDate: DateTime(date.year, date.month, date.day, now.hour, now.minute),
      createdAt: now,
      updatedAt: now,
      isCompleted: false,
      timelineSection: 0,
      estimatedMinutes: 15,
      tagIds: const [],
      category: defaultCat,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: newTask)),
    );
  }

  void _openTaskDetail(TaskEntity task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final tasks = ref.watch(tasksProvider);

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        elevation: 0,
        title: Text(
          DateFormat('MMMM yyyy').format(_focusedDate),
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Today Button
          IconButton(
            icon: const Icon(Icons.today_rounded),
            tooltip: 'Today',
            onPressed: () {
              setState(() {
                _focusedDate = DateTime.now();
              });
            },
          ),
          PopupMenuButton<CalendarMode>(
            initialValue: _mode,
            onSelected: (mode) => setState(() => _mode = mode),
            icon: const Icon(Icons.calendar_view_month_rounded),
            itemBuilder: (context) => [
              const PopupMenuItem(value: CalendarMode.month, child: Text('Month View')),
              const PopupMenuItem(value: CalendarMode.week, child: Text('Week View')),
              const PopupMenuItem(value: CalendarMode.day, child: Text('Day View')),
              const PopupMenuItem(value: CalendarMode.agenda, child: Text('Agenda View')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Mode Segmented Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SegmentedButton<CalendarMode>(
                segments: const [
                  ButtonSegment(value: CalendarMode.month, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Month', maxLines: 1))),
                  ButtonSegment(value: CalendarMode.week, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Week', maxLines: 1))),
                  ButtonSegment(value: CalendarMode.day, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Day', maxLines: 1))),
                  ButtonSegment(value: CalendarMode.agenda, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Agenda', maxLines: 1))),
                ],
                selected: {_mode},
                onSelectionChanged: (set) => setState(() => _mode = set.first),
              ),
            ),

            Expanded(
              child: switch (_mode) {
                CalendarMode.month => _buildMonthView(context, tasks, theme),
                CalendarMode.week => _buildWeekView(context, tasks, theme),
                CalendarMode.day => _buildDayView(context, tasks, theme),
                CalendarMode.agenda => _buildAgendaView(context, tasks, theme),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthView(BuildContext context, List<TaskEntity> tasks, AppThemeData theme) {
    final daysInMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;
    final firstWeekday = DateTime(_focusedDate.year, _focusedDate.month, 1).weekday;

    final focusedDayTasks = tasks
        .where((t) => t.dueDate != null && DateUtils.isSameDay(t.dueDate!, _focusedDate) && !t.isArchived)
        .toList();

    return Column(
      children: [
        // Days of week header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((d) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      d,
                      style: context.typography.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.secondary,
                      ),
                    ),
                  ),)
              .toList(),
        ),
        // Month Grid View
        SizedBox(
          height: 280,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.1,
            ),
            itemCount: daysInMonth + (firstWeekday - 1),
            itemBuilder: (context, index) {
              if (index < firstWeekday - 1) return const SizedBox();

              final dayNum = index - (firstWeekday - 2);
              final cellDate = DateTime(_focusedDate.year, _focusedDate.month, dayNum);
              final isToday = DateUtils.isSameDay(cellDate, DateTime.now());
              final isFocused = DateUtils.isSameDay(cellDate, _focusedDate);

              final dayTasks = tasks
                  .where((t) => t.dueDate != null && DateUtils.isSameDay(t.dueDate!, cellDate) && !t.isArchived)
                  .toList();
              final hasReminder = dayTasks.any((t) => t.reminderMs != null);
              final hasRecurring = dayTasks.any((t) => t.recurrenceRule != null);

              return DragTarget<TaskEntity>(
                onWillAcceptWithDetails: (details) => true,
                onAcceptWithDetails: (details) {
                  final task = details.data;
                  final updated = task.copyWith(
                    dueDate: DateTime(cellDate.year, cellDate.month, cellDate.day, task.dueDate?.hour ?? 12, task.dueDate?.minute ?? 0),
                    updatedAt: DateTime.now(),
                  );
                  ref.read(tasksNotifierProvider.notifier).updateTask(updated);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Moved "${task.title}" to ${DateFormat('MMM d').format(cellDate)}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                builder: (context, candidateData, rejectedData) {
                  final isHovered = candidateData.isNotEmpty;
                  return GestureDetector(
                    onTap: () => setState(() => _focusedDate = cellDate),
                    onLongPress: () => _createNewTaskAtDate(cellDate),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: isHovered
                            ? theme.primary.withValues(alpha: 0.25)
                            : (isFocused
                                ? theme.primary.withValues(alpha: 0.15)
                                : (isToday ? theme.surfaceBright : theme.surface)),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isFocused
                              ? theme.primary
                              : (isToday ? theme.secondary.withValues(alpha: 0.5) : theme.outlineVariant),
                          width: isFocused ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$dayNum',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isToday || isFocused ? FontWeight.bold : FontWeight.normal,
                              color: isFocused ? theme.primary : (isToday ? theme.secondary : null),
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Dots indicator
                          if (dayTasks.isNotEmpty)
                            Wrap(
                              spacing: 2,
                              alignment: WrapAlignment.center,
                              children: dayTasks.take(3).map((t) {
                                final categories = ref.read(categoriesProvider);
                                final cat = categories.firstWhere(
                                  (c) => c.name.toLowerCase() == t.category.toLowerCase(),
                                  orElse: () => PlannerCategory.builtInCategories[0],
                                );
                                Color dotColor = cat.color;
                                if (t.priority == 'high') {
                                  dotColor = theme.error;
                                } else if (t.priority == 'medium') {
                                  dotColor = theme.warning;
                                }
                                return Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: t.isCompleted ? theme.success.withValues(alpha: 0.5) : dotColor,
                                  ),
                                );
                              }).toList(),
                            ),
                          // Reminder/Recurrence mini icons
                          if (hasReminder || hasRecurring)
                            Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (hasReminder)
                                    Icon(Icons.notifications_rounded, size: 8, color: theme.warning),
                                  if (hasRecurring)
                                    Icon(Icons.repeat_rounded, size: 8, color: theme.primary),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const Divider(height: 1),
        // Day agenda list
        Expanded(
          child: Container(
            color: theme.surfaceDim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tasks for ${DateFormat('MMM d, yyyy').format(_focusedDate)}',
                        style: context.typography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_rounded, size: 20),
                        onPressed: () => _createNewTaskAtDate(_focusedDate),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: focusedDayTasks.isEmpty
                      ? Center(
                          child: Text(
                            'No tasks scheduled for this day.',
                            style: context.typography.bodySmall.copyWith(color: theme.secondary),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: focusedDayTasks.length,
                          itemBuilder: (context, idx) {
                            final t = focusedDayTasks[idx];
                            return Draggable<TaskEntity>(
                              data: t,
                              feedback: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: TaskCard(
                                    task: t,
                                    onToggle: () {},
                                    onDelete: () {},
                                    isSelected: false,
                                    isSelectionMode: false,
                                    onTapSelection: () {},
                                    onLongPress: () {},
                                    onTapDetail: () {},
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.4,
                                child: TaskCard(
                                  task: t,
                                  onToggle: () {},
                                  onDelete: () {},
                                  isSelected: false,
                                  isSelectionMode: false,
                                  onTapSelection: () {},
                                  onLongPress: () {},
                                  onTapDetail: () {},
                                ),
                              ),
                              child: TaskCard(
                                task: t,
                                onToggle: () => ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(t.id),
                                onDelete: () => ref.read(tasksNotifierProvider.notifier).deleteTask(t.id),
                                isSelected: false,
                                isSelectionMode: false,
                                onTapSelection: () {},
                                onLongPress: () {},
                                onTapDetail: () => _openTaskDetail(t),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekView(BuildContext context, List<TaskEntity> tasks, AppThemeData theme) {
    final startOfWeek = _focusedDate.subtract(Duration(days: _focusedDate.weekday - 1));

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 7,
      itemBuilder: (context, idx) {
        final day = startOfWeek.add(Duration(days: idx));
        final dayTasks = tasks
            .where((t) => t.dueDate != null && DateUtils.isSameDay(t.dueDate!, day) && !t.isArchived)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, MMM d').format(day),
                    style: context.typography.titleSmall.copyWith(fontWeight: FontWeight.bold, color: theme.primary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_rounded, size: 18),
                    onPressed: () => _createNewTaskAtDate(day),
                  ),
                ],
              ),
            ),
            if (dayTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
                child: Text('No tasks scheduled', style: context.typography.bodySmall.copyWith(color: theme.secondary)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dayTasks.length,
                itemBuilder: (context, tIdx) {
                  final t = dayTasks[tIdx];
                  return TaskCard(
                    task: t,
                    onToggle: () => ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(t.id),
                    onDelete: () => ref.read(tasksNotifierProvider.notifier).deleteTask(t.id),
                    isSelected: false,
                    isSelectionMode: false,
                    onTapSelection: () {},
                    onLongPress: () {},
                    onTapDetail: () => _openTaskDetail(t),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildDayView(BuildContext context, List<TaskEntity> tasks, AppThemeData theme) {
    final dayTasks = tasks
        .where((t) => t.dueDate != null && DateUtils.isSameDay(t.dueDate!, _focusedDate) && !t.isArchived)
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, MMMM d').format(_focusedDate),
                style: context.typography.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () => _createNewTaskAtDate(_focusedDate),
              ),
            ],
          ),
        ),
        Expanded(
          child: dayTasks.isEmpty
              ? Center(
                  child: Text(
                    'No tasks scheduled for this day.',
                    style: context.typography.bodySmall.copyWith(color: theme.secondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: dayTasks.length,
                  itemBuilder: (context, idx) {
                    final t = dayTasks[idx];
                    return TaskCard(
                      task: t,
                      onToggle: () => ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(t.id),
                      onDelete: () => ref.read(tasksNotifierProvider.notifier).deleteTask(t.id),
                      isSelected: false,
                      isSelectionMode: false,
                      onTapSelection: () {},
                      onLongPress: () {},
                      onTapDetail: () => _openTaskDetail(t),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAgendaView(BuildContext context, List<TaskEntity> tasks, AppThemeData theme) {
    final activeTasks = tasks.where((t) => !t.isArchived).toList();
    final sorted = List<TaskEntity>.from(activeTasks);
    sorted.sort((a, b) {
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });

    return sorted.isEmpty
        ? Center(
            child: Text(
              'No upcoming tasks in your agenda.',
              style: context.typography.bodySmall.copyWith(color: theme.secondary),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: sorted.length,
            itemBuilder: (context, idx) {
              final t = sorted[idx];
              return TaskCard(
                task: t,
                onToggle: () => ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(t.id),
                onDelete: () => ref.read(tasksNotifierProvider.notifier).deleteTask(t.id),
                isSelected: false,
                isSelectionMode: false,
                onTapSelection: () {},
                onLongPress: () {},
                onTapDetail: () => _openTaskDetail(t),
              );
            },
          );
  }
}
