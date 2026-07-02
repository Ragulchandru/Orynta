// lib/core/constants/app_colors.dart
//
// Orynta 2.0 — Backward Compatibility Shim
//
// This file re-exports from the new design system and provides legacy
// aliases so that existing widgets that import this path continue to
// compile without modification.
//
// ── Migration Path ────────────────────────────────────────────────────────────
// Prefer importing from the design system directly:
//   import 'package:orynta/core/design_system/design_tokens.dart';
//
// This shim will be removed in a future cleanup phase once all feature
// code has been migrated to the new import path.

import 'package:flutter/material.dart';

// Re-export the new design system color class under the old name.
export '../design_system/colors/app_colors.dart'
    show AppColors, OryAppColors;

/// Legacy color aliases for widgets not yet migrated to the design system.
///
/// These constants mirror the old AppColors values to prevent compile errors
/// in existing files. Do NOT use these in new code — use AppColors.light.*
/// or AppColors.dark.* via context.colors instead.
abstract final class LegacyColors {
  // ── Seed / brand ──────────────────────────────────────────────────────────
  static const Color seedColor   = Color(0xFF4F46E5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark  = Color(0xFF000000);

  // ── Semantic status ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color error   = Color(0xFFDC2626);
  static const Color info    = Color(0xFF2563EB);

  // ── Note colors (Hive int values) — these have NOT changed ───────────────
  // Use AppColors.noteColors and AppColors.noteColor* directly.

  static const Color transparent = Colors.transparent;
}
