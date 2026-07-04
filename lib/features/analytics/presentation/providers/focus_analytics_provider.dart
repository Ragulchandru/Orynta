// lib/features/analytics/presentation/providers/focus_analytics_provider.dart
//
// Orynta 2.0 — Focus Analytics & Productivity Metrics Provider (Time Filter Synchronized)

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../focus/presentation/providers/focus_notifier.dart';
import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import 'analytics_provider.dart';
import 'insights_time_filter_provider.dart';

class FocusAnalyticsData {
  const FocusAnalyticsData({
    required this.totalFocusMinutes,
    required this.averageFocusMinutes,
    required this.longestFocusMinutes,
    required this.notesCreatedToday,
    required this.tasksCompletedToday,
    required this.mostProductiveHour,
    required this.mostProductiveDay,
    required this.averageDailyProductivity,
  });

  final int totalFocusMinutes;
  final double averageFocusMinutes;
  final int longestFocusMinutes;
  final int notesCreatedToday;
  final int tasksCompletedToday;
  final String mostProductiveHour;
  final String mostProductiveDay;
  final double averageDailyProductivity;
}

final focusAnalyticsProvider = Provider<FocusAnalyticsData>((ref) {
  final range = ref.watch(insightsTimeRangeProvider);
  final focusSessions = ref.watch(focusNotifierProvider);
  final tasks = ref.watch(tasksProvider);
  final notesAsync = ref.watch(notesProvider);
  final notes = notesAsync.value ?? [];
  final weeklyStats = ref.watch(weeklyStatsProvider);

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

  // Filter lists based on time range
  final rangeFocus = focusSessions.where((s) => isInRange(s.endTime)).toList();
  final rangeTasks = tasks.where((t) => isInRange(t.updatedAt)).toList();
  final rangeNotes = notes.where((n) => isInRange(n.createdAt)).toList();

  final completedFocus = rangeFocus.where((s) => s.completed).toList();

  // 1. Total Focus Time
  final totalMinutes = completedFocus.fold<int>(0, (sum, s) => sum + s.actualDurationMinutes);

  // 2. Average Session
  final avgSession = completedFocus.isEmpty ? 0.0 : totalMinutes / completedFocus.length;

  // 3. Longest Session
  final longestSession = completedFocus.isEmpty
      ? 0
      : completedFocus.map((s) => s.actualDurationMinutes).reduce((a, b) => a > b ? a : b);

  // 4. Notes Created in Range
  final notesCount = rangeNotes.length;

  // 5. Tasks Completed in Range
  final tasksCompletedCount = rangeTasks.where((t) => t.isCompleted).length;

  // 6. Most Productive Hour
  final hourCounts = Map<int, int>.fromIterable(
    List.generate(24, (i) => i),
    value: (_) => 0,
  );
  for (final t in rangeTasks.where((t) => t.isCompleted)) {
    hourCounts[t.updatedAt.hour] = (hourCounts[t.updatedAt.hour] ?? 0) + 1;
  }
  for (final s in completedFocus) {
    hourCounts[s.startTime.hour] = (hourCounts[s.startTime.hour] ?? 0) + 1;
  }
  int bestHour = 9;
  int maxHourCount = -1;
  hourCounts.forEach((hour, count) {
    if (count > maxHourCount) {
      maxHourCount = count;
      bestHour = hour;
    }
  });
  final String startHourStr = bestHour == 0
      ? '12 AM'
      : bestHour == 12
          ? '12 PM'
          : bestHour > 12
              ? '${bestHour - 12} PM'
              : '$bestHour AM';

  // 7. Most Productive Day
  final dayCounts = Map<int, int>.fromIterable(
    List.generate(7, (i) => i + 1),
    value: (_) => 0,
  );
  for (final t in rangeTasks.where((t) => t.isCompleted)) {
    dayCounts[t.updatedAt.weekday] = (dayCounts[t.updatedAt.weekday] ?? 0) + 1;
  }
  int bestDay = 1;
  int maxDayCount = -1;
  dayCounts.forEach((day, count) {
    if (count > maxDayCount) {
      maxDayCount = count;
      bestDay = day;
    }
  });
  final weekdayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final mostProductiveDayStr = weekdayNames[bestDay - 1];

  // 8. Average Daily Productivity (from weeklyStats)
  final double avgDailyProductivity = weeklyStats.isEmpty
      ? 0.0
      : weeklyStats.map((s) => s.productivityScore).reduce((a, b) => a + b) / weeklyStats.length;

  return FocusAnalyticsData(
    totalFocusMinutes: totalMinutes,
    averageFocusMinutes: avgSession,
    longestFocusMinutes: longestSession,
    notesCreatedToday: notesCount,
    tasksCompletedToday: tasksCompletedCount,
    mostProductiveHour: '$startHourStr - ${bestHour == 23 ? '12 AM' : (bestHour + 1) > 12 ? '${bestHour + 1 - 12} PM' : '${bestHour + 1} AM'}',
    mostProductiveDay: mostProductiveDayStr,
    averageDailyProductivity: avgDailyProductivity,
  );
});
