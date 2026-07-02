// lib/core/design_system/glass/app_glass.dart
//
// Orynta 2.0 — Glass Effect Constants
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Glassmorphism is a powerful depth cue when used with restraint.
// Orynta's glass style is conservative — it never overwhelms content.
//
// To apply glass effect, combine:
//   1. ClipRRect / ClipPath for rounded clipping
//   2. BackdropFilter(filter: ImageFilter.blur(...)) for the blur
//   3. Container with glass gradient + border overlay for the glass look
//
// Glass is applied to:
//   • Floating AppBars (scrolled state)
//   • Overlay panels / drawers
//   • Bottom sheets with background content visible
//   • Action sheets on blurred backgrounds
//
// ── Readiness ────────────────────────────────────────────────────────────────
// This file ONLY provides constants. Actual glass widgets
// are implemented in Phase 1 Step 2 using these constants.
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   BackdropFilter(
//     filter: ImageFilter.blur(
//       sigmaX: AppGlass.blurSm,
//       sigmaY: AppGlass.blurSm,
//     ),
//     child: Container(
//       color: AppGlass.fillLight,
//       decoration: BoxDecoration(
//         border: Border.all(color: AppGlass.borderLight, width: AppGlass.borderWidth),
//         borderRadius: AppGlass.radius,
//       ),
//     ),
//   )

import 'package:flutter/material.dart';

/// Glass effect constants for Orynta 2.0.
///
/// Provides blur values, fill colors, border values, and radius
/// to be used when implementing glass/frosted surfaces.
abstract final class AppGlass {
  // ─── Blur Sigma Values ────────────────────────────────────────────────────
  // sigmaX and sigmaY — higher = more blur = more frosted

  /// 4.0 — very subtle blur (navbar, tab bar)
  static const double blurXs = 4.0;

  /// 8.0 — light blur (floating appbar, pinned header)
  static const double blurSm = 8.0;

  /// 16.0 — standard glass blur (modal panel, action sheet)
  static const double blurMd = 16.0;

  /// 24.0 — heavy blur (full-overlay glass panel)
  static const double blurLg = 24.0;

  /// 40.0 — maximum blur (splash screen, onboarding overlay)
  static const double blurXl = 40.0;

  // ─── Fill Colors (semi-transparent) ──────────────────────────────────────

  /// Light glass fill — 80% white
  static const Color fillLight = Color(0xCCFFFFFF);

  /// Light glass fill — subtle (60% white)
  static const Color fillLightSubtle = Color(0x99FFFFFF);

  /// Dark glass fill — 60% dark surface
  static const Color fillDark = Color(0x991E1E2E);

  /// Dark glass fill — subtle (40% dark surface)
  static const Color fillDarkSubtle = Color(0x661E1E2E);

  /// AMOLED glass fill — 70% near-black
  static const Color fillAmoled = Color(0xB30D0D18);

  // ─── Border ───────────────────────────────────────────────────────────────

  /// Standard glass border width
  static const double borderWidth = 1.0;

  /// Light glass border — very subtle white edge
  static const Color borderLight = Color(0x33FFFFFF);

  /// Dark glass border — very subtle bright edge
  static const Color borderDark = Color(0x22FFFFFF);

  /// AMOLED glass border
  static const Color borderAmoled = Color(0x18FFFFFF);

  // ─── Opacity ──────────────────────────────────────────────────────────────

  /// Background opacity for subtle glass (navbar)
  static const double opacitySubtle = 0.60;

  /// Background opacity for standard glass
  static const double opacityStandard = 0.80;

  /// Background opacity for heavy glass (modal)
  static const double opacityHeavy = 0.90;

  // ─── Radius ───────────────────────────────────────────────────────────────

  /// Standard glass border radius (12dp)
  static const double radius = 12.0;

  /// Large glass border radius (24dp) — bottom sheet
  static const double radiusLg = 24.0;

  // ─── Convenience Resolvers ────────────────────────────────────────────────

  /// Returns the appropriate fill color for the given [brightness].
  static Color fill(Brightness brightness) =>
      brightness == Brightness.light ? fillLight : fillDark;

  /// Returns the appropriate border color for the given [brightness].
  static Color border(Brightness brightness) =>
      brightness == Brightness.light ? borderLight : borderDark;
}
