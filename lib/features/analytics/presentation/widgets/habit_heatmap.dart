import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/analytics_provider.dart';

class HabitHeatmap extends StatelessWidget {
  const HabitHeatmap({
    super.key,
    required this.monthlyStats,
  });

  final List<DailyStats> monthlyStats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Take past 35 days of stats (we pad the list if smaller)
    final days = monthlyStats.length >= 35
        ? monthlyStats.sublist(monthlyStats.length - 35)
        : [
            ...List.generate(
              35 - monthlyStats.length,
              (i) => DailyStats(
                date: DateTime.now().subtract(Duration(days: 34 - i)),
                tasksCompleted: 0,
                tasksPending: 0,
                habitsCompleted: 0,
                habitsTotal: 0,
                focusMinutes: 0,
                notesCreated: 0,
                notesEdited: 0,
                productivityScore: 0.0,
              ),
            ),
            ...monthlyStats,
          ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habit Heatmap',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Daily routine completion intensities over 5 weeks',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 35,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                final stat = days[index];
                final total = stat.habitsTotal;
                final done = stat.habitsCompleted;

                final double ratio = total > 0 ? done / total : 0.0;

                // github colors mapping: 0% gray, increasing green bounds
                final Color cellColor = switch (ratio) {
                  == 0.0 => colorScheme.surfaceContainerHigh,
                  < 0.4 => Colors.green.withValues(alpha: 0.2),
                  < 0.7 => Colors.green.withValues(alpha: 0.5),
                  < 0.9 => Colors.green.withValues(alpha: 0.75),
                  _ => Colors.green,
                };

                final tooltip = '${DateFormat('MMM d').format(stat.date)}: $done/$total habits completed';

                return Tooltip(
                  message: tooltip,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSizes.md),
            // Legends
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Less', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outline)),
                const SizedBox(width: 4),
                _buildLegendSquare(colorScheme.surfaceContainerHigh),
                const SizedBox(width: 2),
                _buildLegendSquare(Colors.green.withValues(alpha: 0.2)),
                const SizedBox(width: 2),
                _buildLegendSquare(Colors.green.withValues(alpha: 0.5)),
                const SizedBox(width: 2),
                _buildLegendSquare(Colors.green.withValues(alpha: 0.75)),
                const SizedBox(width: 2),
                _buildLegendSquare(Colors.green),
                const SizedBox(width: 4),
                Text('More', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outline)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendSquare(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
