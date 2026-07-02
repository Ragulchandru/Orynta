import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_names.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';
import '../../../calendar/presentation/widgets/agenda_section.dart';
import '../../../calendar/presentation/widgets/calendar_header.dart';
import '../../../calendar/presentation/widgets/month_grid.dart';
import '../../../calendar/presentation/widgets/week_strip.dart';
import '../providers/tasks_notifier.dart';
import '../../../habits/presentation/providers/habits_notifier.dart';
import '../widgets/task_multiselect_bar.dart';
import '../../../focus/presentation/providers/focus_notifier.dart';

final showMonthlyCalendarProvider = StateProvider<bool>((ref) => false);

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedDate = ref.watch(selectedDateProvider);
    final formattedDate = DateFormat('MMMM d, yyyy').format(selectedDate);

    // Watch query state variables
    final searchQuery = ref.watch(taskSearchQueryProvider);
    final activeFilter = ref.watch(taskFilterProvider);
    final activeSort = ref.watch(taskSortProvider);

    // Watch selections and collapse states
    final selectedIds = ref.watch(selectedTasksProvider);
    final isSelectionMode = selectedIds.isNotEmpty;
    final showMonthlyCalendar = ref.watch(showMonthlyCalendarProvider);
    // Calculate daily completion rate
    final dayTasks = ref.watch(selectedDateTasksProvider);
    final dayCompleted = dayTasks.where((t) => t.isCompleted).length;
    final dayPercent = dayTasks.isNotEmpty ? (dayCompleted / dayTasks.length * 100).toInt() : 100;

    // Calculate weekly completion rate
    final allTasks = ref.watch(tasksProvider);
    final weekStart = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekTasks = allTasks.where((t) {
      if (t.dueDate == null) {
        final now = DateTime.now();
        final nowStart = now.subtract(Duration(days: now.weekday - 1));
        return weekStart.isAtSameMomentAs(DateTime(nowStart.year, nowStart.month, nowStart.day));
      }
      final due = t.dueDate!;
      return (due.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
          due.isBefore(weekEnd.add(const Duration(seconds: 1))));
    }).toList();
    final weekCompleted = weekTasks.where((t) => t.isCompleted).length;
    final weekPercent = weekTasks.isNotEmpty ? (weekCompleted / weekTasks.length * 100).toInt() : 100;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header details
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.md, AppSizes.lg, AppSizes.xs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Planner',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Playfair Display',
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_month_rounded, size: 14, color: colorScheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: AppSizes.md),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Daily: $dayPercent% • Weekly: $weekPercent%',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Toggle month grid / clear selections
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              showMonthlyCalendar ? Icons.calendar_view_week_rounded : Icons.calendar_view_month_rounded,
                              color: colorScheme.primary,
                            ),
                            tooltip: showMonthlyCalendar ? 'Show Weekly View' : 'Show Monthly View',
                            onPressed: () {
                              ref.read(showMonthlyCalendarProvider.notifier).state = !showMonthlyCalendar;
                            },
                          ),
                          if (isSelectionMode)
                            TextButton(
                              onPressed: () {
                                ref.read(selectedTasksProvider.notifier).clearSelection();
                              },
                              child: const Text('Clear'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Calendar layouts (Collapsible MonthGrid or WeekStrip)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: showMonthlyCalendar
                        ? Column(
                            children: [
                              const CalendarHeader(),
                              const MonthGrid(),
                              const SizedBox(height: AppSizes.sm),
                              TextButton.icon(
                                onPressed: () {
                                  ref.read(showMonthlyCalendarProvider.notifier).state = false;
                                },
                                icon: const Icon(Icons.expand_less_rounded),
                                label: const Text('Show Weekly Bar'),
                              ),
                            ],
                          )
                        : const WeekStrip(),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),

                // Search, Filter, Sort Controls row
                _buildControls(context, ref, searchQuery, activeFilter, activeSort),
                const SizedBox(height: AppSizes.sm),

                // Agenda Timeline sections lists
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(AppSizes.lg, 0, AppSizes.lg, AppSizes.xxxl * 2),
                    children: [
                      _buildHabitsSection(context, ref),
                      const SizedBox(height: AppSizes.md),
                      const AgendaSection(),
                      const SizedBox(height: AppSizes.md),
                      _buildFocusSessionsSection(context, ref),
                    ],
                  ),
                ),
              ],
            ),

            // Floating multiselect action bar
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: TaskMultiselectBar(),
            ),
          ],
        ),
      ),
      floatingActionButton: isSelectionMode
          ? null
          : FloatingActionButton(
              onPressed: () => context.pushNamed(RouteNames.createTask),
              child: const Icon(Icons.add_rounded),
            ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    WidgetRef ref,
    String query,
    String activeFilter,
    String activeSort,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filterOptions = [
      {'value': 'all', 'label': 'All'},
      {'value': 'today', 'label': 'Today'},
      {'value': 'upcoming', 'label': 'Upcoming'},
      {'value': 'completed', 'label': 'Completed'},
      {'value': 'pending', 'label': 'Pending'},
      {'value': 'high', 'label': 'High Priority'},
      {'value': 'medium', 'label': 'Medium Priority'},
      {'value': 'low', 'label': 'Low Priority'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search & Sort row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) {
                    ref.read(taskSearchQueryProvider.notifier).state = val;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    hintText: 'Search selected date tasks...',
                    hintStyle: TextStyle(color: colorScheme.outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.sm),
                      borderSide: BorderSide(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              
              // Sort dropdown
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort_rounded),
                tooltip: 'Sort Mode',
                color: colorScheme.surface,
                onSelected: (mode) {
                  ref.read(taskSortProvider.notifier).state = mode;
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'dueDate', child: Text('Sort by Due Date')),
                  PopupMenuItem(value: 'priority', child: Text('Sort by Priority')),
                  PopupMenuItem(value: 'recentlyUpdated', child: Text('Sort by Recents')),
                  PopupMenuItem(value: 'alphabetical', child: Text('Sort Alphabetically')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.sm),

        // Filter chips list
        SizedBox(
          height: 36,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            scrollDirection: Axis.horizontal,
            itemCount: filterOptions.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSizes.xs),
            itemBuilder: (context, index) {
              final option = filterOptions[index];
              final isSelected = activeFilter == option['value'];

              return FilterChip(
                label: Text(option['label']!),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(taskFilterProvider.notifier).state = option['value']!;
                },
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                ),
                selectedColor: colorScheme.primary,
                showCheckmark: false,
                padding: EdgeInsets.zero,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHabitsSection(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateHabits = ref.watch(habitsForSelectedDateProvider);

    if (selectedDateHabits.isEmpty) return const SizedBox.shrink();

    final completedCount = selectedDateHabits.where((h) => h.completedToday).length;
    final totalCount = selectedDateHabits.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.spa_rounded, size: 18, color: colorScheme.primary),
                const SizedBox(width: AppSizes.xs),
                Text(
                  'Daily Routines',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Text(
              '$completedCount/$totalCount',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: selectedDateHabits.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
            itemBuilder: (context, index) {
              final habit = selectedDateHabits[index];
              final isDone = habit.completedToday;
              final habitColor = Color(habit.color);

              return Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.md),
                  side: BorderSide(
                    color: isDone
                        ? Colors.green.withValues(alpha: 0.5)
                        : colorScheme.outlineVariant.withValues(alpha: 0.3),
                    width: isDone ? 1.5 : 1,
                  ),
                ),
                color: isDone
                    ? Colors.green.withValues(alpha: 0.05)
                    : colorScheme.surfaceContainerLow,
                child: InkWell(
                  onTap: () {
                    if (isDone) {
                      ref.read(habitsProvider.notifier).decrementHabit(habit.id, selectedDate);
                    } else {
                      ref.read(habitsProvider.notifier).incrementHabit(habit.id, selectedDate);
                    }
                  },
                  borderRadius: BorderRadius.circular(AppSizes.md),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDone
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: isDone ? Colors.green : habitColor,
                          size: 18,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  decoration: isDone ? TextDecoration.lineThrough : null,
                                  color: isDone
                                      ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                                      : colorScheme.onSurface,
                                ),
                            ),
                            if (habit.targetCount > 1) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${habit.currentCount}/${habit.targetCount}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFocusSessionsSection(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedDate = ref.watch(selectedDateProvider);
    final allSessions = ref.watch(focusNotifierProvider);

    final selectedDateSessions = allSessions.where((s) {
      return s.createdAt.year == selectedDate.year &&
             s.createdAt.month == selectedDate.month &&
             s.createdAt.day == selectedDate.day &&
             s.completed;
    }).toList();

    if (selectedDateSessions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.alarm_on_rounded, size: 18, color: colorScheme.primary),
            const SizedBox(width: AppSizes.xs),
            Text(
              'Focus Log',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: selectedDateSessions.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.xs),
          itemBuilder: (context, index) {
            final session = selectedDateSessions[index];
            final isBreak = session.sessionType != 'focus';
            final timeStr = DateFormat('h:mm a').format(session.endTime);
            final durationStr = '${session.actualDurationMinutes}m';

            final icon = isBreak ? Icons.coffee_rounded : Icons.timer_outlined;
            final iconColor = isBreak ? Colors.green : colorScheme.primary;
            final label = isBreak
                ? (session.sessionType == 'shortBreak' ? 'Short Break' : 'Long Break')
                : 'Focus Session';

            return Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.md),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              color: colorScheme.surfaceContainerLow,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 0),
                leading: CircleAvatar(
                  backgroundColor: iconColor.withValues(alpha: 0.1),
                  radius: 16,
                  child: Icon(icon, color: iconColor, size: 16),
                ),
                title: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  'Completed at $timeStr',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Text(
                  durationStr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
