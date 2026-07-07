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

  /// Executes [action] with optimistic in-memory update and handles revert on failure.
  Future<Either<Failure, NoteEntity>> _updateInMemoryAndExecute(
    String id,
    Future<Either<Failure, NoteEntity>> Function() action,
    NoteEntity Function(NoteEntity) updateFn,
  ) async {
    final currentState = state.valueOrNull;
    NoteEntity? originalNote;
    if (currentState != null) {
      final index = currentState.indexWhere((n) => n.id == id);
      if (index != -1) {
        originalNote = currentState[index];
        final updatedList = List<NoteEntity>.from(currentState);
        updatedList[index] = updateFn(originalNote);
        state = AsyncData(updatedList);
      }
    }

    final result = await action();
    
    return result.fold(
      (failure) {
        // Revert on failure
        if (currentState != null && originalNote != null) {
          final index = currentState.indexWhere((n) => n.id == id);
          if (index != -1) {
            final updatedList = List<NoteEntity>.from(state.valueOrNull ?? currentState);
            updatedList[index] = originalNote;
            state = AsyncData(updatedList);
          }
        }
        return Left(failure);
      },
      (updatedNote) {
        // Apply returned note on success
        final current = state.valueOrNull;
        if (current != null) {
          final index = current.indexWhere((n) => n.id == id);
          if (index != -1) {
            final updatedList = List<NoteEntity>.from(current);
            updatedList[index] = updatedNote;
            state = AsyncData(updatedList);
          }
        }
        return Right(updatedNote);
      },
    );
  }

  // ─── Write Operations ─────────────────────────────────────────────────────

  /// Creates a new note.
  ///
  /// Returns [NoteValidationFailure] if both title and body are empty.
  /// Returns [NoteStorageFailure] if the write fails.
  Future<Either<Failure, NoteEntity>> createNote(
    CreateNoteParams params,
  ) async {
    final result = await ref.read(createNoteUseCaseProvider)(params);
    return result.fold(
      (failure) => Left(failure),
      (note) {
        final current = state.valueOrNull;
        if (current != null) {
          state = AsyncData([...current, note]);
        }
        return Right(note);
      },
    );
  }

  /// Updates an existing note's content, trimming fields and stamping updatedAt.
  ///
  /// Returns [NoteNotFoundFailure] if the note no longer exists.
  Future<Either<Failure, NoteEntity>> updateNote(NoteEntity entity) async {
    final currentState = state.valueOrNull;
    NoteEntity? originalNote;
    if (currentState != null) {
      final index = currentState.indexWhere((n) => n.id == entity.id);
      if (index != -1) {
        originalNote = currentState[index];
        final updatedList = List<NoteEntity>.from(currentState);
        updatedList[index] = entity;
        state = AsyncData(updatedList);
      }
    }

    final result = await ref.read(updateNoteUseCaseProvider)(entity);
    return result.fold(
      (failure) {
        if (currentState != null && originalNote != null) {
          final index = currentState.indexWhere((n) => n.id == entity.id);
          if (index != -1) {
            final updatedList = List<NoteEntity>.from(state.valueOrNull ?? currentState);
            updatedList[index] = originalNote;
            state = AsyncData(updatedList);
          }
        }
        return Left(failure);
      },
      (note) {
        final current = state.valueOrNull;
        if (current != null) {
          final index = current.indexWhere((n) => n.id == note.id);
          if (index != -1) {
            final updatedList = List<NoteEntity>.from(current);
            updatedList[index] = note;
            state = AsyncData(updatedList);
          }
        }
        return Right(note);
      },
    );
  }

  /// Soft-deletes a note by moving it to the trash.
  ///
  /// The note disappears from [activeNotesProvider] and appears in
  /// [trashedNotesProvider] after the next re-fetch — with a single
  /// [ref.invalidateSelf()] call.
  Future<Either<Failure, NoteEntity>> deleteNote(String id) =>
      _updateInMemoryAndExecute(
        id,
        () => ref.read(deleteNoteUseCaseProvider)(id),
        (note) => note.copyWith(
          status: NoteStatus.trashed,
          trashedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

  /// Archives a note.
  ///
  /// After [ref.invalidateSelf()], the note vanishes from [activeNotesProvider]
  /// and appears in [archivedNotesProvider] — no cross-invalidation needed.
  Future<Either<Failure, NoteEntity>> archiveNote(String id) =>
      _updateInMemoryAndExecute(
        id,
        () => ref.read(archiveNoteUseCaseProvider)(id),
        (note) => note.copyWith(
          status: NoteStatus.archived,
          updatedAt: DateTime.now(),
        ),
      );

  /// Returns an archived note to the active list.
  Future<Either<Failure, NoteEntity>> unarchiveNote(String id) =>
      _updateInMemoryAndExecute(
        id,
        () => ref.read(unarchiveNoteUseCaseProvider)(id),
        (note) => note.copyWith(
          status: NoteStatus.active,
          updatedAt: DateTime.now(),
        ),
      );

  /// Restores a trashed note to the active list.
  Future<Either<Failure, NoteEntity>> restoreNote(String id) =>
      _updateInMemoryAndExecute(
        id,
        () => ref.read(restoreNoteUseCaseProvider)(id),
        (note) => note.copyWith(
          status: NoteStatus.active,
          trashedAt: null,
          updatedAt: DateTime.now(),
        ),
      );

  /// Pins a note to the top of the active list.
  ///
  /// No-op (returns [Right]) if the note is already pinned.
  Future<Either<Failure, NoteEntity>> pinNote(String id) =>
      _updateInMemoryAndExecute(
        id,
        () => ref.read(pinNoteUseCaseProvider)(id),
        (note) => note.copyWith(
          isPinned: true,
          updatedAt: DateTime.now(),
        ),
      );

  /// Unpins a note.
  ///
  /// No-op (returns [Right]) if the note is already unpinned.
  Future<Either<Failure, NoteEntity>> unpinNote(String id) =>
      _updateInMemoryAndExecute(
        id,
        () => ref.read(unpinNoteUseCaseProvider)(id),
        (note) => note.copyWith(
          isPinned: false,
          updatedAt: DateTime.now(),
        ),
      );

  /// Toggles the favorite state of a note.
  Future<Either<Failure, NoteEntity>> toggleFavorite(String id) =>
      _updateInMemoryAndExecute(
        id,
        () => ref.read(toggleFavoriteUseCaseProvider)(id),
        (note) => note.copyWith(
          isFavorite: !note.isFavorite,
          updatedAt: DateTime.now(),
        ),
      );

  // ─── Bulk Operations ──────────────────────────────────────────────────────

  /// Favorites or unfavorites a batch of notes.
  Future<void> bulkToggleFavorite(Set<String> ids, bool favorite) async {
    final currentState = state.valueOrNull;
    if (currentState != null) {
      final updatedList = List<NoteEntity>.from(currentState);
      for (final id in ids) {
        final index = updatedList.indexWhere((n) => n.id == id);
        if (index != -1) {
          updatedList[index] = updatedList[index].copyWith(
            isFavorite: favorite,
            updatedAt: DateTime.now(),
          );
        }
      }
      state = AsyncData(updatedList);
    }

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
  }

  /// Pins or unpins a batch of notes.
  Future<void> bulkTogglePin(Set<String> ids, bool pin) async {
    final currentState = state.valueOrNull;
    if (currentState != null) {
      final updatedList = List<NoteEntity>.from(currentState);
      for (final id in ids) {
        final index = updatedList.indexWhere((n) => n.id == id);
        if (index != -1) {
          updatedList[index] = updatedList[index].copyWith(
            isPinned: pin,
            updatedAt: DateTime.now(),
          );
        }
      }
      state = AsyncData(updatedList);
    }

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
  }

  /// Archives or unarchives a batch of notes.
  Future<void> bulkToggleArchive(Set<String> ids, bool archive) async {
    final currentState = state.valueOrNull;
    if (currentState != null) {
      final updatedList = List<NoteEntity>.from(currentState);
      for (final id in ids) {
        final index = updatedList.indexWhere((n) => n.id == id);
        if (index != -1) {
          updatedList[index] = updatedList[index].copyWith(
            status: archive ? NoteStatus.archived : NoteStatus.active,
            updatedAt: DateTime.now(),
          );
        }
      }
      state = AsyncData(updatedList);
    }

    final repo = ref.read(noteRepositoryProvider);
    for (final id in ids) {
      if (archive) {
        await repo.archiveNote(id);
      } else {
        await repo.unarchiveNote(id);
      }
    }
  }

  /// Moves a batch of notes to trash (soft delete).
  Future<void> bulkDelete(Set<String> ids) async {
    final currentState = state.valueOrNull;
    if (currentState != null) {
      final updatedList = List<NoteEntity>.from(currentState);
      for (final id in ids) {
        final index = updatedList.indexWhere((n) => n.id == id);
        if (index != -1) {
          updatedList[index] = updatedList[index].copyWith(
            status: NoteStatus.trashed,
            trashedAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      }
      state = AsyncData(updatedList);
    }

    final repo = ref.read(noteRepositoryProvider);
    for (final id in ids) {
      await repo.deleteNote(id);
    }
  }

  /// Duplicates a batch of notes.
  Future<void> bulkDuplicate(Set<String> ids) async {
    final repo = ref.read(noteRepositoryProvider);
    final List<NoteEntity> duplicatedNotes = [];
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
          duplicatedNotes.add(duplicated);
        },
      );
    }
    if (duplicatedNotes.isNotEmpty) {
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData([...current, ...duplicatedNotes]);
      }
    }
  }

  /// Assigns a category/folder ID to a batch of notes.
  Future<void> bulkMoveToCategory(Set<String> ids, String? categoryId) async {
    final currentState = state.valueOrNull;
    if (currentState != null) {
      final updatedList = List<NoteEntity>.from(currentState);
      for (final id in ids) {
        final index = updatedList.indexWhere((n) => n.id == id);
        if (index != -1) {
          updatedList[index] = updatedList[index].copyWith(
            categoryId: categoryId,
            updatedAt: DateTime.now(),
          );
        }
      }
      state = AsyncData(updatedList);
    }

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
  }

  /// Changes the color of a batch of notes.
  Future<void> bulkChangeColor(Set<String> ids, int? color) async {
    final currentState = state.valueOrNull;
    if (currentState != null) {
      final updatedList = List<NoteEntity>.from(currentState);
      for (final id in ids) {
        final index = updatedList.indexWhere((n) => n.id == id);
        if (index != -1) {
          updatedList[index] = updatedList[index].copyWith(
            color: color,
            updatedAt: DateTime.now(),
          );
        }
      }
      state = AsyncData(updatedList);
    }

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
  }

  /// Adds a tag to a batch of notes.
  Future<void> bulkAddTag(Set<String> ids, String tag) async {
    final cleanTag = tag.trim().replaceAll('#', '');
    if (cleanTag.isEmpty) return;

    final currentState = state.valueOrNull;
    if (currentState != null) {
      final updatedList = List<NoteEntity>.from(currentState);
      for (final id in ids) {
        final index = updatedList.indexWhere((n) => n.id == id);
        if (index != -1) {
          final note = updatedList[index];
          final currentTags = List<String>.from(note.tagIds);
          if (!currentTags.contains(cleanTag)) {
            final newBody = note.body.isEmpty ? '#$cleanTag' : '${note.body}\n#$cleanTag';
            final newTags = [...currentTags, cleanTag];
            updatedList[index] = note.copyWith(
              body: newBody,
              tagIds: newTags,
              updatedAt: DateTime.now(),
            );
          }
        }
      }
      state = AsyncData(updatedList);
    }

    final repo = ref.read(noteRepositoryProvider);
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
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.where((n) => n.status != NoteStatus.trashed).toList());
    }
  }

  /// Permanently erases all notes from the local storage.
  Future<void> clearAllNotes() async {
    final box = ref.read(notesBoxProvider);
    await box.clear();
    state = const AsyncData([]);
  }

  /// Helper to synchronously update a note in memory.
  void addOrUpdateNoteInMemory(NoteEntity note) {
    final current = state.valueOrNull;
    if (current != null) {
      final index = current.indexWhere((n) => n.id == note.id);
      final updated = List<NoteEntity>.from(current);
      if (index != -1) {
        updated[index] = note;
      } else {
        updated.add(note);
      }
      state = AsyncData(updated);
    }
  }

  /// Helper to synchronously remove a note from memory.
  void removeNoteInMemory(String id) {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.where((n) => n.id != id).toList());
    }
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
