import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._box);

  final Box<TaskModel> _box;

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    return _box.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<TaskEntity?> getTaskById(String id) async {
    final model = _box.get(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    await _box.put(task.id, TaskModel.fromEntity(task));
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await _box.put(task.id, TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }
}
