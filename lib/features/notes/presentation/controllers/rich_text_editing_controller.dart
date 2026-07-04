// lib/features/notes/presentation/controllers/rich_text_editing_controller.dart
//
// Orynta 2.0 — Custom Rich Text Editing Controller (Markdown Aware with List Helpers)

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
      while (lineStart > 0 && newValue.text[lineStart - 1] != '\n') {
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
    final fadedStyle = defaultStyle.copyWith(
      color: context.colors.textSecondary.withValues(alpha: 0.18),
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
          lineStyle = context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          );
          markerLength = 4;
        } else if (line.startsWith('## ')) {
          lineStyle = context.typography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          );
          markerLength = 3;
        } else if (line.startsWith('# ')) {
          lineStyle = context.typography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: context.colors.textPrimary,
          );
          markerLength = 2;
        } else if (line.startsWith('> ')) {
          isQuote = true;
          markerLength = 2;
          lineStyle = defaultStyle.copyWith(
            color: context.colors.textSecondary,
            fontStyle: FontStyle.italic,
          );
        } else if (line.startsWith('- ')) {
          markerLength = 2;
        } else if (RegExp(r'^\d+\. ').hasMatch(line)) {
          final match = RegExp(r'^\d+\. ').firstMatch(line)!;
          markerLength = match.end;
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
            fadedStyle,
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
              style: fadedStyle.copyWith(
                fontSize: lineStyle.fontSize,
                fontStyle: FontStyle.normal,
              ),
            ),
          );
        }

        children.addAll(
          _parseInlineFormatting(
            line.substring(markerLength),
            lineStyle,
            fadedStyle,
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
              style: fadedStyle.copyWith(
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
      } else if (markerLength > 0) {
        final markerText = line.substring(0, markerLength);
        final contentText = line.substring(markerLength);

        children.add(
          TextSpan(
            text: markerText,
            style: isCursorOnLine
                ? lineStyle.copyWith(
                    color: context.colors.primary.withValues(alpha: 0.6),
                  )
                : fadedStyle.copyWith(
                    fontSize: lineStyle.fontSize,
                  ),
          ),
        );

        children.addAll(
          _parseInlineFormatting(
            contentText,
            lineStyle,
            fadedStyle,
            lineStart + markerLength,
            cursorPosition,
            context,
          ),
        );
      } else {
        children.addAll(
          _parseInlineFormatting(
            line,
            isCodeBlockLine
                ? lineStyle
                : line.startsWith('```') || line.endsWith('```')
                    ? lineStyle
                    : defaultStyle,
            fadedStyle,
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
    TextStyle fadedStyle,
    int lineStartOffset,
    int cursorPosition,
    BuildContext context,
  ) {
    if (text.isEmpty) return [];

    final len = text.length;
    final styles = List<TextStyle>.generate(len, (_) => baseStyle);
    final faded = List<int>.generate(len, (_) => 0); // 0 = normal, 1 = faded (15%), 2 = hidden (0%)

    void applyStyle(int start, int end, TextStyle Function(TextStyle) modifier) {
      for (int i = start; i < end; i++) {
        styles[i] = modifier(styles[i]);
      }
    }

    void markFaded(int start, int end, {bool hide = false}) {
      for (int i = start; i < end; i++) {
        faded[i] = hide ? 2 : 1;
      }
    }

    // 1. Underline <u>...</u>
    final underlineRegex = RegExp(r'<u>(.*?)</u>');
    for (final match in underlineRegex.allMatches(text)) {
      final start = match.start;
      final end = match.end;
      final contentStart = start + 3;
      final contentEnd = end - 4;

      applyStyle(contentStart, contentEnd, (s) => s.copyWith(decoration: TextDecoration.underline));

      final isCursorOnStart = cursorPosition >= lineStartOffset + start &&
          cursorPosition <= lineStartOffset + contentStart;
      final isCursorOnEnd = cursorPosition >= lineStartOffset + contentEnd &&
          cursorPosition <= lineStartOffset + end;

      if (!isCursorOnStart) markFaded(start, contentStart, hide: true);
      if (!isCursorOnEnd) markFaded(contentEnd, end, hide: true);
    }

    // 2. Bold **...**
    final boldRegex = RegExp(r'\*\*(.*?)\*\*');
    for (final match in boldRegex.allMatches(text)) {
      final start = match.start;
      final end = match.end;
      final contentStart = start + 2;
      final contentEnd = end - 2;

      applyStyle(contentStart, contentEnd, (s) => s.copyWith(fontWeight: FontWeight.bold));

      final isCursorOnStart = cursorPosition >= lineStartOffset + start &&
          cursorPosition <= lineStartOffset + contentStart;
      final isCursorOnEnd = cursorPosition >= lineStartOffset + contentEnd &&
          cursorPosition <= lineStartOffset + end;

      if (!isCursorOnStart) markFaded(start, contentStart);
      if (!isCursorOnEnd) markFaded(contentEnd, end);
    }

    // 3. Italic *...*
    final italicRegex = RegExp(r'\*(.*?)\*');
    for (final match in italicRegex.allMatches(text)) {
      final start = match.start;
      final end = match.end;
      final contentStart = start + 1;
      final contentEnd = end - 1;

      if (start > 0 && text[start - 1] == '*' || end < len && text[end] == '*') {
        continue;
      }

      applyStyle(contentStart, contentEnd, (s) => s.copyWith(fontStyle: FontStyle.italic));

      final isCursorOnStart = cursorPosition >= lineStartOffset + start &&
          cursorPosition <= lineStartOffset + contentStart;
      final isCursorOnEnd = cursorPosition >= lineStartOffset + contentEnd &&
          cursorPosition <= lineStartOffset + end;

      if (!isCursorOnStart) markFaded(start, contentStart);
      if (!isCursorOnEnd) markFaded(contentEnd, end);
    }

    // 4. Strikethrough ~~...~~
    final strikeRegex = RegExp(r'~~(.*?)~~');
    for (final match in strikeRegex.allMatches(text)) {
      final start = match.start;
      final end = match.end;
      final contentStart = start + 2;
      final contentEnd = end - 2;

      applyStyle(contentStart, contentEnd, (s) => s.copyWith(decoration: TextDecoration.lineThrough));

      final isCursorOnStart = cursorPosition >= lineStartOffset + start &&
          cursorPosition <= lineStartOffset + contentStart;
      final isCursorOnEnd = cursorPosition >= lineStartOffset + contentEnd &&
          cursorPosition <= lineStartOffset + end;

      if (!isCursorOnStart) markFaded(start, contentStart);
      if (!isCursorOnEnd) markFaded(contentEnd, end);
    }

    // 5. Inline Code `...`
    final codeRegex = RegExp(r'`(.*?)`');
    for (final match in codeRegex.allMatches(text)) {
      final start = match.start;
      final end = match.end;
      final contentStart = start + 1;
      final contentEnd = end - 1;

      applyStyle(
        contentStart,
        contentEnd,
        (s) => s.copyWith(
          fontFamily: 'monospace',
          backgroundColor: context.colors.outlineVariant.withValues(alpha: 0.3),
          color: context.colors.primary,
        ),
      );

      final isCursorOnStart = cursorPosition >= lineStartOffset + start &&
          cursorPosition <= lineStartOffset + contentStart;
      final isCursorOnEnd = cursorPosition >= lineStartOffset + contentEnd &&
          cursorPosition <= lineStartOffset + end;

      if (!isCursorOnStart) markFaded(start, contentStart);
      if (!isCursorOnEnd) markFaded(contentEnd, end);
    }

    final spans = <TextSpan>[];
    int start = 0;
    while (start < len) {
      int end = start + 1;
      while (end < len && styles[end] == styles[start] && faded[end] == faded[start]) {
        end++;
      }

      final chunk = text.substring(start, end);
      final fadeType = faded[start];
      final activeStyle = styles[start];

      TextStyle spanStyle = activeStyle;
      if (fadeType == 1) {
        spanStyle = fadedStyle.copyWith(
          fontSize: activeStyle.fontSize,
          fontWeight: activeStyle.fontWeight,
          fontStyle: activeStyle.fontStyle,
        );
      } else if (fadeType == 2) {
        spanStyle = activeStyle.copyWith(
          color: Colors.transparent,
          fontSize: 0.01,
        );
      }

      spans.add(
        TextSpan(
          text: chunk,
          style: spanStyle,
        ),
      );

      start = end;
    }

    return spans;
  }
}
