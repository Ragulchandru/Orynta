// lib/features/notes/presentation/controllers/notes_home_controller.dart
//
// Orynta 2.0 — Notes Home Controller with Tag Parsing, Multi-Filters & Search Suggestions

import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/note_attachment_model.dart';
import '../../domain/models/note_summary.dart';
import '../../domain/models/notes_filter.dart';
import '../../domain/models/notes_home_state.dart';
import '../../domain/models/smart_filter.dart';
import '../../domain/models/sort_option.dart';
import '../../domain/repositories/notes_home_repository.dart';

class NotesHomeController extends StateNotifier<NotesHomeState> {
  NotesHomeController(
    this._repository,
  ) : super(
          const NotesHomeState(
            notes: [],
            filteredNotes: [],
            selectedFilter: NotesFilter.all,
            searchQuery: '',
            loading: true,
          ),
        ) {
    initialize();
  }

  final NotesHomeRepository _repository;

  Future<void> initialize() async {
    _loadRecentSearches();
    await loadNotes();
  }

  Future<void> loadNotes() async {
    state = state.copyWith(loading: true);
    final result = await _repository.loadNotes();
    result.fold(
      (failure) => state = state.copyWith(
        loading: false,
        error: failure.message,
      ),
      (notes) {
        state = state.copyWith(
          loading: false,
          notes: notes,
          error: null,
        );
        _applyFilterSortSearch();
      },
    );
  }

  void _loadRecentSearches() {
    final settingsBox = Hive.box<String>(AppStrings.settingsBoxName);
    final jsonStr = settingsBox.get('recent_searches');
    if (jsonStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        final searches = decoded.cast<String>();
        state = state.copyWith(recentSearches: searches);
      } catch (_) {}
    }
  }

  void addRecentSearch(String query) {
    if (query.trim().isEmpty) return;
    final cleanQuery = query.trim();
    final current = List<String>.from(state.recentSearches);
    
    current.remove(cleanQuery);
    current.insert(0, cleanQuery);
    
    if (current.length > 10) {
      current.removeLast();
    }
    
    state = state.copyWith(recentSearches: current);
    
    final settingsBox = Hive.box<String>(AppStrings.settingsBoxName);
    settingsBox.put('recent_searches', jsonEncode(current));
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: const []);
    final settingsBox = Hive.box<String>(AppStrings.settingsBoxName);
    settingsBox.delete('recent_searches');
  }

  void toggleSmartFilter(SmartFilter filter) {
    final active = Set<SmartFilter>.from(state.activeFilters);
    if (active.contains(filter)) {
      active.remove(filter);
    } else {
      active.add(filter);
    }
    state = state.copyWith(activeFilters: active);
    _applyFilterSortSearch();
  }

  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
    _applyFilterSortSearch();
  }

  void setSelectedTag(String? tag) {
    state = state.copyWith(selectedTag: tag);
    _applyFilterSortSearch();
  }

  void setSearchFocused(bool focused) {
    state = state.copyWith(isSearchFocused: focused);
  }

  Future<void> refresh() => loadNotes();

  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query);
    _applyFilterSortSearch();
  }

  Future<void> changeFilter(NotesFilter filter) async {
    state = state.copyWith(selectedFilter: filter);
    final active = <SmartFilter>{};
    switch (filter) {
      case NotesFilter.all:
        active.add(SmartFilter.allNotes);
      case NotesFilter.recent:
        active.add(SmartFilter.recentlyEdited);
      case NotesFilter.favorites:
        active.add(SmartFilter.favorites);
      case NotesFilter.pinned:
        active.add(SmartFilter.pinned);
      case NotesFilter.archived:
        active.add(SmartFilter.archived);
    }
    state = state.copyWith(activeFilters: active);
    _applyFilterSortSearch();
  }

  void _applyFilterSortSearch() {
    final nonNullNotes = state.notes.whereType<NoteSummary>().toList();
    var result = List<NoteSummary>.from(nonNullNotes);

    // 1. Tag Browser Selection
    final tag = state.selectedTag;
    if (tag != null) {
      result = result.where((n) => n.tagIds.contains(tag)).toList();
    }

    // 2. Combine Multiple Smart Filters
    for (final filter in state.activeFilters) {
      switch (filter) {
        case SmartFilter.allNotes:
          result = result.where((n) => !n.isArchived).toList();
        case SmartFilter.favorites:
          result = result.where((n) => n.isFavorite).toList();
        case SmartFilter.pinned:
          result = result.where((n) => n.isPinned).toList();
        case SmartFilter.archived:
          result = result.where((n) => n.isArchived).toList();
        case SmartFilter.attachments:
          result = result.where((n) => n.hasAttachments).toList();
        case SmartFilter.checklists:
          result = result.where((n) => n.hasChecklists).toList();
        case SmartFilter.recentlyEdited:
          final oneDayAgo = DateTime.now().subtract(const Duration(hours: 24));
          result = result.where((n) => n.updatedAt.isAfter(oneDayAgo)).toList();
      }
    }

    // 3. Match Search Text
    if (state.searchQuery.trim().isNotEmpty) {
      final query = state.searchQuery.trim().toLowerCase();
      result = result.where((n) {
        final matchTitle = n.title.toLowerCase().contains(query);
        final matchPreview = n.preview.toLowerCase().contains(query);
        final matchTags = n.tagIds.any((t) => t.toLowerCase().contains(query));
        
        final attachmentsBox = Hive.box<NoteAttachmentModel>(AppStrings.attachmentsBoxName);
        final matchAttachments = attachmentsBox.values.any(
          (a) => a.noteId == n.id && a.fileName.toLowerCase().contains(query),
        );
        
        return matchTitle || matchPreview || matchTags || matchAttachments;
      }).toList();
    }

    // 4. Sort Output
    switch (state.sortOption) {
      case SortOption.recentlyUpdated:
        result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case SortOption.oldest:
        result.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
      case SortOption.alphabetical:
        result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      case SortOption.color:
        result.sort((a, b) => (a.colorHex ?? '').compareTo(b.colorHex ?? ''));
      case SortOption.favorites:
        result.sort((a, b) {
          if (a.isFavorite && !b.isFavorite) return -1;
          if (!a.isFavorite && b.isFavorite) return 1;
          return b.updatedAt.compareTo(a.updatedAt);
        });
      case SortOption.pinned:
        result.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.updatedAt.compareTo(a.updatedAt);
        });
    }

    state = state.copyWith(filteredNotes: result);
  }

  Future<void> clearSearch() {
    return search('');
  }
}
