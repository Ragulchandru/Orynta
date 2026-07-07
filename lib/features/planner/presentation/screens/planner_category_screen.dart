// lib/features/planner/presentation/screens/planner_category_screen.dart
//
// Orynta 2.0 — Planner Category Screen to view tasks under a specific category

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/models/category_model.dart';
import '../providers/categories_notifier.dart';
import '../providers/tasks_notifier.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class PlannerCategoryScreen extends ConsumerWidget {
  const PlannerCategoryScreen({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  void _openTaskDetail(BuildContext context, TaskEntity task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final categories = ref.watch(categoriesProvider);
    final allTasks = ref.watch(tasksProvider);

    // Find the category info
    final category = categories.firstWhere(
      (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
      orElse: () => PlannerCategory(
        id: 'unknown',
        name: categoryName,
        icon: Icons.category_rounded,
        color: Colors.blue,
      ),
    );

    // Filter tasks for this category (excluding archived)
    final tasks = allTasks
        .where((t) => t.category.toLowerCase() == categoryName.toLowerCase() && !t.isArchived)
        .toList();

    final activeTasks = tasks.where((t) => !t.isCompleted).toList();
    final completedTasks = tasks.where((t) => t.isCompleted).toList();

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        elevation: 0,
        title: Text(
          category.name,
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          children: [
            // Category Header Card
            PremiumCard(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(category.icon, color: category.color, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: context.typography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${activeTasks.length} pending • ${completedTasks.length} completed',
                            style: context.typography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline_rounded, size: 48, color: theme.outline),
                      const SizedBox(height: 12),
                      Text('No tasks in this category yet.', style: context.typography.bodyMedium),
                    ],
                  ),
                ),
              )
            else ...[
              if (activeTasks.isNotEmpty) ...[
                Text(
                  'ACTIVE TASKS',
                  style: context.typography.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: theme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeTasks.length,
                  itemBuilder: (context, idx) {
                    final task = activeTasks[idx];
                    return TaskCard(
                      task: task,
                      onToggle: () => ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(task.id),
                      onDelete: () => ref.read(tasksNotifierProvider.notifier).deleteTask(task.id),
                      isSelected: false,
                      isSelectionMode: false,
                      onTapSelection: () {},
                      onLongPress: () {},
                      onTapDetail: () => _openTaskDetail(context, task),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
              if (completedTasks.isNotEmpty) ...[
                Text(
                  'COMPLETED TASKS',
                  style: context.typography.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: theme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: completedTasks.length,
                  itemBuilder: (context, idx) {
                    final task = completedTasks[idx];
                    return TaskCard(
                      task: task,
                      onToggle: () => ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(task.id),
                      onDelete: () => ref.read(tasksNotifierProvider.notifier).deleteTask(task.id),
                      isSelected: false,
                      isSelectionMode: false,
                      onTapSelection: () {},
                      onLongPress: () {},
                      onTapDetail: () => _openTaskDetail(context, task),
                    );
                  },
                ),
              ],
            ],
          ],
        ),
      ),
      floatingActionButton: PremiumFAB(
        onPressed: () {
          final now = DateTime.now();
          final newTask = TaskEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'New Task',
            description: '',
            priority: 'medium',
            dueDate: now,
            createdAt: now,
            updatedAt: now,
            isCompleted: false,
            timelineSection: 0,
            estimatedMinutes: 15,
            tagIds: const [],
            category: category.name,
          );
          _openTaskDetail(context, newTask);
        },
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }
}
