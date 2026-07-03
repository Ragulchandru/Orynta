// lib/features/dashboard/presentation/controllers/analytics_snapshot_controller.dart
//
// Orynta 2.0 — Analytics Snapshot Controller

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/analytics_snapshot.dart';
import '../../domain/repositories/analytics_snapshot_repository.dart';

class AnalyticsSnapshotController extends StateNotifier<AnalyticsSnapshot> {
  AnalyticsSnapshotController(this._repository)
      : super(const AnalyticsSnapshot(isLoading: true)) {
    loadAnalyticsSnapshot();
  }

  final AnalyticsSnapshotRepository _repository;

  Future<void> loadAnalyticsSnapshot() async {
    state = state.copyWith(isLoading: true);
    final snapshot = await _repository.getAnalyticsSnapshot();
    state = snapshot;
  }

  Future<void> refresh() async {
    final snapshot = await _repository.getAnalyticsSnapshot();
    state = snapshot;
  }
}
