part of 'habit_entity.dart';

mixin _$HabitEntity {
  String get id => throw UnsupportedError();
  String get title => throw UnsupportedError();
  String get description => throw UnsupportedError();
  String get icon => throw UnsupportedError();
  int get color => throw UnsupportedError();
  String get frequency => throw UnsupportedError();
  int get targetCount => throw UnsupportedError();
  int get currentCount => throw UnsupportedError();
  bool get completedToday => throw UnsupportedError();
  int get currentStreak => throw UnsupportedError();
  int get longestStreak => throw UnsupportedError();
  DateTime get createdAt => throw UnsupportedError();
  DateTime get updatedAt => throw UnsupportedError();
  Map<String, int> get completionHistory => throw UnsupportedError();

  HabitEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? color,
    String? frequency,
    int? targetCount,
    int? currentCount,
    bool? completedToday,
    int? currentStreak,
    int? longestStreak,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, int>? completionHistory,
  }) => throw UnsupportedError();
}

class _HabitEntity implements HabitEntity {
  const _HabitEntity({
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
    required this.createdAt,
    required this.updatedAt,
    required this.completionHistory,
  });

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String icon;
  @override
  final int color;
  @override
  final String frequency;
  @override
  final int targetCount;
  @override
  final int currentCount;
  @override
  final bool completedToday;
  @override
  final int currentStreak;
  @override
  final int longestStreak;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final Map<String, int> completionHistory;

  @override
  HabitEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? color,
    String? frequency,
    int? targetCount,
    int? currentCount,
    bool? completedToday,
    int? currentStreak,
    int? longestStreak,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, int>? completionHistory,
  }) {
    return _HabitEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      completedToday: completedToday ?? this.completedToday,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completionHistory: completionHistory ?? this.completionHistory,
    );
  }

  @override
  String toString() {
    return 'HabitEntity(id: $id, title: $title, description: $description, icon: $icon, color: $color, frequency: $frequency, targetCount: $targetCount, currentCount: $currentCount, completedToday: $completedToday, currentStreak: $currentStreak, longestStreak: $longestStreak, createdAt: $createdAt, updatedAt: $updatedAt, completionHistory: $completionHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HabitEntity &&
            other.id == id &&
            other.title == title &&
            other.description == description &&
            other.icon == icon &&
            other.color == color &&
            other.frequency == frequency &&
            other.targetCount == targetCount &&
            other.currentCount == currentCount &&
            other.completedToday == completedToday &&
            other.currentStreak == currentStreak &&
            other.longestStreak == longestStreak &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt &&
            other.completionHistory == completionHistory);
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        id,
        title,
        description,
        icon,
        color,
        frequency,
        targetCount,
        currentCount,
        completedToday,
        currentStreak,
        longestStreak,
        createdAt,
        updatedAt,
        completionHistory,
      );
}
