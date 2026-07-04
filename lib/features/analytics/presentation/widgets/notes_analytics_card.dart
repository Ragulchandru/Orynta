// lib/features/analytics/presentation/widgets/notes_analytics_card.dart
//
// Orynta 2.0 — Notes analytics card

import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class NotesAnalyticsCard extends StatelessWidget {
  const NotesAnalyticsCard({
    super.key,
    required this.totalNotes,
    required this.favoriteNotes,
    required this.archivedNotes,
    required this.notesCreatedToday,
  });

  final int totalNotes;
  final int favoriteNotes;
  final int archivedNotes;
  final int notesCreatedToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget buildItem(String label, String value, IconData icon) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.secondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.secondary,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes Analytics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Metadata summaries and text capture volumes',
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: AppSizes.md),
            buildItem('Total Active Notes', '$totalNotes', Icons.description_outlined),
            buildItem('Starred Notes', '$favoriteNotes', Icons.star_rounded),
            buildItem('Archived Notes', '$archivedNotes', Icons.archive_outlined),
            buildItem('Captured Today', '$notesCreatedToday', Icons.today_rounded),
          ],
        ),
      ),
    );
  }
}
