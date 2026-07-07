// lib/features/notes/data/models/note_model.dart

import '../../domain/entities/note_entity.dart';
import '../../domain/entities/note_status.dart';

/// Represents a note in the data layer.
///
/// Hive-compatible.
/// Converts to and from [NoteEntity].
///
/// All timestamps are stored as [int] (milliseconds since Unix epoch).
/// [NoteStatus] is stored as [int] (enum index).
/// [List<String>] fields are stored using a length-prefixed string sequence.
/// These storage details are hidden inside [toEntity] and [fromEntity] —
/// the domain layer never sees them.
class NoteModel {
  NoteModel({
    required this.id,
    required this.title,
    required this.body,
    required this.color,
    required this.isPinned,
    required this.statusIndex,
    required this.createdAtMs,
    required this.updatedAtMs,
    required this.trashedAtMs,
    required this.categoryId,
    required this.tagIds,
    required this.isFavorite,
  });

  // ─── Core Fields ──────────────────────────────────────────────────────────

  /// UUID v4 — used as the Hive box key.
  final String id;

  /// Note title (may be empty string).
  final String title;

  /// Note body — plain text, multiline.
  final String body;

  /// ARGB color as integer. null = use theme default.
  final int? color;

  /// Whether the note is pinned at the top of the list.
  final bool isPinned;

  /// [NoteStatus.index] — 0 = active, 1 = archived, 2 = trashed.
  /// Stored as int because Hive cannot serialize enums directly.
  final int statusIndex;

  /// [DateTime.millisecondsSinceEpoch] for the creation timestamp.
  final int createdAtMs;

  /// [DateTime.millisecondsSinceEpoch] for the last-modified timestamp.
  final int updatedAtMs;

  /// [DateTime.millisecondsSinceEpoch] when moved to trash. null if not trashed.
  final int? trashedAtMs;

  // ─── Future-Proof Fields (Phase 2+) ───────────────────────────────────────

  /// The ID of the assigned [Category]. null = uncategorized.
  final String? categoryId;

  /// The IDs of all [Tag]s applied to this note. Empty = no tags.
  final List<String> tagIds;

  /// Whether the user has marked this note as a favorite.
  final bool isFavorite;

  // ─── Conversion ───────────────────────────────────────────────────────────

  /// Converts this [NoteModel] to a domain [NoteEntity].
  /// Called by the repository when passing data up to use cases.
  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      body: body,
      color: color,
      isPinned: isPinned,
      status: NoteStatus.values[statusIndex],
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      trashedAt: trashedAtMs != null
          ? DateTime.fromMillisecondsSinceEpoch(trashedAtMs!)
          : null,
      categoryId: categoryId,
      tagIds: tagIds,
      isFavorite: isFavorite,
    );
  }

  /// Creates a [NoteModel] from a domain [NoteEntity].
  /// Called by the data source when persisting data down to Hive.
  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      color: entity.color,
      isPinned: entity.isPinned,
      statusIndex: entity.status.index,
      createdAtMs: entity.createdAt.millisecondsSinceEpoch,
      updatedAtMs: entity.updatedAt.millisecondsSinceEpoch,
      trashedAtMs: entity.trashedAt?.millisecondsSinceEpoch,
      categoryId: entity.categoryId,
      tagIds: entity.tagIds,
      isFavorite: entity.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'color': color,
      'isPinned': isPinned,
      'statusIndex': statusIndex,
      'createdAtMs': createdAtMs,
      'updatedAtMs': updatedAtMs,
      'trashedAtMs': trashedAtMs,
      'categoryId': categoryId,
      'tagIds': tagIds,
      'isFavorite': isFavorite,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      color: json['color'] as int?,
      isPinned: json['isPinned'] as bool? ?? false,
      statusIndex: json['statusIndex'] as int? ?? 0,
      createdAtMs: json['createdAtMs'] as int,
      updatedAtMs: json['updatedAtMs'] as int,
      trashedAtMs: json['trashedAtMs'] as int?,
      categoryId: json['categoryId'] as String?,
      tagIds: List<String>.from(json['tagIds'] ?? const []),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
