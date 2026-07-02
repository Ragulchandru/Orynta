import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/habit_entity.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onLongPress,
    required this.onIncrement,
  });

  final HabitEntity habit;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final habitColor = Color(habit.color);
    final habitIcon = _getIconData(habit.icon);

    final progressRatio = habit.targetCount > 0 ? habit.currentCount / habit.targetCount : 0.0;
    final isDone = habit.completedToday;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(
          color: isDone
              ? Colors.green.withValues(alpha: 0.4)
              : colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: isDone ? 1.5 : 1,
        ),
      ),
      color: isDone
          ? Colors.green.withValues(alpha: 0.05)
          : colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppSizes.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.md),
          child: Row(
            children: [
              // Icon Circle Background
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: habitColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  habitIcon,
                  color: habitColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.md),

              // Title and Streak Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (habit.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        habit.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (habit.currentStreak > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded, size: 12, color: Colors.orange),
                          const SizedBox(width: 2),
                          Text(
                            '${habit.currentStreak} day streak',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.sm),

              // Interactive Progress Circle
              GestureDetector(
                onTap: onIncrement,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: CircularProgressIndicator(
                        value: progressRatio,
                        strokeWidth: 4,
                        backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDone ? Colors.green : habitColor,
                        ),
                      ),
                    ),
                    isDone
                        ? const Icon(Icons.check_rounded, color: Colors.green, size: 20)
                        : Text(
                            '${habit.currentCount}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    return switch (name) {
      'water' => Icons.water_drop_rounded,
      'fitness' => Icons.fitness_center_rounded,
      'book' => Icons.book_rounded,
      'meditation' => Icons.self_improvement_rounded,
      'sleep' => Icons.bedtime_rounded,
      'apple' => Icons.apple_rounded,
      'work' => Icons.work_rounded,
      'savings' => Icons.savings_rounded,
      _ => Icons.spa_rounded,
    };
  }
}
