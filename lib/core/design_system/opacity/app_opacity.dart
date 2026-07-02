// lib/core/design_system/opacity/app_opacity.dart
//
// Orynta 2.0 — Reusable Opacity Tokens
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Standardized opacity values ensure consistent visual hierarchies.
// Instead of calling withOpacity(0.6), use semantic fields like
// AppOpacity.scrim or AppOpacity.disabled.
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   color: context.colors.primary.withOpacity(AppOpacity.hover)
//   opacity: AppOpacity.disabled

/// Reusable opacity constant tokens for Orynta 2.0.
abstract final class AppOpacity {
  /// 0.00 — Fully transparent.
  static const double transparent = 0.00;

  /// 0.04 — Extremely subtle hover/focus state or divider line.
  static const double subtle = 0.04;

  /// 0.08 — Standard hover background overlay.
  static const double hover = 0.08;

  /// 0.10 — Standard keyboard focus highlight.
  static const double focus = 0.10;

  /// 0.12 — Standard ripple/pressed overlay.
  static const double pressed = 0.12;

  /// 0.24 — Disabled text or icon indicators (secondary).
  static const double disabledLow = 0.24;

  /// 0.30 — Subtle background cards or overlay grids.
  static const double overlay = 0.30;

  /// 0.38 — Standard disabled state opacity (M3 spec).
  static const double disabled = 0.38;

  /// 0.50 — Standard modal dialog barrier/dimmer.
  static const double modal = 0.50;

  /// 0.60 — Dark scrim overlay for image hero banners.
  static const double scrim = 0.60;

  /// 0.80 — Translucent glass effect background.
  static const double glass = 0.80;

  /// 1.00 — Fully opaque.
  static const double opaque = 1.00;
}
