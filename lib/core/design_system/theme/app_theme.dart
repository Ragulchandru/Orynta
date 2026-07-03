// lib/core/design_system/theme/app_theme.dart
//
// Orynta 2.0 — Complete Material 3 Theme
//
// ── Architecture ─────────────────────────────────────────────────────────────
// Three ThemeData instances are exposed:
//   • lightTheme  — Light mode (warm white surfaces)
//   • darkTheme   — Dark mode (deep charcoal surfaces)
//   • amoledTheme — AMOLED mode (true-black, OLED optimized)
//
// All three are built by [_buildTheme] which accepts an [OryAppColors]
// semantic color set and generates a complete Material 3 configuration.
//
// ── Component Coverage ────────────────────────────────────────────────────────
// ColorScheme          ✓  Toolbar / AppBar         ✓
// Typography           ✓  Card                     ✓
// FilledButton         ✓  OutlinedButton           ✓
// TextButton           ✓  ElevatedButton           ✓
// IconButton           ✓  FAB                      ✓
// InputDecoration      ✓  NavigationBar            ✓
// NavigationRail       ✓  SnackBar                 ✓
// Dialog               ✓  BottomSheet              ✓
// Divider              ✓  ListTile                 ✓
// Chip                 ✓  Scrollbar                ✓
// Checkbox             ✓  Switch                   ✓
// ProgressIndicator    ✓  Popup Menu               ✓
// Menu                 ✓  Drawer                   ✓
// BottomAppBar         ✓  TabBar                   ✓
// Tooltip              ✓  Badge                    ✓
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   MaterialApp(
//     theme: AppTheme.lightTheme,
//     darkTheme: AppTheme.darkTheme,
//     themeMode: themeMode,
//   )
//
//   // For AMOLED, the app.dart switches based on a custom ThemeMode:
//   theme: AppTheme.amoledTheme  (when user selects AMOLED)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/app_colors.dart';
import '../dimensions/app_dimensions.dart';
import '../elevation/app_elevation.dart';
import '../radius/app_radius.dart';
import '../spacing/app_spacing.dart';
import '../typography/app_typography.dart';
import '../extensions/theme_extensions.dart';

/// Provides Material 3 [ThemeData] for Light, Dark, and AMOLED modes.
abstract final class AppTheme {
  // ─── Public Theme Instances ───────────────────────────────────────────────

  /// Light theme — warm white surfaces, crisp contrast.
  static final ThemeData lightTheme = _buildTheme(AppColors.light);

  /// Dark theme — deep charcoal surfaces, soft contrast.
  static final ThemeData darkTheme = _buildTheme(AppColors.dark);

  /// AMOLED theme — true-black surfaces for OLED battery saving.
  static final ThemeData amoledTheme = _buildTheme(AppColors.amoled);

  // ─── Builder ──────────────────────────────────────────────────────────────

  static ThemeData _buildTheme(OryAppColors c) {
    final isDark = c.isDark;

    // M3 ColorScheme — generated from our semantic OryAppColors set.
    final colorScheme = ColorScheme(
      brightness:          c.brightness,
      primary:             c.primary,
      onPrimary:           c.onPrimary,
      primaryContainer:    c.primaryContainer,
      onPrimaryContainer:  c.onPrimaryContainer,
      secondary:           c.secondary,
      onSecondary:         c.onSecondary,
      secondaryContainer:  c.secondaryContainer,
      onSecondaryContainer: c.onSecondaryContainer,
      // M3 uses surface/onSurface for the main background pair.
      surface:             c.surface,
      onSurface:           c.onSurface,
      surfaceContainerHighest: c.surfaceContainerHigh,
      surfaceContainerHigh:    c.surfaceContainerHigh,
      surfaceContainer:        c.surfaceContainer,
      surfaceContainerLow:     c.surfaceContainerLow,
      surfaceContainerLowest:  c.background,
      onSurfaceVariant:    c.onSurfaceVariant,
      outline:             c.outline,
      outlineVariant:      c.outlineVariant,
      error:               c.error,
      onError:             c.onError,
      errorContainer:      c.errorContainer,
      onErrorContainer:    c.onErrorContainer,
      // Tertiary — use info/secondary for now
      tertiary:            c.info,
      onTertiary:          c.onInfo,
      tertiaryContainer:   c.infoContainer,
      onTertiaryContainer: c.onInfoContainer,
      shadow:              isDark ? const Color(0xFF000000) : const Color(0xFF000000),
      scrim:               c.scrim,
      inverseSurface:      isDark ? c.textPrimary : AppColors.neutral800,
      onInverseSurface:    isDark ? c.surface : AppColors.neutral0,
      inversePrimary:      isDark ? c.primaryContainer : c.primaryVariant,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme:  colorScheme,
      brightness:   c.brightness,
      extensions: [
        OryColorsThemeExtension(colors: c),
      ],

      // ── Typography ──────────────────────────────────────────────────────
      textTheme: AppTypography.textTheme.apply(
        bodyColor:    c.textPrimary,
        displayColor: c.textPrimary,
      ),

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation:             AppElevation.level0,
        scrolledUnderElevation: AppElevation.level1,
        centerTitle:           false,
        backgroundColor:       c.surface,
        foregroundColor:       c.textPrimary,
        surfaceTintColor:      c.primary.withValues(alpha: 0.05),
        titleTextStyle:        AppTypography.titleLarge.copyWith(
          color: c.textPrimary,
        ),
        iconTheme: IconThemeData(
          color: c.textPrimary,
          size: AppDimensions.iconMd,
        ),
        actionsIconTheme: IconThemeData(
          color: c.textSecondary,
          size: AppDimensions.iconMd,
        ),
        toolbarHeight: AppDimensions.toolbarHeight,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor:                  Colors.transparent,
                systemNavigationBarColor:        c.surface,
                systemNavigationBarIconBrightness: Brightness.light,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor:                  Colors.transparent,
                systemNavigationBarColor:        c.surface,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
      ),

      // ── Card ────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation:   AppElevation.level0,
        color:       c.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
          side: BorderSide(color: c.cardBorder, width: AppDimensions.dividerThickness),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Filled Button ───────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
          textStyle:   AppTypography.labelLarge,
          elevation:   AppElevation.level0,
        ),
      ),

      // ── Outlined Button ─────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
          side:      BorderSide(color: c.outline),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ── Text Button ─────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(64, AppDimensions.buttonHeightSm),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusSm,
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ── Elevated Button ─────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
          elevation:   AppElevation.level1,
          textStyle:   AppTypography.labelLarge,
        ),
      ),

      // ── Icon Button ─────────────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppDimensions.iconButtonSize),
          padding:     EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusSm,
          ),
        ),
      ),

      // ── FAB ─────────────────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation:         AppElevation.fab,
        focusElevation:    AppElevation.level3,
        hoverElevation:    AppElevation.level3,
        highlightElevation: AppElevation.level3,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusXl,
        ),
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
      ),

      // ── Input Decoration (TextField) ────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:      true,
        fillColor:   c.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.mdSm,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: c.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: c.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: c.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: c.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: c.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: c.outlineVariant.withValues(alpha: 0.5)),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: c.textHint,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: c.textSecondary,
        ),
        floatingLabelStyle: AppTypography.labelMedium.copyWith(
          color: c.primary,
        ),
        errorStyle: AppTypography.labelMedium.copyWith(
          color: c.error,
        ),
        prefixIconColor: c.textHint,
        suffixIconColor: c.textHint,
      ),

      // ── Navigation Bar (Bottom Nav) ─────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        elevation:          AppElevation.level0,
        height:             AppDimensions.bottomNavHeight,
        backgroundColor:    c.surface,
        surfaceTintColor:   Colors.transparent,
        indicatorColor:     c.primaryContainer,
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(
              color: c.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.labelSmall.copyWith(
            color: c.textHint,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: c.primary, size: AppDimensions.iconMd);
          }
          return IconThemeData(color: c.textHint, size: AppDimensions.iconMd);
        }),
      ),

      // ── Navigation Rail ─────────────────────────────────────────────────
      navigationRailTheme: NavigationRailThemeData(
        elevation:          AppElevation.level0,
        backgroundColor:    c.surfaceContainerLow,
        indicatorColor:     c.primaryContainer,
        selectedIconTheme:  IconThemeData(color: c.primary, size: AppDimensions.iconMd),
        unselectedIconTheme: IconThemeData(color: c.textHint, size: AppDimensions.iconMd),
        selectedLabelTextStyle: AppTypography.labelSmall.copyWith(
          color: c.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: AppTypography.labelSmall.copyWith(
          color: c.textHint,
        ),
        useIndicator: true,
        minWidth: AppDimensions.navigationRailWidth,
        minExtendedWidth: AppDimensions.navigationRailWidthExtended,
      ),

      // ── Drawer ──────────────────────────────────────────────────────────
      drawerTheme: DrawerThemeData(
        elevation:       AppElevation.drawer,
        backgroundColor: c.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.drawerRadius,
        ),
        width: AppDimensions.navigationDrawerWidth,
      ),

      // ── Bottom App Bar ───────────────────────────────────────────────────
      bottomAppBarTheme: BottomAppBarThemeData(
        elevation:       AppElevation.level0,
        color:           c.surface,
        surfaceTintColor: Colors.transparent,
        height:          AppDimensions.bottomNavHeight,
        padding:         EdgeInsets.zero,
      ),

      // ── Tab Bar ─────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor:         c.primary,
        unselectedLabelColor: c.textHint,
        indicatorColor:     c.primary,
        indicatorSize:      TabBarIndicatorSize.label,
        dividerColor:       c.outlineVariant,
        labelStyle:         AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),

      // ── Chip ────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor:    c.surfaceContainer,
        selectedColor:      c.primaryContainer,
        disabledColor:      c.surfaceContainerLow,
        labelStyle:         AppTypography.labelMedium.copyWith(color: c.textPrimary),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(color: c.primary),
        side:               BorderSide(color: c.outlineVariant),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusSm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        elevation:          AppElevation.level0,
        pressElevation:     AppElevation.level1,
        checkmarkColor:     c.primary,
        iconTheme: IconThemeData(color: c.textSecondary, size: AppDimensions.iconSm),
      ),

      // ── Snack Bar ───────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior:   SnackBarBehavior.floating,
        elevation:  AppElevation.snackBar,
        backgroundColor: isDark ? c.surfaceContainerHigh : const Color(0xFF1C1C2C),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? c.textPrimary : const Color(0xFFEFEFF8),
        ),
        actionTextColor: c.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        elevation:       AppElevation.dialog,
        backgroundColor: c.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: c.textPrimary,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: c.textSecondary,
        ),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),

      // ── Bottom Sheet ────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        elevation:        AppElevation.bottomSheet,
        modalElevation:   AppElevation.level3,
        backgroundColor:  c.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: c.surfaceContainerLow,
        showDragHandle:   true,
        dragHandleColor:  c.outlineVariant,
        dragHandleSize: const Size(
          AppDimensions.bottomSheetHandleWidth,
          AppDimensions.bottomSheetHandleHeight,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.bottomSheetRadius,
        ),
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color:     c.divider,
        thickness: AppDimensions.dividerThickness,
        space:     AppDimensions.dividerThickness,
      ),

      // ── List Tile ───────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: AppSpacing.paddingListTile,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusSm,
        ),
        titleTextStyle: AppTypography.bodyLarge.copyWith(color: c.textPrimary),
        subtitleTextStyle: AppTypography.bodySmall.copyWith(color: c.textSecondary),
        leadingAndTrailingTextStyle: AppTypography.labelMedium.copyWith(
          color: c.textSecondary,
        ),
        iconColor:     c.textSecondary,
        textColor:     c.textPrimary,
        selectedColor: c.primary,
        selectedTileColor: c.primaryContainer.withValues(alpha: 0.5),
        minLeadingWidth: AppDimensions.iconMd,
        minVerticalPadding: AppSpacing.sm,
      ),

      // ── Popup Menu ──────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        elevation:       AppElevation.menu,
        color:           c.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        textStyle: AppTypography.bodyMedium.copyWith(color: c.textPrimary),
        labelTextStyle: WidgetStateProperty.all(
          AppTypography.bodyMedium.copyWith(color: c.textPrimary),
        ),
        iconColor: c.textSecondary,
        position:  PopupMenuPosition.under,
      ),

      // ── Menu (M3 Menu widget) ────────────────────────────────────────────
      menuTheme: MenuThemeData(
        style: MenuStyle(
          elevation: WidgetStateProperty.all(AppElevation.menu),
          backgroundColor: WidgetStateProperty.all(c.surfaceContainerHigh),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          ),
        ),
      ),

      // ── Scrollbar ───────────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return c.primary.withValues(alpha: 0.8);
          }
          return c.textHint.withValues(alpha: 0.4);
        }),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(AppRadius.full),
        thickness: WidgetStateProperty.all(4),
        interactive: true,
      ),

      // ── Checkbox ────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(c.onPrimary),
        overlayColor: WidgetStateProperty.all(
          c.primary.withValues(alpha: 0.12),
        ),
        side: BorderSide(color: c.outline, width: 1.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),

      // ── Switch ──────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.onPrimary;
          return c.textHint;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.primary;
          return c.surfaceContainer;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.transparent;
          return c.outline;
        }),
        overlayColor: WidgetStateProperty.all(
          c.primary.withValues(alpha: 0.12),
        ),
      ),

      // ── Progress Indicator ──────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color:           c.primary,
        linearTrackColor: c.surfaceContainer,
        circularTrackColor: c.surfaceContainer,
        linearMinHeight: AppDimensions.progressBarHeight,
        refreshBackgroundColor: c.surface,
      ),

      // ── Slider ──────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor:   c.primary,
        inactiveTrackColor: c.surfaceContainer,
        thumbColor:         c.primary,
        overlayColor:       c.primary.withValues(alpha: 0.12),
        valueIndicatorColor: c.primary,
        valueIndicatorTextStyle: AppTypography.labelMedium.copyWith(
          color: c.onPrimary,
        ),
      ),

      // ── Tooltip ─────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color:        isDark ? c.surfaceContainerHigh : const Color(0xFF1C1C2C),
          borderRadius: AppRadius.borderRadiusXs,
        ),
        textStyle: AppTypography.labelSmall.copyWith(
          color: isDark ? c.textPrimary : const Color(0xFFEFEFF8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        preferBelow:  true,
        waitDuration: const Duration(milliseconds: 500),
      ),

      // ── Badge ────────────────────────────────────────────────────────────
      badgeTheme: BadgeThemeData(
        backgroundColor: c.error,
        textColor:       c.onError,
        textStyle:       AppTypography.labelSmall,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        smallSize: 8,
        largeSize: 16,
      ),

      // ── Scaffold ─────────────────────────────────────────────────────────
      scaffoldBackgroundColor: c.background,

      // ── Icon ─────────────────────────────────────────────────────────────
      iconTheme: IconThemeData(
        color: c.textSecondary,
        size:  AppDimensions.iconMd,
      ),
    );
  }
}
