// lib/features/dashboard/data/repositories/habits_repository_impl.dart
//
// Orynta 2.0 — Habits Repository Implementation

import 'package:flutter/foundation.dart';
import '../../domain/models/habits_state.dart';
import '../../domain/repositories/habits_repository.dart';

class HabitsRepositoryImpl implements HabitsRepository {
  const HabitsRepositoryImpl();

  @override
  Future<HabitsState> getHabitsState() async {
    try {
      // Returns empty state to test elegant empty state
      return const HabitsState(
        isLoading: false,
        habits: [],
        completedTodayCount: 0,
        totalTodayCount: 0,
        motivationalMessage: 'Keep it going.',
      );
    } catch (e) {
      assert(() {
        debugPrint('[HabitsRepositoryImpl] Error fetching habits: $e');
        return true;
      }());
      return const HabitsState(isLoading: false);
    }
  }
}
