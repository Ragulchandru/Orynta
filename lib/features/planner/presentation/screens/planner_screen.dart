import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_names.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/tasks_notifier.dart';
import '../widgets/task_card.dart';

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dateString = DateFormat('EEEE, MMMM d').format(DateTime.now());

    // Watch tasks lists for each segment
    final morningTasks = ref.watch(morningTasksProvider);
    final afternoonTasks = ref.watch(afternoonTasksProvider);
    final eveningTasks = ref.watch(eveningTasksProvider);
    final nightTasks = ref.watch(nightTasksProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.md, AppSizes.lg, AppSizes.xs),
              child: Column(
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
            ),
            const Divider(),

            // Scrollable Timeline
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(AppSizes.lg, 0, AppSizes.lg, AppSizes.xxxl),
                children: [
                  _buildTimelineSection(
                    context: context,
                    ref: ref,
                    title: 'Morning',
                    icon: Icons.wb_sunny_outlined,
                    iconColor: Colors.amber,
                    tasks: morningTasks,
                  ),
                  _buildTimelineSection(
                    context: context,
                    ref: ref,
                    title: 'Afternoon',
                    icon: Icons.wb_cloudy_outlined,
                    iconColor: Colors.orange,
                    tasks: afternoonTasks,
                  ),
                  _buildTimelineSection(
                    context: context,
                    ref: ref,
                    title: 'Evening',
                    icon: Icons.nights_stay_outlined,
                    iconColor: Colors.indigo,
                    tasks: eveningTasks,
                  ),
                  _buildTimelineSection(
                    context: context,
                    ref: ref,
                    title: 'Night',
                    icon: Icons.bedtime_outlined,
                    iconColor: Colors.blueGrey,
                    tasks: nightTasks,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteNames.createTask),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildTimelineSection({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<TaskEntity> tasks,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (tasks.isNotEmpty)
                Text(
                  '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.xs),

          // Timeline Content Box
          Container(
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
                ? _buildEmptySection(theme)
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
        ],
      ),
    );
  }

  Widget _buildEmptySection(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSizes.sm),
      ),
      child: Center(
        child: Text(
          'No tasks scheduled',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline.withValues(alpha: 0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
