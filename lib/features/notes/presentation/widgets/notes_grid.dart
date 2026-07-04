// lib/features/notes/presentation/widgets/notes_grid.dart
//
// Orynta 2.0 — Notes Grid Component (Responsive natural sizing)

import 'package:flutter/material.dart';
import '../../domain/models/note_summary.dart';
import 'note_preview_card.dart';

class NotesGrid extends StatelessWidget {
  const NotesGrid({
    super.key,
    required this.notes,
    required this.onNoteTap,
  });

  final List<NoteSummary> notes;
  final ValueChanged<NoteSummary> onNoteTap;

  int _calculateCrossAxisCount(double width) {
    if (width < 600) return 2;
    if (width < 1000) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);
        final List<Widget> rows = [];

        for (int i = 0; i < notes.length; i += crossAxisCount) {
          final chunk = notes.sublist(
            i,
            (i + crossAxisCount) > notes.length ? notes.length : i + crossAxisCount,
          );

          final rowChildren = <Widget>[];
          for (int j = 0; j < crossAxisCount; j++) {
            if (j < chunk.length) {
              final note = chunk[j];
              rowChildren.add(
                Expanded(
                  child: NotePreviewCard(
                    note: note,
                    onTap: () => onNoteTap(note),
                  ),
                ),
              );
            } else {
              rowChildren.add(const Expanded(child: SizedBox.shrink()));
            }
            if (j < crossAxisCount - 1) {
              rowChildren.add(const SizedBox(width: 20));
            }
          }

          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rowChildren,
              ),
            ),
          );

          if (i + crossAxisCount < notes.length) {
            rows.add(const SizedBox(height: 20));
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows,
        );
      },
    );
  }
}
