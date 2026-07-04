// lib/features/analytics/presentation/widgets/task_completion_overview_card.dart
//
// Orynta 2.0 — Custom Bar Chart showing Task Completion Trends (Responsive Headers)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/design_system/motion/motion_tokens.dart';

class TaskCompletionOverviewCard extends StatefulWidget {
  const TaskCompletionOverviewCard({
    super.key,
    required this.completedWeekly,
    required this.datesWeekly,
    required this.completedMonthly,
    required this.datesMonthly,
  });

  final List<int> completedWeekly;
  final List<DateTime> datesWeekly;

  final List<int> completedMonthly;
  final List<DateTime> datesMonthly;

  @override
  State<TaskCompletionOverviewCard> createState() => _TaskCompletionOverviewCardState();
}

class _TaskCompletionOverviewCardState extends State<TaskCompletionOverviewCard> with SingleTickerProviderStateMixin {
  int _selectedTab = 0; // 0 = Weekly, 1 = Monthly
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: MotionTokens.emphasized,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant TaskCompletionOverviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final completed = _selectedTab == 0 ? widget.completedWeekly : widget.completedMonthly;
    final dates = _selectedTab == 0 ? widget.datesWeekly : widget.datesMonthly;

    final maxVal = [
      ...completed,
      3, // Minimum baseline height
    ].reduce((a, b) => a > b ? a : b);

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
            // Responsive Wrap Header
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 450;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: isNarrow ? constraints.maxWidth : null,
                      child: Text(
                        'Task Completion Overview',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 0, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Wk', maxLines: 1))),
                        ButtonSegment(value: 1, label: FittedBox(fit: BoxFit.scaleDown, child: Text('Mo', maxLines: 1))),
                      ],
                      selected: {_selectedTab},
                      onSelectionChanged: (val) {
                        setState(() {
                          _selectedTab = val.first;
                        });
                        _animationController.reset();
                        _animationController.forward();
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 6),
            Text(
              'Completed tasks counts distribution',
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: AppSizes.xl),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SizedBox(
                  height: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(completed.length, (idx) {
                      final startDelay = (idx * 0.04).clamp(0.0, 0.4);
                      final progress = ((_animation.value - startDelay) / 0.6).clamp(0.0, 1.0);
                      final scale = progress == 1.0 ? 1.0 : progress * 1.15 - 0.15 * math.pow(progress, 3);

                      final val = completed[idx];
                      final ratio = val / maxVal;
                      final height = (ratio * 120.0 * scale).clamp(4.0, 120.0);

                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Tooltip(
                              message: '$val completed',
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                height: height,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(alpha: 0.8),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedTab == 0
                                  ? DateFormat('E').format(dates[idx]).substring(0, 1)
                                  : DateFormat('d').format(dates[idx]),
                              style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
