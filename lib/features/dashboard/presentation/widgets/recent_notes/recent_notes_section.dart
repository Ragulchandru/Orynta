// lib/features/dashboard/presentation/widgets/recent_notes/recent_notes_section.dart
//
// Orynta 2.0 — Recent Notes Section Component

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../providers/recent_notes_providers.dart';
import 'recent_note_card.dart';
import 'recent_notes_empty_state.dart';
import 'recent_notes_loading.dart';

class RecentNotesSection extends ConsumerWidget {
  const RecentNotesSection({super.key});

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth < 600) return 1;
    if (screenWidth < 1000) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recentNotesControllerProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Header Row
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_edu_outlined,
                    size: 20,
                    color: context.colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Notes',
                        style: context.typography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Text(
                        'Continue your latest work',
                        style: context.typography.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.push('/notes'),
                borderRadius: context.radius.borderRadiusSm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: context.typography.labelMedium.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: context.colors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Body Grid / Empty State / Loading
        if (state.isLoading)
          const RecentNotesLoading()
        else if (state.notes.isEmpty)
          const RecentNotesEmptyState()
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: screenWidth < 600 ? 2.2 : 1.5,
            ),
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];
              return RecentNoteCard(
                note: note,
                onTap: () => context.push('/notes/${note.id}'),
              );
            },
          ),
      ],
    );
  }
}
