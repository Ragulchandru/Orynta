// lib/features/analytics/presentation/screens/analytics_screen.dart
//
// Orynta 2.0 — Premium Insights & Productivity Dashboard 2.0 (Global Filter & Motion Integrated)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../../../../shared/widgets/staggered_entrance.dart';
import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../planner/presentation/providers/planner_stats_provider.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../notes/domain/entities/note_status.dart';
import '../../domain/services/report_exporter.dart';
import '../providers/activity_timeline_provider.dart';
import '../providers/analytics_provider.dart';
import '../providers/focus_analytics_provider.dart';
import '../providers/insights_time_filter_provider.dart';
import '../providers/productivity_score_provider.dart';
import '../widgets/achievements_card.dart';
import '../widgets/activity_timeline_widget.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/focus_analytics_card.dart';
import '../widgets/goals_card.dart';
import '../widgets/heatmap_calendar.dart';
import '../widgets/notes_analytics_card.dart';
import '../widgets/planner_analytics_card.dart';
import '../widgets/priority_bar_chart.dart';
import '../widgets/productivity_score_card.dart';
import '../widgets/task_completion_overview_card.dart';
import '../widgets/weekly_line_chart.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  void _exportReport(BuildContext context) {
    final score = ref.read(unifiedScoreProvider);
    final focus = ref.read(focusAnalyticsProvider);
    final stats = ref.read(plannerStatsProvider);
    final notes = ref.read(notesProvider).value ?? [];
    final activeNotes = notes.where((n) => n.status == NoteStatus.active).length;
    final favNotes = notes.where((n) => n.isFavorite).length;
    final archNotes = notes.where((n) => n.status == NoteStatus.archived).length;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.appTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Export Professional Report',
                  style: context.typography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
                title: const Text('Export Plain PDF Format'),
                subtitle: const Text('Generates printer-ready clean layout'),
                onTap: () async {
                  final content = ReportExporter.generatePDFPlainReport(
                    scoreData: score,
                    focusData: focus,
                    statsData: stats,
                    totalNotes: activeNotes,
                    favoriteNotes: favNotes,
                    archivedNotes: archNotes,
                  );
                  await ReportExporter.copyToClipboard(content);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PDF layout copied to clipboard! Ready to print/save.')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart_rounded, color: Colors.green),
                title: const Text('Export CSV Spreadsheet'),
                subtitle: const Text('Perfect for importing to Excel or Google Sheets'),
                onTap: () async {
                  final content = ReportExporter.generateCSVReport(
                    scoreData: score,
                    focusData: focus,
                    statsData: stats,
                    totalNotes: activeNotes,
                  );
                  await ReportExporter.copyToClipboard(content);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('CSV report copied to clipboard!')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.text_snippet_rounded, color: Colors.blueAccent),
                title: const Text('Export Markdown'),
                subtitle: const Text('Compatible with Notion, Obsidian, and GitHub'),
                onTap: () async {
                  final content = ReportExporter.generateMarkdownReport(
                    scoreData: score,
                    focusData: focus,
                    statsData: stats,
                    totalNotes: activeNotes,
                    favoriteNotes: favNotes,
                    archivedNotes: archNotes,
                  );
                  await ReportExporter.copyToClipboard(content);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Markdown report copied to clipboard!')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final activeRange = ref.watch(insightsTimeRangeProvider);

    final score = ref.watch(unifiedScoreProvider);
    final focus = ref.watch(focusAnalyticsProvider);
    final stats = ref.watch(plannerStatsProvider);
    final notes = ref.watch(notesProvider).value ?? [];
    final timelineEvents = ref.watch(activityTimelineProvider);
    final monthly = ref.watch(monthlyStatsProvider);
    final achievements = ref.watch(achievementsProvider);
    final tasks = ref.watch(tasksProvider);

    final activeNotesCount = notes.where((n) => n.status == NoteStatus.active).length;
    final favNotesCount = notes.where((n) => n.isFavorite).length;
    final archivedNotesCount = notes.where((n) => n.status == NoteStatus.archived).length;

    final overdueTasksCount = tasks.where((t) {
      if (t.isCompleted || t.dueDate == null) return false;
      final startOfToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      return t.dueDate!.isBefore(startOfToday);
    }).length;

    final recurringTasksCount = tasks.where((t) => t.recurrenceRule != null && t.recurrenceRule!.isNotEmpty).length;

    // Category & Priority distribution mapping
    final Map<String, int> categoryCounts = {};
    final Map<String, int> priorityCounts = {'high': 0, 'medium': 0, 'low': 0};
    for (final t in tasks) {
      if (t.category.isNotEmpty) {
        categoryCounts[t.category] = (categoryCounts[t.category] ?? 0) + 1;
      }
      final p = t.priority.toLowerCase();
      priorityCounts[p] = (priorityCounts[p] ?? 0) + 1;
    }

    // Weekly creation vs completion trends dates & counts
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    // Past 7 days (Weekly)
    final List<DateTime> pastWeekDates = List.generate(7, (i) => todayStart.subtract(Duration(days: 6 - i)));
    final List<int> createdWeeklyTrend = List.filled(7, 0);
    final List<int> completedWeeklyTrend = List.filled(7, 0);

    for (int i = 0; i < 7; i++) {
      final date = pastWeekDates[i];
      createdWeeklyTrend[i] = tasks.where((t) {
        return t.createdAt.year == date.year && t.createdAt.month == date.month && t.createdAt.day == date.day;
      }).length;
      completedWeeklyTrend[i] = tasks.where((t) {
        return t.isCompleted &&
            t.updatedAt.year == date.year &&
            t.updatedAt.month == date.month &&
            t.updatedAt.day == date.day;
      }).length;
    }

    // Past 30 days (Monthly)
    final List<DateTime> pastMonthDates = List.generate(30, (i) => todayStart.subtract(Duration(days: 29 - i)));
    final List<int> createdMonthlyTrend = List.filled(30, 0);
    final List<int> completedMonthlyTrend = List.filled(30, 0);

    for (int i = 0; i < 30; i++) {
      final date = pastMonthDates[i];
      createdMonthlyTrend[i] = tasks.where((t) {
        return t.createdAt.year == date.year && t.createdAt.month == date.month && t.createdAt.day == date.day;
      }).length;
      completedMonthlyTrend[i] = tasks.where((t) {
        return t.isCompleted &&
            t.updatedAt.year == date.year &&
            t.updatedAt.month == date.month &&
            t.updatedAt.day == date.day;
      }).length;
    }

    final double width = MediaQuery.of(context).size.width;

    Widget buildDashboardContent() {
      if (width >= 1024) {
        // Desktop 3-Column Adaptive layout grid
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  StaggeredEntrance(
                    index: 0,
                    child: ProductivityScoreCard(score: score.score.toDouble()),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 1,
                    child: HeatmapCalendar(monthlyStats: monthly),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 2,
                    child: WeeklyLineChart(
                      createdTrendWeekly: createdWeeklyTrend,
                      completedTrendWeekly: completedWeeklyTrend,
                      datesWeekly: pastWeekDates,
                      createdTrendMonthly: createdMonthlyTrend,
                      completedTrendMonthly: completedMonthlyTrend,
                      datesMonthly: pastMonthDates,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 3,
                    child: TaskCompletionOverviewCard(
                      completedWeekly: completedWeeklyTrend,
                      datesWeekly: pastWeekDates,
                      completedMonthly: completedMonthlyTrend,
                      datesMonthly: pastMonthDates,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 4,
                    child: Row(
                      children: [
                        Expanded(child: CategoryPieChart(categoryCounts: categoryCounts)),
                        const SizedBox(width: 16),
                        Expanded(child: PriorityBarChart(priorityCounts: priorityCounts)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  StaggeredEntrance(
                    index: 1,
                    child: FocusAnalyticsCard(data: focus),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 2,
                    child: NotesAnalyticsCard(
                      totalNotes: activeNotesCount,
                      favoriteNotes: favNotesCount,
                      archivedNotes: archivedNotesCount,
                      notesCreatedToday: score.notesCreatedToday,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 3,
                    child: PlannerAnalyticsCard(
                      stats: stats,
                      overdueTasksCount: overdueTasksCount,
                      recurringTasksCount: recurringTasksCount,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 4,
                    child: GoalsCard(stats: stats),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 5,
                    child: AchievementsCard(achievements: achievements),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 6,
                    child: ActivityTimelineWidget(events: timelineEvents),
                  ),
                ],
              ),
            ),
          ],
        );
      } else if (width >= 600) {
        // Tablet 2-Column layout grid
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  StaggeredEntrance(
                    index: 0,
                    child: ProductivityScoreCard(score: score.score.toDouble()),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 1,
                    child: HeatmapCalendar(monthlyStats: monthly),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 2,
                    child: WeeklyLineChart(
                      createdTrendWeekly: createdWeeklyTrend,
                      completedTrendWeekly: completedWeeklyTrend,
                      datesWeekly: pastWeekDates,
                      createdTrendMonthly: createdMonthlyTrend,
                      completedTrendMonthly: completedMonthlyTrend,
                      datesMonthly: pastMonthDates,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 3,
                    child: TaskCompletionOverviewCard(
                      completedWeekly: completedWeeklyTrend,
                      datesWeekly: pastWeekDates,
                      completedMonthly: completedMonthlyTrend,
                      datesMonthly: pastMonthDates,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 4,
                    child: CategoryPieChart(categoryCounts: categoryCounts),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 5,
                    child: PriorityBarChart(priorityCounts: priorityCounts),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  StaggeredEntrance(
                    index: 1,
                    child: FocusAnalyticsCard(data: focus),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 2,
                    child: NotesAnalyticsCard(
                      totalNotes: activeNotesCount,
                      favoriteNotes: favNotesCount,
                      archivedNotes: archivedNotesCount,
                      notesCreatedToday: score.notesCreatedToday,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 3,
                    child: PlannerAnalyticsCard(
                      stats: stats,
                      overdueTasksCount: overdueTasksCount,
                      recurringTasksCount: recurringTasksCount,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 4,
                    child: GoalsCard(stats: stats),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 5,
                    child: AchievementsCard(achievements: achievements),
                  ),
                  const SizedBox(height: 16),
                  StaggeredEntrance(
                    index: 6,
                    child: ActivityTimelineWidget(events: timelineEvents),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        // Phone single-column list
        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            StaggeredEntrance(
              index: 0,
              child: ProductivityScoreCard(score: score.score.toDouble()),
            ),
            const SizedBox(height: 16),
            StaggeredEntrance(
              index: 1,
              child: HeatmapCalendar(monthlyStats: monthly),
            ),
            const SizedBox(height: 16),
            StaggeredEntrance(
              index: 2,
              child: WeeklyLineChart(
                createdTrendWeekly: createdWeeklyTrend,
                completedTrendWeekly: completedWeeklyTrend,
                datesWeekly: pastWeekDates,
                createdTrendMonthly: createdMonthlyTrend,
                completedTrendMonthly: completedMonthlyTrend,
                datesMonthly: pastMonthDates,
              ),
            ),
            const SizedBox(height: 16),
            StaggeredEntrance(
              index: 3,
              child: TaskCompletionOverviewCard(
                completedWeekly: completedWeeklyTrend,
                datesWeekly: pastWeekDates,
                completedMonthly: completedMonthlyTrend,
                datesMonthly: pastMonthDates,
              ),
            ),
            const SizedBox(height: 16),
            StaggeredEntrance(
              index: 4,
              child: CategoryPieChart(categoryCounts: categoryCounts),
            ),
            const SizedBox(height: 16),
            StaggeredEntrance(
              index: 5,
              child: PriorityBarChart(priorityCounts: priorityCounts),
            ),
            const SizedBox(height: 16),
            StaggeredEntrance(
              index: 6,
              child: FocusAnalyticsCard(data: focus),
            ),
            const SizedBox(height: 16),
            StaggeredEntrance(
              index: 7,
              child: NotesAnalyticsCard(
                totalNotes: activeNotesCount,
                favoriteNotes: favNotesCount,
                archivedNotes: archivedNotesCount,
                notesCreatedToday: score.notesCreatedToday,
              ),
            ),
            const SizedBox(height: 16),
            StaggeredEntrance(
              index: 8,
              child: PlannerAnalyticsCard(
                stats: stats,
                overdueTasksCount: overdueTasksCount,
                recurringTasksCount: recurringTasksCount,
              ),
            ),
            const SizedBox(height: 16),
            StaggeredEntrance(
              index: 9,
              child: GoalsCard(stats: stats),
            ),
            const SizedBox(height: 16),
            StaggeredEntrance(
              index: 10,
              child: AchievementsCard(achievements: achievements),
            ),
            const SizedBox(height: 16),
            StaggeredEntrance(
              index: 11,
              child: ActivityTimelineWidget(events: timelineEvents),
            ),
          ],
        );
      }
    }

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        elevation: 0,
        title: Text(
          'Insights & Analytics',
          style: context.typography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Export Professional Report',
            onPressed: () => _exportReport(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              // Global Range Filter Bar (Centered & Restricted Width on Tablet/Desktop)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    width: double.infinity,
                    child: SegmentedButton<InsightsTimeRange>(
                      segments: const [
                        ButtonSegment(value: InsightsTimeRange.today, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Today', maxLines: 1))),
                        ButtonSegment(value: InsightsTimeRange.week, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Week', maxLines: 1))),
                        ButtonSegment(value: InsightsTimeRange.month, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Month', maxLines: 1))),
                        ButtonSegment(value: InsightsTimeRange.year, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Year', maxLines: 1))),
                        ButtonSegment(value: InsightsTimeRange.all, label: FittedBox(fit: BoxFit.scaleDown, child: Text('All', maxLines: 1))),
                      ],
                      selected: {activeRange},
                      onSelectionChanged: (val) {
                        ref.read(insightsTimeRangeProvider.notifier).state = val.first;
                      },
                    ),
                  ),
                ),
              ),
              Expanded(child: buildDashboardContent()),
            ],
          ),
        ),
      ),
    );
  }
}
