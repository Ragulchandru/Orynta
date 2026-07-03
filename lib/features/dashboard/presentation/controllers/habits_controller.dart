// lib/features/dashboard/presentation/controllers/habits_controller.dart
//
// Orynta 2.0 — Habits Controller

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/habits_state.dart';
import '../../domain/repositories/habits_repository.dart';

class HabitsController extends StateNotifier<HabitsState> {
  HabitsController(this._repository)
      : super(const HabitsState(isLoading: true)) {
    loadHabits();
  }

  final HabitsRepository _repository;

  Future<void> loadHabits() async {
    state = state.copyWith(isLoading: true);
    final habitsState = await _repository.getHabitsState();
    state = habitsState;
  }

  Future<void> refresh() async {
    final habitsState = await _repository.getHabitsState();
    state = habitsState;
  }
}
