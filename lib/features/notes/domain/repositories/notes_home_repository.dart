// lib/features/notes/domain/repositories/notes_home_repository.dart
//
// Orynta 2.0 — Notes Home Repository Interface

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../models/note_summary.dart';
import '../models/notes_filter.dart';

abstract interface class NotesHomeRepository {
  /// Loads all notes as summaries.
  Future<Either<Failure, List<NoteSummary>>> loadNotes();

  /// Searches notes by query text.
  Future<Either<Failure, List<NoteSummary>>> searchNotes(String query);

  /// Filters note summaries according to [NotesFilter].
  Future<Either<Failure, List<NoteSummary>>> filterNotes(
    List<NoteSummary> notes,
    NotesFilter filter,
  );
}
