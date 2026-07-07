import 'package:flutter/material.dart';
import '../../../../core/design_system/design_system.dart';
import '../providers/insights_time_filter_provider.dart';

class AnalyticsIntelligenceCard extends StatelessWidget {
  const AnalyticsIntelligenceCard({
    super.key,
    required this.created,
    required this.completed,
    required this.prevCreated,
    required this.prevCompleted,
    required this.completionRate,
    required this.prevCompletionRate,
    required this.longestStreak,
    required this.totalFocusMinutes,
    required this.range,
    required this.bestDay,
    required this.worstDay,
  });

  final int created;
  final int completed;
  final int prevCreated;
  final int prevCompleted;
  final double completionRate;
  final double prevCompletionRate;
  final int longestStreak;
  final int totalFocusMinutes;
  final InsightsTimeRange range;
  final String bestDay;
  final String worstDay;

  double _getDiffPct(double current, double prev) {
    if (prev == 0) return current > 0 ? 100.0 : 0.0;
    return ((current - prev) / prev) * 100;
  }

  Widget _buildTrendIndicator(BuildContext context, double current, double prev) {
    final theme = context.appTheme;
    final diff = _getDiffPct(current, prev);
    final isPositive = diff > 0;
    final isNegative = diff < 0;
    final color = isPositive ? theme.success : (isNegative ? theme.error : theme.outline);
    final icon = isPositive ? Icons.arrow_upward_rounded : (isNegative ? Icons.arrow_downward_rounded : Icons.horizontal_rule_rounded);
    final prefix = isPositive ? '↑' : (isNegative ? '↓' : '');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 2),
        Text(
          '$prefix${diff.abs().round()}%',
          style: context.typography.labelSmall.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final focusHours = totalFocusMinutes / 60.0;
    final days = switch (range) {
      InsightsTimeRange.today => 1,
      InsightsTimeRange.week => 7,
      InsightsTimeRange.month => 30,
      InsightsTimeRange.year => 365,
      InsightsTimeRange.all => 365,
    };
    final avgDailyTasks = completed / days;

    // Bullet smart summaries generator
    final List<String> summaries = [];
    if (completionRate >= 80) {
      summaries.add('🔥 High Efficiency: Your completion rate is at a premium ${completionRate.toInt()}%. Excellent focus and task completion!');
    } else if (completionRate >= 50) {
      summaries.add('📈 Stable Progress: You are maintaining a steady ${completionRate.toInt()}% completion rate. Keep pushing!');
    } else {
      summaries.add('💡 Focus Tip: Break down your high-priority tasks into smaller subtasks to boost completion rates.');
    }

    if (completed > prevCompleted) {
      summaries.add('🚀 Tasks completed are up by ${_getDiffPct(completed.toDouble(), prevCompleted.toDouble()).abs().round()}% vs last period. You\'re building solid momentum!');
    } else if (completed < prevCompleted && prevCompleted > 0) {
      summaries.add('💤 Task throughput is slightly down by ${_getDiffPct(completed.toDouble(), prevCompleted.toDouble()).abs().round()}% compared to last period. Take time to plan your schedule.');
    } else {
      summaries.add('📊 Activity is stable. Your task completions match last period\'s pace.');
    }

    if (longestStreak > 0) {
      summaries.add('⚡ Streak Legend: Your longest consistency streak is $longestStreak days! Consistency is the secret to mastery.');
    } else {
      summaries.add('🎯 Start your streak today! Complete at least one task or habit daily to build consistency.');
    }

    return Card(
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
              children: [
                const Text('🧠', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  'Analytics Intelligence',
                  style: context.typography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            LayoutBuilder(
              builder: (context, constraints) {
                final double aspect = constraints.maxWidth < 360 ? 1.6 : 2.2;
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: aspect,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    // Longest Streak
                    _buildIntelligenceStat(
                      context,
                      title: 'Longest Streak',
                      value: '$longestStreak d',
                      trailing: const Icon(Icons.local_fire_department_rounded, size: 14, color: Colors.orangeAccent),
                    ),
                    // Focus Hours
                    _buildIntelligenceStat(
                      context,
                      title: 'Focus Hours',
                      value: '${focusHours.toStringAsFixed(1)}h',
                      trailing: const Icon(Icons.timer_outlined, size: 14, color: Colors.purpleAccent),
                    ),
                    // Avg Daily Tasks
                    _buildIntelligenceStat(
                      context,
                      title: 'Avg Daily Tasks',
                      value: avgDailyTasks.toStringAsFixed(1),
                      trailing: const Icon(Icons.show_chart_rounded, size: 14, color: Colors.blueAccent),
                    ),
                    // Completion Consistency
                    _buildIntelligenceStat(
                      context,
                      title: 'Completion consistency',
                      value: '${completionRate.toInt()}%',
                      trailing: _buildTrendIndicator(context, completionRate, prevCompletionRate),
                    ),
                    // Best Productivity Day
                    _buildIntelligenceStat(
                      context,
                      title: 'Best Productivity Day',
                      value: bestDay,
                      trailing: const Icon(Icons.wb_sunny_rounded, size: 14, color: Colors.amber),
                    ),
                    // Worst Productivity Day
                    _buildIntelligenceStat(
                      context,
                      title: 'Worst Productivity Day',
                      value: worstDay,
                      trailing: const Icon(Icons.cloud_rounded, size: 14, color: Colors.grey),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),
            Divider(color: colors.outlineVariant.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            
            // Smart Summaries Bullet List
            Text(
              'Smart Summaries',
              style: context.typography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...summaries.map((s) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: context.typography.bodyMedium.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        s,
                        style: context.typography.bodySmall.copyWith(
                          color: colors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildIntelligenceStat(
    BuildContext context, {
    required String title,
    required String value,
    required Widget trailing,
  }) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.labelSmall.copyWith(
                    color: colors.textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              trailing,
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.typography.titleMedium.copyWith(
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

