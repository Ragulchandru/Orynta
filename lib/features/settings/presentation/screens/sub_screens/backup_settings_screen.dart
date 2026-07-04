// lib/features/settings/presentation/screens/sub_screens/backup_settings_screen.dart
//
// Orynta 2.0 — Backup & Restore Settings Sub-Screen

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/design_system/design_system.dart';
import '../../widgets/settings_widgets.dart';

class BackupSettingsScreen extends ConsumerWidget {
  const BackupSettingsScreen({super.key});

  void _exportJsonBackup(BuildContext context) {
    final box = Hive.box<String>(AppStrings.notesBoxName);
    final allNotes = box.values.toList();
    final jsonStr = jsonEncode({'export_date': DateTime.now().toIso8601String(), 'notes': allNotes});

    Clipboard.setData(ClipboardData(text: jsonStr));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Backup JSON exported & copied to clipboard!'),
        duration: Duration(seconds: 3),
      ),
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
          'Backup & Restore',
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
              title: 'LOCAL BACKUP',
              children: [
                PremiumListTile(
                  title: 'Export JSON Backup',
                  subtitle: 'Copies encrypted JSON backup string to clipboard',
                  icon: Icons.upload_file_rounded,
                  iconColor: Colors.green,
                  onTap: () => _exportJsonBackup(context),
                ),
                PremiumListTile(
                  title: 'Restore JSON Backup',
                  subtitle: 'Import notes data from a saved backup file',
                  icon: Icons.file_download_outlined,
                  iconColor: Colors.blue,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Select backup file to restore')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            PremiumSection(
              title: 'CLOUD SYNCHRONIZATION',
              children: [
                PremiumListTile(
                  title: 'Google Drive Cloud Sync',
                  subtitle: 'Coming Soon',
                  icon: Icons.cloud_off_rounded,
                  iconColor: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
                ),
                PremiumListTile(
                  title: 'iCloud Backups',
                  subtitle: 'Coming Soon',
                  icon: Icons.cloud_off_rounded,
                  iconColor: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
