// lib/features/dashboard/presentation/controllers/today_controller.dart
//
// Orynta 2.0 — Today Controller

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/today_state.dart';
import '../../domain/repositories/today_repository.dart';

class TodayController extends StateNotifier<TodayState> {
  TodayController(this._repository) : super(const TodayState(isLoading: true)) {
    loadTodayData();
  }

  final TodayRepository _repository;

  Future<void> loadTodayData() async {
    state = state.copyWith(isLoading: true);
    final newState = await _repository.getTodayState();
    state = newState;
  }

  Future<void> refresh() async {
    final newState = await _repository.getTodayState();
    state = newState;
  }
}
