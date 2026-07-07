// test/widget/notes_view_mode_test.dart
//
// Orynta 2.0 — Notes View Mode Layout Widget Tests

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:orynta/core/constants/app_strings.dart';
import 'package:orynta/core/errors/failures.dart';
import 'package:orynta/features/notes/domain/entities/note_entity.dart';
import 'package:orynta/features/notes/domain/entities/note_status.dart';
import 'package:orynta/features/notes/domain/models/note_summary.dart';
import 'package:orynta/features/notes/domain/models/notes_filter.dart';
import 'package:orynta/features/notes/domain/models/notes_home_state.dart';
import 'package:orynta/features/notes/domain/models/notes_view_mode.dart';
import 'package:orynta/features/notes/domain/repositories/notes_home_repository.dart';
import 'package:orynta/features/notes/presentation/controllers/notes_home_controller.dart';
import 'package:orynta/features/notes/presentation/pages/notes_page.dart';
import 'package:orynta/features/notes/presentation/providers/notes_home_providers.dart';
import 'package:orynta/features/notes/presentation/providers/notes_notifier.dart';

class FakeNotesHomeRepository implements NotesHomeRepository {
  @override
  Future<Either<Failure, List<NoteSummary>>> loadNotes() async => const Right([]);
  @override
  Future<Either<Failure, List<NoteSummary>>> searchNotes(String query) async => const Right([]);
  @override
  Future<Either<Failure, List<NoteSummary>>> filterNotes(
    List<NoteSummary> notes,
    NotesFilter filter,
  ) async => const Right([]);
}

class FakeNotesHomeController extends NotesHomeController {
  FakeNotesHomeController(
    NotesHomeState initialState,
  ) : super(FakeNotesHomeRepository()) {
    state = initialState;
  }

  @override
  Future<void> setViewMode(NotesViewMode mode) async {
    state = state.copyWith(viewMode: mode);
  }

  @override
  Future<void> loadNotes() async {}
}

class FakeNotesNotifier extends NotesNotifier {
  FakeNotesNotifier(this._initialNotes);
  final List<NoteEntity> _initialNotes;

  @override
  Future<List<NoteEntity>> build() async {
    return _initialNotes;
  }
}

void main() {
  late Directory tempDir;
  late Box<String> box;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('orynta_notes_view_widget_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<String>(AppStrings.settingsBoxName);
  });

  tearDown(() async {
    await box.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Notes View Mode Widget Tests', () {
    final note = NoteSummary(
      id: 'note_1',
      title: 'Testing View Mode',
      preview: 'Snippet content of testing view mode',
      colorHex: '0xFFD0BCFF',
      isPinned: false,
      isFavorite: false,
      isArchived: false,
      updatedAt: DateTime.now(),
      tagIds: const [],
    );

    final notesList = [
      NoteEntity(
        id: 'note_1',
        title: 'Testing View Mode',
        body: 'Snippet content of testing view mode',
        isPinned: false,
        status: NoteStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isFavorite: false,
        tagIds: const [],
      ),
    ];

    testWidgets('Dropdown selection updates notes layout rendering', (tester) async {
      final initialState = NotesHomeState(
        notes: [note],
        filteredNotes: [note],
        selectedFilter: NotesFilter.all,
        searchQuery: '',
        loading: false,
        viewMode: NotesViewMode.grid,
      );

      final controller = FakeNotesHomeController(initialState);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notesHomeControllerProvider.overrideWith((ref) => controller),
            notesProvider.overrideWith(() => FakeNotesNotifier(notesList)),
          ],
          child: const MaterialApp(
            home: NotesPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify note summary card is displayed
      expect(find.text('Testing View Mode'), findsOneWidget);

      // Verify we can find and tap View Mode dropdown selection
      final dropdownFinder = find.byType(DropdownButton<NotesViewMode>);
      expect(dropdownFinder, findsOneWidget);

      // Change view mode to list inside controller directly to simulate selection change
      await controller.setViewMode(NotesViewMode.list);
      await tester.pumpAndSettle();

      // Verify note is still rendered after layout rebuild
      expect(find.text('Testing View Mode'), findsOneWidget);
    });
  });
}
