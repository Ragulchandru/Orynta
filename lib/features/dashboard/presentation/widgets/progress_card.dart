import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../analytics/presentation/providers/analytics_provider.dart';

class ProgressCard extends ConsumerWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch today's stats and score
    final score = ref.watch(productivityScoreProvider);
    final stats = ref.watch(todayStatsProvider);

    // Watch achievements to find the latest progress
    final achievements = ref.watch(achievementsProvider);
    final latestAchievement = achievements.isEmpty
        ? const AchievementEntity(
            id: 'locked',
            title: 'No Badges Yet',
            description: 'Start completing activities.',
            icon: Icons.lock_outline_rounded,
            isUnlocked: false,
            progress: 0.0,
            progressLabel: '0/0',
          )
        : achievements.firstWhere(
            (a) => a.isUnlocked,
            orElse: () {
              final sorted = [...achievements]
                ..sort((a, b) => b.progress.compareTo(a.progress));
              return sorted.first;
            },
          );

    // Watch weekly stats to get trend sums
    final weekly = ref.watch(weeklyStatsProvider);
    final weeklyFocusMins = weekly.map((s) => s.focusMinutes).fold(0, (a, b) => a + b);
    final weeklyAvgScore = weekly.isEmpty
        ? 0.0
        : weekly.map((s) => s.productivityScore).fold(0.0, (a, b) => a + b) / weekly.length;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Row(
          children: [
            // Left: Combined Productivity Score Gauge Ring
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: CircularProgressIndicator(
                    value: score / 100.0,
                    strokeWidth: 8,
                    backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
                    color: score >= 90.0
                        ? Colors.amber
                        : (score >= 60.0 ? colorScheme.primary : colorScheme.outline),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${score.toInt()}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'SCORE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: AppSizes.lg),

            // Right: Detailed Stats & Trends
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatRow(
                    context: context,
                    icon: Icons.checklist_rounded,
                    iconColor: Colors.green,
                    label: 'Tasks Today',
                    value: '${stats.tasksCompleted} / ${stats.tasksCompleted + stats.tasksPending}',
                  ),
                  const SizedBox(height: 6),
                  _buildStatRow(
                    context: context,
                    icon: Icons.loop_rounded,
                    iconColor: colorScheme.primary,
                    label: 'Habits Today',
                    value: '${stats.habitsCompleted} / ${stats.habitsTotal}',
                  ),
                  const SizedBox(height: 6),
                  _buildStatRow(
                    context: context,
                    icon: Icons.trending_up_rounded,
                    iconColor: Colors.purple,
                    label: 'Weekly Avg',
                    value: '${weeklyAvgScore.toInt()} pts',
                  ),
                  const SizedBox(height: 6),
                  _buildStatRow(
                    context: context,
                    icon: Icons.timer_outlined,
                    iconColor: Colors.orange,
                    label: 'Focus Trend',
                    value: '${weeklyFocusMins}m wkly',
                  ),
                  const SizedBox(height: 6),
                  _buildStatRow(
                    context: context,
                    icon: latestAchievement.isUnlocked ? Icons.emoji_events_rounded : Icons.lock_outline_rounded,
                    iconColor: latestAchievement.isUnlocked ? Colors.amber : colorScheme.outline,
                    label: 'Latest Badge',
                    value: latestAchievement.title,
                    isTruncated: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    bool isTruncated = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 90),
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
