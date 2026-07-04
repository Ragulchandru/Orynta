// lib/features/notes/data/repositories/note_editor_repository_impl.dart
//
// Orynta 2.0 — Note Editor Repository Implementation

import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/note_status.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/note_editor_repository.dart';

class NoteEditorRepositoryImpl implements NoteEditorRepository {
  const NoteEditorRepositoryImpl({
    required NoteRepository noteRepository,
  }) : _noteRepository = noteRepository;

  final NoteRepository _noteRepository;
  static const _uuid = Uuid();

  @override
  Future<Either<Failure, NoteEntity>> createDraft() async {
    final now = DateTime.now();
    final draft = NoteEntity(
      id: _uuid.v4(),
      title: '',
      body: '',
      isPinned: false,
      status: NoteStatus.active,
      createdAt: now,
      updatedAt: now,
    );
    // Persist empty draft to Hive
    final result = await _noteRepository.createNote(draft);
    return result;
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
  }) async {
    // Check if the note already exists
    final existingResult = await _noteRepository.getNoteById(id);
    return existingResult.fold(
      (failure) async {
        // If not found, create a new one
        final now = DateTime.now();
        final newNote = NoteEntity(
          id: id,
          title: title.trim(),
          body: content.trim(),
          isPinned: isPinned ?? false,
          isFavorite: isFavorite ?? false,
          status: (isArchived ?? false) ? NoteStatus.archived : NoteStatus.active,
          color: color,
          createdAt: now,
          updatedAt: now,
        );
        return _noteRepository.createNote(newNote);
      },
      (existing) async {
        // If exists, update properties
        final updatedNote = existing.copyWith(
          title: title.trim(),
          body: content.trim(),
          isPinned: isPinned ?? existing.isPinned,
          isFavorite: isFavorite ?? existing.isFavorite,
          status: isArchived != null
              ? (isArchived ? NoteStatus.archived : NoteStatus.active)
              : existing.status,
          color: color,
          updatedAt: DateTime.now(),
        );
        return _noteRepository.updateNote(updatedNote);
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteDraft(String id) async {
    // Soft delete / remove the draft
    final result = await _noteRepository.deleteNote(id);
    return result.map((_) {});
  }

  @override
  Future<Either<Failure, NoteEntity>> getNoteById(String id) {
    return _noteRepository.getNoteById(id);
  }
}
