// test/unit/theme_persistence_test.dart
//
// Orynta 2.0 — Theme Persistence and Serialization Unit Tests

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:orynta/core/constants/app_strings.dart';
import 'package:orynta/core/design_system/theme/app_theme_type.dart';
import 'package:orynta/shared/providers/theme_provider.dart';

void main() {
  late Directory tempDir;
  late Box<String> box;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('orynta_theme_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<String>(AppStrings.settingsBoxName);
  });

  tearDown(() async {
    await box.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Theme Mode Persistence Tests', () {
    test('Initial: defaults to AppThemeType.gold when no saved setting exists', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeNotifierProvider);
      expect(notifier, AppThemeType.gold);
    });

    test('Initial: restores saved theme string from Hive box', () async {
      await box.put('theme_type', 'amoled');

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeNotifierProvider);
      expect(notifier, AppThemeType.amoled);
    });

    test('Set: updating theme updates provider state and persists to Hive', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeNotifierProvider.notifier);
      await notifier.setTheme(AppThemeType.graphite);

      expect(container.read(themeModeNotifierProvider), AppThemeType.graphite);
      expect(box.get('theme_type'), 'graphite');
    });

    test('Toggle: toggles between light and gold correctly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeNotifierProvider.notifier);

      // Current theme is gold (default)
      await notifier.toggle();
      expect(container.read(themeModeNotifierProvider), AppThemeType.light);
      expect(box.get('theme_type'), 'light');

      // Toggle again
      await notifier.toggle();
      expect(container.read(themeModeNotifierProvider), AppThemeType.gold);
      expect(box.get('theme_type'), 'gold');
    });
  });
}
