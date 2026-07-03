// lib/features/dashboard/domain/repositories/today_repository.dart
//
// Orynta 2.0 — Today Repository Interface

import '../models/today_state.dart';

abstract interface class TodayRepository {
  /// Aggregates daily summary data from feature repositories.
  Future<TodayState> getTodayState();
}
