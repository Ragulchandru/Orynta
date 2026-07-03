// lib/features/notes/domain/models/notes_home_state.dart
//
// Orynta 2.0 — Notes Home State

import 'package:flutter/foundation.dart';
import 'note_summary.dart';
import 'notes_filter.dart';

@immutable
class NotesHomeState {
  const NotesHomeState({
    required this.notes,
    required this.filteredNotes,
    required this.selectedFilter,
    required this.searchQuery,
    required this.loading,
    this.error,
  });

  final List<NoteSummary> notes;
  final List<NoteSummary> filteredNotes;
  final NotesFilter selectedFilter;
  final String searchQuery;
  final bool loading;
  final String? error;

  NotesHomeState copyWith({
    List<NoteSummary>? notes,
    List<NoteSummary>? filteredNotes,
    NotesFilter? selectedFilter,
    String? searchQuery,
    bool? loading,
    String? error,
  }) {
    return NotesHomeState(
      notes: notes ?? this.notes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
