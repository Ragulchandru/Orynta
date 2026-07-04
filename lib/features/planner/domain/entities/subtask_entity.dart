// lib/features/planner/domain/entities/subtask_entity.dart
//
// Orynta 2.0 — Subtask Entity

import 'package:flutter/foundation.dart';

@immutable
class SubtaskEntity {
  const SubtaskEntity({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final bool isCompleted;

  SubtaskEntity copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return SubtaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubtaskEntity &&
        other.id == id &&
        other.title == title &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => Object.hash(id, title, isCompleted);
}
