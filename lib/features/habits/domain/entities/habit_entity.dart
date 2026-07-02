import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_entity.freezed.dart';

@freezed
class HabitEntity with _$HabitEntity {
  const factory HabitEntity({
    required String id,
    required String title,
    required String description,
    required String icon,
    required int color,
    required String frequency,
    required int targetCount,
    required int currentCount,
    required bool completedToday,
    required int currentStreak,
    required int longestStreak,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Map<String, int> completionHistory,
  }) = _HabitEntity;
}
