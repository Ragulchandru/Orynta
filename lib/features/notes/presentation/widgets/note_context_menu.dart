// lib/features/notes/presentation/widgets/note_context_menu.dart
//
// Orynta 2.0 — Right-Click Context Menu for Desktop and Web

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/design_system.dart';
import '../../domain/models/note_summary.dart';
import '../providers/notes_notifier.dart';
import 'archive_helper.dart';

Widget _buildItem(BuildContext context, IconData icon, String label, {Color? color}) {
  final theme = context.appTheme;
  final defaultColor = theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C);

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: color ?? defaultColor, size: 18),
      const SizedBox(width: 12),
      Text(
        label,
        style: context.typography.bodyMedium.copyWith(
          color: color ?? defaultColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Future<void> showNoteContextMenu({
  required BuildContext context,
  required WidgetRef ref,
  required Offset position,
  required NoteSummary note,
}) async {
  final theme = context.appTheme;

  final result = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      position.dx + 1.0,
      position.dy + 1.0,
    ),
    color: theme.surface,
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
      side: BorderSide(color: theme.outlineVariant, width: 1.0),
    ),
    items: [
      PopupMenuItem(
        value: 'open',
        child: _buildItem(context, Icons.open_in_new_rounded, 'Open'),
      ),
      PopupMenuItem(
        value: 'favorite',
        child: _buildItem(
          context,
          note.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
          note.isFavorite ? 'Unfavorite' : 'Favorite',
          color: note.isFavorite ? theme.primary : null,
        ),
      ),
      PopupMenuItem(
        value: 'pin',
        child: _buildItem(
          context,
          note.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
          note.isPinned ? 'Unpin' : 'Pin',
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        value: 'duplicate',
        child: _buildItem(context, Icons.copy_rounded, 'Duplicate'),
      ),
      PopupMenuItem(
        value: 'share',
        child: _buildItem(context, Icons.share_rounded, 'Share'),
      ),
      PopupMenuItem(
        value: 'export',
        child: _buildItem(context, Icons.import_export_rounded, 'Export'),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        value: 'archive',
        child: _buildItem(context, Icons.archive_outlined, 'Archive'),
      ),
      PopupMenuItem(
        value: 'delete',
        child: _buildItem(
          context,
          Icons.delete_outline_rounded,
          'Move to Trash',
          color: theme.error,
        ),
      ),
    ],
  );

  if (result == null || !context.mounted) return;

  final ids = {note.id};
  switch (result) {
    case 'open':
      context.push('/notes/${note.id}');
      break;
    case 'favorite':
      ref.read(notesProvider.notifier).bulkToggleFavorite(ids, !note.isFavorite);
      break;
    case 'pin':
      ref.read(notesProvider.notifier).bulkTogglePin(ids, !note.isPinned);
      break;
    case 'duplicate':
      ref.read(notesProvider.notifier).bulkDuplicate(ids);
      break;
    case 'share':
      final messenger = ScaffoldMessenger.of(context);
      await ref.read(notesProvider.notifier).bulkShare(ids);
      messenger.showSnackBar(
        const SnackBar(content: Text('Note contents copied to clipboard!')),
      );
      break;
    case 'export':
      final messenger = ScaffoldMessenger.of(context);
      await ref.read(notesProvider.notifier).bulkExport(ids);
      messenger.showSnackBar(
        const SnackBar(content: Text('Note exported as markdown to clipboard!')),
      );
      break;
    case 'archive':
      ArchiveHelper.archiveNote(context: context, ref: ref, ids: ids);
      break;
    case 'delete':
      // Show confirmation dialog before soft-deleting
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: theme.surface,
            title: Text(
              'Move to Trash?',
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
              ),
            ),
            content: Text(
              'Move this note to the Trash? You can restore it within 30 days.',
              style: context.typography.bodyMedium.copyWith(
                color: theme.isDark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8)),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(notesProvider.notifier).bulkDelete(ids);
                  Navigator.pop(context);
                },
                child: Text(
                  'Move to Trash',
                  style: TextStyle(color: theme.error, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
      break;
  }
}
