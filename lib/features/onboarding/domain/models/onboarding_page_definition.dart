// lib/features/onboarding/domain/models/onboarding_page_definition.dart
//
// Orynta 2.0 — Onboarding Page Definition
//
// Represents an onboarding step in an extensible list format.

import 'package:flutter/widgets.dart';

@immutable
class OnboardingPageDefinition {
  const OnboardingPageDefinition({
    required this.id,
    required this.stepNumber,
    required this.title,
    required this.widgetBuilder,
    this.allowSkip = true,
    this.analyticsEvent = '',
  });

  final String id;
  final int stepNumber;
  final String title;
  final WidgetBuilder widgetBuilder;
  final bool allowSkip;
  final String analyticsEvent;
}
