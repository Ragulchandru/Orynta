import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../providers/calendar_providers.dart';

class WeekStrip extends ConsumerWidget {
  const WeekStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedDate = ref.watch(selectedDateProvider);
    final tasks = ref.watch(tasksProvider);

    // Find the Sunday of the current week containing selectedDate
    // selectedDate.weekday returns 1 = Monday, ..., 7 = Sunday
    final weekday = selectedDate.weekday;
    final sundayOffset = weekday % 7; // Sunday is 0, Mon is 1, ..., Sat is 6
    final startOfWeek = selectedDate.subtract(Duration(days: sundayOffset));

    final List<DateTime> weekDates = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.md),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: AppSizes.xs),
        child: Row(
          children: [
            // Prev Week Button
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, size: 20),
              visualDensity: VisualDensity.compact,
              onPressed: () {
                ref.read(selectedDateProvider.notifier).state = selectedDate.subtract(const Duration(days: 7));
              },
            ),

            // 7 Days
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: weekDates.map((date) {
                  final isSelected = date.year == selectedDate.year &&
                      date.month == selectedDate.month &&
                      date.day == selectedDate.day;

                  final now = DateTime.now();
                  final isToday = now.year == date.year &&
                      now.month == date.month &&
                      now.day == date.day;

                  // Find tasks counts for this specific date
                  final dateTaskCount = tasks.where((t) {
                    if (t.dueDate == null) return false;
                    final due = t.dueDate!;
                    return due.year == date.year && due.month == date.month && due.day == date.day;
                  }).length;

                  final dayLabel = DateFormat('E').format(date).substring(0, 1); // S, M, T, W, T, F, S

                  Color? dayBg;
                  Color? dayFg;

                  if (isSelected) {
                    dayBg = colorScheme.primary;
                    dayFg = colorScheme.onPrimary;
                  } else if (isToday) {
                    dayBg = colorScheme.primaryContainer;
                    dayFg = colorScheme.onPrimaryContainer;
                  }

                  return InkWell(
                    onTap: () {
                      ref.read(selectedDateProvider.notifier).state = date;
                    },
                    borderRadius: BorderRadius.circular(AppSizes.sm),
                    child: Container(
                      width: 32,
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      decoration: BoxDecoration(
                        color: dayBg,
                        borderRadius: BorderRadius.circular(AppSizes.sm),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dayLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                              color: isSelected ? dayFg : colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date.day.toString(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? dayFg : colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Count badge/indicator
                          if (dateTaskCount > 0)
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: isSelected ? dayFg : colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Next Week Button
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded, size: 20),
              visualDensity: VisualDensity.compact,
              onPressed: () {
                ref.read(selectedDateProvider.notifier).state = selectedDate.add(const Duration(days: 7));
              },
            ),
          ],
        ),
      ),
    );
  }
}
