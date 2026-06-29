// lib/features/notes/domain/repositories/note_repository.dart
//
// The domain layer's contract for all note-related data operations.
//
// Why does this interface live in the DOMAIN layer?
//
//   In Clean Architecture, the domain layer defines WHAT it needs, not HOW
//   it is provided. By declaring NoteRepository here (domain), use cases
//   depend on an abstraction they own — they never import anything from the
//   data layer. This is the Dependency Inversion Principle in action:
//
//     HIGH-LEVEL (domain/use cases) ──depends on──► ABSTRACTION (this file)
//     LOW-LEVEL  (data/NoteRepositoryImpl)  ◄──implements── ABSTRACTION
//
//   The data layer flows toward the domain, not the other way around.
//
// Why Either<Failure, T> instead of throwing exceptions?
//
//   1. Explicit error contract — callers MUST handle both cases; they cannot
//      accidentally ignore the failure path the way they can ignore exceptions.
//   2. Composable — Either chains cleanly with fpdart's map/flatMap/fold
//      without nested try/catch.
//   3. Testable — returning Either makes mocking trivial (just return Left or
//      Right); no need to stub `throw` behavior.
//   4. Domain-clean — use cases and UI never see raw Hive exceptions; they
//      only see typed Failure values.

import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/note_entity.dart';

/// Contract for all note data operations available to the domain layer.
///
/// Implemented by [NoteRepositoryImpl] in the data layer.
/// Consumed by use cases in [features/notes/domain/usecases/].
///
/// All methods return [Either]<[Failure], T>:
///   - [Right] T        — the operation succeeded.
///   - [Left] [Failure] — the operation failed with a typed reason.
abstract interface class NoteRepository {
  // ─── Write Operations ───────────────────────────────────────────────────

  /// Creates and persists a new note.
  ///
  /// Returns [Right] with the saved [NoteEntity] on success.
  /// Returns [Left] with [NoteStorageFailure] if the write fails.
  Future<Either<Failure, NoteEntity>> createNote(NoteEntity entity);

  /// Updates an existing note with the fields provided in [entity].
  ///
  /// Returns [Right] with the updated [NoteEntity] on success.
  /// Returns [Left] with [NoteNotFoundFailure] if the note does not exist.
  /// Returns [Left] with [NoteStorageFailure] if the write fails.
  Future<Either<Failure, NoteEntity>> updateNote(NoteEntity entity);

  /// Soft-deletes a note by moving it to the trash.
  ///
  /// The note is not removed from storage; it remains accessible via
  /// [getTrashedNotes] for 30 days before permanent purge.
  ///
  /// Returns [Right] with the trashed [NoteEntity] on success.
  /// Returns [Left] with [NoteNotFoundFailure] if the note does not exist.
  Future<Either<Failure, NoteEntity>> deleteNote(String id);

  /// Restores a trashed note back to active status.
  ///
  /// Returns [Right] with the restored [NoteEntity] on success.
  /// Returns [Left] with [NoteNotFoundFailure] if the note does not exist.
  Future<Either<Failure, NoteEntity>> restoreNote(String id);

  /// Archives a note, hiding it from the main notes list.
  ///
  /// Returns [Right] with the archived [NoteEntity] on success.
  /// Returns [Left] with [NoteNotFoundFailure] if the note does not exist.
  Future<Either<Failure, NoteEntity>> archiveNote(String id);

  /// Unarchives a note, returning it to the active notes list.
  ///
  /// Returns [Right] with the active [NoteEntity] on success.
  /// Returns [Left] with [NoteNotFoundFailure] if the note does not exist.
  Future<Either<Failure, NoteEntity>> unarchiveNote(String id);

  /// Pins a note to the top of the active notes list.
  ///
  /// Returns [Right] with the pinned [NoteEntity] on success.
  /// Returns [Left] with [NoteNotFoundFailure] if the note does not exist.
  Future<Either<Failure, NoteEntity>> pinNote(String id);

  /// Unpins a previously pinned note.
  ///
  /// Returns [Right] with the unpinned [NoteEntity] on success.
  /// Returns [Left] with [NoteNotFoundFailure] if the note does not exist.
  Future<Either<Failure, NoteEntity>> unpinNote(String id);

  /// Toggles the favorite state of a note.
  ///
  /// Returns [Right] with the updated [NoteEntity] on success.
  /// Returns [Left] with [NoteNotFoundFailure] if the note does not exist.
  Future<Either<Failure, NoteEntity>> toggleFavorite(String id);

  // ─── Read Operations ────────────────────────────────────────────────────

  /// Returns every note regardless of status.
  ///
  /// Returns [Right] with a [List]<[NoteEntity]> on success (may be empty).
  /// Returns [Left] with [NoteStorageFailure] if the read fails.
  Future<Either<Failure, List<NoteEntity>>> getAllNotes();

  /// Returns all active notes sorted by pin status then last-modified date.
  ///
  /// Returns [Right] with a [List]<[NoteEntity]> on success (may be empty).
  /// Returns [Left] with [NoteStorageFailure] if the read fails.
  Future<Either<Failure, List<NoteEntity>>> getActiveNotes();

  /// Returns all archived notes sorted by last-modified date descending.
  ///
  /// Returns [Right] with a [List]<[NoteEntity]> on success (may be empty).
  /// Returns [Left] with [NoteStorageFailure] if the read fails.
  Future<Either<Failure, List<NoteEntity>>> getArchivedNotes();

  /// Returns all trashed notes sorted by trash date descending.
  ///
  /// Returns [Right] with a [List]<[NoteEntity]> on success (may be empty).
  /// Returns [Left] with [NoteStorageFailure] if the read fails.
  Future<Either<Failure, List<NoteEntity>>> getTrashedNotes();

  /// Returns non-trashed notes matching [query] in title or body.
  ///
  /// An empty [query] returns an empty list.
  /// Returns [Right] with matching [List]<[NoteEntity]> on success.
  /// Returns [Left] with [NoteStorageFailure] if the read fails.
  Future<Either<Failure, List<NoteEntity>>> searchNotes(String query);

  /// Returns the single note identified by [id].
  ///
  /// Returns [Right] with the [NoteEntity] on success.
  /// Returns [Left] with [NoteNotFoundFailure] if the note does not exist.
  Future<Either<Failure, NoteEntity>> getNoteById(String id);
}
