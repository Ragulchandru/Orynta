// lib/core/design_system/theme/app_theme.dart
//
// Orynta 2.0 — Premium Theme Builder and Theme Extensions

import 'package:flutter/material.dart';
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
  static ThemeData buildTheme(AppThemeType type) {
    final t = AppThemeFactory.getTheme(type);

    final colorScheme = ColorScheme(
      brightness: t.brightness,
      primary: t.primary,
      onPrimary: t.brightness == Brightness.dark ? const Color(0xFF0F0F17) : const Color(0xFFFFFFFF),
      primaryContainer: t.notes.tagBackground,
      onPrimaryContainer: t.primary,
      secondary: t.secondary,
      onSecondary: t.brightness == Brightness.dark ? const Color(0xFF0F0F17) : const Color(0xFFFFFFFF),
      tertiary: t.tertiary,
      surface: t.surface,
      onSurface: t.brightness == Brightness.dark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
      surfaceContainer: t.surfaceContainer,
      surfaceContainerLow: t.surfaceDim,
      surfaceContainerHigh: t.surfaceBright,
      onSurfaceVariant: t.brightness == Brightness.dark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68),
      outline: t.outline,
      outlineVariant: t.outlineVariant,
      error: t.error,
      onError: const Color(0xFFFFFFFF),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: t.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: t.surfaceDim,
      dividerColor: t.outlineVariant,
      extensions: [
        OryThemeExtension(themeData: t),
      ],
      cardTheme: CardThemeData(
        color: t.notes.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: t.notes.cardBorder, width: 1.0),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: t.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(color: t.outlineVariant, width: 1.0),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: t.surfaceContainer,
        disabledColor: t.surfaceDim,
        selectedColor: t.primary,
        secondarySelectedColor: t.secondary,
        labelStyle: TextStyle(
          color: t.brightness == Brightness.dark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: t.outlineVariant, width: 1.0),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: t.primary,
        foregroundColor: t.brightness == Brightness.dark ? const Color(0xFF0F0F17) : const Color(0xFFFFFFFF),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  // Preserve the existing basic public theme instances for clean backward compatibility
  static final ThemeData lightTheme = buildTheme(AppThemeType.light);
  static final ThemeData darkTheme = buildTheme(AppThemeType.gold);
  static final ThemeData amoledTheme = buildTheme(AppThemeType.midnight);
}
