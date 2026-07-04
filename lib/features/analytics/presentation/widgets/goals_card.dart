// lib/features/analytics/presentation/widgets/goals_card.dart
//
// Orynta 2.0 — Goals Card displaying Weekly, Monthly, and Yearly Progress Rings

import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../planner/presentation/providers/planner_stats_provider.dart';
import 'progress_ring.dart';

class GoalsCard extends StatelessWidget {
  const GoalsCard({
    super.key,
    required this.stats,
  });

  final PlannerStatsData stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Goals settings (can be interactive, but static configurations for now)
    const weeklyTarget = 10;
    const monthlyTarget = 40;
    const yearlyTarget = 400;

    final weeklyProgress = (stats.weeklyCompleted / weeklyTarget).clamp(0.0, 1.0);
    final monthlyProgress = (stats.monthlyCompleted / monthlyTarget).clamp(0.0, 1.0);
    // Approximate yearly from monthly or calculate from cumulative stats
    final yearlyProgress = ((stats.monthlyCompleted * 1.5) / yearlyTarget).clamp(0.0, 1.0);

    Widget buildGoalItem(String title, String countText, double progress, Color color) {
      return Expanded(
        child: Column(
          children: [
            ProgressRing(
              progress: progress,
              size: 70,
              strokeWidth: 7,
              color: color,
              child: Text(
                '${(progress * 100).toInt()}%',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              countText,
              style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outline),
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
              'Productivity Goals',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildGoalItem('Weekly Goal', '${stats.weeklyCompleted}/$weeklyTarget tasks', weeklyProgress, colorScheme.primary),
                buildGoalItem('Monthly Goal', '${stats.monthlyCompleted}/$monthlyTarget tasks', monthlyProgress, colorScheme.secondary),
                buildGoalItem('Yearly Goal', '${(stats.monthlyCompleted * 1.5).toInt()}/$yearlyTarget tasks', yearlyProgress, colorScheme.tertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
