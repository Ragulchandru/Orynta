// lib/core/design_system/spacing/app_spacing.dart
//
// Orynta 2.0 — Spacing System
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Based on a 4px base grid. All spacing values are multiples of 4.
// This aligns with Material 3's 4dp grid and ensures pixel-perfect
// consistency across all screen densities.
//
// Using named tokens (AppSpacing.md) instead of magic numbers (16.0) makes
// the codebase self-documenting and allows global spacing changes in one file.
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   Padding(padding: AppSpacing.paddingCard)
//   SizedBox(height: AppSpacing.md)
//   AppSpacing.gapMd         // SizedBox widget
//   AppSpacing.screenPadding // Horizontal screen EdgeInsets
//   context.spacing.md       // via ThemeExtension

import 'package:flutter/material.dart';

/// Raw spacing scale and pre-built EdgeInsets / SizedBox helpers.
abstract final class AppSpacing {
  // ─── Raw Scale ────────────────────────────────────────────────────────────
  // Values in logical pixels (dp), following a 4px grid.

  /// 2dp — hair-line gap (e.g., between badge and icon)
  static const double xxs = 2.0;

  /// 4dp — micro gap (icon-to-label, tight list rows)
  static const double xs = 4.0;

  /// 8dp — small gap (between related elements, chip padding)
  static const double sm = 8.0;

  /// 12dp — medium-small gap (inner card padding, form row gap)
  static const double mdSm = 12.0;

  /// 16dp — standard gap (screen horizontal padding, section gap)
  static const double md = 16.0;

  /// 20dp — medium-large (prominent card padding, form field gap)
  static const double mdLg = 20.0;

  /// 24dp — large (between sections, generous card padding)
  static const double lg = 24.0;

  /// 32dp — extra-large (hero content, empty state spacing)
  static const double xl = 32.0;

  /// 40dp — 2x large (onboarding, generous vertical rhythm)
  static const double xxl = 40.0;

  /// 48dp — 3x large (prominent empty state vertical padding)
  static const double xxxl = 48.0;

  /// 64dp — hero (splash, full-screen centred content)
  static const double hero = 64.0;

  /// 96dp — display (splash screen logo area)
  static const double display = 96.0;

  // ─── EdgeInsets Helpers ───────────────────────────────────────────────────

  /// `EdgeInsets.all(4)` — xs all-around padding
  static const EdgeInsets paddingXs =
      EdgeInsets.all(xs);

  /// `EdgeInsets.all(8)` — small all-around padding
  static const EdgeInsets paddingSm =
      EdgeInsets.all(sm);

  /// `EdgeInsets.all(16)` — standard all-around padding
  static const EdgeInsets paddingMd =
      EdgeInsets.all(md);

  /// `EdgeInsets.all(24)` — large all-around padding
  static const EdgeInsets paddingLg =
      EdgeInsets.all(lg);

  /// `EdgeInsets.symmetric(horizontal:16, vertical:16)` — screen padding
  static const EdgeInsets paddingScreen =
      EdgeInsets.symmetric(horizontal: md, vertical: md);

  /// `EdgeInsets.all(16)` — standard card inner padding
  static const EdgeInsets paddingCard =
      EdgeInsets.all(md);

  /// `EdgeInsets.all(20)` — generous card inner padding
  static const EdgeInsets paddingCardLg =
      EdgeInsets.all(mdLg);

  /// `EdgeInsets.symmetric(horizontal:16)` — horizontal-only screen padding
  static const EdgeInsets paddingHorizontal =
      EdgeInsets.symmetric(horizontal: md);

  /// `EdgeInsets.symmetric(horizontal:24)` — generous horizontal padding
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);

  /// `EdgeInsets.symmetric(vertical:8)` — vertical-only small padding
  static const EdgeInsets paddingVerticalSm =
      EdgeInsets.symmetric(vertical: sm);

  /// `EdgeInsets.symmetric(vertical:16)` — standard vertical padding
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: md);

  /// `EdgeInsets.symmetric(vertical:24)` — large vertical padding
  static const EdgeInsets paddingVerticalLg =
      EdgeInsets.symmetric(vertical: lg);

  /// `EdgeInsets.symmetric(horizontal:16, vertical:8)` — list tile padding
  static const EdgeInsets paddingListTile =
      EdgeInsets.symmetric(horizontal: md, vertical: sm);

  /// `EdgeInsets.symmetric(horizontal:16, vertical:12)` — chip / badge padding
  static const EdgeInsets paddingChip =
      EdgeInsets.symmetric(horizontal: md, vertical: mdSm);

  /// `EdgeInsets.symmetric(horizontal:20, vertical:16)` — dialog content padding
  static const EdgeInsets paddingDialog =
      EdgeInsets.symmetric(horizontal: mdLg, vertical: md);

  /// `EdgeInsets.symmetric(horizontal:16, vertical:24)` — bottom sheet padding
  static const EdgeInsets paddingBottomSheet =
      EdgeInsets.symmetric(horizontal: md, vertical: lg);

  /// `EdgeInsets.symmetric(horizontal:16, vertical:12)` — section header padding
  static const EdgeInsets paddingSection =
      EdgeInsets.symmetric(horizontal: md, vertical: mdSm);

  // ─── SizedBox Helpers ─────────────────────────────────────────────────────
  // Use these for constant vertical/horizontal gaps in Column/Row widgets.
  // Dart const constructors keep these as compile-time constants.

  /// `SizedBox(height: 2)` / `SizedBox(width: 2)`
  static const SizedBox gapXxs  = SizedBox(height: xxs, width: xxs);

  /// `SizedBox(height: 4)` — use for xxs vertical gaps
  static const SizedBox gapXs   = SizedBox(height: xs,  width: xs);

  /// `SizedBox(height: 8)` — use for small vertical gaps
  static const SizedBox gapSm   = SizedBox(height: sm,  width: sm);

  /// `SizedBox(height: 12)` — medium-small vertical gap
  static const SizedBox gapMdSm = SizedBox(height: mdSm, width: mdSm);

  /// `SizedBox(height: 16)` — standard vertical gap
  static const SizedBox gapMd   = SizedBox(height: md,  width: md);

  /// `SizedBox(height: 20)` — medium-large vertical gap
  static const SizedBox gapMdLg = SizedBox(height: mdLg, width: mdLg);

  /// `SizedBox(height: 24)` — large vertical gap
  static const SizedBox gapLg   = SizedBox(height: lg,  width: lg);

  /// `SizedBox(height: 32)` — extra-large vertical gap
  static const SizedBox gapXl   = SizedBox(height: xl,  width: xl);

  /// `SizedBox(height: 40)` — 2x large vertical gap
  static const SizedBox gapXxl  = SizedBox(height: xxl, width: xxl);

  /// `SizedBox(height: 48)` — 3x large vertical gap
  static const SizedBox gapXxxl = SizedBox(height: xxxl, width: xxxl);

  /// `SizedBox(height: 64)` — hero vertical gap
  static const SizedBox gapHero = SizedBox(height: hero, width: hero);

  // ─── Vertical Gaps (Column-specific, width: 0) ───────────────────────────

  /// Vertical `SizedBox` of 4dp height.
  static const SizedBox vGapXs   = SizedBox(height: xs);

  /// Vertical `SizedBox` of 8dp height.
  static const SizedBox vGapSm   = SizedBox(height: sm);

  /// Vertical `SizedBox` of 12dp height.
  static const SizedBox vGapMdSm = SizedBox(height: mdSm);

  /// Vertical `SizedBox` of 16dp height.
  static const SizedBox vGapMd   = SizedBox(height: md);

  /// Vertical `SizedBox` of 20dp height.
  static const SizedBox vGapMdLg = SizedBox(height: mdLg);

  /// Vertical `SizedBox` of 24dp height.
  static const SizedBox vGapLg   = SizedBox(height: lg);

  /// Vertical `SizedBox` of 32dp height.
  static const SizedBox vGapXl   = SizedBox(height: xl);

  /// Vertical `SizedBox` of 48dp height.
  static const SizedBox vGapXxxl = SizedBox(height: xxxl);

  // ─── Horizontal Gaps (Row-specific, height: 0) ───────────────────────────

  /// Horizontal `SizedBox` of 4dp width.
  static const SizedBox hGapXs   = SizedBox(width: xs);

  /// Horizontal `SizedBox` of 8dp width.
  static const SizedBox hGapSm   = SizedBox(width: sm);

  /// Horizontal `SizedBox` of 12dp width.
  static const SizedBox hGapMdSm = SizedBox(width: mdSm);

  /// Horizontal `SizedBox` of 16dp width.
  static const SizedBox hGapMd   = SizedBox(width: md);

  /// Horizontal `SizedBox` of 20dp width.
  static const SizedBox hGapMdLg = SizedBox(width: mdLg);

  /// Horizontal `SizedBox` of 24dp width.
  static const SizedBox hGapLg   = SizedBox(width: lg);

  /// Horizontal `SizedBox` of 32dp width.
  static const SizedBox hGapXl   = SizedBox(width: xl);
}
