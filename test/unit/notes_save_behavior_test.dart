// test/unit/notes_save_behavior_test.dart
//
// Orynta 2.0 — Notes Editor Save/Autosave Behavior Unit Tests

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:orynta/core/constants/app_strings.dart';
import 'package:orynta/core/errors/failures.dart';
import 'package:orynta/features/notes/domain/entities/note_entity.dart';
import 'package:orynta/features/notes/domain/entities/note_status.dart';
import 'package:orynta/features/notes/domain/repositories/note_editor_repository.dart';
import 'package:orynta/features/notes/presentation/providers/note_editor_providers.dart';
import 'package:orynta/features/settings/presentation/providers/settings_provider.dart';
import 'package:orynta/features/notes/data/models/note_model.dart';
import 'package:orynta/features/notes/data/models/note_type_adapter.dart';
import 'package:orynta/features/notes/data/models/note_attachment_model.dart';

class FakeNoteEditorRepository implements NoteEditorRepository {
  NoteEntity? savedNote;
  int saveCount = 0;

  @override
  Future<Either<Failure, NoteEntity>> createDraft() async {
    return Right(NoteEntity(
      id: 'draft',
      title: '',
      body: '',
      isPinned: false,
      status: NoteStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isFavorite: false,
      tagIds: const [],
    ),);
  }

  @override
  Future<Either<Failure, NoteEntity>> save(
    String id,
    String title,
    String content, {
    int? color,
    bool? isPinned,
    bool? isFavorite,
    bool? isArchived,
    List<String>? tagIds,
  }) async {
    saveCount++;
    savedNote = NoteEntity(
      id: id,
      title: title,
      body: content,
      isPinned: isPinned ?? false,
      status: (isArchived ?? false) ? NoteStatus.archived : NoteStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isFavorite: isFavorite ?? false,
      tagIds: tagIds ?? const [],
    );
    return Right(savedNote!);
  }

  @override
  Future<Either<Failure, void>> deleteDraft(String id) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, NoteEntity>> getNoteById(String id) async {
    return Right(NoteEntity(
      id: id,
      title: 'Note 1',
      body: 'Body 1',
      isPinned: false,
      status: NoteStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isFavorite: false,
      tagIds: const [],
    ),);
  }
}

class FakeSettingsNotifier extends SettingsNotifier {
  FakeSettingsNotifier(SettingsState initialState) {
    state = initialState;
  }

  @override
  void loadSettings() {}
}

void main() {
  late FakeNoteEditorRepository repository;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('orynta_notes_save_test');
    Hive.init(tempDir.path);
    try {
      Hive.registerAdapter(NoteTypeAdapter());
    } catch (_) {}
    await Hive.openBox<NoteModel>(AppStrings.notesBoxName);
    await Hive.openBox<NoteAttachmentModel>(AppStrings.attachmentsBoxName);
    await Hive.openBox<String>(AppStrings.settingsBoxName);
    repository = FakeNoteEditorRepository();
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Notes Autosave & Manual Save Tests', () {
    test('Autosave enabled: changes trigger auto persistence after debounce', () async {
      final initialSettings = SettingsState.initial().copyWith(autosaveEnabled: true);
      final container = ProviderContainer(
        overrides: [
          noteEditorRepositoryProvider.overrideWithValue(repository),
          settingsStateProvider.overrideWith((ref) => FakeSettingsNotifier(initialSettings)),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(noteEditorControllerProvider('draft').notifier);

      controller.updateTitle('My Title');
      controller.updateContent('My Content');

      // Wait for debounce time (800ms) plus buffer
      await Future.delayed(const Duration(milliseconds: 900));

      expect(repository.saveCount, greaterThan(0));
      expect(repository.savedNote!.title, 'My Title');
      expect(repository.savedNote!.body, 'My Content');
    });

    test('Autosave disabled: changes do not trigger auto persistence, manual save works', () async {
      final initialSettings = SettingsState.initial().copyWith(autosaveEnabled: false);
      final container = ProviderContainer(
        overrides: [
          noteEditorRepositoryProvider.overrideWithValue(repository),
          settingsStateProvider.overrideWith((ref) => FakeSettingsNotifier(initialSettings)),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(noteEditorControllerProvider('draft').notifier);

      controller.updateTitle('Manual Title');
      controller.updateContent('Manual Content');

      // Wait for duration that would trigger auto save
      await Future.delayed(const Duration(milliseconds: 900));

      expect(repository.saveCount, 0);

      // Perform manual save
      await controller.save();

      expect(repository.saveCount, 1);
      expect(repository.savedNote!.title, 'Manual Title');
      expect(repository.savedNote!.body, 'Manual Content');
    });
  });
}
