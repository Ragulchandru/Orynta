// lib/features/dashboard/data/repositories/analytics_snapshot_repository_impl.dart
//
// Orynta 2.0 — Analytics Snapshot Repository Implementation

import 'package:flutter/foundation.dart';
import '../../domain/models/analytics_snapshot.dart';
import '../../domain/repositories/analytics_snapshot_repository.dart';

class AnalyticsSnapshotRepositoryImpl implements AnalyticsSnapshotRepository {
  const AnalyticsSnapshotRepositoryImpl();

  @override
  Future<AnalyticsSnapshot> getAnalyticsSnapshot() async {
    try {
      // Returns empty analytics to test elegant empty state
      return const AnalyticsSnapshot(
        isLoading: false,
        focusMinutesToday: null,
        completionRate: null,
        productiveStreak: null,
        weeklyActivity: [],
      );
    } catch (e) {
      assert(() {
        debugPrint('[AnalyticsSnapshotRepositoryImpl] Error fetching snapshot: $e');
        return true;
      }());
      return const AnalyticsSnapshot(isLoading: false);
    }
  }
}
