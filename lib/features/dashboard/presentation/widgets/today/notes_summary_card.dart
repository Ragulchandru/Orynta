// lib/features/dashboard/presentation/widgets/today/notes_summary_card.dart
//
// Orynta 2.0 — Notes Summary Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/notes_summary_data.dart';
import 'today_card.dart';
import 'today_empty_state.dart';

class NotesSummaryCard extends StatelessWidget {
  const NotesSummaryCard({
    super.key,
    required this.data,
  });

  final NotesSummaryData data;

  @override
  Widget build(BuildContext context) {
    return TodayCard(
      title: 'Notes',
      subtitle: 'Knowledge & ideas',
      icon: Icons.article_outlined,
      isEmpty: !data.hasNotes,
      body: !data.hasNotes
          ? const TodayEmptyState(
              title: 'Nothing captured today.',
              subtitle: 'Your next idea starts here.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      '${data.notesCreatedToday}',
                      style: context.typography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'created today',
                      style: context.typography.titleMedium.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (data.recentlyModifiedNoteTitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Recent: ${data.recentlyModifiedNoteTitle}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
