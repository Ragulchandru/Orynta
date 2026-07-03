// lib/features/notes/presentation/widgets/notes_grid.dart
//
// Orynta 2.0 — Notes Grid Component

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

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: constraints.maxWidth < 600 ? 1.0 : 1.25,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return NotePreviewCard(
              note: note,
              onTap: () => onNoteTap(note),
            );
          },
        );
      },
    );
  }
}
