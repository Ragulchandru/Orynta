// lib/core/design_system/borders/app_borders.dart
//
// Orynta 2.0 — Borders Tokens

import 'package:flutter/material.dart';

abstract final class AppBorders {
  static const double thin = 1.0;
  static const double medium = 1.5;
  static const double thick = 2.0;

  static const BorderSide thinSide = BorderSide(width: thin);
  static const BorderSide mediumSide = BorderSide(width: medium);
  static const BorderSide thickSide = BorderSide(width: thick);
}
