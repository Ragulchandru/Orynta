// lib/core/theme/app_text_styles.dart
//
// Orynta 2.0 — Backward Compatibility Shim
//
// The design system's canonical typography is now in:
//   lib/core/design_system/typography/app_typography.dart
//
// This file re-exports [AppTypography] and provides [AppTextStyles] as an
// alias so that the existing app_theme.dart (old version) and any other
// files that import AppTextStyles continue to compile.
//
// ── Migration Path ────────────────────────────────────────────────────────────
// In new code, import:
//   import 'package:orynta/core/design_system/design_tokens.dart';
// And use: AppTypography.bodyMedium or context.typography.bodyMedium

import '../design_system/typography/app_typography.dart';

export '../design_system/typography/app_typography.dart'
    show AppTypography;

// Alias for backward compatibility with any code that still references
// AppTextStyles by name.
// ignore: camel_case_types
typedef AppTextStyles = AppTypography;
