// lib/core/design_system/radius/app_radius.dart
//
// Orynta 2.0 — Border Radius System
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Consistent radii create visual harmony across components.
// Larger radii feel friendlier and more modern; smaller radii feel
// precise and professional. Orynta uses a mid-range scale that balances
// both qualities for a premium productivity aesthetic.
//
// All values are Material 3 aligned:
//   xs   → 4dp  (badges, small chips)
//   sm   → 8dp  (chips, input chips, small buttons)
//   md   → 12dp (cards, text fields, standard containers)
//   lg   → 16dp (dialogs, prominent cards, sheets)
//   xl   → 24dp (bottom sheets, featured content areas)
//   full → 999dp (pills, avatars, circular FABs)
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   borderRadius: AppRadius.borderRadiusMd
//   borderRadius: AppRadius.borderRadiusMd
//   decoration: BoxDecoration(borderRadius: AppRadius.borderRadiusLg)

import 'package:flutter/material.dart';

/// Radius tokens and [BorderRadius] helpers for Orynta 2.0.
abstract final class AppRadius {
  // ─── Raw Values ───────────────────────────────────────────────────────────

  /// 4dp — Extra small: badge, indicator, tiny chip
  static const double xs   = 4.0;

  /// 8dp — Small: chip, input chip, small button, tag
  static const double sm   = 8.0;

  /// 12dp — Medium: card, text field, standard container
  static const double md   = 12.0;

  /// 16dp — Large: dialog, prominent card, action chip
  static const double lg   = 16.0;

  /// 20dp — Extra large: bottom sheet top corners, feature card
  static const double xl   = 20.0;

  /// 28dp — 2x extra large: modal, hero card
  static const double xxl  = 28.0;

  /// 999dp — Full: pill button, avatar, circular FAB
  static const double full = 999.0;

  // ─── Radius Objects ───────────────────────────────────────────────────────

  static const Radius radiusXs   = Radius.circular(xs);
  static const Radius radiusSm   = Radius.circular(sm);
  static const Radius radiusMd   = Radius.circular(md);
  static const Radius radiusLg   = Radius.circular(lg);
  static const Radius radiusXl   = Radius.circular(xl);
  static const Radius radiusXxl  = Radius.circular(xxl);
  static const Radius radiusFull = Radius.circular(full);

  // ─── BorderRadius Helpers ─────────────────────────────────────────────────

  /// `BorderRadius.circular(4)` — badges, tiny elements
  static const BorderRadius borderRadiusXs =
      BorderRadius.all(radiusXs);

  /// `BorderRadius.circular(8)` — chips, tags
  static const BorderRadius borderRadiusSm =
      BorderRadius.all(radiusSm);

  /// `BorderRadius.circular(12)` — cards, text fields
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(radiusMd);

  /// `BorderRadius.circular(16)` — dialogs, prominent cards
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(radiusLg);

  /// `BorderRadius.circular(20)` — bottom sheets, hero areas
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(radiusXl);

  /// `BorderRadius.circular(28)` — large modal surfaces
  static const BorderRadius borderRadiusXxl =
      BorderRadius.all(radiusXxl);

  /// `BorderRadius.circular(999)` — pill shapes, avatars
  static const BorderRadius borderRadiusFull =
      BorderRadius.all(radiusFull);

  // ─── Special Shapes ───────────────────────────────────────────────────────

  /// Bottom sheet: 20dp on top corners only
  static const BorderRadius bottomSheetRadius = BorderRadius.only(
    topLeft:  radiusXl,
    topRight: radiusXl,
  );

  /// Navigation drawer: 16dp on right corners only
  static const BorderRadius drawerRadius = BorderRadius.only(
    topRight:    radiusLg,
    bottomRight: radiusLg,
  );

  /// Top-only rounded (e.g., sticky header)
  static const BorderRadius topRadius = BorderRadius.only(
    topLeft:  radiusMd,
    topRight: radiusMd,
  );

  /// Bottom-only rounded (e.g., dropdown content)
  static const BorderRadius bottomRadius = BorderRadius.only(
    bottomLeft:  radiusMd,
    bottomRight: radiusMd,
  );
}
