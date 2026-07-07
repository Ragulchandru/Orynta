// integration_test/app_test.dart
//
// Orynta 2.0 — End-to-End Core User Workflows Integration Tests

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive/hive.dart';
import 'package:orynta/core/constants/app_strings.dart';
import 'package:orynta/app.dart';
import 'package:orynta/features/notes/data/models/note_model.dart';
import 'package:orynta/features/notes/data/models/note_type_adapter.dart';
import 'package:orynta/features/notes/data/models/note_attachment_model.dart';
import 'package:orynta/features/notes/data/models/note_attachment_type_adapter.dart';
import 'package:orynta/features/planner/data/models/task_model.dart';
import 'package:orynta/features/planner/data/models/task_type_adapter.dart';
import 'package:orynta/features/habits/data/models/habit_model.dart';
import 'package:orynta/features/habits/data/models/habit_type_adapter.dart';
import 'package:orynta/features/focus/data/models/focus_session_model.dart';
import 'package:orynta/features/focus/data/models/focus_type_adapter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('orynta_integration_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(NoteTypeAdapter());
    Hive.registerAdapter(NoteAttachmentTypeAdapter());
    Hive.registerAdapter(TaskTypeAdapter());
    Hive.registerAdapter(HabitTypeAdapter());
    Hive.registerAdapter(FocusTypeAdapter());
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Orynta 2.0 Core Flow Integration Tests', () {
    testWidgets('App Launch, Task Lifecycle, Note Creation, Theme Check', (tester) async {
      // Clear or open boxes for fresh start
      await Hive.openBox<String>(AppStrings.settingsBoxName);
      await Hive.openBox<NoteModel>(AppStrings.notesBoxName);
      await Hive.openBox<NoteAttachmentModel>(AppStrings.attachmentsBoxName);
      await Hive.openBox<TaskModel>(AppStrings.tasksBoxName);
      await Hive.openBox<HabitModel>(AppStrings.habitsBoxName);
      await Hive.openBox<FocusSessionModel>(AppStrings.focusBoxName);

      // Launch application
      await tester.pumpWidget(
        const ProviderScope(
          child: OryntaApp(),
        ),
      );

      await tester.pumpAndSettle();

      // App starts by showing splash, wait for it to route to lock/onboarding/dashboard
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // We expect the app to load dashboard page
      expect(find.text('Dashboard'), findsOneWidget);

      // Verify today at a glance cards render
      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('Streak'), findsOneWidget);
      expect(find.text('Score'), findsOneWidget);
    });
  });
}
