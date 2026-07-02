import '../../domain/entities/focus_session_entity.dart';

class FocusSessionModel {
  FocusSessionModel({
    required this.id,
    this.taskId,
    this.habitId,
    required this.sessionType,
    required this.durationMinutes,
    required this.actualDurationMinutes,
    required this.startTimeMs,
    required this.endTimeMs,
    required this.completed,
    required this.interrupted,
    required this.notes,
    required this.createdAtMs,
  });

  final String id;
  final String? taskId;
  final String? habitId;
  final String sessionType;
  final int durationMinutes;
  final int actualDurationMinutes;
  final int startTimeMs;
  final int endTimeMs;
  final bool completed;
  final bool interrupted;
  final String notes;
  final int createdAtMs;

  factory FocusSessionModel.fromEntity(FocusSessionEntity entity) {
    return FocusSessionModel(
      id: entity.id,
      taskId: entity.taskId,
      habitId: entity.habitId,
      sessionType: entity.sessionType,
      durationMinutes: entity.durationMinutes,
      actualDurationMinutes: entity.actualDurationMinutes,
      startTimeMs: entity.startTime.millisecondsSinceEpoch,
      endTimeMs: entity.endTime.millisecondsSinceEpoch,
      completed: entity.completed,
      interrupted: entity.interrupted,
      notes: entity.notes,
      createdAtMs: entity.createdAt.millisecondsSinceEpoch,
    );
  }

  FocusSessionEntity toEntity() {
    return FocusSessionEntity(
      id: id,
      taskId: taskId,
      habitId: habitId,
      sessionType: sessionType,
      durationMinutes: durationMinutes,
      actualDurationMinutes: actualDurationMinutes,
      startTime: DateTime.fromMillisecondsSinceEpoch(startTimeMs),
      endTime: DateTime.fromMillisecondsSinceEpoch(endTimeMs),
      completed: completed,
      interrupted: interrupted,
      notes: notes,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
    );
  }
}
