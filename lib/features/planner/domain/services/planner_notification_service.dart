// lib/features/planner/domain/services/planner_notification_service.dart
//
// Orynta 2.0 — Production Notification Engine
// Uses flutter_local_notifications for real scheduled local notifications.
// Supports: Tasks, Habits, Focus Sessions, Daily Summaries, Reboot Recovery.
// Action IDs: complete, snooze, open

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'notification_service.dart';

// ─── Action Identifiers ──────────────────────────────────────────────────────
// ...
class NotificationActions {
  static const String complete  = 'action_complete';
  static const String checkIn   = 'action_checkin';
  static const String snooze    = 'action_snooze';
  static const String open      = 'action_open';
}

// ─── Notification ID Namespaces ──────────────────────────────────────────────
// Each entity gets a deterministic ID range to avoid collisions.
// Tasks  : Hash(taskId)   % 10_000          →  0 –  9_999
// Habits : Hash(habitId)  % 10_000 + 10_000 → 10_000 – 19_999
// System :                                  → 90_000+

// ─── Channel IDs / Names ─────────────────────────────────────────────────────

class _Channels {
  static const taskChannelId    = 'orynta_tasks';
  static const taskChannelName  = 'Task Reminders';
  static const habitChannelId   = 'orynta_habits';
  static const habitChannelName = 'Habit Reminders';
  static const systemChannelId  = 'orynta_system';
  static const systemChannelName = 'System Alerts';
}

// ─── Service ─────────────────────────────────────────────────────────────────

class PlannerNotificationService implements NotificationService {
  const PlannerNotificationService._();

  static const instance = PlannerNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialised = false;

  // Quiet hours (24h)
  static int _quietStart = 22; // 10 PM
  static int _quietEnd   = 7;  // 7 AM
  static bool _quietHoursEnabled = false;

  // ── Init ──────────────────────────────────────────────────────────────────

  /// Call once from main() before runApp.
  static Future<void> init() async {
    if (_initialised) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings  = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundResponse,
    );

    _initialised = true;
    debugPrint('[PlannerNotificationService] Initialized.');
  }

  // ── Permission ────────────────────────────────────────────────────────────

  /// Request exact-alarm / notification permissions. Returns true if granted.
  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return false;
  }

  // ── Quiet Hours ───────────────────────────────────────────────────────────

  static void updateQuietHours({
    required bool enabled,
    required int startHour,
    required int endHour,
  }) {
    _quietHoursEnabled = enabled;
    _quietStart = startHour;
    _quietEnd   = endHour;
  }

  static bool _isQuietNow() {
    if (!_quietHoursEnabled) return false;
    final hour = DateTime.now().hour;
    if (_quietStart < _quietEnd) {
      return hour >= _quietStart && hour < _quietEnd;
    } else {
      // Wraps midnight: e.g. 22–7
      return hour >= _quietStart || hour < _quietEnd;
    }
  }

  // ── Action Response Handlers ──────────────────────────────────────────────

  static void _onNotificationResponse(NotificationResponse response) {
    final payload  = response.payload ?? '';
    final actionId = response.actionId ?? '';

    debugPrint('[PlannerNotificationService] Action: $actionId | Payload: $payload');

    switch (actionId) {
      case NotificationActions.complete:
        _handleComplete(payload);
      case NotificationActions.checkIn:
        _handleCheckIn(payload);
      case NotificationActions.snooze:
        _handleSnooze(payload);
      case NotificationActions.open:
      default:
        _handleOpen(payload);
    }
  }

  @pragma('vm:entry-point')
  static void _onBackgroundResponse(NotificationResponse response) {
    _onNotificationResponse(response);
  }

  static void _handleComplete(String payload) {
    debugPrint('[PlannerNotificationService] Complete action for: $payload');
    // TODO: wire to tasksNotifier.completeTask(id) via isolate port or deep link
  }

  static void _handleCheckIn(String payload) {
    debugPrint('[PlannerNotificationService] Check-in action for: $payload');
    // TODO: wire to habitsNotifier.incrementHabit(id)
  }

  static void _handleSnooze(String payload) {
    debugPrint('[PlannerNotificationService] Snooze action for: $payload');
    // Reschedule 10 minutes from now
    final snoozedTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 10));
    final id = _idFromPayload(payload);
    if (id != null) {
      _scheduleRaw(
        id: id,
        title: 'Snoozed Reminder',
        body: 'Your reminder is back.',
        scheduledDate: snoozedTime,
        channelId: _Channels.taskChannelId,
        channelName: _Channels.taskChannelName,
        payload: payload,
        actions: _taskActions(),
      );
    }
  }

  static void _handleOpen(String payload) {
    debugPrint('[PlannerNotificationService] Open action for: $payload');
    // TODO: GoRouter.instance.go('/planner/task/$payload')
  }

  // ── NotificationService Interface Implementation ──────────────────────────

  @override
  Future<void> scheduleTaskReminder({
    required String taskId,
    required String taskTitle,
    required DateTime reminderTime,
    required int earlyMinutes,
    required String repeatInterval,
  }) async {
    await scheduleTaskReminderStatic(
      taskId: taskId,
      taskTitle: taskTitle,
      reminderTime: reminderTime,
      earlyMinutes: earlyMinutes,
      repeatInterval: repeatInterval,
    );
  }

  @override
  Future<void> cancelTaskReminder(String taskId) async {
    await cancelTaskReminderStatic(taskId);
  }

  @override
  Future<void> scheduleHabitReminder({
    required String habitId,
    required String habitTitle,
    required String reminderType,
    String? customTime,
  }) async {
    await scheduleHabitReminderStatic(
      habitId: habitId,
      habitTitle: habitTitle,
      reminderType: reminderType,
      customTime: customTime,
    );
  }

  @override
  Future<void> cancelHabitReminder(String habitId) async {
    await cancelHabitReminderStatic(habitId);
  }

  // ── Task Notifications ────────────────────────────────────────────────────

  static Future<void> scheduleTaskReminderStatic({
    required String taskId,
    required String taskTitle,
    required DateTime reminderTime,
    int? earlyMinutes,
    String? repeatInterval,
  }) async {
    if (_isQuietNow()) {
      debugPrint('[PlannerNotificationService] Quiet hours — skipped task: $taskId');
      return;
    }

    final effectiveTime = earlyMinutes != null
        ? reminderTime.subtract(Duration(minutes: earlyMinutes))
        : reminderTime;

    if (effectiveTime.isBefore(DateTime.now())) {
      debugPrint('[PlannerNotificationService] Reminder is in the past — skipped.');
      return;
    }

    final tzTime = tz.TZDateTime.from(effectiveTime, tz.local);
    final notifId = _taskNotifId(taskId);

    await _scheduleRaw(
      id: notifId,
      title: '📌 $taskTitle',
      body: earlyMinutes != null
          ? 'Due in $earlyMinutes minutes'
          : 'Your task is due now',
      scheduledDate: tzTime,
      channelId: _Channels.taskChannelId,
      channelName: _Channels.taskChannelName,
      payload: 'task:$taskId',
      actions: _taskActions(),
    );

    debugPrint(
      '[PlannerNotificationService] Scheduled task "$taskTitle" at $tzTime',
    );
  }

  static Future<void> cancelTaskReminderStatic(String taskId) async {
    await _plugin.cancel(_taskNotifId(taskId));
    debugPrint('[PlannerNotificationService] Cancelled task: $taskId');
  }

  static Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
    debugPrint('[PlannerNotificationService] Cancelled all reminders.');
  }

  static Future<void> snoozeTaskReminder(String taskId, Duration snoozeDuration) async {
    final nextTime = tz.TZDateTime.now(tz.local).add(snoozeDuration);
    final notifId  = _taskNotifId(taskId);

    await _scheduleRaw(
      id: notifId,
      title: '⏰ Snoozed Reminder',
      body: 'Reminder rescheduled.',
      scheduledDate: nextTime,
      channelId: _Channels.taskChannelId,
      channelName: _Channels.taskChannelName,
      payload: 'task:$taskId',
      actions: _taskActions(),
    );

    debugPrint('[PlannerNotificationService] Snoozed task $taskId until $nextTime');
  }

  // ── Habit Notifications ───────────────────────────────────────────────────

  static Future<void> scheduleHabitReminderStatic({
    required String habitId,
    required String habitTitle,
    required String reminderType,
    String? customTime,
  }) async {
    TimeOfDay? time;

    switch (reminderType) {
      case 'morning':
        time = const TimeOfDay(hour: 8, minute: 0);
      case 'afternoon':
        time = const TimeOfDay(hour: 13, minute: 0);
      case 'evening':
        time = const TimeOfDay(hour: 19, minute: 0);
      case 'custom':
        if (customTime != null) {
          final parts = customTime.split(':');
          if (parts.length == 2) {
            time = TimeOfDay(
              hour: int.tryParse(parts[0]) ?? 8,
              minute: int.tryParse(parts[1]) ?? 0,
            );
          }
        }
      default:
        return;
    }

    if (time == null) return;
    if (_isQuietNow()) {
      debugPrint('[PlannerNotificationService] Quiet hours — skipped habit: $habitId');
      return;
    }

    final now       = DateTime.now();
    var scheduled   = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final tzTime  = tz.TZDateTime.from(scheduled, tz.local);
    final notifId = _habitNotifId(habitId);

    await _scheduleRaw(
      id: notifId,
      title: '🌟 $habitTitle',
      body: 'Don\'t forget your habit today!',
      scheduledDate: tzTime,
      channelId: _Channels.habitChannelId,
      channelName: _Channels.habitChannelName,
      payload: 'habit:$habitId',
      actions: _habitActions(),
    );

    debugPrint(
      '[PlannerNotificationService] Scheduled habit "$habitTitle" at $tzTime',
    );
  }

  static Future<void> cancelHabitReminderStatic(String habitId) async {
    await _plugin.cancel(_habitNotifId(habitId));
    debugPrint('[PlannerNotificationService] Cancelled habit: $habitId');
  }

  // ── Daily Summary ─────────────────────────────────────────────────────────

  static Future<void> scheduleDailySummary({
    int hour = 21,
    int minute = 0,
  }) async {
    const notifId = 90000;
    final now     = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final tzTime = tz.TZDateTime.from(scheduled, tz.local);

    await _scheduleRaw(
      id: notifId,
      title: '📊 Your Daily Summary',
      body: 'Tap to review your productivity today.',
      scheduledDate: tzTime,
      channelId: _Channels.systemChannelId,
      channelName: _Channels.systemChannelName,
      payload: 'system:daily_summary',
      actions: [],
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint('[PlannerNotificationService] Scheduled daily summary at $tzTime');
  }

  // ── Notification History ──────────────────────────────────────────────────

  /// Returns all currently pending notifications as a list of maps.
  static Future<List<Map<String, dynamic>>> getPendingNotifications() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending
        .map((n) => {
              'id': n.id,
              'title': n.title ?? '',
              'body': n.body ?? '',
              'payload': n.payload ?? '',
            },)
        .toList();
  }

  // ── Private Helpers ───────────────────────────────────────────────────────

  static Future<void> _scheduleRaw({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required String channelId,
    required String channelName,
    required String payload,
    required List<AndroidNotificationAction> actions,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.high,
      priority: Priority.high,
      actions: actions,
    );
    final darwinDetails = DarwinNotificationDetails(
      categoryIdentifier: channelId,
    );
    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: matchDateTimeComponents,
    );
  }

  static List<AndroidNotificationAction> _taskActions() => const [
        AndroidNotificationAction(
          NotificationActions.complete,
          'Complete',
          showsUserInterface: false,
        ),
        AndroidNotificationAction(
          NotificationActions.snooze,
          'Snooze 10 min',
          showsUserInterface: false,
        ),
        AndroidNotificationAction(
          NotificationActions.open,
          'Open',
          showsUserInterface: true,
        ),
      ];

  static List<AndroidNotificationAction> _habitActions() => const [
        AndroidNotificationAction(
          NotificationActions.checkIn,
          'Check In',
          showsUserInterface: false,
        ),
        AndroidNotificationAction(
          NotificationActions.open,
          'Open',
          showsUserInterface: true,
        ),
      ];

  static int _taskNotifId(String id)  => id.hashCode.abs() % 10000;
  static int _habitNotifId(String id) => id.hashCode.abs() % 10000 + 10000;

  static int? _idFromPayload(String payload) {
    if (payload.startsWith('task:'))  return _taskNotifId(payload.substring(5));
    if (payload.startsWith('habit:')) return _habitNotifId(payload.substring(6));
    return null;
  }
}
