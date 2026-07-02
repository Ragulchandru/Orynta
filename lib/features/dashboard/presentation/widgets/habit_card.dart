import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class HabitCard extends StatefulWidget {
  const HabitCard({super.key});

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  // Local mock habits for interactive Phase 2 representation
  final List<_MockHabit> _habits = [
    _MockHabit(id: '1', name: 'Drink 3L Water', isCompleted: true),
    _MockHabit(id: '2', name: 'Read 10 pages', isCompleted: true),
    _MockHabit(id: '3', name: 'Solve 1 Leetcode', isCompleted: false),
    _MockHabit(id: '4', name: 'Walk 10k Steps', isCompleted: false),
  ];

  int _streak = 7;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final completedCount = _habits.where((h) => h.isCompleted).length;
    final totalCount = _habits.length;
    final completionRatio = totalCount > 0 ? completedCount / totalCount : 0.0;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Habits',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 20),
                    const SizedBox(width: 2),
                    Text(
                      '$_streak Days',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              '$completedCount of $totalCount habits completed today (${(completionRatio * 100).toInt()}%)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _habits.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSizes.xs),
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      habit.isCompleted = !habit.isCompleted;
                      // Update streak dynamically as helper representation
                      if (_habits.every((h) => h.isCompleted)) {
                        _streak = 8;
                      } else {
                        _streak = 7;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(AppSizes.sm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: AppSizes.xs),
                    child: Row(
                      children: [
                        Icon(
                          habit.isCompleted
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: habit.isCompleted ? Colors.orange : colorScheme.outline,
                          size: 20,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: Text(
                            habit.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: habit.isCompleted
                                  ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                                  : colorScheme.onSurface,
                              decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      ],
                    ),
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

class _MockHabit {
  _MockHabit({
    required this.id,
    required this.name,
    required this.isCompleted,
  });

  final String id;
  final String name;
  bool isCompleted;
}
