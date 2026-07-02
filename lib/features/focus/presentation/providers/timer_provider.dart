import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../habits/presentation/providers/habits_notifier.dart';
import '../../domain/entities/focus_session_entity.dart';
import 'focus_notifier.dart';

class TimerState {
  const TimerState({
    required this.remainingSeconds,
    required this.totalDurationSeconds,
    required this.isRunning,
    required this.sessionType, // "focus", "shortBreak", "longBreak"
    this.selectedTaskId,
    this.selectedHabitId,
  });

  final int remainingSeconds;
  final int totalDurationSeconds;
  final bool isRunning;
  final String sessionType;
  final String? selectedTaskId;
  final String? selectedHabitId;

  TimerState copyWith({
    int? remainingSeconds,
    int? totalDurationSeconds,
    bool? isRunning,
    String? sessionType,
    String? selectedTaskId,
    String? selectedHabitId,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      isRunning: isRunning ?? this.isRunning,
      sessionType: sessionType ?? this.sessionType,
      selectedTaskId: selectedTaskId ?? this.selectedTaskId,
      selectedHabitId: selectedHabitId ?? this.selectedHabitId,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier(this._ref,)
      : super(
          const TimerState(
            remainingSeconds: 25 * 60,
            totalDurationSeconds: 25 * 60,
            isRunning: false,
            sessionType: 'focus',
          ),
        );

  final Ref _ref;
  Timer? _timer;
  DateTime? _startTime;

  void selectTask(String? taskId) {
    state = state.copyWith(selectedTaskId: taskId);
  }

  void selectHabit(String? habitId) {
    state = state.copyWith(selectedHabitId: habitId);
  }

  void startTimer() {
    if (state.isRunning) return;
    _startTime = DateTime.now();
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _onTimeCompleted();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resumeTimer() {
    startTimer();
  }

  void resetTimer() {
    _timer?.cancel();
    state = state.copyWith(
      remainingSeconds: state.totalDurationSeconds,
      isRunning: false,
    );
  }

  void stopTimer({required bool saveSession}) {
    _timer?.cancel();
    final elapsedSeconds = state.totalDurationSeconds - state.remainingSeconds;

    if (saveSession && elapsedSeconds > 0) {
      _saveSessionLog(
        interrupted: true,
        actualDurationSeconds: elapsedSeconds,
      );
    }

    state = state.copyWith(
      remainingSeconds: state.totalDurationSeconds,
      isRunning: false,
    );
  }

  void skipTimer() {
    _timer?.cancel();
    _transitionToNextPhase();
  }

  void setPreset(String type, int minutes) {
    _timer?.cancel();
    state = TimerState(
      remainingSeconds: minutes * 60,
      totalDurationSeconds: minutes * 60,
      isRunning: false,
      sessionType: type,
      selectedTaskId: state.selectedTaskId,
      selectedHabitId: state.selectedHabitId,
    );
  }

  void _onTimeCompleted() {
    _timer?.cancel();
    _saveSessionLog(
      interrupted: false,
      actualDurationSeconds: state.totalDurationSeconds,
    );

    // Auto-completions linkages triggers
    if (state.sessionType == 'focus') {
      if (state.selectedTaskId != null) {
        _ref
            .read(tasksProvider.notifier)
            .toggleTaskCompletion(state.selectedTaskId!);
      }
      if (state.selectedHabitId != null) {
        _ref
            .read(habitsProvider.notifier)
            .incrementHabit(state.selectedHabitId!);
      }
    }

    // Clean notifications hook endpoints
    _triggerNotification(
      title: state.sessionType == 'focus' ? 'Focus Complete!' : 'Break Over!',
      body:
          state.sessionType == 'focus' ? 'Time for a break.' : 'Back to focus.',
    );

    _transitionToNextPhase();
  }

  void _saveSessionLog({
    required bool interrupted,
    required int actualDurationSeconds,
  }) {
    final start = _startTime ??
        DateTime.now().subtract(Duration(seconds: actualDurationSeconds));
    final end = DateTime.now();

    final session = FocusSessionEntity(
      id: const Uuid().v4(),
      taskId: state.selectedTaskId,
      habitId: state.selectedHabitId,
      sessionType: state.sessionType,
      durationMinutes: state.totalDurationSeconds ~/ 60,
      actualDurationMinutes: actualDurationSeconds ~/ 60,
      startTime: start,
      endTime: end,
      completed: !interrupted,
      interrupted: interrupted,
      notes: '',
      createdAt: end,
    );

    _ref.read(focusNotifierProvider.notifier).addSession(session);
  }

  void _transitionToNextPhase() {
    String nextType = 'focus';
    int nextMinutes = 25;

    if (state.sessionType == 'focus') {
      // Find historical consecutive sessions count to trigger long break
      final history = _ref.read(focusNotifierProvider);
      final focusTodayCount = history
          .where((s) =>
              s.sessionType == 'focus' &&
              s.completed &&
              s.createdAt.day == DateTime.now().day,
          )
          .length;

      if ((focusTodayCount + 1) % 4 == 0) {
        nextType = 'longBreak';
        nextMinutes = 20;
      } else {
        nextType = 'shortBreak';
        nextMinutes = 5;
      }
    }

    state = TimerState(
      remainingSeconds: nextMinutes * 60,
      totalDurationSeconds: nextMinutes * 60,
      isRunning: false,
      sessionType: nextType,
      selectedTaskId: state.selectedTaskId,
      selectedHabitId: state.selectedHabitId,
    );
  }

  void _triggerNotification({required String title, required String body}) {
    // Local notifications plugin placeholder clean extension point.
    // print('Alarm Notification - Title: $title, Body: $body');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier(ref);
});
