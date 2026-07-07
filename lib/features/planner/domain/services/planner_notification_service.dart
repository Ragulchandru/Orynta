// lib/features/planner/domain/services/planner_notification_service.dart
//
// Orynta 2.0 — Production Notification Engine
// Uses flutter_local_notifications for real scheduled local notifications.
// Supports: Tasks, Habits, Focus Sessions, Daily Summaries, Reboot Recovery.
// Action IDs: complete, snooze, open

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' hide Priority;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../entities/task_entity.dart';
import 'notification_service.dart';
import '../../presentation/providers/tasks_notifier.dart';
import '../../../../core/router/app_router.dart';

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

  static ProviderContainer? container;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialised = false;

  // ── Diagnostics & Lifecycle logs ──────────────────────────────────────────
  static final List<String> logs = [];
  static String? lastDeliveredNotification;
  static String? lastTappedNotification;
  static String? lastSchedulingError;


  static void logEvent(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final logLine = '[$timestamp] $message';
    logs.add(logLine);
    if (kDebugMode) debugPrint(logLine);
    if (logs.length > 200) logs.removeAt(0);
  }

  // ── Foreground notification broadcast stream ─────────────────────────────
  //
  // Events are only pushed when the app is currently resumed (foreground).
  // Widgets such as InAppNotificationOverlay listen to this stream to render
  // in-app banner cards without relying on the OS notification shade.
  static final StreamController<TaskEntity> _foregroundStreamController =
      StreamController<TaskEntity>.broadcast();

  static Stream<TaskEntity> get foregroundNotificationStream =>
      _foregroundStreamController.stream;

  static void _emitForeground(TaskEntity task) {
    final lifecycle = SchedulerBinding.instance.lifecycleState;
    if (lifecycle == AppLifecycleState.resumed) {
      if (kDebugMode) {
        debugPrint('[Notification] Delivered (foreground): ${task.title}');
      }
      _foregroundStreamController.add(task);
    }
  }

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
    logEvent('Notification Scheduled | Engine Initialized');
  }


  // ── Permission ────────────────────────────────────────────────────────────

  /// Request exact-alarm / notification permissions. Returns true if granted.
  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      // POST_NOTIFICATIONS — Android 13+
      final granted = await android.requestNotificationsPermission();
      if (granted == false) {
        logEvent('Permission request denied: Notifications');
      }
      // Exact Alarm — Android 12+ (SCHEDULE_EXACT_ALARM)
      final canExact = await android.canScheduleExactNotifications() ?? false;
      if (!canExact) {
        await android.requestExactAlarmsPermission();
      }
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
      if (granted == false) {
        logEvent('Permission request denied: iOS Alert/Badge/Sound');
      }
      return granted ?? false;
    }
    return false;
  }

  /// Request permissions. Directs user to settings with a custom dialog if denied.
  static Future<bool> checkAndRequestPermissions(BuildContext context) async {
    // 1. Check & Request standard notification permission
    final status = await Permission.notification.status;
    if (status.isDenied) {
      final requested = await Permission.notification.request();
      if (requested.isDenied) {
        logEvent('Permission request denied: Notifications via Settings check');
        if (context.mounted) _showSettingsDialog(context);
        return false;
      }
    }

    // 2. Check & Request exact alarm permission (Android 12+)
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final hasExact = await android.canScheduleExactNotifications() ?? false;
      if (!hasExact) {
        await android.requestExactAlarmsPermission();
        final verified = await android.canScheduleExactNotifications() ?? false;
        if (!verified) {
          logEvent('Permission request denied: Exact Alarms');
          if (context.mounted) _showSettingsDialog(context);
          return false;
        }
      }
    }
    return true;
  }

  static void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
              SizedBox(width: 8),
              Text('Permissions Required'),
            ],
          ),
          content: const Text(
            'Notifications disabled.\n\nEnable alarms and notifications in Settings to get reliable alerts for your reminders.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: colors.outline)),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
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

    logEvent('Notification Clicked: "$payload" | Action: "$actionId"');
    lastTappedNotification = 'Payload: "$payload", Action: "$actionId", Time: ${DateTime.now().toIso8601String().substring(11, 19)}';

    // When there is no actionId, this is a foreground delivery event.
    // Emit the task to the in-app overlay stream.
    if (actionId.isEmpty && payload.startsWith('task:')) {
      final taskId = payload.substring(5);
      if (container != null) {
        try {
          final tasks = container!.read(tasksProvider);
          final task = tasks.firstWhere(
            (t) => t.id == taskId,
            orElse: () => throw StateError('Task not found'),
          );
          _emitForeground(task);
        } catch (_) {
          // Task not found — skip foreground banner.
        }
      }
      return;
    }

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
    logEvent('Notification Completed: Task completed from notification shade action for $payload');
    if (container != null) {
      container!.read(tasksNotifierProvider.notifier).toggleTaskCompletion(payload);
    }
  }

  static void _handleCheckIn(String payload) {
    debugPrint('[PlannerNotificationService] Check-in action for: $payload');
    // Habit check-in logic if needed in the future
  }

  static void _handleSnooze(String payload) {
    if (kDebugMode) debugPrint('[Notification] Snoozed: $payload');
    // Reschedule 10 minutes from now
    final snoozedTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 10));
    final id = _idFromPayload(payload);
    if (id != null) {
      logEvent('Notification Snoozed: Task snoozed for 10 minutes, ID: $id');
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
    if (kDebugMode) debugPrint('[Notification] Tapped: $payload');
    if (container != null) {
      container!.read(appRouterProvider).push('/tasks/$payload');
    }
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

  /// Schedule a reminder using the task's stored [TaskEntity.notificationId].
  ///
  /// Steps:
  ///   1. Cancel any existing notification for this task by its stored ID.
  ///   2. Schedule the new zonedSchedule notification.
  static Future<void> scheduleTaskReminderStatic({
    required String taskId,
    required String taskTitle,
    required DateTime reminderTime,
    int? earlyMinutes,
    String? repeatInterval,
    int? storedNotificationId,
  }) async {
    if (_isQuietNow()) {
      if (kDebugMode) debugPrint('[Notification] Quiet hours — skipped task: $taskId');
      return;
    }

    final effectiveTime = earlyMinutes != null
        ? reminderTime.subtract(Duration(minutes: earlyMinutes))
        : reminderTime;

    if (effectiveTime.isBefore(DateTime.now())) {
      if (kDebugMode) debugPrint('[Notification] Reminder is in the past — skipped.');
      return;
    }

    final tzTime = tz.TZDateTime.from(effectiveTime, tz.local);

    // Use stored stable ID. Fall back to FNV-1a if not yet persisted
    // (e.g. old tasks created before this field was introduced).
    final notifId = storedNotificationId ?? fnv1a32(taskId);

    // Step 1: Cancel existing notification to avoid duplicates.
    await _plugin.cancel(notifId);

    try {
      // Step 2: Schedule new notification.
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

      logEvent('Notification Scheduled: ID $notifId - "$taskTitle" at $tzTime');
    } catch (e) {
      lastSchedulingError = e.toString();
      logEvent('Notification scheduling failed: ID $notifId - Error: $e');
    }

  }

  static Future<void> cancelTaskReminderStatic(String taskId, {int? storedNotificationId}) async {
    final notifId = storedNotificationId ?? fnv1a32(taskId);
    await _plugin.cancel(notifId);
    logEvent('Notification Cancelled: ID $notifId for task $taskId');
  }


  static Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
    debugPrint('[PlannerNotificationService] Cancelled all reminders.');
  }

  static Future<void> snoozeTaskReminder(String taskId, Duration snoozeDuration, {int? storedNotificationId}) async {
    final nextTime  = tz.TZDateTime.now(tz.local).add(snoozeDuration);
    final notifId   = storedNotificationId ?? fnv1a32(taskId);

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

    if (kDebugMode) debugPrint('[Notification] Snoozed: $taskId until $nextTime');
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

  static Future<void> showTestImmediateNotification() async {
    await _scheduleRaw(
      id: 99999,
      title: '⚡ Test Immediate Alert',
      body: 'This is an immediate diagnostic notification from Orynta developer settings.',
      scheduledDate: tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
      channelId: _Channels.systemChannelId,
      channelName: _Channels.systemChannelName,
      payload: 'system:test_immediate',
      actions: [],
    );
    logEvent('Sent Immediate Test Notification');
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
    // Android custom sound: resource name ONLY (no extension).
    // Android resource identifiers (e.g. R.raw.orynta_alert) ignore file extensions.
    // Therefore, only one format (orynta_alert.mp3) must exist in res/raw.
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      enableLights: true,
      ledColor: const Color(0xFF6200EE),
      ledOnMs: 1000,
      ledOffMs: 1000,
      actions: actions,
      playSound: true,
      enableVibration: true,
      sound: const RawResourceAndroidNotificationSound('orynta_alert'),
    );
    // iOS custom sound: must specify the full filename including the format extension.
    final darwinDetails = DarwinNotificationDetails(
      categoryIdentifier: channelId,
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
      sound: 'orynta_alert.wav',
    );
    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );


    try {
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
    } catch (e) {
      lastSchedulingError = e.toString();
      logEvent('Channel creation failed or raw zonedSchedule failed: $e');
      rethrow;
    }

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

  // ── Private ID Helpers ────────────────────────────────────────────────────
  //
  // These helpers exist only for the habit channel (which still uses the
  // legacy pattern) and for payload parsing in _handleSnooze.
  // Task notification IDs are ALWAYS read from TaskEntity.notificationId.

  static int _habitNotifId(String id) => fnv1a32('habit:$id');

  static int? _idFromPayload(String payload) {
    if (payload.startsWith('task:'))  return fnv1a32(payload.substring(5));
    if (payload.startsWith('habit:')) return _habitNotifId(payload.substring(6));
    return null;
  }
}
