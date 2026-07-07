import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../habits/presentation/providers/habits_notifier.dart';
import '../../../focus/presentation/providers/focus_notifier.dart';
import '../../../planner/presentation/providers/planner_stats_provider.dart';
import 'insights_time_filter_provider.dart';

// ─── Daily Stats Model ───────────────────────────────────────────────────────

class DailyStats {
  const DailyStats({
    required this.date,
    required this.tasksCompleted,
    required this.tasksPending,
    required this.habitsCompleted,
    required this.habitsTotal,
    required this.focusMinutes,
    required this.notesCreated,
    required this.notesEdited,
    required this.productivityScore,
  });

  final DateTime date;
  final int tasksCompleted;
  final int tasksPending;
  final int habitsCompleted;
  final int habitsTotal;
  final int focusMinutes;
  final int notesCreated;
  final int notesEdited;
  final double productivityScore;
}

// ─── Achievement Model ───────────────────────────────────────────────────────

class AchievementEntity {
  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    required this.progress,
    required this.progressLabel,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final double progress;
  final String progressLabel;
}

// ─── Helper method to check dates matching ──────────────────────────────────

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

double _calculateScoreForDay({
  required int tasksCompleted,
  required int tasksPending,
  required int habitsCompleted,
  required int habitsTotal,
  required int focusMinutes,
  required int streak,
  required int missedReminders,
  required int overdueTasks,
}) {
  // 1. Completed tasks (weight 0.3)
  final double completedTasksFactor = (tasksCompleted / 4.0).clamp(0.0, 1.0);

  // 2. Completion % (weight 0.2)
  final int totalTasks = tasksCompleted + tasksPending;
  final double completionRateFactor = totalTasks > 0 ? tasksCompleted / totalTasks : 1.0;

  // 3. Habits completed (weight 0.2)
  final double habitsFactor = habitsTotal > 0 ? habitsCompleted / habitsTotal : 1.0;

  // 4. Focus sessions minutes (weight 0.15)
  final double focusFactor = (focusMinutes / 75.0).clamp(0.0, 1.0);

  // 5. Daily streak / Consistency (weight 0.15)
  final double streakFactor = (streak / 7.0).clamp(0.0, 1.0);

  final double baseScore = (completedTasksFactor * 30.0) +
                     (completionRateFactor * 20.0) +
                     (habitsFactor * 20.0) +
                     (focusFactor * 15.0) +
                     (streakFactor * 15.0);

  final double deductions = (missedReminders * 5.0) + (overdueTasks * 2.0);

  return (baseScore - deductions).clamp(0.0, 100.0);
}

// ─── Analytics Engine Computed Providers ────────────────────────────────────

final dailyStatsProvider = Provider.family<DailyStats, DateTime>((ref, rawDate) {
  final date = DateTime(rawDate.year, rawDate.month, rawDate.day);

  // Tasks completed vs pending
  final tasks = ref.watch(tasksProvider);
  final habits = ref.watch(habitsProvider);
  final focusSessions = ref.watch(focusNotifierProvider);
  final notesAsync = ref.watch(notesProvider);
  final notes = notesAsync.value ?? [];

  if (tasks.isEmpty && habits.isEmpty && focusSessions.isEmpty && notes.isEmpty) {
    return DailyStats(
      date: date,
      tasksCompleted: 0,
      tasksPending: 0,
      habitsCompleted: 0,
      habitsTotal: 0,
      focusMinutes: 0,
      notesCreated: 0,
      notesEdited: 0,
      productivityScore: 0.0,
    );
  }

  final dayTasks = tasks.where((t) => _isSameDay(t.dueDate ?? t.createdAt, date)).toList();
  final tasksCompleted = dayTasks.where((t) => t.isCompleted).length;
  final tasksPending = dayTasks.length - tasksCompleted;

  // Habits completed vs total
  int habitsCompleted = 0;
  int habitsTotal = 0;
  final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  for (final habit in habits) {
    habitsTotal++;
    final count = habit.completionHistory[dateKey] ?? 0;
    if (count >= habit.targetCount) {
      habitsCompleted++;
    }
  }

  // Focus minutes completed
  final dayFocusMinutes = focusSessions
      .where((s) => _isSameDay(s.createdAt, date) && s.sessionType == 'focus' && s.completed)
      .map((s) => s.actualDurationMinutes)
      .fold(0, (a, b) => a + b);

  final notesCreated = notes.where((n) => _isSameDay(n.createdAt, date)).length;

  final notesEdited = notes
      .where((n) => _isSameDay(n.updatedAt, date) && !_isSameDay(n.createdAt, n.updatedAt))
      .length;

  // Overdue tasks
  final overdueTasks = tasks.where((t) {
    if (t.isCompleted || t.isArchived || t.dueDate == null) return false;
    return t.dueDate!.isBefore(date);
  }).length;

  // Missed reminders
  final missedReminders = tasks.where((t) {
    if (t.isCompleted || t.isArchived || t.reminderMs == null) return false;
    return t.reminderMs! < date.millisecondsSinceEpoch;
  }).length;

  // Streak
  final completionDates = tasks
      .where((t) => t.isCompleted)
      .map((t) => DateTime(t.updatedAt.year, t.updatedAt.month, t.updatedAt.day))
      .toSet()
      .toList()
    ..sort((a, b) => a.compareTo(b));

  int streak = 0;
  if (completionDates.isNotEmpty) {
    final dateMidnight = DateTime(date.year, date.month, date.day);
    if (completionDates.contains(dateMidnight) || completionDates.contains(dateMidnight.subtract(const Duration(days: 1)))) {
      streak = 1;
      var checkDay = completionDates.contains(dateMidnight) ? dateMidnight : dateMidnight.subtract(const Duration(days: 1));
      while (true) {
        checkDay = checkDay.subtract(const Duration(days: 1));
        if (completionDates.contains(checkDay)) {
          streak++;
        } else {
          break;
        }
      }
    }
  }

  final score = _calculateScoreForDay(
    tasksCompleted: tasksCompleted,
    tasksPending: tasksPending,
    habitsCompleted: habitsCompleted,
    habitsTotal: habitsTotal,
    focusMinutes: dayFocusMinutes,
    streak: streak,
    missedReminders: missedReminders,
    overdueTasks: overdueTasks,
  );

  return DailyStats(
    date: date,
    tasksCompleted: tasksCompleted,
    tasksPending: tasksPending,
    habitsCompleted: habitsCompleted,
    habitsTotal: habitsTotal,
    focusMinutes: dayFocusMinutes,
    notesCreated: notesCreated,
    notesEdited: notesEdited,
    productivityScore: score,
  );
});

// ─── Today's stats & productivity score ─────────────────────────────────────

final todayStatsProvider = Provider<DailyStats>((ref) {
  final now = DateTime.now();
  return ref.watch(dailyStatsProvider(DateTime(now.year, now.month, now.day)));
});

final productivityScoreProvider = Provider<double>((ref) {
  return ref.watch(todayStatsProvider).productivityScore;
});

// ─── Past 7 Days statistics trend ───────────────────────────────────────────

final weeklyStatsProvider = Provider<List<DailyStats>>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return List.generate(7, (i) {
    final date = today.subtract(Duration(days: 6 - i));
    return ref.watch(dailyStatsProvider(date));
  });
});

// ─── Past 30 Days statistics trend ──────────────────────────────────────────

final monthlyStatsProvider = Provider<List<DailyStats>>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return List.generate(30, (i) {
    final date = today.subtract(Duration(days: 29 - i));
    return ref.watch(dailyStatsProvider(date));
  });
});

// ─── Achievements Unlock provider ───────────────────────────────────────────

final achievementsProvider = Provider<List<AchievementEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final notesAsync = ref.watch(notesProvider);
  final notes = notesAsync.value ?? [];
  final stats = ref.watch(plannerStatsProvider);
  final score = ref.watch(productivityScoreProvider);

  // 1. First Task Completed
  final completedTasks = tasks.where((t) => t.isCompleted).length;
  final firstTaskUnlocked = completedTasks >= 1;
  final firstTaskProgress = firstTaskUnlocked ? 1.0 : 0.0;

  // 2. 7 Day Streak
  final streak7Unlocked = stats.currentStreak >= 7;
  final streak7Progress = (stats.currentStreak / 7.0).clamp(0.0, 1.0);

  // 3. 30 Day Streak
  final streak30Unlocked = stats.currentStreak >= 30;
  final streak30Progress = (stats.currentStreak / 30.0).clamp(0.0, 1.0);

  // 4. 100 Notes
  final notes100Unlocked = notes.length >= 100;
  final notes100Progress = (notes.length / 100.0).clamp(0.0, 1.0);

  // 5. 100 Tasks
  final tasks100Unlocked = completedTasks >= 100;
  final tasks100Progress = (completedTasks / 100.0).clamp(0.0, 1.0);

  // 6. Productivity Master
  final masterUnlocked = score >= 95.0;
  final masterProgress = (score / 95.0).clamp(0.0, 1.0);

  return [
    AchievementEntity(
      id: 'first_task',
      title: 'First Task',
      description: 'Unlock your journey by completing your very first task.',
      icon: Icons.check_circle_outline_rounded,
      isUnlocked: firstTaskUnlocked,
      progress: firstTaskProgress,
      progressLabel: firstTaskUnlocked ? '1/1' : '0/1',
    ),
    AchievementEntity(
      id: 'streak_7',
      title: '7 Day Streak',
      description: 'Maintain an active task completion streak for 7 consecutive days.',
      icon: Icons.local_fire_department_rounded,
      isUnlocked: streak7Unlocked,
      progress: streak7Progress,
      progressLabel: '${stats.currentStreak}/7 days',
    ),
    AchievementEntity(
      id: 'streak_30',
      title: '30 Day Streak',
      description: 'Maintain a task completion streak for 30 consecutive days.',
      icon: Icons.emoji_events_rounded,
      isUnlocked: streak30Unlocked,
      progress: streak30Progress,
      progressLabel: '${stats.currentStreak}/30 days',
    ),
    AchievementEntity(
      id: 'notes_100',
      title: '100 Notes',
      description: 'Capture 100 thoughts, quick logs, or study guides in Orynta.',
      icon: Icons.description_outlined,
      isUnlocked: notes100Unlocked,
      progress: notes100Progress,
      progressLabel: '${notes.length}/100 notes',
    ),
    AchievementEntity(
      id: 'tasks_100',
      title: '100 Tasks',
      description: 'Complete 100 structured tasks on your planner.',
      icon: Icons.checklist_rounded,
      isUnlocked: tasks100Unlocked,
      progress: tasks100Progress,
      progressLabel: '$completedTasks/100 tasks',
    ),
    AchievementEntity(
      id: 'prod_master',
      title: 'Productivity Master',
      description: 'Reach a peak daily productivity score of 95 or above.',
      icon: Icons.stars_rounded,
      isUnlocked: masterUnlocked,
      progress: masterProgress,
      progressLabel: '${score.toInt()}/95 points',
    ),
  ];
});

// ─── Productivity Insights rule engine ──────────────────────────────────────

final productivityInsightsProvider = Provider<List<String>>((ref) {
  final weekly = ref.watch(weeklyStatsProvider);
  final monthly = ref.watch(monthlyStatsProvider);
  final focus = ref.watch(focusNotifierProvider);

  final List<String> insights = [];

  // 1. Productivity Trend Insights
  if (weekly.length >= 7) {
    final recentAvg = (weekly[4].productivityScore + weekly[5].productivityScore + weekly[6].productivityScore) / 3;
    final pastAvg = (weekly[0].productivityScore + weekly[1].productivityScore + weekly[2].productivityScore) / 3;
    if (recentAvg > pastAvg) {
      final pct = (((recentAvg - pastAvg) / (pastAvg > 0 ? pastAvg : 1)) * 100).toInt();
      insights.add('Your productivity increased by $pct% this week compared to last week.');
    } else if (recentAvg < pastAvg) {
      insights.add('Your productivity trended slightly downwards. Take regular breaks to avoid fatigue.');
    } else if (recentAvg > 0) {
      insights.add('Your productivity remains consistent and stable this week.');
    }
  }

  // 2. Most productive weekday (Monday=1, Sunday=7)
  if (monthly.isNotEmpty) {
    final Map<int, List<double>> weekdayScores = {};
    for (final s in monthly) {
      if (s.productivityScore > 0) {
        weekdayScores.putIfAbsent(s.date.weekday, () => []).add(s.productivityScore);
      }
    }
    if (weekdayScores.isNotEmpty) {
      int bestDay = 1;
      double maxAvg = 0.0;
      weekdayScores.forEach((day, scores) {
        final avg = scores.isEmpty
            ? 0.0
            : scores.fold(0.0, (a, b) => a + b) / scores.length;
        if (avg > maxAvg) {
          maxAvg = avg;
          bestDay = day;
        }
      });
      final weekdayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      insights.add('${weekdayNames[bestDay - 1]} was your most productive day over the past month.');
    }
  }

  // 3. Best Focus Period
  if (focus.isNotEmpty) {
    int morningMins = 0;
    int afternoonMins = 0;
    int eveningMins = 0;
    int nightMins = 0;

    for (final s in focus.where((s) => s.sessionType == 'focus' && s.completed)) {
      final hour = s.startTime.hour;
      if (hour >= 6 && hour < 12) {
        morningMins += s.actualDurationMinutes;
      } else if (hour >= 12 && hour < 18) {
        afternoonMins += s.actualDurationMinutes;
      } else if (hour >= 18 && hour < 22) {
        eveningMins += s.actualDurationMinutes;
      } else {
        nightMins += s.actualDurationMinutes;
      }
    }

    final totalMins = morningMins + afternoonMins + eveningMins + nightMins;
    if (totalMins > 0) {
      if (morningMins >= afternoonMins && morningMins >= eveningMins && morningMins >= nightMins) {
        insights.add('Morning sessions are your strongest focus period.');
      } else if (afternoonMins >= morningMins && afternoonMins >= eveningMins && afternoonMins >= nightMins) {
        insights.add('Afternoon sessions are your strongest focus period.');
      } else if (eveningMins >= morningMins && eveningMins >= afternoonMins && eveningMins >= nightMins) {
        insights.add('Evening sessions are your strongest focus period.');
      } else {
        insights.add('Night sessions are your strongest focus period.');
      }
    }
  }

  // 4. Focus time trend (Weekly compare)
  if (weekly.length >= 7) {
    final recentMins = weekly.take(3).map((s) => s.focusMinutes).fold(0, (a, b) => a + b);
    final pastMins = weekly.skip(4).take(3).map((s) => s.focusMinutes).fold(0, (a, b) => a + b);
    if (recentMins > pastMins && pastMins > 0) {
      insights.add('Your weekly focus time is increasing. Keep maintaining this focus flow!');
    } else if (recentMins < pastMins && recentMins > 0) {
      insights.add('Your focus time is decreasing. Try scheduling distraction-free sessions.');
    }
  }

  // Fallback defaults when empty
  if (insights.isEmpty) {
    insights.add('Start using Orynta to unlock productivity insights.');
    insights.add('Consistency is key! Complete at least one study habit or task today.');
  }

  return insights;
});

// ─── Phase 5.6.3 Models and Providers ──────────────────────────────────────────

class TrendPoint {
  final DateTime date;
  final int created;
  final int completed;
  const TrendPoint({
    required this.date,
    required this.created,
    required this.completed,
  });
}

class PeriodMetrics {
  final int created;
  final int completed;
  final double completionRate;
  final double avgProductivityScore;

  // Comparison previous period
  final int prevCreated;
  final int prevCompleted;
  final double prevCompletionRate;
  final double prevAvgProductivityScore;

  final String label;
  final String prevLabel;

  const PeriodMetrics({
    required this.created,
    required this.completed,
    required this.completionRate,
    required this.avgProductivityScore,
    required this.prevCreated,
    required this.prevCompleted,
    required this.prevCompletionRate,
    required this.prevAvgProductivityScore,
    required this.label,
    required this.prevLabel,
  });
}

class HourlyProductivity {
  final String label;
  final int count;
  const HourlyProductivity(this.label, this.count);
}

class PerformanceDay {
  final String dayName;
  final int completedCount;
  final String label;
  final double completionRate;
  const PerformanceDay({
    required this.dayName,
    required this.completedCount,
    required this.label,
    required this.completionRate,
  });
}

class PerformanceSummary {
  final PerformanceDay best;
  final PerformanceDay worst;
  const PerformanceSummary({required this.best, required this.worst});
}

// Active Trend Provider
final activeTrendProvider = Provider<List<TrendPoint>>((ref) {
  final range = ref.watch(insightsTimeRangeProvider);
  final tasks = ref.watch(tasksProvider);
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);

  switch (range) {
    case InsightsTimeRange.today:
      final hours = [6, 9, 12, 15, 18, 21];
      return List.generate(hours.length, (i) {
        final h = hours[i];
        final start = todayStart.add(Duration(hours: h - 3));
        final end = todayStart.add(Duration(hours: h));
        final created = tasks.where((t) => t.createdAt.isAfter(start) && t.createdAt.isBefore(end)).length;
        final completed = tasks.where((t) => t.isCompleted && t.updatedAt.isAfter(start) && t.updatedAt.isBefore(end)).length;
        return TrendPoint(
          date: todayStart.add(Duration(hours: h)),
          created: created,
          completed: completed,
        );
      });

    case InsightsTimeRange.week:
      return List.generate(7, (i) {
        final date = todayStart.subtract(Duration(days: 6 - i));
        final start = date;
        final end = date.add(const Duration(days: 1));
        final created = tasks.where((t) => t.createdAt.isAfter(start) && t.createdAt.isBefore(end)).length;
        final completed = tasks.where((t) => t.isCompleted && t.updatedAt.isAfter(start) && t.updatedAt.isBefore(end)).length;
        return TrendPoint(date: date, created: created, completed: completed);
      });

    case InsightsTimeRange.month:
      return List.generate(30, (i) {
        final date = todayStart.subtract(Duration(days: 29 - i));
        final start = date;
        final end = date.add(const Duration(days: 1));
        final created = tasks.where((t) => t.createdAt.isAfter(start) && t.createdAt.isBefore(end)).length;
        final completed = tasks.where((t) => t.isCompleted && t.updatedAt.isAfter(start) && t.updatedAt.isBefore(end)).length;
        return TrendPoint(date: date, created: created, completed: completed);
      });

    case InsightsTimeRange.year:
      return List.generate(12, (i) {
        final date = DateTime(now.year, now.month - (11 - i), 1);
        final nextMonth = DateTime(date.year, date.month + 1, 1);
        final created = tasks.where((t) => t.createdAt.isAfter(date) && t.createdAt.isBefore(nextMonth)).length;
        final completed = tasks.where((t) => t.isCompleted && t.updatedAt.isAfter(date) && t.updatedAt.isBefore(nextMonth)).length;
        return TrendPoint(date: date, created: created, completed: completed);
      });

    case InsightsTimeRange.all:
      return List.generate(5, (i) {
        final year = now.year - (4 - i);
        final start = DateTime(year, 1, 1);
        final end = DateTime(year + 1, 1, 1);
        final created = tasks.where((t) => t.createdAt.isAfter(start) && t.createdAt.isBefore(end)).length;
        final completed = tasks.where((t) => t.isCompleted && t.updatedAt.isAfter(start) && t.updatedAt.isBefore(end)).length;
        return TrendPoint(date: start, created: created, completed: completed);
      });
  }
});

// Period Metrics Provider for Summary Cards and Previous Period Comparisons
final periodMetricsProvider = Provider<PeriodMetrics>((ref) {
  final range = ref.watch(insightsTimeRangeProvider);
  final tasks = ref.watch(tasksProvider);

  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);

  DateTime activeStart;
  DateTime activeEnd = now;
  DateTime prevStart;
  DateTime prevEnd;

  String label = '';
  String prevLabel = '';

  switch (range) {
    case InsightsTimeRange.today:
      activeStart = todayStart;
      prevStart = todayStart.subtract(const Duration(days: 1));
      prevEnd = todayStart;
      label = 'Today';
      prevLabel = 'Yesterday';
      break;
    case InsightsTimeRange.week:
      activeStart = todayStart.subtract(const Duration(days: 6));
      prevStart = activeStart.subtract(const Duration(days: 7));
      prevEnd = activeStart;
      label = 'This Week';
      prevLabel = 'Last Week';
      break;
    case InsightsTimeRange.month:
      activeStart = todayStart.subtract(const Duration(days: 29));
      prevStart = activeStart.subtract(const Duration(days: 30));
      prevEnd = activeStart;
      label = DateFormat('MMMM').format(now);
      prevLabel = DateFormat('MMMM').format(now.subtract(const Duration(days: 30)));
      break;
    case InsightsTimeRange.year:
      activeStart = todayStart.subtract(const Duration(days: 364));
      prevStart = activeStart.subtract(const Duration(days: 365));
      prevEnd = activeStart;
      label = now.year.toString();
      prevLabel = (now.year - 1).toString();
      break;
    case InsightsTimeRange.all:
      activeStart = DateTime(2020);
      prevStart = DateTime(2020);
      prevEnd = DateTime(2020);
      label = 'All Time';
      prevLabel = 'N/A';
      break;
  }

  // Active period
  final createdCount = tasks.where((t) => t.createdAt.isAfter(activeStart) && t.createdAt.isBefore(activeEnd)).length;
  final completedCount = tasks.where((t) => t.isCompleted && t.updatedAt.isAfter(activeStart) && t.updatedAt.isBefore(activeEnd)).length;
  final completionRate = createdCount > 0 ? (completedCount / createdCount) * 100 : 0.0;

  // Previous period
  final prevCreatedCount = tasks.where((t) => t.createdAt.isAfter(prevStart) && t.createdAt.isBefore(prevEnd)).length;
  final prevCompletedCount = tasks.where((t) => t.isCompleted && t.updatedAt.isAfter(prevStart) && t.updatedAt.isBefore(prevEnd)).length;
  final prevCompletionRate = prevCreatedCount > 0 ? (prevCompletedCount / prevCreatedCount) * 100 : 0.0;

  // Active score calculation
  double activeScoreSum = 0.0;
  int activeDays = 0;
  final activeDuration = activeEnd.difference(activeStart).inDays + 1;
  for (int i = 0; i < activeDuration; i++) {
    final day = activeStart.add(Duration(days: i));
    final stats = ref.read(dailyStatsProvider(day));
    if (stats.productivityScore > 0) {
      activeScoreSum += stats.productivityScore;
      activeDays++;
    }
  }
  final activeScore = activeDays > 0 ? activeScoreSum / activeDays : 0.0;

  // Previous score calculation
  double prevScoreSum = 0.0;
  int prevDays = 0;
  if (range != InsightsTimeRange.all) {
    final prevDuration = prevEnd.difference(prevStart).inDays + 1;
    for (int i = 0; i < prevDuration; i++) {
      final day = prevStart.add(Duration(days: i));
      final stats = ref.read(dailyStatsProvider(day));
      if (stats.productivityScore > 0) {
        prevScoreSum += stats.productivityScore;
        prevDays++;
      }
    }
  }
  final prevScore = prevDays > 0 ? prevScoreSum / prevDays : 0.0;

  return PeriodMetrics(
    created: createdCount,
    completed: completedCount,
    completionRate: completionRate,
    avgProductivityScore: activeScore,
    prevCreated: prevCreatedCount,
    prevCompleted: prevCompletedCount,
    prevCompletionRate: prevCompletionRate,
    prevAvgProductivityScore: prevScore,
    label: label,
    prevLabel: prevLabel,
  );
});

// Timeline Hourly Productivity Provider
final timelineHourlyProductivityProvider = Provider<List<HourlyProductivity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final range = ref.watch(insightsTimeRangeProvider);
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);

  DateTime start;
  switch (range) {
    case InsightsTimeRange.today:
      start = todayStart;
      break;
    case InsightsTimeRange.week:
      start = todayStart.subtract(const Duration(days: 6));
      break;
    case InsightsTimeRange.month:
      start = todayStart.subtract(const Duration(days: 29));
      break;
    case InsightsTimeRange.year:
      start = todayStart.subtract(const Duration(days: 364));
      break;
    case InsightsTimeRange.all:
      start = DateTime(2020);
      break;
  }

  final completedTasks = tasks.where((t) => t.isCompleted && t.updatedAt.isAfter(start)).toList();

  const slots = [
    _HourRange('6 AM', 5, 7),
    _HourRange('8 AM', 7, 9),
    _HourRange('10 AM', 9, 11),
    _HourRange('12 PM', 11, 13),
    _HourRange('2 PM', 13, 15),
    _HourRange('6 PM', 15, 19),
    _HourRange('9 PM', 19, 23),
  ];

  return slots.map((s) {
    final count = completedTasks.where((t) {
      final hour = t.updatedAt.hour;
      return hour >= s.start && hour < s.end;
    }).length;
    return HourlyProductivity(s.label, count);
  }).toList();
});

class _HourRange {
  final String label;
  final int start;
  final int end;
  const _HourRange(this.label, this.start, this.end);
}

// Performance Days Provider (Best vs Worst)
final performanceDaysProvider = Provider<PerformanceSummary>((ref) {
  final tasks = ref.watch(tasksProvider);
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final monthAgo = todayStart.subtract(const Duration(days: 29));

  final activeTasks = tasks.where((t) => !t.isArchived && t.updatedAt.isAfter(monthAgo)).toList();

  // Group by day of week (1 = Monday, 7 = Sunday)
  final Map<int, int> weekdayTotal = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
  final Map<int, int> weekdayCompletions = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};

  for (final t in activeTasks) {
    final day = t.updatedAt.weekday;
    weekdayTotal[day] = (weekdayTotal[day] ?? 0) + 1;
    if (t.isCompleted) {
      weekdayCompletions[day] = (weekdayCompletions[day] ?? 0) + 1;
    }
  }

  int bestDay = 1;
  int bestCount = -1;
  int worstDay = 7;
  int worstCount = 999999;

  final weekdayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  weekdayCompletions.forEach((day, count) {
    if (count > bestCount) {
      bestCount = count;
      bestDay = day;
    }
    if (count < worstCount) {
      worstCount = count;
      worstDay = day;
    }
  });

  double getRate(int day) {
    final total = weekdayTotal[day] ?? 0;
    if (total == 0) return 0.0;
    return (weekdayCompletions[day] ?? 0) / total;
  }

  return PerformanceSummary(
    best: PerformanceDay(
      dayName: weekdayNames[bestDay - 1],
      completedCount: bestCount == -1 ? 0 : bestCount,
      label: 'Highest Productivity',
      completionRate: getRate(bestDay),
    ),
    worst: PerformanceDay(
      dayName: weekdayNames[worstDay - 1],
      completedCount: worstCount == 999999 ? 0 : worstCount,
      label: 'Lowest Productivity',
      completionRate: getRate(worstDay),
    ),
  );
});
