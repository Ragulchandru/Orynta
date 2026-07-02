import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_names.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/tasks_notifier.dart';
import '../widgets/task_card.dart';
import '../widgets/task_multiselect_bar.dart';
import '../widgets/timeline_section_header.dart';

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dateString = DateFormat('EEEE, MMMM d').format(DateTime.now());

    // Watch query query states
    final searchQuery = ref.watch(taskSearchQueryProvider);
    final activeFilter = ref.watch(taskFilterProvider);
    final activeSort = ref.watch(taskSortProvider);

    // Watch tasks lists for each segment (computed lists already filtered/sorted)
    final morningTasks = ref.watch(morningTasksProvider);
    final afternoonTasks = ref.watch(afternoonTasksProvider);
    final eveningTasks = ref.watch(eveningTasksProvider);
    final nightTasks = ref.watch(nightTasksProvider);

    // Watch multiselect parameters
    final selectedIds = ref.watch(selectedTasksProvider);
    final isSelectionMode = selectedIds.isNotEmpty;

    final collapsedSections = ref.watch(collapsedSectionsProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Details
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.md, AppSizes.lg, AppSizes.xs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Planner',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Playfair Display',
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.today_rounded, size: 14, color: colorScheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                dateString,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                ),
                const Divider(),

                // Search & Filter & Sort Controls
                _buildControls(context, ref, searchQuery, activeFilter, activeSort),
                const SizedBox(height: AppSizes.xs),

                // Scrollable Timeline
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(AppSizes.lg, 0, AppSizes.lg, AppSizes.xxxl * 2),
                    children: [
                      _buildCollapsibleSection(
                        context: context,
                        ref: ref,
                        sectionIndex: 0,
                        title: 'Morning',
                        icon: Icons.wb_sunny_outlined,
                        iconColor: Colors.amber,
                        tasks: morningTasks,
                        isCollapsed: collapsedSections.contains(0),
                        selectedIds: selectedIds,
                        isSelectionMode: isSelectionMode,
                      ),
                      _buildCollapsibleSection(
                        context: context,
                        ref: ref,
                        sectionIndex: 1,
                        title: 'Afternoon',
                        icon: Icons.wb_cloudy_outlined,
                        iconColor: Colors.orange,
                        tasks: afternoonTasks,
                        isCollapsed: collapsedSections.contains(1),
                        selectedIds: selectedIds,
                        isSelectionMode: isSelectionMode,
                      ),
                      _buildCollapsibleSection(
                        context: context,
                        ref: ref,
                        sectionIndex: 2,
                        title: 'Evening',
                        icon: Icons.nights_stay_outlined,
                        iconColor: Colors.indigo,
                        tasks: eveningTasks,
                        isCollapsed: collapsedSections.contains(2),
                        selectedIds: selectedIds,
                        isSelectionMode: isSelectionMode,
                      ),
                      _buildCollapsibleSection(
                        context: context,
                        ref: ref,
                        sectionIndex: 3,
                        title: 'Night',
                        icon: Icons.bedtime_outlined,
                        iconColor: Colors.blueGrey,
                        tasks: nightTasks,
                        isCollapsed: collapsedSections.contains(3),
                        selectedIds: selectedIds,
                        isSelectionMode: isSelectionMode,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Floating Bulk Actions Bar
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
        // Search Input row
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
                    hintText: 'Search tasks...',
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

        // Scrollable filter chip row
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

  Widget _buildCollapsibleSection({
    required BuildContext context,
    required WidgetRef ref,
    required int sectionIndex,
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<TaskEntity> tasks,
    required bool isCollapsed,
    required Set<String> selectedIds,
    required bool isSelectionMode,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collapsible Header
          TimelineSectionHeader(
            sectionIndex: sectionIndex,
            title: title,
            icon: icon,
            iconColor: iconColor,
            tasks: tasks,
          ),
          const SizedBox(height: AppSizes.xs),

          // Collapsible body
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: isCollapsed
                ? const SizedBox.shrink()
                : Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                          width: 2,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: AppSizes.md, bottom: AppSizes.sm),
                    margin: const EdgeInsets.only(left: 13),
                    child: tasks.isEmpty
                        ? _buildEmptyState(theme, ref.watch(taskFilterProvider))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: tasks.length,
                            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return TaskCard(
                                key: ValueKey(task.id),
                                task: task,
                                isSelected: selectedIds.contains(task.id),
                                isSelectionMode: isSelectionMode,
                                onTapSelection: () {
                                  ref.read(selectedTasksProvider.notifier).toggleSelection(task.id);
                                },
                                onLongPress: () {
                                  ref.read(selectedTasksProvider.notifier).toggleSelection(task.id);
                                },
                                onTapDetail: () {
                                  context.push('/tasks/${task.id}');
                                },
                                onToggle: () {
                                  ref.read(tasksProvider.notifier).toggleTaskCompletion(task.id);
                                },
                                onDelete: () {
                                  ref.read(tasksProvider.notifier).deleteTask(task.id);
                                },
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, String activeFilter) {
    final message = switch (activeFilter) {
      'completed' => 'No completed tasks here',
      'upcoming' => 'No upcoming tasks found',
      'all' => 'No tasks scheduled',
      _ => 'No matching tasks found',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSizes.sm),
      ),
      child: Center(
        child: Text(
          message,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline.withValues(alpha: 0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
