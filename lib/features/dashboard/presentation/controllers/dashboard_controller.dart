// lib/features/dashboard/presentation/controllers/dashboard_controller.dart
//
// Orynta 2.0 — Dashboard Controller & State

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/dashboard_config.dart';
import '../../domain/models/dashboard_module.dart';
import '../../domain/repositories/dashboard_repository.dart';

@immutable
class DashboardState {
  const DashboardState({
    this.isLoading = true,
    this.hasError = false,
    this.errorMessage,
    this.modules = const [],
    this.isRefreshing = false,
    this.isCustomizing = false,
  });

  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final List<DashboardModule> modules;
  final bool isRefreshing;
  final bool isCustomizing;

  /// Returns sorted list of enabled modules.
  List<DashboardModule> get enabledModules {
    final enabled = modules.where((m) => m.enabled).toList();
    enabled.sort((a, b) => a.order.compareTo(b.order));
    return enabled;
  }

  DashboardState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    List<DashboardModule>? modules,
    bool? isRefreshing,
    bool? isCustomizing,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      modules: modules ?? this.modules,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isCustomizing: isCustomizing ?? this.isCustomizing,
    );
  }
}

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController(this._config, this._repository)
      : super(const DashboardState()) {
    loadModules();
  }

  final DashboardConfig _config;
  final DashboardRepository _repository;

  Future<void> loadModules() async {
    state = state.copyWith(isLoading: true, hasError: false);
    try {
      final modules = await _repository.getModules();
      state = state.copyWith(
        isLoading: false,
        modules: _applyStaggerDelays(modules),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load dashboard modules.',
      );
    }
  }

  Future<void> refresh() async {
    if (state.isRefreshing) return;
    state = state.copyWith(isRefreshing: true);
    try {
      final modules = await _repository.getModules();
      state = state.copyWith(
        isRefreshing: false,
        modules: _applyStaggerDelays(modules),
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false);
    }
  }

  Future<void> toggleModule(String id, bool enabled) async {
    final updated = state.modules.map((m) {
      if (m.id == id) {
        return m.copyWith(enabled: enabled);
      }
      return m;
    }).toList();

    state = state.copyWith(modules: updated);
    await _repository.setModuleEnabled(id, enabled);
  }

  Future<void> reorderModules(int oldIndex, int newIndex) async {
    final list = List<DashboardModule>.from(state.modules);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    final reordered = list.asMap().entries.map((e) {
      return e.value.copyWith(order: e.key);
    }).toList();

    state = state.copyWith(modules: _applyStaggerDelays(reordered));
    await _repository.saveModuleOrder(reordered.map((m) => m.id).toList());
  }

  Future<void> resetLayout() async {
    await _repository.resetLayout();
    await loadModules();
  }

  List<DashboardModule> _applyStaggerDelays(List<DashboardModule> modules) {
    if (!_config.enableAnimations) return modules;
    return modules.asMap().entries.map((e) {
      final delay = _config.staggerAnimationDelay * e.key;
      return e.value.copyWith(animationDelay: delay);
    }).toList();
  }
}
