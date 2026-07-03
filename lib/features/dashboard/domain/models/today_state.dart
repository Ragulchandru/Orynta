// lib/features/dashboard/domain/models/today_state.dart
//
// Orynta 2.0 — Today Module Aggregated State

import 'package:flutter/foundation.dart';
import 'notes_summary_data.dart';
import 'planner_summary_data.dart';
import 'reminder_summary_data.dart';
import 'tasks_summary_data.dart';

@immutable
class TodayState {
  const TodayState({
    this.isLoading = false,
    this.tasksSummary = const TasksSummaryData(),
    this.notesSummary = const NotesSummaryData(),
    this.reminderSummary = const ReminderSummaryData(),
    this.plannerSummary = const PlannerSummaryData(),
  });

  final bool isLoading;
  final TasksSummaryData tasksSummary;
  final NotesSummaryData notesSummary;
  final ReminderSummaryData reminderSummary;
  final PlannerSummaryData plannerSummary;

  TodayState copyWith({
    bool? isLoading,
    TasksSummaryData? tasksSummary,
    NotesSummaryData? notesSummary,
    ReminderSummaryData? reminderSummary,
    PlannerSummaryData? plannerSummary,
  }) {
    return TodayState(
      isLoading: isLoading ?? this.isLoading,
      tasksSummary: tasksSummary ?? this.tasksSummary,
      notesSummary: notesSummary ?? this.notesSummary,
      reminderSummary: reminderSummary ?? this.reminderSummary,
      plannerSummary: plannerSummary ?? this.plannerSummary,
    );
  }
}
