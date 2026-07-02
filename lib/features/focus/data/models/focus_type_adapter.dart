import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/hive_type_ids.dart';
import 'focus_session_model.dart';

class FocusTypeAdapter extends TypeAdapter<FocusSessionModel> {
  @override
  final int typeId = HiveTypeIds.focusSession;

  @override
  FocusSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FocusSessionModel(
      id: fields[0] as String,
      taskId: fields[1] as String?,
      habitId: fields[2] as String?,
      sessionType: fields[3] as String,
      durationMinutes: fields[4] as int,
      actualDurationMinutes: fields[5] as int,
      startTimeMs: fields[6] as int,
      endTimeMs: fields[7] as int,
      completed: fields[8] as bool,
      interrupted: fields[9] as bool,
      notes: fields[10] as String,
      createdAtMs: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FocusSessionModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.habitId)
      ..writeByte(3)
      ..write(obj.sessionType)
      ..writeByte(4)
      ..write(obj.durationMinutes)
      ..writeByte(5)
      ..write(obj.actualDurationMinutes)
      ..writeByte(6)
      ..write(obj.startTimeMs)
      ..writeByte(7)
      ..write(obj.endTimeMs)
      ..writeByte(8)
      ..write(obj.completed)
      ..writeByte(9)
      ..write(obj.interrupted)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.createdAtMs);
  }
}
