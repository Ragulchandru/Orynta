// lib/features/settings/presentation/screens/sub_screens/about_settings_screen.dart
//
// Orynta 2.0 — About Settings Sub-Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/design_system/design_system.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/settings_widgets.dart';

class AboutSettingsScreen extends ConsumerWidget {
  const AboutSettingsScreen({super.key});

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: theme.outlineVariant, width: 1.0),
          ),
          title: const Text('Reset Settings?'),
          content: const Text(
            'This will reset all theme preferences, editor choices, and planner configurations to default values. Notes will NOT be deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Hive.box<String>(AppStrings.settingsBoxName).clear();
                ref.read(settingsStateProvider.notifier).loadSettings();
                ref.read(themeModeNotifierProvider.notifier).setTheme(AppThemeType.gold);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings Reset Completed!')),
                );
              },
              child: Text('Reset Now', style: TextStyle(color: theme.error)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          'About Orynta',
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
            Center(
              child: Column(
                children: [
                  const OryntaLogo(size: 140),
                  const SizedBox(height: 16),
                  Text(
                    'Orynta',
                    style: context.typography.headlineMedium.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Write • Organize • Elevate',
                    style: context.typography.bodyMedium.copyWith(
                      color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version ${AppStrings.appVersion}',
                    style: context.typography.labelSmall.copyWith(
                      color: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const PremiumSection(
              title: 'APPLICATION DETAILS',
              children: [
                PremiumListTile(
                  title: 'Orynta Version',
                  subtitle: '${AppStrings.appVersion} (Premium Pro Build)',
                  icon: Icons.info_outline_rounded,
                  iconColor: Colors.blue,
                ),
                PremiumListTile(
                  title: 'Build Number',
                  subtitle: '${AppStrings.appBuildNumber} (Stable Hive Offline Architecture)',
                  icon: Icons.build_outlined,
                  iconColor: Colors.teal,
                ),
              ],
            ),
            const SizedBox(height: 24),
            PremiumSection(
              title: 'RESET DATA',
              children: [
                PremiumListTile(
                  title: 'Reset All Settings',
                  subtitle: 'Restores theme, editor, and planner defaults',
                  icon: Icons.restart_alt_rounded,
                  iconColor: Colors.red,
                  onTap: () => _showResetConfirmation(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
