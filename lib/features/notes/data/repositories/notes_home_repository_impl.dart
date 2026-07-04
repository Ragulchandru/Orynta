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
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/note_attachment_model.dart';

class NotesHomeRepositoryImpl implements NotesHomeRepository {
  const NotesHomeRepositoryImpl({
    required NoteRepository noteRepository,
  }) : _noteRepository = noteRepository;

  final NoteRepository _noteRepository;

  @override
  Future<Either<Failure, List<NoteSummary>>> loadNotes() async {
    final result = await _noteRepository.getAllNotes();
    return result.map((entities) {
      final summaries = entities
          // Exclude trashed notes from Notes Home screen
          .where((e) => e.status != NoteStatus.trashed)
          .map(_mapToSummary)
          .toList();

      // Sort: Pinned notes first, then by updatedAt descending
      summaries.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });

      return summaries;
    });
  }

  @override
  Future<Either<Failure, List<NoteSummary>>> searchNotes(String query) async {
    if (query.trim().isEmpty) {
      return const Right([]);
    }
    final result = await _noteRepository.searchNotes(query);
    return result.map((entities) {
      final summaries = entities
          .where((e) => e.status != NoteStatus.trashed)
          .map(_mapToSummary)
          .toList();

      // Sort: Pinned notes first, then by updatedAt descending
      summaries.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });

      return summaries;
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
        final list = notes.where((n) => !n.isArchived).toList();
        list.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.updatedAt.compareTo(a.updatedAt);
        });
        filtered.addAll(list);
      case NotesFilter.recent:
        final list = notes.where((n) => !n.isArchived).toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        filtered.addAll(list);
      case NotesFilter.favorites:
        final list = notes.where((n) => n.isFavorite && !n.isArchived).toList();
        list.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.updatedAt.compareTo(a.updatedAt);
        });
        filtered.addAll(list);
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

    final attachmentsBox = Hive.box<NoteAttachmentModel>(AppStrings.attachmentsBoxName);
    final hasAttachments = attachmentsBox.values.any((a) => a.noteId == entity.id);
    final hasChecklists = entity.body.contains('- [ ]') || entity.body.contains('- [x]');

    return NoteSummary(
      id: entity.id,
      title: entity.title,
      preview: entity.body,
      updatedAt: entity.updatedAt,
      colorHex: hexColor,
      isPinned: entity.isPinned,
      isFavorite: entity.isFavorite,
      isArchived: entity.status == NoteStatus.archived,
      tagIds: entity.tagIds,
      hasAttachments: hasAttachments,
      hasChecklists: hasChecklists,
    );
  }
}
