// lib/features/dashboard/data/repositories/today_repository_impl.dart
//
// Orynta 2.0 — Today Repository Implementation

import 'package:flutter/foundation.dart';

import '../../domain/models/notes_summary_data.dart';
import '../../domain/models/planner_summary_data.dart';
import '../../domain/models/reminder_summary_data.dart';
import '../../domain/models/tasks_summary_data.dart';
import '../../domain/models/today_state.dart';
import '../../domain/repositories/today_repository.dart';

class TodayRepositoryImpl implements TodayRepository {
  const TodayRepositoryImpl();

  @override
  Future<TodayState> getTodayState() async {
    try {
      // Aggregate data from local storage
      return const TodayState(
        isLoading: false,
        tasksSummary: TasksSummaryData(),
        notesSummary: NotesSummaryData(),
        reminderSummary: ReminderSummaryData(),
        plannerSummary: PlannerSummaryData(),
      );
    } catch (e) {
      assert(() {
        debugPrint('[TodayRepositoryImpl] Error fetching today state: $e');
        return true;
      }());
      return const TodayState(isLoading: false);
    }
  }
}
