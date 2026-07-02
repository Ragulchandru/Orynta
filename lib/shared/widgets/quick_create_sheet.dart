import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/router/route_names.dart';
import 'ink_snack_bar.dart';

class QuickCreateSheet extends StatelessWidget {
  const QuickCreateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final items = [
      _QuickActionItem(
        icon: Icons.sticky_note_2_rounded,
        label: 'New Note',
        color: colorScheme.primary,
        onTap: () {
          Navigator.of(context).pop();
          context.pushNamed(RouteNames.noteEditor);
        },
      ),
      _QuickActionItem(
        icon: Icons.assignment_turned_in_rounded,
        label: 'New Task',
        color: colorScheme.secondary,
        onTap: () {
          Navigator.of(context).pop();
          context.pushNamed(RouteNames.createTask);
        },
      ),
      _QuickActionItem(
        icon: Icons.folder_shared_rounded,
        label: 'New Project',
        color: colorScheme.tertiary,
        onTap: () {
          Navigator.of(context).pop();
          InkSnackBar.showInfo(context, 'Projects are coming soon in Phase 4.');
        },
      ),
      _QuickActionItem(
        icon: Icons.loop_rounded,
        label: 'New Habit',
        color: Colors.orange,
        onTap: () {
          Navigator.of(context).pop();
          InkSnackBar.showInfo(context, 'Habits are coming soon in Phase 6.');
        },
      ),
      _QuickActionItem(
        icon: Icons.mic_rounded,
        label: 'Voice Note',
        color: Colors.red,
        onTap: () {
          Navigator.of(context).pop();
          InkSnackBar.showInfo(context, 'Voice Notes are coming soon in a future update.');
        },
      ),
      _QuickActionItem(
        icon: Icons.checklist_rounded,
        label: 'Checklist',
        color: Colors.teal,
        onTap: () {
          Navigator.of(context).pop();
          InkSnackBar.showInfo(context, 'Checklists are coming soon in a future update.');
        },
      ),
    ];

    return Container(
      padding: const EdgeInsets.only(
        top: AppSizes.md,
        left: AppSizes.lg,
        right: AppSizes.lg,
        bottom: AppSizes.xl,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.lg),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Create New',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: AppSizes.md,
                crossAxisSpacing: AppSizes.md,
                childAspectRatio: 0.95,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(AppSizes.md),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          color: item.color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        item.label,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
}
