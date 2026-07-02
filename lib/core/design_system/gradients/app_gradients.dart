// lib/core/design_system/gradients/app_gradients.dart
//
// Orynta 2.0 — Gradient System
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Gradients in a premium productivity app must be EXTREMELY subtle.
// They should not be visible as "gradients" — they should be felt as
// depth and atmosphere. Orynta uses:
//
//   • Surface gradients — barely-there tonal variation on backgrounds
//   • Accent gradients  — primary-tinted fills for highlighted areas
//   • Glass gradients   — frosted-glass effect preparation
//   • Shimmer gradients — loading skeleton animations
//   • Overlay gradients — image/card scrim overlays
//
// All gradients are defined per-theme variant (light, dark, AMOLED).
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   Container(
//     decoration: BoxDecoration(
//       gradient: AppGradients.primaryLight,
//     ),
//   )
//
//   // Resolve for current theme:
//   gradient: AppGradients.primary(context)

import 'package:flutter/material.dart';

/// Subtle, premium gradient definitions for Orynta 2.0.
abstract final class AppGradients {
  // ─── Primary Accent Gradients ─────────────────────────────────────────────
  // Use for hero sections, highlighted cards, feature banners.

  /// Primary gradient — Indigo tonal range (light)
  static const LinearGradient primaryLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6D63F0), Color(0xFF4F46E5)],
  );

  /// Primary gradient — Indigo tonal range (dark)
  static const LinearGradient primaryDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF818CF8), Color(0xFF6D63F0)],
  );

  /// Primary container gradient (very light, for card backgrounds)
  static const LinearGradient primaryContainerLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEFEEFF), Color(0xFFE8E7FF)],
  );

  static const LinearGradient primaryContainerDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D2B7E), Color(0xFF1E1D5E)],
  );

  // ─── Surface Gradients ────────────────────────────────────────────────────
  // Extremely subtle — creates atmosphere without shouting "gradient".

  /// Surface gradient (light) — tiny warm-to-cool tonal shift
  static const LinearGradient surfaceLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F8FA)],
  );

  /// Surface gradient (dark) — very subtle cool depth
  static const LinearGradient surfaceDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1E1E2E), Color(0xFF141420)],
  );

  /// Surface gradient (AMOLED) — near-black depth
  static const LinearGradient surfaceAmoled = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D0D18), Color(0xFF000000)],
  );

  // ─── Glass Effect Gradients ───────────────────────────────────────────────
  // For frosted glass containers. Apply with BackdropFilter(ImageFilter.blur).

  /// Glass gradient (light) — semi-transparent white
  static const LinearGradient glassLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xBBFFFFFF), Color(0x88FFFFFF)],
  );

  /// Glass gradient (dark) — semi-transparent dark
  static const LinearGradient glassDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x44252535), Color(0x281E1E2E)],
  );

  /// Glass gradient (AMOLED) — ultra-dark tinted glass
  static const LinearGradient glassAmoled = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x550D0D18), Color(0x33000000)],
  );

  // ─── Shimmer Gradients ────────────────────────────────────────────────────
  // For skeleton loading animations. Animate the alignment/stops to shimmer.

  /// Shimmer gradient (light) — left-to-right sweep
  static const LinearGradient shimmerLight = LinearGradient(
    begin: Alignment(-1.5, 0),
    end: Alignment(1.5, 0),
    colors: [
      Color(0xFFF1F1F5),
      Color(0xFFE8E8EF),
      Color(0xFFF1F1F5),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Shimmer gradient (dark) — subtle grey sweep
  static const LinearGradient shimmerDark = LinearGradient(
    begin: Alignment(-1.5, 0),
    end: Alignment(1.5, 0),
    colors: [
      Color(0xFF1E1E2E),
      Color(0xFF252538),
      Color(0xFF1E1E2E),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ─── Overlay / Scrim Gradients ────────────────────────────────────────────
  // For image cards, note backgrounds, bottom-of-list fades.

  /// Bottom scrim — for image cards (dark from bottom)
  static const LinearGradient cardScrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0x99000000)],
  );

  /// Top fade — for scrollable list top fade
  static const LinearGradient topFadeLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0x00FFFFFF)],
  );

  static const LinearGradient topFadeDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF141420), Color(0x00141420)],
  );

  // ─── Accent Gradients ─────────────────────────────────────────────────────
  // For dashboard feature areas, onboarding highlights.

  /// Accent: indigo-to-violet subtle tint
  static const LinearGradient accentIndigo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
  );

  /// Accent: success teal (for completion / streaks)
  static const LinearGradient accentSuccess = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF16A34A)],
  );

  /// Accent: warm amber (for warnings / streaks / focus)
  static const LinearGradient accentWarm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  // ─── Convenience Resolvers ────────────────────────────────────────────────

  /// Returns the correct primary gradient for the given [brightness].
  static LinearGradient primary(Brightness brightness) =>
      brightness == Brightness.light ? primaryLight : primaryDark;

  /// Returns the correct surface gradient for the given [brightness].
  static LinearGradient surface(Brightness brightness) =>
      brightness == Brightness.light ? surfaceLight : surfaceDark;

  /// Returns the correct glass gradient for the given [brightness].
  static LinearGradient glass(Brightness brightness) =>
      brightness == Brightness.light ? glassLight : glassDark;

  /// Returns the correct shimmer gradient for the given [brightness].
  static LinearGradient shimmer(Brightness brightness) =>
      brightness == Brightness.light ? shimmerLight : shimmerDark;
}
