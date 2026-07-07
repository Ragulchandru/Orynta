// test/unit/planner_task_lifecycle_test.dart
//
// Orynta 2.0 — Planner Task Lifecycle Unit Tests

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:orynta/core/constants/app_strings.dart';
import 'package:orynta/features/planner/domain/entities/task_entity.dart';
import 'package:orynta/features/planner/domain/repositories/task_repository.dart';
import 'package:orynta/features/planner/presentation/providers/tasks_notifier.dart';

import '../fakes/fake_notification_service.dart';

class FakeTaskRepository implements TaskRepository {
  final Map<String, TaskEntity> _tasks = {};

  @override
  Future<List<TaskEntity>> getAllTasks() async => _tasks.values.toList();

  @override
  Future<TaskEntity?> getTaskById(String id) async => _tasks[id];

  @override
  Future<void> saveTask(TaskEntity task) async {
    _tasks[task.id] = task;
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    _tasks[task.id] = task;
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.remove(id);
  }
}

void main() {
  late FakeTaskRepository repository;
  late TasksNotifier notifier;
  late Directory tempDir;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('orynta_task_lifecycle_test');
    Hive.init(tempDir.path);
    await Hive.openBox<String>(AppStrings.settingsBoxName);
    repository = FakeTaskRepository();
    notifier = TasksNotifier(repository, notificationService: FakeNotificationService());
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Planner Task Lifecycle Tests', () {
    final task1 = TaskEntity(
      id: '1',
      title: 'Task 1',
      description: 'Desc 1',
      priority: 'low',
      dueDate: DateTime(2026, 7, 7),
      createdAt: DateTime(2026, 7, 7),
      updatedAt: DateTime(2026, 7, 7),
      isCompleted: false,
      timelineSection: 0,
      estimatedMinutes: 15,
      tagIds: const [],
    );

    test('Create: Adding a task saves it to repo and state', () async {
      await notifier.addTask(task1);

      expect(notifier.state.length, 1);
      expect(notifier.state.first.id, '1');

      final saved = await repository.getTaskById('1');
      expect(saved, isNotNull);
      expect(saved!.title, 'Task 1');
    });

    test('Edit: Updating a task updates repo and state', () async {
      await notifier.addTask(task1);

      final updatedTask = task1.copyWith(title: 'Updated Task 1');
      await notifier.updateTask(updatedTask);

      expect(notifier.state.first.title, 'Updated Task 1');

      final saved = await repository.getTaskById('1');
      expect(saved!.title, 'Updated Task 1');
    });

    test('Complete: Toggling completion updates state and repo', () async {
      await notifier.addTask(task1);

      await notifier.toggleTaskCompletion('1');
      expect(notifier.state.first.isCompleted, true);

      final saved = await repository.getTaskById('1');
      expect(saved!.isCompleted, true);
    });

    test('Archive: Archiving sets isArchived to true', () async {
      await notifier.addTask(task1);

      await notifier.archiveTask('1');
      expect(notifier.state.first.isArchived, true);

      final saved = await repository.getTaskById('1');
      expect(saved!.isArchived, true);
    });

    test('Restore: Restoring sets isArchived back to false', () async {
      final archivedTask = task1.copyWith(isArchived: true);
      await notifier.addTask(archivedTask);

      await notifier.restoreTask('1');
      expect(notifier.state.first.isArchived, false);

      final saved = await repository.getTaskById('1');
      expect(saved!.isArchived, false);
    });

    test('Delete: Deleting removes the task from state and repo', () async {
      await notifier.addTask(task1);

      await notifier.deleteTask('1');
      expect(notifier.state.isEmpty, true);

      final saved = await repository.getTaskById('1');
      expect(saved, isNull);
    });
  });
}
