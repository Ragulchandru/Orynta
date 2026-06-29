// lib/features/notes/di/notes_use_case_providers.dart
//
// Use case dependency injection for the Notes feature.
//
// Every provider in this file:
//   1. Reads [noteRepositoryProvider] from notes_data_providers.dart.
//   2. Constructs the corresponding use case via constructor injection.
//   3. Returns the use case instance.
//
// This file contains ZERO business logic — it is purely a wiring layer.
// All logic lives inside the use case classes themselves.
//
// Naming convention: [useCaseName]Provider
//   e.g., createNoteUseCaseProvider, getActiveNotesUseCaseProvider

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/usecases/archive_note_use_case.dart';
import '../domain/usecases/create_note_use_case.dart';
import '../domain/usecases/delete_note_use_case.dart';
import '../domain/usecases/get_active_notes_use_case.dart';
import '../domain/usecases/get_all_notes_use_case.dart';
import '../domain/usecases/get_archived_notes_use_case.dart';
import '../domain/usecases/get_note_by_id_use_case.dart';
import '../domain/usecases/get_trashed_notes_use_case.dart';
import '../domain/usecases/pin_note_use_case.dart';
import '../domain/usecases/restore_note_use_case.dart';
import '../domain/usecases/search_notes_use_case.dart';
import '../domain/usecases/toggle_favorite_use_case.dart';
import '../domain/usecases/unarchive_note_use_case.dart';
import '../domain/usecases/unpin_note_use_case.dart';
import '../domain/usecases/update_note_use_case.dart';
import 'notes_data_providers.dart';

// ─── Write Use Cases ──────────────────────────────────────────────────────────

/// Provides [CreateNoteUseCase] — validates, trims, and persists a new note.
final createNoteUseCaseProvider = Provider<CreateNoteUseCase>(
  (ref) => CreateNoteUseCase(ref.watch(noteRepositoryProvider)),
  name: 'createNoteUseCaseProvider',
);

/// Provides [UpdateNoteUseCase] — trims and persists changes to an existing note.
final updateNoteUseCaseProvider = Provider<UpdateNoteUseCase>(
  (ref) => UpdateNoteUseCase(ref.watch(noteRepositoryProvider)),
  name: 'updateNoteUseCaseProvider',
);

/// Provides [DeleteNoteUseCase] — soft-deletes a note by moving it to trash.
final deleteNoteUseCaseProvider = Provider<DeleteNoteUseCase>(
  (ref) => DeleteNoteUseCase(ref.watch(noteRepositoryProvider)),
  name: 'deleteNoteUseCaseProvider',
);

/// Provides [RestoreNoteUseCase] — restores a trashed note to active status.
final restoreNoteUseCaseProvider = Provider<RestoreNoteUseCase>(
  (ref) => RestoreNoteUseCase(ref.watch(noteRepositoryProvider)),
  name: 'restoreNoteUseCaseProvider',
);

/// Provides [ArchiveNoteUseCase] — moves a note to the archive.
final archiveNoteUseCaseProvider = Provider<ArchiveNoteUseCase>(
  (ref) => ArchiveNoteUseCase(ref.watch(noteRepositoryProvider)),
  name: 'archiveNoteUseCaseProvider',
);

/// Provides [UnarchiveNoteUseCase] — moves an archived note back to active.
final unarchiveNoteUseCaseProvider = Provider<UnarchiveNoteUseCase>(
  (ref) => UnarchiveNoteUseCase(ref.watch(noteRepositoryProvider)),
  name: 'unarchiveNoteUseCaseProvider',
);

/// Provides [PinNoteUseCase] — pins a note; no-op if already pinned.
final pinNoteUseCaseProvider = Provider<PinNoteUseCase>(
  (ref) => PinNoteUseCase(ref.watch(noteRepositoryProvider)),
  name: 'pinNoteUseCaseProvider',
);

/// Provides [UnpinNoteUseCase] — unpins a note; no-op if already unpinned.
final unpinNoteUseCaseProvider = Provider<UnpinNoteUseCase>(
  (ref) => UnpinNoteUseCase(ref.watch(noteRepositoryProvider)),
  name: 'unpinNoteUseCaseProvider',
);

/// Provides [ToggleFavoriteUseCase] — toggles a note's favorite state.
final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>(
  (ref) => ToggleFavoriteUseCase(ref.watch(noteRepositoryProvider)),
  name: 'toggleFavoriteUseCaseProvider',
);

// ─── Read Use Cases ───────────────────────────────────────────────────────────

/// Provides [GetAllNotesUseCase] — returns every note regardless of status.
final getAllNotesUseCaseProvider = Provider<GetAllNotesUseCase>(
  (ref) => GetAllNotesUseCase(ref.watch(noteRepositoryProvider)),
  name: 'getAllNotesUseCaseProvider',
);

/// Provides [GetActiveNotesUseCase] — returns active notes, pinned first.
final getActiveNotesUseCaseProvider = Provider<GetActiveNotesUseCase>(
  (ref) => GetActiveNotesUseCase(ref.watch(noteRepositoryProvider)),
  name: 'getActiveNotesUseCaseProvider',
);

/// Provides [GetArchivedNotesUseCase] — returns archived notes.
final getArchivedNotesUseCaseProvider = Provider<GetArchivedNotesUseCase>(
  (ref) => GetArchivedNotesUseCase(ref.watch(noteRepositoryProvider)),
  name: 'getArchivedNotesUseCaseProvider',
);

/// Provides [GetTrashedNotesUseCase] — returns trashed notes.
final getTrashedNotesUseCaseProvider = Provider<GetTrashedNotesUseCase>(
  (ref) => GetTrashedNotesUseCase(ref.watch(noteRepositoryProvider)),
  name: 'getTrashedNotesUseCaseProvider',
);

/// Provides [SearchNotesUseCase] — searches non-trashed notes by query.
final searchNotesUseCaseProvider = Provider<SearchNotesUseCase>(
  (ref) => SearchNotesUseCase(ref.watch(noteRepositoryProvider)),
  name: 'searchNotesUseCaseProvider',
);

/// Provides [GetNoteByIdUseCase] — returns a single note by ID.
final getNoteByIdUseCaseProvider = Provider<GetNoteByIdUseCase>(
  (ref) => GetNoteByIdUseCase(ref.watch(noteRepositoryProvider)),
  name: 'getNoteByIdUseCaseProvider',
);
