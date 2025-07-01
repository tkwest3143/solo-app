// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../work_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkTime _$WorkTimeFromJson(Map<String, dynamic> json) {
  return _WorkTime.fromJson(json);
}

/// @nodoc
mixin _$WorkTime {
  int get id => throw _privateConstructorUsedError;
  String get targetDay => throw _privateConstructorUsedError;
  DateTime? get start => throw _privateConstructorUsedError;
  DateTime? get end => throw _privateConstructorUsedError;
  DateTime? get restStart => throw _privateConstructorUsedError;
  DateTime? get restEnd => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WorkTime to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkTimeCopyWith<WorkTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkTimeCopyWith<$Res> {
  factory $WorkTimeCopyWith(WorkTime value, $Res Function(WorkTime) then) =
      _$WorkTimeCopyWithImpl<$Res, WorkTime>;
  @useResult
  $Res call(
      {int id,
      String targetDay,
      DateTime? start,
      DateTime? end,
      DateTime? restStart,
      DateTime? restEnd,
      String? memo,
      int userId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$WorkTimeCopyWithImpl<$Res, $Val extends WorkTime>
    implements $WorkTimeCopyWith<$Res> {
  _$WorkTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? targetDay = null,
    Object? start = freezed,
    Object? end = freezed,
    Object? restStart = freezed,
    Object? restEnd = freezed,
    Object? memo = freezed,
    Object? userId = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      targetDay: null == targetDay
          ? _value.targetDay
          : targetDay // ignore: cast_nullable_to_non_nullable
              as String,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      restStart: freezed == restStart
          ? _value.restStart
          : restStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      restEnd: freezed == restEnd
          ? _value.restEnd
          : restEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkTimeImplCopyWith<$Res>
    implements $WorkTimeCopyWith<$Res> {
  factory _$$WorkTimeImplCopyWith(
          _$WorkTimeImpl value, $Res Function(_$WorkTimeImpl) then) =
      __$$WorkTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String targetDay,
      DateTime? start,
      DateTime? end,
      DateTime? restStart,
      DateTime? restEnd,
      String? memo,
      int userId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$WorkTimeImplCopyWithImpl<$Res>
    extends _$WorkTimeCopyWithImpl<$Res, _$WorkTimeImpl>
    implements _$$WorkTimeImplCopyWith<$Res> {
  __$$WorkTimeImplCopyWithImpl(
      _$WorkTimeImpl _value, $Res Function(_$WorkTimeImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? targetDay = null,
    Object? start = freezed,
    Object? end = freezed,
    Object? restStart = freezed,
    Object? restEnd = freezed,
    Object? memo = freezed,
    Object? userId = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WorkTimeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      targetDay: null == targetDay
          ? _value.targetDay
          : targetDay // ignore: cast_nullable_to_non_nullable
              as String,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      restStart: freezed == restStart
          ? _value.restStart
          : restStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      restEnd: freezed == restEnd
          ? _value.restEnd
          : restEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkTimeImpl implements _WorkTime {
  const _$WorkTimeImpl(
      {required this.id,
      required this.targetDay,
      this.start,
      this.end,
      this.restStart,
      this.restEnd,
      this.memo,
      required this.userId,
      this.createdAt,
      this.updatedAt});

  factory _$WorkTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkTimeImplFromJson(json);

  @override
  final int id;
  @override
  final String targetDay;
  @override
  final DateTime? start;
  @override
  final DateTime? end;
  @override
  final DateTime? restStart;
  @override
  final DateTime? restEnd;
  @override
  final String? memo;
  @override
  final int userId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WorkTime(id: $id, targetDay: $targetDay, start: $start, end: $end, restStart: $restStart, restEnd: $restEnd, memo: $memo, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkTimeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.targetDay, targetDay) ||
                other.targetDay == targetDay) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.restStart, restStart) ||
                other.restStart == restStart) &&
            (identical(other.restEnd, restEnd) || other.restEnd == restEnd) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, targetDay, start, end,
      restStart, restEnd, memo, userId, createdAt, updatedAt);

  /// Create a copy of WorkTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkTimeImplCopyWith<_$WorkTimeImpl> get copyWith =>
      __$$WorkTimeImplCopyWithImpl<_$WorkTimeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkTimeImplToJson(
      this,
    );
  }
}

abstract class _WorkTime implements WorkTime {
  const factory _WorkTime(
      {required final int id,
      required final String targetDay,
      final DateTime? start,
      final DateTime? end,
      final DateTime? restStart,
      final DateTime? restEnd,
      final String? memo,
      required final int userId,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$WorkTimeImpl;

  factory _WorkTime.fromJson(Map<String, dynamic> json) =
      _$WorkTimeImpl.fromJson;

  @override
  int get id;
  @override
  String get targetDay;
  @override
  DateTime? get start;
  @override
  DateTime? get end;
  @override
  DateTime? get restStart;
  @override
  DateTime? get restEnd;
  @override
  String? get memo;
  @override
  int get userId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of WorkTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkTimeImplCopyWith<_$WorkTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
