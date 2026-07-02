import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_names.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final actions = [
      _ActionItem(
        icon: Icons.note_add_rounded,
        label: 'New Note',
        color: colorScheme.primary,
        onTap: () => context.pushNamed(RouteNames.noteEditor),
      ),
      _ActionItem(
        icon: Icons.add_task_rounded,
        label: 'New Task',
        color: colorScheme.secondary,
        onTap: () => context.pushNamed(RouteNames.createTask),
      ),
      _ActionItem(
        icon: Icons.play_arrow_rounded,
        label: 'Start Focus',
        color: Colors.red,
        onTap: () => context.pushNamed(RouteNames.focus),
      ),
      _ActionItem(
        icon: Icons.loop_rounded,
        label: 'New Habit',
        color: Colors.orange,
        onTap: () => context.pushNamed(RouteNames.createHabit),
      ),
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: actions.map((act) {
                return InkWell(
                  onTap: act.onTap,
                  borderRadius: BorderRadius.circular(AppSizes.sm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: act.color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            act.icon,
                            color: act.color,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          act.label,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  const _ActionItem({
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
