import '../../domain/entities/task_entity.dart';

class TaskModel {
  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.dueDateMs,
    required this.createdAtMs,
    required this.updatedAtMs,
    required this.isCompleted,
    required this.timelineSection,
    required this.estimatedMinutes,
    required this.tagIds,
    this.linkedNoteId,
  });

  final String id;
  final String title;
  final String description;
  final String priority;
  final int? dueDateMs;
  final int createdAtMs;
  final int updatedAtMs;
  final bool isCompleted;
  final int timelineSection;
  final int estimatedMinutes;
  final List<String> tagIds;
  final String? linkedNoteId;

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      priority: entity.priority,
      dueDateMs: entity.dueDate?.millisecondsSinceEpoch,
      createdAtMs: entity.createdAt.millisecondsSinceEpoch,
      updatedAtMs: entity.updatedAt.millisecondsSinceEpoch,
      isCompleted: entity.isCompleted,
      timelineSection: entity.timelineSection,
      estimatedMinutes: entity.estimatedMinutes,
      tagIds: entity.tagIds,
      linkedNoteId: entity.linkedNoteId,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDateMs != null ? DateTime.fromMillisecondsSinceEpoch(dueDateMs!) : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      isCompleted: isCompleted,
      timelineSection: timelineSection,
      estimatedMinutes: estimatedMinutes,
      tagIds: tagIds,
      linkedNoteId: linkedNoteId,
    );
  }
}
