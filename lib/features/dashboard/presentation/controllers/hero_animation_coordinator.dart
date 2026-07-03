// lib/features/dashboard/presentation/controllers/hero_animation_coordinator.dart
//
// Orynta 2.0 — Hero Animation Coordinator

import 'package:flutter/foundation.dart';

@immutable
class HeroAnimationDelays {
  const HeroAnimationDelays({
    this.cardDelay = const Duration(milliseconds: 0),
    this.greetingDelay = const Duration(milliseconds: 50),
    this.dateDelay = const Duration(milliseconds: 100),
    this.motivationDelay = const Duration(milliseconds: 150),
    this.scoreDelay = const Duration(milliseconds: 200),
  });

  final Duration cardDelay;
  final Duration greetingDelay;
  final Duration dateDelay;
  final Duration motivationDelay;
  final Duration scoreDelay;
}

class HeroAnimationCoordinator {
  const HeroAnimationCoordinator();

  HeroAnimationDelays calculateDelays([Duration baseDelay = Duration.zero]) {
    return HeroAnimationDelays(
      cardDelay: baseDelay,
      greetingDelay: baseDelay + const Duration(milliseconds: 50),
      dateDelay: baseDelay + const Duration(milliseconds: 100),
      motivationDelay: baseDelay + const Duration(milliseconds: 150),
      scoreDelay: baseDelay + const Duration(milliseconds: 200),
    );
  }
}
