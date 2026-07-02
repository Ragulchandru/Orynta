import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../focus/presentation/providers/focus_notifier.dart';
import '../providers/analytics_provider.dart';
import '../widgets/achievements_card.dart';
import '../widgets/focus_chart.dart';
import '../widgets/habit_heatmap.dart';
import '../widgets/insights_card.dart';
import '../widgets/monthly_chart.dart';
import '../widgets/note_activity_chart.dart';
import '../widgets/productivity_breakdown.dart';
import '../widgets/productivity_score_card.dart';
import '../widgets/task_completion_chart.dart';
import '../widgets/weekly_chart.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _selectedSegment = 0; // 0 = Weekly, 1 = Monthly

  @override
  Widget build(BuildContext context) {
    // Watch providers
    final todayScore = ref.watch(productivityScoreProvider);
    final todayStats = ref.watch(todayStatsProvider);
    final weekly = ref.watch(weeklyStatsProvider);
    final monthly = ref.watch(monthlyStatsProvider);
    final focus = ref.watch(focusNotifierProvider);
    final achievements = ref.watch(achievementsProvider);
    final insights = ref.watch(productivityInsightsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Insights & Analytics',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.md,
          ),
          children: [
            // 1. Productivity Score Gauges
            ProductivityScoreCard(score: todayScore),
            const SizedBox(height: AppSizes.md),

            // 2. Score breakdown progress contributors
            ProductivityBreakdown(stats: todayStats),
            const SizedBox(height: AppSizes.lg),

            // 3. Choice Segmented Control Chips
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(
                        value: 0,
                        label: Text('Weekly Stats'),
                        icon: Icon(Icons.calendar_view_week_rounded),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text('Monthly Stats'),
                        icon: Icon(Icons.calendar_view_month_rounded),
                      ),
                    ],
                    selected: {_selectedSegment},
                    onSelectionChanged: (val) {
                      setState(() {
                        _selectedSegment = val.first;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),

            // 4. Dynamic Charts display based on selected segment
            if (_selectedSegment == 0) ...[
              WeeklyChart(weeklyStats: weekly),
              const SizedBox(height: AppSizes.md),
              NoteActivityChart(weeklyStats: weekly),
              const SizedBox(height: AppSizes.md),
              FocusChart(focusSessions: focus),
              const SizedBox(height: AppSizes.md),
              TaskCompletionChart(
                completedCount: todayStats.tasksCompleted,
                pendingCount: todayStats.tasksPending,
              ),
            ] else ...[
              MonthlyChart(monthlyStats: monthly),
              const SizedBox(height: AppSizes.md),
              HabitHeatmap(monthlyStats: monthly),
            ],
            const SizedBox(height: AppSizes.lg),

            // 5. Dynamic text Insights
            InsightsCard(insights: insights),
            const SizedBox(height: AppSizes.md),

            // 6. Achievements Lock grids
            AchievementsCard(achievements: achievements),
            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }
}
