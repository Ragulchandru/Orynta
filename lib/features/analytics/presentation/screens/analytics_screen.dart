// lib/features/analytics/presentation/screens/analytics_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
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
import '../widgets/analytics_intelligence_card.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  void _exportReport(BuildContext context) {
    final score = ref.read(todayStatsProvider);
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

  Widget getComparisonWidget(double current, double prev, ColorScheme colorScheme) {
    if (prev == 0) {
      return Text(
        current > 0 ? '↑100%' : 'No Change',
        style: TextStyle(
          color: current > 0 ? Colors.green : colorScheme.outline,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    final diff = ((current - prev) / prev) * 100;
    final isPositive = diff > 0;
    final isNegative = diff < 0;
    final color = isPositive ? Colors.green : (isNegative ? Colors.red : colorScheme.outline);
    final prefix = isPositive ? '↑' : (isNegative ? '↓' : '');

    return Text(
      '$prefix${diff.abs().round()}%',
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
    );
  }

  String getScoreLabel(double score) {
    if (score >= 90) return 'Excellent';
    if (score >= 70) return 'Great';
    if (score >= 50) return 'Good';
    if (score > 0) return 'Fair';
    return 'No Data';
  }

  Color getScoreColor(double score, AppThemeData theme) {
    if (score >= 90) return theme.success;
    if (score >= 70) return Colors.green;
    if (score >= 50) return Colors.orange;
    return theme.secondary;
  }

  Widget _buildSummaryCards(BuildContext context, WidgetRef ref, bool isNarrow) {
    final theme = context.appTheme;
    final colors = context.colors;
    final metrics = ref.watch(periodMetricsProvider);

    Widget buildCard(String title, String value, Widget comparison, IconData icon, Color color) {
      return Card(
        color: colors.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: context.typography.labelMedium.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(icon, size: 16, color: color),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: context.typography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              comparison,
            ],
          ),
        ),
      );
    }

    if (isNarrow) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: buildCard(
                  'Created',
                  '${metrics.created}',
                  getComparisonWidget(metrics.created.toDouble(), metrics.prevCreated.toDouble(), Theme.of(context).colorScheme),
                  Icons.add_circle_outline_rounded,
                  colors.primary,
                ),
              ),
              Expanded(
                child: buildCard(
                  'Completed',
                  '${metrics.completed}',
                  getComparisonWidget(metrics.completed.toDouble(), metrics.prevCompleted.toDouble(), Theme.of(context).colorScheme),
                  Icons.check_circle_outline_rounded,
                  theme.success,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: buildCard(
                  'Completion',
                  '${metrics.completionRate.toInt()}%',
                  getComparisonWidget(metrics.completionRate, metrics.prevCompletionRate, Theme.of(context).colorScheme),
                  Icons.percent_rounded,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: buildCard(
                  'Avg Score',
                  '${metrics.avgProductivityScore.toInt()}',
                  Text(
                    getScoreLabel(metrics.avgProductivityScore),
                    style: TextStyle(
                      color: getScoreColor(metrics.avgProductivityScore, theme),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icons.stars_rounded,
                  Colors.teal,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: buildCard(
              'Created',
              '${metrics.created}',
              getComparisonWidget(metrics.created.toDouble(), metrics.prevCreated.toDouble(), Theme.of(context).colorScheme),
              Icons.add_circle_outline_rounded,
              colors.primary,
            ),
          ),
          Expanded(
            child: buildCard(
              'Completed',
              '${metrics.completed}',
              getComparisonWidget(metrics.completed.toDouble(), metrics.prevCompleted.toDouble(), Theme.of(context).colorScheme),
              Icons.check_circle_outline_rounded,
              theme.success,
            ),
          ),
          Expanded(
            child: buildCard(
              'Completion Rate',
              '${metrics.completionRate.toInt()}%',
              getComparisonWidget(metrics.completionRate, metrics.prevCompletionRate, Theme.of(context).colorScheme),
              Icons.percent_rounded,
              Colors.orange,
            ),
          ),
          Expanded(
            child: buildCard(
              'Avg Score',
              '${metrics.avgProductivityScore.toInt()}',
              Text(
                getScoreLabel(metrics.avgProductivityScore),
                style: TextStyle(
                  color: getScoreColor(metrics.avgProductivityScore, theme),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icons.stars_rounded,
              Colors.teal,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildBestWorstDays(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final colors = context.colors;
    final perf = ref.watch(performanceDaysProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Highs & Lows',
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // 🏆 Highest Productivity Card
            Expanded(
              child: Card(
                color: colors.surfaceContainerLow,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Highest Productivity',
                              style: context.typography.labelSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        perf.best.dayName,
                        style: context.typography.titleLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${perf.best.completedCount} completed',
                        style: context.typography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${(perf.best.completionRate * 100).toStringAsFixed(0)}% completion rate',
                        style: context.typography.labelSmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // ⚠️ Needs Improvement Card
            Expanded(
              child: Card(
                color: colors.surfaceContainerLow,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('⚠️', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Needs Improvement',
                              style: context.typography.labelSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        perf.worst.dayName,
                        style: context.typography.titleLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${perf.worst.completedCount} completed',
                        style: context.typography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.error,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${(perf.worst.completionRate * 100).toStringAsFixed(0)}% completion rate',
                        style: context.typography.labelSmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
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

  Widget _buildHourlyTimeline(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final hourly = ref.watch(timelineHourlyProductivityProvider);

    var maxCount = -1;
    var maxLabel = '6 AM';
    var minCount = 999999;
    var minLabel = '6 AM';

    for (final h in hourly) {
      if (h.count > maxCount) {
        maxCount = h.count;
        maxLabel = h.label;
      }
      if (h.count < minCount) {
        minCount = h.count;
        minLabel = h.label;
      }
    }

    if (maxCount <= 0) {
      maxCount = 0;
      maxLabel = '--';
      minLabel = '--';
    }

    final peakRating = maxCount >= 10 ? 'Outstanding' : (maxCount >= 5 ? 'Excellent' : (maxCount > 0 ? 'Good' : 'No Data'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Peak Focus Large Card
        Card(
          color: colors.surfaceContainerLow,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Peak Focus',
                      style: context.typography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textSecondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        peakRating,
                        style: context.typography.labelSmall.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  maxLabel,
                  style: context.typography.displayMedium.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colors.outlineVariant.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: maxCount > 0 ? (maxCount / (maxCount + 5)).clamp(0.1, 1.0) : 0.0,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [colors.primary, colors.secondary],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 2. Hourly Timeline Card with animated vertical bars
        Card(
          color: colors.surfaceContainerLow,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Productivity Timeline',
                  style: context.typography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: hourly.map((h) {
                    final overallMax = hourly.map((item) => item.count).reduce((a, b) => a > b ? a : b);
                    const double maxHeight = 80.0;
                    final double height = overallMax > 0 ? (h.count / overallMax) * maxHeight : 4.0;
                    final isPeak = h.label == maxLabel;

                    return Expanded(
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutBack,
                            width: 14,
                            height: height.clamp(4.0, maxHeight),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: isPeak
                                    ? [colors.primary, colors.secondary]
                                    : [colors.primary.withValues(alpha: 0.3), colors.primary.withValues(alpha: 0.5)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            h.label,
                            style: context.typography.labelSmall.copyWith(
                              fontSize: 9,
                              fontWeight: isPeak ? FontWeight.bold : FontWeight.normal,
                              color: isPeak ? colors.textPrimary : colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 3. Focus Insights cards
        Row(
          children: [
            Expanded(
              child: Card(
                color: colors.surfaceContainerLow,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Peak Productivity',
                        style: context.typography.labelSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        maxLabel,
                        style: context.typography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: i < (maxCount > 0 ? (maxCount >= 5 ? 5 : 4) : 0) ? Colors.amber : colors.outlineVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                color: colors.surfaceContainerLow,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lowest Activity',
                        style: context.typography.labelSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        minLabel,
                        style: context.typography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        maxCount > 0 ? 'Good time for planning' : 'No data logged yet',
                        style: context.typography.bodySmall.copyWith(
                          color: colors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final activeRange = ref.watch(insightsTimeRangeProvider);

    final score = ref.watch(todayStatsProvider);
    final focus = ref.watch(focusAnalyticsProvider);
    final stats = ref.watch(plannerStatsProvider);
    final metrics = ref.watch(periodMetricsProvider);
    final notes = ref.watch(notesProvider).value ?? [];
    final timelineEvents = ref.watch(activityTimelineProvider);
    final monthly = ref.watch(monthlyStatsProvider);
    final achievements = ref.watch(achievementsProvider);
    final tasks = ref.watch(tasksProvider);
    final perf = ref.watch(performanceDaysProvider);


    final activeNotesCount = notes.where((n) => n.status == NoteStatus.active).length;
    final favNotesCount = notes.where((n) => n.isFavorite).length;
    final archivedNotesCount = notes.where((n) => n.status == NoteStatus.archived).length;

    final overdueTasksCount = tasks.where((t) {
      if (t.isCompleted || t.isArchived || t.dueDate == null) return false;
      final startOfToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      return t.dueDate!.isBefore(startOfToday);
    }).length;

    final recurringTasksCount = tasks.where((t) => t.recurrenceRule != null && t.recurrenceRule!.isNotEmpty).length;

    final Map<String, int> priorityCounts = {'high': 0, 'medium': 0, 'low': 0};
    for (final t in tasks) {
      final p = t.priority.toLowerCase();
      priorityCounts[p] = (priorityCounts[p] ?? 0) + 1;
    }

    final double width = MediaQuery.of(context).size.width;

    Widget buildDashboardContent() {
      if (width >= 1024) {
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
                    child: _buildSummaryCards(context, ref, false),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 1,
                    child: ProductivityScoreCard(score: score.productivityScore),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 1,
                    child: AnalyticsIntelligenceCard(
                      created: metrics.created,
                      completed: metrics.completed,
                      prevCreated: metrics.prevCreated,
                      prevCompleted: metrics.prevCompleted,
                      completionRate: metrics.completionRate,
                      prevCompletionRate: metrics.prevCompletionRate,
                      longestStreak: stats.longestStreak,
                      totalFocusMinutes: focus.totalFocusMinutes,
                      range: activeRange,
                      bestDay: perf.best.dayName,
                      worstDay: perf.worst.dayName,
                    ),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 2,
                    child: _buildBestWorstDays(context, ref),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 3,
                    child: _buildHourlyTimeline(context, ref),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 4,
                    child: HeatmapCalendar(monthlyStats: monthly),
                  ),
                  const SizedBox(height: 28),
                  const StaggeredEntrance(
                    index: 5,
                    child: WeeklyLineChart(),
                  ),
                  const SizedBox(height: 28),
                  const StaggeredEntrance(
                    index: 6,
                    child: TaskCompletionOverviewCard(),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 7,
                    child: Row(
                      children: [
                        Expanded(child: CategoryPieChart(tasks: tasks)),
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
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 2,
                    child: NotesAnalyticsCard(
                      totalNotes: activeNotesCount,
                      favoriteNotes: favNotesCount,
                      archivedNotes: archivedNotesCount,
                      notesCreatedToday: score.notesCreated,
                    ),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 3,
                    child: PlannerAnalyticsCard(
                      stats: stats,
                      overdueTasksCount: overdueTasksCount,
                      recurringTasksCount: recurringTasksCount,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const StaggeredEntrance(
                    index: 4,
                    child: GoalsCard(),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 5,
                    child: AchievementsCard(achievements: achievements),
                  ),
                  const SizedBox(height: 28),
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
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  StaggeredEntrance(
                    index: 0,
                    child: _buildSummaryCards(context, ref, false),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 1,
                    child: ProductivityScoreCard(score: score.productivityScore),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 1,
                    child: AnalyticsIntelligenceCard(
                      created: metrics.created,
                      completed: metrics.completed,
                      prevCreated: metrics.prevCreated,
                      prevCompleted: metrics.prevCompleted,
                      completionRate: metrics.completionRate,
                      prevCompletionRate: metrics.prevCompletionRate,
                      longestStreak: stats.longestStreak,
                      totalFocusMinutes: focus.totalFocusMinutes,
                      range: activeRange,
                      bestDay: perf.best.dayName,
                      worstDay: perf.worst.dayName,
                    ),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 2,
                    child: _buildBestWorstDays(context, ref),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 3,
                    child: _buildHourlyTimeline(context, ref),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 4,
                    child: HeatmapCalendar(monthlyStats: monthly),
                  ),
                  const SizedBox(height: 28),
                  const StaggeredEntrance(
                    index: 5,
                    child: WeeklyLineChart(),
                  ),
                  const SizedBox(height: 28),
                  const StaggeredEntrance(
                    index: 6,
                    child: TaskCompletionOverviewCard(),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 7,
                    child: CategoryPieChart(tasks: tasks),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 8,
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
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 2,
                    child: NotesAnalyticsCard(
                      totalNotes: activeNotesCount,
                      favoriteNotes: favNotesCount,
                      archivedNotes: archivedNotesCount,
                      notesCreatedToday: score.notesCreated,
                    ),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 3,
                    child: PlannerAnalyticsCard(
                      stats: stats,
                      overdueTasksCount: overdueTasksCount,
                      recurringTasksCount: recurringTasksCount,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const StaggeredEntrance(
                    index: 4,
                    child: GoalsCard(),
                  ),
                  const SizedBox(height: 28),
                  StaggeredEntrance(
                    index: 5,
                    child: AchievementsCard(achievements: achievements),
                  ),
                  const SizedBox(height: 28),
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
        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            StaggeredEntrance(
              index: 0,
              child: _buildSummaryCards(context, ref, true),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 1,
              child: ProductivityScoreCard(score: score.productivityScore),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 1,
              child: AnalyticsIntelligenceCard(
                created: metrics.created,
                completed: metrics.completed,
                prevCreated: metrics.prevCreated,
                prevCompleted: metrics.prevCompleted,
                completionRate: metrics.completionRate,
                prevCompletionRate: metrics.prevCompletionRate,
                longestStreak: stats.longestStreak,
                totalFocusMinutes: focus.totalFocusMinutes,
                range: activeRange,
                bestDay: perf.best.dayName,
                worstDay: perf.worst.dayName,
              ),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 2,
              child: _buildBestWorstDays(context, ref),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 3,
              child: _buildHourlyTimeline(context, ref),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 4,
              child: HeatmapCalendar(monthlyStats: monthly),
            ),
            const SizedBox(height: 28),
            const StaggeredEntrance(
              index: 5,
              child: WeeklyLineChart(),
            ),
            const SizedBox(height: 28),
            const StaggeredEntrance(
              index: 6,
              child: TaskCompletionOverviewCard(),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 7,
              child: CategoryPieChart(tasks: tasks),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 8,
              child: PriorityBarChart(priorityCounts: priorityCounts),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 9,
              child: FocusAnalyticsCard(data: focus),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 10,
              child: NotesAnalyticsCard(
                totalNotes: activeNotesCount,
                favoriteNotes: favNotesCount,
                archivedNotes: archivedNotesCount,
                notesCreatedToday: score.notesCreated,
              ),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 11,
              child: PlannerAnalyticsCard(
                stats: stats,
                overdueTasksCount: overdueTasksCount,
                recurringTasksCount: recurringTasksCount,
              ),
            ),
            const SizedBox(height: 28),
            const StaggeredEntrance(
              index: 12,
              child: GoalsCard(),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 13,
              child: AchievementsCard(achievements: achievements),
            ),
            const SizedBox(height: 28),
            StaggeredEntrance(
              index: 14,
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
