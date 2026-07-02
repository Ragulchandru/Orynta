import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/providers/habits_notifier.dart';
import '../providers/calendar_providers.dart';
import 'calendar_indicator.dart';

class DayTile extends ConsumerWidget {
  const DayTile({
    super.key,
    required this.date,
    required this.isCurrentMonth,
  });

  final DateTime date;
  final bool isCurrentMonth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedDate = ref.watch(selectedDateProvider);
    final taskMap = ref.watch(monthlyTaskMapProvider);
    final habits = ref.watch(habitsProvider);

    final isSelected = selectedDate.year == date.year &&
        selectedDate.month == date.month &&
        selectedDate.day == date.day;

    final now = DateTime.now();
    final isToday = now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;

    // Format date key: yyyy-MM-dd
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final taskCount = taskMap[dateKey] ?? 0;

    // Habits Completion Check for this date
    final hasHabits = habits.isNotEmpty;
    final completedHabitsCount = habits.where((h) => (h.completionHistory[dateKey] ?? 0) >= h.targetCount).length;
    final anyHabitCompleted = habits.any((h) => (h.completionHistory[dateKey] ?? 0) > 0);
    final allHabitsCompleted = hasHabits && completedHabitsCount == habits.length;

    // Colors & Styles
    Color? textColor;
    if (isSelected) {
      textColor = colorScheme.onPrimary;
    } else if (isToday) {
      textColor = colorScheme.primary;
    } else if (!isCurrentMonth) {
      textColor = colorScheme.outlineVariant;
    } else {
      textColor = colorScheme.onSurface;
    }

    Widget cellChild = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          date.day.toString(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: (isSelected || isToday) ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 2),
        CalendarIndicator(
          taskCount: taskCount,
          isCompleted: false,
          hasHabits: hasHabits,
          allHabitsCompleted: allHabitsCompleted,
          anyHabitsCompleted: anyHabitCompleted,
        ),
      ],
    );

    // Selected decoration
    Decoration? decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
      );
    } else if (isToday) {
      decoration = BoxDecoration(
        border: Border.all(color: colorScheme.primary, width: 1.5),
        shape: BoxShape.circle,
      );
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(3.0),
        decoration: decoration,
        child: InkWell(
          onTap: () {
            // Update selected date
            ref.read(selectedDateProvider.notifier).state = date;
          },
          borderRadius: BorderRadius.circular(999),
          child: cellChild,
        ),
      ),
    );
  }
}
