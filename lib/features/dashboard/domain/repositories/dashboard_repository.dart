// lib/features/dashboard/domain/repositories/dashboard_repository.dart
//
// Orynta 2.0 — Dashboard Repository Interface

import '../models/dashboard_module.dart';

abstract interface class DashboardRepository {
  /// Fetches registered dashboard modules with stored user ordering and enable states.
  Future<List<DashboardModule>> getModules();

  /// Persists user custom module order.
  Future<void> saveModuleOrder(List<String> moduleIds);

  /// Toggles module enable/disable state.
  Future<void> setModuleEnabled(String moduleId, bool enabled);

  /// Resets dashboard layout to system default ordering.
  Future<void> resetLayout();
}
