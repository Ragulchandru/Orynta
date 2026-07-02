import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/hive_type_ids.dart';
import 'task_model.dart';

class TaskTypeAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = HiveTypeIds.task;

  @override
  TaskModel read(BinaryReader reader) {
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
  }
}
