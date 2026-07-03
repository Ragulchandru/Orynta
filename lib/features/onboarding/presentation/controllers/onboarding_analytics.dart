// lib/features/onboarding/presentation/controllers/onboarding_analytics.dart
//
// Orynta 2.0 — Internal Onboarding Analytics Logger
//
// Isolated internal logger for onboarding lifecycle events.
// No external services attached — used solely for debug tracking.

import 'package:flutter/foundation.dart';

abstract final class OnboardingAnalytics {
  static const String eventStarted = 'onboarding_started';
  static const String eventStartupSelected = 'startup_selected';
  static const String eventLayoutSelected = 'layout_selected';
  static const String eventThemeSelected = 'theme_selected';
  static const String eventNameEntered = 'name_entered';
  static const String eventCompleted = 'onboarding_completed';
  static const String eventSkipped = 'onboarding_skipped';

  static void log(String event, [Map<String, dynamic>? parameters]) {
    assert(() {
      debugPrint('[OnboardingAnalytics] Event: $event ${parameters ?? ""}');
      return true;
    }());
  }
}
