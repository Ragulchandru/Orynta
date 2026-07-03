// lib/features/dashboard/presentation/controllers/planner_snapshot_controller.dart
//
// Orynta 2.0 — Planner Snapshot Controller

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/planner_snapshot_state.dart';
import '../../domain/repositories/planner_snapshot_repository.dart';

class PlannerSnapshotController extends StateNotifier<PlannerSnapshotState> {
  PlannerSnapshotController(this._repository)
      : super(const PlannerSnapshotState(isLoading: true)) {
    loadPlannerSnapshot();
  }

  final PlannerSnapshotRepository _repository;

  Future<void> loadPlannerSnapshot() async {
    state = state.copyWith(isLoading: true);
    final snapshot = await _repository.getPlannerSnapshot();
    state = snapshot;
  }

  Future<void> refresh() async {
    final snapshot = await _repository.getPlannerSnapshot();
    state = snapshot;
  }
}
