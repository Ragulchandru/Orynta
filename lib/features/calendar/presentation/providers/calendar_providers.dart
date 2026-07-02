import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../planner/domain/entities/task_entity.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';

// ─── Selected Date States ───────────────────────────────────────────────────

/// The active selected date in the calendar/agenda view.
/// Defaults to today at midnight.
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// The active month being displayed in the monthly calendar grid.
/// Used to navigate previous/next months.
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

// ─── Tasks For Selected Date ────────────────────────────────────────────────

/// Tasks scheduled for the selected calendar date.
/// If selected date is today, includes tasks with no due date.
/// If selected date is in past/future, only includes tasks scheduled for that day.
final selectedDateTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final now = DateTime.now();
  final isToday = selectedDate.year == now.year &&
      selectedDate.month == now.month &&
      selectedDate.day == now.day;

  return tasks.where((t) {
    if (t.dueDate == null) {
      return isToday; // Unscheduled tasks show up on today
    }
    final due = t.dueDate!;
    return due.year == selectedDate.year &&
        due.month == selectedDate.month &&
        due.day == selectedDate.day;
  }).toList();
});

// ─── Monthly Task Map (Task Indicators) ──────────────────────────────────────

/// Maps date strings ('yyyy-MM-dd') to task count for calendar day indicators.
final monthlyTaskMapProvider = Provider<Map<String, int>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final map = <String, int>{};

  for (final t in tasks) {
    if (t.dueDate != null) {
      final key = _formatDateKey(t.dueDate!);
      map[key] = (map[key] ?? 0) + 1;
    }
  }
  return map;
});

String _formatDateKey(DateTime dt) {
  final y = dt.year.toString();
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

// ─── Computed Agenda & Progress For Selected Date ───────────────────────────

final selectedDateCompletedTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(selectedDateTasksProvider).where((t) => t.isCompleted).toList();
});

final selectedDateRemainingTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(selectedDateTasksProvider).where((t) => !t.isCompleted).toList();
});

/// Dynamic completion rate for selected date tasks + mock habits.
final selectedDateCompletionRateProvider = Provider<double>((ref) {
  final tasks = ref.watch(selectedDateTasksProvider);
  final completedTasksCount = tasks.where((t) => t.isCompleted).length;
  final totalTasksCount = tasks.length;

  const habitsCompleted = 3;
  const totalHabits = 4;

  final completedCount = completedTasksCount + habitsCompleted;
  final totalCount = totalTasksCount + totalHabits;
  return totalCount > 0 ? completedCount / totalCount : 0.0;
});

// ─── Selected Date Timeline Section Tasks ────────────────────────────────────

final selectedDateMorningTasksProvider = Provider<List<TaskEntity>>((ref) {
  final sorted = ref.watch(sortedTasksProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  return _filterTasksByDateAndSection(sorted, selectedDate, 0);
});

final selectedDateAfternoonTasksProvider = Provider<List<TaskEntity>>((ref) {
  final sorted = ref.watch(sortedTasksProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  return _filterTasksByDateAndSection(sorted, selectedDate, 1);
});

final selectedDateEveningTasksProvider = Provider<List<TaskEntity>>((ref) {
  final sorted = ref.watch(sortedTasksProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  return _filterTasksByDateAndSection(sorted, selectedDate, 2);
});

final selectedDateNightTasksProvider = Provider<List<TaskEntity>>((ref) {
  final sorted = ref.watch(sortedTasksProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  return _filterTasksByDateAndSection(sorted, selectedDate, 3);
});

List<TaskEntity> _filterTasksByDateAndSection(
  List<TaskEntity> tasks,
  DateTime selectedDate,
  int sectionIndex,
) {
  final now = DateTime.now();
  final isToday = selectedDate.year == now.year &&
      selectedDate.month == now.month &&
      selectedDate.day == now.day;

  return tasks.where((t) {
    if (t.timelineSection != sectionIndex) return false;
    if (t.dueDate == null) return isToday;
    final due = t.dueDate!;
    return due.year == selectedDate.year &&
        due.month == selectedDate.month &&
        due.day == selectedDate.day;
  }).toList();
}
