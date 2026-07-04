// lib/core/design_system/theme/app_theme_type.dart
//
// Orynta 2.0 — App Theme Type

enum AppThemeType {
  gold,
  midnight,
  forest,
  ocean,
  lavender,
  sunset,
  light,
  sepia;

  String get label {
    switch (this) {
      case AppThemeType.gold:
        return 'Orynta Gold';
      case AppThemeType.midnight:
        return 'Midnight';
      case AppThemeType.forest:
        return 'Forest';
      case AppThemeType.ocean:
        return 'Ocean';
      case AppThemeType.lavender:
        return 'Lavender';
      case AppThemeType.sunset:
        return 'Sunset';
      case AppThemeType.light:
        return 'Light';
      case AppThemeType.sepia:
        return 'Sepia';
    }
  }

  bool get isDark {
    return this != AppThemeType.light && this != AppThemeType.sepia;
  }
}
