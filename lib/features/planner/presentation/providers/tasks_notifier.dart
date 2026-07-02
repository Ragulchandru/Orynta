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

  Future<void> toggleTaskCompletion(String id) async {
    final index = state.indexWhere((t) => t.id == id);
    if (index != -1) {
      final updated = state[index].copyWith(
        isCompleted: !state[index].isCompleted,
        updatedAt: DateTime.now(),
      );
      await _repository.saveTask(updated);
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
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<TaskEntity>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TasksNotifier(repository);
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

/// Tasks filtered by timeline sections
final morningTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(todaysTasksProvider).where((t) => t.timelineSection == 0).toList();
});

final afternoonTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(todaysTasksProvider).where((t) => t.timelineSection == 1).toList();
});

final eveningTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(todaysTasksProvider).where((t) => t.timelineSection == 2).toList();
});

final nightTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(todaysTasksProvider).where((t) => t.timelineSection == 3).toList();
});
