// lib/core/design_system/shapes/app_shapes.dart
//
// Orynta 2.0 — Reusable Shape Borders
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Shapes establish borders and boundaries for elements in the UI.
// Rather than rebuilding RoundedRectangleBorder instances everywhere,
// use centralized ShapeBorder definitions.
//
// All shapes use corner radii defined in [AppRadius].
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   Card(shape: AppShapes.card)
//   OutlinedButton(style: OutlinedButton.styleFrom(shape: AppShapes.button))

import 'package:flutter/material.dart';

import '../radius/app_radius.dart';

/// Reusable [ShapeBorder] and [OutlinedBorder] definitions for Orynta 2.0.
abstract final class AppShapes {
  // ─── Cards ────────────────────────────────────────────────────────────────

  /// Standard card shape: 12dp rounded corners.
  static const OutlinedBorder card = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusMd,
  );

  /// Prominent card shape: 16dp rounded corners.
  static const OutlinedBorder cardLg = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusLg,
  );

  /// Compact card shape: 8dp rounded corners.
  static const OutlinedBorder cardSm = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusSm,
  );

  // ─── Dialogs & Modals ─────────────────────────────────────────────────────

  /// Standard modal/alert dialog shape: 16dp rounded corners.
  static const OutlinedBorder dialog = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusLg,
  );

  /// Large dialog / overlay panel shape: 24dp rounded corners.
  static const OutlinedBorder dialogLg = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusXl,
  );

  // ─── Sheets ───────────────────────────────────────────────────────────────

  /// Bottom sheet shape: 24dp top corners.
  static const ShapeBorder bottomSheet = RoundedRectangleBorder(
    borderRadius: AppRadius.bottomSheetRadius,
  );

  /// Navigation drawer shape: 16dp right corners.
  static const ShapeBorder drawer = RoundedRectangleBorder(
    borderRadius: AppRadius.drawerRadius,
  );

  // ─── Buttons ──────────────────────────────────────────────────────────────

  /// Standard button shape (filled, outlined): 12dp rounded corners.
  static const OutlinedBorder button = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusMd,
  );

  /// Small/compact button shape: 8dp rounded corners.
  static const OutlinedBorder buttonSm = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusSm,
  );

  /// Pill button shape: fully rounded.
  static const OutlinedBorder buttonPill = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusFull,
  );

  // ─── FAB ──────────────────────────────────────────────────────────────────

  /// Standard FAB shape: 16dp rounded corners.
  static const OutlinedBorder fab = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusLg,
  );

  /// Small FAB shape: 12dp rounded corners.
  static const OutlinedBorder fabSm = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusMd,
  );

  /// Circular FAB shape: fully rounded.
  static const OutlinedBorder fabCircular = CircleBorder();

  // ─── Chips ────────────────────────────────────────────────────────────────

  /// Standard chip shape: 8dp rounded corners.
  static const OutlinedBorder chip = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusSm,
  );

  /// Pill/circular chip shape.
  static const OutlinedBorder chipPill = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusFull,
  );

  // ─── Text Fields ──────────────────────────────────────────────────────────

  /// Text field border shape: 12dp rounded corners.
  static const ShapeBorder textField = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusMd,
  );

  // ─── Navigation ───────────────────────────────────────────────────────────

  /// Bottom navigation bar indicator shape.
  static const ShapeBorder navIndicator = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusMd,
  );

  // ─── Menus & Overlays ─────────────────────────────────────────────────────

  /// Popup menu shape: 12dp rounded corners.
  static const ShapeBorder menu = RoundedRectangleBorder(
    borderRadius: AppRadius.borderRadiusMd,
  );
}
