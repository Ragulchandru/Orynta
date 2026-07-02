import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_names.dart';
import '../../../focus/presentation/providers/focus_notifier.dart';
import '../../../focus/presentation/providers/timer_provider.dart';

class FocusCard extends ConsumerWidget {
  const FocusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch live focus state
    final todaysSessions = ref.watch(todaysFocusProvider);
    final streak = ref.watch(focusStreakProvider);
    final timerState = ref.watch(timerProvider);
    final history = ref.watch(sessionHistoryProvider);

    final completedFocusSessions = todaysSessions.where((s) => s.sessionType == 'focus' && s.completed).toList();
    final todayMinutes = completedFocusSessions.map((s) => s.actualDurationMinutes).fold(0, (a, b) => a + b);

    // Format remaining time if running
    final isRunning = timerState.isRunning;
    final mins = (timerState.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (timerState.remainingSeconds % 60).toString().padLeft(2, '0');
    final remainingTimeStr = '$mins:$secs';

    String lastSessionStr = 'None';
    if (history.isNotEmpty) {
      final last = history.first;
      final typeStr = last.sessionType == 'focus' ? 'Focus' : 'Break';
      final formattedTime = DateFormat('h:mm a').format(last.endTime);
      lastSessionStr = '$typeStr (${last.actualDurationMinutes}m) completed at $formattedTime';
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: () => context.pushNamed(RouteNames.focus),
        borderRadius: BorderRadius.circular(AppSizes.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title and timer icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Focus Workspace',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Icon(
                    Icons.alarm_on_rounded,
                    color: isRunning ? Colors.red : colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),

              // Metrics Row (Today's minutes and Streaks)
              Row(
                children: [
                  _buildStatBox(
                    context: context,
                    title: 'Today',
                    value: '$todayMinutes mins',
                    icon: Icons.access_time_rounded,
                  ),
                  const SizedBox(width: AppSizes.md),
                  _buildStatBox(
                    context: context,
                    title: 'Streak',
                    value: '$streak Days',
                    icon: Icons.electric_bolt_rounded,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),

              // Dynamic Timer or Last Session details
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: isRunning
                      ? colorScheme.primaryContainer.withValues(alpha: 0.15)
                      : colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppSizes.sm),
                  border: isRunning
                      ? Border.all(color: colorScheme.primary.withValues(alpha: 0.2))
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      isRunning ? Icons.hourglass_top_rounded : Icons.history_toggle_off_rounded,
                      size: 14,
                      color: isRunning ? colorScheme.primary : colorScheme.outline,
                    ),
                    const SizedBox(width: AppSizes.xs),
                    Expanded(
                      child: Text(
                        isRunning
                            ? 'Remaining: $remainingTimeStr (${timerState.sessionType == 'focus' ? 'Focusing' : 'Break'})'
                            : 'Last: $lastSessionStr',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isRunning ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          fontWeight: isRunning ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // Action button to enter Focus Mode screen
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed(RouteNames.focus),
                  icon: Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 18),
                  label: Text(isRunning ? 'Resume Timer' : 'Start Focus Session'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppSizes.md),
          color: colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
