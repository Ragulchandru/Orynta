// lib/features/notes/domain/models/note_editor_state.dart
//
// Orynta 2.0 — Note Editor State

import 'package:flutter/foundation.dart';
import 'note_color.dart';

@immutable
class NoteEditorState {
  const NoteEditorState({
    this.noteId,
    this.title = '',
    this.content = '',
    this.saving = false,
    this.saved = false,
    this.dirty = false,
    this.isNewNote = false,
    this.isPinned = false,
    this.isFavorite = false,
    this.isArchived = false,
    this.color = NoteColor.defaultColor,
  });

  final String? noteId;
  final String title;
  final String content;
  final bool saving;
  final bool saved;
  final bool dirty;
  final bool isNewNote;
  final bool isPinned;
  final bool isFavorite;
  final bool isArchived;
  final NoteColor color;

  bool get isEmpty => title.trim().isEmpty && content.trim().isEmpty;

  NoteEditorState copyWith({
    String? noteId,
    String? title,
    String? content,
    bool? saving,
    bool? saved,
    bool? dirty,
    bool? isNewNote,
    bool? isPinned,
    bool? isFavorite,
    bool? isArchived,
    NoteColor? color,
  }) {
    return NoteEditorState(
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      content: content ?? this.content,
      saving: saving ?? this.saving,
      saved: saved ?? this.saved,
      dirty: dirty ?? this.dirty,
      isNewNote: isNewNote ?? this.isNewNote,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      color: color ?? this.color,
    );
  }
}
