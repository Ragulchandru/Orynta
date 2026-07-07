// lib/features/notes/domain/models/notes_group_by.dart

enum NotesGroupBy {
  none,
  category,
  date;

  String get label => switch (this) {
        NotesGroupBy.none => 'No Grouping',
        NotesGroupBy.category => 'Category',
        NotesGroupBy.date => 'Date',
      };
}
