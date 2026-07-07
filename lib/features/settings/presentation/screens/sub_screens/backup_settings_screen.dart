import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/design_system/design_system.dart';
import '../../../../notes/data/models/note_model.dart';
import '../../../../notes/presentation/providers/notes_home_providers.dart';
import '../../widgets/settings_widgets.dart';

class BackupSettingsScreen extends ConsumerWidget {
  const BackupSettingsScreen({super.key});

  void _exportJsonBackup(BuildContext context) {
    final box = Hive.box<NoteModel>(AppStrings.notesBoxName);
    final allNotes = box.values.toList();
    final jsonStr = jsonEncode({
      'export_date': DateTime.now().toIso8601String(),
      'notes': allNotes.map((n) => n.toJson()).toList(),
    });

    Clipboard.setData(ClipboardData(text: jsonStr));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Backup JSON exported & copied to clipboard!'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _restoreJsonBackup(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final textController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: theme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: theme.outlineVariant, width: 1.0),
              ),
              title: Text(
                'Restore Notes Backup',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paste the exported backup JSON string below:',
                    style: context.typography.bodySmall.copyWith(
                      color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF7E7E9A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: textController,
                    maxLines: 6,
                    style: context.typography.bodySmall.copyWith(fontFamily: 'monospace'),
                    decoration: InputDecoration(
                      hintText: '{"export_date": ...}',
                      errorText: errorMessage,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.outline),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final jsonStr = textController.text.trim();
                    if (jsonStr.isEmpty) {
                      setState(() {
                        errorMessage = 'Please paste a valid JSON string';
                      });
                      return;
                    }
                    try {
                      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
                      final notesList = decoded['notes'] as List<dynamic>;
                      
                      final box = Hive.box<NoteModel>(AppStrings.notesBoxName);
                      int count = 0;
                      for (final raw in notesList) {
                        final noteMap = Map<String, dynamic>.from(raw as Map);
                        final note = NoteModel.fromJson(noteMap);
                        await box.put(note.id, note);
                        count++;
                      }
                      
                      // Refresh notes list provider
                      ref.read(notesHomeControllerProvider.notifier).loadNotes();
                      
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Successfully restored $count notes from backup!')),
                        );
                      }
                    } catch (e) {
                      setState(() {
                        errorMessage = 'Invalid backup format or parse error';
                      });
                    }
                  },
                  child: const Text('Import'),
                ),
              ],
            );
          },
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
                  onTap: () => _restoreJsonBackup(context, ref),
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
