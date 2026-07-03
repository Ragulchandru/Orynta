// lib/features/dashboard/presentation/providers/analytics_snapshot_providers.dart
//
// Orynta 2.0 — Analytics Snapshot Riverpod Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/analytics_snapshot_repository_impl.dart';
import '../../domain/models/analytics_snapshot.dart';
import '../../domain/repositories/analytics_snapshot_repository.dart';
import '../controllers/analytics_snapshot_controller.dart';

final analyticsSnapshotRepositoryProvider =
    Provider<AnalyticsSnapshotRepository>((ref) {
  return const AnalyticsSnapshotRepositoryImpl();
});

final analyticsSnapshotControllerProvider = StateNotifierProvider.autoDispose<
    AnalyticsSnapshotController, AnalyticsSnapshot>((ref) {
  final repository = ref.watch(analyticsSnapshotRepositoryProvider);
  return AnalyticsSnapshotController(repository);
});
