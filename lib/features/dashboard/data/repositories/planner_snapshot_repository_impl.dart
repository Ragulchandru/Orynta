// lib/features/dashboard/data/repositories/planner_snapshot_repository_impl.dart
//
// Orynta 2.0 — Planner Snapshot Repository Implementation

import 'package:flutter/foundation.dart';
import '../../domain/models/planner_snapshot_state.dart';
import '../../domain/repositories/planner_snapshot_repository.dart';

class PlannerSnapshotRepositoryImpl implements PlannerSnapshotRepository {
  const PlannerSnapshotRepositoryImpl();

  @override
  Future<PlannerSnapshotState> getPlannerSnapshot() async {
    try {
      // Returns empty snapshot to test elegant empty state
      return const PlannerSnapshotState(
        isLoading: false,
        nextEvent: null,
        eventsTodayCount: 0,
        upcomingThisWeekCount: 0,
        freeTimeRemaining: null,
      );
    } catch (e) {
      assert(() {
        debugPrint('[PlannerSnapshotRepositoryImpl] Error fetching snapshot: $e');
        return true;
      }());
      return const PlannerSnapshotState(isLoading: false);
    }
  }
}
