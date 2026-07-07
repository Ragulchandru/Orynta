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
    final state = ref.watch(todayStateProvider);
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

        // Responsive Equal-Height Grid using IntrinsicHeight Rows
        _buildResponsiveGrid(cards, crossAxisCount),
      ],
    );
  }

  Widget _buildResponsiveGrid(List<Widget> cards, int crossAxisCount) {
    final List<Widget> rows = [];
    for (int i = 0; i < cards.length; i += crossAxisCount) {
      final chunk = cards.sublist(
        i,
        (i + crossAxisCount) > cards.length ? cards.length : i + crossAxisCount,
      );

      final rowChildren = <Widget>[];
      for (int j = 0; j < crossAxisCount; j++) {
        if (j < chunk.length) {
          rowChildren.add(Expanded(child: chunk[j]));
        } else {
          rowChildren.add(const Expanded(child: SizedBox.shrink()));
        }
        if (j < crossAxisCount - 1) {
          rowChildren.add(const SizedBox(width: 20));
        }
      }

      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rowChildren,
          ),
        ),
      );

      if (i + crossAxisCount < cards.length) {
        rows.add(const SizedBox(height: 20));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
