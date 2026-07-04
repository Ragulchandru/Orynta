// lib/features/dashboard/presentation/pages/dashboard_page.dart
//
// Orynta 2.0 — Redesigned Dashboard Page

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../workspace/presentation/widgets/workspace_avatar.dart';
import '../../../../core/design_system/design_tokens.dart';

import '../../../planner/domain/entities/task_entity.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../planner/presentation/providers/planner_stats_provider.dart';
import '../../../analytics/presentation/providers/productivity_score_provider.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/dashboard_error_view.dart';
import '../widgets/dashboard_loading_view.dart';
import '../widgets/hero/hero_section.dart';
import '../widgets/quick_actions/quick_actions_section.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    final notifier = ref.read(dashboardControllerProvider.notifier);
    final theme = context.appTheme;

    final tasks = ref.watch(tasksProvider);
    final stats = ref.watch(plannerStatsProvider);
    final scoreData = ref.watch(unifiedScoreProvider);

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => notifier.refresh(),
          color: theme.primary,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: context.spacing.paddingScreen,
                sliver: const SliverToBoxAdapter(
                  child: PremiumHeader(
                    title: 'Dashboard',
                    subtitle: 'Your personal productivity hub',
                    actions: [WorkspaceAvatar()],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              if (state.isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: DashboardLoadingView(),
                )
              else if (state.hasError)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: DashboardErrorView(
                    errorMessage: state.errorMessage,
                    onRetry: () => notifier.loadModules(),
                  ),
                )
              else
                SliverPadding(
                  padding: context.spacing.paddingHorizontalLg,
                  sliver: SliverToBoxAdapter(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 800;
                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    const HeroSection(),
                                    const SizedBox(height: 16),
                                    _buildTodaysMission(context, tasks),
                                    const SizedBox(height: 16),
                                    _buildNextReminder(context, tasks),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: [
                                    _buildTodayAtAGlance(context, scoreData, stats),
                                    const SizedBox(height: 20),
                                    const QuickActionsSection(),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              const HeroSection(),
                              const SizedBox(height: 16),
                              _buildTodaysMission(context, tasks),
                              const SizedBox(height: 16),
                              _buildNextReminder(context, tasks),
                              const SizedBox(height: 16),
                              _buildTodayAtAGlance(context, scoreData, stats),
                              const SizedBox(height: 20),
                              const QuickActionsSection(),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysMission(BuildContext context, List<TaskEntity> tasks) {
    final theme = context.appTheme;
    final colors = context.colors;

    final todaysPendingTasks = tasks.where((t) {
      if (t.isCompleted || t.dueDate == null) return false;
      return _isToday(t.dueDate!);
    }).toList();

    int priorityWeight(String p) {
      switch (p.toLowerCase()) {
        case 'high':   return 3;
        case 'medium': return 2;
        case 'low':    return 1;
        default:       return 0;
      }
    }
    todaysPendingTasks.sort((a, b) => priorityWeight(b.priority).compareTo(priorityWeight(a.priority)));

    final hasMission = todaysPendingTasks.isNotEmpty;

    return Card(
      margin: EdgeInsets.zero,
      color: theme.notes.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: theme.notes.cardBorder, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🎯', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  "Today's Mission",
                  style: context.typography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasMission) ...[
              Builder(
                builder: (context) {
                  final mission = todaysPendingTasks.first;
                  int percent = 0;
                  if (mission.subtasks.isNotEmpty) {
                    final completed = mission.subtasks.where((s) => s.isCompleted).length;
                    percent = (completed / mission.subtasks.length * 100).round();
                  }
                  final hasSubtasks = mission.subtasks.isNotEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              mission.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.typography.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          if (hasSubtasks)
                            Text(
                              '$percent%',
                              style: context.typography.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.primary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (hasSubtasks) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percent / 100.0,
                            backgroundColor: theme.outlineVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: colors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            mission.dueTimeMs != null
                                ? 'Due Today • ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(mission.dueTimeMs!))}'
                                : 'Due Today',
                            style: context.typography.bodySmall.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ] else ...[
              Text(
                'No mission today.',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Create a task to stay productive.',
                style: context.typography.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNextReminder(BuildContext context, List<TaskEntity> tasks) {
    final theme = context.appTheme;
    final colors = context.colors;
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    final upcomingReminders = tasks.where((t) {
      final reminderMs = t.reminderMs;
      if (t.isCompleted || reminderMs == null) return false;
      if (reminderMs < nowMs) return false;
      return _isToday(DateTime.fromMillisecondsSinceEpoch(reminderMs));
    }).toList()
      ..sort((a, b) => (a.reminderMs ?? 0).compareTo(b.reminderMs ?? 0));

    final hasReminder = upcomingReminders.isNotEmpty;

    return Card(
      margin: EdgeInsets.zero,
      color: theme.notes.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: theme.notes.cardBorder, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🔔', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  'Next Reminder',
                  style: context.typography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasReminder) ...[
              Builder(
                builder: (context) {
                  final task = upcomingReminders.first;
                  final remainingMs = (task.reminderMs ?? 0) - nowMs;
                  final remaining = Duration(milliseconds: remainingMs);
                  final hours = remaining.inHours;
                  final minutes = remaining.inMinutes % 60;
                  final timeStr = DateFormat('h:mm a')
                      .format(DateTime.fromMillisecondsSinceEpoch(task.reminderMs ?? 0));
                  final remainingStr = hours > 0
                      ? '${hours}h ${minutes}m remaining'
                      : '${minutes}m remaining';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.typography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today • $timeStr',
                            style: context.typography.bodySmall.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            remainingStr,
                            style: context.typography.bodySmall.copyWith(
                              color: theme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ] else ...[
              Text(
                'No reminders scheduled today.',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "You're all caught up.",
                style: context.typography.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTodayAtAGlance(
    BuildContext context,
    ProductivityScoreData scoreData,
    PlannerStatsData stats,
  ) {
    final theme = context.appTheme;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Today at a Glance',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.1,
          children: [
            _GlanceCard(
              title: 'Tasks',
              value: scoreData.tasksCompletedToday,
              icon: Icons.check_circle_outline_rounded,
              color: theme.primary,
            ),
            _GlanceCard(
              title: 'Notes',
              value: scoreData.notesCreatedToday,
              icon: Icons.article_outlined,
              color: Colors.blue,
            ),
            _GlanceCard(
              title: 'Streak',
              value: stats.currentStreak,
              icon: Icons.local_fire_department_rounded,
              color: Colors.orange,
            ),
            _GlanceCard(
              title: 'Score',
              value: scoreData.score,
              icon: Icons.speed_rounded,
              color: Colors.teal,
            ),
          ],
        ),
      ],
    );
  }
}

class _GlanceCard extends StatelessWidget {
  const _GlanceCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final num value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = context.colors;

    return Card(
      margin: EdgeInsets.zero,
      color: theme.notes.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: theme.notes.cardBorder, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: value.toDouble()),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutCubic,
                    builder: (context, val, _) {
                      return Text(
                        '${val.toInt()}',
                        style: context.typography.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.labelSmall.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
