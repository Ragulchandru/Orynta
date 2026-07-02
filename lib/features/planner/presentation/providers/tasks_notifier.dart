import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final box = Hive.box<TaskModel>(AppStrings.tasksBoxName);
  return TaskRepositoryImpl(box);
});

// ─── Tasks Notifier ─────────────────────────────────────────────────────────

class TasksNotifier extends StateNotifier<List<TaskEntity>> {
  TasksNotifier(this._repository) : super([]) {
    loadTasks();
  }

  final TaskRepository _repository;

  Future<void> loadTasks() async {
    final tasks = await _repository.getAllTasks();
    state = tasks;
  }

  Future<void> addTask(TaskEntity task) async {
    await _repository.saveTask(task);
    state = [...state, task];
  }

  Future<void> updateTask(TaskEntity task) async {
    await _repository.updateTask(task);
    state = [
      for (final t in state)
        if (t.id == task.id) task else t,
    ];
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = state.indexWhere((t) => t.id == id);
    if (index != -1) {
      final updated = state[index].copyWith(
        isCompleted: !state[index].isCompleted,
        updatedAt: DateTime.now(),
      );
      await _repository.updateTask(updated);
      state = [
        for (final t in state)
          if (t.id == id) updated else t,
      ];
    }
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    state = state.where((t) => t.id != id).toList();
  }

  Future<void> bulkDeleteTasks(List<String> ids) async {
    for (final id in ids) {
      await _repository.deleteTask(id);
    }
    state = state.where((t) => !ids.contains(t.id)).toList();
  }

  Future<void> bulkCompleteTasks(List<String> ids, bool isCompleted) async {
    final now = DateTime.now();
    state = [
      for (final t in state)
        if (ids.contains(t.id)) () {
          final updated = t.copyWith(isCompleted: isCompleted, updatedAt: now);
          _repository.updateTask(updated);
          return updated;
        }() else t,
    ];
  }

  Future<void> bulkMoveTimelineSection(List<String> ids, int targetSection) async {
    final now = DateTime.now();
    state = [
      for (final t in state)
        if (ids.contains(t.id)) () {
          final updated = t.copyWith(timelineSection: targetSection, updatedAt: now);
          _repository.updateTask(updated);
          return updated;
        }() else t,
    ];
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<TaskEntity>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TasksNotifier(repository);
});

// ─── Search, Filter, Sort States ─────────────────────────────────────────────

final taskSearchQueryProvider = StateProvider<String>((ref) => '');

final taskFilterProvider = StateProvider<String>((ref) => 'all'); // all, today, upcoming, completed, pending, high, medium, low

final taskSortProvider = StateProvider<String>((ref) => 'dueDate'); // dueDate, priority, recentlyUpdated, alphabetical

// ─── Collapsed Sections State ────────────────────────────────────────────────

class CollapsedSectionsNotifier extends StateNotifier<Set<int>> {
  CollapsedSectionsNotifier() : super({});

  void toggleCollapse(int sectionIndex) {
    if (state.contains(sectionIndex)) {
      state = state.difference({sectionIndex});
    } else {
      state = state.union({sectionIndex});
    }
  }
}

final collapsedSectionsProvider = StateNotifierProvider<CollapsedSectionsNotifier, Set<int>>((ref) {
  return CollapsedSectionsNotifier();
});

// ─── Selected Tasks State ────────────────────────────────────────────────────

class SelectedTasksNotifier extends StateNotifier<Set<String>> {
  SelectedTasksNotifier() : super({});

  void toggleSelection(String id) {
    if (state.contains(id)) {
      state = state.difference({id});
    } else {
      state = state.union({id});
    }
  }

  void clearSelection() {
    state = {};
  }

  void selectAll(List<String> ids) {
    state = Set.from(ids);
  }
}

final selectedTasksProvider = StateNotifierProvider<SelectedTasksNotifier, Set<String>>((ref) {
  return SelectedTasksNotifier();
});

// ─── Computed Providers ──────────────────────────────────────────────────────

/// Search results based on [taskSearchQueryProvider]
final searchResultsProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final query = ref.watch(taskSearchQueryProvider).trim().toLowerCase();
  
  if (query.isEmpty) return tasks;
  
  return tasks.where((t) {
    return t.title.toLowerCase().contains(query) ||
           t.description.toLowerCase().contains(query);
  }).toList();
});

/// Filtered tasks combining search and [taskFilterProvider]
final filteredTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(searchResultsProvider);
  final filter = ref.watch(taskFilterProvider);
  final today = DateTime.now();

  return tasks.where((t) {
    return switch (filter) {
      'today' => () {
        if (t.dueDate == null) return true;
        final due = t.dueDate!;
        return due.year == today.year && due.month == today.month && due.day == today.day;
      }(),
      'upcoming' => () {
        if (t.dueDate == null) return false;
        final startOfToday = DateTime(today.year, today.month, today.day);
        return t.dueDate!.isAfter(startOfToday.add(const Duration(days: 1))) || 
               (t.dueDate!.year == today.year && t.dueDate!.month == today.month && t.dueDate!.day == today.day && !t.isCompleted);
      }(),
      'completed' => t.isCompleted,
      'pending' => !t.isCompleted,
      'high' => t.priority.toLowerCase() == 'high',
      'medium' => t.priority.toLowerCase() == 'medium',
      'low' => t.priority.toLowerCase() == 'low',
      _ => true,
    };
  }).toList();
});

/// Sorted tasks based on [taskSortProvider]
final sortedTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  final sortMode = ref.watch(taskSortProvider);

  final sorted = List<TaskEntity>.from(tasks);
  sorted.sort((a, b) {
    return switch (sortMode) {
      'dueDate' => () {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      }(),
      'priority' => () {
        final aPriority = _priorityWeight(a.priority);
        final bPriority = _priorityWeight(b.priority);
        return bPriority.compareTo(aPriority); // High weight first
      }(),
      'recentlyUpdated' => b.updatedAt.compareTo(a.updatedAt),
      'alphabetical' => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      _ => 0,
    };
  });
  return sorted;
});

int _priorityWeight(String priority) {
  return switch (priority.toLowerCase()) {
    'high' => 3,
    'medium' => 2,
    _ => 1,
  };
}

// ─── Business Analytics Summary Providers ────────────────────────────────────

final completedTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(tasksProvider).where((t) => t.isCompleted).toList();
});

final pendingTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(tasksProvider).where((t) => !t.isCompleted).toList();
});

final highPriorityTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(tasksProvider).where((t) => t.priority.toLowerCase() == 'high').toList();
});

/// All tasks for today (either due today or with no due date).
final todaysTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final today = DateTime.now();
  return tasks.where((t) {
    if (t.dueDate == null) return true;
    final due = t.dueDate!;
    return due.year == today.year && due.month == today.month && due.day == today.day;
  }).toList();
});

final completedTodayTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(todaysTasksProvider).where((t) => t.isCompleted).toList();
});

final remainingTodayTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(todaysTasksProvider).where((t) => !t.isCompleted).toList();
});

/// Overdue tasks (due in past, and not completed)
final overdueTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final now = DateTime.now();
  return tasks.where((t) {
    if (t.isCompleted || t.dueDate == null) return false;
    // Overdue if due date is before today
    final startOfToday = DateTime(now.year, now.month, now.day);
    return t.dueDate!.isBefore(startOfToday);
  }).toList();
});

/// Upcoming pending tasks scheduled in future
final upcomingTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final now = DateTime.now();
  final startOfTomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  return tasks.where((t) {
    if (t.isCompleted || t.dueDate == null) return false;
    return t.dueDate!.isAtSameMomentAs(startOfTomorrow) || t.dueDate!.isAfter(startOfTomorrow);
  }).toList();
});

/// Next upcoming pending task (closest due date in future)
final nextUpcomingTaskProvider = Provider<TaskEntity?>((ref) {
  final upcoming = ref.watch(upcomingTasksProvider);
  if (upcoming.isEmpty) return null;
  final sorted = List<TaskEntity>.from(upcoming);
  sorted.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  return sorted.first;
});

/// Completion percentage for today's tasks + mock habits (Dashboard display)
final completionRateProvider = Provider<double>((ref) {
  final todaysTasks = ref.watch(todaysTasksProvider);
  final tasksCompleted = todaysTasks.where((t) => t.isCompleted).length;
  final totalTasks = todaysTasks.length;

  const habitsCompleted = 3;
  const totalHabits = 4;

  final completedCount = tasksCompleted + habitsCompleted;
  final totalCount = totalTasks + totalHabits;
  return totalCount > 0 ? completedCount / totalCount : 0.0;
});

// ─── Timeline Morning/Afternoon/Evening/Night Sections ────────────────────────

final morningTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(sortedTasksProvider).where((t) => t.timelineSection == 0).toList();
});

final afternoonTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(sortedTasksProvider).where((t) => t.timelineSection == 1).toList();
});

final eveningTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(sortedTasksProvider).where((t) => t.timelineSection == 2).toList();
});

final nightTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(sortedTasksProvider).where((t) => t.timelineSection == 3).toList();
});
