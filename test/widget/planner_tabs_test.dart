// test/widget/planner_tabs_test.dart
//
// Orynta 2.0 — Planner Tabs Filter Widget Tests

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:orynta/core/constants/app_strings.dart';
import 'package:orynta/features/planner/domain/entities/task_entity.dart';
import 'package:orynta/features/planner/domain/models/category_model.dart';
import 'package:orynta/features/planner/domain/repositories/task_repository.dart';
import 'package:orynta/features/planner/presentation/providers/categories_notifier.dart';
import 'package:orynta/features/planner/presentation/providers/tasks_notifier.dart';
import 'package:orynta/features/planner/presentation/screens/planner_screen.dart';

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

class FakeCategoriesNotifier extends CategoriesNotifier {
  FakeCategoriesNotifier() : super() {
    state = PlannerCategory.builtInCategories;
  }
}

void main() {
  late Directory tempDir;
  late Box<String> box;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('orynta_planner_tabs_widget_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<String>(AppStrings.settingsBoxName);
  });

  tearDown(() async {
    await box.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Planner Tabs Widget Tests', () {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final tomorrowMidnight = todayMidnight.add(const Duration(days: 1));

    final tToday = TaskEntity(
      id: 'today_task',
      title: 'Task Due Today',
      description: '',
      priority: 'medium',
      dueDate: todayMidnight.add(const Duration(hours: 10)),
      createdAt: now,
      updatedAt: now,
      isCompleted: false,
      timelineSection: 0,
      estimatedMinutes: 15,
      tagIds: const [],
      category: 'Personal',
    );

    final tTomorrow = TaskEntity(
      id: 'tomorrow_task',
      title: 'Task Due Tomorrow',
      description: '',
      priority: 'high',
      dueDate: tomorrowMidnight.add(const Duration(hours: 10)),
      createdAt: now,
      updatedAt: now,
      isCompleted: false,
      timelineSection: 0,
      estimatedMinutes: 30,
      tagIds: const [],
      category: 'Personal',
    );

    testWidgets('Default tab is Today and switching tabs changes visible tasks',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tasksNotifierProvider.overrideWith((ref) => FakeTasksNotifier([tToday, tTomorrow])),
            categoriesProvider.overrideWith((ref) => FakeCategoriesNotifier()),
          ],
          child: const MaterialApp(
            home: PlannerScreen(),
          ),
        ),
      );

      // Verify startup state is loaded and Today tab is visible
      await tester.pumpAndSettle();

      // Today task should be visible
      expect(find.text('Task Due Today'), findsOneWidget);

      // Tomorrow task should NOT be visible initially
      expect(find.text('Task Due Tomorrow'), findsNothing);

      // Tap on the "Tomorrow" FilterChip
      final tomorrowChip = find.widgetWithText(FilterChip, 'Tomorrow');
      expect(tomorrowChip, findsOneWidget);
      await tester.tap(tomorrowChip);
      await tester.pumpAndSettle();

      // Tomorrow task should now be visible
      expect(find.text('Task Due Tomorrow'), findsOneWidget);

      // Today task should NOT be visible under Tomorrow tab
      expect(find.text('Task Due Today'), findsNothing);
    });
  });
}
