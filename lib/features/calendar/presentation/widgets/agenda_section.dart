import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../planner/domain/entities/task_entity.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../planner/presentation/widgets/task_card.dart';
import '../../../planner/presentation/widgets/timeline_section_header.dart';
import '../providers/calendar_providers.dart';

class AgendaSection extends ConsumerWidget {
  const AgendaSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch tasks for the selected date across each timeline section
    final morningTasks = ref.watch(selectedDateMorningTasksProvider);
    final afternoonTasks = ref.watch(selectedDateAfternoonTasksProvider);
    final eveningTasks = ref.watch(selectedDateEveningTasksProvider);
    final nightTasks = ref.watch(selectedDateNightTasksProvider);

    // Watch selections for multiselection
    final selectedIds = ref.watch(selectedTasksProvider);
    final isSelectionMode = selectedIds.isNotEmpty;

    final collapsedSections = ref.watch(collapsedSectionsProvider);

    final totalTasksCount = morningTasks.length + afternoonTasks.length + eveningTasks.length + nightTasks.length;

    if (totalTasksCount == 0) {
      return EmptyStateWidget(
        icon: Icons.wb_sunny_rounded,
        iconColor: Colors.amber,
        title: "You're free today.",
        description: "Enjoy your day or tap + to schedule a task.",
        actionLabel: "Create Task",
        onAction: () => context.pushNamed(RouteNames.createTask),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          // Header Row
          TimelineSectionHeader(
            sectionIndex: sectionIndex,
            title: title,
            icon: icon,
            iconColor: iconColor,
            tasks: tasks,
          ),
          const SizedBox(height: AppSizes.xs),

          // Collapsible list
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
                        ? _buildSectionEmptyState(theme)
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

  Widget _buildSectionEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSizes.sm),
      ),
      child: Center(
        child: Text(
          'No tasks in this section',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline.withValues(alpha: 0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
