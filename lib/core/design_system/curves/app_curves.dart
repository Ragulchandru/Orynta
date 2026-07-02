// lib/core/design_system/curves/app_curves.dart
//
// Orynta 2.0 — Animation Curve Constants
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Curves determine the "feel" of an animation. Material 3 introduced
// an "emphasized" curve that mimics spring-like motion for natural movement.
//
// Guidelines:
//   • easeOut    — elements entering the screen (start fast, end slow)
//   • easeIn     — elements leaving the screen (start slow, end fast)
//   • easeInOut  — elements changing position within screen
//   • emphasized — prominent transitions (M3 standard, spring-like)
//   • linear     — precise, mechanical (progress bars, loading only)
//
// ── M3 Standard Curves ───────────────────────────────────────────────────────
//   Emphasized         → Cubic(0.2, 0.0, 0.0, 1.0) — enter/expand
//   EmphasizedDecel    → Cubic(0.05, 0.7, 0.1, 1.0) — object appears
//   EmphasizedAccel    → Cubic(0.3, 0.0, 0.8, 0.15) — object disappears
//   Standard           → Cubic(0.2, 0.0, 0.0, 1.0)
//   StandardDecel      → Cubic(0.0, 0.0, 0.0, 1.0)
//   StandardAccel      → Cubic(0.3, 0.0, 1.0, 1.0)
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   AnimatedContainer(
//     duration: AppDurations.normal,
//     curve: AppCurves.easeOut,
//   )

import 'package:flutter/material.dart';

/// Animation curve tokens for Orynta 2.0.
///
/// Pair with [AppDurations] for complete animation definitions.
abstract final class AppCurves {
  // ─── Material 3 Emphasized ────────────────────────────────────────────────

  /// M3 Emphasized — primary curve for prominent transitions (enter/expand).
  /// Spring-like feel without actual spring physics.
  static const Curve emphasized =
      Cubic(0.2, 0.0, 0.0, 1.0);

  /// M3 Emphasized Decelerate — element appears on screen (decelerates).
  static const Curve emphasizedDecelerate =
      Cubic(0.05, 0.7, 0.1, 1.0);

  /// M3 Emphasized Accelerate — element leaves screen (accelerates).
  static const Curve emphasizedAccelerate =
      Cubic(0.3, 0.0, 0.8, 0.15);

  // ─── Material 3 Standard ──────────────────────────────────────────────────

  /// M3 Standard — element moves across screen.
  static const Curve standard =
      Cubic(0.2, 0.0, 0.0, 1.0);

  /// M3 Standard Decelerate — element decelerates to final position.
  static const Curve standardDecelerate =
      Cubic(0.0, 0.0, 0.0, 1.0);

  /// M3 Standard Accelerate — element accelerates away.
  static const Curve standardAccelerate =
      Cubic(0.3, 0.0, 1.0, 1.0);

  // ─── Flutter Built-ins (aliased for semantic naming) ─────────────────────

  /// Smooth ease-in-out — elements repositioning within the screen.
  static const Curve easeInOut = Curves.easeInOut;

  /// Ease-in — elements exiting screen (start slow, end fast).
  static const Curve easeIn = Curves.easeIn;

  /// Ease-out — elements entering screen (start fast, end slow).
  static const Curve easeOut = Curves.easeOut;

  /// Cubic ease-in-out (more pronounced than [easeInOut]).
  static const Curve easeInOutCubic = Curves.easeInOutCubic;

  /// Cubic ease-out (snappy enter).
  static const Curve easeOutCubic = Curves.easeOutCubic;

  /// Cubic ease-in (snappy exit).
  static const Curve easeInCubic = Curves.easeInCubic;

  /// Quart ease-out — very snappy enter, used for lists stagger.
  static const Curve easeOutQuart = Curves.easeOutQuart;

  /// Expo ease-out — dramatic fast entry, used for hero elements.
  static const Curve easeOutExpo = Curves.easeOutExpo;

  /// Linear — for mechanical progress, shimmer, looping animations.
  static const Curve linear = Curves.linear;

  /// Bounce out — subtle elastic, used for pull-to-refresh.
  static const Curve bounceOut = Curves.bounceOut;

  /// Fast out, slow in — Material classic for panel closing.
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // ─── Component-Specific Aliases ───────────────────────────────────────────

  /// Page route enter transition
  static const Curve pageEnter = emphasizedDecelerate;

  /// Page route exit transition
  static const Curve pageExit = emphasizedAccelerate;

  /// Bottom sheet enter
  static const Curve bottomSheetEnter = emphasizedDecelerate;

  /// Bottom sheet exit
  static const Curve bottomSheetExit = emphasizedAccelerate;

  /// Dialog enter (scale + fade)
  static const Curve dialogEnter = emphasizedDecelerate;

  /// Dialog exit
  static const Curve dialogExit = emphasizedAccelerate;

  /// FAB appear (scale)
  static const Curve fabEnter = emphasizedDecelerate;

  /// Card expand / press
  static const Curve cardInteraction = easeOutCubic;

  /// Button press (fast response)
  static const Curve buttonPress = easeOutCubic;

  /// List item stagger enter
  static const Curve listItemEnter = easeOutQuart;

  /// Snack bar enter (slide up)
  static const Curve snackBarEnter = easeOutCubic;

  /// Pull to refresh elastic
  static const Curve pullToRefresh = bounceOut;
}
