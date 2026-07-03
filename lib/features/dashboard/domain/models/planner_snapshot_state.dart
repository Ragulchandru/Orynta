// lib/features/dashboard/domain/models/planner_snapshot_state.dart
//
// Orynta 2.0 — Planner Snapshot Domain State

import 'package:flutter/foundation.dart';
import 'planner_event_summary.dart';

@immutable
class PlannerSnapshotState {
  const PlannerSnapshotState({
    this.isLoading = false,
    this.nextEvent,
    this.eventsTodayCount = 0,
    this.upcomingThisWeekCount = 0,
    this.freeTimeRemaining,
  });

  final bool isLoading;
  final PlannerEventSummary? nextEvent;
  final int eventsTodayCount;
  final int upcomingThisWeekCount;
  final String? freeTimeRemaining;

  bool get hasEvent => nextEvent != null;

  PlannerSnapshotState copyWith({
    bool? isLoading,
    PlannerEventSummary? nextEvent,
    int? eventsTodayCount,
    int? upcomingThisWeekCount,
    String? freeTimeRemaining,
  }) {
    return PlannerSnapshotState(
      isLoading: isLoading ?? this.isLoading,
      nextEvent: nextEvent ?? this.nextEvent,
      eventsTodayCount: eventsTodayCount ?? this.eventsTodayCount,
      upcomingThisWeekCount: upcomingThisWeekCount ?? this.upcomingThisWeekCount,
      freeTimeRemaining: freeTimeRemaining ?? this.freeTimeRemaining,
    );
  }
}
