// lib/shared/providers/appearance_mode.dart
//
// AppearanceModeNotifier — Manage active AppearanceMode (light, dark, amoled) with Hive persistence

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_strings.dart';

enum AppearanceMode {
  light,
  dark,
  amoled,
}

class AppearanceModeNotifier extends Notifier<AppearanceMode> {
  Box<String> get _box => Hive.box<String>(AppStrings.settingsBoxName);

  @override
  AppearanceMode build() {
    final saved = _box.get('appearance_mode');
    if (saved != null) {
      return _fromString(saved);
    }

    // Migration logic for old amoledMode setting
    final legacyAmoled = _box.get('setting_amoledMode');
    if (legacyAmoled == 'true') {
      _box.put('appearance_mode', 'amoled');
      return AppearanceMode.amoled;
    }

    // Default is dark
    return AppearanceMode.dark;
  }

  Future<void> setMode(AppearanceMode mode) async {
    state = mode;
    await _box.put('appearance_mode', _toString(mode));
  }

  AppearanceMode _fromString(String saved) {
    switch (saved) {
      case 'light':
        return AppearanceMode.light;
      case 'amoled':
        return AppearanceMode.amoled;
      case 'dark':
      default:
        return AppearanceMode.dark;
    }
  }

  String _toString(AppearanceMode mode) {
    switch (mode) {
      case AppearanceMode.light:
        return 'light';
      case AppearanceMode.amoled:
        return 'amoled';
      case AppearanceMode.dark:
        return 'dark';
    }
  }
}

final appearanceModeProvider = NotifierProvider<AppearanceModeNotifier, AppearanceMode>(
  AppearanceModeNotifier.new,
);
