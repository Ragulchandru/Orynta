// lib/features/onboarding/domain/models/onboarding_config.dart
//
// Orynta 2.0 — Onboarding Feature Configuration
//
// Centralizes feature flags, animation timings, and limits for the onboarding module.

import 'package:flutter/foundation.dart';

@immutable
class OnboardingConfig {
  const OnboardingConfig({
    this.totalPages = 4,
    this.preparationDuration = const Duration(milliseconds: 800),
    this.enableAnimations = true,
    this.enableAnalyticsEvents = true,
    this.enableSkipConfirmation = true,
    this.enableParallax = true,
    this.maxDisplayNameLength = 30,
  });

  /// Total number of onboarding pages (4).
  final int totalPages;

  /// Duration of the "Preparing your workspace..." transition (800ms).
  final Duration preparationDuration;

  /// Master animation toggle.
  final bool enableAnimations;

  /// Whether internal onboarding analytics events are logged.
  final bool enableAnalyticsEvents;

  /// Whether to prompt confirmation when skipping with modified inputs.
  final bool enableSkipConfirmation;

  /// Parallax effect during page view swiping.
  final bool enableParallax;

  /// Maximum character limit for user display name input.
  final int maxDisplayNameLength;
}
