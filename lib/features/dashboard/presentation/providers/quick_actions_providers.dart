// lib/features/dashboard/presentation/providers/quick_actions_providers.dart
//
// Orynta 2.0 — Quick Actions Riverpod Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/quick_actions_repository_impl.dart';
import '../../domain/models/quick_actions_state.dart';
import '../../domain/repositories/quick_actions_repository.dart';
import '../controllers/quick_actions_controller.dart';

final quickActionsRepositoryProvider = Provider<QuickActionsRepository>((ref) {
  return const QuickActionsRepositoryImpl();
});

final quickActionsControllerProvider =
    StateNotifierProvider.autoDispose<QuickActionsController, QuickActionsState>((ref) {
  final repository = ref.watch(quickActionsRepositoryProvider);
  return QuickActionsController(repository);
});
