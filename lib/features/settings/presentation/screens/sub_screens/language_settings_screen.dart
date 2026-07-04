// lib/features/settings/presentation/screens/sub_screens/language_settings_screen.dart
//
// Orynta 2.0 — Language & Region Settings Sub-Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_system.dart';
import '../../widgets/settings_widgets.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          'Language & Region',
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
              title: 'LOCALIZATION',
              children: [
                PremiumListTile(
                  title: 'App Language',
                  subtitle: 'English (US)',
                  icon: Icons.translate_rounded,
                  iconColor: Colors.blueAccent,
                  trailing: DropdownButton<String>(
                    value: 'English',
                    onChanged: (val) {},
                    underline: const SizedBox(),
                    items: ['English']
                        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                  ),
                ),
                PremiumListTile(
                  title: 'Additional Languages',
                  subtitle: 'Spanish, French, German (Coming Soon)',
                  icon: Icons.language_rounded,
                  iconColor: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
                ),
                PremiumListTile(
                  title: 'Region Formatting',
                  subtitle: 'United States',
                  icon: Icons.map_outlined,
                  iconColor: Colors.green,
                  trailing: DropdownButton<String>(
                    value: 'United States',
                    onChanged: (val) {},
                    underline: const SizedBox(),
                    items: ['United States', 'United Kingdom', 'Europe']
                        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
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
