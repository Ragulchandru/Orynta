import '../../domain/entities/habit_entity.dart';

class HabitModel {
  HabitModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.frequency,
    required this.targetCount,
    required this.currentCount,
    required this.completedToday,
    required this.currentStreak,
    required this.longestStreak,
    required this.createdAtMs,
    required this.updatedAtMs,
    required this.completionHistory,
  });

  final String id;
  final String title;
  final String description;
  final String icon;
  final int color;
  final String frequency;
  final int targetCount;
  final int currentCount;
  final bool completedToday;
  final int currentStreak;
  final int longestStreak;
  final int createdAtMs;
  final int updatedAtMs;
  final Map<String, int> completionHistory;

  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      icon: entity.icon,
      color: entity.color,
      frequency: entity.frequency,
      targetCount: entity.targetCount,
      currentCount: entity.currentCount,
      completedToday: entity.completedToday,
      currentStreak: entity.currentStreak,
      longestStreak: entity.longestStreak,
      createdAtMs: entity.createdAt.millisecondsSinceEpoch,
      updatedAtMs: entity.updatedAt.millisecondsSinceEpoch,
      completionHistory: entity.completionHistory,
    );
  }

  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      title: title,
      description: description,
      icon: icon,
      color: color,
      frequency: frequency,
      targetCount: targetCount,
      currentCount: currentCount,
      completedToday: completedToday,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      completionHistory: Map<String, int>.from(completionHistory),
    );
  }
}
