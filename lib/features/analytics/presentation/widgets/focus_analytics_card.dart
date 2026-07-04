// lib/features/analytics/presentation/widgets/focus_analytics_card.dart
//
// Orynta 2.0 — Focus Analytics Metrics display

import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/focus_analytics_provider.dart';

class FocusAnalyticsCard extends StatelessWidget {
  const FocusAnalyticsCard({
    super.key,
    required this.data,
  });

  final FocusAnalyticsData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget buildStatRow(String label, String value, IconData icon) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
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
                color: colorScheme.primary,
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
              'Focus Analytics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Distraction-free metrics & sessions analytics',
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: AppSizes.md),
            buildStatRow('Total Focus Time', '${data.totalFocusMinutes} mins', Icons.hourglass_full_rounded),
            buildStatRow('Avg Session Length', '${data.averageFocusMinutes.toStringAsFixed(1)} mins', Icons.timer_rounded),
            buildStatRow('Longest Session', '${data.longestFocusMinutes} mins', Icons.star_purple500_rounded),
            buildStatRow('Peak Output Hour', data.mostProductiveHour, Icons.lock_clock_rounded),
            buildStatRow('Peak Output Day', data.mostProductiveDay, Icons.calendar_today_rounded),
          ],
        ),
      ),
    );
  }
}
