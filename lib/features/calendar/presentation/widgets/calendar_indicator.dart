import 'package:flutter/material.dart';

class CalendarIndicator extends StatelessWidget {
  const CalendarIndicator({
    super.key,
    required this.taskCount,
    this.isCompleted = false,
  });

  final int taskCount;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    if (taskCount == 0) return const SizedBox(height: 4);

    final colorScheme = Theme.of(context).colorScheme;
    final dotColor = isCompleted ? Colors.green : colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        taskCount.clamp(1, 3), // Max 3 indicator dots
        (index) => Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 1.0),
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
