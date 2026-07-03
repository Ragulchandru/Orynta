// lib/features/notes/presentation/controllers/editor_format_controller.dart
//
// Orynta 2.0 — Editor Formatting Actions Controller

import 'package:flutter/widgets.dart';

class EditorFormatController {
  static void toggleInlineStyle(TextEditingController controller, String marker) {
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) return;

    final start = selection.start;
    final end = selection.end;
    final isCollapsed = selection.isCollapsed;

    if (isCollapsed) {
      final startText = text.substring(0, start);
      final endText = text.substring(start);
      final newText = '$startText$marker$marker$endText';
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: start + marker.length),
      );
    } else {
      final selectedText = text.substring(start, end);
      final hasMarkers = selectedText.startsWith(marker) && selectedText.endsWith(marker);

      if (hasMarkers) {
        final stripped = selectedText.substring(marker.length, selectedText.length - marker.length);
        final startText = text.substring(0, start);
        final endText = text.substring(end);
        final newText = '$startText$stripped$endText';
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection(
            baseOffset: start,
            extentOffset: start + stripped.length,
          ),
        );
      } else {
        final wrapped = '$marker$selectedText$marker';
        final startText = text.substring(0, start);
        final endText = text.substring(end);
        final newText = '$startText$wrapped$endText';
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection(
            baseOffset: start,
            extentOffset: start + wrapped.length,
          ),
        );
      }
    }
  }

  static void toggleBlockStyle(TextEditingController controller, String prefix) {
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) return;

    final start = selection.start;
    final end = selection.end;

    int lineStart = start;
    while (lineStart > 0 && text[lineStart - 1] != '\n') {
      lineStart--;
    }

    int lineEnd = end;
    while (lineEnd < text.length && text[lineEnd] != '\n') {
      lineEnd++;
    }

    final selectedLines = text.substring(lineStart, lineEnd);
    final lines = selectedLines.split('\n');
    final updatedLines = <String>[];

    final allHavePrefix = lines.every((line) => line.startsWith(prefix));

    for (var line in lines) {
      if (allHavePrefix) {
        updatedLines.add(line.substring(prefix.length));
      } else {
        var cleanLine = line;
        if (line.startsWith('### ')) {
          cleanLine = line.substring(4);
        } else if (line.startsWith('## ')) {
          cleanLine = line.substring(3);
        } else if (line.startsWith('# ')) {
          cleanLine = line.substring(2);
        } else if (line.startsWith('- [ ] ')) {
          cleanLine = line.substring(6);
        } else if (line.startsWith('- ')) {
          cleanLine = line.substring(2);
        } else if (line.startsWith('> ')) {
          cleanLine = line.substring(2);
        } else if (line.startsWith('1. ')) {
          cleanLine = line.substring(3);
        }

        updatedLines.add('$prefix$cleanLine');
      }
    }

    final newLinesText = updatedLines.join('\n');
    final startText = text.substring(0, lineStart);
    final endText = text.substring(lineEnd);
    final newText = '$startText$newLinesText$endText';

    final difference = newLinesText.length - selectedLines.length;
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection(
        baseOffset: start,
        extentOffset: end + difference,
      ),
    );
  }

  static void insertDivider(TextEditingController controller) {
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) return;

    final start = selection.start;
    final startText = text.substring(0, start);
    final endText = text.substring(selection.end);
    final newText = '$startText\n---\n$endText';

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + 5),
    );
  }

  static void toggleCodeBlock(TextEditingController controller) {
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) return;

    final start = selection.start;
    final end = selection.end;

    if (selection.isCollapsed) {
      final startText = text.substring(0, start);
      final endText = text.substring(start);
      final newText = '$startText\n```text\n\n```\n$endText';
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: start + 9),
      );
    } else {
      final selectedText = text.substring(start, end);
      final wrapped = '\n```text\n$selectedText\n```\n';
      final startText = text.substring(0, start);
      final endText = text.substring(end);
      final newText = '$startText$wrapped$endText';
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: start + wrapped.length),
      );
    }
  }
}
