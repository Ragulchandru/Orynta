// lib/features/dashboard/domain/models/dashboard_module.dart
//
// Orynta 2.0 — Dashboard Module Domain Entity

import 'package:flutter/widgets.dart';
import 'dashboard_module_type.dart';

@immutable
class DashboardModule {
  const DashboardModule({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.icon,
    this.enabled = true,
    required this.order,
    this.isPremium = false,
    this.isLocked = false,
    this.isCollapsed = false,
    this.animationDelay = Duration.zero,
  });

  final String id;
  final DashboardModuleType type;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool enabled;
  final int order;
  final bool isPremium;
  final bool isLocked;
  final bool isCollapsed;
  final Duration animationDelay;

  DashboardModule copyWith({
    String? id,
    DashboardModuleType? type,
    String? title,
    String? subtitle,
    IconData? icon,
    bool? enabled,
    int? order,
    bool? isPremium,
    bool? isLocked,
    bool? isCollapsed,
    Duration? animationDelay,
  }) {
    return DashboardModule(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      enabled: enabled ?? this.enabled,
      order: order ?? this.order,
      isPremium: isPremium ?? this.isPremium,
      isLocked: isLocked ?? this.isLocked,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      animationDelay: animationDelay ?? this.animationDelay,
    );
  }
}
