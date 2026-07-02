// lib/core/design_system/elevation/app_elevation.dart
//
// Orynta 2.0 — Material 3 Elevation System
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Material 3 uses "tonal elevation" — surface color lightens as elevation
// increases (in dark mode), replacing the M2 shadow-based system.
// Explicit elevation values still control shadow depth on light mode.
//
// Use the lowest elevation that communicates the visual hierarchy correctly.
// Over-elevation makes the UI feel heavy and cluttered.
//
// ── M3 Elevation Levels ──────────────────────────────────────────────────────
//   Level 0 → 0dp  — Background, flat cards
//   Level 1 → 1dp  — Cards, menus (tonal surface +5%)
//   Level 2 → 3dp  — FAB, floating elements (tonal surface +8%)
//   Level 3 → 6dp  — NavBar, bottom sheet  (tonal surface +11%)
//   Level 4 → 8dp  — Snackbar             (tonal surface +12%)
//   Level 5 → 12dp — Dialog, drawer       (tonal surface +14%)
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   Card(elevation: AppElevation.level1)
//   FloatingActionButton(elevation: AppElevation.level2)
//   Dialog(elevation: AppElevation.level5)

/// Material 3 elevation level tokens for Orynta 2.0.
abstract final class AppElevation {
  /// Level 0 — 0dp: Flat. Background, non-elevated cards, dividers.
  static const double level0 = 0.0;

  /// Level 1 — 1dp: Resting. Default card, menu, popover.
  static const double level1 = 1.0;

  /// Level 2 — 3dp: Floating. FAB resting, filled button hover.
  static const double level2 = 3.0;

  /// Level 3 — 6dp: Elevated. Navigation bar, bottom sheet.
  static const double level3 = 6.0;

  /// Level 4 — 8dp: Prominent. Snackbar, tooltip.
  static const double level4 = 8.0;

  /// Level 5 — 12dp: Overlay. Dialog, modal drawer.
  static const double level5 = 12.0;

  // ─── Semantic Aliases ─────────────────────────────────────────────────────

  /// Flat card — no shadow, uses tonal fill.
  static const double card        = level0;

  /// FAB at rest.
  static const double fab         = level2;

  /// FAB pressed.
  static const double fabPressed  = level3;

  /// Bottom app bar / navigation bar.
  static const double bottomBar   = level2;

  /// Floating action button area.
  static const double floating    = level3;

  /// Dropdown menu, popup menu.
  static const double menu        = level2;

  /// Snack bar.
  static const double snackBar    = level3;

  /// Dialog / modal.
  static const double dialog      = level5;

  /// Navigation drawer.
  static const double drawer      = level5;

  /// Bottom sheet.
  static const double bottomSheet = level1;
}
