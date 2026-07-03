// lib/features/dashboard/domain/repositories/recent_notes_repository.dart
//
// Orynta 2.0 — Recent Notes Repository Interface

import '../models/recent_note_summary.dart';

abstract interface class RecentNotesRepository {
  /// Fetches the latest 3 to 5 notes.
  Future<List<RecentNoteSummary>> getRecentNotes({int limit = 5});
}
