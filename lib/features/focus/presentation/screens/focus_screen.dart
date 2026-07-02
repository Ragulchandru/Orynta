import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/focus_notifier.dart';
import '../providers/timer_provider.dart';
import '../widgets/focus_progress_ring.dart';
import '../widgets/focus_statistics.dart';
import '../widgets/focus_timer.dart';
import '../widgets/session_history.dart';
import '../widgets/task_selector.dart';
import '../widgets/timer_controls.dart';

class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  int _customMinutes = 25;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch providers
    final timerState = ref.watch(timerProvider);
    final sessions = ref.watch(sessionHistoryProvider);
    final streak = ref.watch(focusStreakProvider);
    final averageMinutes = ref.watch(averageFocusTimeProvider);
    final todaysSessions = ref.watch(todaysFocusProvider);

    final todayMinutes = todaysSessions
        .where((s) => s.sessionType == 'focus' && s.completed)
        .map((s) => s.actualDurationMinutes)
        .fold(0, (a, b) => a + b);

    final progressRatio = timerState.totalDurationSeconds > 0
        ? timerState.remainingSeconds / timerState.totalDurationSeconds
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Focus Mode',
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
            // 1. Preset Pickers (disable if running to prevent accidental resets)
            if (!timerState.isRunning) ...[
              Text(
                'Focus Presets',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPresetButton(
                    '25m',
                    () {
                      ref.read(timerProvider.notifier).setPreset('focus', 25);
                    },
                    timerState.totalDurationSeconds == 25 * 60 &&
                        timerState.sessionType == 'focus',
                  ),
                  _buildPresetButton(
                    '50m',
                    () {
                      ref.read(timerProvider.notifier).setPreset('focus', 50);
                    },
                    timerState.totalDurationSeconds == 50 * 60 &&
                        timerState.sessionType == 'focus',
                  ),
                  _buildPresetButton(
                    '90m',
                    () {
                      ref.read(timerProvider.notifier).setPreset('focus', 90);
                    },
                    timerState.totalDurationSeconds == 90 * 60 &&
                        timerState.sessionType == 'focus',
                  ),
                  _buildPresetButton(
                    'Break',
                    () {
                      ref
                          .read(timerProvider.notifier)
                          .setPreset('shortBreak', 5);
                    },
                    timerState.sessionType == 'shortBreak',
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  Text(
                    'Custom: ${_customMinutes}m',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _customMinutes.toDouble(),
                      min: 1,
                      max: 180,
                      divisions: 179,
                      onChanged: (val) {
                        setState(() {
                          _customMinutes = val.toInt();
                        });
                        ref
                            .read(timerProvider.notifier)
                            .setPreset('focus', _customMinutes);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
            ],

            // 2. Focus Ring & Timer
            Center(
              child: FocusProgressRing(
                progress: progressRatio,
                sessionType: timerState.sessionType,
                child: FocusTimer(
                  remainingSeconds: timerState.remainingSeconds,
                  sessionType: timerState.sessionType,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // 3. Task Linkage Row Selector
            const TaskSelector(),
            const SizedBox(height: AppSizes.lg),

            // 4. Timer Controls
            TimerControls(
              isRunning: timerState.isRunning,
              onStart: () => ref.read(timerProvider.notifier).startTimer(),
              onPause: () => ref.read(timerProvider.notifier).pauseTimer(),
              onReset: () => ref.read(timerProvider.notifier).resetTimer(),
              onStop: () {
                _showStopConfirmationDialog(context, ref);
              },
              onSkip: () => ref.read(timerProvider.notifier).skipTimer(),
            ),
            const SizedBox(height: AppSizes.xl),

            // 5. Statistics
            Text(
              'Session Performance',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            FocusStatistics(
              todayMinutes: todayMinutes,
              streak: streak,
              averageMinutes: averageMinutes,
              totalSessions: sessions
                  .where((s) => s.sessionType == 'focus' && s.completed)
                  .length,
            ),
            const SizedBox(height: AppSizes.xl),

            // 6. Session Logs History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Focus Logs',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (sessions.isNotEmpty)
                  Text(
                    '${sessions.length} sessions logged',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: colorScheme.outline),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            SessionHistory(
              sessions: sessions.take(10).toList(),
              onDelete: (id) {
                ref.read(focusNotifierProvider.notifier).deleteSession(id);
              },
            ),
            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButton(String label, VoidCallback onTap, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ChoiceChip(
          label: Container(
            alignment: Alignment.center,
            child: Text(label),
          ),
          selected: isSelected,
          onSelected: (_) => onTap(),
          showCheckmark: false,
          labelStyle: TextStyle(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          selectedColor: colorScheme.primary,
        ),
      ),
    );
  }

  void _showStopConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Stop Focus Session?'),
          content: const Text(
            'Do you want to stop this timer? You can choose to log the progress completed so far or discard it.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ref.read(timerProvider.notifier).stopTimer(saveSession: false);
              },
              child: Text(
                'Discard',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ref.read(timerProvider.notifier).stopTimer(saveSession: true);
              },
              child: const Text('Save & Stop'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Resume'),
            ),
          ],
        );
      },
    );
  }
}
