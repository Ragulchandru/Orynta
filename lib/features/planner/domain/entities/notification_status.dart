// lib/features/planner/domain/entities/notification_status.dart
//
// Orynta 2.0 — NotificationStatus enum
// Every task reminder belongs to exactly ONE status at any point in time.

enum NotificationStatus {
  /// Reminder is scheduled and fires in the future.
  upcoming,

  /// Reminder time has passed and the task is still incomplete.
  missed,

  /// Task has been marked as completed.
  completed,

  /// Reminder was explicitly cancelled by the user.
  cancelled,
}
