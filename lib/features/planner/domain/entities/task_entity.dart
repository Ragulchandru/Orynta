// lib/features/planner/domain/entities/task_entity.dart
//
// Orynta 2.0 — Extended Task Entity (Pure Immutable Dart Model)

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'notification_status.dart';
import 'subtask_entity.dart';
import 'task_attachment_entity.dart';

// ─── Stable Notification ID ───────────────────────────────────────────────────
//
// FNV-1a 32-bit hash — deterministic and platform-independent.
// String.hashCode is NOT used here because it is not guaranteed to be stable
// across Dart VM restarts or different platforms.
//
// This function is called ONCE at task creation time.  The result is stored
// as `notificationId` inside the task and persisted to Hive.  It is NEVER
// recalculated from the task ID at runtime.
int fnv1a32(String input) {
  var hash = 0x811c9dc5;
  for (final byte in utf8.encode(input)) {
    hash ^= byte;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  // Clamp to signed 32-bit to satisfy flutter_local_notifications.
  return hash > 0x7FFFFFFF ? hash - 0x100000000 : hash;
}

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
    this.isArchived = false,
    this.repeatReminderInterval = 'never',
    // ── New fields ───────────────────────────────────────────────────────────
    this.reminderStatus,
    this.notificationId,
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
  final bool isArchived;
  final String? repeatReminderInterval;

  /// Explicit reminder status string — `'cancelled'` when the user cancels the
  /// alert, `null` otherwise (status is computed from other fields).
  final String? reminderStatus;

  /// Stable integer used as the flutter_local_notifications notification ID.
  /// Generated ONCE via [fnv1a32] at creation time and stored in Hive.
  /// NEVER re-derived from [id] at runtime.
  final int? notificationId;

  // ─── Computed notification status ──────────────────────────────────────────

  NotificationStatus get computedNotificationStatus {
    if (isCompleted) return NotificationStatus.completed;
    if (reminderStatus == 'cancelled') return NotificationStatus.cancelled;
    if (reminderMs == null) return NotificationStatus.cancelled;
    final now = DateTime.now().millisecondsSinceEpoch;
    return reminderMs! > now
        ? NotificationStatus.upcoming
        : NotificationStatus.missed;
  }

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
    bool? isArchived,
    String? repeatReminderInterval,
    String? reminderStatus,
    int? notificationId,
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
      isArchived: isArchived ?? this.isArchived,
      repeatReminderInterval:
          repeatReminderInterval ?? this.repeatReminderInterval,
      reminderStatus: reminderStatus ?? this.reminderStatus,
      notificationId: notificationId ?? this.notificationId,
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
