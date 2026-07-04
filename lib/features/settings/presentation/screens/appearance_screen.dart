// lib/features/settings/presentation/screens/appearance_screen.dart
//
// AppearanceScreen — Theme Selection, Live Preview, AMOLED & Shape Styling Config

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../shared/providers/appearance_mode.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_widgets.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  void _showResetConfirmationDialog(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surfaceBright,
        title: Text(
          'Reset Appearance?',
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        content: Text(
          'This will restore Orynta Gold preset, Dark appearance, default corner radius, and default animation speeds.',
          style: context.typography.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Reset preset to gold
              await ref.read(themeModeNotifierProvider.notifier).setTheme(AppThemeType.gold);
              // Reset mode to dark
              await ref.read(appearanceModeProvider.notifier).setMode(AppearanceMode.dark);
              // Reset settings (radius, speed)
              await ref.read(settingsStateProvider.notifier).resetAppearance();
            },
            child: Text('Reset', style: TextStyle(color: theme.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);
    final settingsNotifier = ref.read(settingsStateProvider.notifier);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final themeNotifier = ref.read(themeModeNotifierProvider.notifier);
    final appearanceMode = ref.watch(appearanceModeProvider);
    final theme = context.appTheme;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          'Appearance',
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          physics: const BouncingScrollPhysics(),
          children: [
            // 1. Appearance Mode Selector
            Text(
              'APPEARANCE MODE',
              style: context.typography.labelSmall.copyWith(
                color: theme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<AppearanceMode>(
                segments: const <ButtonSegment<AppearanceMode>>[
                  ButtonSegment<AppearanceMode>(
                    value: AppearanceMode.light,
                    label: Text('Light'),
                    icon: Icon(Icons.wb_sunny_rounded),
                  ),
                  ButtonSegment<AppearanceMode>(
                    value: AppearanceMode.dark,
                    label: Text('Dark'),
                    icon: Icon(Icons.nightlight_round_rounded),
                  ),
                  ButtonSegment<AppearanceMode>(
                    value: AppearanceMode.amoled,
                    label: Text('AMOLED'),
                    icon: Icon(Icons.circle_rounded),
                  ),
                ],
                selected: <AppearanceMode>{appearanceMode},
                onSelectionChanged: (Set<AppearanceMode> selected) {
                  ref.read(appearanceModeProvider.notifier).setMode(selected.first);
                },
              ),
            ),
            const SizedBox(height: 24),

            // 2. Live Preview Section
            Text(
              'LIVE PREVIEW',
              style: context.typography.labelSmall.copyWith(
                color: theme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 160,
              child: _MiniThemePreview(
                themeData: theme,
                isSelected: true,
              ),
            ),
            const SizedBox(height: 24),

            // 3. Preset Themes
            Text(
              'THEME PRESETS',
              style: context.typography.labelSmall.copyWith(
                color: theme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemCount: AppThemeType.values.length,
              itemBuilder: (context, index) {
                final type = AppThemeType.values[index];
                final isSelected = themeMode == type;
                final itemTheme = AppTheme.buildTheme(type, mode: appearanceMode, cornerRadius: settings.cornerRadius);

                return ScaleOnPress(
                  onTap: () => themeNotifier.setTheme(type),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: _MiniThemePreview(
                          themeData: itemTheme.extension<OryThemeExtension>()?.themeData ?? itemTheme as dynamic,
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
                            color: Colors.black.withValues(alpha: 0.65),
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
            const SizedBox(height: 24),

            // 4. Detailed Modifiers
            PremiumSection(
              title: 'COLOR & STYLING',
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Corner Radius (${settings.cornerRadius.toInt()}px)', style: context.typography.bodyMedium.copyWith(color: colors.textPrimary)),
                      Slider(
                        value: settings.cornerRadius,
                        min: 4.0,
                        max: 24.0,
                        divisions: 5,
                        onChanged: (val) => settingsNotifier.updateCornerRadius(val),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Animation Speed (${settings.animationSpeed.toStringAsFixed(1)}x)', style: context.typography.bodyMedium.copyWith(color: colors.textPrimary)),
                      Slider(
                        value: settings.animationSpeed,
                        min: 0.2,
                        max: 2.0,
                        divisions: 9,
                        onChanged: (val) => settingsNotifier.updateAnimationSpeed(val),
                      ),
                    ],
                  ),
                ),
                PremiumListTile(
                  title: 'Dynamic Colors (Android 12+)',
                  subtitle: 'Placeholder for dynamic wallpaper colors',
                  icon: Icons.colorize_rounded,
                  iconColor: colors.textSecondary,
                ),
                PremiumListTile(
                  title: 'Reset Appearance',
                  subtitle: 'Restores default theme preset, appearance, and layouts',
                  icon: Icons.restore_rounded,
                  iconColor: theme.error,
                  onTap: () => _showResetConfirmationDialog(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
                              color: themeData.brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            width: 35,
                            height: 2,
                            decoration: BoxDecoration(
                              color: themeData.brightness == Brightness.dark ? Colors.white38 : Colors.black38,
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
