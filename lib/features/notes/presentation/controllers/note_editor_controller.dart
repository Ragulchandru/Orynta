// lib/features/notes/presentation/controllers/note_editor_controller.dart
//
// Orynta 2.0 — Note Editor Controller

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/note_editor_state.dart';
import '../../domain/repositories/note_editor_repository.dart';

class NoteEditorController extends StateNotifier<NoteEditorState> {
  NoteEditorController(
    this._repository, {
    this.noteId,
  }) : super(const NoteEditorState()) {
    initialize();
  }

  final NoteEditorRepository _repository;
  final String? noteId;
  Timer? _debounceTimer;

  Future<void> initialize() async {
    state = state.copyWith(saving: false, saved: false, dirty: false);
    if (noteId == null) {
      // Create Mode
      final result = await _repository.createDraft();
      result.fold(
        (failure) {},
        (note) {
          state = NoteEditorState(
            noteId: note.id,
            title: '',
            content: '',
            isNewNote: true,
          );
        },
      );
    } else {
      // Edit Mode
      final result = await _repository.getNoteById(noteId!);
      result.fold(
        (failure) {},
        (note) {
          state = NoteEditorState(
            noteId: note.id,
            title: note.title,
            content: note.body,
            isNewNote: false,
            saved: true,
          );
        },
      );
    }
  }

  void updateTitle(String title) {
    if (state.title == title) return;
    state = state.copyWith(title: title, dirty: true, saved: false);
    _triggerAutosave();
  }

  void updateContent(String content) {
    if (state.content == content) return;
    state = state.copyWith(content: content, dirty: true, saved: false);
    _triggerAutosave();
  }

  void _triggerAutosave() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      autosave();
    });
  }

  Future<void> autosave() async {
    final currentId = state.noteId;
    if (currentId == null || !state.dirty) return;

    state = state.copyWith(saving: true);
    final result = await _repository.save(currentId, state.title, state.content);
    result.fold(
      (failure) {
        state = state.copyWith(saving: false, saved: false);
      },
      (note) {
        state = state.copyWith(saving: false, saved: true, dirty: false);
      },
    );
  }

  Future<void> discardEmptyDraft() async {
    final currentId = state.noteId;
    if (currentId != null && state.isEmpty) {
      await _repository.deleteDraft(currentId);
    }
  }

  Future<void> finishEditing() async {
    _debounceTimer?.cancel();
    if (state.dirty) {
      await autosave();
    }
    await discardEmptyDraft();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
