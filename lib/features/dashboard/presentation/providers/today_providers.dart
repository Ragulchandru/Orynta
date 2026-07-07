// lib/features/dashboard/presentation/providers/today_providers.dart
//
// Orynta 2.0 — Today Module Riverpod Providers
// Reactively rebuilds whenever tasks, notes, or habits change.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../habits/presentation/providers/habits_notifier.dart';
import '../../../notes/domain/entities/note_status.dart';
import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../domain/models/today_state.dart';
import '../../domain/models/notes_summary_data.dart';
import '../../domain/models/planner_summary_data.dart';
import '../../domain/models/reminder_summary_data.dart';
import '../../domain/models/tasks_summary_data.dart';
import '../../domain/repositories/today_repository.dart';
import '../../data/repositories/today_repository_impl.dart';
import '../controllers/today_controller.dart';

final todayRepositoryProvider = Provider<TodayRepository>((ref) {
  return const TodayRepositoryImpl();
});

/// Reactive dashboard summary. Auto-updates when tasks, notes, or habits change.
final todayStateProvider = Provider.autoDispose<TodayState>((ref) {
  final tasks   = ref.watch(tasksProvider);
  final notesAsync = ref.watch(notesProvider);
  final habits  = ref.watch(habitsProvider);

  final now        = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final todayEnd   = todayStart.add(const Duration(days: 1));
  final dateKey    = DateFormat('yyyy-MM-dd').format(now);

  // ── Tasks ──────────────────────────────────────────────────────────────────
  final active         = tasks.where((t) => !t.isCompleted && !t.isArchived).toList();
  final completedToday = tasks.where((t) =>
      t.isCompleted &&
      t.updatedAt.isAfter(todayStart) &&
      t.updatedAt.isBefore(todayEnd),
  ).length;
  final remaining = active.length;
  final total     = tasks.where((t) => !t.isArchived).length;

  // ── Next reminder ──────────────────────────────────────────────────────────
  final upcomingReminders = active.where((t) {
    final reminderMs = t.reminderMs;
    if (reminderMs == null) return false;
    final reminderDateTime = DateTime.fromMillisecondsSinceEpoch(reminderMs);
    return reminderDateTime.isAfter(now);
  }).toList()
    ..sort((a, b) => (a.reminderMs ?? 0).compareTo(b.reminderMs ?? 0));

  String? nextTitle, nextTime, nextPriority;
  if (upcomingReminders.isNotEmpty) {
    final task = upcomingReminders.first;
    nextTitle = task.title;
    nextPriority = task.priority;

    final reminderDateTime = DateTime.fromMillisecondsSinceEpoch(task.reminderMs!);
    final remainingMs = task.reminderMs! - now.millisecondsSinceEpoch;
    final remaining = Duration(milliseconds: remainingMs);

    // Format: strict spec — always based on reminderMs, never dueDate.
    // < 60 min  → "X min left"
    // today     → "Today HH:MM AM/PM"
    // tomorrow  → "Tomorrow HH:MM AM/PM"
    // other     → "X days left"
    final startOfToday = DateTime(now.year, now.month, now.day);
    final reminderDay = DateTime(reminderDateTime.year, reminderDateTime.month, reminderDateTime.day);
    final timeStr = DateFormat('h:mm a').format(reminderDateTime);

    if (remaining.inMinutes < 60) {
      nextTime = '${remaining.inMinutes} min left';
    } else if (reminderDay.isAtSameMomentAs(startOfToday)) {
      nextTime = 'Today $timeStr';
    } else if (reminderDay.isAtSameMomentAs(startOfToday.add(const Duration(days: 1)))) {
      nextTime = 'Tomorrow $timeStr';
    } else {
      final days = reminderDay.difference(startOfToday).inDays;
      nextTime = '$days days left';
    }
  }

  // ── Notes ──────────────────────────────────────────────────────────────────
  final notes = notesAsync.valueOrNull ?? const [];
  final activeNotes = notes.where((n) => n.status == NoteStatus.active).toList();
  final notesToday  = activeNotes.where((n) =>
      n.createdAt.isAfter(todayStart) && n.createdAt.isBefore(todayEnd),
  ).length;
  String? recentTitle;
  if (activeNotes.isNotEmpty) {
    recentTitle = (activeNotes
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)))
        .first
        .title;
  }

  // ── Habits ─────────────────────────────────────────────────────────────────
  final habitsCompletedToday = habits.where((h) {
    final count = h.completionHistory[dateKey] ?? 0;
    return count >= h.targetCount;
  }).length;

  return TodayState(
    isLoading: false,
    tasksSummary: TasksSummaryData(
      totalTasks: total,
      completedTasks: completedToday,
      remainingTasks: remaining,
    ),
    notesSummary: NotesSummaryData(
      notesCreatedToday: notesToday,
      recentlyModifiedNoteTitle: recentTitle,
    ),
    reminderSummary: ReminderSummaryData(
      title: nextTitle,
      time: nextTime,
      priority: nextPriority,
    ),
    plannerSummary: PlannerSummaryData(
      eventsTodayCount: habitsCompletedToday,
      upcomingEventsCount: upcomingReminders.length,
    ),
  );
});

// Keep legacy controller for compatibility with widgets that already use it.
final todayControllerProvider =
    StateNotifierProvider.autoDispose<TodayController, TodayState>((ref) {
  final repository = ref.watch(todayRepositoryProvider);
  return TodayController(repository);
});
