// lib/features/planner/data/models/task_type_adapter.dart
//
// Orynta 2.0 — Backward-Compatible Task TypeAdapter for Hive Storage

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/hive_type_ids.dart';
import 'task_model.dart';

class TaskTypeAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = HiveTypeIds.task;

  @override
  TaskModel read(BinaryReader reader) {
    // Legacy positional slots 0 to 11
    final id = reader.readString();                              // slot 0
    final title = reader.readString();                          // slot 1
    final description = reader.readString();                    // slot 2
    final priority = reader.readString();                       // slot 3

    final hasDueDate = reader.readBool();                       // slot 4
    final dueDateMs = hasDueDate ? reader.readInt() : null;

    final createdAtMs = reader.readInt();                       // slot 5
    final updatedAtMs = reader.readInt();                       // slot 6
    final isCompleted = reader.readBool();                      // slot 7
    final timelineSection = reader.readInt();                   // slot 8
    final estimatedMinutes = reader.readInt();                  // slot 9

    final tagIdsCount = reader.readInt();                       // slot 10
    final tagIds = List<String>.generate(
      tagIdsCount,
      (_) => reader.readString(),
    );

    final hasLinkedNote = reader.readBool();                    // slot 11
    final linkedNoteId = hasLinkedNote ? reader.readString() : null;

    // Optional expanded slots for backward compatibility
    String category = 'Personal';
    List<Map<String, dynamic>> subtasksRaw = [];
    int? reminderMs;
    int? earlyReminderMinutes;
    String? recurrenceRule;
    List<Map<String, dynamic>> attachmentsRaw = [];
    bool isFavorite = false;
    String? notes;
    int sortOrder = 0;
    List<String> linkedNoteIds = [];
    int? dueTimeMs;

    if (reader.availableBytes > 0) {
      category = reader.readString();                           // slot 12
    }

    if (reader.availableBytes > 0) {
      final subtaskCount = reader.readInt();                    // slot 13
      subtasksRaw = List.generate(subtaskCount, (_) {
        return {
          'id': reader.readString(),
          'title': reader.readString(),
          'isCompleted': reader.readBool(),
        };
      });
    }

    if (reader.availableBytes > 0) {
      final hasReminder = reader.readBool();
      reminderMs = hasReminder ? reader.readInt() : null;
    }

    if (reader.availableBytes > 0) {
      final hasEarlyReminder = reader.readBool();
      earlyReminderMinutes = hasEarlyReminder ? reader.readInt() : null;
    }

    if (reader.availableBytes > 0) {
      final hasRecurrence = reader.readBool();
      recurrenceRule = hasRecurrence ? reader.readString() : null;
    }

    if (reader.availableBytes > 0) {
      final attachCount = reader.readInt();
      attachmentsRaw = List.generate(attachCount, (_) {
        return {
          'id': reader.readString(),
          'filePath': reader.readString(),
          'fileName': reader.readString(),
          'fileType': reader.readString(),
          'sizeBytes': reader.readInt(),
        };
      });
    }

    if (reader.availableBytes > 0) {
      isFavorite = reader.readBool();
    }

    if (reader.availableBytes > 0) {
      final hasNotes = reader.readBool();
      notes = hasNotes ? reader.readString() : null;
    }

    if (reader.availableBytes > 0) {
      sortOrder = reader.readInt();
    }

    if (reader.availableBytes > 0) {
      final linkedCount = reader.readInt();
      linkedNoteIds = List.generate(linkedCount, (_) => reader.readString());
    }

    if (reader.availableBytes > 0) {
      final hasDueTime = reader.readBool();
      dueTimeMs = hasDueTime ? reader.readInt() : null;
    }

    bool isArchived = false;
    if (reader.availableBytes > 0) {
      isArchived = reader.readBool();
    }

    String repeatReminderInterval = 'never';
    if (reader.availableBytes > 0) {
      repeatReminderInterval = reader.readString();
    }

    String? reminderStatus;
    if (reader.availableBytes > 0) {
      final has = reader.readBool();
      reminderStatus = has ? reader.readString() : null;
    }

    int? notificationId;
    if (reader.availableBytes > 0) {
      final has = reader.readBool();
      notificationId = has ? reader.readInt() : null;
    }

    return TaskModel(
      id: id,
      title: title,
      description: description,
      priority: priority,
      dueDateMs: dueDateMs,
      createdAtMs: createdAtMs,
      updatedAtMs: updatedAtMs,
      isCompleted: isCompleted,
      timelineSection: timelineSection,
      estimatedMinutes: estimatedMinutes,
      tagIds: tagIds,
      linkedNoteId: linkedNoteId,
      category: category,
      subtasksRaw: subtasksRaw,
      reminderMs: reminderMs,
      earlyReminderMinutes: earlyReminderMinutes,
      recurrenceRule: recurrenceRule,
      attachmentsRaw: attachmentsRaw,
      isFavorite: isFavorite,
      notes: notes,
      sortOrder: sortOrder,
      linkedNoteIds: linkedNoteIds,
      dueTimeMs: dueTimeMs,
      isArchived: isArchived,
      repeatReminderInterval: repeatReminderInterval,
      reminderStatus: reminderStatus,
      notificationId: notificationId,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeString(obj.id);                                 // slot 0
    writer.writeString(obj.title);                             // slot 1
    writer.writeString(obj.description);                        // slot 2
    writer.writeString(obj.priority);                           // slot 3

    writer.writeBool(obj.dueDateMs != null);                    // slot 4
    if (obj.dueDateMs != null) writer.writeInt(obj.dueDateMs!);

    writer.writeInt(obj.createdAtMs);                          // slot 5
    writer.writeInt(obj.updatedAtMs);                          // slot 6
    writer.writeBool(obj.isCompleted);                         // slot 7
    writer.writeInt(obj.timelineSection);                      // slot 8
    writer.writeInt(obj.estimatedMinutes);                     // slot 9

    writer.writeInt(obj.tagIds.length);                        // slot 10
    for (final tagId in obj.tagIds) {
      writer.writeString(tagId);
    }

    writer.writeBool(obj.linkedNoteId != null);                 // slot 11
    if (obj.linkedNoteId != null) writer.writeString(obj.linkedNoteId!);

    // Expanded slots
    writer.writeString(obj.category);                           // slot 12

    writer.writeInt(obj.subtasksRaw.length);                    // slot 13
    for (final s in obj.subtasksRaw) {
      writer.writeString(s['id'] as String? ?? '');
      writer.writeString(s['title'] as String? ?? '');
      writer.writeBool(s['isCompleted'] as bool? ?? false);
    }

    writer.writeBool(obj.reminderMs != null);
    if (obj.reminderMs != null) writer.writeInt(obj.reminderMs!);

    writer.writeBool(obj.earlyReminderMinutes != null);
    if (obj.earlyReminderMinutes != null) writer.writeInt(obj.earlyReminderMinutes!);

    writer.writeBool(obj.recurrenceRule != null);
    if (obj.recurrenceRule != null) writer.writeString(obj.recurrenceRule!);

    writer.writeInt(obj.attachmentsRaw.length);
    for (final a in obj.attachmentsRaw) {
      writer.writeString(a['id'] as String? ?? '');
      writer.writeString(a['filePath'] as String? ?? '');
      writer.writeString(a['fileName'] as String? ?? '');
      writer.writeString(a['fileType'] as String? ?? '');
      writer.writeInt(a['sizeBytes'] as int? ?? 0);
    }

    writer.writeBool(obj.isFavorite);

    writer.writeBool(obj.notes != null);
    if (obj.notes != null) writer.writeString(obj.notes!);

    writer.writeInt(obj.sortOrder);

    writer.writeInt(obj.linkedNoteIds.length);
    for (final noteId in obj.linkedNoteIds) {
      writer.writeString(noteId);
    }

    writer.writeBool(obj.dueTimeMs != null);
    if (obj.dueTimeMs != null) writer.writeInt(obj.dueTimeMs!);

    writer.writeBool(obj.isArchived);
    writer.writeString(obj.repeatReminderInterval ?? 'never');

    writer.writeBool(obj.reminderStatus != null);
    if (obj.reminderStatus != null) writer.writeString(obj.reminderStatus!);

    writer.writeBool(obj.notificationId != null);
    if (obj.notificationId != null) writer.writeInt(obj.notificationId!);
  }
}
