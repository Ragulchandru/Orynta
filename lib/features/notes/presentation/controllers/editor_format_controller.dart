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

  static void toggleUnderlineStyle(TextEditingController controller) {
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) return;

    final start = selection.start;
    final end = selection.end;
    final isCollapsed = selection.isCollapsed;

    const openMarker = '<u>';
    const closeMarker = '</u>';

    if (isCollapsed) {
      final startText = text.substring(0, start);
      final endText = text.substring(start);
      final newText = '$startText$openMarker$closeMarker$endText';
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: start + openMarker.length),
      );
    } else {
      final selectedText = text.substring(start, end);
      final hasMarkers = selectedText.startsWith(openMarker) && selectedText.endsWith(closeMarker);

      if (hasMarkers) {
        final stripped = selectedText.substring(openMarker.length, selectedText.length - closeMarker.length);
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
        final wrapped = '$openMarker$selectedText$closeMarker';
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

  static String _stripLinePrefix(String line) {
    if (line.startsWith('### ')) {
      return line.substring(4);
    } else if (line.startsWith('## ')) {
      return line.substring(3);
    } else if (line.startsWith('# ')) {
      return line.substring(2);
    } else if (line.startsWith('- [ ] ')) {
      return line.substring(6);
    } else if (line.startsWith('- [x] ')) {
      return line.substring(6);
    } else if (line.startsWith('- ')) {
      return line.substring(2);
    } else if (line.startsWith('> ')) {
      return line.substring(2);
    } else {
      final match = RegExp(r'^\d+\. ').firstMatch(line);
      if (match != null) {
        return line.substring(match.end);
      }
    }
    return line;
  }

  static bool _hasPrefix(String line, String prefix) {
    if (prefix == '1. ') {
      return RegExp(r'^\d+\. ').hasMatch(line);
    }
    return line.startsWith(prefix);
  }

  static String _stripSpecificPrefix(String line, String prefix) {
    if (prefix == '1. ') {
      final match = RegExp(r'^\d+\. ').firstMatch(line);
      if (match != null) {
        return line.substring(match.end);
      }
    }
    if (line.startsWith(prefix)) {
      return line.substring(prefix.length);
    }
    return line;
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

    final allHavePrefix = prefix.isNotEmpty && lines.every((line) => _hasPrefix(line, prefix));

    int itemNum = 1;
    for (var line in lines) {
      if (prefix.isEmpty) {
        updatedLines.add(_stripLinePrefix(line));
      } else if (allHavePrefix) {
        updatedLines.add(_stripSpecificPrefix(line, prefix));
      } else {
        final cleanLine = _stripLinePrefix(line);
        if (prefix == '1. ') {
          updatedLines.add('$itemNum. $cleanLine');
          itemNum++;
        } else {
          updatedLines.add('$prefix$cleanLine');
        }
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
      final isWrapped = (selectedText.startsWith('```') && selectedText.endsWith('```')) ||
          (selectedText.startsWith('\n```') && selectedText.endsWith('```\n'));

      if (isWrapped) {
        var stripped = selectedText;
        if (stripped.startsWith('\n```')) {
          stripped = stripped.substring(1);
        }
        if (stripped.endsWith('\n')) {
          stripped = stripped.substring(0, stripped.length - 1);
        }
        if (stripped.startsWith('```')) {
          int newlineIdx = stripped.indexOf('\n');
          if (newlineIdx != -1) {
            stripped = stripped.substring(newlineIdx + 1);
          } else {
            stripped = stripped.substring(3);
          }
        }
        if (stripped.endsWith('```')) {
          stripped = stripped.substring(0, stripped.length - 3);
        }

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
        final wrapped = '\n```text\n$selectedText\n```\n';
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

  static void clearFormatting(TextEditingController controller) {
    // 1. Remove block styles
    toggleBlockStyle(controller, '');

    // 2. Remove inline markers within the current line / selection
    final text = controller.text;
    final selection = controller.selection;
    if (!selection.isValid) return;

    final start = selection.start;
    final end = selection.end;

    if (selection.isCollapsed) {
      int lineStart = start;
      while (lineStart > 0 && text[lineStart - 1] != '\n') {
        lineStart--;
      }
      int lineEnd = end;
      while (lineEnd < text.length && text[lineEnd] != '\n') {
        lineEnd++;
      }
      final lineText = text.substring(lineStart, lineEnd);
      final cleanedLine = lineText
          .replaceAll('**', '')
          .replaceAll('__', '')
          .replaceAll('*', '')
          .replaceAll('_', '')
          .replaceAll('~~', '')
          .replaceAll('<u>', '')
          .replaceAll('</u>', '')
          .replaceAll('`', '');
      
      final startText = text.substring(0, lineStart);
      final endText = text.substring(lineEnd);
      controller.value = TextEditingValue(
        text: '$startText$cleanedLine$endText',
        selection: TextSelection.collapsed(offset: lineStart + cleanedLine.length),
      );
    } else {
      final selectedText = text.substring(start, end);
      final cleanedText = selectedText
          .replaceAll('**', '')
          .replaceAll('__', '')
          .replaceAll('*', '')
          .replaceAll('_', '')
          .replaceAll('~~', '')
          .replaceAll('<u>', '')
          .replaceAll('</u>', '')
          .replaceAll('`', '');
      final startText = text.substring(0, start);
      final endText = text.substring(end);
      controller.value = TextEditingValue(
        text: '$startText$cleanedText$endText',
        selection: TextSelection(
          baseOffset: start,
          extentOffset: start + cleanedText.length,
        ),
      );
    }
  }
}
