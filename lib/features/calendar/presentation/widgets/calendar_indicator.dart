import 'package:flutter/material.dart';

class CalendarIndicator extends StatelessWidget {
  const CalendarIndicator({
    super.key,
    required this.taskCount,
    this.isCompleted = false,
    required this.hasHabits,
    this.allHabitsCompleted = false,
    this.anyHabitsCompleted = false,
  });

  final int taskCount;
  final bool isCompleted;
  final bool hasHabits;
  final bool allHabitsCompleted;
  final bool anyHabitsCompleted;

  @override
  Widget build(BuildContext context) {
    if (taskCount == 0 && !hasHabits) return const SizedBox(height: 4);

    final colorScheme = Theme.of(context).colorScheme;
    final taskDotColor = isCompleted ? Colors.green : colorScheme.primary;

    Color habitDotColor = Colors.orange.withValues(alpha: 0.4);
    if (allHabitsCompleted) {
      habitDotColor = Colors.orange;
    } else if (anyHabitsCompleted) {
      habitDotColor = Colors.orangeAccent;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Task Dots
        if (taskCount > 0)
          ...List.generate(
            taskCount.clamp(1, 2), // Max 2 dots to avoid overflowing cells
            (index) => Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 0.5),
              decoration: BoxDecoration(
                color: taskDotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),

        // Spacing if both exist
        if (taskCount > 0 && hasHabits) const SizedBox(width: 3),

        // 2. Habit Dot
        if (hasHabits)
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: habitDotColor,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
