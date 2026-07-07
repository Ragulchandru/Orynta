// lib/features/planner/data/models/task_model.dart
//
// Orynta 2.0 — Task Model for Hive Storage

import '../../domain/entities/subtask_entity.dart';
import '../../domain/entities/task_attachment_entity.dart';
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
    this.category = 'Personal',
    this.subtasksRaw = const [],
    this.reminderMs,
    this.earlyReminderMinutes,
    this.recurrenceRule,
    this.attachmentsRaw = const [],
    this.isFavorite = false,
    this.notes,
    this.sortOrder = 0,
    this.linkedNoteIds = const [],
    this.dueTimeMs,
    this.isArchived = false,
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
  final String category;
  final List<Map<String, dynamic>> subtasksRaw;
  final int? reminderMs;
  final int? earlyReminderMinutes;
  final String? recurrenceRule;
  final List<Map<String, dynamic>> attachmentsRaw;
  final bool isFavorite;
  final String? notes;
  final int sortOrder;
  final List<String> linkedNoteIds;
  final int? dueTimeMs;
  final bool isArchived;

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
      category: entity.category,
      subtasksRaw: entity.subtasks
          .map((s) => {
                'id': s.id,
                'title': s.title,
                'isCompleted': s.isCompleted,
              },)
          .toList(),
      reminderMs: entity.reminderMs,
      earlyReminderMinutes: entity.earlyReminderMinutes,
      recurrenceRule: entity.recurrenceRule,
      attachmentsRaw: entity.attachments
          .map((a) => {
                'id': a.id,
                'filePath': a.filePath,
                'fileName': a.fileName,
                'fileType': a.fileType,
                'sizeBytes': a.sizeBytes,
              },)
          .toList(),
      isFavorite: entity.isFavorite,
      notes: entity.notes,
      sortOrder: entity.sortOrder,
      linkedNoteIds: entity.linkedNoteIds,
      dueTimeMs: entity.dueTimeMs,
      isArchived: entity.isArchived,
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
      category: category,
      subtasks: subtasksRaw
          .map((m) => SubtaskEntity(
                id: m['id'] as String? ?? '',
                title: m['title'] as String? ?? '',
                isCompleted: m['isCompleted'] as bool? ?? false,
              ),)
          .toList(),
      reminderMs: reminderMs,
      earlyReminderMinutes: earlyReminderMinutes,
      recurrenceRule: recurrenceRule,
      attachments: attachmentsRaw
          .map((m) => TaskAttachmentEntity(
                id: m['id'] as String? ?? '',
                filePath: m['filePath'] as String? ?? '',
                fileName: m['fileName'] as String? ?? '',
                fileType: m['fileType'] as String? ?? '',
                sizeBytes: m['sizeBytes'] as int? ?? 0,
              ),)
          .toList(),
      isFavorite: isFavorite,
      notes: notes,
      sortOrder: sortOrder,
      linkedNoteIds: linkedNoteIds.isNotEmpty
          ? linkedNoteIds
          : (linkedNoteId != null ? [linkedNoteId!] : const []),
      dueTimeMs: dueTimeMs,
      isArchived: isArchived,
    );
  }
}
