// lib/features/notes/domain/repositories/note_editor_repository.dart
//
// Orynta 2.0 — Note Editor Repository Interface

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/note_entity.dart';

abstract interface class NoteEditorRepository {
  /// Creates a local draft note.
  Future<Either<Failure, NoteEntity>> createDraft();

  /// Saves or updates the note with the given title and content.
  Future<Either<Failure, NoteEntity>> save(
    String id,
    String title,
    String content,
  );

  /// Deletes the note draft if discarded.
  Future<Either<Failure, void>> deleteDraft(String id);

  /// Retrieves an existing note by ID.
  Future<Either<Failure, NoteEntity>> getNoteById(String id);
}
