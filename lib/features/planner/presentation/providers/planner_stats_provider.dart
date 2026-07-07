// lib/features/planner/presentation/providers/planner_stats_provider.dart
//
// Orynta 2.0 — Planner Statistics & Productivity Insights Engine

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tasks_notifier.dart';

class PlannerStatsData {
  const PlannerStatsData({
    required this.todayCompleted,
    required this.todayTotal,
    required this.todayCompletionRate,
    required this.weeklyCompleted,
    required this.weeklyTotal,
    required this.weeklyCompletionRate,
    required this.monthlyCompleted,
    required this.monthlyTotal,
    required this.monthlyCompletionRate,
    required this.currentStreak,
    required this.longestStreak,
    required this.tasksCreated,
    required this.tasksCompleted,
    required this.averageDailyTasks,
    required this.productivityScore,
  });

  final int todayCompleted;
  final int todayTotal;
  final double todayCompletionRate;
  final int weeklyCompleted;
  final int weeklyTotal;
  final double weeklyCompletionRate;
  final int monthlyCompleted;
  final int monthlyTotal;
  final double monthlyCompletionRate;
  final int currentStreak;
  final int longestStreak;
  final int tasksCreated;
  final int tasksCompleted;
  final double averageDailyTasks;
  final int productivityScore;
}

final plannerStatsProvider = Provider<PlannerStatsData>((ref) {
  final tasks = ref.watch(tasksNotifierProvider);

  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final todayEnd = todayStart.add(const Duration(days: 1));

  final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));
  final monthStart = DateTime(now.year, now.month, 1);

  // Today stats
  final todayTasks = tasks.where((t) {
    if (t.dueDate == null) return false;
    return t.dueDate!.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
        t.dueDate!.isBefore(todayEnd);
  }).toList();
  final todayDone = todayTasks.where((t) => t.isCompleted).length;
  final todayRate = todayTasks.isEmpty ? 0.0 : (todayDone / todayTasks.length);

  // Weekly stats
  final weeklyTasks = tasks.where((t) => t.dueDate != null && t.dueDate!.isAfter(weekStart)).toList();
  final weeklyDone = weeklyTasks.where((t) => t.isCompleted).length;
  final weeklyRate = weeklyTasks.isEmpty ? 0.0 : (weeklyDone / weeklyTasks.length);

  // Monthly stats
  final monthlyTasks = tasks.where((t) => t.dueDate != null && t.dueDate!.isAfter(monthStart)).toList();
  final monthlyDone = monthlyTasks.where((t) => t.isCompleted).length;
  final monthlyRate = monthlyTasks.isEmpty ? 0.0 : (monthlyDone / monthlyTasks.length);

  // Overall totals
  final totalCreated = tasks.length;
  final totalCompleted = tasks.where((t) => t.isCompleted).length;

  // Dynamic streak calculation
  final completionDates = tasks
      .where((t) => t.isCompleted)
      .map((t) => DateTime(t.updatedAt.year, t.updatedAt.month, t.updatedAt.day))
      .toSet()
      .toList();
  
  completionDates.sort((a, b) => a.compareTo(b));

  int currentStreak = 0;
  int longestStreak = 0;

  if (completionDates.isNotEmpty) {
    int tempStreak = 1;
    longestStreak = 1;
    for (int i = 1; i < completionDates.length; i++) {
      final prev = completionDates[i - 1];
      final curr = completionDates[i];
      final difference = curr.difference(prev).inDays;
      if (difference == 1) {
        tempStreak++;
      } else if (difference > 1) {
        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
        tempStreak = 1;
      }
    }
    if (tempStreak > longestStreak) {
      longestStreak = tempStreak;
    }

    final todayMidnight = DateTime(now.year, now.month, now.day);
    final yesterdayMidnight = todayMidnight.subtract(const Duration(days: 1));

    bool completedToday = completionDates.contains(todayMidnight);
    bool completedYesterday = completionDates.contains(yesterdayMidnight);

    if (completedToday || completedYesterday) {
      currentStreak = 1;
      var checkDay = completedToday ? todayMidnight : yesterdayMidnight;
      while (true) {
        checkDay = checkDay.subtract(const Duration(days: 1));
        if (completionDates.contains(checkDay)) {
          currentStreak++;
        } else {
          break;
        }
      }
    } else {
      currentStreak = 0;
    }
  }

  final score = (todayRate * 40 + weeklyRate * 40 + (currentStreak > 0 ? 20 : 0)).round().clamp(0, 100);

  return PlannerStatsData(
    todayCompleted: todayDone,
    todayTotal: todayTasks.length,
    todayCompletionRate: todayRate,
    weeklyCompleted: weeklyDone,
    weeklyTotal: weeklyTasks.length,
    weeklyCompletionRate: weeklyRate,
    monthlyCompleted: monthlyDone,
    monthlyTotal: monthlyTasks.length,
    monthlyCompletionRate: monthlyRate,
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    tasksCreated: totalCreated,
    tasksCompleted: totalCompleted,
    averageDailyTasks: totalCreated == 0 ? 0.0 : (totalCompleted / 7).clamp(0.0, 50.0),
    productivityScore: score,
  );
});
