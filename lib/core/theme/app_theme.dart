// lib/core/theme/app_theme.dart
//
// Orynta 2.0 — Legacy Theme File (Delegation Shim)
//
// The canonical theme is now in:
//   lib/core/design_system/theme/app_theme.dart
//
// This file re-exports [AppTheme] from the design system so that
// lib/app.dart and any other import of this path continues to work.
//
// ── Migration Path ────────────────────────────────────────────────────────────
// In new code, import:
//   import 'package:orynta/core/design_system/design_tokens.dart';
//
// This shim will be removed once app.dart is updated to use the
// design_tokens.dart import directly.

export '../design_system/theme/app_theme.dart' show AppTheme;
