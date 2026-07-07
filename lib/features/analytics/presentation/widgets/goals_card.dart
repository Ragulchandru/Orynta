// lib/features/analytics/presentation/widgets/goals_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/design_system/design_system.dart';
import '../../../planner/presentation/providers/planner_stats_provider.dart';
import '../providers/analytics_provider.dart';
import 'progress_ring.dart';

class GoalsCard extends ConsumerWidget {
  const GoalsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    final stats = ref.watch(plannerStatsProvider);
    final today = ref.watch(todayStatsProvider);

    const dailyTarget = 5;
    const weeklyTarget = 20;
    const focusTarget = 50;
    final habitTarget = today.habitsTotal > 0 ? today.habitsTotal : 3;

    final dailyProgress = (today.tasksCompleted / dailyTarget).clamp(0.0, 1.0);
    final weeklyProgress = (stats.weeklyCompleted / weeklyTarget).clamp(0.0, 1.0);
    final focusProgress = (today.focusMinutes / focusTarget).clamp(0.0, 1.0);
    final habitProgress = (today.habitsTotal > 0 ? today.habitsCompleted / today.habitsTotal : 0.0).clamp(0.0, 1.0);

    Widget buildGoalItem(String title, String countText, double progress, Color color) {
      return Expanded(
        child: Column(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.fastOutSlowIn,
              builder: (context, val, child) {
                return ProgressRing(
                  progress: val,
                  size: 65,
                  strokeWidth: 6,
                  color: color,
                  child: Text(
                    '${(val * 100).toInt()}%',
                    style: context.typography.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              title,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: context.typography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              countText,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: context.typography.labelSmall.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
      ),
      color: colors.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productivity Goals',
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 450;

                final items = [
                  buildGoalItem('Daily Tasks', '${today.tasksCompleted}/$dailyTarget', dailyProgress, colors.primary),
                  buildGoalItem('Weekly Tasks', '${stats.weeklyCompleted}/$weeklyTarget', weeklyProgress, colors.secondary),
                  buildGoalItem('Focus Goal', '${today.focusMinutes}/${focusTarget}m', focusProgress, Colors.teal),
                  buildGoalItem('Habit Goal', '${today.habitsCompleted}/$habitTarget', habitProgress, Colors.orange),
                ];

                if (isNarrow) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [items[0], items[1]],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [items[2], items[3]],
                      ),
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: items,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
