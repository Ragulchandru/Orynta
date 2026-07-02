// lib/core/design_system/design_tokens.dart
//
// Orynta 2.0 — Single Import Design System Barrel
//
// ── Purpose ───────────────────────────────────────────────────────────────────
// This file is the SINGLE import point for the entire design system.
//
// Instead of:
//   import '../../../core/design_system/colors/app_colors.dart';
//   import '../../../core/design_system/spacing/app_spacing.dart';
//   import '../../../core/design_system/typography/app_typography.dart';
//   ...
//
// Write:
//   import 'package:orynta/core/design_system/design_tokens.dart';
//
// Everything is then available:
//   AppColors, AppTypography, AppSpacing, AppRadius, AppElevation,
//   AppShadows, AppGradients, AppGlass, AppDurations, AppCurves,
//   AppIcons, AppDimensions, AppTheme,
//   OryAppColors, context.colors, context.spacing, ...
//
// ── What NOT to import directly ──────────────────────────────────────────────
// Do NOT import individual sub-files from design_system/ in feature code.
// Always use this barrel. This allows us to reorganize internal files
// without breaking any imports in feature layers.

// Colors
export 'colors/app_colors.dart';

// Typography
export 'typography/app_typography.dart';

// Spacing
export 'spacing/app_spacing.dart';

// Dimensions
export 'dimensions/app_dimensions.dart';

// Radius
export 'radius/app_radius.dart';

// Elevation
export 'elevation/app_elevation.dart';

// Shadows
export 'shadows/app_shadows.dart';

// Gradients
export 'gradients/app_gradients.dart';

// Glass
export 'glass/app_glass.dart';

// Durations
export 'durations/app_durations.dart';

// Curves
export 'curves/app_curves.dart';

// Icons
export 'icons/app_icons.dart';

// Theme
export 'theme/app_theme.dart';

// Extensions (BuildContext shortcuts)
export 'extensions/theme_extensions.dart';

// Shapes
export 'shapes/app_shapes.dart';

// Opacity
export 'opacity/app_opacity.dart';
