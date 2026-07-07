import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../providers/analytics_provider.dart';

class HeatmapCalendar extends ConsumerStatefulWidget {
  const HeatmapCalendar({
    super.key,
    required this.monthlyStats,
  });

  final List<DailyStats> monthlyStats;

  @override
  ConsumerState<HeatmapCalendar> createState() => _HeatmapCalendarState();
}

class _HeatmapCalendarState extends ConsumerState<HeatmapCalendar> {
  int _viewMode = 0; // 0 = Month, 1 = Year
  DateTime? _selectedDate;

  void _showDailySummary(BuildContext context, DailyStats stat) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appTheme = context.appTheme;

    final totalProductivity = stat.tasksCompleted + stat.notesCreated + stat.focusMinutes ~/ 15;

    showModalBottomSheet(
      context: context,
      backgroundColor: appTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(stat.date),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                if (totalProductivity == 0)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        children: [
                          Icon(Icons.event_busy_rounded, size: 48, color: colorScheme.outline),
                          const SizedBox(height: 12),
                          Text(
                            'No activity recorded.',
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  // Tasks
                  _buildSectionHeader(context, 'Tasks'),
                  _buildMetricRow(context, 'Created', '${stat.tasksCompleted + stat.tasksPending}'),
                  _buildMetricRow(context, 'Completed', '${stat.tasksCompleted}'),
                  _buildMetricRow(context, 'Overdue', '${stat.tasksPending}'),
                  const SizedBox(height: 12),

                  // Notes
                  _buildSectionHeader(context, 'Notes'),
                  _buildMetricRow(context, 'Created', '${stat.notesCreated}'),
                  _buildMetricRow(context, 'Edited', '${stat.notesEdited}'),
                  const SizedBox(height: 12),

                  // Productivity
                  _buildSectionHeader(context, 'Productivity'),
                  _buildMetricRow(context, 'Productivity Score', '${stat.productivityScore.toInt()}/100'),
                  _buildMetricRow(context, 'Focus Time Completed', '${stat.focusMinutes} mins'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        title,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildMetricRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity Heatmap',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Month', maxLines: 1))),
                    ButtonSegment(value: 1, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Year', maxLines: 1))),
                  ],
                  selected: {_viewMode},
                  onSelectionChanged: (val) {
                    setState(() => _viewMode = val.first);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Productivity intensity and output frequencies',
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: AppSizes.md),
            AnimatedCrossFade(
              firstChild: _buildMonthGrid(theme, colorScheme),
              secondChild: _buildYearGrid(theme, colorScheme),
              crossFadeState: _viewMode == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
            const SizedBox(height: 16),
            _buildHeatmapLegend(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  List<String> _getWeekdayHeaders() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final date = monday.add(Duration(days: i));
      return DateFormat.E().format(date);
    });
  }

  Widget _buildMonthGrid(ThemeData theme, ColorScheme colorScheme) {
    final now = DateTime.now();
    
    final firstDay = DateTime(now.year, now.month, 1);
    final firstWeekday = firstDay.weekday; // 1 = Monday, 7 = Sunday
    final paddingCells = firstWeekday - 1;
    final totalDays = DateTime(now.year, now.month + 1, 0).day;
    final gridCount = ((paddingCells + totalDays) / 7).ceil() * 7;

    return Column(
      children: [
        Row(
          children: _getWeekdayHeaders()
              .map((d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                  ),)
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gridCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemBuilder: (context, idx) {
            final date = firstDay.add(Duration(days: idx - paddingCells));
            final stat = ref.watch(dailyStatsProvider(date));
            final total = stat.tasksCompleted + stat.notesCreated + stat.focusMinutes ~/ 15;
            final color = _getHeatmapColor(total, colorScheme);

            final isToday = stat.date.year == now.year && stat.date.month == now.month && stat.date.day == now.day;
            final isSelected = _selectedDate != null &&
                stat.date.year == _selectedDate!.year &&
                stat.date.month == _selectedDate!.month &&
                stat.date.day == _selectedDate!.day;
            final isCurrentMonth = date.month == now.month;

            return GestureDetector(
              onTap: () {
                setState(() => _selectedDate = stat.date);
                _showDailySummary(context, stat);
              },
              child: AnimatedScale(
                scale: isSelected ? 1.05 : 1.0,
                duration: MotionTokens.fast,
                curve: MotionTokens.emphasized,
                child: AnimatedContainer(
                  duration: MotionTokens.normal,
                  curve: MotionTokens.emphasized,
                  decoration: BoxDecoration(
                    color: isCurrentMonth ? color : color.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : isToday
                              ? colorScheme.secondary
                              : Colors.transparent,
                      width: isSelected || isToday ? 2.0 : 0.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${stat.date.day}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: !isCurrentMonth 
                            ? colorScheme.onSurface.withValues(alpha: 0.4)
                            : (total > 2 ? Colors.white : colorScheme.onSurface),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildYearGrid(ThemeData theme, ColorScheme colorScheme) {
    final now = DateTime.now();
    const cellCount = 140;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 110,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: cellCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (context, idx) {
            final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: (cellCount - 1) - idx));
            final stat = ref.watch(dailyStatsProvider(date));
            final total = stat.tasksCompleted + stat.notesCreated + stat.focusMinutes ~/ 15;
            final color = _getHeatmapColor(total, colorScheme);

            return GestureDetector(
              onTap: () => _showDailySummary(context, stat),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeatmapLegend(ThemeData theme, ColorScheme colorScheme) {
    Widget buildLegendDot(String label, Color color) {
      return Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(width: 4),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildLegendDot('No Data', colorScheme.outlineVariant.withValues(alpha: 0.1)),
        buildLegendDot('Low', colorScheme.primary.withValues(alpha: 0.25)),
        buildLegendDot('Medium', colorScheme.primary.withValues(alpha: 0.5)),
        buildLegendDot('High', colorScheme.primary.withValues(alpha: 0.75)),
        buildLegendDot('Very High', colorScheme.primary),
      ],
    );
  }

  Color _getHeatmapColor(int points, ColorScheme colorScheme) {
    if (points == 0) return colorScheme.outlineVariant.withValues(alpha: 0.1);
    if (points < 2) return colorScheme.primary.withValues(alpha: 0.25);
    if (points < 4) return colorScheme.primary.withValues(alpha: 0.5);
    if (points < 6) return colorScheme.primary.withValues(alpha: 0.75);
    return colorScheme.primary;
  }
}
