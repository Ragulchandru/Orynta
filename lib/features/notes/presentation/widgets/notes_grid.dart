import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_summary.dart';
import '../../domain/models/notes_view_mode.dart';
import '../../domain/models/notes_group_by.dart';
import '../providers/notes_home_providers.dart';
import '../providers/notes_notifier.dart';
import 'note_preview_card.dart';

class NotesGrid extends ConsumerWidget {
  const NotesGrid({
    super.key,
    required this.notes,
    required this.onNoteTap,
    this.searchQuery = '',
  });

  final List<NoteSummary> notes;
  final ValueChanged<NoteSummary> onNoteTap;
  final String searchQuery;

  int _calculateCrossAxisCount(double width, NotesViewMode viewMode) {
    if (viewMode == NotesViewMode.list || viewMode == NotesViewMode.comfortableList) {
      return 1;
    }
    if (width < 600) return 2;
    if (width < 1000) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notesHomeControllerProvider);
    final viewMode = state.viewMode;
    final groupBy = state.groupBy;

    final notesAsync = ref.watch(notesProvider);
    final notesList = notesAsync.valueOrNull ?? [];

    final List<Widget> sections = [];

    if (groupBy == NotesGroupBy.none) {
      sections.add(_buildGrid(context, notes, viewMode));
    } else {
      final Map<String, List<NoteSummary>> grouped = {};
      for (final note in notes) {
        String key = 'Uncategorized';
        if (groupBy == NotesGroupBy.category) {
          String? catId;
          for (final e in notesList) {
            if (e.id == note.id) {
              catId = e.categoryId;
              break;
            }
          }
          key = catId ?? 'General';
          if (key.trim().isEmpty) {
            key = 'General';
          }
        } else if (groupBy == NotesGroupBy.date) {
          final now = DateTime.now();
          final diff = now.difference(note.updatedAt).inDays;
          if (diff == 0) {
            key = 'Today';
          } else if (diff == 1) {
            key = 'Yesterday';
          } else if (diff < 7) {
            key = 'This Week';
          } else {
            key = 'Older';
          }
        }
        grouped.putIfAbsent(key, () => []).add(note);
      }

      grouped.forEach((header, noteGroup) {
        sections.add(
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 4.0),
            child: Text(
              header,
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
          ),
        );
        sections.add(_buildGrid(context, noteGroup, viewMode));
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  Widget _buildGrid(BuildContext context, List<NoteSummary> noteList, NotesViewMode viewMode) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth, viewMode);
        final List<Widget> rows = [];

        for (int i = 0; i < noteList.length; i += crossAxisCount) {
          final chunk = noteList.sublist(
            i,
            (i + crossAxisCount) > noteList.length ? noteList.length : i + crossAxisCount,
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
                    searchQuery: searchQuery,
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

          if (i + crossAxisCount < noteList.length) {
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
