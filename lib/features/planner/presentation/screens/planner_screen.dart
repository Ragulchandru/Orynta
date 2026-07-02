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
import '../widgets/task_multiselect_bar.dart';

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
                    children: const [
                      AgendaSection(),
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
}
