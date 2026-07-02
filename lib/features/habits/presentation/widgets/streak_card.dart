import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
  });

  final int currentStreak;
  final int longestStreak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md, horizontal: AppSizes.lg),
        child: Row(
          children: [
            Expanded(
              child: _buildStreakColumn(
                context: context,
                label: 'Current Streak',
                value: '$currentStreak Days',
                icon: Icons.local_fire_department_rounded,
                iconColor: Colors.orange,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
            Expanded(
              child: _buildStreakColumn(
                context: context,
                label: 'Longest Streak',
                value: '$longestStreak Days',
                icon: Icons.emoji_events_rounded,
                iconColor: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakColumn({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: iconColor),
        const SizedBox(width: AppSizes.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
