// lib/features/analytics/presentation/widgets/priority_bar_chart.dart
//
// Orynta 2.0 — Priority Distribution Bar Chart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class PriorityBarChart extends StatelessWidget {
  const PriorityBarChart({
    super.key,
    required this.priorityCounts,
  });

  final Map<String, int> priorityCounts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final high = priorityCounts['high'] ?? 0;
    final medium = priorityCounts['medium'] ?? 0;
    final low = priorityCounts['low'] ?? 0;
    final total = high + medium + low;

    if (total == 0) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.lg),
          side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        color: colorScheme.surfaceContainerLow,
        child: const Padding(
          padding: EdgeInsets.all(AppSizes.lg),
          child: Center(
            child: Text('No priority data available'),
          ),
        ),
      );
    }

    final double highRatio = high / total;
    final double medRatio = medium / total;
    final double lowRatio = low / total;

    Widget buildPriorityRow(String label, int count, double ratio, Color color) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '$count (${(ratio * 100).toStringAsFixed(0)}%)',
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 8,
                backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
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
              'Priority Distribution',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            buildPriorityRow('High Priority', high, highRatio, Colors.redAccent),
            buildPriorityRow('Medium Priority', medium, medRatio, Colors.amber),
            buildPriorityRow('Low Priority', low, lowRatio, Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}
