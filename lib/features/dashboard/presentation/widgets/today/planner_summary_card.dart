// lib/features/dashboard/presentation/widgets/today/planner_summary_card.dart
//
// Orynta 2.0 — Planner Summary Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/planner_summary_data.dart';
import 'today_card.dart';
import 'today_empty_state.dart';

class PlannerSummaryCard extends StatelessWidget {
  const PlannerSummaryCard({
    super.key,
    required this.data,
  });

  final PlannerSummaryData data;

  @override
  Widget build(BuildContext context) {
    return TodayCard(
      title: 'Planner',
      subtitle: 'Schedule overview',
      icon: Icons.calendar_month_outlined,
      isEmpty: !data.hasEvents,
      body: !data.hasEvents
          ? const TodayEmptyState(
              title: 'Your schedule is clear today.',
              subtitle: 'Enjoy the extra space.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      '${data.eventsTodayCount}',
                      style: context.typography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'events today',
                      style: context.typography.titleMedium.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.upcomingEventsCount} upcoming events scheduled',
                  style: context.typography.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
    );
  }
}
