// lib/features/planner/domain/services/planner_notification_service.dart
//
// Orynta 2.0 — Local Reminders & Notifications Service Architecture

import 'package:flutter/material.dart';

class PlannerNotificationService {
  const PlannerNotificationService();

  static Future<void> scheduleTaskReminder({
    required String taskId,
    required String taskTitle,
    required DateTime reminderTime,
    int? earlyMinutes,
  }) async {
    final effectiveTime = earlyMinutes != null
        ? reminderTime.subtract(Duration(minutes: earlyMinutes))
        : reminderTime;

    debugPrint(
      '[PlannerNotificationService] Scheduled reminder for "$taskTitle" at $effectiveTime (Early $earlyMinutes mins)',
    );
  }

  static Future<void> cancelTaskReminder(String taskId) async {
    debugPrint('[PlannerNotificationService] Cancelled reminder for taskId: $taskId');
  }

  static Future<void> cancelAllReminders() async {
    debugPrint('[PlannerNotificationService] Cancelled all scheduled task alarms.');
  }

  static Future<void> snoozeTaskReminder(String taskId, Duration snoozeDuration) async {
    final nextTime = DateTime.now().add(snoozeDuration);
    debugPrint('[PlannerNotificationService] Snoozed taskId $taskId until $nextTime');
  }
}
