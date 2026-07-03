// lib/features/notes/presentation/widgets/editor_app_bar.dart
//
// Orynta 2.0 — Editor App Bar Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class EditorAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditorAppBar({
    super.key,
    required this.onBack,
    this.onDelete,
    this.onArchive,
    this.onFavorite,
    this.onPin,
    this.isPinned = false,
    this.isFavorite = false,
  });

  final VoidCallback onBack;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;
  final VoidCallback? onFavorite;
  final VoidCallback? onPin;
  final bool isPinned;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: onBack,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        if (onPin != null)
          IconButton(
            icon: Icon(
              isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
              color: isPinned ? context.colors.primary : context.colors.textSecondary,
            ),
            onPressed: onPin,
          ),
        if (onFavorite != null)
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFavorite ? context.colors.error : context.colors.textSecondary,
            ),
            onPressed: onFavorite,
          ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (value) {
            if (value == 'delete' && onDelete != null) {
              onDelete!();
            } else if (value == 'archive' && onArchive != null) {
              onArchive!();
            }
          },
          itemBuilder: (context) => [
            if (onArchive != null)
              const PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.archive_outlined, size: 20),
                    SizedBox(width: 10),
                    Text('Archive'),
                  ],
                ),
              ),
            if (onDelete != null)
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, size: 20),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
