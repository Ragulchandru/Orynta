// lib/features/planner/presentation/providers/tasks_notifier.dart
//
// Orynta 2.0 — Premium Tasks Notifier & Smart Filter Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/services/recurrence_engine.dart';
import '../../domain/services/notification_service.dart';
import '../../domain/services/planner_notification_service.dart';


final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final box = Hive.box<TaskModel>(AppStrings.tasksBoxName);
  return TaskRepositoryImpl(box);
});

// ─── Tasks Notifier ─────────────────────────────────────────────────────────

class TasksNotifier extends StateNotifier<List<TaskEntity>> {
  TasksNotifier(
    this._repository, {
    NotificationService? notificationService,
  })  : _notificationService = notificationService ?? PlannerNotificationService.instance,
        super([]) {
    loadTasks();
  }

  final TaskRepository _repository;
  final NotificationService _notificationService;

  Future<void> loadTasks() async {
    final tasks = await _repository.getAllTasks();
    state = tasks;
    // Reschedule all active future reminders upon load
    for (final task in tasks) {
      _syncTaskReminder(task);
    }
  }

  Future<void> addTask(TaskEntity task) async {
    final updatedTask = _setTaskReminderFields(task);
    await _repository.saveTask(updatedTask);
    state = [...state, updatedTask];
    _syncTaskReminder(updatedTask);
  }

  Future<void> quickAddTask(String title, {String? category, DateTime? dueDate}) async {
    if (title.trim().isEmpty) return;
    final now = DateTime.now();
    final box = Hive.box<String>(AppStrings.settingsBoxName);
    final defaultCat = category ?? box.get('default_category_id') ?? 'Personal';

    final task = TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      description: '',
      priority: 'medium',
      dueDate: dueDate ?? now,
      createdAt: now,
      updatedAt: now,
      isCompleted: false,
      timelineSection: 0,
      estimatedMinutes: 15,
      tagIds: const [],
      category: defaultCat,
    );
    await addTask(task);
  }

  Future<void> updateTask(TaskEntity task) async {
    final updatedTask = _setTaskReminderFields(task);
    await _repository.updateTask(updatedTask);
    state = [
      for (final t in state)
        if (t.id == task.id) updatedTask else t,
    ];
    _syncTaskReminder(updatedTask);
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = state.indexWhere((t) => t.id == id);
    if (index != -1) {
      final current = state[index];
      final newStatus = !current.isCompleted;
      final now = DateTime.now();

      final updated = current.copyWith(
        isCompleted: newStatus,
        updatedAt: now,
      );

      await updateTask(updated);

      // Offline-first recurrence generation
      if (newStatus && current.recurrenceRule != null && current.dueDate != null) {
        final nextDue = RecurrenceEngine.computeNextDueDate(current.dueDate!, current.recurrenceRule);
        if (nextDue != null) {
          final recurringCopy = current.copyWith(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            dueDate: nextDue,
            isCompleted: false,
            createdAt: now,
            updatedAt: now,
            subtasks: current.subtasks.map((s) => s.copyWith(isCompleted: false)).toList(),
          );
          await addTask(recurringCopy);
        }
      }
    }
  }

  Future<void> toggleSubtaskCompletion(String taskId, String subtaskId) async {
    final index = state.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final current = state[index];
      final updatedSubtasks = current.subtasks.map((s) {
        if (s.id == subtaskId) {
          return s.copyWith(isCompleted: !s.isCompleted);
        }
        return s;
      }).toList();

      final updated = current.copyWith(
        subtasks: updatedSubtasks,
        updatedAt: DateTime.now(),
      );

      await updateTask(updated);
    }
  }

  Future<void> toggleFavorite(String id) async {
    final index = state.indexWhere((t) => t.id == id);
    if (index != -1) {
      final current = state[index];
      final updated = current.copyWith(
        isFavorite: !current.isFavorite,
        updatedAt: DateTime.now(),
      );
      await updateTask(updated);
    }
  }

  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final items = List<TaskEntity>.from(state);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    state = items;
    for (var i = 0; i < state.length; i++) {
      final updated = state[i].copyWith(sortOrder: i);
      await _repository.updateTask(updated);
    }
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    state = state.where((t) => t.id != id).toList();
    _notificationService.cancelTaskReminder(id);
  }

  Future<void> bulkDeleteTasks(List<String> ids) async {
    for (final id in ids) {
      await _repository.deleteTask(id);
      _notificationService.cancelTaskReminder(id);
    }
    state = state.where((t) => !ids.contains(t.id)).toList();
  }

  Future<void> bulkCompleteTasks(List<String> ids, bool isCompleted) async {
    final now = DateTime.now();
    state = [
      for (final t in state)
        if (ids.contains(t.id)) () {
          final updated = t.copyWith(isCompleted: isCompleted, updatedAt: now);
          final updatedWithReminder = _setTaskReminderFields(updated);
          _repository.updateTask(updatedWithReminder);
          _syncTaskReminder(updatedWithReminder);
          return updatedWithReminder;
        }() else t,
    ];
  }

  Future<void> archiveTask(String id) async {
    final index = state.indexWhere((t) => t.id == id);
    if (index != -1) {
      final current = state[index];
      final updated = current.copyWith(isArchived: true, updatedAt: DateTime.now());
      await updateTask(updated);
    }
  }

  Future<void> restoreTask(String id) async {
    final index = state.indexWhere((t) => t.id == id);
    if (index != -1) {
      final current = state[index];
      final updated = current.copyWith(isArchived: false, isCompleted: false, updatedAt: DateTime.now());
      await updateTask(updated);
    }
  }

  Future<void> bulkArchiveTasks(List<String> ids) async {
    final now = DateTime.now();
    for (final id in ids) {
      final index = state.indexWhere((t) => t.id == id);
      if (index != -1) {
        final updated = state[index].copyWith(isArchived: true, updatedAt: now);
        await updateTask(updated);
      }
    }
  }

  Future<void> bulkUnarchiveTasks(List<String> ids) async {
    final now = DateTime.now();
    for (final id in ids) {
      final index = state.indexWhere((t) => t.id == id);
      if (index != -1) {
        final updated = state[index].copyWith(isArchived: false, isCompleted: false, updatedAt: now);
        await updateTask(updated);
      }
    }
  }

  void _syncTaskReminder(TaskEntity task) {
    _notificationService.cancelTaskReminder(task.id);

    if (task.isCompleted || task.isArchived || task.dueDate == null) {
      return;
    }

    final offsetMinutes = task.earlyReminderMinutes ?? _getDefaultOffset(task.priority);
    final reminderTime = task.dueDate!.subtract(Duration(minutes: offsetMinutes));

    if (reminderTime.isAfter(DateTime.now())) {
      _notificationService.scheduleTaskReminder(
        taskId: task.id,
        taskTitle: task.title,
        reminderTime: reminderTime,
        earlyMinutes: offsetMinutes,
        repeatInterval: task.repeatReminderInterval ?? 'none',
      );
    }
  }

  int _getDefaultOffset(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 30;
      case 'medium':
        return 15;
      case 'low':
        return 5;
      default:
        return 15;
    }
  }

  TaskEntity _setTaskReminderFields(TaskEntity task) {
    if (task.dueDate == null || task.isCompleted || task.isArchived) {
      return task.copyWith(reminderMs: null);
    }
    final offset = task.earlyReminderMinutes ?? _getDefaultOffset(task.priority);
    final reminderTime = task.dueDate!.subtract(Duration(minutes: offset));
    return task.copyWith(
      earlyReminderMinutes: offset,
      reminderMs: reminderTime.millisecondsSinceEpoch,
    );
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

// Alias for cleaner code
final tasksNotifierProvider = tasksProvider;

// ─── Search, Filter, Sort States ─────────────────────────────────────────────

final taskSearchQueryProvider = StateProvider<String>((ref) => '');

final taskFilterProvider = StateProvider<String>((ref) => 'today'); // today, tomorrow, upcoming, completed, archived, all

final taskCategoryFilterProvider = StateProvider<String?>((ref) => null);

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

// ─── Computed Smart Search Provider ──────────────────────────────────────────

/// Search results searching Title, Description, Notes, Tags, Category, Subtasks, and Linked Notes
final searchResultsProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final query = ref.watch(taskSearchQueryProvider).trim().toLowerCase();
  
  if (query.isEmpty) return tasks;
  
  return tasks.where((t) {
    final inTitle = t.title.toLowerCase().contains(query);
    final inDesc = t.description.toLowerCase().contains(query);
    final inNotes = t.notes?.toLowerCase().contains(query) ?? false;
    final inCategory = t.category.toLowerCase().contains(query);
    final inTags = t.tagIds.any((tag) => tag.toLowerCase().contains(query));
    final inSubtasks = t.subtasks.any((sub) => sub.title.toLowerCase().contains(query));
    final inLinked = t.linkedNoteIds.any((id) => id.toLowerCase().contains(query)) ||
        (t.linkedNoteId?.toLowerCase().contains(query) ?? false);

    return inTitle || inDesc || inNotes || inCategory || inTags || inSubtasks || inLinked;
  }).toList();
});

/// Filtered tasks combining search, smart filters, and category filter
final filteredTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(searchResultsProvider);
  final filter = ref.watch(taskFilterProvider);
  final categoryFilter = ref.watch(taskCategoryFilterProvider);
  final today = DateTime.now();
  final startOfToday = DateTime(today.year, today.month, today.day);

  return tasks.where((t) {
    if (categoryFilter != null && categoryFilter.isNotEmpty) {
      if (t.category.toLowerCase() != categoryFilter.toLowerCase()) return false;
    }

    // Archived tab shows only archived. Other tabs show only non-archived.
    if (filter == 'archived') {
      if (!t.isArchived) return false;
    } else {
      if (t.isArchived) return false;
    }

    return switch (filter) {
      'today' => () {
        if (t.isCompleted) return false;
        if (t.dueDate == null) return true;
        final due = t.dueDate!;
        final dueStart = DateTime(due.year, due.month, due.day);
        return dueStart.isAtSameMomentAs(startOfToday) || dueStart.isBefore(startOfToday);
      }(),
      'tomorrow' => () {
        if (t.isCompleted) return false;
        if (t.dueDate == null) return false;
        final tomorrow = startOfToday.add(const Duration(days: 1));
        final due = t.dueDate!;
        return due.year == tomorrow.year && due.month == tomorrow.month && due.day == tomorrow.day;
      }(),
      'upcoming' => () {
        if (t.isCompleted) return false;
        if (t.dueDate == null) return false;
        final dayAfterTomorrow = startOfToday.add(const Duration(days: 2));
        final due = t.dueDate!;
        final dueStart = DateTime(due.year, due.month, due.day);
        return dueStart.isAtSameMomentAs(dayAfterTomorrow) || dueStart.isAfter(dayAfterTomorrow);
      }(),
      'completed' => t.isCompleted,
      'archived' => true,
      'all' => !t.isCompleted,
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

// ─── Analytics & Section Providers ─────────────────────────────────────────

final completedTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(tasksProvider).where((t) => t.isCompleted).toList();
});

final pendingTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(tasksProvider).where((t) => !t.isCompleted).toList();
});

final highPriorityTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(tasksProvider).where((t) => t.priority.toLowerCase() == 'high').toList();
});

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

final overdueTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  return tasks.where((t) {
    if (t.isCompleted || t.dueDate == null) return false;
    return t.dueDate!.isBefore(startOfToday);
  }).toList();
});

final upcomingTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final now = DateTime.now();
  final startOfTomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  return tasks.where((t) {
    if (t.isCompleted || t.dueDate == null) return false;
    return t.dueDate!.isAtSameMomentAs(startOfTomorrow) || t.dueDate!.isAfter(startOfTomorrow);
  }).toList();
});

final nextUpcomingTaskProvider = Provider<TaskEntity?>((ref) {
  final upcoming = ref.watch(upcomingTasksProvider);
  if (upcoming.isEmpty) return null;
  final sorted = List<TaskEntity>.from(upcoming);
  sorted.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  return sorted.first;
});

final completionRateProvider = Provider<double>((ref) {
  final todaysTasks = ref.watch(todaysTasksProvider);
  final tasksCompleted = todaysTasks.where((t) => t.isCompleted).length;
  final totalTasks = todaysTasks.length;
  return totalTasks > 0 ? tasksCompleted / totalTasks : 0.0;
});
