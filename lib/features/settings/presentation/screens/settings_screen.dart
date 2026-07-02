// lib/features/settings/presentation/screens/settings_screen.dart
//
// SettingsScreen — Phase 3, Step 1.
//
// Orynta Settings Screen.
//
// Design philosophy:
//   Minimal, structured, premium interface. Uses rounded cards to group
//   related settings, consistent with Material 3 styling.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/widgets/ink_confirm_dialog.dart';
import '../../../../shared/widgets/ink_snack_bar.dart';
import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../notes/presentation/providers/notes_providers.dart';

/// Orynta Settings Screen.
///
/// Displays settings for Appearance, Storage stats, Danger Zone actions,
/// and placeholder Coming Soon items.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── SliverAppBar ─────────────────────────────────────────────────
          _SettingsAppBar(),

          // ── Settings List ────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.md,
              AppSizes.sm,
              AppSizes.md,
              MediaQuery.paddingOf(context).bottom + AppSizes.lg,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 1. Appearance Section
                const _SectionHeader(title: 'Appearance'),
                const _ThemeSelectorCard(),
                const SizedBox(height: AppSizes.md),

                // 2. Storage Section
                const _SectionHeader(title: 'Storage & Statistics'),
                const _StorageStatsCard(),
                const SizedBox(height: AppSizes.md),

                // 3. Coming Soon Section
                const _SectionHeader(title: 'Premium Features'),
                const _ComingSoonCard(),
                const SizedBox(height: AppSizes.md),

                // 4. Danger Zone Section
                const _SectionHeader(title: 'Danger Zone', isDestructive: true),
                const _DangerZoneCard(),
                const SizedBox(height: AppSizes.md),

                // 5. About Section
                const _SectionHeader(title: 'About'),
                const _AboutCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SettingsAppBar
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      floating: true,
      snap: true,
      toolbarHeight: 64,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        tooltip: 'Back',
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Settings',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SectionHeader
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.isDestructive = false,
  });

  final String title;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.xs,
        bottom: AppSizes.xs,
        top: AppSizes.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: color.withValues(alpha: 0.8),
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ThemeSelectorCard
// ─────────────────────────────────────────────────────────────────────────────

class _ThemeSelectorCard extends ConsumerWidget {
  const _ThemeSelectorCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeThemeMode = ref.watch(themeModeNotifierProvider);

    Widget buildThemeOption(ThemeMode mode, String label, IconData icon) {
      final isSelected = activeThemeMode == mode;
      return RadioListTile<ThemeMode>(
        value: mode,
        title: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSizes.md),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
        activeColor: theme.colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      color: theme.colorScheme.surfaceContainerLow,
      child: RadioGroup<ThemeMode>(
        groupValue: activeThemeMode,
        onChanged: (value) {
          if (value != null) {
            ref.read(themeModeNotifierProvider.notifier).setMode(value);
          }
        },
        child: Column(
          children: [
            buildThemeOption(ThemeMode.system, 'System Default', Icons.brightness_auto_rounded),
            Divider(height: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
            buildThemeOption(ThemeMode.light, 'Light Mode', Icons.light_mode_rounded),
            Divider(height: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
            buildThemeOption(ThemeMode.dark, 'Dark Mode', Icons.dark_mode_rounded),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StorageStatsCard
// ─────────────────────────────────────────────────────────────────────────────

class _StorageStatsCard extends ConsumerWidget {
  const _StorageStatsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Watch derived note list states
    final activeNotes = ref.watch(activeNotesProvider).valueOrNull?.length ?? 0;
    final archivedNotes = ref.watch(archivedNotesProvider).valueOrNull?.length ?? 0;
    final trashedNotes = ref.watch(trashedNotesProvider).valueOrNull?.length ?? 0;
    final totalNotes = activeNotes + archivedNotes + trashedNotes;

    Widget buildStatRow(String label, int count, IconData icon, Color color) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm + 2,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.xs + 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppSizes.md),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Text(
              '$count',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
        child: Column(
          children: [
            buildStatRow('Active Notes', activeNotes, Icons.description_outlined, theme.colorScheme.primary),
            Divider(height: 1, indent: 52, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
            buildStatRow('Archived Notes', archivedNotes, Icons.archive_outlined, theme.colorScheme.secondary),
            Divider(height: 1, indent: 52, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
            buildStatRow('Trash / Deleted', trashedNotes, Icons.delete_outline_rounded, theme.colorScheme.error),
            Divider(height: 1, indent: 52, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
            buildStatRow('Total Database Count', totalNotes, Icons.storage_rounded, theme.colorScheme.tertiary),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ComingSoonCard
// ─────────────────────────────────────────────────────────────────────────────

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildComingSoonTile(String label, IconData icon) {
      return ListTile(
        leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
        title: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Text(
            'Soon',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        enabled: false,
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          buildComingSoonTile('App Lock (PIN / Biometrics)', Icons.lock_outline_rounded),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          buildComingSoonTile('Backup & Restore', Icons.cloud_upload_outlined),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          buildComingSoonTile('Export Notes (PDF / MD)', Icons.picture_as_pdf_outlined),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          buildComingSoonTile('AI Features (Summarize / Tag)', Icons.auto_awesome_outlined),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DangerZoneCard
// ─────────────────────────────────────────────────────────────────────────────

class _DangerZoneCard extends ConsumerWidget {
  const _DangerZoneCard();

  Future<void> _handleEmptyTrash(BuildContext context, WidgetRef ref) async {
    final confirmed = await InkConfirmDialog.show(
      context,
      title: 'Empty Trash?',
      message: 'All notes in the trash will be permanently deleted. This action is irreversible.',
      confirmLabel: 'Empty Trash',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(notesProvider.notifier).emptyTrash();
      if (context.mounted) {
        InkSnackBar.showSuccess(context, 'Trash emptied successfully.');
      }
    }
  }

  Future<void> _handleClearAllNotes(BuildContext context, WidgetRef ref) async {
    final confirmed = await InkConfirmDialog.show(
      context,
      title: 'Clear All Notes?',
      message: 'Every note in your active list, archive, and trash will be permanently deleted. This action is irreversible.',
      confirmLabel: 'Clear All',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(notesProvider.notifier).clearAllNotes();
      if (context.mounted) {
        InkSnackBar.showSuccess(context, 'Database cleared successfully.');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Watch values to see if buttons should be disabled
    final activeCount = ref.watch(activeNotesProvider).valueOrNull?.length ?? 0;
    final archivedCount = ref.watch(archivedNotesProvider).valueOrNull?.length ?? 0;
    final trashedCount = ref.watch(trashedNotesProvider).valueOrNull?.length ?? 0;
    final totalNotes = activeCount + archivedCount + trashedCount;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: BorderSide(
          color: theme.colorScheme.error.withValues(alpha: 0.25),
        ),
      ),
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.delete_forever_rounded, color: theme.colorScheme.error),
            title: Text(
              'Empty Trash',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: trashedCount > 0 ? theme.colorScheme.error : theme.colorScheme.error.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text('Permanently delete all items currently in trash'),
            onTap: trashedCount > 0 ? () => _handleEmptyTrash(context, ref) : null,
            enabled: trashedCount > 0,
          ),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          ListTile(
            leading: Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
            title: Text(
              'Clear All Notes',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: totalNotes > 0 ? theme.colorScheme.error : theme.colorScheme.error.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text('Permanently erase the entire local notes database'),
            onTap: totalNotes > 0 ? () => _handleClearAllNotes(context, ref) : null,
            enabled: totalNotes > 0,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _AboutCard
// ─────────────────────────────────────────────────────────────────────────────

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildAboutTile(String label, String value, IconData icon, {VoidCallback? onTap}) {
      return ListTile(
        leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
        title: Text(
          label,
          style: theme.textTheme.bodyLarge,
        ),
        trailing: onTap != null
            ? Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5))
            : Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
        onTap: onTap,
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          buildAboutTile('App Name', 'Orynta', Icons.info_outline_rounded),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          buildAboutTile('Version', '1.0.0', Icons.commit_rounded),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          buildAboutTile(
            'Open Source Licenses',
            '',
            Icons.gavel_rounded,
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'Orynta',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2026 Orynta Contributors',
            ),
          ),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          buildAboutTile(
            'GitHub Repository',
            '',
            Icons.code_rounded,
            onTap: () => InkSnackBar.showInfo(context, 'GitHub link placeholder'),
          ),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          buildAboutTile(
            'Privacy Policy',
            '',
            Icons.privacy_tip_outlined,
            onTap: () => InkSnackBar.showInfo(context, 'Privacy policy placeholder'),
          ),
        ],
      ),
    );
  }
}
