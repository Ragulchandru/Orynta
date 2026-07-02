import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';

@freezed
class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    required String id,
    required String title,
    required String description,
    required String priority, // "low", "medium", "high"
    required DateTime? dueDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isCompleted,
    required int timelineSection, // 0 = Morning, 1 = Afternoon, 2 = Evening, 3 = Night
    required int estimatedMinutes,
    required List<String> tagIds,
    String? linkedNoteId,
  }) = _TaskEntity;
}
