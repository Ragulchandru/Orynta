// lib/features/settings/presentation/screens/settings_screen.dart
//
// Orynta 2.0 — Settings Center Category Index

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import 'appearance_screen.dart';
import 'sub_screens/about_settings_screen.dart';
import 'sub_screens/accessibility_settings_screen.dart';
import 'sub_screens/analytics_settings_screen.dart';
import 'sub_screens/backup_settings_screen.dart';
import 'sub_screens/editor_settings_screen.dart';
import 'sub_screens/experimental_settings_screen.dart';
import 'sub_screens/language_settings_screen.dart';
import 'sub_screens/notifications_settings_screen.dart';
import 'sub_screens/planner_settings_screen.dart';
import 'sub_screens/security_settings_screen.dart';
import 'sub_screens/theme_preview_screen.dart';
import '../widgets/settings_widgets.dart';

enum SettingsCategory {
  appearance,
  editor,
  planner,
  analytics,
  notifications,
  security,
  backup,
  language,
  accessibility,
  experimental,
  about,
  themePreview;

  String get label => switch (this) {
        SettingsCategory.appearance => 'Appearance',
        SettingsCategory.editor => 'Editor Settings',
        SettingsCategory.planner => 'Planner Options',
        SettingsCategory.analytics => 'Analytics Targets',
        SettingsCategory.notifications => 'Notifications',
        SettingsCategory.security => 'Privacy & Security',
        SettingsCategory.backup => 'Backup & Restore',
        SettingsCategory.accessibility => 'Accessibility',
        SettingsCategory.language => 'Language & Region',
        SettingsCategory.experimental => 'Experimental Labs',
        SettingsCategory.about => 'About Orynta',
        SettingsCategory.themePreview => 'Theme Preview',
      };

  String get subtitle => switch (this) {
        SettingsCategory.appearance => 'Themes, dark mode, animation speeds, corner shapes',
        SettingsCategory.editor => 'Autosave, markdown parsing, font choices, toolbar layout',
        SettingsCategory.planner => 'Week start days, default calendar views, 24h formats',
        SettingsCategory.analytics => 'Daily focus goals and task targets',
        SettingsCategory.notifications => 'Daily reminders, time pickers, quiet hours',
        SettingsCategory.security => 'PIN lock screen, biometrics, auto-lock rules',
        SettingsCategory.backup => 'Local JSON backup export/restore, cloud sync',
        SettingsCategory.accessibility => 'Text font scaling and visual contrast options',
        SettingsCategory.language => 'App language selection and regional formats',
        SettingsCategory.experimental => 'AI suggestions labs and masonry grid experiments',
        SettingsCategory.about => 'Build details, version information, settings reset',
        SettingsCategory.themePreview => 'Developer component and typography gallery',
      };

  IconData get icon => switch (this) {
        SettingsCategory.appearance => Icons.palette_rounded,
        SettingsCategory.editor => Icons.edit_note_rounded,
        SettingsCategory.planner => Icons.calendar_today_rounded,
        SettingsCategory.analytics => Icons.analytics_rounded,
        SettingsCategory.notifications => Icons.notifications_active_rounded,
        SettingsCategory.security => Icons.security_rounded,
        SettingsCategory.backup => Icons.backup_rounded,
        SettingsCategory.accessibility => Icons.accessibility_new_rounded,
        SettingsCategory.language => Icons.language_rounded,
        SettingsCategory.experimental => Icons.science_rounded,
        SettingsCategory.about => Icons.info_outline_rounded,
        SettingsCategory.themePreview => Icons.developer_mode_rounded,
      };

  Color get color => switch (this) {
        SettingsCategory.appearance => Colors.purple,
        SettingsCategory.editor => Colors.blue,
        SettingsCategory.planner => Colors.indigo,
        SettingsCategory.analytics => Colors.teal,
        SettingsCategory.notifications => Colors.deepOrange,
        SettingsCategory.security => Colors.green,
        SettingsCategory.backup => Colors.amber,
        SettingsCategory.accessibility => Colors.lightBlue,
        SettingsCategory.language => Colors.pink,
        SettingsCategory.experimental => Colors.deepPurple,
        SettingsCategory.about => Colors.blueGrey,
        SettingsCategory.themePreview => Colors.red,
      };
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  SettingsCategory _selectedCategory = SettingsCategory.appearance;

  List<SettingsCategory> get _visibleCategories => SettingsCategory.values
      .where((c) => c != SettingsCategory.themePreview || kDebugMode)
      .toList();

  void _openSubScreen(BuildContext context, SettingsCategory category) {
    Widget page = switch (category) {
      SettingsCategory.appearance => const AppearanceScreen(),
      SettingsCategory.editor => const EditorSettingsScreen(),
      SettingsCategory.planner => const PlannerSettingsScreen(),
      SettingsCategory.analytics => const AnalyticsSettingsScreen(),
      SettingsCategory.notifications => const NotificationsSettingsScreen(),
      SettingsCategory.security => const SecuritySettingsScreen(),
      SettingsCategory.backup => const BackupSettingsScreen(),
      SettingsCategory.language => const LanguageSettingsScreen(),
      SettingsCategory.accessibility => const AccessibilitySettingsScreen(),
      SettingsCategory.experimental => const ExperimentalSettingsScreen(),
      SettingsCategory.about => const AboutSettingsScreen(),
      SettingsCategory.themePreview => const ThemePreviewScreen(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = context.colors;
    final width = MediaQuery.of(context).size.width;
    final categories = _visibleCategories;

    if (width >= 1024) {
      // Desktop Sidebar + Master Detail sub-screen embedding
      return Scaffold(
        backgroundColor: theme.surfaceDim,
        body: SafeArea(
          child: Row(
            children: [
              // Sidebar Navigation
              Container(
                width: 320,
                color: theme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                            onPressed: () => context.pop(),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Settings',
                            style: context.typography.titleLarge.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = _selectedCategory == category;
                          return ListTile(
                            leading: Icon(
                              category.icon,
                              color: isSelected
                                  ? theme.primary
                                  : colors.textSecondary,
                            ),
                            title: Text(
                              category.label,
                              style: context.typography.bodyMedium.copyWith(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected
                                    ? theme.primary
                                    : colors.textPrimary,
                              ),
                            ),
                            selected: isSelected,
                            selectedTileColor: theme.primary.withValues(alpha: 0.08),
                            onTap: () => setState(() => _selectedCategory = category),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(width: 1, color: theme.outlineVariant),
              // Detail Panel Sub-Screen
              Expanded(
                child: ClipRRect(
                  child: KeyedSubtree(
                    key: ValueKey(_selectedCategory),
                    child: switch (_selectedCategory) {
                      SettingsCategory.appearance => const AppearanceScreen(),
                      SettingsCategory.editor => const EditorSettingsScreen(),
                      SettingsCategory.planner => const PlannerSettingsScreen(),
                      SettingsCategory.analytics => const AnalyticsSettingsScreen(),
                      SettingsCategory.notifications => const NotificationsSettingsScreen(),
                      SettingsCategory.security => const SecuritySettingsScreen(),
                      SettingsCategory.backup => const BackupSettingsScreen(),
                      SettingsCategory.language => const LanguageSettingsScreen(),
                      SettingsCategory.accessibility => const AccessibilitySettingsScreen(),
                      SettingsCategory.experimental => const ExperimentalSettingsScreen(),
                      SettingsCategory.about => const AboutSettingsScreen(),
                      SettingsCategory.themePreview => const ThemePreviewScreen(),
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Phone / Tablet: Categorized List of Sub-Screens
    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          'Settings',
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
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
              title: 'PREFERENCES & CONFIGURATION',
              children: categories.map((category) {
                return PremiumListTile(
                  title: category.label,
                  subtitle: category.subtitle,
                  icon: category.icon,
                  iconColor: theme.primary,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colors.textSecondary,
                  ),
                  onTap: () => _openSubScreen(context, category),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
