// lib/features/notes/presentation/widgets/search_highlight_text.dart
//
// Orynta 2.0 — Text Search Query Highlight Render Component

import 'package:flutter/material.dart';

class SearchHighlightText extends StatelessWidget {
  const SearchHighlightText({
    super.key,
    required this.text,
    required this.highlight,
    required this.style,
    required this.highlightStyle,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final String highlight;
  final TextStyle style;
  final TextStyle highlightStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    if (highlight.trim().isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final query = highlight.toLowerCase();
    final lowerText = text.toLowerCase();
    final List<InlineSpan> spans = [];

    int start = 0;
    int indexOfHighlight;

    while ((indexOfHighlight = lowerText.indexOf(query, start)) != -1) {
      if (indexOfHighlight > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, indexOfHighlight),
            style: style,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(
            indexOfHighlight,
            indexOfHighlight + query.length,
          ),
          style: highlightStyle,
        ),
      );

      start = indexOfHighlight + query.length;
    }

    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: style,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }
}
