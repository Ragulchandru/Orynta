// lib/features/notes/data/repositories/notes_home_repository_impl.dart
//
// Orynta 2.0 — Notes Home Repository Implementation

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/note_status.dart';
import '../../domain/models/note_summary.dart';
import '../../domain/models/notes_filter.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/notes_home_repository.dart';

class NotesHomeRepositoryImpl implements NotesHomeRepository {
  const NotesHomeRepositoryImpl({
    required NoteRepository noteRepository,
  }) : _noteRepository = noteRepository;

  final NoteRepository _noteRepository;

  @override
  Future<Either<Failure, List<NoteSummary>>> loadNotes() async {
    final result = await _noteRepository.getAllNotes();
    return result.map((entities) {
      return entities
          // Exclude trashed notes from Notes Home screen
          .where((e) => e.status != NoteStatus.trashed)
          .map(_mapToSummary)
          .toList();
    });
  }

  @override
  Future<Either<Failure, List<NoteSummary>>> searchNotes(String query) async {
    if (query.trim().isEmpty) {
      return const Right([]);
    }
    final result = await _noteRepository.searchNotes(query);
    return result.map((entities) {
      return entities
          .where((e) => e.status != NoteStatus.trashed)
          .map(_mapToSummary)
          .toList();
    });
  }

  @override
  Future<Either<Failure, List<NoteSummary>>> filterNotes(
    List<NoteSummary> notes,
    NotesFilter filter,
  ) async {
    final filtered = <NoteSummary>[];

    switch (filter) {
      case NotesFilter.all:
        filtered.addAll(notes.where((n) => !n.isArchived));
      case NotesFilter.recent:
        final list = notes.where((n) => !n.isArchived).toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        filtered.addAll(list);
      case NotesFilter.favorites:
        filtered.addAll(notes.where((n) => n.isFavorite && !n.isArchived));
      case NotesFilter.pinned:
        filtered.addAll(notes.where((n) => n.isPinned && !n.isArchived));
      case NotesFilter.archived:
        filtered.addAll(notes.where((n) => n.isArchived));
    }

    return Right(filtered);
  }

  NoteSummary _mapToSummary(NoteEntity entity) {
    final hexColor = entity.color != null
        ? '#${entity.color!.toRadixString(16).padLeft(8, '0').toUpperCase()}'
        : null;

    return NoteSummary(
      id: entity.id,
      title: entity.title,
      preview: entity.body,
      updatedAt: entity.updatedAt,
      colorHex: hexColor,
      isPinned: entity.isPinned,
      isFavorite: entity.isFavorite,
      isArchived: entity.status == NoteStatus.archived,
    );
  }
}
