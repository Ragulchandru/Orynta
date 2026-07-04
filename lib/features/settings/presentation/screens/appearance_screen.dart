// lib/features/settings/presentation/screens/appearance_screen.dart
//
// AppearanceScreen — Theme Selection, Live Preview, AMOLED & Shape Styling Config

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_widgets.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);
    final settingsNotifier = ref.read(settingsStateProvider.notifier);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final themeNotifier = ref.read(themeModeNotifierProvider.notifier);
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          'Appearance',
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
            // 1. Live Preview Section
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

            // 2. Preset Themes
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
                final itemTheme = AppThemeFactory.getTheme(type);

                return ScaleOnPress(
                  onTap: () => themeNotifier.setTheme(type),
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

            // 3. Detailed Modifiers
            PremiumSection(
              title: 'COLOR & STYLING',
              children: [
                PremiumListTile(
                  title: 'Accent Color',
                  subtitle: settings.accentColor,
                  icon: Icons.palette_outlined,
                  iconColor: Colors.purple,
                  trailing: DropdownButton<String>(
                    value: settings.accentColor,
                    onChanged: (val) {
                      if (val != null) settingsNotifier.updateAccentColor(val);
                    },
                    underline: const SizedBox(),
                    items: ['Default', 'Teal', 'Indigo', 'Amber', 'Orange', 'Coral']
                        .map((color) => DropdownMenuItem(value: color, child: Text(color)))
                        .toList(),
                  ),
                ),
                PremiumListTile(
                  title: 'AMOLED Mode',
                  subtitle: 'Pitch-black dark backgrounds',
                  icon: Icons.dark_mode_outlined,
                  iconColor: Colors.black,
                  trailing: PremiumSwitch(
                    value: settings.amoledMode,
                    onChanged: (val) => settingsNotifier.updateAmoledMode(val),
                  ),
                ),
                PremiumListTile(
                  title: 'Follow System theme',
                  subtitle: 'Match system theme settings',
                  icon: Icons.settings_brightness_rounded,
                  iconColor: Colors.blue,
                  trailing: PremiumSwitch(
                    value: settings.followSystemTheme,
                    onChanged: (val) => settingsNotifier.updateFollowSystemTheme(val),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Corner Radius (${settings.cornerRadius.toInt()}px)', style: context.typography.bodyMedium),
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
                      Text('Animation Speed (${settings.animationSpeed.toStringAsFixed(1)}x)', style: context.typography.bodyMedium),
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
                const PremiumListTile(
                  title: 'Dynamic Colors (Android 12+)',
                  subtitle: 'Placeholder for dynamic wallpaper colors',
                  icon: Icons.colorize_rounded,
                  iconColor: Colors.grey,
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
