// lib/features/notes/domain/models/note_color.dart
//
// Orynta 2.0 — Note Color Enum & Helpers

enum NoteColor {
  defaultColor,
  blue,
  green,
  yellow,
  orange,
  red,
  purple,
  pink;

  int? get argbValue {
    switch (this) {
      case NoteColor.defaultColor:
        return null;
      case NoteColor.blue:
        return 0xFFDBEAFE;
      case NoteColor.green:
        return 0xFFD1FAE5;
      case NoteColor.yellow:
        return 0xFFFEF9C3;
      case NoteColor.orange:
        return 0xFFFFEDD5;
      case NoteColor.red:
        return 0xFFFFE4E6;
      case NoteColor.purple:
        return 0xFFEDE9FE;
      case NoteColor.pink:
        return 0xFFFCE7F3;
    }
  }

  static NoteColor fromArgb(int? argb) {
    if (argb == null) return NoteColor.defaultColor;
    for (final color in NoteColor.values) {
      if (color.argbValue == argb) return color;
    }
    return NoteColor.defaultColor;
  }
}
