// lib/features/dashboard/domain/models/quick_action.dart
//
// Orynta 2.0 — Quick Action Domain Entity

import 'package:flutter/material.dart';
import 'quick_action_type.dart';

@immutable
class QuickAction {
  const QuickAction({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.icon,
    this.route,
    this.enabled = true,
    this.requiresPremium = false,
    this.badge,
    required this.analyticsKey,
    required this.displayOrder,
    this.accentColor,
    this.category,
    this.requiresInternet = false,
    this.featureFlag,
    this.minimumAppVersion,
  });

  final String id;
  final QuickActionType type;
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? route;
  final bool enabled;
  final bool requiresPremium;
  final String? badge;
  final String analyticsKey;
  final int displayOrder;
  final Color? accentColor;
  final String? category;
  final bool requiresInternet;
  final String? featureFlag;
  final String? minimumAppVersion;

  QuickAction copyWith({
    String? id,
    QuickActionType? type,
    String? title,
    String? subtitle,
    IconData? icon,
    String? route,
    bool? enabled,
    bool? requiresPremium,
    String? badge,
    String? analyticsKey,
    int? displayOrder,
    Color? accentColor,
    String? category,
    bool? requiresInternet,
    String? featureFlag,
    String? minimumAppVersion,
  }) {
    return QuickAction(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      enabled: enabled ?? this.enabled,
      requiresPremium: requiresPremium ?? this.requiresPremium,
      badge: badge ?? this.badge,
      analyticsKey: analyticsKey ?? this.analyticsKey,
      displayOrder: displayOrder ?? this.displayOrder,
      accentColor: accentColor ?? this.accentColor,
      category: category ?? this.category,
      requiresInternet: requiresInternet ?? this.requiresInternet,
      featureFlag: featureFlag ?? this.featureFlag,
      minimumAppVersion: minimumAppVersion ?? this.minimumAppVersion,
    );
  }
}
