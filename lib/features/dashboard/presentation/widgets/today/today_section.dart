// lib/features/dashboard/presentation/widgets/today/today_section.dart
//
// Orynta 2.0 — Today Module Section
//
// Responsive card layout adapting across Phone (2 cols), Tablet (3 cols), and Desktop (4 cols)
// with 20dp gap between cards, 24dp internal padding, equal heights, and staggered animation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../providers/today_providers.dart';
import 'notes_summary_card.dart';
import 'planner_summary_card.dart';
import 'reminder_summary_card.dart';
import 'tasks_summary_card.dart';
import 'today_loading_card.dart';

class TodaySection extends ConsumerWidget {
  const TodaySection({super.key});

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth < 600) return 2;
    if (screenWidth < 1000) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(todayControllerProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);

    final cards = state.isLoading
        ? const [
            TodayLoadingCard(),
            TodayLoadingCard(),
            TodayLoadingCard(),
            TodayLoadingCard(),
          ]
        : [
            TasksSummaryCard(data: state.tasksSummary),
            NotesSummaryCard(data: state.notesSummary),
            ReminderSummaryCard(data: state.reminderSummary),
            PlannerSummaryCard(data: state.plannerSummary),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 4.0),
          child: Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                size: 20,
                color: context.colors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Today',
                style: context.typography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // Responsive Equal-Height Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: screenWidth < 400 ? 1.05 : 1.25,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return cards[index];
          },
        ),
      ],
    );
  }
}
