// lib/features/dashboard/domain/models/recent_notes_state.dart
//
// Orynta 2.0 — Recent Notes Domain State

import 'package:flutter/foundation.dart';
import 'recent_note_summary.dart';

@immutable
class RecentNotesState {
  const RecentNotesState({
    this.isLoading = false,
    this.notes = const [],
  });

  final bool isLoading;
  final List<RecentNoteSummary> notes;

  RecentNotesState copyWith({
    bool? isLoading,
    List<RecentNoteSummary>? notes,
  }) {
    return RecentNotesState(
      isLoading: isLoading ?? this.isLoading,
      notes: notes ?? this.notes,
    );
  }
}
