// lib/features/dashboard/presentation/providers/planner_snapshot_providers.dart
//
// Orynta 2.0 — Planner Snapshot Riverpod Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/planner_snapshot_repository_impl.dart';
import '../../domain/models/planner_snapshot_state.dart';
import '../../domain/repositories/planner_snapshot_repository.dart';
import '../controllers/planner_snapshot_controller.dart';

final plannerSnapshotRepositoryProvider = Provider<PlannerSnapshotRepository>((ref) {
  return const PlannerSnapshotRepositoryImpl();
});

final plannerSnapshotControllerProvider =
    StateNotifierProvider.autoDispose<PlannerSnapshotController, PlannerSnapshotState>((ref) {
  final repository = ref.watch(plannerSnapshotRepositoryProvider);
  return PlannerSnapshotController(repository);
});
