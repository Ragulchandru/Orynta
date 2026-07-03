// lib/features/notes/domain/models/rich_text_selection.dart
//
// Orynta 2.0 — Rich Text Selection State

import 'package:flutter/foundation.dart';
import 'text_format_type.dart';

@immutable
class RichTextSelection {
  const RichTextSelection({
    required this.selectionStart,
    required this.selectionEnd,
    this.activeFormats = const {},
  });

  final int selectionStart;
  final int selectionEnd;
  final Set<TextFormatType> activeFormats;

  bool get isCollapsed => selectionStart == selectionEnd;

  int get start => selectionStart < selectionEnd ? selectionStart : selectionEnd;
  int get end => selectionStart < selectionEnd ? selectionEnd : selectionStart;

  RichTextSelection copyWith({
    int? selectionStart,
    int? selectionEnd,
    Set<TextFormatType>? activeFormats,
  }) {
    return RichTextSelection(
      selectionStart: selectionStart ?? this.selectionStart,
      selectionEnd: selectionEnd ?? this.selectionEnd,
      activeFormats: activeFormats ?? this.activeFormats,
    );
  }
}
