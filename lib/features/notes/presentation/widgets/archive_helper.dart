// lib/features/notes/presentation/widgets/archive_helper.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notes_notifier.dart';

class ArchiveHelper {
  static void archiveNote({
    required BuildContext context,
    required WidgetRef ref,
    required Set<String> ids,
    String? message,
  }) {
    if (ids.isEmpty) return;

    // Trigger archive operation immediately
    ref.read(notesProvider.notifier).bulkToggleArchive(ids, true);

    final label = message ?? (ids.length == 1 ? 'Note moved to Archive' : '${ids.length} notes moved to Archive');

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(label),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              // Restore only the archived notes from this specific operation
              restoreNote(context: context, ref: ref, ids: ids);
            },
          ),
        ),
      );
  }

  static void restoreNote({
    required BuildContext context,
    required WidgetRef ref,
    required Set<String> ids,
    String? message,
  }) {
    if (ids.isEmpty) return;

    // Trigger restore operation immediately
    ref.read(notesProvider.notifier).bulkToggleArchive(ids, false);

    final label = message ?? (ids.length == 1 ? 'Note restored' : '${ids.length} notes restored');

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(label),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
