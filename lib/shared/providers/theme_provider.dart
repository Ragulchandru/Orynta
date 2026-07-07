// lib/shared/providers/theme_provider.dart
//
// ThemeModeNotifier — Riverpod provider managing the active AppThemeType.

import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_strings.dart';
import '../../core/design_system/design_system.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  Box<String> get _box => Hive.box<String>(AppStrings.settingsBoxName);

  @override
  AppThemeType build() {
    final saved = _box.get('theme_type');
    return _fromString(saved);
  }

  Future<void> setTheme(AppThemeType type) async {
    state = type;
    await _box.put('theme_type', _toString(type));
  }

  Future<void> toggle() async {
    final next = state == AppThemeType.light ? AppThemeType.gold : AppThemeType.light;
    await setTheme(next);
  }

  AppThemeType _fromString(String? value) => switch (value) {
        'midnight' => AppThemeType.midnight,
        'forest'   => AppThemeType.forest,
        'ocean'    => AppThemeType.ocean,
        'lavender' => AppThemeType.lavender,
        'sunset'   => AppThemeType.sunset,
        'light'    => AppThemeType.light,
        'sepia'    => AppThemeType.sepia,
        'amoled'   => AppThemeType.amoled,
        'graphite' => AppThemeType.graphite,
        'whiteMinimal' => AppThemeType.whiteMinimal,
        'arctic'   => AppThemeType.arctic,
        'rose'     => AppThemeType.rose,
        'emerald'  => AppThemeType.emerald,
        'crimson'  => AppThemeType.crimson,
        'indigo'   => AppThemeType.indigo,
        _          => AppThemeType.gold,
      };

  String _toString(AppThemeType type) => switch (type) {
        AppThemeType.gold     => 'gold',
        AppThemeType.midnight => 'midnight',
        AppThemeType.forest   => 'forest',
        AppThemeType.ocean    => 'ocean',
        AppThemeType.lavender => 'lavender',
        AppThemeType.sunset   => 'sunset',
        AppThemeType.light    => 'light',
        AppThemeType.sepia    => 'sepia',
        AppThemeType.amoled   => 'amoled',
        AppThemeType.graphite => 'graphite',
        AppThemeType.whiteMinimal => 'whiteMinimal',
        AppThemeType.arctic   => 'arctic',
        AppThemeType.rose     => 'rose',
        AppThemeType.emerald  => 'emerald',
        AppThemeType.crimson  => 'crimson',
        AppThemeType.indigo   => 'indigo',
      };
}
