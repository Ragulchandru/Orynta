import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';
import '../../data/datasources/habit_local_data_source.dart';
import '../../data/models/habit_model.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../../planner/domain/services/notification_service.dart';
import '../../../planner/domain/services/planner_notification_service.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final Box<HabitModel> box = Hive.box<HabitModel>(AppStrings.habitsBoxName);
  final dataSource = HabitLocalDataSourceImpl(box);
  return HabitRepositoryImpl(dataSource);
});

// ─── Habits Notifier ─────────────────────────────────────────────────────────

class HabitsNotifier extends StateNotifier<List<HabitEntity>> {
  HabitsNotifier(
    this._repository, {
    NotificationService? notificationService,
  })  : _notificationService = notificationService ?? PlannerNotificationService.instance,
        super([]) {
    loadHabits();
  }

  final HabitRepository _repository;
  final NotificationService _notificationService;

  Future<void> loadHabits() async {
    final habits = await _repository.getAllHabits();
    
    // Check if any habit needs today's count/completion reset because a new day has started
    final todayKey = _formatKey(DateTime.now());
    final updatedList = <HabitEntity>[];
    
    for (final h in habits) {
      final countForToday = h.completionHistory[todayKey] ?? 0;
      final completedToday = countForToday >= h.targetCount;
      if (h.currentCount != countForToday || h.completedToday != completedToday) {
        final updated = h.copyWith(
          currentCount: countForToday,
          completedToday: completedToday,
          updatedAt: DateTime.now(),
        );
        await _repository.updateHabit(updated);
        updatedList.add(updated);
      } else {
        updatedList.add(h);
      }
    }
    
    state = updatedList;

    // Reschedule all active future habit reminders
    for (final h in state) {
      _syncHabitReminder(h);
    }
  }

  Future<void> addHabit(HabitEntity habit) async {
    await _repository.saveHabit(habit);
    state = [...state, habit];
    _syncHabitReminder(habit);
  }

  Future<void> editHabit(HabitEntity habit) async {
    final updated = habit.copyWith(updatedAt: DateTime.now());
    await _repository.updateHabit(updated);
    state = [
      for (final h in state)
        if (h.id == habit.id) updated else h,
    ];
    _syncHabitReminder(updated);
  }

  Future<void> deleteHabit(String id) async {
    await _repository.deleteHabit(id);
    state = state.where((h) => h.id != id).toList();
    _notificationService.cancelHabitReminder(id);
  }

  Future<void> incrementHabit(String id, [DateTime? date]) async {
    final index = state.indexWhere((h) => h.id == id);
    if (index == -1) return;

    final habit = state[index];
    final targetDate = date ?? DateTime.now();
    final dateKey = _formatKey(targetDate);
    final newHistory = Map<String, int>.from(habit.completionHistory);
    final currentVal = newHistory[dateKey] ?? 0;
    newHistory[dateKey] = currentVal + 1;

    final isToday = _formatKey(DateTime.now()) == dateKey;
    final isCompleted = newHistory[dateKey]! >= habit.targetCount;
    final currentStreak = _calculateStreak(newHistory, habit.targetCount);
    final longestStreak = currentStreak > habit.longestStreak ? currentStreak : habit.longestStreak;

    final updated = habit.copyWith(
      currentCount: isToday ? newHistory[dateKey]! : habit.currentCount,
      completedToday: isToday ? isCompleted : habit.completedToday,
      completionHistory: newHistory,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      updatedAt: DateTime.now(),
    );

    await _repository.updateHabit(updated);
    state = [
      for (final h in state)
        if (h.id == id) updated else h,
    ];
    _syncHabitReminder(updated);
  }

  Future<void> decrementHabit(String id, [DateTime? date]) async {
    final index = state.indexWhere((h) => h.id == id);
    if (index == -1) return;

    final habit = state[index];
    final targetDate = date ?? DateTime.now();
    final dateKey = _formatKey(targetDate);
    final newHistory = Map<String, int>.from(habit.completionHistory);
    final currentVal = newHistory[dateKey] ?? 0;
    if (currentVal <= 0) return;
    newHistory[dateKey] = currentVal - 1;

    final isToday = _formatKey(DateTime.now()) == dateKey;
    final isCompleted = newHistory[dateKey]! >= habit.targetCount;
    final currentStreak = _calculateStreak(newHistory, habit.targetCount);

    final updated = habit.copyWith(
      currentCount: isToday ? newHistory[dateKey]! : habit.currentCount,
      completedToday: isToday ? isCompleted : habit.completedToday,
      completionHistory: newHistory,
      currentStreak: currentStreak,
      updatedAt: DateTime.now(),
    );

    await _repository.updateHabit(updated);
    state = [
      for (final h in state)
        if (h.id == id) updated else h,
    ];
    _syncHabitReminder(updated);
  }

  void _syncHabitReminder(HabitEntity habit) {
    _notificationService.cancelHabitReminder(habit.id);

    // If completed today or no reminderType is set, do not schedule
    if (habit.completedToday || habit.reminderType == null) {
      return;
    }

    _notificationService.scheduleHabitReminder(
      habitId: habit.id,
      habitTitle: habit.title,
      reminderType: habit.reminderType!,
      customTime: habit.customReminderTime,
    );
  }

  String _formatKey(DateTime dt) {
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  int _calculateStreak(Map<String, int> history, int targetCount) {
    int streak = 0;
    DateTime checkDate = DateTime.now();

    final todayKey = _formatKey(checkDate);
    final yesterdayKey = _formatKey(checkDate.subtract(const Duration(days: 1)));

    final todayCompleted = (history[todayKey] ?? 0) >= targetCount;
    final yesterdayCompleted = (history[yesterdayKey] ?? 0) >= targetCount;

    if (!todayCompleted && !yesterdayCompleted) {
      return 0;
    }

    DateTime iterator = todayCompleted ? checkDate : checkDate.subtract(const Duration(days: 1));
    while (true) {
      final key = _formatKey(iterator);
      if ((history[key] ?? 0) >= targetCount) {
        streak++;
        iterator = iterator.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<HabitEntity>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return HabitsNotifier(repository);
});

// ─── Computed Selectors ──────────────────────────────────────────────────────

final todaysHabitsProvider = Provider<List<HabitEntity>>((ref) {
  return ref.watch(habitsProvider);
});

final completedHabitsProvider = Provider<List<HabitEntity>>((ref) {
  return ref.watch(todaysHabitsProvider).where((h) => h.completedToday).toList();
});

final activeStreakProvider = Provider<int>((ref) {
  final habits = ref.watch(habitsProvider);
  if (habits.isEmpty) return 0;
  return habits.map((h) => h.currentStreak).fold(0, (a, b) => a > b ? a : b);
});

final longestStreakProvider = Provider<int>((ref) {
  final habits = ref.watch(habitsProvider);
  if (habits.isEmpty) return 0;
  return habits.map((h) => h.longestStreak).fold(0, (a, b) => a > b ? a : b);
});

/// Displays overall today's completion rate
final habitCompletionRateProvider = Provider<double>((ref) {
  final habits = ref.watch(todaysHabitsProvider);
  if (habits.isEmpty) return 0.0;
  final completed = habits.where((h) => h.completedToday).length;
  return completed / habits.length;
});

/// Adjusts list entities to reflect selected calendar date completions
final habitsForSelectedDateProvider = Provider<List<HabitEntity>>((ref) {
  final habits = ref.watch(habitsProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final dateKey = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

  return habits.map((h) {
    final countOnDate = h.completionHistory[dateKey] ?? 0;
    return h.copyWith(
      currentCount: countOnDate,
      completedToday: countOnDate >= h.targetCount,
    );
  }).toList();
});

final habitConsistencyProvider = Provider<double>((ref) {
  final habits = ref.watch(habitsProvider);
  if (habits.isEmpty) return 0.0;

  double totalConsistency = 0.0;
  final now = DateTime.now();

  for (final habit in habits) {
    int completedDays = 0;
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final completedCount = habit.completionHistory[dateKey] ?? 0;
      if (completedCount >= habit.targetCount) {
        completedDays++;
      }
    }
    totalConsistency += (completedDays / 30.0);
  }

  return totalConsistency / habits.length;
});
