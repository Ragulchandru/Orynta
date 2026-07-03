// lib/features/dashboard/domain/models/habits_state.dart
//
// Orynta 2.0 — Habits Domain State

import 'package:flutter/foundation.dart';
import 'habit_summary.dart';

@immutable
class HabitsState {
  const HabitsState({
    this.isLoading = false,
    this.habits = const [],
    this.completedTodayCount = 0,
    this.totalTodayCount = 0,
    this.motivationalMessage = 'Keep it going.',
  });

  final bool isLoading;
  final List<HabitSummary> habits;
  final int completedTodayCount;
  final int totalTodayCount;
  final String motivationalMessage;

  bool get hasHabits => habits.isNotEmpty || totalTodayCount > 0;

  double get completionPercentage {
    if (totalTodayCount <= 0) return 0.0;
    return (completedTodayCount / totalTodayCount).clamp(0.0, 1.0);
  }

  int get percentageRatio => (completionPercentage * 100).round();

  HabitsState copyWith({
    bool? isLoading,
    List<HabitSummary>? habits,
    int? completedTodayCount,
    int? totalTodayCount,
    String? motivationalMessage,
  }) {
    return HabitsState(
      isLoading: isLoading ?? this.isLoading,
      habits: habits ?? this.habits,
      completedTodayCount: completedTodayCount ?? this.completedTodayCount,
      totalTodayCount: totalTodayCount ?? this.totalTodayCount,
      motivationalMessage: motivationalMessage ?? this.motivationalMessage,
    );
  }
}
