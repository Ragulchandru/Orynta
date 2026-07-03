// lib/features/dashboard/domain/repositories/habits_repository.dart
//
// Orynta 2.0 — Habits Repository Interface

import '../models/habits_state.dart';

abstract interface class HabitsRepository {
  /// Aggregates today's habit summaries and streaks.
  Future<HabitsState> getHabitsState();
}
