// lib/features/settings/presentation/screens/sub_screens/editor_settings_screen.dart
//
// Orynta 2.0 — Editor Settings Sub-Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_system.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/settings_widgets.dart';

class EditorSettingsScreen extends ConsumerWidget {
  const EditorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);
    final settingsNotifier = ref.read(settingsStateProvider.notifier);
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          'Editor Settings',
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          physics: const BouncingScrollPhysics(),
          children: [
            PremiumSection(
              title: 'BEHAVIOR & PARSING',
              children: [
                PremiumListTile(
                  title: 'Autosave Notes',
                  subtitle: 'Saves updates instantly while typing',
                  icon: Icons.save_outlined,
                  iconColor: Colors.green,
                  trailing: PremiumSwitch(
                    value: settings.autosaveEnabled,
                    onChanged: (val) => settingsNotifier.updateAutosaveEnabled(val),
                  ),
                ),
                PremiumListTile(
                  title: 'Markdown Parsing',
                  subtitle: 'Enables interactive headers, quotes, and list rendering',
                  icon: Icons.code_rounded,
                  iconColor: Colors.deepOrange,
                  trailing: PremiumSwitch(
                    value: settings.markdownEnabled,
                    onChanged: (val) => settingsNotifier.updateMarkdownEnabled(val),
                  ),
                ),
                PremiumListTile(
                  title: 'Focus Mode',
                  subtitle: 'Hides toolbars and chrome while editing notes',
                  icon: Icons.filter_center_focus_rounded,
                  iconColor: Colors.indigo,
                  trailing: PremiumSwitch(
                    value: settings.focusModeEnabled,
                    onChanged: (val) => settingsNotifier.updateFocusModeEnabled(val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            PremiumSection(
              title: 'TYPOGRAPHY & LAYOUT',
              children: [
                PremiumListTile(
                  title: 'Toolbar Position',
                  subtitle: settings.editorToolbarPosition,
                  icon: Icons.space_bar_rounded,
                  iconColor: Colors.blueGrey,
                  trailing: DropdownButton<String>(
                    value: settings.editorToolbarPosition,
                    onChanged: (val) {
                      if (val != null) settingsNotifier.updateEditorToolbarPosition(val);
                    },
                    underline: const SizedBox(),
                    items: ['Bottom', 'Top']
                        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                  ),
                ),
                PremiumListTile(
                  title: 'Default Font Family',
                  subtitle: settings.defaultFontFamily,
                  icon: Icons.font_download_rounded,
                  iconColor: Colors.pink,
                  trailing: DropdownButton<String>(
                    value: settings.defaultFontFamily,
                    onChanged: (val) {
                      if (val != null) settingsNotifier.updateDefaultFontFamily(val);
                    },
                    underline: const SizedBox(),
                    items: ['Inter', 'Roboto', 'Outfit', 'monospace']
                        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Default Font Size (${settings.defaultFontSize.toInt()}pt)',
                        style: context.typography.bodyMedium,
                      ),
                      Slider(
                        value: settings.defaultFontSize,
                        min: 12.0,
                        max: 24.0,
                        divisions: 6,
                        onChanged: (val) => settingsNotifier.updateDefaultFontSize(val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
