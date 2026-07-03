// lib/features/dashboard/domain/models/weekly_activity.dart
//
// Orynta 2.0 — Weekly Activity Domain Entity

import 'package:flutter/foundation.dart';

@immutable
class WeeklyActivity {
  const WeeklyActivity({
    required this.weekday,
    required this.value,
    this.completed = false,
  });

  final String weekday; // e.g. "Mon", "Tue"
  final double value; // 0.0 to 1.0
  final bool completed;
}
