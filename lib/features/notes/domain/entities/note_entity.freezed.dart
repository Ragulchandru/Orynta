// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NoteEntity {
  /// Universally unique identifier (UUID v4).
  /// Generated once at creation, never changes.
  String get id => throw _privateConstructorUsedError;

  /// The note title. May be an empty string (body-only notes are valid).
  String get title => throw _privateConstructorUsedError;

  /// The note body — plain text, multiline.
  /// Rich text (flutter_quill) is planned for Phase 5.
  String get body => throw _privateConstructorUsedError;

  /// Background color as an ARGB integer (e.g., 0xFFD0BCFF = lavender).
  ///
  /// Stored as [int] to keep the domain free of Flutter's [Color] type.
  /// The UI converts: Color(note.color ?? AppColors.noteColorDefault).
  /// null = use the theme's default card surface color.
  int? get color => throw _privateConstructorUsedError;

  /// Whether this note is pinned at the top of the notes list.
  bool get isPinned => throw _privateConstructorUsedError;

  /// The lifecycle state of this note (active / archived / trashed).
  NoteStatus get status => throw _privateConstructorUsedError;

  /// When the note was originally created. Set once and never modified.
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// When the note was last modified (any field change triggers an update).
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// When the note was moved to the trash. null if not in the trash.
  ///
  /// Drives the 30-day auto-delete countdown:
  ///   if (DateTime.now().difference(note.trashedAt!) > 30 days) → purge.
  DateTime? get trashedAt => throw _privateConstructorUsedError;

  /// The ID of the [Category] this note belongs to.
  ///
  /// null = uncategorized. Populated in Phase 2 when Categories are
  /// implemented. Stored now to avoid a breaking schema migration later.
  String? get categoryId => throw _privateConstructorUsedError;

  /// The IDs of all [Tag]s applied to this note.
  ///
  /// Empty list = no tags. Populated in Phase 2 when Tags are implemented.
  /// Using IDs (not embedded objects) keeps the note entity flat and avoids
  /// complex nested serialization.
  List<String> get tagIds => throw _privateConstructorUsedError;

  /// Whether the user has marked this note as a favorite.
  ///
  /// Favorites are shown in a dedicated Favorites screen (Phase 3).
  /// Stored as a separate field (not a [NoteStatus] value) because a note
  /// can be both favorited AND archived simultaneously.
  bool get isFavorite => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NoteEntityCopyWith<NoteEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteEntityCopyWith<$Res> {
  factory $NoteEntityCopyWith(
          NoteEntity value, $Res Function(NoteEntity) then) =
      _$NoteEntityCopyWithImpl<$Res, NoteEntity>;
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      int? color,
      bool isPinned,
      NoteStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? trashedAt,
      String? categoryId,
      List<String> tagIds,
      bool isFavorite});
}

/// @nodoc
class _$NoteEntityCopyWithImpl<$Res, $Val extends NoteEntity>
    implements $NoteEntityCopyWith<$Res> {
  _$NoteEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? color = freezed,
    Object? isPinned = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? trashedAt = freezed,
    Object? categoryId = freezed,
    Object? tagIds = null,
    Object? isFavorite = null,
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
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int?,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NoteStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      trashedAt: freezed == trashedAt
          ? _value.trashedAt
          : trashedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      tagIds: null == tagIds
          ? _value.tagIds
          : tagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteEntityImplCopyWith<$Res>
    implements $NoteEntityCopyWith<$Res> {
  factory _$$NoteEntityImplCopyWith(
          _$NoteEntityImpl value, $Res Function(_$NoteEntityImpl) then) =
      __$$NoteEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      int? color,
      bool isPinned,
      NoteStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? trashedAt,
      String? categoryId,
      List<String> tagIds,
      bool isFavorite});
}

/// @nodoc
class __$$NoteEntityImplCopyWithImpl<$Res>
    extends _$NoteEntityCopyWithImpl<$Res, _$NoteEntityImpl>
    implements _$$NoteEntityImplCopyWith<$Res> {
  __$$NoteEntityImplCopyWithImpl(
      _$NoteEntityImpl _value, $Res Function(_$NoteEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? color = freezed,
    Object? isPinned = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? trashedAt = freezed,
    Object? categoryId = freezed,
    Object? tagIds = null,
    Object? isFavorite = null,
  }) {
    return _then(_$NoteEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int?,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NoteStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      trashedAt: freezed == trashedAt
          ? _value.trashedAt
          : trashedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      tagIds: null == tagIds
          ? _value._tagIds
          : tagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NoteEntityImpl implements _NoteEntity {
  const _$NoteEntityImpl(
      {required this.id,
      required this.title,
      required this.body,
      this.color,
      required this.isPinned,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.trashedAt,
      this.categoryId,
      final List<String> tagIds = const [],
      this.isFavorite = false})
      : _tagIds = tagIds;

  /// Universally unique identifier (UUID v4).
  /// Generated once at creation, never changes.
  @override
  final String id;

  /// The note title. May be an empty string (body-only notes are valid).
  @override
  final String title;

  /// The note body — plain text, multiline.
  /// Rich text (flutter_quill) is planned for Phase 5.
  @override
  final String body;

  /// Background color as an ARGB integer (e.g., 0xFFD0BCFF = lavender).
  ///
  /// Stored as [int] to keep the domain free of Flutter's [Color] type.
  /// The UI converts: Color(note.color ?? AppColors.noteColorDefault).
  /// null = use the theme's default card surface color.
  @override
  final int? color;

  /// Whether this note is pinned at the top of the notes list.
  @override
  final bool isPinned;

  /// The lifecycle state of this note (active / archived / trashed).
  @override
  final NoteStatus status;

  /// When the note was originally created. Set once and never modified.
  @override
  final DateTime createdAt;

  /// When the note was last modified (any field change triggers an update).
  @override
  final DateTime updatedAt;

  /// When the note was moved to the trash. null if not in the trash.
  ///
  /// Drives the 30-day auto-delete countdown:
  ///   if (DateTime.now().difference(note.trashedAt!) > 30 days) → purge.
  @override
  final DateTime? trashedAt;

  /// The ID of the [Category] this note belongs to.
  ///
  /// null = uncategorized. Populated in Phase 2 when Categories are
  /// implemented. Stored now to avoid a breaking schema migration later.
  @override
  final String? categoryId;

  /// The IDs of all [Tag]s applied to this note.
  ///
  /// Empty list = no tags. Populated in Phase 2 when Tags are implemented.
  /// Using IDs (not embedded objects) keeps the note entity flat and avoids
  /// complex nested serialization.
  final List<String> _tagIds;

  /// The IDs of all [Tag]s applied to this note.
  ///
  /// Empty list = no tags. Populated in Phase 2 when Tags are implemented.
  /// Using IDs (not embedded objects) keeps the note entity flat and avoids
  /// complex nested serialization.
  @override
  @JsonKey()
  List<String> get tagIds {
    if (_tagIds is EqualUnmodifiableListView) return _tagIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagIds);
  }

  /// Whether the user has marked this note as a favorite.
  ///
  /// Favorites are shown in a dedicated Favorites screen (Phase 3).
  /// Stored as a separate field (not a [NoteStatus] value) because a note
  /// can be both favorited AND archived simultaneously.
  @override
  @JsonKey()
  final bool isFavorite;

  @override
  String toString() {
    return 'NoteEntity(id: $id, title: $title, body: $body, color: $color, isPinned: $isPinned, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, trashedAt: $trashedAt, categoryId: $categoryId, tagIds: $tagIds, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.trashedAt, trashedAt) ||
                other.trashedAt == trashedAt) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(other._tagIds, _tagIds) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      body,
      color,
      isPinned,
      status,
      createdAt,
      updatedAt,
      trashedAt,
      categoryId,
      const DeepCollectionEquality().hash(_tagIds),
      isFavorite);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteEntityImplCopyWith<_$NoteEntityImpl> get copyWith =>
      __$$NoteEntityImplCopyWithImpl<_$NoteEntityImpl>(this, _$identity);
}

abstract class _NoteEntity implements NoteEntity {
  const factory _NoteEntity(
      {required final String id,
      required final String title,
      required final String body,
      final int? color,
      required final bool isPinned,
      required final NoteStatus status,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? trashedAt,
      final String? categoryId,
      final List<String> tagIds,
      final bool isFavorite}) = _$NoteEntityImpl;

  @override

  /// Universally unique identifier (UUID v4).
  /// Generated once at creation, never changes.
  String get id;
  @override

  /// The note title. May be an empty string (body-only notes are valid).
  String get title;
  @override

  /// The note body — plain text, multiline.
  /// Rich text (flutter_quill) is planned for Phase 5.
  String get body;
  @override

  /// Background color as an ARGB integer (e.g., 0xFFD0BCFF = lavender).
  ///
  /// Stored as [int] to keep the domain free of Flutter's [Color] type.
  /// The UI converts: Color(note.color ?? AppColors.noteColorDefault).
  /// null = use the theme's default card surface color.
  int? get color;
  @override

  /// Whether this note is pinned at the top of the notes list.
  bool get isPinned;
  @override

  /// The lifecycle state of this note (active / archived / trashed).
  NoteStatus get status;
  @override

  /// When the note was originally created. Set once and never modified.
  DateTime get createdAt;
  @override

  /// When the note was last modified (any field change triggers an update).
  DateTime get updatedAt;
  @override

  /// When the note was moved to the trash. null if not in the trash.
  ///
  /// Drives the 30-day auto-delete countdown:
  ///   if (DateTime.now().difference(note.trashedAt!) > 30 days) → purge.
  DateTime? get trashedAt;
  @override

  /// The ID of the [Category] this note belongs to.
  ///
  /// null = uncategorized. Populated in Phase 2 when Categories are
  /// implemented. Stored now to avoid a breaking schema migration later.
  String? get categoryId;
  @override

  /// The IDs of all [Tag]s applied to this note.
  ///
  /// Empty list = no tags. Populated in Phase 2 when Tags are implemented.
  /// Using IDs (not embedded objects) keeps the note entity flat and avoids
  /// complex nested serialization.
  List<String> get tagIds;
  @override

  /// Whether the user has marked this note as a favorite.
  ///
  /// Favorites are shown in a dedicated Favorites screen (Phase 3).
  /// Stored as a separate field (not a [NoteStatus] value) because a note
  /// can be both favorited AND archived simultaneously.
  bool get isFavorite;
  @override
  @JsonKey(ignore: true)
  _$$NoteEntityImplCopyWith<_$NoteEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
