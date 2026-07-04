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

import '../../../../core/design_system/design_system.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/widgets/ink_confirm_dialog.dart';
import '../../../../shared/widgets/ink_snack_bar.dart';
import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../notes/presentation/providers/notes_providers.dart';
import '../../../auth/presentation/screens/lock_screen.dart';
import '../../../auth/presentation/providers/app_lock_provider.dart';

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

                // Quick Navigation Section
                const _SectionHeader(title: 'Quick Navigation'),
                const _QuickNavigationCard(),
                const SizedBox(height: AppSizes.md),

                // 2. Storage Section
                const _SectionHeader(title: 'Storage & Statistics'),
                const _StorageStatsCard(),
                const SizedBox(height: AppSizes.md),

                // 3. Security Section
                const _SectionHeader(title: 'Security'),
                const _SecuritySettingsCard(),
                const SizedBox(height: AppSizes.md),

                // 4. Coming Soon Section
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

class _MiniThemePreview extends StatelessWidget {
  const _MiniThemePreview({
    required this.themeData,
    required this.isSelected,
  });

  final AppThemeData themeData;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeData.surfaceDim,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? themeData.primary : themeData.outlineVariant,
          width: isSelected ? 2.5 : 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Miniature Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 24,
              child: Container(
                color: themeData.navigation.background,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: themeData.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 30,
                      height: 4,
                      decoration: BoxDecoration(
                        color: themeData.navigation.active.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Miniature Content Body
            Positioned(
              top: 28,
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 6,
                    decoration: BoxDecoration(
                      color: themeData.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeData.notes.card,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: themeData.notes.cardBorder, width: 0.5),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 25,
                            height: 3,
                            decoration: BoxDecoration(
                              color: themeData.isDark ? Colors.white70 : Colors.black87,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            width: 35,
                            height: 2,
                            decoration: BoxDecoration(
                              color: themeData.isDark ? Colors.white38 : Colors.black38,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: themeData.notes.tagBackground,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Container(
                                width: 12,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: themeData.notes.tagBackground,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSelectorCard extends ConsumerStatefulWidget {
  const _ThemeSelectorCard();

  @override
  ConsumerState<_ThemeSelectorCard> createState() => _ThemeSelectorCardState();
}

class _ThemeSelectorCardState extends ConsumerState<_ThemeSelectorCard> {
  String _cornerStyle = 'Rounded';
  String _animationSpeed = 'Normal';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeTheme = ref.watch(themeModeNotifierProvider);
    final notifier = ref.read(themeModeNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemCount: AppThemeType.values.length,
          itemBuilder: (context, index) {
            final type = AppThemeType.values[index];
            final isSelected = activeTheme == type;
            final itemTheme = AppThemeFactory.getTheme(type);

            return ScaleOnPress(
              onTap: () => notifier.setTheme(type),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _MiniThemePreview(
                      themeData: itemTheme,
                      isSelected: isSelected,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          AppThemeFactory.getTheme(activeTheme).description,
          style: context.typography.bodyMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'ACCENT COLOR',
          style: context.typography.labelMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: AppThemeType.values.map((type) {
            final itemTheme = AppThemeFactory.getTheme(type);
            final isSelected = activeTheme == type;
            return GestureDetector(
              onTap: () => notifier.setTheme(type),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: itemTheme.primary,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: theme.colorScheme.onSurface, width: 2.0)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'CORNER STYLE',
          style: context.typography.labelMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'Curved', label: Text('Curved')),
            ButtonSegment(value: 'Rounded', label: Text('Rounded')),
            ButtonSegment(value: 'Soft', label: Text('Soft')),
          ],
          selected: {_cornerStyle},
          onSelectionChanged: (value) {
            setState(() {
              _cornerStyle = value.first;
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          'ANIMATION SPEED',
          style: context.typography.labelMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'Fast', label: Text('Fast')),
            ButtonSegment(value: 'Normal', label: Text('Normal')),
            ButtonSegment(value: 'Slow', label: Text('Slow')),
          ],
          selected: {_animationSpeed},
          onSelectionChanged: (value) {
            setState(() {
              _animationSpeed = value.first;
            });
          },
        ),
      ],
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
// _SecuritySettingsCard
// ─────────────────────────────────────────────────────────────────────────────

class _SecuritySettingsCard extends ConsumerWidget {
  const _SecuritySettingsCard();

  void _setupAppLock(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LockScreen(
          mode: LockScreenMode.setup,
          onVerified: (pin) async {
            await ref.read(appLockStateProvider.notifier).enableAppLock(pin);
            if (context.mounted) {
              InkSnackBar.showSuccess(context, 'App Lock enabled.');
              Navigator.of(context).pop(); // Dismiss setup
            }
          },
        ),
      ),
    );
  }

  void _disableAppLock(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LockScreen(
          mode: LockScreenMode.verifyCurrent,
          onVerified: (_) async {
            await ref.read(appLockStateProvider.notifier).disableAppLock();
            if (context.mounted) {
              InkSnackBar.showSuccess(context, 'App Lock disabled.');
              Navigator.of(context).pop(); // Dismiss verify screen
            }
          },
        ),
      ),
    );
  }

  void _changePin(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LockScreen(
          mode: LockScreenMode.verifyCurrent,
          onVerified: (_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => LockScreen(
                  mode: LockScreenMode.setup,
                  onVerified: (newPin) async {
                    await ref.read(appLockStateProvider.notifier).enableAppLock(newPin);
                    if (context.mounted) {
                      InkSnackBar.showSuccess(context, 'PIN changed successfully.');
                      Navigator.of(context).pop(); // Dismiss setup screen
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lockState = ref.watch(appLockStateProvider);

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
          // 1. Enable App Lock Switch
          SwitchListTile(
            secondary: Icon(
              Icons.security_rounded,
              color: lockState.isEnabled ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            title: const Text('Enable App Lock'),
            subtitle: const Text('Require PIN or biometrics to open Orynta'),
            value: lockState.isEnabled,
            onChanged: (value) {
              if (value) {
                _setupAppLock(context, ref);
              } else {
                _disableAppLock(context, ref);
              }
            },
          ),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),

          // 2. Use Biometrics Switch
          SwitchListTile(
            secondary: Icon(
              Icons.fingerprint_rounded,
              color: lockState.isBiometricsEnabled ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            title: const Text('Use Biometrics'),
            subtitle: const Text('Unlock using fingerprint or face recognition'),
            value: lockState.isBiometricsEnabled,
            onChanged: lockState.isEnabled && lockState.isBiometricsSupported
                ? (value) => ref.read(appLockStateProvider.notifier).setBiometricsEnabled(value)
                : null,
          ),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),

          // 3. Auto Lock Timeout Dropdown
          ListTile(
            leading: Icon(Icons.timer_outlined, color: theme.colorScheme.onSurfaceVariant),
            title: const Text('Auto Lock'),
            subtitle: const Text('Locks app after background inactivity'),
            trailing: DropdownButton<int>(
              value: lockState.autoLockDuration,
              underline: const SizedBox(),
              onChanged: lockState.isEnabled
                  ? (value) {
                      if (value != null) {
                        ref.read(appLockStateProvider.notifier).setAutoLockDuration(value);
                      }
                    }
                  : null,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Immediately')),
                DropdownMenuItem(value: 30, child: Text('After 30s')),
                DropdownMenuItem(value: 60, child: Text('After 1m')),
                DropdownMenuItem(value: 300, child: Text('After 5m')),
              ],
            ),
          ),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),

          // 4. Change PIN Button
          ListTile(
            leading: Icon(Icons.password_rounded, color: theme.colorScheme.onSurfaceVariant),
            title: const Text('Change PIN'),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
            onTap: lockState.isEnabled ? () => _changePin(context, ref) : null,
            enabled: lockState.isEnabled,
          ),
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

class _QuickNavigationCard extends StatelessWidget {
  const _QuickNavigationCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.archive_outlined, color: theme.colorScheme.primary),
            title: const Text('Archived Notes'),
            subtitle: const Text('View notes stored in your archive'),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.colorScheme.outline),
            onTap: () => context.pushNamed(RouteNames.archive),
          ),
          Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          ListTile(
            leading: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.primary),
            title: const Text('Trash & Recycling'),
            subtitle: const Text('View deleted notes before permanent removal'),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.colorScheme.outline),
            onTap: () => context.pushNamed(RouteNames.trash),
          ),
        ],
      ),
    );
  }
}
