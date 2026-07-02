// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TaskEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get priority =>
      throw _privateConstructorUsedError; // "low", "medium", "high"
  DateTime? get dueDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  int get timelineSection =>
      throw _privateConstructorUsedError; // 0 = Morning, 1 = Afternoon, 2 = Evening, 3 = Night
  int get estimatedMinutes => throw _privateConstructorUsedError;
  List<String> get tagIds => throw _privateConstructorUsedError;
  String? get linkedNoteId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TaskEntityCopyWith<TaskEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskEntityCopyWith<$Res> {
  factory $TaskEntityCopyWith(
          TaskEntity value, $Res Function(TaskEntity) then) =
      _$TaskEntityCopyWithImpl<$Res, TaskEntity>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String priority,
      DateTime? dueDate,
      DateTime createdAt,
      DateTime updatedAt,
      bool isCompleted,
      int timelineSection,
      int estimatedMinutes,
      List<String> tagIds,
      String? linkedNoteId});
}

/// @nodoc
class _$TaskEntityCopyWithImpl<$Res, $Val extends TaskEntity>
    implements $TaskEntityCopyWith<$Res> {
  _$TaskEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? dueDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isCompleted = null,
    Object? timelineSection = null,
    Object? estimatedMinutes = null,
    Object? tagIds = null,
    Object? linkedNoteId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      timelineSection: null == timelineSection
          ? _value.timelineSection
          : timelineSection // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedMinutes: null == estimatedMinutes
          ? _value.estimatedMinutes
          : estimatedMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      tagIds: null == tagIds
          ? _value.tagIds
          : tagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      linkedNoteId: freezed == linkedNoteId
          ? _value.linkedNoteId
          : linkedNoteId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskEntityImplCopyWith<$Res>
    implements $TaskEntityCopyWith<$Res> {
  factory _$$TaskEntityImplCopyWith(
          _$TaskEntityImpl value, $Res Function(_$TaskEntityImpl) then) =
      __$$TaskEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String priority,
      DateTime? dueDate,
      DateTime createdAt,
      DateTime updatedAt,
      bool isCompleted,
      int timelineSection,
      int estimatedMinutes,
      List<String> tagIds,
      String? linkedNoteId});
}

/// @nodoc
class __$$TaskEntityImplCopyWithImpl<$Res>
    extends _$TaskEntityCopyWithImpl<$Res, _$TaskEntityImpl>
    implements _$$TaskEntityImplCopyWith<$Res> {
  __$$TaskEntityImplCopyWithImpl(
      _$TaskEntityImpl _value, $Res Function(_$TaskEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? dueDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isCompleted = null,
    Object? timelineSection = null,
    Object? estimatedMinutes = null,
    Object? tagIds = null,
    Object? linkedNoteId = freezed,
  }) {
    return _then(_$TaskEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      timelineSection: null == timelineSection
          ? _value.timelineSection
          : timelineSection // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedMinutes: null == estimatedMinutes
          ? _value.estimatedMinutes
          : estimatedMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      tagIds: null == tagIds
          ? _value._tagIds
          : tagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      linkedNoteId: freezed == linkedNoteId
          ? _value.linkedNoteId
          : linkedNoteId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TaskEntityImpl implements _TaskEntity {
  const _$TaskEntityImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.priority,
      required this.dueDate,
      required this.createdAt,
      required this.updatedAt,
      required this.isCompleted,
      required this.timelineSection,
      required this.estimatedMinutes,
      required final List<String> tagIds,
      this.linkedNoteId})
      : _tagIds = tagIds;

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String priority;
// "low", "medium", "high"
  @override
  final DateTime? dueDate;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool isCompleted;
  @override
  final int timelineSection;
// 0 = Morning, 1 = Afternoon, 2 = Evening, 3 = Night
  @override
  final int estimatedMinutes;
  final List<String> _tagIds;
  @override
  List<String> get tagIds {
    if (_tagIds is EqualUnmodifiableListView) return _tagIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagIds);
  }

  @override
  final String? linkedNoteId;

  @override
  String toString() {
    return 'TaskEntity(id: $id, title: $title, description: $description, priority: $priority, dueDate: $dueDate, createdAt: $createdAt, updatedAt: $updatedAt, isCompleted: $isCompleted, timelineSection: $timelineSection, estimatedMinutes: $estimatedMinutes, tagIds: $tagIds, linkedNoteId: $linkedNoteId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.timelineSection, timelineSection) ||
                other.timelineSection == timelineSection) &&
            (identical(other.estimatedMinutes, estimatedMinutes) ||
                other.estimatedMinutes == estimatedMinutes) &&
            const DeepCollectionEquality().equals(other._tagIds, _tagIds) &&
            (identical(other.linkedNoteId, linkedNoteId) ||
                other.linkedNoteId == linkedNoteId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      priority,
      dueDate,
      createdAt,
      updatedAt,
      isCompleted,
      timelineSection,
      estimatedMinutes,
      const DeepCollectionEquality().hash(_tagIds),
      linkedNoteId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskEntityImplCopyWith<_$TaskEntityImpl> get copyWith =>
      __$$TaskEntityImplCopyWithImpl<_$TaskEntityImpl>(this, _$identity);
}

abstract class _TaskEntity implements TaskEntity {
  const factory _TaskEntity(
      {required final String id,
      required final String title,
      required final String description,
      required final String priority,
      required final DateTime? dueDate,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final bool isCompleted,
      required final int timelineSection,
      required final int estimatedMinutes,
      required final List<String> tagIds,
      final String? linkedNoteId}) = _$TaskEntityImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get priority;
  @override // "low", "medium", "high"
  DateTime? get dueDate;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isCompleted;
  @override
  int get timelineSection;
  @override // 0 = Morning, 1 = Afternoon, 2 = Evening, 3 = Night
  int get estimatedMinutes;
  @override
  List<String> get tagIds;
  @override
  String? get linkedNoteId;
  @override
  @JsonKey(ignore: true)
  _$$TaskEntityImplCopyWith<_$TaskEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
