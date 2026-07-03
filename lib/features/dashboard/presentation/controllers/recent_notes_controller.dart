// lib/features/dashboard/presentation/controllers/recent_notes_controller.dart
//
// Orynta 2.0 — Recent Notes Controller

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/recent_notes_state.dart';
import '../../domain/repositories/recent_notes_repository.dart';

class RecentNotesController extends StateNotifier<RecentNotesState> {
  RecentNotesController(this._repository)
      : super(const RecentNotesState(isLoading: true)) {
    loadRecentNotes();
  }

  final RecentNotesRepository _repository;

  Future<void> loadRecentNotes() async {
    state = state.copyWith(isLoading: true);
    final notes = await _repository.getRecentNotes();
    state = state.copyWith(
      isLoading: false,
      notes: notes,
    );
  }

  Future<void> refresh() async {
    final notes = await _repository.getRecentNotes();
    state = state.copyWith(notes: notes);
  }
}
