// lib/features/splash/domain/splash_config.dart
//
// Orynta 2.0 — Splash Configuration Entity
//
// Centralizes all customizable parameters for the Splash feature.
// Keeps SplashPage and components completely decoupled from magic values.

import 'package:flutter/foundation.dart';
import '../../../../core/design_system/durations/app_durations.dart';

/// Configuration options for the Splash Screen experience.
@immutable
class SplashConfig {
  const SplashConfig({
    this.heroTag = 'orynta_logo',
    this.logoAssetPath = 'assets/images/orynta_logo.png',
    this.minSplashDuration = AppDurations.splashTotal,
    this.reducedMotionDuration = AppDurations.splashReducedMotionTotal,
    this.maxSplashTimeout = const Duration(milliseconds: 5000),
    this.showTagline = true,
    this.showLoadingIndicator = true,
    this.enableAnimations = true,
  });

  /// Hero transition tag for seamless logo transition to subsequent screens.
  final String heroTag;

  /// Primary image asset path for the official Orynta logo.
  final String logoAssetPath;

  /// Minimum time the splash animation must run before navigating (2800ms).
  final Duration minSplashDuration;

  /// Splash time when Reduced Motion is enabled (1500ms).
  final Duration reducedMotionDuration;

  /// Safety fallback timeout to prevent infinite splash loading.
  final Duration maxSplashTimeout;

  /// Whether to render the tagline below the app title.
  final bool showTagline;

  /// Whether to render the 3-dot animated loading indicator.
  final bool showLoadingIndicator;

  /// Master switch for splash entrance animations.
  final bool enableAnimations;
}
