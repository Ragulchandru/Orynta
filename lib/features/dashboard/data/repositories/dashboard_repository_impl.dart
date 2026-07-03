// lib/features/dashboard/data/repositories/dashboard_repository_impl.dart
//
// Orynta 2.0 — Dashboard Repository Implementation

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../domain/models/dashboard_module.dart';
import '../../domain/models/dashboard_module_type.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._box);

  final Box<String> _box;

  static final List<DashboardModule> _defaultModules = [
    const DashboardModule(
      id: 'hero',
      type: DashboardModuleType.hero,
      title: 'Overview',
      subtitle: 'Daily workspace status',
      icon: Icons.space_dashboard_rounded,
      order: 0,
      animationDelay: Duration(milliseconds: 0),
    ),
    const DashboardModule(
      id: 'quick_actions',
      type: DashboardModuleType.quickActions,
      title: 'Quick Actions',
      subtitle: 'Create & capture instantly',
      icon: Icons.flash_on_rounded,
      order: 1,
      animationDelay: Duration(milliseconds: 50),
    ),
    const DashboardModule(
      id: 'today',
      type: DashboardModuleType.today,
      title: "Today's Focus",
      subtitle: 'Scheduled priorities',
      icon: Icons.today_rounded,
      order: 2,
      animationDelay: Duration(milliseconds: 100),
    ),
    const DashboardModule(
      id: 'recent_notes',
      type: DashboardModuleType.recentNotes,
      title: 'Recent Notes',
      subtitle: 'Quickly access documents',
      icon: Icons.article_outlined,
      order: 3,
      animationDelay: Duration(milliseconds: 150),
    ),
    const DashboardModule(
      id: 'planner',
      type: DashboardModuleType.planner,
      title: 'Planner & Tasks',
      subtitle: 'Habits and schedule',
      icon: Icons.calendar_today_rounded,
      order: 4,
      animationDelay: Duration(milliseconds: 200),
    ),
    const DashboardModule(
      id: 'analytics',
      type: DashboardModuleType.analytics,
      title: 'Analytics & Focus',
      subtitle: 'Productivity trends',
      icon: Icons.insights_rounded,
      order: 5,
      animationDelay: Duration(milliseconds: 250),
    ),
  ];

  @override
  Future<List<DashboardModule>> getModules() async {
    try {
      final orderString = _box.get('dashboard_module_order');
      if (orderString == null || orderString.isEmpty) {
        return _defaultModules;
      }

      final orderList = orderString.split(',');
      final modulesMap = {for (var m in _defaultModules) m.id: m};
      final sorted = <DashboardModule>[];

      for (var i = 0; i < orderList.length; i++) {
        final id = orderList[i];
        if (modulesMap.containsKey(id)) {
          final disabledSetting = _box.get('dashboard_module_disabled_$id');
          final isEnabled = disabledSetting != 'true';
          sorted.add(
            modulesMap[id]!.copyWith(
              order: i,
              enabled: isEnabled,
            ),
          );
          modulesMap.remove(id);
        }
      }

      // Add any remaining default modules
      for (var m in modulesMap.values) {
        final disabledSetting = _box.get('dashboard_module_disabled_${m.id}');
        final isEnabled = disabledSetting != 'true';
        sorted.add(
          m.copyWith(
            order: sorted.length,
            enabled: isEnabled,
          ),
        );
      }

      return sorted;
    } catch (e) {
      assert(() {
        debugPrint('[DashboardRepositoryImpl] Error fetching modules: $e');
        return true;
      }());
      return _defaultModules;
    }
  }

  @override
  Future<void> saveModuleOrder(List<String> moduleIds) async {
    try {
      await _box.put('dashboard_module_order', moduleIds.join(','));
    } catch (e) {
      assert(() {
        debugPrint('[DashboardRepositoryImpl] Error saving module order: $e');
        return true;
      }());
    }
  }

  @override
  Future<void> setModuleEnabled(String moduleId, bool enabled) async {
    try {
      await _box.put('dashboard_module_disabled_$moduleId', enabled ? 'false' : 'true');
    } catch (e) {
      assert(() {
        debugPrint('[DashboardRepositoryImpl] Error saving module enabled state: $e');
        return true;
      }());
    }
  }

  @override
  Future<void> resetLayout() async {
    try {
      await _box.delete('dashboard_module_order');
      for (var m in _defaultModules) {
        await _box.delete('dashboard_module_disabled_${m.id}');
      }
    } catch (e) {
      assert(() {
        debugPrint('[DashboardRepositoryImpl] Error resetting layout: $e');
        return true;
      }());
    }
  }
}
