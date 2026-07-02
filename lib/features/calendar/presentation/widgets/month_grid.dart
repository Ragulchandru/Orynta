import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/calendar_providers.dart';
import 'day_tile.dart';

class MonthGrid extends ConsumerWidget {
  const MonthGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final viewMonth = ref.watch(selectedMonthProvider);

    // Calculate grid dates
    final firstDayOfMonth = DateTime(viewMonth.year, viewMonth.month, 1);
    final weekdayOfFirst = firstDayOfMonth.weekday; // 1 = Mon, ..., 7 = Sun

    // Adjust weekday offset to assume Sunday is column 0 (0-6 index)
    // Sunday in weekday is 7, so (7 % 7) = 0. Monday is 1, ..., Saturday is 6.
    final startOffset = weekdayOfFirst % 7; 

    // Find previous month's ending dates to fill prefix cells
    final prevMonthEnd = firstDayOfMonth.subtract(const Duration(days: 1));
    
    final totalDaysInMonth = DateTime(viewMonth.year, viewMonth.month + 1, 0).day;

    final List<DateTime> gridDates = [];

    // Prefix dates from previous month
    for (int i = startOffset - 1; i >= 0; i--) {
      gridDates.add(DateTime(prevMonthEnd.year, prevMonthEnd.month, prevMonthEnd.day - i));
    }

    // Days in current month
    for (int i = 1; i <= totalDaysInMonth; i++) {
      gridDates.add(DateTime(viewMonth.year, viewMonth.month, i));
    }

    // Suffix dates to complete full 6 weeks grid (42 cells)
    final suffixCount = 42 - gridDates.length;
    for (int i = 1; i <= suffixCount; i++) {
      gridDates.add(DateTime(viewMonth.year, viewMonth.month + 1, i));
    }

    final weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Weekday labels header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays.map((day) {
            return Container(
              width: 32,
              alignment: Alignment.center,
              child: Text(
                day,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.outline,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSizes.xs),

        // 6-week Days Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            final date = gridDates[index];
            final isCurrentMonth = date.month == viewMonth.month;

            return DayTile(
              date: date,
              isCurrentMonth: isCurrentMonth,
            );
          },
        ),
      ],
    );
  }
}
