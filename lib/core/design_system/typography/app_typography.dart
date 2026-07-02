// lib/core/design_system/typography/app_typography.dart
//
// Orynta 2.0 — Complete Typography System
//
// ── Font ─────────────────────────────────────────────────────────────────────
// ONLY Inter is used — a humanist sans-serif trusted by Linear, Figma,
// Notion, and other premium productivity applications. It offers superior
// legibility at every size on mobile screens.
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// • Each style has a clear semantic role — do not use display styles for body.
// • Line heights follow a 1.2–1.6 range for comfortable reading.
// • Letter spacing tightens for large headlines (reduce optically wide
//   spacing) and loosens for small labels (improve readability at small px).
// • Font weights communicate hierarchy — never rely on color alone.
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   // Preferred: read from theme (auto-adapts to light/dark color)
//   Text('Hello', style: Theme.of(context).textTheme.titleMedium)
//   Text('Hello', style: context.typography.titleMedium)
//
//   // Design System layer only:
//   AppTypography.titleMedium
//
// ── Material 3 Mapping ───────────────────────────────────────────────────────
// displayLarge   → 57sp  - Large hero text (rare in productivity apps)
// displayMedium  → 45sp  - Section hero text
// displaySmall   → 36sp  - Large feature headings
// headlineLarge  → 32sp  - Screen-level headings
// headlineMedium → 28sp  - Section headings
// headlineSmall  → 24sp  - Subsection headings
// titleLarge     → 22sp  - AppBar titles, dialog titles
// titleMedium    → 16sp  - Card titles, prominent labels
// titleSmall     → 14sp  - Secondary card headings
// bodyLarge      → 16sp  - Primary reading text
// bodyMedium     → 14sp  - Default body, list content
// bodySmall      → 12sp  - Secondary body, metadata
// labelLarge     → 14sp  - Button labels, primary chips
// labelMedium    → 12sp  - Chip labels, tags, badges
// labelSmall     → 11sp  - Timestamp, nav bar labels, captions

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full Material 3 type scale for Orynta 2.0.
///
/// ONLY Inter is used. All styles are defined as static getters that
/// return fresh [TextStyle] instances (required by google_fonts to allow
/// color-aware theme overrides from ThemeData.textTheme).
///
/// **Do not add a color here.** Colors come from the theme automatically.
abstract final class AppTypography {
  // ─── Internal helper ──────────────────────────────────────────────────────

  static TextStyle _inter({
    required double fontSize,
    required FontWeight fontWeight,
    double letterSpacing = 0.0,
    double height = 1.4,
  }) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
      );

  // ─── Display ──────────────────────────────────────────────────────────────
  // For large-format editorial content. Rare in productivity apps.

  /// 57sp / W300 / -0.25 tracking / 1.12 leading
  static TextStyle get displayLarge => _inter(
        fontSize: 57,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.25,
        height: 1.12,
      );

  /// 45sp / W300 / 0 tracking / 1.16 leading
  static TextStyle get displayMedium => _inter(
        fontSize: 45,
        fontWeight: FontWeight.w300,
        letterSpacing: 0,
        height: 1.16,
      );

  /// 36sp / W400 / 0 tracking / 1.22 leading
  static TextStyle get displaySmall => _inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      );

  // ─── Headline ─────────────────────────────────────────────────────────────
  // Screen-level headings and major section headings.

  /// 32sp / W600 / -0.5 tracking / 1.25 leading
  static TextStyle get headlineLarge => _inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.25,
      );

  /// 28sp / W600 / -0.25 tracking / 1.29 leading
  static TextStyle get headlineMedium => _inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.29,
      );

  /// 24sp / W600 / 0 tracking / 1.33 leading
  static TextStyle get headlineSmall => _inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
      );

  // ─── Title ────────────────────────────────────────────────────────────────
  // AppBar titles, card headings, dialog titles.

  /// 22sp / W600 / 0 tracking / 1.27 leading
  static TextStyle get titleLarge => _inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
      );

  /// 16sp / W500 / 0.1 tracking / 1.50 leading
  static TextStyle get titleMedium => _inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.50,
      );

  /// 14sp / W500 / 0.1 tracking / 1.43 leading
  static TextStyle get titleSmall => _inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  // ─── Body ─────────────────────────────────────────────────────────────────
  // Primary reading text. Most content will use bodyMedium.

  /// 16sp / W400 / 0.15 tracking / 1.55 leading
  static TextStyle get bodyLarge => _inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.55,
      );

  /// 14sp / W400 / 0.25 tracking / 1.50 leading
  static TextStyle get bodyMedium => _inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.50,
      );

  /// 12sp / W400 / 0.4 tracking / 1.45 leading
  static TextStyle get bodySmall => _inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.45,
      );

  // ─── Label ────────────────────────────────────────────────────────────────
  // Button labels, chips, nav tabs, badges, captions.

  /// 14sp / W600 / 0.1 tracking / 1.43 leading
  static TextStyle get labelLarge => _inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  /// 12sp / W500 / 0.5 tracking / 1.33 leading
  static TextStyle get labelMedium => _inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      );

  /// 11sp / W500 / 0.5 tracking / 1.45 leading — nav labels, timestamps
  static TextStyle get labelSmall => _inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      );

  // ─── Utility Styles ───────────────────────────────────────────────────────
  // Not part of the M3 scale, but commonly needed.

  /// Code / monospace body text — for future code block feature.
  static TextStyle get codeBody => GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.6,
      );

  /// Extra-large numeric display (timer, statistics counters).
  static TextStyle get numericDisplay => _inter(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.0,
      );

  /// Builds the complete [TextTheme] for use in [ThemeData].
  static TextTheme get textTheme => TextTheme(
        displayLarge:   displayLarge,
        displayMedium:  displayMedium,
        displaySmall:   displaySmall,
        headlineLarge:  headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall:  headlineSmall,
        titleLarge:     titleLarge,
        titleMedium:    titleMedium,
        titleSmall:     titleSmall,
        bodyLarge:      bodyLarge,
        bodyMedium:     bodyMedium,
        bodySmall:      bodySmall,
        labelLarge:     labelLarge,
        labelMedium:    labelMedium,
        labelSmall:     labelSmall,
      );
}
