// lib/features/planner/presentation/screens/planner_calendar_view.dart
//
// Orynta 2.0 — Premium Planner Calendar View System

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/design_system.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/tasks_notifier.dart';
import '../widgets/task_card.dart';

enum CalendarMode { month, week, day, agenda }

class PlannerCalendarView extends ConsumerStatefulWidget {
  const PlannerCalendarView({super.key});

  @override
  ConsumerState<PlannerCalendarView> createState() => _PlannerCalendarViewState();
}

class _PlannerCalendarViewState extends ConsumerState<PlannerCalendarView> {
  CalendarMode _mode = CalendarMode.month;
  DateTime _focusedDate = DateTime.now();

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

    return Column(
      children: [
        // Days of week header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((d) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(d, style: context.typography.labelSmall.copyWith(fontWeight: FontWeight.bold)),
                  ),)
              .toList(),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.85,
            ),
            itemCount: daysInMonth + (firstWeekday - 1),
            itemBuilder: (context, index) {
              if (index < firstWeekday - 1) return const SizedBox();

              final dayNum = index - (firstWeekday - 2);
              final cellDate = DateTime(_focusedDate.year, _focusedDate.month, dayNum);
              final isToday = DateUtils.isSameDay(cellDate, DateTime.now());

              final dayTasks = tasks.where((t) => t.dueDate != null && DateUtils.isSameDay(t.dueDate!, cellDate)).toList();
              final hasOverdue = dayTasks.any((t) => !t.isCompleted && cellDate.isBefore(DateTime.now()));

              return GestureDetector(
                onTap: () => setState(() => _focusedDate = cellDate),
                child: Container(
                  margin: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: isToday ? theme.primary.withValues(alpha: 0.15) : theme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isToday ? theme.primary : theme.outlineVariant,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNum',
                        style: TextStyle(
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: isToday ? theme.primary : null,
                        ),
                      ),
                      if (dayTasks.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: hasOverdue ? theme.error : theme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
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
        final dayTasks = tasks.where((t) => t.dueDate != null && DateUtils.isSameDay(t.dueDate!, day)).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                DateFormat('EEEE, MMM d').format(day),
                style: context.typography.titleSmall.copyWith(fontWeight: FontWeight.bold, color: theme.primary),
              ),
            ),
            if (dayTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                child: Text('No tasks scheduled', style: context.typography.bodySmall),
              )
            else
              ...dayTasks.map((t) => TaskCard(
                    task: t,
                    onToggle: () => ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(t.id),
                    onDelete: () => ref.read(tasksNotifierProvider.notifier).deleteTask(t.id),
                    isSelected: false,
                    isSelectionMode: false,
                    onTapSelection: () {},
                    onLongPress: () {},
                    onTapDetail: () {
                      context.push('/planner/detail', extra: t);
                    },
                  ),),
          ],
        );
      },
    );
  }

  Widget _buildDayView(BuildContext context, List<TaskEntity> tasks, AppThemeData theme) {
    final dayTasks = tasks.where((t) => t.dueDate != null && DateUtils.isSameDay(t.dueDate!, _focusedDate)).toList();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          DateFormat('EEEE, MMMM d, yyyy').format(_focusedDate),
          style: context.typography.headlineSmall.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (dayTasks.isEmpty)
          const Center(child: Text('No tasks scheduled for this day.'))
        else
          ...dayTasks.map((t) => TaskCard(
                task: t,
                onToggle: () => ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(t.id),
                onDelete: () => ref.read(tasksNotifierProvider.notifier).deleteTask(t.id),
                isSelected: false,
                isSelectionMode: false,
                onTapSelection: () {},
                onLongPress: () {},
                onTapDetail: () {
                  context.push('/planner/detail', extra: t);
                },
              ),),
      ],
    );
  }

  Widget _buildAgendaView(BuildContext context, List<TaskEntity> tasks, AppThemeData theme) {
    final sorted = List<TaskEntity>.from(tasks);
    sorted.sort((a, b) {
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });

    return ListView.builder(
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
          onTapDetail: () {
            context.push('/planner/detail', extra: t);
          },
        );
      },
    );
  }
}
