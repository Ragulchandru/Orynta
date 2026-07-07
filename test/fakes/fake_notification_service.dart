// test/fakes/fake_notification_service.dart

import 'package:orynta/features/planner/domain/services/notification_service.dart';

class FakeNotificationService implements NotificationService {
  final List<String> scheduledTaskIds = [];
  final List<String> cancelledTaskIds = [];
  final List<String> scheduledHabitIds = [];
  final List<String> cancelledHabitIds = [];

  @override
  Future<void> scheduleTaskReminder({
    required String taskId,
    required String taskTitle,
    required DateTime reminderTime,
    required int earlyMinutes,
    required String repeatInterval,
  }) async {
    scheduledTaskIds.add(taskId);
  }

  @override
  Future<void> cancelTaskReminder(String taskId) async {
    cancelledTaskIds.add(taskId);
  }

  @override
  Future<void> scheduleHabitReminder({
    required String habitId,
    required String habitTitle,
    required String reminderType,
    String? customTime,
  }) async {
    scheduledHabitIds.add(habitId);
  }

  @override
  Future<void> cancelHabitReminder(String habitId) async {
    cancelledHabitIds.add(habitId);
  }
}
