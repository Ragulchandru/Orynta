// lib/features/notes/presentation/controllers/rich_text_editing_controller.dart
//
// Orynta 2.0 — Custom Rich Text Editing Controller (Markdown Aware)

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class RichTextEditingController extends TextEditingController {
  RichTextEditingController({super.text});

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
      color: context.colors.textSecondary.withValues(alpha: 0.15),
    );
    final cursorPosition = selection.isValid && selection.isCollapsed
        ? selection.baseOffset
        : -1;

    final lines = text.split('\n');
    final children = <TextSpan>[];

    int currentPos = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineStart = currentPos;
      final lineEnd = lineStart + line.length;

      TextStyle lineStyle = defaultStyle;
      int markerLength = 0;
      bool isCodeBlock = false;

      if (line.startsWith('### ')) {
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
        lineStyle = defaultStyle.copyWith(
          color: context.colors.textSecondary,
          fontStyle: FontStyle.italic,
        );
        markerLength = 2;
      } else if (line.startsWith('- [ ] ') || line.startsWith('- [x] ')) {
        final isChecked = line.startsWith('- [x] ');
        markerLength = 6;
        lineStyle = defaultStyle.copyWith(
          decoration: isChecked ? TextDecoration.lineThrough : null,
          color: isChecked ? context.colors.textSecondary : context.colors.textPrimary,
        );
      } else if (line.startsWith('- ')) {
        markerLength = 2;
      } else if (RegExp(r'^\d+\. ').hasMatch(line)) {
        final match = RegExp(r'^\d+\. ').firstMatch(line)!;
        markerLength = match.end;
      } else if (line.startsWith('```')) {
        isCodeBlock = true;
        lineStyle = context.typography.bodySmall.copyWith(
          fontFamily: 'monospace',
          color: context.colors.primary,
        );
      } else if (line == '---') {
        markerLength = 3;
      }

      if (markerLength > 0) {
        final markerText = line.substring(0, markerLength);
        final contentText = line.substring(markerLength);

        final isCursorOnMarker = cursorPosition >= lineStart &&
            cursorPosition <= lineStart + markerLength;

        children.add(
          TextSpan(
            text: markerText,
            style: isCursorOnMarker
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
            isCodeBlock
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
    final faded = List<bool>.generate(len, (_) => false);

    void applyStyle(int start, int end, TextStyle Function(TextStyle) modifier) {
      for (int i = start; i < end; i++) {
        styles[i] = modifier(styles[i]);
      }
    }

    void markFaded(int start, int end) {
      for (int i = start; i < end; i++) {
        faded[i] = true;
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

      if (!isCursorOnStart) markFaded(start, contentStart);
      if (!isCursorOnEnd) markFaded(contentEnd, end);
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
      final isFaded = faded[start];
      final activeStyle = styles[start];

      spans.add(
        TextSpan(
          text: chunk,
          style: isFaded
              ? fadedStyle.copyWith(
                  fontSize: activeStyle.fontSize,
                  fontWeight: activeStyle.fontWeight,
                  fontStyle: activeStyle.fontStyle,
                )
              : activeStyle,
        ),
      );

      start = end;
    }

    return spans;
  }
}
