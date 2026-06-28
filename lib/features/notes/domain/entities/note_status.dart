// lib/features/notes/domain/entities/note_status.dart

/// The lifecycle state of a note in the domain layer.
///
/// Immutable.
/// Independent of Hive and Flutter.
///
/// A note is always in exactly one of these three states.
/// Using an enum instead of booleans makes illegal combinations
/// (e.g., archived AND trashed simultaneously) unrepresentable.
enum NoteStatus {
  /// The note is visible in the main notes list. Default state.
  active,

  /// The note has been archived. Hidden from the main list,
  /// accessible from the Archive screen.
  archived,

  /// The note has been moved to trash. Permanently deleted after 30 days.
  /// Accessible from the Trash screen until then.
  trashed,
}
