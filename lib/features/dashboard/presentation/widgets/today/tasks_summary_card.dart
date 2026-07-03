// lib/features/dashboard/presentation/widgets/today/tasks_summary_card.dart
//
// Orynta 2.0 — Tasks Summary Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/tasks_summary_data.dart';
import 'today_card.dart';
import 'today_empty_state.dart';

class TasksSummaryCard extends StatelessWidget {
  const TasksSummaryCard({
    super.key,
    required this.data,
  });

  final TasksSummaryData data;

  @override
  Widget build(BuildContext context) {
    return TodayCard(
      title: 'Tasks',
      subtitle: 'Daily focus',
      icon: Icons.check_circle_outline_rounded,
      isEmpty: !data.hasTasks,
      body: !data.hasTasks
          ? const TodayEmptyState(
              title: "You're all caught up.",
              subtitle: 'Enjoy your free time.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      '${data.remainingTasks}',
                      style: context.typography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'remaining',
                      style: context.typography.titleMedium.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.completedTasks} of ${data.totalTasks} tasks completed',
                  style: context.typography.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
    );
  }
}
