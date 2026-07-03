// lib/features/notes/presentation/controllers/notes_home_controller.dart
//
// Orynta 2.0 — Notes Home Controller

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/notes_filter.dart';
import '../../domain/models/notes_home_state.dart';
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
    loadNotes();
  }

  final NotesHomeRepository _repository;

  Future<void> loadNotes() async {
    state = state.copyWith(loading: true);
    final result = await _repository.loadNotes();
    result.fold(
      (failure) => state = state.copyWith(
        loading: false,
        error: failure.message,
      ),
      (notes) async {
        final filteredResult = await _repository.filterNotes(
          notes,
          state.selectedFilter,
        );
        filteredResult.fold(
          (failure) => state = state.copyWith(
            loading: false,
            error: failure.message,
          ),
          (filtered) => state = state.copyWith(
            loading: false,
            notes: notes,
            filteredNotes: filtered,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> refresh() => loadNotes();

  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query, loading: true);
    if (query.trim().isEmpty) {
      final filteredResult = await _repository.filterNotes(
        state.notes,
        state.selectedFilter,
      );
      filteredResult.fold(
        (failure) => state = state.copyWith(
          loading: false,
          error: failure.message,
        ),
        (filtered) => state = state.copyWith(
          loading: false,
          filteredNotes: filtered,
          error: null,
        ),
      );
      return;
    }

    final result = await _repository.searchNotes(query);
    result.fold(
      (failure) => state = state.copyWith(
        loading: false,
        error: failure.message,
      ),
      (searchResults) {
        state = state.copyWith(
          loading: false,
          filteredNotes: searchResults,
          error: null,
        );
      },
    );
  }

  Future<void> changeFilter(NotesFilter filter) async {
    state = state.copyWith(selectedFilter: filter, loading: true);
    final filteredResult = await _repository.filterNotes(
      state.notes,
      filter,
    );
    filteredResult.fold(
      (failure) => state = state.copyWith(
        loading: false,
        error: failure.message,
      ),
      (filtered) => state = state.copyWith(
        loading: false,
        filteredNotes: filtered,
        searchQuery: '',
        error: null,
      ),
    );
  }

  Future<void> clearSearch() => search('');
}
