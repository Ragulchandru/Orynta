// lib/core/constants/app_sizes.dart
//
// Orynta 2.0 — Backward Compatibility Shim
//
// This file keeps all the old AppSizes constants intact while also
// re-exporting the new design system modules.
//
// Existing widgets that import this file continue to compile unchanged.
//
// ── Migration Path ────────────────────────────────────────────────────────────
// Prefer importing from the design system directly:
//   import 'package:orynta/core/design_system/design_tokens.dart';
//   // Then use AppSpacing.md, AppRadius.md, AppDimensions.toolbarHeight etc.
//
// This shim will be removed in a future cleanup phase.

// Re-export new design system spacing, radius, dimensions
export '../design_system/spacing/app_spacing.dart'    show AppSpacing;
export '../design_system/radius/app_radius.dart'      show AppRadius;
export '../design_system/dimensions/app_dimensions.dart' show AppDimensions;
export '../design_system/elevation/app_elevation.dart' show AppElevation;

/// Legacy spacing constants for widgets not yet migrated.
///
/// These mirror the original AppSizes values exactly.
/// Do NOT use these in new code — use AppSpacing.* instead.
abstract final class AppSizes {
  // ─── Spacing Scale ────────────────────────────────────────────────────────
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 16.0;
  static const double lg   = 24.0;
  static const double xl   = 32.0;
  static const double xxl  = 48.0;
  static const double xxxl = 64.0;

  // ─── Border Radius Scale ──────────────────────────────────────────────────
  static const double radiusSm   = 8.0;
  static const double radiusMd   = 12.0;
  static const double radiusLg   = 16.0;
  static const double radiusXl   = 24.0;
  static const double radiusFull = 999.0;

  // ─── Icon Sizes ───────────────────────────────────────────────────────────
  static const double iconSm   = 16.0;
  static const double iconMd   = 24.0;
  static const double iconLg   = 32.0;
  static const double iconXl   = 48.0;
  static const double iconHero = 80.0;

  // ─── Elevation ────────────────────────────────────────────────────────────
  static const double elevationNone = 0.0;
  static const double elevationSm   = 1.0;
  static const double elevationMd   = 3.0;
  static const double elevationLg   = 6.0;
  static const double elevationXl   = 12.0;

  // ─── Animation Durations ──────────────────────────────────────────────────
  static const Duration durationFast   = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow   = Duration(milliseconds: 500);

  // ─── Component Sizes ─────────────────────────────────────────────────────
  static const double buttonHeight  = 48.0;
  static const double textFieldHeight = 52.0;
  static const double fabSize       = 56.0;
  static const double appBarHeight  = 56.0;
  static const double cardPadding   = 16.0;
}
