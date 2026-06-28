// lib/features/notes/domain/entities/note_entity.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import 'note_status.dart';

part 'note_entity.freezed.dart';

/// Represents a note in the domain layer.
///
/// Immutable.
/// Independent of Hive and Flutter.
///
/// This is the single source of truth for note data across the entire app.
/// Use cases produce it; the UI consumes it; the data layer converts to/from
/// [NoteModel] for persistence. Neither Hive, Firebase, nor Flutter types
/// are referenced here — ensuring the domain remains the most stable layer.
@freezed
class NoteEntity with _$NoteEntity {
  const factory NoteEntity({
    /// Universally unique identifier (UUID v4).
    /// Generated once at creation, never changes.
    required String id,

    /// The note title. May be an empty string (body-only notes are valid).
    required String title,

    /// The note body — plain text, multiline.
    /// Rich text (flutter_quill) is planned for Phase 5.
    required String body,

    /// Background color as an ARGB integer (e.g., 0xFFD0BCFF = lavender).
    ///
    /// Stored as [int] to keep the domain free of Flutter's [Color] type.
    /// The UI converts: Color(note.color ?? AppColors.noteColorDefault).
    /// null = use the theme's default card surface color.
    int? color,

    /// Whether this note is pinned at the top of the notes list.
    required bool isPinned,

    /// The lifecycle state of this note (active / archived / trashed).
    required NoteStatus status,

    /// When the note was originally created. Set once and never modified.
    required DateTime createdAt,

    /// When the note was last modified (any field change triggers an update).
    required DateTime updatedAt,

    /// When the note was moved to the trash. null if not in the trash.
    ///
    /// Drives the 30-day auto-delete countdown:
    ///   if (DateTime.now().difference(note.trashedAt!) > 30 days) → purge.
    DateTime? trashedAt,

    /// The ID of the [Category] this note belongs to.
    ///
    /// null = uncategorized. Populated in Phase 2 when Categories are
    /// implemented. Stored now to avoid a breaking schema migration later.
    String? categoryId,

    /// The IDs of all [Tag]s applied to this note.
    ///
    /// Empty list = no tags. Populated in Phase 2 when Tags are implemented.
    /// Using IDs (not embedded objects) keeps the note entity flat and avoids
    /// complex nested serialization.
    @Default([]) List<String> tagIds,

    /// Whether the user has marked this note as a favorite.
    ///
    /// Favorites are shown in a dedicated Favorites screen (Phase 3).
    /// Stored as a separate field (not a [NoteStatus] value) because a note
    /// can be both favorited AND archived simultaneously.
    @Default(false) bool isFavorite,
  }) = _NoteEntity;
}
