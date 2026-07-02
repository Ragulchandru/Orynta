import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/analytics_provider.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({
    super.key,
    required this.weeklyStats,
  });

  final List<DailyStats> weeklyStats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              'Weekly Trend',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Productivity scores over the last 7 days',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            SizedBox(
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: weeklyStats.map((stat) {
                  final score = stat.productivityScore;
                  final dayLabel = DateFormat('E').format(stat.date);
                  final heightRatio = (score / 100.0).clamp(0.02, 1.0);

                  final isToday = DateFormat('yyyy-MM-dd').format(stat.date) ==
                      DateFormat('yyyy-MM-dd').format(DateTime.now());

                  final barColor = isToday
                      ? colorScheme.primary
                      : colorScheme.primary.withValues(alpha: 0.4);

                  final barHeight = 120 * heightRatio;

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: 'Score: ${score.toInt()}',
                          child: SizedBox(
                            height: barHeight,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                color: barColor,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          dayLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isToday ? colorScheme.primary : colorScheme.outline,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
