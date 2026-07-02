// lib/core/design_system/colors/app_colors.dart
//
// Orynta 2.0 — Complete Semantic Color System
//
// ── Philosophy ──────────────────────────────────────────────────────────────
// Colors are defined as semantic tokens, not raw palette values.
// Widgets should NEVER reference raw hex codes — always use a named token.
//
// Three surface modes are provided:
//   • Light   — warm white surfaces, crisp contrast
//   • Dark    — deep charcoal surfaces, soft contrast
//   • AMOLED  — true-black surfaces for OLED battery saving
//
// ── Brand ───────────────────────────────────────────────────────────────────
// Primary: Refined Indigo (#4F46E5) — professional, focused, trustworthy
// Accent:  Slate-blue tones for a calm, productivity-first feel
//
// ── Usage ───────────────────────────────────────────────────────────────────
//   // In a widget, always prefer theme tokens:
//   context.colors.primary
//   context.colors.surface
//   Theme.of(context).colorScheme.primary
//
//   // Raw tokens (only in design_system layer):
//   AppColors.primaryBase
//   AppColors.surfaceDark

import 'package:flutter/material.dart';

/// Raw color primitives and semantic color sets for Orynta 2.0.
///
/// Contains three static instances — [light], [dark], [amoled] —
/// each of type [OryAppColors], exposing all semantic tokens.
abstract final class AppColors {
  // ─── Brand / Seed ─────────────────────────────────────────────────────────

  /// The Material 3 seed color — generates the entire tonal palette.
  /// Refined Indigo: premium, focused, trustworthy.
  static const Color seedColor = Color(0xFF4F46E5);

  /// Brand primary — same as seed, used directly where needed.
  static const Color primaryBase = Color(0xFF4F46E5);

  /// Lighter primary tint for surfaces and containers.
  static const Color primaryLight = Color(0xFF6D63F0);

  /// Darker primary shade for pressed states.
  static const Color primaryDark = Color(0xFF3730C5);

  // ─── Neutral Palette (12-step greyscale) ──────────────────────────────────
  static const Color neutral0   = Color(0xFFFFFFFF);
  static const Color neutral50  = Color(0xFFF8F8FA);
  static const Color neutral100 = Color(0xFFF1F1F5);
  static const Color neutral150 = Color(0xFFE8E8EF);
  static const Color neutral200 = Color(0xFFDFDFE8);
  static const Color neutral300 = Color(0xFFC5C5D3);
  static const Color neutral400 = Color(0xFF9A9AB0);
  static const Color neutral500 = Color(0xFF6E6E8A);
  static const Color neutral600 = Color(0xFF4E4E68);
  static const Color neutral700 = Color(0xFF38384E);
  static const Color neutral800 = Color(0xFF252535);
  static const Color neutral850 = Color(0xFF1A1A28);
  static const Color neutral900 = Color(0xFF11111C);
  static const Color neutral950 = Color(0xFF080810);
  static const Color neutral1000 = Color(0xFF000000);

  // ─── Semantic Color Sets ──────────────────────────────────────────────────

  /// Light theme semantic colors.
  static const OryAppColors light = OryAppColors(
    primary:         Color(0xFF4F46E5),
    primaryVariant:  Color(0xFF3730C5),
    onPrimary:       Color(0xFFFFFFFF),
    primaryContainer:    Color(0xFFE8E7FF),
    onPrimaryContainer:  Color(0xFF1B1770),

    secondary:       Color(0xFF6366F1),
    onSecondary:     Color(0xFFFFFFFF),
    secondaryContainer:   Color(0xFFEEEEFD),
    onSecondaryContainer: Color(0xFF23246B),

    background:      Color(0xFFF8F8FA),
    onBackground:    Color(0xFF11111C),

    surface:         Color(0xFFFFFFFF),
    onSurface:       Color(0xFF11111C),
    surfaceVariant:  Color(0xFFF1F1F5),
    onSurfaceVariant: Color(0xFF4E4E68),
    surfaceContainer:     Color(0xFFF1F1F5),
    surfaceContainerLow:  Color(0xFFF8F8FA),
    surfaceContainerHigh: Color(0xFFE8E8EF),

    card:            Color(0xFFFFFFFF),
    onCard:          Color(0xFF11111C),
    cardBorder:      Color(0xFFE8E8EF),

    outline:         Color(0xFFDFDFE8),
    outlineVariant:  Color(0xFFEEEEF5),
    divider:         Color(0xFFEEEEF5),

    textPrimary:     Color(0xFF11111C),
    textSecondary:   Color(0xFF4E4E68),
    textHint:        Color(0xFF9A9AB0),
    textDisabled:    Color(0xFFC5C5D3),

    success:         Color(0xFF16A34A),
    onSuccess:       Color(0xFFFFFFFF),
    successContainer:    Color(0xFFDCFCE7),
    onSuccessContainer:  Color(0xFF14532D),

    warning:         Color(0xFFD97706),
    onWarning:       Color(0xFFFFFFFF),
    warningContainer:    Color(0xFFFEF3C7),
    onWarningContainer:  Color(0xFF78350F),

    error:           Color(0xFFDC2626),
    onError:         Color(0xFFFFFFFF),
    errorContainer:      Color(0xFFFEE2E2),
    onErrorContainer:    Color(0xFF7F1D1D),

    info:            Color(0xFF2563EB),
    onInfo:          Color(0xFFFFFFFF),
    infoContainer:       Color(0xFFDBEAFE),
    onInfoContainer:     Color(0xFF1E3A8A),

    overlay:         Color(0x33000000),
    scrim:           Color(0x99000000),
    transparent:     Color(0x00000000),

    brightness:      Brightness.light,
  );

  /// Dark theme semantic colors.
  static const OryAppColors dark = OryAppColors(
    primary:         Color(0xFF818CF8),
    primaryVariant:  Color(0xFF6D63F0),
    onPrimary:       Color(0xFF1B1770),
    primaryContainer:    Color(0xFF2D2B7E),
    onPrimaryContainer:  Color(0xFFE8E7FF),

    secondary:       Color(0xFF818CF8),
    onSecondary:     Color(0xFF23246B),
    secondaryContainer:   Color(0xFF2E2F7E),
    onSecondaryContainer: Color(0xFFEEEEFD),

    background:      Color(0xFF0F0F17),
    onBackground:    Color(0xFFEFEFF8),

    surface:         Color(0xFF141420),
    onSurface:       Color(0xFFEFEFF8),
    surfaceVariant:  Color(0xFF1E1E2E),
    onSurfaceVariant: Color(0xFFC5C5D3),
    surfaceContainer:     Color(0xFF1E1E2E),
    surfaceContainerLow:  Color(0xFF18182A),
    surfaceContainerHigh: Color(0xFF252538),

    card:            Color(0xFF1E1E2E),
    onCard:          Color(0xFFEFEFF8),
    cardBorder:      Color(0xFF2A2A40),

    outline:         Color(0xFF38384E),
    outlineVariant:  Color(0xFF2A2A40),
    divider:         Color(0xFF252535),

    textPrimary:     Color(0xFFEFEFF8),
    textSecondary:   Color(0xFFC5C5D3),
    textHint:        Color(0xFF6E6E8A),
    textDisabled:    Color(0xFF4E4E68),

    success:         Color(0xFF4ADE80),
    onSuccess:       Color(0xFF14532D),
    successContainer:    Color(0xFF166534),
    onSuccessContainer:  Color(0xFFDCFCE7),

    warning:         Color(0xFFFBBF24),
    onWarning:       Color(0xFF78350F),
    warningContainer:    Color(0xFF92400E),
    onWarningContainer:  Color(0xFFFEF3C7),

    error:           Color(0xFFF87171),
    onError:         Color(0xFF7F1D1D),
    errorContainer:      Color(0xFF991B1B),
    onErrorContainer:    Color(0xFFFEE2E2),

    info:            Color(0xFF60A5FA),
    onInfo:          Color(0xFF1E3A8A),
    infoContainer:       Color(0xFF1D4ED8),
    onInfoContainer:     Color(0xFFDBEAFE),

    overlay:         Color(0x52000000),
    scrim:           Color(0xBF000000),
    transparent:     Color(0x00000000),

    brightness:      Brightness.dark,
  );

  /// AMOLED theme semantic colors — true-black for OLED displays.
  static const OryAppColors amoled = OryAppColors(
    primary:         Color(0xFF818CF8),
    primaryVariant:  Color(0xFF6D63F0),
    onPrimary:       Color(0xFF1B1770),
    primaryContainer:    Color(0xFF1E1D5E),
    onPrimaryContainer:  Color(0xFFE8E7FF),

    secondary:       Color(0xFF818CF8),
    onSecondary:     Color(0xFF1B1770),
    secondaryContainer:   Color(0xFF1C1C5C),
    onSecondaryContainer: Color(0xFFEEEEFD),

    background:      Color(0xFF000000),
    onBackground:    Color(0xFFEFEFF8),

    surface:         Color(0xFF000000),
    onSurface:       Color(0xFFEFEFF8),
    surfaceVariant:  Color(0xFF0D0D18),
    onSurfaceVariant: Color(0xFFC5C5D3),
    surfaceContainer:     Color(0xFF0D0D18),
    surfaceContainerLow:  Color(0xFF050510),
    surfaceContainerHigh: Color(0xFF141424),

    card:            Color(0xFF0D0D18),
    onCard:          Color(0xFFEFEFF8),
    cardBorder:      Color(0xFF1A1A2E),

    outline:         Color(0xFF252535),
    outlineVariant:  Color(0xFF1A1A2E),
    divider:         Color(0xFF111122),

    textPrimary:     Color(0xFFEFEFF8),
    textSecondary:   Color(0xFFC5C5D3),
    textHint:        Color(0xFF6E6E8A),
    textDisabled:    Color(0xFF38384E),

    success:         Color(0xFF4ADE80),
    onSuccess:       Color(0xFF14532D),
    successContainer:    Color(0xFF0D3321),
    onSuccessContainer:  Color(0xFFDCFCE7),

    warning:         Color(0xFFFBBF24),
    onWarning:       Color(0xFF78350F),
    warningContainer:    Color(0xFF4A2008),
    onWarningContainer:  Color(0xFFFEF3C7),

    error:           Color(0xFFF87171),
    onError:         Color(0xFF7F1D1D),
    errorContainer:      Color(0xFF4D0F0F),
    onErrorContainer:    Color(0xFFFEE2E2),

    info:            Color(0xFF60A5FA),
    onInfo:          Color(0xFF1E3A8A),
    infoContainer:       Color(0xFF0F2B5C),
    onInfoContainer:     Color(0xFFDBEAFE),

    overlay:         Color(0x52000000),
    scrim:           Color(0xCC000000),
    transparent:     Color(0x00000000),

    brightness:      Brightness.dark,
  );

  // ─── Note Background Colors (Hive-compatible ARGB ints) ───────────────────
  // Stored in Hive as int (ARGB). Curated to be subtle on both light/dark.

  /// Default — no tint, uses card surface.
  static const int noteColorDefault  = 0xFFFFFFFF;

  /// Soft lavender — calm, creative.
  static const int noteColorLavender = 0xFFEDE9FE;

  /// Sage mint — fresh, organized.
  static const int noteColorMint     = 0xFFD1FAE5;

  /// Warm peach — energetic, warm.
  static const int noteColorPeach    = 0xFFFFEDD5;

  /// Soft butter — cheerful, light.
  static const int noteColorButter   = 0xFFFEF9C3;

  /// Blush rose — gentle, personal.
  static const int noteColorRose     = 0xFFFFE4E6;

  /// Sky blue — clear, focused.
  static const int noteColorSky      = 0xFFDBEAFE;

  /// Warm sand — earthy, grounded.
  static const int noteColorSand     = 0xFFF5F0E8;

  /// All note colors in display order.
  static const List<int> noteColors = [
    noteColorDefault,
    noteColorLavender,
    noteColorMint,
    noteColorPeach,
    noteColorButter,
    noteColorRose,
    noteColorSky,
    noteColorSand,
  ];
}

// ─── Semantic Color Set ────────────────────────────────────────────────────

/// A complete set of semantic color tokens for one theme variant.
///
/// Used by [AppColors.light], [AppColors.dark], and [AppColors.amoled].
/// The ThemeExtension wraps this to make it available via `context.colors`.
@immutable
class OryAppColors {
  const OryAppColors({
    required this.primary,
    required this.primaryVariant,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.surfaceContainer,
    required this.surfaceContainerLow,
    required this.surfaceContainerHigh,
    required this.card,
    required this.onCard,
    required this.cardBorder,
    required this.outline,
    required this.outlineVariant,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textDisabled,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.overlay,
    required this.scrim,
    required this.transparent,
    required this.brightness,
  });

  // ── Brand ──────────────────────────────────────────────────────────────────
  final Color primary;
  final Color primaryVariant;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;

  // ── Surfaces ───────────────────────────────────────────────────────────────
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color surfaceContainer;
  final Color surfaceContainerLow;
  final Color surfaceContainerHigh;

  // ── Card ───────────────────────────────────────────────────────────────────
  final Color card;
  final Color onCard;
  final Color cardBorder;

  // ── Borders & Dividers ────────────────────────────────────────────────────
  final Color outline;
  final Color outlineVariant;
  final Color divider;

  // ── Text ───────────────────────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color textDisabled;

  // ── Semantic States ────────────────────────────────────────────────────────
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;

  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  // ── Utility ────────────────────────────────────────────────────────────────
  final Color overlay;
  final Color scrim;
  final Color transparent;

  // ── Meta ───────────────────────────────────────────────────────────────────
  final Brightness brightness;

  bool get isDark => brightness == Brightness.dark;
}
