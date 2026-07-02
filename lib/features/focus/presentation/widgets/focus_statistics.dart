import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class FocusStatistics extends StatelessWidget {
  const FocusStatistics({
    super.key,
    required this.todayMinutes,
    required this.streak,
    required this.averageMinutes,
    required this.totalSessions,
  });

  final int todayMinutes;
  final int streak;
  final double averageMinutes;
  final int totalSessions;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppSizes.md,
      mainAxisSpacing: AppSizes.md,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      children: [
        _buildStatTile(
          context: context,
          label: 'Focus Today',
          value: '${todayMinutes}m',
          icon: Icons.timer_outlined,
          iconColor: Colors.blue,
        ),
        _buildStatTile(
          context: context,
          label: 'Active Streak',
          value: '$streak Days',
          icon: Icons.local_fire_department_rounded,
          iconColor: Colors.orange,
        ),
        _buildStatTile(
          context: context,
          label: 'Avg Duration',
          value: '${averageMinutes.toStringAsFixed(1)}m',
          icon: Icons.analytics_outlined,
          iconColor: Colors.purple,
        ),
        _buildStatTile(
          context: context,
          label: 'Completed Sessions',
          value: totalSessions.toString(),
          icon: Icons.emoji_events_outlined,
          iconColor: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildStatTile({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.md),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: AppSizes.xs),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
