// lib/features/notes/presentation/controllers/rich_text_editing_controller.dart
//
// Orynta 2.0 — Custom Rich Text Editing Controller (Premium Markdown Aware with Live Preview Hiding)

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class RichTextEditingController extends TextEditingController {
  RichTextEditingController({super.text});

  @override
  set value(TextEditingValue newValue) {
    // 1. Detect if Enter was pressed
    final isEnterPressed = newValue.text.length == text.length + 1 &&
        newValue.selection.isCollapsed &&
        newValue.selection.baseOffset > 0 &&
        newValue.text[newValue.selection.baseOffset - 1] == '\n';

    if (isEnterPressed) {
      final pos = newValue.selection.baseOffset;
      int lineEnd = pos - 1;
      int lineStart = lineEnd;
      while (lineStart > 0 && newValue.text[lineStart - 1] != '\n') {
        lineStart--;
      }

      final previousLine = newValue.text.substring(lineStart, lineEnd);

      if (previousLine == '- [ ]' || previousLine == '- [x]') {
        // Exit Checklist
        final prefixText = newValue.text.substring(0, lineStart);
        final suffixText = newValue.text.substring(pos);
        newValue = TextEditingValue(
          text: '$prefixText$suffixText',
          selection: TextSelection.collapsed(offset: lineStart),
        );
      } else if (previousLine.startsWith('- [ ] ') || previousLine.startsWith('- [x] ')) {
        // Continue Checklist
        final prefixText = newValue.text.substring(0, pos);
        final suffixText = newValue.text.substring(pos);
        newValue = TextEditingValue(
          text: '$prefixText- [ ] $suffixText',
          selection: TextSelection.collapsed(offset: pos + 6),
        );
      } else if (previousLine == '-' || previousLine == '- ') {
        // Exit Bullet list
        final prefixText = newValue.text.substring(0, lineStart);
        final suffixText = newValue.text.substring(pos);
        newValue = TextEditingValue(
          text: '$prefixText$suffixText',
          selection: TextSelection.collapsed(offset: lineStart),
        );
      } else if (previousLine.startsWith('- ')) {
        // Continue Bullet list
        final prefixText = newValue.text.substring(0, pos);
        final suffixText = newValue.text.substring(pos);
        newValue = TextEditingValue(
          text: '$prefixText- $suffixText',
          selection: TextSelection.collapsed(offset: pos + 2),
        );
      } else if (RegExp(r'^\d+\. $').hasMatch(previousLine) || RegExp(r'^\d+\.$').hasMatch(previousLine)) {
        // Exit Numbered list
        final prefixText = newValue.text.substring(0, lineStart);
        final suffixText = newValue.text.substring(pos);
        newValue = TextEditingValue(
          text: '$prefixText$suffixText',
          selection: TextSelection.collapsed(offset: lineStart),
        );
      } else if (RegExp(r'^(\d+)\. ').hasMatch(previousLine)) {
        // Continue Numbered list
        final match = RegExp(r'^(\d+)\. ').firstMatch(previousLine)!;
        final nextNum = int.parse(match.group(1)!) + 1;
        final prefixText = newValue.text.substring(0, pos);
        final suffixText = newValue.text.substring(pos);
        final insertText = '$nextNum. ';
        newValue = TextEditingValue(
          text: '$prefixText$insertText$suffixText',
          selection: TextSelection.collapsed(offset: pos + insertText.length),
        );
      }
    }

    // 2. Detect if Backspace was pressed on an empty prefix line
    final isBackspacePressed = newValue.text.length == text.length - 1 &&
        newValue.selection.isCollapsed;

    if (isBackspacePressed) {
      final pos = newValue.selection.baseOffset;
      int lineStart = pos;
      while (lineStart > 0 && newValue.text[newValue.selection.baseOffset] != '\n' && newValue.text[lineStart - 1] != '\n') {
        lineStart--;
      }
      int lineEnd = pos;
      while (lineEnd < newValue.text.length && newValue.text[lineEnd] != '\n') {
        lineEnd++;
      }
      final currentLine = newValue.text.substring(lineStart, lineEnd);

      if (currentLine == '- [ ]' ||
          currentLine == '- [x]' ||
          currentLine == '-' ||
          currentLine == '- ' ||
          RegExp(r'^\d+\.$').hasMatch(currentLine) ||
          RegExp(r'^\d+\. $').hasMatch(currentLine)) {
        // Clear list/checklist formatting
        final prefixText = newValue.text.substring(0, lineStart);
        final suffixText = newValue.text.substring(lineEnd);
        newValue = TextEditingValue(
          text: '$prefixText$suffixText',
          selection: TextSelection.collapsed(offset: lineStart),
        );
      }
    }

    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final defaultStyle = style ?? context.typography.bodyMedium.copyWith(
      color: context.colors.textPrimary,
    );
    final cursorPosition = selection.isValid && selection.isCollapsed
        ? selection.baseOffset
        : -1;

    final lines = text.split('\n');
    final children = <InlineSpan>[];

    int currentPos = 0;
    bool inCodeBlock = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineStart = currentPos;
      final lineEnd = lineStart + line.length;

      TextStyle lineStyle = defaultStyle;
      int markerLength = 0;
      bool isCodeBlockLine = false;
      bool isChecklist = false;
      bool isChecked = false;
      bool isDivider = false;
      bool isQuote = false;

      // Code block toggles
      if (line.startsWith('```')) {
        inCodeBlock = !inCodeBlock;
        isCodeBlockLine = true;
        lineStyle = context.typography.bodySmall.copyWith(
          fontFamily: 'monospace',
          color: context.colors.primary,
          backgroundColor: context.colors.outlineVariant.withValues(alpha: 0.25),
        );
        markerLength = 3;
      } else if (inCodeBlock) {
        isCodeBlockLine = true;
        lineStyle = context.typography.bodySmall.copyWith(
          fontFamily: 'monospace',
          color: context.colors.textPrimary,
          backgroundColor: context.colors.outlineVariant.withValues(alpha: 0.25),
        );
      } else {
        // Normal block parsing
        if (line.startsWith('- [ ] ') || line.startsWith('- [x] ')) {
          isChecklist = true;
          isChecked = line.startsWith('- [x] ');
          markerLength = 6;
          lineStyle = defaultStyle.copyWith(
            decoration: isChecked ? TextDecoration.lineThrough : null,
            color: isChecked ? context.colors.textSecondary : context.colors.textPrimary,
          );
        } else if (line.startsWith('### ')) {
          markerLength = 4;
          lineStyle = context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          );
        } else if (line.startsWith('## ')) {
          markerLength = 3;
          lineStyle = context.typography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          );
        } else if (line.startsWith('# ')) {
          markerLength = 2;
          lineStyle = context.typography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: context.colors.textPrimary,
          );
        } else if (line.startsWith('> ')) {
          isQuote = true;
          markerLength = 2;
          lineStyle = defaultStyle.copyWith(
            color: context.colors.textSecondary,
            fontStyle: FontStyle.italic,
          );
        } else if (line.startsWith('- ')) {
          // bullet list checked later
        } else if (RegExp(r'^\d+\. ').hasMatch(line)) {
          // numbered list checked later
        } else if (line == '---') {
          isDivider = true;
          markerLength = 3;
        }
      }

      final isCursorOnLine = cursorPosition >= lineStart && cursorPosition <= lineEnd;

      if (isChecklist) {
        children.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () {
                final currentText = text;
                final newMarker = isChecked ? '- [ ] ' : '- [x] ';
                final newText = currentText.substring(0, lineStart) +
                    newMarker +
                    currentText.substring(lineStart + 6);
                value = TextEditingValue(
                  text: newText,
                  selection: selection,
                );
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Icon(
                    isChecked
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    size: 20,
                    color: isChecked
                        ? context.colors.primary
                        : context.colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );

        children.addAll(
          _parseInlineFormatting(
            line.substring(markerLength),
            lineStyle,
            lineStart + markerLength,
            cursorPosition,
            context,
          ),
        );
      } else if (isQuote) {
        children.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              margin: const EdgeInsets.only(right: 8.0, left: 4.0),
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );

        if (isCursorOnLine) {
          children.add(
            TextSpan(
              text: '> ',
              style: defaultStyle.copyWith(
                color: context.colors.primary.withValues(alpha: 0.6),
                fontSize: lineStyle.fontSize,
                fontStyle: FontStyle.normal,
              ),
            ),
          );
        } else {
          children.add(
            TextSpan(
              text: '> ',
              style: lineStyle.copyWith(
                color: Colors.transparent,
                fontSize: 0.01,
              ),
            ),
          );
        }

        children.addAll(
          _parseInlineFormatting(
            line.substring(markerLength),
            lineStyle,
            lineStart + markerLength,
            cursorPosition,
            context,
          ),
        );
      } else if (isDivider) {
        if (isCursorOnLine) {
          children.add(
            TextSpan(
              text: '---',
              style: defaultStyle.copyWith(
                color: context.colors.primary.withValues(alpha: 0.6),
                fontSize: defaultStyle.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          children.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: SizedBox(
                width: 10000,
                child: Divider(
                  height: 24,
                  thickness: 1.5,
                  color: context.colors.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
          );
        }
      } else if (line.startsWith('- ') && !isCodeBlockLine) {
        if (isCursorOnLine) {
          children.add(
            TextSpan(
              text: '- ',
              style: lineStyle.copyWith(
                color: context.colors.primary.withValues(alpha: 0.6),
              ),
            ),
          );
        } else {
          children.add(
            TextSpan(
              text: '- ',
              style: lineStyle.copyWith(
                color: Colors.transparent,
                fontSize: 0.01,
              ),
            ),
          );
          children.add(
            TextSpan(
              text: '• ',
              style: lineStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
          );
        }

        children.addAll(
          _parseInlineFormatting(
            line.substring(2),
            lineStyle,
            lineStart + 2,
            cursorPosition,
            context,
          ),
        );
      } else if (RegExp(r'^\d+\. ').hasMatch(line) && !isCodeBlockLine) {
        final match = RegExp(r'^\d+\. ').firstMatch(line)!;
        final prefixText = line.substring(0, match.end);
        final contentText = line.substring(match.end);

        children.add(
          TextSpan(
            text: prefixText,
            style: lineStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
        );

        children.addAll(
          _parseInlineFormatting(
            contentText,
            lineStyle,
            lineStart + match.end,
            cursorPosition,
            context,
          ),
        );
      } else if (line.startsWith('# ') || line.startsWith('## ') || line.startsWith('### ')) {
        final markerText = line.substring(0, markerLength);
        final contentText = line.substring(markerLength);

        if (isCursorOnLine) {
          children.add(
            TextSpan(
              text: markerText,
              style: lineStyle.copyWith(
                color: context.colors.primary.withValues(alpha: 0.6),
              ),
            ),
          );
        } else {
          children.add(
            TextSpan(
              text: markerText,
              style: lineStyle.copyWith(
                color: Colors.transparent,
                fontSize: 0.01,
              ),
            ),
          );
        }

        children.addAll(
          _parseInlineFormatting(
            contentText,
            lineStyle,
            lineStart + markerLength,
            cursorPosition,
            context,
          ),
        );
      } else if (line.startsWith('```')) {
        if (isCursorOnLine) {
          children.add(
            TextSpan(
              text: line,
              style: lineStyle,
            ),
          );
        } else {
          children.add(
            TextSpan(
              text: line,
              style: lineStyle.copyWith(
                color: Colors.transparent,
                fontSize: 0.01,
              ),
            ),
          );
        }
      } else {
        children.addAll(
          _parseInlineFormatting(
            line,
            isCodeBlockLine
                ? lineStyle
                : defaultStyle,
            lineStart,
            cursorPosition,
            context,
          ),
        );
      }

      if (i < lines.length - 1) {
        children.add(const TextSpan(text: '\n'));
      }
      currentPos = lineEnd + 1;
    }

    return TextSpan(children: children);
  }

  List<TextSpan> _parseInlineFormatting(
    String text,
    TextStyle baseStyle,
    int lineStartOffset,
    int cursorPosition,
    BuildContext context,
  ) {
    if (text.isEmpty) return [];

    final len = text.length;
    final isBold = List<bool>.generate(len, (_) => false);
    final isItalic = List<bool>.generate(len, (_) => false);
    final isUnderline = List<bool>.generate(len, (_) => false);
    final isStrike = List<bool>.generate(len, (_) => false);
    final isCode = List<bool>.generate(len, (_) => false);

    final markerLengthMap = <int, int>{};
    final faded = List<int>.generate(len, (_) => 0); // 0 = normal, 1 = hide completely

    void applyStyle(int start, int end, String markerType) {
      for (int k = start; k < end; k++) {
        if (markerType == '**' || markerType == '__') isBold[k] = true;
        if (markerType == '*' || markerType == '_') isItalic[k] = true;
        if (markerType == '~~') isStrike[k] = true;
        if (markerType == '`') isCode[k] = true;
        if (markerType == '<u>') isUnderline[k] = true;
      }
    }

    final stack = <MapEntry<String, int>>[];
    int i = 0;

    while (i < len) {
      String? matchedMarker;

      if (text.startsWith('</u>', i)) {
        matchedMarker = '</u>';
      } else if (text.startsWith('<u>', i)) {
        matchedMarker = '<u>';
      } else if (text.startsWith('**', i)) {
        matchedMarker = '**';
      } else if (text.startsWith('__', i)) {
        matchedMarker = '__';
      } else if (text.startsWith('~~', i)) {
        matchedMarker = '~~';
      } else if (text.startsWith('*', i)) {
        matchedMarker = '*';
      } else if (text.startsWith('_', i)) {
        matchedMarker = '_';
      } else if (text.startsWith('`', i)) {
        matchedMarker = '`';
      }

      if (matchedMarker != null) {
        final mLen = matchedMarker.length;
        int openIdx = -1;

        if (matchedMarker == '</u>') {
          openIdx = stack.lastIndexWhere((entry) => entry.key == '<u>');
        } else {
          openIdx = stack.lastIndexWhere((entry) => entry.key == matchedMarker);
        }

        if (openIdx != -1) {
          final openEntry = stack[openIdx];
          final openStart = openEntry.value;
          final contentStart = openStart + openEntry.key.length;
          final contentEnd = i;

          applyStyle(contentStart, contentEnd, openEntry.key);

          markerLengthMap[openStart] = openEntry.key.length;
          markerLengthMap[i] = mLen;

          final isCursorOnStart = cursorPosition >= lineStartOffset + openStart &&
              cursorPosition <= lineStartOffset + contentStart;
          final isCursorOnEnd = cursorPosition >= lineStartOffset + contentEnd &&
              cursorPosition <= lineStartOffset + i + mLen;

          if (!isCursorOnStart) {
            for (int k = openStart; k < contentStart; k++) {
              faded[k] = 1;
            }
          }
          if (!isCursorOnEnd) {
            for (int k = i; k < i + mLen; k++) {
              faded[k] = 1;
            }
          }

          stack.removeRange(openIdx, stack.length);
          i += mLen;
        } else {
          if (matchedMarker != '</u>') {
            stack.add(MapEntry(matchedMarker, i));
          }
          i += mLen;
        }
      } else {
        i++;
      }
    }

    final spans = <TextSpan>[];
    int start = 0;
    while (start < len) {
      if (markerLengthMap.containsKey(start)) {
        final mLen = markerLengthMap[start]!;
        final markerText = text.substring(start, start + mLen);
        final isFaded = faded[start] == 1;

        TextStyle markerStyle = baseStyle;
        if (isFaded) {
          markerStyle = baseStyle.copyWith(
            color: Colors.transparent,
            fontSize: 0.01,
          );
        } else {
          markerStyle = baseStyle.copyWith(
            color: context.colors.primary.withValues(alpha: 0.6),
          );
        }

        spans.add(
          TextSpan(
            text: markerText,
            style: markerStyle,
          ),
        );

        start += mLen;
      } else {
        int end = start + 1;
        while (end < len &&
            !markerLengthMap.containsKey(end) &&
            isBold[end] == isBold[start] &&
            isItalic[end] == isItalic[start] &&
            isUnderline[end] == isUnderline[start] &&
            isStrike[end] == isStrike[start] &&
            isCode[end] == isCode[start]) {
          end++;
        }

        final chunk = text.substring(start, end);
        
        TextStyle chunkStyle = baseStyle;
        if (isBold[start]) chunkStyle = chunkStyle.copyWith(fontWeight: FontWeight.bold);
        if (isItalic[start]) chunkStyle = chunkStyle.copyWith(fontStyle: FontStyle.italic);
        if (isUnderline[start]) chunkStyle = chunkStyle.copyWith(decoration: TextDecoration.underline);
        if (isStrike[start]) {
          final dec = chunkStyle.decoration == TextDecoration.underline
              ? TextDecoration.combine([TextDecoration.underline, TextDecoration.lineThrough])
              : TextDecoration.lineThrough;
          chunkStyle = chunkStyle.copyWith(decoration: dec);
        }
        if (isCode[start]) {
          chunkStyle = chunkStyle.copyWith(
            fontFamily: 'monospace',
            backgroundColor: context.colors.outlineVariant.withValues(alpha: 0.3),
            color: context.colors.primary,
          );
        }

        spans.add(
          TextSpan(
            text: chunk,
            style: chunkStyle,
          ),
        );

        start = end;
      }
    }

    return spans;
  }
}
