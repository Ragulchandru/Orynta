// lib/features/notes/presentation/providers/notes_notifier.dart
//
// Single source of truth for the entire notes collection.
//
// Architecture decision — Why one notifier instead of three?
//
//   BEFORE (three notifiers):
//     ActiveNotesNotifier  ─── fetches active notes independently
//     ArchivedNotesNotifier ── fetches archived notes independently
//     TrashedNotesNotifier  ── fetches trashed notes independently
//
//     Problem: archiving a note requires invalidating TWO notifiers.
//     Tricky one-way import chain. If a third screen is added, a third
//     notifier must be kept in sync. Any missed invalidation = stale UI.
//
//   AFTER (one notifier, derived providers):
//     NotesNotifier ─── fetches ALL notes once (via GetAllNotesUseCase)
//         │
//         ├── activeNotesProvider   ─── in-memory filter + sort
//         ├── archivedNotesProvider ─── in-memory filter + sort
//         ├── trashedNotesProvider  ─── in-memory filter + sort
//         └── filteredActiveNotesProvider ─── NoteFilter applied on top
//
//     A single ref.invalidateSelf() updates EVERY view simultaneously.
//     No cross-provider invalidation. No import dependencies between views.
//
// Why GetAllNotesUseCase instead of GetActiveNotesUseCase?
//   Hive is an in-memory key-value store — reading all notes is essentially
//   the same cost as reading a filtered subset (no SQL query planner). For
//   Phase 1 (hundreds of notes), the difference is imperceptible. The
//   in-memory sort/filter in Dart is fast and clean.
//
// Mutation contract:
//   Each method returns Either<Failure, NoteEntity> to the caller (the UI).
//   On Right: ref.invalidateSelf() re-runs build() and refreshes all views.
//   On Left:  notifier state is unchanged; the UI handles the error.

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../di/notes_use_case_providers.dart';
import '../../di/notes_data_providers.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/note_status.dart';
import '../../domain/usecases/create_note_use_case.dart';

/// Single AsyncNotifier that owns the complete in-memory notes collection.
///
/// All four derived providers ([activeNotesProvider], [archivedNotesProvider],
/// [trashedNotesProvider], [filteredActiveNotesProvider]) are computed from
/// this notifier's state — they do NOT fetch independently.
///
/// The UI never calls [notesProvider] directly for display; it watches the
/// appropriate derived provider instead.
class NotesNotifier extends AsyncNotifier<List<NoteEntity>> {
  /// Loads all notes from local storage.
  ///
  /// Called automatically on first access and whenever [ref.invalidateSelf()]
  /// is called by a mutation method. Throws [Failure] on storage error,
  /// which Riverpod surfaces as [AsyncError] on all derived providers.
  @override
  Future<List<NoteEntity>> build() async {
    final result =
        await ref.read(getAllNotesUseCaseProvider)(const NoParams());
    return result.fold(
      (failure) => throw failure,
      (notes) => notes,
    );
  }

  // ─── Private Helper ──────────────────────────────────────────────────────

  /// Executes [action], refreshes on success, and returns the [Either].
  ///
  /// Consolidates the three-line pattern shared by all 9 mutation methods:
  ///   1. Await the use case result.
  ///   2. Invalidate self on [Right] to trigger a re-fetch.
  ///   3. Return the [Either] to the UI for error handling.
  Future<Either<Failure, T>> _mutate<T>(
    Future<Either<Failure, T>> Function() action,
  ) async {
    final result = await action();
    if (result.isRight()) ref.invalidateSelf();
    return result;
  }

  // ─── Write Operations ─────────────────────────────────────────────────────

  /// Creates a new note.
  ///
  /// Returns [NoteValidationFailure] if both title and body are empty.
  /// Returns [NoteStorageFailure] if the write fails.
  Future<Either<Failure, NoteEntity>> createNote(
    CreateNoteParams params,
  ) =>
      _mutate(() => ref.read(createNoteUseCaseProvider)(params));

  /// Updates an existing note's content, trimming fields and stamping updatedAt.
  ///
  /// Returns [NoteNotFoundFailure] if the note no longer exists.
  Future<Either<Failure, NoteEntity>> updateNote(NoteEntity entity) =>
      _mutate(() => ref.read(updateNoteUseCaseProvider)(entity));

  /// Soft-deletes a note by moving it to the trash.
  ///
  /// The note disappears from [activeNotesProvider] and appears in
  /// [trashedNotesProvider] after the next re-fetch — with a single
  /// [ref.invalidateSelf()] call.
  Future<Either<Failure, NoteEntity>> deleteNote(String id) =>
      _mutate(() => ref.read(deleteNoteUseCaseProvider)(id));

  /// Archives a note.
  ///
  /// After [ref.invalidateSelf()], the note vanishes from [activeNotesProvider]
  /// and appears in [archivedNotesProvider] — no cross-invalidation needed.
  Future<Either<Failure, NoteEntity>> archiveNote(String id) =>
      _mutate(() => ref.read(archiveNoteUseCaseProvider)(id));

  /// Returns an archived note to the active list.
  Future<Either<Failure, NoteEntity>> unarchiveNote(String id) =>
      _mutate(() => ref.read(unarchiveNoteUseCaseProvider)(id));

  /// Restores a trashed note to the active list.
  Future<Either<Failure, NoteEntity>> restoreNote(String id) =>
      _mutate(() => ref.read(restoreNoteUseCaseProvider)(id));

  /// Pins a note to the top of the active list.
  ///
  /// No-op (returns [Right]) if the note is already pinned.
  Future<Either<Failure, NoteEntity>> pinNote(String id) =>
      _mutate(() => ref.read(pinNoteUseCaseProvider)(id));

  /// Unpins a note.
  ///
  /// No-op (returns [Right]) if the note is already unpinned.
  Future<Either<Failure, NoteEntity>> unpinNote(String id) =>
      _mutate(() => ref.read(unpinNoteUseCaseProvider)(id));

  /// Toggles the favorite state of a note.
  Future<Either<Failure, NoteEntity>> toggleFavorite(String id) =>
      _mutate(() => ref.read(toggleFavoriteUseCaseProvider)(id));

  // ─── Bulk Operations ──────────────────────────────────────────────────────

  /// Favorites or unfavorites a batch of notes.
  Future<void> bulkToggleFavorite(Set<String> ids, bool favorite) async {
    final repo = ref.read(noteRepositoryProvider);
    for (final id in ids) {
      final noteResult = await ref.read(getNoteByIdUseCaseProvider)(id);
      await noteResult.fold(
        (failure) async {},
        (note) async {
          final updated = note.copyWith(
            isFavorite: favorite,
            updatedAt: DateTime.now(),
          );
          await repo.updateNote(updated);
        },
      );
    }
    ref.invalidateSelf();
  }

  /// Pins or unpins a batch of notes.
  Future<void> bulkTogglePin(Set<String> ids, bool pin) async {
    final repo = ref.read(noteRepositoryProvider);
    for (final id in ids) {
      final noteResult = await ref.read(getNoteByIdUseCaseProvider)(id);
      await noteResult.fold(
        (failure) async {},
        (note) async {
          final updated = note.copyWith(
            isPinned: pin,
            updatedAt: DateTime.now(),
          );
          await repo.updateNote(updated);
        },
      );
    }
    ref.invalidateSelf();
  }

  /// Archives or unarchives a batch of notes.
  Future<void> bulkToggleArchive(Set<String> ids, bool archive) async {
    final repo = ref.read(noteRepositoryProvider);
    for (final id in ids) {
      if (archive) {
        await repo.archiveNote(id);
      } else {
        await repo.unarchiveNote(id);
      }
    }
    ref.invalidateSelf();
  }

  /// Moves a batch of notes to trash (soft delete).
  Future<void> bulkDelete(Set<String> ids) async {
    final repo = ref.read(noteRepositoryProvider);
    for (final id in ids) {
      await repo.deleteNote(id);
    }
    ref.invalidateSelf();
  }

  /// Duplicates a batch of notes.
  Future<void> bulkDuplicate(Set<String> ids) async {
    final repo = ref.read(noteRepositoryProvider);
    for (final id in ids) {
      final noteResult = await ref.read(getNoteByIdUseCaseProvider)(id);
      await noteResult.fold(
        (failure) async {},
        (note) async {
          final duplicated = NoteEntity(
            id: '${DateTime.now().millisecondsSinceEpoch}_$id',
            title: note.title.isNotEmpty ? '${note.title} (Copy)' : 'Copy',
            body: note.body,
            color: note.color,
            isPinned: false,
            status: note.status,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            categoryId: note.categoryId,
            tagIds: note.tagIds,
            isFavorite: note.isFavorite,
          );
          await repo.createNote(duplicated);
        },
      );
    }
    ref.invalidateSelf();
  }

  /// Assigns a category/folder ID to a batch of notes.
  Future<void> bulkMoveToCategory(Set<String> ids, String? categoryId) async {
    final repo = ref.read(noteRepositoryProvider);
    for (final id in ids) {
      final noteResult = await ref.read(getNoteByIdUseCaseProvider)(id);
      await noteResult.fold(
        (failure) async {},
        (note) async {
          final updated = note.copyWith(
            categoryId: categoryId,
            updatedAt: DateTime.now(),
          );
          await repo.updateNote(updated);
        },
      );
    }
    ref.invalidateSelf();
  }

  /// Changes the color of a batch of notes.
  Future<void> bulkChangeColor(Set<String> ids, int? color) async {
    final repo = ref.read(noteRepositoryProvider);
    for (final id in ids) {
      final noteResult = await ref.read(getNoteByIdUseCaseProvider)(id);
      await noteResult.fold(
        (failure) async {},
        (note) async {
          final updated = note.copyWith(
            color: color,
            updatedAt: DateTime.now(),
          );
          await repo.updateNote(updated);
        },
      );
    }
    ref.invalidateSelf();
  }

  /// Adds a tag to a batch of notes.
  Future<void> bulkAddTag(Set<String> ids, String tag) async {
    final repo = ref.read(noteRepositoryProvider);
    final cleanTag = tag.trim().replaceAll('#', '');
    if (cleanTag.isEmpty) return;

    for (final id in ids) {
      final noteResult = await ref.read(getNoteByIdUseCaseProvider)(id);
      await noteResult.fold(
        (failure) async {},
        (note) async {
          final currentTags = List<String>.from(note.tagIds);
          if (!currentTags.contains(cleanTag)) {
            final newBody = note.body.isEmpty ? '#$cleanTag' : '${note.body}\n#$cleanTag';
            final newTags = [...currentTags, cleanTag];
            final updated = note.copyWith(
              body: newBody,
              tagIds: newTags,
              updatedAt: DateTime.now(),
            );
            await repo.updateNote(updated);
          }
        },
      );
    }
    ref.invalidateSelf();
  }

  /// Copies note contents to the clipboard as plain text to share.
  Future<void> bulkShare(Set<String> ids) async {
    final buffer = StringBuffer();
    for (final id in ids) {
      final noteResult = await ref.read(getNoteByIdUseCaseProvider)(id);
      noteResult.fold(
        (failure) {},
        (note) {
          buffer.writeln('---');
          if (note.title.isNotEmpty) {
            buffer.writeln('Title: ${note.title}');
          }
          buffer.writeln(note.body);
          buffer.writeln();
        },
      );
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
  }

  /// Exports selected notes as Markdown text onto the clipboard.
  Future<void> bulkExport(Set<String> ids) async {
    final buffer = StringBuffer();
    for (final id in ids) {
      final noteResult = await ref.read(getNoteByIdUseCaseProvider)(id);
      noteResult.fold(
        (failure) {},
        (note) {
          buffer.writeln('# ${note.title.isNotEmpty ? note.title : 'Untitled Note'}');
          buffer.writeln();
          buffer.writeln(note.body);
          buffer.writeln('\n---\n');
        },
      );
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
  }

  /// Permanently deletes all notes currently in the trash from storage.
  Future<void> emptyTrash() async {
    final box = ref.read(notesBoxProvider);
    final trashedKeys = box.values
        .where((m) => m.statusIndex == NoteStatus.trashed.index)
        .map((m) => m.id)
        .toList();
    await box.deleteAll(trashedKeys);
    ref.invalidateSelf();
  }

  /// Permanently erases all notes from the local storage.
  Future<void> clearAllNotes() async {
    final box = ref.read(notesBoxProvider);
    await box.clear();
    ref.invalidateSelf();
  }
}

/// The single source of truth for all notes.
///
/// Derived providers watch this — the UI watches derived providers instead.
///
/// ```dart
/// // From the UI — mutate:
/// await ref.read(notesProvider.notifier).createNote(params);
/// await ref.read(notesProvider.notifier).archiveNote(id);
///
/// // Do NOT watch this directly for display:
/// // Use activeNotesProvider, archivedNotesProvider, etc.
/// ```
final notesProvider =
    AsyncNotifierProvider<NotesNotifier, List<NoteEntity>>(
  NotesNotifier.new,
);
