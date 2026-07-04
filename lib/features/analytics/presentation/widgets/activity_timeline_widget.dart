// lib/features/analytics/presentation/widgets/activity_timeline_widget.dart
//
// Orynta 2.0 — Activity Timeline widget showing recent local occurrences

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/activity_timeline_provider.dart';

class ActivityTimelineWidget extends StatelessWidget {
  const ActivityTimelineWidget({
    super.key,
    required this.events,
  });

  final List<ActivityEvent> events;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (events.isEmpty) {
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
            child: Text('No activity events logged yet.'),
          ),
        ),
      );
    }

    // Grouping
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    final List<ActivityEvent> todayEvents = [];
    final List<ActivityEvent> yesterdayEvents = [];
    final List<ActivityEvent> weekEvents = [];
    final List<ActivityEvent> olderEvents = [];

    for (final e in events) {
      final date = DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day);
      if (date == today) {
        todayEvents.add(e);
      } else if (date == yesterday) {
        yesterdayEvents.add(e);
      } else if (date.isAfter(startOfWeek)) {
        weekEvents.add(e);
      } else {
        olderEvents.add(e);
      }
    }

    Widget buildGroup(String title, List<ActivityEvent> groupEvents) {
      if (groupEvents.isEmpty) return const SizedBox();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 8.0, left: 4.0),
            child: Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 1.1,
              ),
            ),
          ),
          ...groupEvents.map((e) => buildTimelineCard(e, theme, colorScheme)),
        ],
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
              'Activity Timeline',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Recent actions across notes, tasks, and achievements',
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: AppSizes.md),
            buildGroup('TODAY', todayEvents),
            buildGroup('YESTERDAY', yesterdayEvents),
            buildGroup('EARLIER THIS WEEK', weekEvents),
            buildGroup('OLDER', olderEvents),
          ],
        ),
      ),
    );
  }

  Widget buildTimelineCard(ActivityEvent event, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              event.icon,
              size: 14,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  event.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('h:mm a').format(event.timestamp),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
