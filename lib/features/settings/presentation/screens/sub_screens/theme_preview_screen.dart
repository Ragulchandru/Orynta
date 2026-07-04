// lib/features/settings/presentation/screens/sub_screens/theme_preview_screen.dart
//
// Orynta 2.0 — Theme Preview Screen (Developer Component Gallery)

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/design_system/design_system.dart';


class ThemePreviewScreen extends ConsumerWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only compile/permit rendering in debug mode.
    if (!kDebugMode) {
      return const Scaffold(
        body: Center(child: Text('Developer tool unavailable in production.')),
      );
    }

    final theme = context.appTheme;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.textPrimary, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Theme Component Gallery',
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          _Section(
            title: 'Typography System',
            children: [
              Text('Display Large', style: context.typography.displayLarge.copyWith(color: colors.textPrimary)),
              const SizedBox(height: 8),
              Text('Headline Large', style: context.typography.headlineLarge.copyWith(color: colors.textPrimary)),
              const SizedBox(height: 8),
              Text('Title Medium (Bold)', style: context.typography.titleMedium.copyWith(color: colors.textPrimary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Body Medium (Secondary)', style: context.typography.bodyMedium.copyWith(color: colors.textSecondary)),
              const SizedBox(height: 8),
              Text('Label Small (Capitalized)', style: context.typography.labelSmall.copyWith(color: theme.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'Borders & Cards',
            children: [
              Card(
                margin: EdgeInsets.zero,
                color: theme.notes.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: BorderSide(color: theme.notes.cardBorder, width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Standard Card Container',
                        style: context.typography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Inherits background, border, and radius from the active theme and corner settings.',
                        style: context.typography.bodySmall.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'Interactive Buttons',
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: isDarkColor(theme.primary) ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: const Text('Primary'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.primary,
                        side: BorderSide(color: theme.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: const Text('Outline'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: FloatingActionButton.extended(
                  onPressed: () {},
                  backgroundColor: theme.notes.fabBackground,
                  foregroundColor: theme.notes.fabForeground,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create Task'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'Inputs & Search',
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: TextStyle(color: colors.textSecondary),
                  prefixIcon: Icon(Icons.edit_note_rounded, color: colors.textSecondary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primary, width: 2.0),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.outlineVariant),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: theme.notes.searchBackground,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: theme.notes.searchBorder),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: colors.textSecondary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Search notes & checklists...',
                      style: context.typography.bodyMedium.copyWith(color: colors.textHint),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'Semantic Badges & Chips',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  const _Chip(label: 'Unselected', isSelected: false),
                  const _Chip(label: 'Selected Accent', isSelected: true),
                  _SemanticBadge(label: 'High Priority', color: theme.planner.highPriority),
                  _SemanticBadge(label: 'Medium Priority', color: theme.planner.mediumPriority),
                  _SemanticBadge(label: 'Success State', color: theme.success),
                  _SemanticBadge(label: 'Info State', color: theme.primary),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'Progress Indicators',
            children: [
              Row(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                    strokeWidth: 3,
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.65,
                        backgroundColor: theme.outlineVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                        minHeight: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'Dialogs & Bottom Sheets',
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showDemoDialog(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: theme.outline),
                      ),
                      child: const Text('Show Dialog'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showDemoBottomSheet(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: theme.outline),
                      ),
                      child: const Text('Show Sheet'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  bool isDarkColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance < 0.5;
  }

  void _showDemoDialog(BuildContext context) {
    final theme = context.appTheme;
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surfaceBright,
        title: Text(
          'Sample Alert Dialog',
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        content: Text(
          'This is a visual component mockup using theme outline tokens.',
          style: context.typography.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Confirm', style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDemoBottomSheet(BuildContext context) {
    final theme = context.appTheme;
    final colors = context.colors;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surfaceBright,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        side: BorderSide(color: theme.notes.cardBorder, width: 1.0),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sample Bottom Sheet',
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Correctly layered and uses semantic textPrimary and textSecondary.',
              style: context.typography.bodyMedium.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: const Text('Dismiss', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: context.typography.labelSmall.copyWith(
            color: theme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: theme.notes.cardBorder),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? theme.notes.chipSelected : theme.notes.chipBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: theme.outlineVariant),
      ),
      child: Text(
        label,
        style: context.typography.labelSmall.copyWith(
          color: isSelected ? theme.notes.chipTextSelected : theme.notes.chipText,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _SemanticBadge extends StatelessWidget {
  const _SemanticBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: context.typography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
