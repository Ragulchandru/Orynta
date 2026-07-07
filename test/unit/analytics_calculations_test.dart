// test/unit/analytics_calculations_test.dart
//
// Orynta 2.0 — Analytics Calculations Unit Tests

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:orynta/core/constants/app_strings.dart';
import 'package:orynta/features/planner/domain/entities/task_entity.dart';
import 'package:orynta/features/planner/domain/repositories/task_repository.dart';
import 'package:orynta/features/planner/presentation/providers/tasks_notifier.dart';
import 'package:orynta/features/planner/presentation/providers/planner_stats_provider.dart';
import 'package:orynta/features/analytics/presentation/providers/analytics_provider.dart';
import 'package:orynta/features/planner/data/models/task_model.dart';
import 'package:orynta/features/habits/data/models/habit_model.dart';
import 'package:orynta/features/focus/data/models/focus_session_model.dart';
import 'package:orynta/features/notes/data/models/note_model.dart';

class FakeTaskRepository implements TaskRepository {
  @override
  Future<List<TaskEntity>> getAllTasks() async => [];
  @override
  Future<TaskEntity?> getTaskById(String id) async => null;
  @override
  Future<void> saveTask(TaskEntity task) async {}
  @override
  Future<void> updateTask(TaskEntity task) async {}
  @override
  Future<void> deleteTask(String id) async {}
}

class FakeTasksNotifier extends TasksNotifier {
  FakeTasksNotifier(List<TaskEntity> initialTasks) : super(FakeTaskRepository()) {
    state = initialTasks;
  }
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('orynta_analytics_test');
    Hive.init(tempDir.path);
    await Hive.openBox<TaskModel>(AppStrings.tasksBoxName);
    await Hive.openBox<HabitModel>(AppStrings.habitsBoxName);
    await Hive.openBox<FocusSessionModel>(AppStrings.focusBoxName);
    await Hive.openBox<NoteModel>(AppStrings.notesBoxName);
    await Hive.openBox<String>(AppStrings.settingsBoxName);
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Analytics Calculations & Streak Tests', () {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final yesterdayMidnight = todayMidnight.subtract(const Duration(days: 1));
    final twoDaysAgoMidnight = todayMidnight.subtract(const Duration(days: 2));

    test('Empty account calculates 0 streak and default productivity score', () {
      final container = ProviderContainer(
        overrides: [
          tasksNotifierProvider.overrideWith((ref) => FakeTasksNotifier([])),
        ],
      );
      addTearDown(container.dispose);

      final stats = container.read(plannerStatsProvider);
      final scoreData = container.read(todayStatsProvider);

      expect(stats.currentStreak, 0);
      expect(stats.longestStreak, 0);
      expect(scoreData.productivityScore, 0.0);
    });

    test('Single task completion today calculates 1-day streak', () {
      final task = TaskEntity(
        id: '1',
        title: 'Task 1',
        description: '',
        priority: 'medium',
        dueDate: todayMidnight,
        createdAt: now,
        updatedAt: now,
        isCompleted: true,
        timelineSection: 0,
        estimatedMinutes: 15,
        tagIds: const [],
      );

      final container = ProviderContainer(
        overrides: [
          tasksNotifierProvider.overrideWith((ref) => FakeTasksNotifier([task])),
        ],
      );
      addTearDown(container.dispose);

      final stats = container.read(plannerStatsProvider);
      expect(stats.currentStreak, 1);
    });

    test('Three consecutive days of completions calculates 3-day streak', () {
      final t1 = TaskEntity(
        id: '1',
        title: 'Task 1',
        description: '',
        priority: 'medium',
        dueDate: todayMidnight,
        createdAt: now,
        updatedAt: todayMidnight,
        isCompleted: true,
        timelineSection: 0,
        estimatedMinutes: 15,
        tagIds: const [],
      );
      final t2 = TaskEntity(
        id: '2',
        title: 'Task 2',
        description: '',
        priority: 'medium',
        dueDate: yesterdayMidnight,
        createdAt: now,
        updatedAt: yesterdayMidnight,
        isCompleted: true,
        timelineSection: 0,
        estimatedMinutes: 15,
        tagIds: const [],
      );
      final t3 = TaskEntity(
        id: '3',
        title: 'Task 3',
        description: '',
        priority: 'medium',
        dueDate: twoDaysAgoMidnight,
        createdAt: now,
        updatedAt: twoDaysAgoMidnight,
        isCompleted: true,
        timelineSection: 0,
        estimatedMinutes: 15,
        tagIds: const [],
      );

      final container = ProviderContainer(
        overrides: [
          tasksNotifierProvider.overrideWith((ref) => FakeTasksNotifier([t1, t2, t3])),
        ],
      );
      addTearDown(container.dispose);

      final stats = container.read(plannerStatsProvider);
      expect(stats.currentStreak, 3);
      expect(stats.longestStreak, 3);
    });

    test('Streak is broken when no completions exist today or yesterday', () {
      final t1 = TaskEntity(
        id: '1',
        title: 'Task 1',
        description: '',
        priority: 'medium',
        dueDate: twoDaysAgoMidnight,
        createdAt: now,
        updatedAt: twoDaysAgoMidnight,
        isCompleted: true,
        timelineSection: 0,
        estimatedMinutes: 15,
        tagIds: const [],
      );

      final container = ProviderContainer(
        overrides: [
          tasksNotifierProvider.overrideWith((ref) => FakeTasksNotifier([t1])),
        ],
      );
      addTearDown(container.dispose);

      final stats = container.read(plannerStatsProvider);
      expect(stats.currentStreak, 0);
      expect(stats.longestStreak, 1);
    });

    test('Productivity score reflects today completions', () {
      final task = TaskEntity(
        id: '1',
        title: 'Task Today',
        description: '',
        priority: 'high',
        dueDate: todayMidnight,
        createdAt: now,
        updatedAt: now,
        isCompleted: true,
        timelineSection: 0,
        estimatedMinutes: 30,
        tagIds: const [],
      );

      final container = ProviderContainer(
        overrides: [
          tasksNotifierProvider.overrideWith((ref) => FakeTasksNotifier([task])),
        ],
      );
      addTearDown(container.dispose);

      final scoreData = container.read(todayStatsProvider);
      expect(scoreData.productivityScore, greaterThan(0.0));
    });
  });
}
