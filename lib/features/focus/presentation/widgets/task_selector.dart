import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../habits/presentation/providers/habits_notifier.dart';
import '../providers/timer_provider.dart';

class TaskSelector extends ConsumerWidget {
  const TaskSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final timerState = ref.watch(timerProvider);
    final tasks = ref.watch(tasksProvider);
    final habits = ref.watch(habitsProvider);

    final selectedTaskId = timerState.selectedTaskId;
    final selectedHabitId = timerState.selectedHabitId;

    final selectedTask = selectedTaskId != null
        ? tasks.firstWhere((t) => t.id == selectedTaskId)
        : null;

    final selectedHabit = selectedHabitId != null
        ? habits.firstWhere((h) => h.id == selectedHabitId)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Task link button
        InkWell(
          onTap: () => _showTaskHabitBottomSheet(context, ref, tasks, habits),
          borderRadius: BorderRadius.circular(AppSizes.md),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
              borderRadius: BorderRadius.circular(AppSizes.md),
              color: colorScheme.surfaceContainerLow,
            ),
            child: Row(
              children: [
                Icon(
                  selectedTask != null
                      ? Icons.checklist_rounded
                      : (selectedHabit != null ? Icons.spa_rounded : Icons.add_link_rounded),
                  color: selectedTask != null
                      ? colorScheme.primary
                      : (selectedHabit != null ? Colors.orange : colorScheme.outline),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedTask != null
                            ? 'Linked Task'
                            : (selectedHabit != null ? 'Linked Habit' : 'Link Task / Habit'),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.outline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedTask?.title ?? selectedHabit?.title ?? 'No linked goal for session',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: (selectedTask != null || selectedHabit != null)
                              ? colorScheme.onSurface
                              : colorScheme.outline.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                if (selectedTask != null || selectedHabit != null)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    onPressed: () {
                      ref.read(timerProvider.notifier).selectTask(null);
                      ref.read(timerProvider.notifier).selectHabit(null);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
                  const Icon(Icons.arrow_drop_down_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showTaskHabitBottomSheet(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> tasks,
    List<dynamic> habits,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.lg)),
      ),
      builder: (BuildContext ctx) {
        final theme = Theme.of(context);
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Text(
                  'Link to Focus Session',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Tasks'),
                  Tab(text: 'Habits'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tasks Tab
                    tasks.isEmpty
                        ? _buildEmptyTab(theme, 'No active tasks found')
                        : ListView.separated(
                            padding: const EdgeInsets.all(AppSizes.md),
                            itemCount: tasks.length,
                            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.xs),
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return ListTile(
                                leading: const Icon(Icons.checklist_rounded),
                                title: Text(task.title),
                                onTap: () {
                                  ref.read(timerProvider.notifier).selectTask(task.id);
                                  ref.read(timerProvider.notifier).selectHabit(null);
                                  Navigator.of(ctx).pop();
                                },
                              );
                            },
                          ),

                    // Habits Tab
                    habits.isEmpty
                        ? _buildEmptyTab(theme, 'No habits registered')
                        : ListView.separated(
                            padding: const EdgeInsets.all(AppSizes.md),
                            itemCount: habits.length,
                            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.xs),
                            itemBuilder: (context, index) {
                              final habit = habits[index];
                              return ListTile(
                                leading: const Icon(Icons.spa_rounded, color: Colors.orange),
                                title: Text(habit.title),
                                onTap: () {
                                  ref.read(timerProvider.notifier).selectHabit(habit.id);
                                  ref.read(timerProvider.notifier).selectTask(null);
                                  Navigator.of(ctx).pop();
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyTab(ThemeData theme, String text) {
    return Center(
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
      ),
    );
  }
}
