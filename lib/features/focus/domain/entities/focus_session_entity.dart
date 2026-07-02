import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_session_entity.freezed.dart';

@freezed
class FocusSessionEntity with _$FocusSessionEntity {
  const factory FocusSessionEntity({
    required String id,
    String? taskId,
    String? habitId,
    required String sessionType,
    required int durationMinutes,
    required int actualDurationMinutes,
    required DateTime startTime,
    required DateTime endTime,
    required bool completed,
    required bool interrupted,
    required String notes,
    required DateTime createdAt,
  }) = _FocusSessionEntity;
}
