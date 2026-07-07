import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

  int _crossAxisCount(double width, NotesViewMode viewMode) {
    if (viewMode == NotesViewMode.list ||
        viewMode == NotesViewMode.comfortableList) {
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
      sections.add(_buildMasonry(context, notes, viewMode));
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
          if (key.trim().isEmpty) key = 'General';
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
        sections.add(_buildMasonry(context, noteGroup, viewMode));
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  Widget _buildMasonry(
    BuildContext context,
    List<NoteSummary> noteList,
    NotesViewMode viewMode,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = _crossAxisCount(constraints.maxWidth, viewMode);

        // List/comfortable-list modes use a plain vertical list — no masonry.
        if (cols == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final note in noteList) ...[
                NotePreviewCard(
                  note: note,
                  onTap: () => onNoteTap(note),
                  searchQuery: searchQuery,
                ),
                const SizedBox(height: 12),
              ],
            ],
          );
        }

        // Grid modes: true masonry — cards take their natural content height.
        return MasonryGridView.count(
          crossAxisCount: cols,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: noteList.length,
          itemBuilder: (context, index) {
            final note = noteList[index];
            return NotePreviewCard(
              note: note,
              onTap: () => onNoteTap(note),
              searchQuery: searchQuery,
            );
          },
        );
      },
    );
  }
}

