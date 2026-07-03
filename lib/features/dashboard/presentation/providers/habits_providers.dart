// lib/features/dashboard/presentation/providers/habits_providers.dart
//
// Orynta 2.0 — Habits Riverpod Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/habits_repository_impl.dart';
import '../../domain/models/habits_state.dart';
import '../../domain/repositories/habits_repository.dart';
import '../controllers/habits_controller.dart';

final habitsRepositoryProvider = Provider<HabitsRepository>((ref) {
  return const HabitsRepositoryImpl();
});

final habitsControllerProvider =
    StateNotifierProvider.autoDispose<HabitsController, HabitsState>((ref) {
  final repository = ref.watch(habitsRepositoryProvider);
  return HabitsController(repository);
});
