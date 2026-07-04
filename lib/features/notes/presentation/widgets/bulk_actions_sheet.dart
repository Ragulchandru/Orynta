// lib/features/notes/presentation/widgets/bulk_actions_sheet.dart
//
// Orynta 2.0 — Bulk actions modal bottom sheet for selected notes

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_system.dart';
import '../../domain/models/note_color.dart';
import '../providers/notes_notifier.dart';

class BulkActionsSheet extends ConsumerWidget {
  const BulkActionsSheet({
    super.key,
    required this.selectedIds,
    required this.onActionCompleted,
  });

  final Set<String> selectedIds;
  final VoidCallback onActionCompleted;

  void _showAddTagDialog(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        final theme = context.appTheme;
        return AlertDialog(
          backgroundColor: theme.surface,
          title: Text(
            'Add Tag',
            style: context.typography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
            ),
          ),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Enter tag name (e.g. work)',
              hintStyle: context.typography.bodyMedium.copyWith(
                color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.outlineVariant),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.primary),
              ),
            ),
            style: context.typography.bodyMedium.copyWith(
              color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
            ),
            autofocus: true,
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
                final tag = textController.text.trim();
                if (tag.isNotEmpty) {
                  ref.read(notesProvider.notifier).bulkAddTag(selectedIds, tag);
                  Navigator.pop(context);
                  onActionCompleted();
                }
              },
              child: Text(
                'Add',
                style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMoveFolderDialog(BuildContext context, WidgetRef ref) {
    final folders = ['Work', 'Personal', 'Study', 'Inspiration'];
    showDialog(
      context: context,
      builder: (context) {
        final theme = context.appTheme;
        return AlertDialog(
          backgroundColor: theme.surface,
          title: Text(
            'Move to Folder',
            style: context.typography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: folders.map((folder) {
              return ListTile(
                title: Text(
                  folder,
                  style: TextStyle(
                    color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                  ),
                ),
                leading: Icon(Icons.folder_rounded, color: theme.primary),
                onTap: () {
                  ref.read(notesProvider.notifier).bulkMoveToCategory(selectedIds, folder);
                  Navigator.pop(context);
                  onActionCompleted();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showColorPickerDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = context.appTheme;
        return AlertDialog(
          backgroundColor: theme.surface,
          title: Text(
            'Change Label Color',
            style: context.typography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
            ),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: NoteColor.values.map((noteColor) {
                final isDefault = noteColor == NoteColor.defaultColor;
                final colorVal = isDefault
                    ? theme.notes.card
                    : Color(noteColor.argbValue!);
                return GestureDetector(
                  onTap: () {
                    ref.read(notesProvider.notifier).bulkChangeColor(selectedIds, noteColor.argbValue);
                    Navigator.pop(context);
                    onActionCompleted();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6.0),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colorVal,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.outlineVariant,
                        width: 1.5,
                      ),
                    ),
                    child: isDefault
                        ? Center(
                            child: Icon(
                              Icons.block,
                              size: 16,
                              color: theme.isDark ? Colors.white30 : Colors.black38,
                            ),
                          )
                        : null,
                  ),
                );
              }).toList(),
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
          ],
        );
      },
    );
  }

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
                onActionCompleted();
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = context.appTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: context.typography.labelSmall.copyWith(
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
          color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8),
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = context.appTheme;
    final defaultColor = theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: color ?? defaultColor, size: 20),
            const SizedBox(width: 16),
            Text(
              label,
              style: context.typography.bodyMedium.copyWith(
                color: color ?? defaultColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;

    return PremiumBottomSheet(
      title: 'Note Actions (${selectedIds.length} Selected)',
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'Quick Actions'),
              _buildActionItem(
                context: context,
                icon: Icons.star_rounded,
                label: 'Favorite All',
                onTap: () {
                  ref.read(notesProvider.notifier).bulkToggleFavorite(selectedIds, true);
                  onActionCompleted();
                },
              ),
              _buildActionItem(
                context: context,
                icon: Icons.star_border_rounded,
                label: 'Unfavorite All',
                onTap: () {
                  ref.read(notesProvider.notifier).bulkToggleFavorite(selectedIds, false);
                  onActionCompleted();
                },
              ),
              _buildActionItem(
                context: context,
                icon: Icons.push_pin_rounded,
                label: 'Pin All',
                onTap: () {
                  ref.read(notesProvider.notifier).bulkTogglePin(selectedIds, true);
                  onActionCompleted();
                },
              ),
              _buildActionItem(
                context: context,
                icon: Icons.pin_drop_outlined,
                label: 'Unpin All',
                onTap: () {
                  ref.read(notesProvider.notifier).bulkTogglePin(selectedIds, false);
                  onActionCompleted();
                },
              ),
              const Divider(height: 1),

              _buildSectionHeader(context, 'Organization'),
              _buildActionItem(
                context: context,
                icon: Icons.label_rounded,
                label: 'Add Tags',
                onTap: () => _showAddTagDialog(context, ref),
              ),
              _buildActionItem(
                context: context,
                icon: Icons.folder_rounded,
                label: 'Move to Folder',
                onTap: () => _showMoveFolderDialog(context, ref),
              ),
              _buildActionItem(
                context: context,
                icon: Icons.palette_rounded,
                label: 'Change Color',
                onTap: () => _showColorPickerDialog(context, ref),
              ),
              const Divider(height: 1),

              _buildSectionHeader(context, 'Utilities'),
              _buildActionItem(
                context: context,
                icon: Icons.copy_rounded,
                label: 'Duplicate',
                onTap: () {
                  ref.read(notesProvider.notifier).bulkDuplicate(selectedIds);
                  onActionCompleted();
                },
              ),
              _buildActionItem(
                context: context,
                icon: Icons.share_rounded,
                label: 'Share (Copy Content)',
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await ref.read(notesProvider.notifier).bulkShare(selectedIds);
                  onActionCompleted();
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Notes contents copied to clipboard!')),
                  );
                },
              ),
              _buildActionItem(
                context: context,
                icon: Icons.import_export_rounded,
                label: 'Export Markdown',
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await ref.read(notesProvider.notifier).bulkExport(selectedIds);
                  onActionCompleted();
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Notes markdown exported to clipboard!')),
                  );
                },
              ),
              const Divider(height: 1),

              _buildSectionHeader(context, 'Danger Zone'),
              _buildActionItem(
                context: context,
                icon: Icons.archive_rounded,
                label: 'Archive Notes',
                onTap: () {
                  ref.read(notesProvider.notifier).bulkToggleArchive(selectedIds, true);
                  onActionCompleted();
                },
              ),
              _buildActionItem(
                context: context,
                icon: Icons.delete_outline_rounded,
                label: 'Move to Trash',
                color: theme.error,
                onTap: () => _showDeleteConfirmation(context, ref),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
