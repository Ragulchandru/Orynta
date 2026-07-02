// lib/core/design_system/shadows/app_shadows.dart
//
// Orynta 2.0 — Shadow System
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Shadows create perceived depth. Premium apps use subtle, multi-layer
// shadows rather than single heavy drop-shadows. Each shadow layer handles
// a different aspect of depth perception:
//   Layer 1 — ambient light (very soft, spread wide)
//   Layer 2 — direct shadow (sharper, closer)
//
// Dark / AMOLED shadows are lighter or invisible since dark backgrounds
// inherently absorb shadow. Only the "glow" variant is useful on AMOLED.
//
// All shadow colors use black at low opacity to stay neutral and harmonious
// with any surface color.
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   Container(
//     decoration: BoxDecoration(
//       boxShadow: AppShadows.card,
//     ),
//   )
//
//   // Dark theme:
//   boxShadow: isDark ? AppShadows.cardDark : AppShadows.card

import 'package:flutter/material.dart';

/// Reusable [BoxShadow] lists for Orynta 2.0.
///
/// Three sets are provided: [light] mode shadows, [dark] mode shadows,
/// and [amoled] mode shadows. Use via [AppShadows.forBrightness].
abstract final class AppShadows {
  // ─── Light Theme Shadows ──────────────────────────────────────────────────

  /// Subtle card rest shadow (2dp equivalent).
  static const List<BoxShadow> cardLight = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 8,
      spreadRadius: 0,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ];

  /// Small shadow — tabs, chips, minor raised elements.
  static const List<BoxShadow> smallLight = [
    BoxShadow(
      color: Color(0x0C000000),
      blurRadius: 6,
      spreadRadius: 0,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 3,
      spreadRadius: 0,
      offset: Offset(0, 1),
    ),
  ];

  /// Medium shadow — modals, dropdowns.
  static const List<BoxShadow> mediumLight = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ];

  /// Large shadow — elevated dialogs.
  static const List<BoxShadow> largeLight = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 32,
      spreadRadius: 0,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];

  /// Floating shadow — FAB, floating toolbars.
  static const List<BoxShadow> floatingLight = [
    BoxShadow(
      color: Color(0x24000000),
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ];

  /// Dialog shadow — full-screen modal overlays.
  static const List<BoxShadow> dialogLight = [
    BoxShadow(
      color: Color(0x28000000),
      blurRadius: 48,
      spreadRadius: 0,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];

  // ─── Dark Theme Shadows ───────────────────────────────────────────────────
  // Reduced opacity — dark surfaces don't need heavy shadows.
  // Adding a subtle inset glow creates perceived depth without harsh shadows.

  /// Card shadow for dark theme.
  static const List<BoxShadow> cardDark = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 8,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ];

  /// Small shadow for dark theme.
  static const List<BoxShadow> smallDark = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 4,
      spreadRadius: 0,
      offset: Offset(0, 1),
    ),
  ];

  /// Medium shadow for dark theme.
  static const List<BoxShadow> mediumDark = [
    BoxShadow(
      color: Color(0x52000000),
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];

  /// Large shadow for dark theme.
  static const List<BoxShadow> largeDark = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 32,
      spreadRadius: 0,
      offset: Offset(0, 8),
    ),
  ];

  /// Floating shadow for dark theme.
  static const List<BoxShadow> floatingDark = [
    BoxShadow(
      color: Color(0x80000000),
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 6),
    ),
  ];

  /// Dialog shadow for dark theme.
  static const List<BoxShadow> dialogDark = [
    BoxShadow(
      color: Color(0x99000000),
      blurRadius: 48,
      spreadRadius: 0,
      offset: Offset(0, 12),
    ),
  ];

  // ─── AMOLED / True Black — Glow Shadows ───────────────────────────────────
  // On true-black backgrounds, traditional shadows are invisible.
  // Use subtle primary-tinted glow instead to indicate elevation.

  /// Primary glow for active/elevated elements on AMOLED.
  static List<BoxShadow> primaryGlow(Color primaryColor) => [
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.20),
      blurRadius: 16,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  /// Subtle card border glow for AMOLED.
  static const List<BoxShadow> cardAmoled = [
    BoxShadow(
      color: Color(0x14FFFFFF),
      blurRadius: 1,
      spreadRadius: 1,
      offset: Offset(0, 0),
    ),
  ];

  // ─── Convenience Resolver ─────────────────────────────────────────────────

  /// Returns the correct card shadow for the given [brightness].
  static List<BoxShadow> card(Brightness brightness) =>
      brightness == Brightness.light ? cardLight : cardDark;

  /// Returns the correct small shadow for the given [brightness].
  static List<BoxShadow> small(Brightness brightness) =>
      brightness == Brightness.light ? smallLight : smallDark;

  /// Returns the correct medium shadow for the given [brightness].
  static List<BoxShadow> medium(Brightness brightness) =>
      brightness == Brightness.light ? mediumLight : mediumDark;

  /// Returns the correct large shadow for the given [brightness].
  static List<BoxShadow> large(Brightness brightness) =>
      brightness == Brightness.light ? largeLight : largeDark;

  /// Returns the correct floating shadow for the given [brightness].
  static List<BoxShadow> floating(Brightness brightness) =>
      brightness == Brightness.light ? floatingLight : floatingDark;

  /// Returns the correct dialog shadow for the given [brightness].
  static List<BoxShadow> dialog(Brightness brightness) =>
      brightness == Brightness.light ? dialogLight : dialogDark;
}
