// lib/features/analytics/presentation/providers/productivity_score_provider.dart
//
// Orynta 2.0 — Unified Productivity Score & Analytics Engine (0-100 Rating)

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../focus/presentation/providers/focus_notifier.dart';
import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../planner/presentation/providers/planner_stats_provider.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../habits/presentation/providers/habits_notifier.dart';

class ProductivityScoreData {
  const ProductivityScoreData({
    required this.score,
    required this.level,
    required this.message,
    required this.tasksCompletedToday,
    required this.focusMinutesToday,
    required this.notesCreatedToday,
    required this.habitsCompletedToday,
  });

  final int score;
  final String level; // Excellent, Good, Average, Needs Improvement
  final String message;
  final int tasksCompletedToday;
  final int focusMinutesToday;
  final int notesCreatedToday;
  final int habitsCompletedToday;
}

final unifiedScoreProvider = Provider<ProductivityScoreData>((ref) {
  final plannerStats = ref.watch(plannerStatsProvider);
  final tasks = ref.watch(tasksProvider);
  final focusSessions = ref.watch(focusNotifierProvider);
  final notesAsync = ref.watch(notesProvider);
  final notes = notesAsync.value ?? [];
  final habits = ref.watch(habitsProvider);

  final now = DateTime.now();

  // 1. Completion Rate contribution (up to 40 points)
  final completionContrib = (plannerStats.todayCompletionRate * 40.0).clamp(0.0, 40.0);

  // 2. Streak contribution (up to 20 points: 5 points per streak day, max 20)
  final streakContrib = (plannerStats.currentStreak * 5.0).clamp(0.0, 20.0);

  // 3. Focus contribution (up to 20 points: 2 points per 10 minutes focused)
  final focusTodayMins = focusSessions
      .where((s) =>
          s.completed &&
          s.endTime.year == now.year &&
          s.endTime.month == now.month &&
          s.endTime.day == now.day,)
      .fold<int>(0, (sum, s) => sum + s.actualDurationMinutes);
  final focusContrib = ((focusTodayMins / 10.0) * 2.0).clamp(0.0, 20.0);

  // 4. Habit Consistency contribution (up to 20 points based on habits completed today)
  final dateKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  int habitsCompleted = 0;
  for (final h in habits) {
    final count = h.completionHistory[dateKey] ?? 0;
    if (count >= h.targetCount) {
      habitsCompleted++;
    }
  }
  final habitsTotal = habits.length;
  final habitContrib = habitsTotal == 0 ? 20.0 : ((habitsCompleted / habitsTotal) * 20.0).clamp(0.0, 20.0);

  // 5. Overdue Penalty (deduct 5 points per overdue task, up to 15 points deduction)
  final overdueTasks = tasks.where((t) => !t.isCompleted && t.dueDate != null && t.dueDate!.isBefore(now)).length;
  final overduePenalty = (overdueTasks * 5.0).clamp(0.0, 15.0);

  // Total Score calculation
  final calculatedScore = (completionContrib + streakContrib + focusContrib + habitContrib - overduePenalty).round().clamp(0, 100);

  // Score levels mapping
  final String level;
  final String message;
  if (calculatedScore >= 90) {
    level = 'Excellent';
    message = 'Incredible! You are at peak performance today. Keep crushing it!';
  } else if (calculatedScore >= 70) {
    level = 'Good';
    message = 'Great job! You remain highly focused and productive today.';
  } else if (calculatedScore >= 50) {
    level = 'Average';
    message = 'Steady progress. Complete a few more tasks or start a focus block to boost your score!';
  } else {
    level = 'Needs Improvement';
    message = 'A bit slow today. Let\'s try logging a 15-minute study block to build momentum.';
  }

  // Notes Created Today
  final notesToday = notes.where((n) {
    return n.createdAt.year == now.year && n.createdAt.month == now.month && n.createdAt.day == now.day;
  }).length;

  return ProductivityScoreData(
    score: calculatedScore,
    level: level,
    message: message,
    tasksCompletedToday: plannerStats.todayCompleted,
    focusMinutesToday: focusTodayMins,
    notesCreatedToday: notesToday,
    habitsCompletedToday: habitsCompleted,
  );
});
