// lib/features/dashboard/data/repositories/recent_notes_repository_impl.dart
//
// Orynta 2.0 — Recent Notes Repository Implementation

import 'package:flutter/foundation.dart';
import '../../domain/models/recent_note_summary.dart';
import '../../domain/repositories/recent_notes_repository.dart';

class RecentNotesRepositoryImpl implements RecentNotesRepository {
  const RecentNotesRepositoryImpl();

  @override
  Future<List<RecentNoteSummary>> getRecentNotes({int limit = 5}) async {
    try {
      // Return empty list initially to test elegant empty state
      return const [];
    } catch (e) {
      assert(() {
        debugPrint('[RecentNotesRepositoryImpl] Error fetching notes: $e');
        return true;
      }());
      return const [];
    }
  }
}
