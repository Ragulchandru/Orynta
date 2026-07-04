// lib/core/design_system/motion/motion_tokens.dart
//
// Orynta 2.0 — Premium Motion System Animation Constants

import 'package:flutter/material.dart';

abstract final class MotionTokens {
  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 320);
  static const Duration hero = Duration(milliseconds: 500);

  // Curves
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve decelerate = Curves.decelerate;

  // Aliases for M3 phase guidelines compatibility
  static Duration get durationNormal => normal;
  static Duration get durationFast => fast;
  static Curve get emphasizedCurve => emphasized;
  static Curve get decelerateCurve => decelerate;
}
