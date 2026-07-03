// lib/features/dashboard/presentation/providers/dashboard_providers.dart
//
// Orynta 2.0 — Dashboard Riverpod Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/models/dashboard_config.dart';
import '../../domain/models/dashboard_module.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../controllers/dashboard_controller.dart';

final dashboardConfigProvider = Provider<DashboardConfig>((ref) {
  return const DashboardConfig();
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final box = Hive.box<String>(AppStrings.settingsBoxName);
  return DashboardRepositoryImpl(box);
});

final dashboardControllerProvider =
    StateNotifierProvider.autoDispose<DashboardController, DashboardState>((ref) {
  final config = ref.watch(dashboardConfigProvider);
  final repository = ref.watch(dashboardRepositoryProvider);
  return DashboardController(config, repository);
});

final dashboardModulesProvider = Provider.autoDispose<List<DashboardModule>>((ref) {
  final state = ref.watch(dashboardControllerProvider);
  return state.enabledModules;
});
