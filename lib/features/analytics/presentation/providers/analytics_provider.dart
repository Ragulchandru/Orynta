import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../habits/presentation/providers/habits_notifier.dart';
import '../../../focus/presentation/providers/focus_notifier.dart';

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
  required int notesCreated,
  required int notesEdited,
}) {
  final hasTasks = (tasksCompleted + tasksPending) > 0;
  final hasHabits = habitsTotal > 0;

  final taskScore = hasTasks ? tasksCompleted / (tasksCompleted + tasksPending) : 0.0;
  final habitScore = hasHabits ? habitsCompleted / habitsTotal : 0.0;
  final focusScore = (focusMinutes / 50.0).clamp(0.0, 1.0);
  final noteScore = ((notesCreated + notesEdited) / 3.0).clamp(0.0, 1.0);

  double weightedSum = 0.0;
  double totalWeight = 0.0;

  if (hasTasks) {
    weightedSum += taskScore * 0.3;
    totalWeight += 0.3;
  }
  if (hasHabits) {
    weightedSum += habitScore * 0.3;
    totalWeight += 0.3;
  }
  if (focusMinutes > 0) {
    weightedSum += focusScore * 0.3;
    totalWeight += 0.3;
  }
  if ((notesCreated + notesEdited) > 0) {
    weightedSum += noteScore * 0.1;
    totalWeight += 0.1;
  }

  return totalWeight > 0 ? (weightedSum / totalWeight) * 100 : 0.0;
}

// ─── Analytics Engine Computed Providers ────────────────────────────────────

final dailyStatsProvider = Provider.family<DailyStats, DateTime>((ref, rawDate) {
  final date = DateTime(rawDate.year, rawDate.month, rawDate.day);

  // Tasks completed vs pending
  final tasks = ref.watch(tasksProvider);
  final dayTasks = tasks.where((t) => _isSameDay(t.dueDate ?? t.createdAt, date)).toList();
  final tasksCompleted = dayTasks.where((t) => t.isCompleted).length;
  final tasksPending = dayTasks.length - tasksCompleted;

  // Habits completed vs total
  final habits = ref.watch(habitsProvider);
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
  final focusSessions = ref.watch(focusNotifierProvider);
  final dayFocusMinutes = focusSessions
      .where((s) => _isSameDay(s.createdAt, date) && s.sessionType == 'focus' && s.completed)
      .map((s) => s.actualDurationMinutes)
      .fold(0, (a, b) => a + b);

  // Notes created/edited today
  final notesAsync = ref.watch(notesProvider);
  final notes = notesAsync.value ?? [];
  final notesCreated = notes.where((n) => _isSameDay(n.createdAt, date)).length;
  final notesEdited = notes
      .where((n) => _isSameDay(n.updatedAt, date) && !_isSameDay(n.createdAt, n.updatedAt))
      .length;

  final score = _calculateScoreForDay(
    tasksCompleted: tasksCompleted,
    tasksPending: tasksPending,
    habitsCompleted: habitsCompleted,
    habitsTotal: habitsTotal,
    focusMinutes: dayFocusMinutes,
    notesCreated: notesCreated,
    notesEdited: notesEdited,
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
  final habits = ref.watch(habitsProvider);
  final focus = ref.watch(focusNotifierProvider);
  final notesAsync = ref.watch(notesProvider);
  final notes = notesAsync.value ?? [];
  final todayScore = ref.watch(productivityScoreProvider);

  // 1. First Focus Session
  final totalFocusSessions = focus.where((s) => s.sessionType == 'focus' && s.completed).length;
  final firstFocusUnlocked = totalFocusSessions >= 1;
  final firstFocusProgress = firstFocusUnlocked ? 1.0 : 0.0;

  // 2. 7-Day Habit Streak
  int maxHabitStreak = 0;
  for (final h in habits) {
    if (h.currentStreak > maxHabitStreak) maxHabitStreak = h.currentStreak;
    if (h.longestStreak > maxHabitStreak) maxHabitStreak = h.longestStreak;
  }
  final habitStreakUnlocked = maxHabitStreak >= 7;
  final habitStreakProgress = (maxHabitStreak / 7.0).clamp(0.0, 1.0);

  // 3. 25 Tasks Completed
  final completedTasks = tasks.where((t) => t.isCompleted).length;
  final tasksCompletedUnlocked = completedTasks >= 25;
  final tasksCompletedProgress = (completedTasks / 25.0).clamp(0.0, 1.0);

  // 4. 100 Focus Hours
  final totalFocusMinutes = focus
      .where((s) => s.sessionType == 'focus' && s.completed)
      .map((s) => s.actualDurationMinutes)
      .fold(0, (a, b) => a + b);
  final focusHoursUnlocked = totalFocusMinutes >= 6000; // 100 hours
  final focusHoursProgress = (totalFocusMinutes / 6000.0).clamp(0.0, 1.0);

  // 5. 50 Notes Created
  final notesCreatedUnlocked = notes.length >= 50;
  final notesCreatedProgress = (notes.length / 50.0).clamp(0.0, 1.0);

  // 6. Productivity Elite (Score above 90)
  final eliteUnlocked = todayScore >= 90.0;
  final eliteProgress = (todayScore / 90.0).clamp(0.0, 1.0);

  return [
    AchievementEntity(
      id: 'first_focus',
      title: 'First Focus Session',
      description: 'Log your first completed focus block.',
      icon: Icons.timer_outlined,
      isUnlocked: firstFocusUnlocked,
      progress: firstFocusProgress,
      progressLabel: firstFocusUnlocked ? '1/1' : '0/1',
    ),
    AchievementEntity(
      id: 'habit_streak',
      title: '7-Day Habit Streak',
      description: 'Maintain a habit streak of 7 days.',
      icon: Icons.local_fire_department_rounded,
      isUnlocked: habitStreakUnlocked,
      progress: habitStreakProgress,
      progressLabel: '$maxHabitStreak/7 days',
    ),
    AchievementEntity(
      id: 'tasks_completed',
      title: '25 Tasks Completed',
      description: 'Complete 25 planned tasks.',
      icon: Icons.checklist_rounded,
      isUnlocked: tasksCompletedUnlocked,
      progress: tasksCompletedProgress,
      progressLabel: '$completedTasks/25 tasks',
    ),
    AchievementEntity(
      id: 'focus_hours',
      title: '100 Focus Hours',
      description: 'Log 100 hours of active focus sessions.',
      icon: Icons.hourglass_empty_rounded,
      isUnlocked: focusHoursUnlocked,
      progress: focusHoursProgress,
      progressLabel: '${(totalFocusMinutes / 60).toStringAsFixed(1)}/100 hrs',
    ),
    AchievementEntity(
      id: 'notes_created',
      title: '50 Notes Created',
      description: 'Capture 50 detailed thoughts or study notes.',
      icon: Icons.description_outlined,
      isUnlocked: notesCreatedUnlocked,
      progress: notesCreatedProgress,
      progressLabel: '${notes.length}/50 notes',
    ),
    AchievementEntity(
      id: 'elite_productivity',
      title: 'Productivity Elite',
      description: 'Reach a daily productivity score above 90.',
      icon: Icons.stars_rounded,
      isUnlocked: eliteUnlocked,
      progress: eliteProgress,
      progressLabel: '${todayScore.toInt()}/90 score',
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
