// lib/core/design_system/theme/app_theme.dart
//
// Orynta 2.0 — Premium Theme Builder, Theme Extensions, and Settings Modifiers

import 'package:flutter/material.dart';
import '../../../shared/providers/appearance_mode.dart';
import '../design_system.dart';

@immutable
class OryThemeExtension extends ThemeExtension<OryThemeExtension> {
  const OryThemeExtension({required this.themeData});

  final AppThemeData themeData;

  @override
  OryThemeExtension copyWith({AppThemeData? themeData}) {
    return OryThemeExtension(themeData: themeData ?? this.themeData);
  }

  @override
  OryThemeExtension lerp(ThemeExtension<OryThemeExtension>? other, double t) {
    if (other is! OryThemeExtension) return this;
    return t < 0.5 ? this : other;
  }
}

extension OryThemeExtensionContext on BuildContext {
  AppThemeData get appTheme {
    final ext = Theme.of(this).extension<OryThemeExtension>();
    if (ext != null) return ext.themeData;
    return AppThemeFactory.getTheme(AppThemeType.gold);
  }
}

abstract final class AppTheme {
  static ThemeData buildTheme(
    AppThemeType type, {
    required AppearanceMode mode,
    double cornerRadius = 16.0,
  }) {
    var t = AppThemeFactory.getTheme(type);

    if (mode == AppearanceMode.light) {
      // Layered M3 Light Mode Overrides
      const lightBg = Color(0xFFF8F8FA);
      const lightSurface = Color(0xFFFFFFFF);
      const lightSurfaceDim = Color(0xFFF3F3F7);
      const lightSurfaceContainer = Color(0xFFEEEEF5);
      const lightSurfaceBright = Color(0xFFFCFCFD);
      const lightOutline = Color(0xFFDFDFE8);
      const lightOutlineVariant = Color(0xFFEEEEF5);

      t = t.copyWith(
        brightness: Brightness.light,
        isDark: false,
        surface: lightSurface,
        surfaceContainer: lightSurfaceContainer,
        surfaceBright: lightSurfaceBright,
        surfaceDim: lightSurfaceDim,
        outline: lightOutline,
        outlineVariant: lightOutlineVariant,
        navigation: t.navigation.copyWith(
          background: lightBg,
          inactive: const Color(0xFF7E7E9A),
          indicator: t.primary.withValues(alpha: 0.08),
        ),
        planner: t.planner.copyWith(
          progressTodo: const Color(0xFFEEEEF5),
        ),
        analytics: t.analytics.copyWith(
          heatmapLow: const Color(0xFFF1F1F5),
          legendText: const Color(0xFF7E7E9A),
          cardBackground: lightSurface,
          cardBorder: const Color(0xFFE8E8EF),
          progressRingInactive: const Color(0xFFEEEEF5),
        ),
        notes: t.notes.copyWith(
          card: lightSurface,
          cardBorder: const Color(0xFFE8E8EF),
          searchBackground: const Color(0xFFF1F1F5),
          searchBorder: lightOutline,
          tagBackground: t.primary.withValues(alpha: 0.08),
          tagText: t.primary,
          chipBackground: const Color(0xFFF1F1F5),
          chipText: const Color(0xFF7E7E9A),
          chipTextSelected: Colors.white,
          fabBackground: t.primary,
          fabForeground: Colors.white,
          selectionBackground: t.primary.withValues(alpha: 0.2),
          contextMenuBackground: lightSurface,
        ),
        dashboard: t.dashboard.copyWith(
          heroBackground: t.primary.withValues(alpha: 0.08),
          heroText: t.primary,
          quoteBackground: lightSurface,
          quoteBorder: const Color(0xFFE8E8EF),
          missionCard: lightSurface,
          reminderCard: lightSurface,
          glanceCard: lightSurface,
          glanceBorder: const Color(0xFFE8E8EF),
          productivityBg: t.primary.withValues(alpha: 0.08),
        ),
        profile: t.profile.copyWith(
          avatarBackground: t.primary.withValues(alpha: 0.08),
          avatarBorder: t.primary,
          avatarText: t.primary,
          headerBackground: lightSurface,
          cardBackground: lightSurface,
          cardBorder: const Color(0xFFE8E8EF),
        ),
      );
    } else if (mode == AppearanceMode.amoled) {
      // AMOLED Pure Black Mode Hierarchy Override
      const amoledBg = Color(0xFF000000);
      const amoledCard = Color(0xFF0A0A0A);
      const amoledDialog = Color(0xFF111111);
      const amoledBorder = Color(0xFF1C1C1C);

      t = t.copyWith(
        brightness: Brightness.dark,
        isDark: true,
        surface: amoledBg,
        surfaceContainer: amoledCard,
        surfaceDim: amoledBg,
        surfaceBright: amoledDialog,
        outline: amoledBorder,
        outlineVariant: amoledBorder,
        navigation: t.navigation.copyWith(
          background: amoledBg,
          indicator: amoledBorder,
        ),
        planner: t.planner.copyWith(
          progressTodo: amoledBorder,
        ),
        analytics: t.analytics.copyWith(
          heatmapLow: const Color(0xFF0D0D0D),
          cardBackground: amoledCard,
          cardBorder: amoledBorder,
          progressRingInactive: amoledBorder,
        ),
        notes: t.notes.copyWith(
          card: amoledCard,
          cardBorder: amoledBorder,
          searchBackground: amoledCard,
          searchBorder: amoledBorder,
          chipBackground: const Color(0xFF0D0D0D),
          chipSelected: t.primary,
          chipTextSelected: Colors.black,
          contextMenuBackground: amoledDialog,
        ),
        dashboard: t.dashboard.copyWith(
          heroBackground: amoledCard,
          quoteBackground: amoledCard,
          quoteBorder: amoledBorder,
          missionCard: amoledCard,
          reminderCard: amoledCard,
          glanceCard: amoledCard,
          glanceBorder: amoledBorder,
          productivityBg: amoledCard,
        ),
        profile: t.profile.copyWith(
          avatarBackground: t.primary.withValues(alpha: 0.12),
          headerBackground: amoledBg,
          cardBackground: amoledCard,
          cardBorder: amoledBorder,
        ),
      );
    }

    final isDark = t.brightness == Brightness.dark;
    final surfaceColor = t.surface;
    final bgDim = t.surfaceDim;
    final cardBgColor = t.notes.card;
    final chipBgColor = t.notes.chipBackground;

    final colorScheme = ColorScheme(
      brightness: t.brightness,
      primary: t.primary,
      onPrimary: isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFFFFF),
      primaryContainer: t.notes.tagBackground,
      onPrimaryContainer: t.primary,
      secondary: t.secondary,
      onSecondary: isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFFFFF),
      tertiary: t.tertiary,
      surface: surfaceColor,
      onSurface: isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
      surfaceContainer: t.surfaceContainer,
      surfaceContainerLow: bgDim,
      surfaceContainerHigh: t.surfaceBright,
      onSurfaceVariant: isDark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68),
      outline: t.outline,
      outlineVariant: t.outlineVariant,
      error: t.error,
      onError: const Color(0xFFFFFFFF),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: t.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bgDim,
      dividerColor: t.outlineVariant,
      extensions: [
        OryThemeExtension(themeData: t),
      ],
      cardTheme: CardThemeData(
        color: cardBgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
          side: BorderSide(color: t.notes.cardBorder, width: 1.0),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? t.surfaceBright : surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius + 8.0),
          side: BorderSide(color: t.outlineVariant, width: 1.0),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? t.surfaceBright : surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(cornerRadius + 8.0),
            topRight: Radius.circular(cornerRadius + 8.0),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: chipBgColor,
        disabledColor: t.surfaceDim,
        selectedColor: t.primary,
        secondarySelectedColor: t.secondary,
        labelStyle: TextStyle(
          color: isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular((cornerRadius - 4.0).clamp(4.0, 24.0)),
          side: BorderSide(color: t.outlineVariant, width: 1.0),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: t.notes.fabBackground,
        foregroundColor: t.notes.fabForeground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
      ),
    );
  }

  // Preserve static instances with default dark mode for backward compatibility
  static final ThemeData lightTheme = buildTheme(AppThemeType.light, mode: AppearanceMode.light);
  static final ThemeData darkTheme = buildTheme(AppThemeType.gold, mode: AppearanceMode.dark);
  static final ThemeData amoledTheme = buildTheme(AppThemeType.midnight, mode: AppearanceMode.amoled);
}
