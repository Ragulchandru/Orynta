import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/analytics_provider.dart';

class NoteActivityChart extends StatelessWidget {
  const NoteActivityChart({
    super.key,
    required this.weeklyStats,
  });

  final List<DailyStats> weeklyStats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalNotesModified =
        weeklyStats.map((s) => s.notesCreated + s.notesEdited).fold(0, (a, b) => a + b);

    // Find the maximum daily count to scale bar heights
    int maxActivity = 1;
    for (final s in weeklyStats) {
      final act = s.notesCreated + s.notesEdited;
      if (act > maxActivity) maxActivity = act;
    }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Note Activity',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      'Notes created & edited in the last 7 days',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Total: $totalNotesModified',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xl),
            SizedBox(
              height: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: weeklyStats.map((stat) {
                  final created = stat.notesCreated;
                  final edited = stat.notesEdited;
                  final total = created + edited;

                  final dayLabel = DateFormat('E').format(stat.date);
                  final ratio = total / maxActivity.toDouble();
                  final heightRatio = ratio.clamp(0.05, 1.0);

                  final barHeight = 90 * heightRatio;

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: 'Created: $created, Edited: $edited',
                          child: SizedBox(
                            height: barHeight,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6.0),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withValues(
                                  alpha: total > 0 ? 0.8 : 0.2,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          dayLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.outline,
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
