// lib/features/dashboard/domain/models/notes_summary_data.dart
//
// Orynta 2.0 — Notes Summary Data Model

import 'package:flutter/foundation.dart';

@immutable
class NotesSummaryData {
  const NotesSummaryData({
    this.notesCreatedToday = 0,
    this.recentlyModifiedNoteTitle,
  });

  final int notesCreatedToday;
  final String? recentlyModifiedNoteTitle;

  bool get hasNotes => notesCreatedToday > 0 || (recentlyModifiedNoteTitle != null && recentlyModifiedNoteTitle!.isNotEmpty);
}
