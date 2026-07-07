// lib/features/planner/domain/services/notification_service.dart

abstract class NotificationService {
  Future<void> scheduleTaskReminder({
    required String taskId,
    required String taskTitle,
    required DateTime reminderTime,
    required int earlyMinutes,
    required String repeatInterval,
  });

  Future<void> cancelTaskReminder(String taskId);

  Future<void> scheduleHabitReminder({
    required String habitId,
    required String habitTitle,
    required String reminderType,
    String? customTime,
  });

  Future<void> cancelHabitReminder(String habitId);
}
