import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/hive_type_ids.dart';
import 'habit_model.dart';

class HabitTypeAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = HiveTypeIds.habit;

  @override
  HabitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      icon: fields[3] as String,
      color: fields[4] as int,
      frequency: fields[5] as String,
      targetCount: fields[6] as int,
      currentCount: fields[7] as int,
      completedToday: fields[8] as bool,
      currentStreak: fields[9] as int,
      longestStreak: fields[10] as int,
      createdAtMs: fields[11] as int,
      updatedAtMs: fields[12] as int,
      completionHistory: (fields[13] as Map?)?.cast<String, int>() ?? {},
      reminderType: fields[14] as String?,
      customReminderTime: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.targetCount)
      ..writeByte(7)
      ..write(obj.currentCount)
      ..writeByte(8)
      ..write(obj.completedToday)
      ..writeByte(9)
      ..write(obj.currentStreak)
      ..writeByte(10)
      ..write(obj.longestStreak)
      ..writeByte(11)
      ..write(obj.createdAtMs)
      ..writeByte(12)
      ..write(obj.updatedAtMs)
      ..writeByte(13)
      ..write(obj.completionHistory)
      ..writeByte(14)
      ..write(obj.reminderType)
      ..writeByte(15)
      ..write(obj.customReminderTime);
  }
}
