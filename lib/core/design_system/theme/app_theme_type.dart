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
  sepia,
  amoled,
  graphite,
  whiteMinimal,
  arctic,
  rose,
  emerald,
  crimson,
  indigo;

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
      case AppThemeType.amoled:
        return 'AMOLED Black';
      case AppThemeType.graphite:
        return 'Graphite';
      case AppThemeType.whiteMinimal:
        return 'White Minimal';
      case AppThemeType.arctic:
        return 'Arctic Ice';
      case AppThemeType.rose:
        return 'Rose Wine';
      case AppThemeType.emerald:
        return 'Emerald Forest';
      case AppThemeType.crimson:
        return 'Crimson Ruby';
      case AppThemeType.indigo:
        return 'Indigo Royal';
    }
  }

  bool get isDark {
    return this != AppThemeType.light &&
        this != AppThemeType.sepia &&
        this != AppThemeType.whiteMinimal &&
        this != AppThemeType.arctic;
  }
}
