// lib/features/dashboard/domain/models/habit_summary.dart
//
// Orynta 2.0 — Habit Summary Domain Entity

import 'package:flutter/material.dart';

@immutable
class HabitSummary {
  const HabitSummary({
    required this.id,
    required this.title,
    required this.icon,
    this.streakCount = 0,
    this.isCompletedToday = false,
    this.hasReminder = false,
    this.category,
    this.weeklyStreak,
    this.monthlyGoal,
    this.colorHex,
    this.aiCoachingTip,
  });

  final String id;
  final String title;
  final IconData icon;
  final int streakCount;
  final bool isCompletedToday;
  final bool hasReminder;
  final String? category;
  final int? weeklyStreak;
  final int? monthlyGoal;
  final String? colorHex;
  final String? aiCoachingTip;

  /// Returns friendly streak string (e.g. "🔥 5 day streak").
  String get streakLabel {
    if (streakCount <= 0) return 'New habit';
    return '🔥 $streakCount ${streakCount == 1 ? 'day' : 'days'} streak';
  }
}
