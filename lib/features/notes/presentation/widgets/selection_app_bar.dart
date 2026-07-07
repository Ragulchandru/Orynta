// lib/features/notes/presentation/widgets/selection_app_bar.dart
//
// Orynta 2.0 — Dynamic Top App Bar for Note Selection Mode

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_system.dart';
import '../providers/notes_notifier.dart';
import 'bulk_actions_sheet.dart';
import 'archive_helper.dart';

class SelectionAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SelectionAppBar({
    super.key,
    required this.selectedIds,
    required this.onCancel,
  });

  final Set<String> selectedIds;
  final VoidCallback onCancel;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = context.appTheme;
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
            'Move the selected ${selectedIds.length} notes to the Trash? You can restore them within 30 days.',
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
                ref.read(notesProvider.notifier).bulkDelete(selectedIds);
                Navigator.pop(context);
                onCancel();
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
  }

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BulkActionsSheet(
        selectedIds: selectedIds,
        onActionCompleted: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final notes = ref.watch(notesProvider).valueOrNull ?? [];
    final selectedNotes = notes.where((n) => selectedIds.contains(n.id)).toList();
    
    final allFavorite = selectedNotes.isNotEmpty && selectedNotes.every((n) => n.isFavorite);
    final allPinned = selectedNotes.isNotEmpty && selectedNotes.every((n) => n.isPinned);

    return AppBar(
      backgroundColor: theme.surface,
      elevation: 2.0,
      shadowColor: theme.isDark ? Colors.black54 : Colors.grey.withValues(alpha: 0.1),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.close_rounded, color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C)),
        onPressed: onCancel,
      ),
      title: Text(
        '${selectedIds.length} Selected',
        style: context.typography.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            allFavorite ? Icons.star_rounded : Icons.star_border_rounded,
            color: allFavorite ? theme.primary : (theme.isDark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68)),
          ),
          tooltip: allFavorite ? 'Unfavorite' : 'Favorite',
          onPressed: () {
            ref.read(notesProvider.notifier).bulkToggleFavorite(selectedIds, !allFavorite);
            onCancel();
          },
        ),
        IconButton(
          icon: Icon(
            allPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
            color: allPinned ? theme.primary : (theme.isDark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68)),
          ),
          tooltip: allPinned ? 'Unpin' : 'Pin',
          onPressed: () {
            ref.read(notesProvider.notifier).bulkTogglePin(selectedIds, !allPinned);
            onCancel();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.archive_outlined,
            color: theme.isDark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68),
          ),
          onPressed: () {
            ArchiveHelper.archiveNote(context: context, ref: ref, ids: selectedIds);
            onCancel();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.delete_outline_rounded,
            color: theme.error,
          ),
          tooltip: 'Move to Trash',
          onPressed: () => _showDeleteConfirmation(context, ref),
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
          ),
          tooltip: 'More Actions',
          onPressed: () => _showMoreActions(context),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
