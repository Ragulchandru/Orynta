// lib/features/planner/domain/entities/task_entity.dart
//
// Orynta 2.0 — Extended Task Entity (Pure Immutable Dart Model)

import 'package:flutter/foundation.dart';

import 'subtask_entity.dart';
import 'task_attachment_entity.dart';

@immutable
class TaskEntity {
  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.priority, // "low", "medium", "high"
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.isCompleted,
    required this.timelineSection, // 0 = Morning, 1 = Afternoon, 2 = Evening, 3 = Night
    required this.estimatedMinutes,
    required this.tagIds,
    this.linkedNoteId,
    this.category = 'Personal',
    this.subtasks = const [],
    this.reminderMs,
    this.earlyReminderMinutes,
    this.recurrenceRule,
    this.attachments = const [],
    this.isFavorite = false,
    this.notes,
    this.sortOrder = 0,
    this.linkedNoteIds = const [],
    this.dueTimeMs,
  });

  final String id;
  final String title;
  final String description;
  final String priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCompleted;
  final int timelineSection;
  final int estimatedMinutes;
  final List<String> tagIds;
  final String? linkedNoteId;
  final String category;
  final List<SubtaskEntity> subtasks;
  final int? reminderMs;
  final int? earlyReminderMinutes;
  final String? recurrenceRule;
  final List<TaskAttachmentEntity> attachments;
  final bool isFavorite;
  final String? notes;
  final int sortOrder;
  final List<String> linkedNoteIds;
  final int? dueTimeMs;

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
    int? timelineSection,
    int? estimatedMinutes,
    List<String>? tagIds,
    String? linkedNoteId,
    String? category,
    List<SubtaskEntity>? subtasks,
    int? reminderMs,
    int? earlyReminderMinutes,
    String? recurrenceRule,
    List<TaskAttachmentEntity>? attachments,
    bool? isFavorite,
    String? notes,
    int? sortOrder,
    List<String>? linkedNoteIds,
    int? dueTimeMs,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      timelineSection: timelineSection ?? this.timelineSection,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      tagIds: tagIds ?? this.tagIds,
      linkedNoteId: linkedNoteId ?? this.linkedNoteId,
      category: category ?? this.category,
      subtasks: subtasks ?? this.subtasks,
      reminderMs: reminderMs ?? this.reminderMs,
      earlyReminderMinutes: earlyReminderMinutes ?? this.earlyReminderMinutes,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      attachments: attachments ?? this.attachments,
      isFavorite: isFavorite ?? this.isFavorite,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      linkedNoteIds: linkedNoteIds ?? this.linkedNoteIds,
      dueTimeMs: dueTimeMs ?? this.dueTimeMs,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskEntity && other.id == id && other.title == title;
  }

  @override
  int get hashCode => Object.hash(id, title);
}
