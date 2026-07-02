// lib/core/design_system/extensions/theme_extensions.dart
//
// Orynta 2.0 — Theme Extensions & Context Accessors
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Instead of writing verbose access patterns:
//   Theme.of(context).colorScheme.primary
//   Theme.of(context).textTheme.bodyMedium
//
// Use the concise, type-safe extensions:
//   context.colors.primary
//   context.typography.bodyMedium
//   context.spacing.md
//   context.radius.lg
//   context.isDark
//
// These extensions are read-only helpers on [BuildContext].
// They do NOT introduce new state — they are pure syntactic sugar.
//
// ── Setup ────────────────────────────────────────────────────────────────────
// No setup required. Import design_tokens.dart (or this file) and the
// extensions are available on any BuildContext.
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   // Colors
//   Text('Hello', style: TextStyle(color: context.colors.primary))
//   Container(color: context.colors.surface)
//
//   // Typography
//   Text('Title', style: context.typography.titleLarge)
//   Text('Body', style: context.typography.bodyMedium)
//
//   // Spacing
//   Padding(padding: context.spacing.paddingScreen)
//   SizedBox(height: context.spacing.lg)
//
//   // Radius
//   BorderRadius.circular(context.radius.md)
//
//   // Theme checks
//   if (context.isDark) { ... }
//   context.colorScheme.primary
//   context.textTheme.bodyMedium

import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../curves/app_curves.dart';
import '../dimensions/app_dimensions.dart';
import '../durations/app_durations.dart';
import '../elevation/app_elevation.dart';
import '../gradients/app_gradients.dart';
import '../glass/app_glass.dart';
import '../icons/app_icons.dart';
import '../radius/app_radius.dart';
import '../shadows/app_shadows.dart';
import '../spacing/app_spacing.dart';
import '../typography/app_typography.dart';

// ─── Flutter native ThemeExtension Subclass ───────────────────────────────────

/// Theme extension for storing semantic design system colors in [ThemeData].
/// Exposes [colors] containing light, dark, or AMOLED color tokens.
@immutable
class OryColorsThemeExtension extends ThemeExtension<OryColorsThemeExtension> {
  const OryColorsThemeExtension({required this.colors});

  final OryAppColors colors;

  @override
  OryColorsThemeExtension copyWith({OryAppColors? colors}) {
    return OryColorsThemeExtension(colors: colors ?? this.colors);
  }

  @override
  OryColorsThemeExtension lerp(ThemeExtension<OryColorsThemeExtension>? other, double t) {
    if (other is! OryColorsThemeExtension) return this;

    return OryColorsThemeExtension(
      colors: OryAppColors(
        primary: Color.lerp(colors.primary, other.colors.primary, t)!,
        primaryVariant: Color.lerp(colors.primaryVariant, other.colors.primaryVariant, t)!,
        onPrimary: Color.lerp(colors.onPrimary, other.colors.onPrimary, t)!,
        primaryContainer: Color.lerp(colors.primaryContainer, other.colors.primaryContainer, t)!,
        onPrimaryContainer: Color.lerp(colors.onPrimaryContainer, other.colors.onPrimaryContainer, t)!,
        secondary: Color.lerp(colors.secondary, other.colors.secondary, t)!,
        onSecondary: Color.lerp(colors.onSecondary, other.colors.onSecondary, t)!,
        secondaryContainer: Color.lerp(colors.secondaryContainer, other.colors.secondaryContainer, t)!,
        onSecondaryContainer: Color.lerp(colors.onSecondaryContainer, other.colors.onSecondaryContainer, t)!,
        background: Color.lerp(colors.background, other.colors.background, t)!,
        onBackground: Color.lerp(colors.onBackground, other.colors.onBackground, t)!,
        surface: Color.lerp(colors.surface, other.colors.surface, t)!,
        onSurface: Color.lerp(colors.onSurface, other.colors.onSurface, t)!,
        surfaceVariant: Color.lerp(colors.surfaceVariant, other.colors.surfaceVariant, t)!,
        onSurfaceVariant: Color.lerp(colors.onSurfaceVariant, other.colors.onSurfaceVariant, t)!,
        surfaceContainer: Color.lerp(colors.surfaceContainer, other.colors.surfaceContainer, t)!,
        surfaceContainerLow: Color.lerp(colors.surfaceContainerLow, other.colors.surfaceContainerLow, t)!,
        surfaceContainerHigh: Color.lerp(colors.surfaceContainerHigh, other.colors.surfaceContainerHigh, t)!,
        card: Color.lerp(colors.card, other.colors.card, t)!,
        onCard: Color.lerp(colors.onCard, other.colors.onCard, t)!,
        cardBorder: Color.lerp(colors.cardBorder, other.colors.cardBorder, t)!,
        outline: Color.lerp(colors.outline, other.colors.outline, t)!,
        outlineVariant: Color.lerp(colors.outlineVariant, other.colors.outlineVariant, t)!,
        divider: Color.lerp(colors.divider, other.colors.divider, t)!,
        textPrimary: Color.lerp(colors.textPrimary, other.colors.textPrimary, t)!,
        textSecondary: Color.lerp(colors.textSecondary, other.colors.textSecondary, t)!,
        textHint: Color.lerp(colors.textHint, other.colors.textHint, t)!,
        textDisabled: Color.lerp(colors.textDisabled, other.colors.textDisabled, t)!,
        success: Color.lerp(colors.success, other.colors.success, t)!,
        onSuccess: Color.lerp(colors.onSuccess, other.colors.onSuccess, t)!,
        successContainer: Color.lerp(colors.successContainer, other.colors.successContainer, t)!,
        onSuccessContainer: Color.lerp(colors.onSuccessContainer, other.colors.onSuccessContainer, t)!,
        warning: Color.lerp(colors.warning, other.colors.warning, t)!,
        onWarning: Color.lerp(colors.onWarning, other.colors.onWarning, t)!,
        warningContainer: Color.lerp(colors.warningContainer, other.colors.warningContainer, t)!,
        onWarningContainer: Color.lerp(colors.onWarningContainer, other.colors.onWarningContainer, t)!,
        error: Color.lerp(colors.error, other.colors.error, t)!,
        onError: Color.lerp(colors.onError, other.colors.onError, t)!,
        errorContainer: Color.lerp(colors.errorContainer, other.colors.errorContainer, t)!,
        onErrorContainer: Color.lerp(colors.onErrorContainer, other.colors.onErrorContainer, t)!,
        info: Color.lerp(colors.info, other.colors.info, t)!,
        onInfo: Color.lerp(colors.onInfo, other.colors.onInfo, t)!,
        infoContainer: Color.lerp(colors.infoContainer, other.colors.infoContainer, t)!,
        onInfoContainer: Color.lerp(colors.onInfoContainer, other.colors.onInfoContainer, t)!,
        overlay: Color.lerp(colors.overlay, other.colors.overlay, t)!,
        scrim: Color.lerp(colors.scrim, other.colors.scrim, t)!,
        transparent: Color.lerp(colors.transparent, other.colors.transparent, t)!,
        brightness: t < 0.5 ? colors.brightness : other.colors.brightness,
      ),
    );
  }
}

// ─── BuildContext Extensions ──────────────────────────────────────────────────

/// Core theme accessors on [BuildContext].
extension OryThemeContext on BuildContext {
  // ── Theme primitives ──────────────────────────────────────────────────────

  /// The current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// The current Material 3 [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// The current [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  // ── Design system shortcuts ───────────────────────────────────────────────

  /// Semantic color set for the current theme variant, fetched from standard theme extensions.
  /// Falls back to Light/Dark/AMOLED based on brightness and surface mapping if the extension isn't found.
  OryAppColors get colors {
    final ext = Theme.of(this).extension<OryColorsThemeExtension>();
    if (ext != null) return ext.colors;

    final brightness = Theme.of(this).brightness;
    final surface = Theme.of(this).colorScheme.surface;
    if (surface == const Color(0xFF000000)) return AppColors.amoled;
    if (brightness == Brightness.dark) return AppColors.dark;
    return AppColors.light;
  }

  /// Typography system.
  ///
  /// Example: `context.typography.titleLarge`
  OryTypographyContext get typography => const OryTypographyContext();

  /// Spacing system.
  ///
  /// Example: `context.spacing.md`, `context.spacing.paddingScreen`
  OrySpacingContext get spacing => const OrySpacingContext();

  /// Radius system.
  ///
  /// Example: `context.radius.md`, `context.radius.borderRadiusLg`
  OryRadiusContext get radius => const OryRadiusContext();

  /// Elevation system.
  ///
  /// Example: `context.elevation.level1`, `context.elevation.card`
  OryElevationContext get elevation => const OryElevationContext();

  /// Dimension / component-size tokens.
  ///
  /// Example: `context.dimensions.toolbarHeight`
  OryDimensionsContext get dimensions => const OryDimensionsContext();

  /// Shadow system.
  ///
  /// Example: `context.shadows.card(context.brightness)`
  OryShadowsContext get shadows => OryShadowsContext(Theme.of(this).brightness);

  /// Gradient system.
  ///
  /// Example: `context.gradients.primary(context.brightness)`
  OryGradientsContext get gradients => OryGradientsContext(Theme.of(this).brightness);

  /// Glass effect constants.
  ///
  /// Example: `context.glass.blurMd`, `context.glass.fill(context.brightness)`
  OryGlassContext get glass => OryGlassContext(Theme.of(this).brightness);

  /// Animation durations.
  ///
  /// Example: `context.durations.normal`
  OryDurationsContext get durations => const OryDurationsContext();

  /// Animation curves.
  ///
  /// Example: `context.curves.easeOut`
  OryCurvesContext get curves => const OryCurvesContext();

  /// Icon token set.
  ///
  /// Example: `context.icons.notes`
  OryIconsContext get icons => const OryIconsContext();

  // ── Convenience booleans ──────────────────────────────────────────────────

  /// `true` when the active theme is dark or AMOLED.
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// `true` when the active theme is light.
  bool get isLight => Theme.of(this).brightness == Brightness.light;

  /// The current [Brightness].
  Brightness get brightness => Theme.of(this).brightness;

  // ── MediaQuery shortcuts ──────────────────────────────────────────────────

  /// Screen size from [MediaQuery].
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Bottom padding (safe area / keyboard).
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  /// Top padding (status bar / notch).
  double get topPadding => MediaQuery.paddingOf(this).top;

  /// `true` when a software keyboard is visible.
  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;
}

// ─── Delegate Accessors ───────────────────────────────────────────────────────
// Thin wrapper objects so that `context.typography.titleLarge` compiles.
// These are const and have zero allocation overhead.

/// Wraps [AppTypography] for use via `context.typography`.
class OryTypographyContext {
  const OryTypographyContext();

  TextStyle get displayLarge   => AppTypography.displayLarge;
  TextStyle get displayMedium  => AppTypography.displayMedium;
  TextStyle get displaySmall   => AppTypography.displaySmall;
  TextStyle get headlineLarge  => AppTypography.headlineLarge;
  TextStyle get headlineMedium => AppTypography.headlineMedium;
  TextStyle get headlineSmall  => AppTypography.headlineSmall;
  TextStyle get titleLarge     => AppTypography.titleLarge;
  TextStyle get titleMedium    => AppTypography.titleMedium;
  TextStyle get titleSmall     => AppTypography.titleSmall;
  TextStyle get bodyLarge      => AppTypography.bodyLarge;
  TextStyle get bodyMedium     => AppTypography.bodyMedium;
  TextStyle get bodySmall      => AppTypography.bodySmall;
  TextStyle get labelLarge     => AppTypography.labelLarge;
  TextStyle get labelMedium    => AppTypography.labelMedium;
  TextStyle get labelSmall     => AppTypography.labelSmall;
  TextStyle get numericDisplay => AppTypography.numericDisplay;
}

/// Wraps [AppSpacing] for use via `context.spacing`.
class OrySpacingContext {
  const OrySpacingContext();

  double get xxs    => AppSpacing.xxs;
  double get xs     => AppSpacing.xs;
  double get sm     => AppSpacing.sm;
  double get mdSm   => AppSpacing.mdSm;
  double get md     => AppSpacing.md;
  double get mdLg   => AppSpacing.mdLg;
  double get lg     => AppSpacing.lg;
  double get xl     => AppSpacing.xl;
  double get xxl    => AppSpacing.xxl;
  double get xxxl   => AppSpacing.xxxl;
  double get hero   => AppSpacing.hero;

  EdgeInsets get paddingXs         => AppSpacing.paddingXs;
  EdgeInsets get paddingSm         => AppSpacing.paddingSm;
  EdgeInsets get paddingMd         => AppSpacing.paddingMd;
  EdgeInsets get paddingLg         => AppSpacing.paddingLg;
  EdgeInsets get paddingScreen     => AppSpacing.paddingScreen;
  EdgeInsets get paddingCard       => AppSpacing.paddingCard;
  EdgeInsets get paddingCardLg     => AppSpacing.paddingCardLg;
  EdgeInsets get paddingHorizontal => AppSpacing.paddingHorizontal;
  EdgeInsets get paddingHorizontalLg => AppSpacing.paddingHorizontalLg;
  EdgeInsets get paddingVerticalSm => AppSpacing.paddingVerticalSm;
  EdgeInsets get paddingVerticalMd => AppSpacing.paddingVerticalMd;
  EdgeInsets get paddingVerticalLg => AppSpacing.paddingVerticalLg;
  EdgeInsets get paddingListTile   => AppSpacing.paddingListTile;
  EdgeInsets get paddingChip       => AppSpacing.paddingChip;
  EdgeInsets get paddingDialog     => AppSpacing.paddingDialog;
  EdgeInsets get paddingBottomSheet => AppSpacing.paddingBottomSheet;
  EdgeInsets get paddingSection    => AppSpacing.paddingSection;
}

/// Wraps [AppRadius] for use via `context.radius`.
class OryRadiusContext {
  const OryRadiusContext();

  double get xs   => AppRadius.xs;
  double get sm   => AppRadius.sm;
  double get md   => AppRadius.md;
  double get lg   => AppRadius.lg;
  double get xl   => AppRadius.xl;
  double get xxl  => AppRadius.xxl;
  double get full => AppRadius.full;

  BorderRadius get borderRadiusXs   => AppRadius.borderRadiusXs;
  BorderRadius get borderRadiusSm   => AppRadius.borderRadiusSm;
  BorderRadius get borderRadiusMd   => AppRadius.borderRadiusMd;
  BorderRadius get borderRadiusLg   => AppRadius.borderRadiusLg;
  BorderRadius get borderRadiusXl   => AppRadius.borderRadiusXl;
  BorderRadius get borderRadiusXxl  => AppRadius.borderRadiusXxl;
  BorderRadius get borderRadiusFull => AppRadius.borderRadiusFull;

  BorderRadius get bottomSheet => AppRadius.bottomSheetRadius;
  BorderRadius get drawer      => AppRadius.drawerRadius;
  BorderRadius get top         => AppRadius.topRadius;
  BorderRadius get bottom      => AppRadius.bottomRadius;
}

/// Wraps [AppElevation] for use via `context.elevation`.
class OryElevationContext {
  const OryElevationContext();

  double get level0 => AppElevation.level0;
  double get level1 => AppElevation.level1;
  double get level2 => AppElevation.level2;
  double get level3 => AppElevation.level3;
  double get level4 => AppElevation.level4;
  double get level5 => AppElevation.level5;
  double get card        => AppElevation.card;
  double get fab         => AppElevation.fab;
  double get menu        => AppElevation.menu;
  double get snackBar    => AppElevation.snackBar;
  double get dialog      => AppElevation.dialog;
  double get drawer      => AppElevation.drawer;
  double get bottomSheet => AppElevation.bottomSheet;
}

/// Wraps [AppDimensions] for use via `context.dimensions`.
class OryDimensionsContext {
  const OryDimensionsContext();

  double get toolbarHeight    => AppDimensions.toolbarHeight;
  double get bottomNavHeight  => AppDimensions.bottomNavHeight;
  double get fabSize          => AppDimensions.fabSize;
  double get buttonHeight     => AppDimensions.buttonHeight;
  double get iconSm           => AppDimensions.iconSm;
  double get iconMd           => AppDimensions.iconMd;
  double get iconLg           => AppDimensions.iconLg;
  double get iconXl           => AppDimensions.iconXl;
  double get avatarSm         => AppDimensions.avatarSm;
  double get avatarMd         => AppDimensions.avatarMd;
  double get avatarLg         => AppDimensions.avatarLg;
  double get cardMinHeight    => AppDimensions.cardMinHeight;
  double get searchBarHeight  => AppDimensions.searchBarHeight;
  double get chipHeight       => AppDimensions.chipHeight;
}

/// Wraps [AppShadows] for use via `context.shadows`.
class OryShadowsContext {
  const OryShadowsContext(this._brightness);
  final Brightness _brightness;

  List<BoxShadow> get card     => AppShadows.card(_brightness);
  List<BoxShadow> get small    => AppShadows.small(_brightness);
  List<BoxShadow> get medium   => AppShadows.medium(_brightness);
  List<BoxShadow> get large    => AppShadows.large(_brightness);
  List<BoxShadow> get floating => AppShadows.floating(_brightness);
  List<BoxShadow> get dialog   => AppShadows.dialog(_brightness);
}

/// Wraps [AppGradients] for use via `context.gradients`.
class OryGradientsContext {
  const OryGradientsContext(this._brightness);
  final Brightness _brightness;

  LinearGradient get primary  => AppGradients.primary(_brightness);
  LinearGradient get surface  => AppGradients.surface(_brightness);
  LinearGradient get glass    => AppGradients.glass(_brightness);
  LinearGradient get shimmer  => AppGradients.shimmer(_brightness);
  LinearGradient get cardScrim => AppGradients.cardScrim;
  LinearGradient get accentIndigo => AppGradients.accentIndigo;
  LinearGradient get accentSuccess => AppGradients.accentSuccess;
  LinearGradient get accentWarm => AppGradients.accentWarm;
}

/// Wraps [AppGlass] for use via `context.glass`.
class OryGlassContext {
  const OryGlassContext(this._brightness);
  final Brightness _brightness;

  double get blurXs => AppGlass.blurXs;
  double get blurSm => AppGlass.blurSm;
  double get blurMd => AppGlass.blurMd;
  double get blurLg => AppGlass.blurLg;
  double get blurXl => AppGlass.blurXl;

  double get borderWidth => AppGlass.borderWidth;
  double get radius      => AppGlass.radius;
  double get radiusLg    => AppGlass.radiusLg;

  Color get fill   => AppGlass.fill(_brightness);
  Color get border => AppGlass.border(_brightness);
}

/// Wraps [AppDurations] for use via `context.durations`.
class OryDurationsContext {
  const OryDurationsContext();

  Duration get instant       => AppDurations.instant;
  Duration get fast          => AppDurations.fast;
  Duration get short         => AppDurations.short;
  Duration get normal        => AppDurations.normal;
  Duration get medium        => AppDurations.medium;
  Duration get slow          => AppDurations.slow;
  Duration get xSlow         => AppDurations.xSlow;
  Duration get pageTransition => AppDurations.pageTransition;
  Duration get buttonAnimation => AppDurations.buttonAnimation;
  Duration get cardAnimation   => AppDurations.cardAnimation;
  Duration get dialogEnter     => AppDurations.dialogEnter;
  Duration get bottomSheetEnter => AppDurations.bottomSheetEnter;
  Duration get shimmerCycle    => AppDurations.shimmerCycle;
}

/// Wraps [AppCurves] for use via `context.curves`.
class OryCurvesContext {
  const OryCurvesContext();

  Curve get emphasized           => AppCurves.emphasized;
  Curve get emphasizedDecelerate => AppCurves.emphasizedDecelerate;
  Curve get emphasizedAccelerate => AppCurves.emphasizedAccelerate;
  Curve get easeInOut            => AppCurves.easeInOut;
  Curve get easeIn               => AppCurves.easeIn;
  Curve get easeOut              => AppCurves.easeOut;
  Curve get easeOutCubic         => AppCurves.easeOutCubic;
  Curve get easeOutQuart         => AppCurves.easeOutQuart;
  Curve get easeOutExpo          => AppCurves.easeOutExpo;
  Curve get linear               => AppCurves.linear;
  Curve get fastOutSlowIn        => AppCurves.fastOutSlowIn;
  Curve get pageEnter            => AppCurves.pageEnter;
  Curve get pageExit             => AppCurves.pageExit;
  Curve get bottomSheetEnter     => AppCurves.bottomSheetEnter;
  Curve get dialogEnter          => AppCurves.dialogEnter;
  Curve get buttonPress          => AppCurves.buttonPress;
  Curve get listItemEnter        => AppCurves.listItemEnter;
}

/// Wraps [AppIcons] for use via `context.icons`.
class OryIconsContext {
  const OryIconsContext();

  IconData get today           => AppIcons.today;
  IconData get todayActive     => AppIcons.todayActive;
  IconData get notes           => AppIcons.notes;
  IconData get notesActive     => AppIcons.notesActive;
  IconData get planner         => AppIcons.planner;
  IconData get plannerActive   => AppIcons.plannerActive;
  IconData get insights        => AppIcons.insights;
  IconData get insightsActive  => AppIcons.insightsActive;
  IconData get dashboard       => AppIcons.dashboard;
  IconData get settings        => AppIcons.settings;
  IconData get settingsActive  => AppIcons.settingsActive;
  IconData get archive         => AppIcons.archive;
  IconData get trash           => AppIcons.trash;
  IconData get search          => AppIcons.search;
  IconData get pin             => AppIcons.pin;
  IconData get pinActive       => AppIcons.pinActive;
  IconData get favorite        => AppIcons.favorite;
  IconData get favoriteActive  => AppIcons.favoriteActive;
  IconData get add             => AppIcons.add;
  IconData get edit            => AppIcons.edit;
  IconData get delete          => AppIcons.delete;
  IconData get more            => AppIcons.more;
  IconData get close           => AppIcons.close;
  IconData get back            => AppIcons.back;
  IconData get share           => AppIcons.share;
  IconData get export          => AppIcons.export;
  IconData get import          => AppIcons.import;
  IconData get lock            => AppIcons.lock;
  IconData get backup          => AppIcons.backup;
  IconData get calendar        => AppIcons.calendar;
  IconData get reminder        => AppIcons.reminder;
  IconData get checklist       => AppIcons.checklist;
  IconData get folder          => AppIcons.folder;
  IconData get image           => AppIcons.image;
  IconData get check           => AppIcons.check;
  IconData get error           => AppIcons.error;
  IconData get info            => AppIcons.info;
  IconData get warning         => AppIcons.warning;
}
