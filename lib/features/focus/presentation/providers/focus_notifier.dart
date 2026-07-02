import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/datasources/focus_local_data_source.dart';
import '../../data/models/focus_session_model.dart';
import '../../data/repositories/focus_repository_impl.dart';
import '../../domain/entities/focus_session_entity.dart';
import '../../domain/repositories/focus_repository.dart';

final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  final Box<FocusSessionModel> box =
      Hive.box<FocusSessionModel>(AppStrings.focusBoxName);
  final dataSource = FocusLocalDataSourceImpl(box);
  return FocusRepositoryImpl(dataSource);
});

// ─── Focus Notifier ──────────────────────────────────────────────────────────

class FocusNotifier extends StateNotifier<List<FocusSessionEntity>> {
  FocusNotifier(this._repository) : super([]) {
    loadSessions();
  }

  final FocusRepository _repository;

  Future<void> loadSessions() async {
    final sessions = await _repository.getAllSessions();
    state = sessions;
  }

  Future<void> addSession(FocusSessionEntity session) async {
    await _repository.saveSession(session);
    state = [...state, session];
  }

  Future<void> deleteSession(String id) async {
    await _repository.deleteSession(id);
    state = state.where((s) => s.id != id).toList();
  }
}

final focusNotifierProvider = StateNotifierProvider<FocusNotifier,
    List<FocusSessionEntity>>((ref) {
  final repo = ref.watch(focusRepositoryProvider);
  return FocusNotifier(repo);
});

// ─── Derived Computed Providers ──────────────────────────────────────────────

final sessionHistoryProvider = Provider<List<FocusSessionEntity>>((ref) {
  final sessions = ref.watch(focusNotifierProvider);
  return [...sessions]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

final todaysFocusProvider = Provider<List<FocusSessionEntity>>((ref) {
  final sessions = ref.watch(focusNotifierProvider);
  final now = DateTime.now();
  return sessions
      .where(
        (s) =>
            s.createdAt.year == now.year &&
            s.createdAt.month == now.month &&
            s.createdAt.day == now.day,
      )
      .toList();
},);

final weeklyFocusProvider = Provider<List<FocusSessionEntity>>((ref) {
  final sessions = ref.watch(focusNotifierProvider);
  final limit = DateTime.now().subtract(const Duration(days: 7));
  return sessions.where((s) => s.createdAt.isAfter(limit)).toList();
});

final monthlyFocusProvider = Provider<List<FocusSessionEntity>>((ref) {
  final sessions = ref.watch(focusNotifierProvider);
  final limit = DateTime.now().subtract(const Duration(days: 30));
  return sessions.where((s) => s.createdAt.isAfter(limit)).toList();
});

final averageFocusTimeProvider = Provider<double>((ref) {
  final sessions = ref
      .watch(focusNotifierProvider)
      .where((s) => s.sessionType == 'focus')
      .toList();
  if (sessions.isEmpty) return 0.0;
  final total =
      sessions.map((s) => s.actualDurationMinutes).reduce((a, b) => a + b);
  return total / sessions.length;
});

final focusStreakProvider = Provider<int>((ref) {
  final sessions = ref
      .watch(focusNotifierProvider)
      .where((s) => s.sessionType == 'focus' && s.completed)
      .toList();
  if (sessions.isEmpty) return 0;

  // Extract set of dates: yyyy-MM-dd
  final dates = sessions.map((s) {
    final dt = s.createdAt;
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }).toSet();

  int streak = 0;
  DateTime checkDate = DateTime.now();

  final todayKey = _formatKey(checkDate);
  final yesterdayKey = _formatKey(checkDate.subtract(const Duration(days: 1)));

  if (!dates.contains(todayKey) && !dates.contains(yesterdayKey)) {
    return 0;
  }

  DateTime iterator = dates.contains(todayKey)
      ? checkDate
      : checkDate.subtract(const Duration(days: 1));
  while (true) {
    final key = _formatKey(iterator);
    if (dates.contains(key)) {
      streak++;
      iterator = iterator.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }
  return streak;
});

String _formatKey(DateTime dt) {
  final y = dt.year.toString();
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
