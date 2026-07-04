// lib/features/notes/presentation/providers/note_selection_provider.dart
//
// Orynta 2.0 — State Management for Note Selection

import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteSelectionState {
  const NoteSelectionState({
    this.inSelectionMode = false,
    this.selectedIds = const {},
    this.lastSelectedId,
  });

  final bool inSelectionMode;
  final Set<String> selectedIds;
  final String? lastSelectedId;

  int get selectedCount => selectedIds.length;

  NoteSelectionState copyWith({
    bool? inSelectionMode,
    Set<String>? selectedIds,
    String? lastSelectedId,
  }) {
    return NoteSelectionState(
      inSelectionMode: inSelectionMode ?? this.inSelectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
      lastSelectedId: lastSelectedId ?? this.lastSelectedId,
    );
  }
}

class NoteSelectionNotifier extends StateNotifier<NoteSelectionState> {
  NoteSelectionNotifier() : super(const NoteSelectionState());

  void enterSelectionMode(String initialId) {
    state = NoteSelectionState(
      inSelectionMode: true,
      selectedIds: {initialId},
      lastSelectedId: initialId,
    );
  }

  void exitSelectionMode() {
    state = const NoteSelectionState();
  }

  void toggleSelection(String id) {
    final current = Set<String>.from(state.selectedIds);
    if (current.contains(id)) {
      current.remove(id);
      final newLast = current.isNotEmpty ? current.last : null;
      if (current.isEmpty) {
        state = const NoteSelectionState();
      } else {
        state = state.copyWith(selectedIds: current, lastSelectedId: newLast);
      }
    } else {
      current.add(id);
      state = state.copyWith(
        inSelectionMode: true,
        selectedIds: current,
        lastSelectedId: id,
      );
    }
  }

  void selectAll(List<String> allIds) {
    state = state.copyWith(
      inSelectionMode: true,
      selectedIds: allIds.toSet(),
      lastSelectedId: allIds.isNotEmpty ? allIds.last : null,
    );
  }

  void deselectAll() {
    state = state.copyWith(selectedIds: const {}, lastSelectedId: null);
  }

  void selectRange(List<String> allIds, String targetId) {
    if (!state.inSelectionMode || state.lastSelectedId == null) {
      enterSelectionMode(targetId);
      return;
    }

    final startIdx = allIds.indexOf(state.lastSelectedId!);
    final endIdx = allIds.indexOf(targetId);

    if (startIdx == -1 || endIdx == -1) {
      toggleSelection(targetId);
      return;
    }

    final start = startIdx < endIdx ? startIdx : endIdx;
    final end = startIdx < endIdx ? endIdx : startIdx;

    final rangeIds = allIds.sublist(start, end + 1);
    final current = Set<String>.from(state.selectedIds)..addAll(rangeIds);

    state = state.copyWith(
      selectedIds: current,
      lastSelectedId: targetId,
    );
  }
}

final noteSelectionProvider =
    StateNotifierProvider<NoteSelectionNotifier, NoteSelectionState>((ref) {
  return NoteSelectionNotifier();
});
