import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/tasks_notifier.dart';

class TimelineSectionHeader extends ConsumerWidget {
  const TimelineSectionHeader({
    super.key,
    required this.sectionIndex,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.tasks,
  });

  final int sectionIndex;
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Check if section is collapsed
    final collapsedSections = ref.watch(collapsedSectionsProvider);
    final isCollapsed = collapsedSections.contains(sectionIndex);

    final completedCount = tasks.where((t) => t.isCompleted).length;
    final totalCount = tasks.length;
    final remainingCount = totalCount - completedCount;
    final completionRatio = totalCount > 0 ? completedCount / totalCount : 0.0;

    return InkWell(
      onTap: () {
        ref.read(collapsedSectionsProvider.notifier).toggleCollapse(sectionIndex);
      },
      borderRadius: BorderRadius.circular(AppSizes.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.xs, horizontal: 4.0),
        child: Row(
          children: [
            // Collapse/Expand Icon Indicator
            AnimatedRotation(
              turns: isCollapsed ? -0.25 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(width: AppSizes.xs),

            // Icon Background
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: iconColor),
            ),
            const SizedBox(width: AppSizes.sm),

            // Section Title
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const Spacer(),

            // Stat Summary info (Completed / Total count and percentage)
            if (totalCount > 0) ...[
              Text(
                '$completedCount/$totalCount completed (${(completionRatio * 100).toInt()}%)',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: completionRatio == 1.0 ? Colors.green : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (remainingCount > 0) ...[
                const SizedBox(width: AppSizes.xs),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$remainingCount left',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ] else ...[
              Text(
                '0 tasks',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
