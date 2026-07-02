import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/calendar_providers.dart';

class CalendarHeader extends ConsumerWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currentMonth = ref.watch(selectedMonthProvider);
    final formattedMonth = DateFormat('MMMM yyyy').format(currentMonth);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs, vertical: AppSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nav Back
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () {
              ref.read(selectedMonthProvider.notifier).state = DateTime(
                currentMonth.year,
                currentMonth.month - 1,
                1,
              );
            },
          ),

          // Animated Month/Year Label
          // Key changes on date updates to trigger flutter_animate transitions
          KeyedSubtree(
            key: ValueKey(currentMonth),
            child: Text(
              formattedMonth,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ).animate().fadeIn(duration: 150.ms).slideX(begin: -0.1, end: 0.0, duration: 150.ms),
          ),

          // Nav Forward
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: () {
              ref.read(selectedMonthProvider.notifier).state = DateTime(
                currentMonth.year,
                currentMonth.month + 1,
                1,
              );
            },
          ),
        ],
      ),
    );
  }
}
