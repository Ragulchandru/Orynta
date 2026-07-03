// lib/features/dashboard/domain/repositories/quick_actions_repository.dart
//
// Orynta 2.0 — Quick Actions Repository Interface

import '../models/quick_action.dart';

abstract interface class QuickActionsRepository {
  /// Fetches available quick actions.
  Future<List<QuickAction>> getQuickActions();
}
