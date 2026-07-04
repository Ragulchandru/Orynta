// lib/features/analytics/presentation/widgets/planner_analytics_card.dart
//
// Orynta 2.0 — Planner analytics card displaying tasks, completions, and streaks

import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../planner/presentation/providers/planner_stats_provider.dart';

class PlannerAnalyticsCard extends StatelessWidget {
  const PlannerAnalyticsCard({
    super.key,
    required this.stats,
    required this.overdueTasksCount,
    required this.recurringTasksCount,
  });

  final PlannerStatsData stats;
  final int overdueTasksCount;
  final int recurringTasksCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget buildRow(String label, String value, IconData icon, Color color) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
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
                color: color,
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
              'Planner Analytics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Streaks, completion metrics, and overdue balances',
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: AppSizes.md),
            buildRow('Tasks Created (Total)', '${stats.tasksCreated}', Icons.assignment_outlined, colorScheme.primary),
            buildRow('Tasks Completed (Total)', '${stats.tasksCompleted}', Icons.task_alt_rounded, colorScheme.primary),
            buildRow('Overdue Tasks', '$overdueTasksCount', Icons.gpp_maybe_outlined, Colors.redAccent),
            buildRow('Recurring Active Tasks', '$recurringTasksCount', Icons.autorenew_rounded, colorScheme.tertiary),
            buildRow('Current Completion Rate', '${(stats.todayCompletionRate * 100).toStringAsFixed(0)}%', Icons.percent_rounded, colorScheme.primary),
            buildRow('Current Active Streak', '${stats.currentStreak} Days', Icons.local_fire_department_rounded, Colors.orangeAccent),
            buildRow('Longest Active Streak', '${stats.longestStreak} Days', Icons.emoji_events_rounded, Colors.amber),
          ],
        ),
      ),
    );
  }
}
