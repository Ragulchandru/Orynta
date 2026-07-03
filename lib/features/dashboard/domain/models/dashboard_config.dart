// lib/features/dashboard/domain/models/dashboard_config.dart
//
// Orynta 2.0 — Dashboard Configuration Model

import 'package:flutter/foundation.dart';

@immutable
class DashboardConfig {
  const DashboardConfig({
    this.enablePullToRefresh = true,
    this.enableAnimations = true,
    this.enableGlassEffects = true,
    this.enableModuleCustomization = true,
    this.enablePremiumModules = true,
    this.staggerAnimationDelay = const Duration(milliseconds: 50),
    this.defaultModuleSpacing = 16.0,
  });

  final bool enablePullToRefresh;
  final bool enableAnimations;
  final bool enableGlassEffects;
  final bool enableModuleCustomization;
  final bool enablePremiumModules;
  final Duration staggerAnimationDelay;
  final double defaultModuleSpacing;
}
