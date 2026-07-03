// lib/features/onboarding/domain/models/onboarding_preference_option.dart
//
// Orynta 2.0 — Generic Preference Option Model
//
// Reusable model for preference selection cards across Starting Screen, Notes Layout, and Theme options.

import 'package:flutter/material.dart';

@immutable
class OnboardingPreferenceOption<T> {
  const OnboardingPreferenceOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final T value;
}
