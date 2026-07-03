// lib/features/dashboard/domain/models/analytics_snapshot.dart
//
// Orynta 2.0 — Analytics Snapshot Domain Entity

import 'package:flutter/foundation.dart';
import 'weekly_activity.dart';

@immutable
class AnalyticsSnapshot {
  const AnalyticsSnapshot({
    this.isLoading = false,
    this.focusMinutesToday,
    this.completionRate,
    this.productiveStreak,
    this.weeklyActivity = const [],
  });

  final bool isLoading;
  final int? focusMinutesToday;
  final double? completionRate;
  final int? productiveStreak;
  final List<WeeklyActivity> weeklyActivity;

  bool get hasAnalytics =>
      (focusMinutesToday != null && focusMinutesToday! > 0) ||
      (completionRate != null && completionRate! > 0) ||
      (productiveStreak != null && productiveStreak! > 0) ||
      weeklyActivity.any((w) => w.value > 0);

  String get formattedFocusTime {
    if (focusMinutesToday == null || focusMinutesToday! <= 0) return '--';
    final hours = focusMinutesToday! ~/ 60;
    final mins = focusMinutesToday! % 60;
    if (hours > 0 && mins > 0) return '${hours}h ${mins}m';
    if (hours > 0) return '${hours}h';
    return '${mins}m';
  }

  String get formattedCompletionRate {
    if (completionRate == null || completionRate! <= 0) return '--';
    return '${(completionRate! * 100).round()}%';
  }

  String get formattedStreak {
    if (productiveStreak == null || productiveStreak! <= 0) return '--';
    return '🔥 $productiveStreak ${productiveStreak == 1 ? 'day' : 'days'}';
  }

  AnalyticsSnapshot copyWith({
    bool? isLoading,
    int? focusMinutesToday,
    double? completionRate,
    int? productiveStreak,
    List<WeeklyActivity>? weeklyActivity,
  }) {
    return AnalyticsSnapshot(
      isLoading: isLoading ?? this.isLoading,
      focusMinutesToday: focusMinutesToday ?? this.focusMinutesToday,
      completionRate: completionRate ?? this.completionRate,
      productiveStreak: productiveStreak ?? this.productiveStreak,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
    );
  }
}
