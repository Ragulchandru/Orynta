// lib/features/dashboard/domain/repositories/analytics_snapshot_repository.dart
//
// Orynta 2.0 — Analytics Snapshot Repository Interface

import '../models/analytics_snapshot.dart';

abstract interface class AnalyticsSnapshotRepository {
  /// Fetches aggregated analytics summary state.
  Future<AnalyticsSnapshot> getAnalyticsSnapshot();
}
