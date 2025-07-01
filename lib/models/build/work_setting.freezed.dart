// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../work_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkSetting _$WorkSettingFromJson(Map<String, dynamic> json) {
  return _WorkSetting.fromJson(json);
}

/// @nodoc
mixin _$WorkSetting {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get start => throw _privateConstructorUsedError;
  DateTime get end => throw _privateConstructorUsedError;
  DateTime get restStart => throw _privateConstructorUsedError;
  DateTime get restEnd => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  int get workingUnit => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WorkSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkSettingCopyWith<WorkSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkSettingCopyWith<$Res> {
  factory $WorkSettingCopyWith(
          WorkSetting value, $Res Function(WorkSetting) then) =
      _$WorkSettingCopyWithImpl<$Res, WorkSetting>;
  @useResult
  $Res call(
      {int id,
      String title,
      DateTime start,
      DateTime end,
      DateTime restStart,
      DateTime restEnd,
      String? memo,
      int workingUnit,
      int userId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$WorkSettingCopyWithImpl<$Res, $Val extends WorkSetting>
    implements $WorkSettingCopyWith<$Res> {
  _$WorkSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? start = null,
    Object? end = null,
    Object? restStart = null,
    Object? restEnd = null,
    Object? memo = freezed,
    Object? workingUnit = null,
    Object? userId = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
      restStart: null == restStart
          ? _value.restStart
          : restStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      restEnd: null == restEnd
          ? _value.restEnd
          : restEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      workingUnit: null == workingUnit
          ? _value.workingUnit
          : workingUnit // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$WorkSettingImplCopyWith<$Res>
    implements $WorkSettingCopyWith<$Res> {
  factory _$$WorkSettingImplCopyWith(
          _$WorkSettingImpl value, $Res Function(_$WorkSettingImpl) then) =
      __$$WorkSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      DateTime start,
      DateTime end,
      DateTime restStart,
      DateTime restEnd,
      String? memo,
      int workingUnit,
      int userId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$WorkSettingImplCopyWithImpl<$Res>
    extends _$WorkSettingCopyWithImpl<$Res, _$WorkSettingImpl>
    implements _$$WorkSettingImplCopyWith<$Res> {
  __$$WorkSettingImplCopyWithImpl(
      _$WorkSettingImpl _value, $Res Function(_$WorkSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? start = null,
    Object? end = null,
    Object? restStart = null,
    Object? restEnd = null,
    Object? memo = freezed,
    Object? workingUnit = null,
    Object? userId = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WorkSettingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
      restStart: null == restStart
          ? _value.restStart
          : restStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      restEnd: null == restEnd
          ? _value.restEnd
          : restEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      workingUnit: null == workingUnit
          ? _value.workingUnit
          : workingUnit // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$WorkSettingImpl implements _WorkSetting {
  const _$WorkSettingImpl(
      {required this.id,
      required this.title,
      required this.start,
      required this.end,
      required this.restStart,
      required this.restEnd,
      this.memo,
      required this.workingUnit,
      required this.userId,
      this.createdAt,
      this.updatedAt});

  factory _$WorkSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkSettingImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final DateTime start;
  @override
  final DateTime end;
  @override
  final DateTime restStart;
  @override
  final DateTime restEnd;
  @override
  final String? memo;
  @override
  final int workingUnit;
  @override
  final int userId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WorkSetting(id: $id, title: $title, start: $start, end: $end, restStart: $restStart, restEnd: $restEnd, memo: $memo, workingUnit: $workingUnit, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkSettingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.restStart, restStart) ||
                other.restStart == restStart) &&
            (identical(other.restEnd, restEnd) || other.restEnd == restEnd) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.workingUnit, workingUnit) ||
                other.workingUnit == workingUnit) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, start, end, restStart,
      restEnd, memo, workingUnit, userId, createdAt, updatedAt);

  /// Create a copy of WorkSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkSettingImplCopyWith<_$WorkSettingImpl> get copyWith =>
      __$$WorkSettingImplCopyWithImpl<_$WorkSettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkSettingImplToJson(
      this,
    );
  }
}

abstract class _WorkSetting implements WorkSetting {
  const factory _WorkSetting(
      {required final int id,
      required final String title,
      required final DateTime start,
      required final DateTime end,
      required final DateTime restStart,
      required final DateTime restEnd,
      final String? memo,
      required final int workingUnit,
      required final int userId,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$WorkSettingImpl;

  factory _WorkSetting.fromJson(Map<String, dynamic> json) =
      _$WorkSettingImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  DateTime get start;
  @override
  DateTime get end;
  @override
  DateTime get restStart;
  @override
  DateTime get restEnd;
  @override
  String? get memo;
  @override
  int get workingUnit;
  @override
  int get userId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of WorkSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkSettingImplCopyWith<_$WorkSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
