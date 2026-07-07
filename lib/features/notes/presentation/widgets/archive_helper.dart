// lib/features/notes/presentation/widgets/archive_helper.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notes_notifier.dart';

class ArchiveHelper {
  static void archiveWithUndo({
    required BuildContext context,
    required WidgetRef ref,
    required Set<String> ids,
    String? message,
  }) {
    if (ids.isEmpty) return;

    // Trigger archive operation immediately
    ref.read(notesProvider.notifier).bulkToggleArchive(ids, true);

    final messenger = ScaffoldMessenger.of(context);
    // Dismiss any existing SnackBar first
    messenger.clearSnackBars();

    final label = message ?? (ids.length == 1 ? 'Note moved to Archive' : '${ids.length} notes moved to Archive');

    messenger.showSnackBar(
      SnackBar(
        content: Text(label),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // Restore only the archived notes from this specific operation
            ref.read(notesProvider.notifier).bulkToggleArchive(ids, false);
          },
        ),
      ),
    );
  }
}
