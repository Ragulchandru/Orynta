// lib/features/analytics/presentation/providers/activity_timeline_provider.dart
//
// Orynta 2.0 — Time Filter Synchronized Local Activity Timeline Provider

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import 'analytics_provider.dart';
import 'insights_time_filter_provider.dart';

class ActivityEvent {
  const ActivityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final IconData icon;
  final String category; // "task", "note", "streak", "achievement", "goal"
}

final activityTimelineProvider = Provider<List<ActivityEvent>>((ref) {
  final range = ref.watch(insightsTimeRangeProvider);
  final tasks = ref.watch(tasksProvider);
  final notesAsync = ref.watch(notesProvider);
  final notes = notesAsync.value ?? [];
  final achievements = ref.watch(achievementsProvider);

  final List<ActivityEvent> events = [];
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);

  DateTime? filterStartDate;
  switch (range) {
    case InsightsTimeRange.today:
      filterStartDate = startOfToday;
      break;
    case InsightsTimeRange.week:
      filterStartDate = startOfToday.subtract(Duration(days: now.weekday - 1));
      break;
    case InsightsTimeRange.month:
      filterStartDate = DateTime(now.year, now.month, 1);
      break;
    case InsightsTimeRange.year:
      filterStartDate = DateTime(now.year, 1, 1);
      break;
    case InsightsTimeRange.all:
      filterStartDate = null;
      break;
  }

  bool isInRange(DateTime date) {
    if (filterStartDate == null) return true;
    return date.isAfter(filterStartDate) || date.isAtSameMomentAs(filterStartDate);
  }

  // 1. Task Completion Events
  for (final t in tasks.where((t) => t.isCompleted && isInRange(t.updatedAt))) {
    events.add(
      ActivityEvent(
        id: 'task_${t.id}_comp',
        title: 'Task Completed',
        description: 'Successfully finished: "${t.title}"',
        timestamp: t.updatedAt,
        icon: Icons.check_circle_rounded,
        category: 'task',
      ),
    );
  }

  // 2. Note Creation Events
  for (final n in notes.where((n) => isInRange(n.createdAt))) {
    events.add(
      ActivityEvent(
        id: 'note_${n.id}_create',
        title: 'Note Captured',
        description: 'Captured new thought: "${n.title}"',
        timestamp: n.createdAt,
        icon: Icons.note_alt_rounded,
        category: 'note',
      ),
    );
    // Linked Note Event
    if (n.categoryId != null) {
      events.add(
        ActivityEvent(
          id: 'note_${n.id}_link',
          title: 'Linked Note Added',
          description: 'Linked note "${n.title}" to category.',
          timestamp: n.updatedAt,
          icon: Icons.link_rounded,
          category: 'note',
        ),
      );
    }
  }

  // 3. Achievements Unlocked Events
  for (final ach in achievements.where((a) => a.isUnlocked)) {
    events.add(
      ActivityEvent(
        id: 'ach_${ach.id}',
        title: 'Achievement Unlocked',
        description: 'Earned badge: "${ach.title}" — ${ach.description}',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)), // Simulated recent date
        icon: ach.icon,
        category: 'achievement',
      ),
    );
  }

  // Sort chronologically descending
  events.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return events;
});
