// lib/features/dashboard/domain/repositories/planner_snapshot_repository.dart
//
// Orynta 2.0 — Planner Snapshot Repository Interface

import '../models/planner_snapshot_state.dart';

abstract interface class PlannerSnapshotRepository {
  /// Fetches aggregated planner snapshot state.
  Future<PlannerSnapshotState> getPlannerSnapshot();
}
