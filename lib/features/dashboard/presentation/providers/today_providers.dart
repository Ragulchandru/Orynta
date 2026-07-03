// lib/features/dashboard/presentation/providers/today_providers.dart
//
// Orynta 2.0 — Today Module Riverpod Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/today_repository_impl.dart';
import '../../domain/models/today_state.dart';
import '../../domain/repositories/today_repository.dart';
import '../controllers/today_controller.dart';

final todayRepositoryProvider = Provider<TodayRepository>((ref) {
  return const TodayRepositoryImpl();
});

final todayControllerProvider =
    StateNotifierProvider.autoDispose<TodayController, TodayState>((ref) {
  final repository = ref.watch(todayRepositoryProvider);
  return TodayController(repository);
});
