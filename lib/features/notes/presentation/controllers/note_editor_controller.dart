// lib/features/notes/presentation/controllers/note_editor_controller.dart
//
// Orynta 2.0 — Note Editor Controller

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/note_status.dart';
import '../../domain/models/note_color.dart';
import '../../domain/models/note_editor_state.dart';
import '../../domain/repositories/note_editor_repository.dart';
import '../providers/notes_home_providers.dart';

class NoteEditorController extends StateNotifier<NoteEditorState> {
  NoteEditorController(
    this._repository,
    this._ref, {
    this.noteId,
  }) : super(const NoteEditorState()) {
    initialize();
  }

  final NoteEditorRepository _repository;
  final Ref _ref;
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
            isPinned: false,
            isFavorite: false,
            isArchived: false,
            color: NoteColor.defaultColor,
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
            isPinned: note.isPinned,
            isFavorite: note.isFavorite,
            isArchived: note.status == NoteStatus.archived,
            color: NoteColor.fromArgb(note.color),
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

  void togglePin(bool pinned) {
    if (state.isPinned == pinned) return;
    state = state.copyWith(isPinned: pinned, dirty: true, saved: false);
    _triggerAutosave();
  }

  void toggleFavorite(bool favorite) {
    if (state.isFavorite == favorite) return;
    state = state.copyWith(isFavorite: favorite, dirty: true, saved: false);
    _triggerAutosave();
  }

  void toggleArchive(bool archived) {
    if (state.isArchived == archived) return;
    state = state.copyWith(isArchived: archived, dirty: true, saved: false);
    _triggerAutosave();
  }

  void updateColor(NoteColor color) {
    if (state.color == color) return;
    state = state.copyWith(color: color, dirty: true, saved: false);
    _triggerAutosave();
  }

  void _triggerAutosave() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      autosave();
    });
  }

  List<String> _extractHashtags(String title, String content) {
    final text = '$title $content';
    final RegExp regex = RegExp(r'(?:^|\s)#([a-zA-Z0-9_\-]+)');
    final matches = regex.allMatches(text);
    final List<String> tags = [];
    for (final match in matches) {
      final tag = match.group(1);
      if (tag != null && tag.isNotEmpty) {
        if (!tags.contains(tag)) {
          tags.add(tag);
        }
      }
    }
    return tags;
  }

  Future<void> autosave() async {
    final currentId = state.noteId;
    if (currentId == null || !state.dirty) return;

    state = state.copyWith(saving: true);
    final tags = _extractHashtags(state.title, state.content);
    
    final result = await _repository.save(
      currentId,
      state.title,
      state.content,
      color: state.color.argbValue,
      isPinned: state.isPinned,
      isFavorite: state.isFavorite,
      isArchived: state.isArchived,
      tagIds: tags,
    );
    result.fold(
      (failure) {
        state = state.copyWith(saving: false, saved: false);
      },
      (note) {
        state = state.copyWith(saving: false, saved: true, dirty: false);
        _ref.read(notesHomeControllerProvider.notifier).loadNotes();
      },
    );
  }

  Future<void> discardEmptyDraft() async {
    final currentId = state.noteId;
    if (currentId != null && state.isEmpty) {
      await _repository.deleteDraft(currentId);
      _ref.read(notesHomeControllerProvider.notifier).loadNotes();
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
