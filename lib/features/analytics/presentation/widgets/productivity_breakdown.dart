import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/analytics_provider.dart';

class ProductivityBreakdown extends StatelessWidget {
  const ProductivityBreakdown({
    super.key,
    required this.stats,
  });

  final DailyStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate individual score parts
    final hasTasks = (stats.tasksCompleted + stats.tasksPending) > 0;
    final hasHabits = stats.habitsTotal > 0;

    final taskVal =
        hasTasks ? stats.tasksCompleted / (stats.tasksCompleted + stats.tasksPending) : 1.0;
    final habitVal = hasHabits ? stats.habitsCompleted / stats.habitsTotal : 1.0;
    final focusVal = (stats.focusMinutes / 50.0).clamp(0.0, 1.0);
    final noteVal = ((stats.notesCreated + stats.notesEdited) / 3.0).clamp(0.0, 1.0);

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
              'Productivity Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Metrics contribution weight for today',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            _buildMetricBar(
              theme: theme,
              color: Colors.green,
              label: 'Tasks Checklist (30%)',
              value: taskVal,
              detail: '${stats.tasksCompleted} of ${stats.tasksCompleted + stats.tasksPending} done',
            ),
            const SizedBox(height: AppSizes.md),
            _buildMetricBar(
              theme: theme,
              color: colorScheme.primary,
              label: 'Daily Habits (30%)',
              value: habitVal,
              detail: '${stats.habitsCompleted} of ${stats.habitsTotal} done',
            ),
            const SizedBox(height: AppSizes.md),
            _buildMetricBar(
              theme: theme,
              color: Colors.orange,
              label: 'Focus Minutes (30%)',
              value: focusVal,
              detail: '${stats.focusMinutes}m of 50m target',
            ),
            const SizedBox(height: AppSizes.md),
            _buildMetricBar(
              theme: theme,
              color: Colors.purple,
              label: 'Note Writing (10%)',
              value: noteVal,
              detail: '${stats.notesCreated + stats.notesEdited} created/edited',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBar({
    required ThemeData theme,
    required Color color,
    required String label,
    required double value,
    required String detail,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              detail,
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.15),
            color: color,
          ),
        ),
      ],
    );
  }
}
