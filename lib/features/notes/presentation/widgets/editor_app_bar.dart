// lib/features/notes/presentation/widgets/editor_app_bar.dart
//
// Orynta 2.0 — Editor App Bar Component

import 'package:flutter/material.dart';

class EditorAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditorAppBar({
    super.key,
    required this.onBack,
    this.onShowOptions,
    this.onSave,
  });

  final VoidCallback onBack;
  final VoidCallback? onShowOptions;
  final VoidCallback? onSave;

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
        if (onSave != null)
          IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: onSave,
            tooltip: 'Save Note',
          ),
        if (onShowOptions != null)
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: onShowOptions,
            tooltip: 'Note Options',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
