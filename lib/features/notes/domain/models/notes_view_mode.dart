// lib/features/notes/domain/models/notes_view_mode.dart

enum NotesViewMode {
  list,
  comfortableList,
  grid,
  compactGrid;

  String get label => switch (this) {
        NotesViewMode.list => 'List',
        NotesViewMode.comfortableList => 'Comfortable List',
        NotesViewMode.grid => 'Grid (2 col)',
        NotesViewMode.compactGrid => 'Compact Grid',
      };
}
