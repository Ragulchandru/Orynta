// lib/features/planner/presentation/screens/planner_screen.dart
//
// Orynta 2.0 — Redesigned Premium Planner 2.0 Dashboard

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../workspace/presentation/widgets/workspace_avatar.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/models/category_model.dart';
import '../providers/categories_notifier.dart';
import '../providers/planner_stats_provider.dart';
import '../providers/tasks_notifier.dart';
import '../widgets/task_card.dart';
import 'planner_calendar_view.dart';
import 'task_detail_screen.dart';

class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});

  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  final TextEditingController _quickAddController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _quickAddController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showCalendar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlannerCalendarView()),
    );
  }

  void _openTaskDetail(TaskEntity task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
    );
  }

  void _createNewTask() {
    final now = DateTime.now();
    final defaultCat = ref.read(categoriesProvider.notifier).defaultCategoryId;
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
      category: defaultCat,
    );
    _openTaskDetail(newTask);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final stats = ref.watch(plannerStatsProvider);
    final sortedTasks = ref.watch(sortedTasksProvider);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: context.typography.bodyMedium.copyWith(
                  color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                ),
                decoration: const InputDecoration(
                  hintText: 'Search tasks, subtasks, notes, tags...',
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  ref.read(taskSearchQueryProvider.notifier).state = val;
                },
              )
            : Text(
                'Planner 2.0',
                style: context.typography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(taskSearchQueryProvider.notifier).state = '';
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: () => _showCalendar(context),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: WorkspaceAvatar(),
          ),
        ],
      ),
      body: SafeArea(
        child: width >= 1024
            ? _buildDesktopLayout(context, theme, stats, sortedTasks)
            : width >= 600
                ? _buildTabletLayout(context, theme, stats, sortedTasks)
                : _buildPhoneLayout(context, theme, stats, sortedTasks),
      ),
      floatingActionButton: PremiumFAB(
        onPressed: _createNewTask,
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }

  // ─── Top Productivity Dashboard Header ─────────────────────────────────────

  Widget _buildTopProgressCards(BuildContext context, AppThemeData theme, PlannerStatsData stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PremiumCard(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Today Progress', style: context.typography.labelSmall),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(stats.todayCompletionRate * 100).round()}%',
                            style: context.typography.headlineSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primary,
                            ),
                          ),
                          Text('${stats.todayCompleted}/${stats.todayTotal} Done', style: context.typography.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: stats.todayCompletionRate,
                        backgroundColor: theme.outlineVariant.withValues(alpha: 0.3),
                        color: theme.primary,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PremiumCard(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Streak', style: context.typography.labelSmall),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 24),
                          const SizedBox(width: 4),
                          Text(
                            '${stats.currentStreak} Days',
                            style: context.typography.headlineSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Score: ${stats.productivityScore}/100', style: context.typography.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Smart Filters & Categories Bar ────────────────────────────────────────

  Widget _buildFiltersAndCategories(BuildContext context, AppThemeData theme) {
    final activeFilter = ref.watch(taskFilterProvider);
    final activeCategory = ref.watch(taskCategoryFilterProvider);
    final categories = ref.watch(categoriesProvider);

    final filters = [
      {'id': 'today', 'label': 'Today'},
      {'id': 'tomorrow', 'label': 'Tomorrow'},
      {'id': 'upcoming', 'label': 'Upcoming'},
      {'id': 'completed', 'label': 'Completed'},
      {'id': 'archived', 'label': 'Archived'},
      {'id': 'all', 'label': 'All'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Pills Row
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ChoiceChip(
                      label: const Text('All Categories'),
                      selected: activeCategory == null,
                      onSelected: (_) => ref.read(taskCategoryFilterProvider.notifier).state = null,
                    ),
                    const SizedBox(width: 8),
                    ...categories.map((c) {
                      final isSelected = activeCategory == c.name;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          avatar: Icon(c.icon, size: 14, color: isSelected ? Colors.white : c.color),
                          label: Text(c.name),
                          selected: isSelected,
                          selectedColor: theme.primary,
                          onSelected: (_) {
                            ref.read(taskCategoryFilterProvider.notifier).state = isSelected ? null : c.name;
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.settings_rounded, size: 20, color: theme.secondary),
              tooltip: 'Manage Categories',
              onPressed: () => _showManageCategoriesSheet(context),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Smart Filter Chips
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: filters.length,
            itemBuilder: (context, idx) {
              final f = filters[idx];
              final isSelected = activeFilter == f['id'];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(f['label']!),
                  selected: isSelected,
                  selectedColor: theme.primary.withValues(alpha: 0.2),
                  checkmarkColor: theme.primary,
                  onSelected: (_) {
                    ref.read(taskFilterProvider.notifier).state = f['id']!;
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Quick Add Input Bar ───────────────────────────────────────────────────

  Widget _buildQuickAddBar(BuildContext context, AppThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.add_task_rounded, color: theme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _quickAddController,
              decoration: const InputDecoration(
                hintText: 'Quick Add Task (e.g. Buy groceries tomorrow)...',
                border: InputBorder.none,
              ),
              onSubmitted: (val) {
                ref.read(tasksNotifierProvider.notifier).quickAddTask(val);
                _quickAddController.clear();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_upward_rounded, color: theme.primary),
            onPressed: () {
              ref.read(tasksNotifierProvider.notifier).quickAddTask(_quickAddController.text);
              _quickAddController.clear();
            },
          ),
        ],
      ),
    );
  }

  // ─── Phone Single Column Layout ─────────────────────────────────────────────

  Widget _buildPhoneLayout(
    BuildContext context,
    AppThemeData theme,
    PlannerStatsData stats,
    List<TaskEntity> sortedTasks,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildTopProgressCards(context, theme, stats),
        const SizedBox(height: 16),
        _buildFiltersAndCategories(context, theme),
        const SizedBox(height: 16),
        _buildQuickAddBar(context, theme),
        const SizedBox(height: 16),

        if (sortedTasks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 48, color: theme.outline),
                  const SizedBox(height: 12),
                  Text('All clear! No tasks match your filter.', style: context.typography.bodyMedium),
                ],
              ),
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedTasks.length,
            onReorderItem: (oldIdx, newIdx) {
              ref.read(tasksNotifierProvider.notifier).reorderTasks(oldIdx, newIdx);
            },
            itemBuilder: (context, idx) {
              final task = sortedTasks[idx];
              return KeyedSubtree(
                key: ValueKey(task.id),
                child: TaskCard(
                  task: task,
                  onToggle: () => ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(task.id),
                  onDelete: () => ref.read(tasksNotifierProvider.notifier).deleteTask(task.id),
                  isSelected: false,
                  isSelectionMode: false,
                  onTapSelection: () {},
                  onLongPress: () {},
                  onTapDetail: () => _openTaskDetail(task),
                ),
              );
            },
          ),
      ],
    );
  }

  // ─── Tablet 2-Column Layout ────────────────────────────────────────────────

  Widget _buildTabletLayout(
    BuildContext context,
    AppThemeData theme,
    PlannerStatsData stats,
    List<TaskEntity> sortedTasks,
  ) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildTopProgressCards(context, theme, stats),
        const SizedBox(height: 20),
        _buildFiltersAndCategories(context, theme),
        const SizedBox(height: 20),
        _buildQuickAddBar(context, theme),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 2.2,
          ),
          itemCount: sortedTasks.length,
          itemBuilder: (context, idx) {
            final task = sortedTasks[idx];
            return TaskCard(
              task: task,
              onToggle: () => ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(task.id),
              onDelete: () => ref.read(tasksNotifierProvider.notifier).deleteTask(task.id),
              isSelected: false,
              isSelectionMode: false,
              onTapSelection: () {},
              onLongPress: () {},
              onTapDetail: () => _openTaskDetail(task),
            );
          },
        ),
      ],
    );
  }

  // ─── Desktop Adaptive Layout ───────────────────────────────────────────────

  Widget _buildDesktopLayout(
    BuildContext context,
    AppThemeData theme,
    PlannerStatsData stats,
    List<TaskEntity> sortedTasks,
  ) {
    return Row(
      children: [
        // Sidebar Filters & Categories
        Container(
          width: 280,
          color: theme.surface,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Smart Filters', style: context.typography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildFiltersAndCategories(context, theme),
            ],
          ),
        ),
        VerticalDivider(width: 1, color: theme.outlineVariant),
        // Main Task List
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildTopProgressCards(context, theme, stats),
                const SizedBox(height: 16),
                _buildQuickAddBar(context, theme),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedTasks.length,
                    itemBuilder: (context, idx) {
                      final task = sortedTasks[idx];
                      return TaskCard(
                        task: task,
                        onToggle: () => ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(task.id),
                        onDelete: () => ref.read(tasksNotifierProvider.notifier).deleteTask(task.id),
                        isSelected: false,
                        isSelectionMode: false,
                        onTapSelection: () {},
                        onLongPress: () {},
                        onTapDetail: () => _openTaskDetail(task),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showManageCategoriesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final theme = context.appTheme;
            final categories = ref.watch(categoriesProvider);
            final notifier = ref.read(categoriesProvider.notifier);
            final defaultId = notifier.defaultCategoryId;

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 24),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Manage Categories',
                        style: context.typography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        color: theme.primary,
                        onPressed: () => _showAddEditCategoryDialog(context, null),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ReorderableListView.builder(
                      itemCount: categories.length,
                      onReorderItem: (oldIdx, newIdx) {
                        notifier.reorderCategories(oldIdx, newIdx);
                      },
                      itemBuilder: (context, idx) {
                        final c = categories[idx];
                        final isDefault = c.id == defaultId;
                        return ListTile(
                          key: ValueKey(c.id),
                          leading: Icon(c.icon, color: c.color),
                          title: Row(
                            children: [
                              Text(c.name, style: context.typography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                              if (isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.success.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Default',
                                    style: TextStyle(color: theme.success, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(isDefault ? Icons.star_rounded : Icons.star_border_rounded),
                                color: isDefault ? Colors.amber : theme.outline,
                                onPressed: () => notifier.setDefaultCategoryId(c.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_rounded, size: 20),
                                onPressed: () => _showAddEditCategoryDialog(context, c),
                              ),
                              if (c.id != 'Personal')
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                                  color: theme.error,
                                  onPressed: () => notifier.deleteCategory(c.id),
                                ),
                              const Icon(Icons.drag_handle_rounded),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddEditCategoryDialog(BuildContext context, PlannerCategory? existing) {
    final isEdit = existing != null;
    final nameController = TextEditingController(text: existing?.name ?? '');
    Color selectedColor = existing?.color ?? Colors.blue;
    IconData selectedIcon = existing?.icon ?? Icons.category_rounded;

    final availableColors = [
      Colors.blue, Colors.purple, Colors.orange, Colors.red, Colors.green,
      Colors.teal, Colors.pink, Colors.amber, Colors.cyan, Colors.indigo,
      Colors.brown, Colors.grey,
    ];

    final availableIcons = [
      Icons.work_rounded, Icons.person_rounded, Icons.school_rounded,
      Icons.favorite_rounded, Icons.shopping_cart_rounded, Icons.account_balance_wallet_rounded,
      Icons.fitness_center_rounded, Icons.home_rounded, Icons.book_rounded,
      Icons.brush_rounded, Icons.local_cafe_rounded, Icons.flight_rounded,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final theme = context.appTheme;
            return AlertDialog(
              backgroundColor: theme.surface,
              title: Text(isEdit ? 'Edit Category' : 'Add Category', style: context.typography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Category Name',
                        hintText: 'e.g. Health & Fitness',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Select Color', style: context.typography.labelSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableColors.map((color) {
                        final isSelected = color == selectedColor;
                        return GestureDetector(
                          onTap: () => setDialogState(() => selectedColor = color),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: theme.primary, width: 3)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text('Select Icon', style: context.typography.labelSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableIcons.map((icon) {
                        final isSelected = icon.codePoint == selectedIcon.codePoint;
                        return GestureDetector(
                          onTap: () => setDialogState(() => selectedIcon = icon),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isSelected ? theme.primary.withValues(alpha: 0.15) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? theme.primary : theme.outlineVariant,
                              ),
                            ),
                            child: Icon(icon, color: isSelected ? theme.primary : theme.secondary, size: 20),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    final notifier = ref.read(categoriesProvider.notifier);
                    if (isEdit) {
                      notifier.updateCategory(existing.id, name, selectedIcon, selectedColor);
                    } else {
                      notifier.addCategory(name, selectedIcon, selectedColor);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
