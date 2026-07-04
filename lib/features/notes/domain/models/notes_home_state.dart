// lib/features/notes/domain/models/notes_home_state.dart
//
// Orynta 2.0 — Notes Home State

import 'package:flutter/foundation.dart';
import 'note_summary.dart';
import 'notes_filter.dart';
import 'smart_filter.dart';
import 'sort_option.dart';

@immutable
class NotesHomeState {
  const NotesHomeState({
    required this.notes,
    required this.filteredNotes,
    required this.selectedFilter,
    required this.searchQuery,
    required this.loading,
    this.error,
    this.activeFilters = const {SmartFilter.allNotes},
    this.sortOption = SortOption.recentlyUpdated,
    this.selectedTag,
    this.isSearchFocused = false,
    this.recentSearches = const [],
  });

  final List<NoteSummary> notes;
  final List<NoteSummary> filteredNotes;
  final NotesFilter selectedFilter;
  final String searchQuery;
  final bool loading;
  final String? error;
  final Set<SmartFilter> activeFilters;
  final SortOption sortOption;
  final String? selectedTag;
  final bool isSearchFocused;
  final List<String> recentSearches;

  NotesHomeState copyWith({
    List<NoteSummary>? notes,
    List<NoteSummary>? filteredNotes,
    NotesFilter? selectedFilter,
    String? searchQuery,
    bool? loading,
    String? error,
    Set<SmartFilter>? activeFilters,
    SortOption? sortOption,
    String? selectedTag,
    bool? isSearchFocused,
    List<String>? recentSearches,
  }) {
    return NotesHomeState(
      notes: notes ?? this.notes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      loading: loading ?? this.loading,
      error: error,
      activeFilters: activeFilters ?? this.activeFilters,
      sortOption: sortOption ?? this.sortOption,
      selectedTag: selectedTag ?? this.selectedTag,
      isSearchFocused: isSearchFocused ?? this.isSearchFocused,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}
