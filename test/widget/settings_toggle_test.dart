// test/widget/settings_toggle_test.dart
//
// Orynta 2.0 — Settings Toggles Widget Tests

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:orynta/core/constants/app_strings.dart';
import 'package:orynta/features/settings/presentation/providers/settings_provider.dart';
import 'package:orynta/features/settings/presentation/screens/sub_screens/editor_settings_screen.dart';
import 'package:orynta/features/settings/presentation/widgets/settings_widgets.dart';

class FakeSettingsNotifier extends SettingsNotifier {
  FakeSettingsNotifier(SettingsState initialState) {
    state = initialState;
  }

  @override
  void loadSettings() {}

  @override
  Future<void> updateAutosaveEnabled(bool val) async {
    state = state.copyWith(autosaveEnabled: val);
  }
}

void main() {
  late Directory tempDir;
  late Box<String> box;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('orynta_settings_toggle_widget_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<String>(AppStrings.settingsBoxName);
  });

  tearDown(() async {
    await box.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Settings Toggles Widget Tests', () {
    testWidgets('Toggling autosave updates UI state immediately', (tester) async {
      final initialSettings = SettingsState.initial().copyWith(autosaveEnabled: true);
      final notifier = FakeSettingsNotifier(initialSettings);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsStateProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: EditorSettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the PremiumSwitch for Autosave Notes
      // The first tile is Autosave Notes
      final switchFinder = find.byType(PremiumSwitch);
      expect(switchFinder, findsNWidgets(6)); // Autosave, Markdown, Rich formatting, Preview, Focus, Animations

      final autosaveSwitch = tester.widget<PremiumSwitch>(switchFinder.first);
      expect(autosaveSwitch.value, true);

      // Tap the switch
      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      // Check if state updated to false
      expect(notifier.state.autosaveEnabled, false);
    });
  });
}
