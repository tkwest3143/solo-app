// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../japanese_holiday.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JapaneseHoliday _$JapaneseHolidayFromJson(Map<String, dynamic> json) {
  return _JapaneseHoliday.fromJson(json);
}

/// @nodoc
mixin _$JapaneseHoliday {
  int get id => throw _privateConstructorUsedError;
  String get targetDay => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this JapaneseHoliday to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JapaneseHoliday
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JapaneseHolidayCopyWith<JapaneseHoliday> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JapaneseHolidayCopyWith<$Res> {
  factory $JapaneseHolidayCopyWith(
          JapaneseHoliday value, $Res Function(JapaneseHoliday) then) =
      _$JapaneseHolidayCopyWithImpl<$Res, JapaneseHoliday>;
  @useResult
  $Res call(
      {int id,
      String targetDay,
      String name,
      String? memo,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$JapaneseHolidayCopyWithImpl<$Res, $Val extends JapaneseHoliday>
    implements $JapaneseHolidayCopyWith<$Res> {
  _$JapaneseHolidayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JapaneseHoliday
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? targetDay = null,
    Object? name = null,
    Object? memo = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$JapaneseHolidayImplCopyWith<$Res>
    implements $JapaneseHolidayCopyWith<$Res> {
  factory _$$JapaneseHolidayImplCopyWith(_$JapaneseHolidayImpl value,
          $Res Function(_$JapaneseHolidayImpl) then) =
      __$$JapaneseHolidayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String targetDay,
      String name,
      String? memo,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$JapaneseHolidayImplCopyWithImpl<$Res>
    extends _$JapaneseHolidayCopyWithImpl<$Res, _$JapaneseHolidayImpl>
    implements _$$JapaneseHolidayImplCopyWith<$Res> {
  __$$JapaneseHolidayImplCopyWithImpl(
      _$JapaneseHolidayImpl _value, $Res Function(_$JapaneseHolidayImpl) _then)
      : super(_value, _then);

  /// Create a copy of JapaneseHoliday
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? targetDay = null,
    Object? name = null,
    Object? memo = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$JapaneseHolidayImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      targetDay: null == targetDay
          ? _value.targetDay
          : targetDay // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$JapaneseHolidayImpl implements _JapaneseHoliday {
  const _$JapaneseHolidayImpl(
      {required this.id,
      required this.targetDay,
      required this.name,
      this.memo,
      this.createdAt,
      this.updatedAt});

  factory _$JapaneseHolidayImpl.fromJson(Map<String, dynamic> json) =>
      _$$JapaneseHolidayImplFromJson(json);

  @override
  final int id;
  @override
  final String targetDay;
  @override
  final String name;
  @override
  final String? memo;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'JapaneseHoliday(id: $id, targetDay: $targetDay, name: $name, memo: $memo, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JapaneseHolidayImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.targetDay, targetDay) ||
                other.targetDay == targetDay) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, targetDay, name, memo, createdAt, updatedAt);

  /// Create a copy of JapaneseHoliday
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JapaneseHolidayImplCopyWith<_$JapaneseHolidayImpl> get copyWith =>
      __$$JapaneseHolidayImplCopyWithImpl<_$JapaneseHolidayImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JapaneseHolidayImplToJson(
      this,
    );
  }
}

abstract class _JapaneseHoliday implements JapaneseHoliday {
  const factory _JapaneseHoliday(
      {required final int id,
      required final String targetDay,
      required final String name,
      final String? memo,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$JapaneseHolidayImpl;

  factory _JapaneseHoliday.fromJson(Map<String, dynamic> json) =
      _$JapaneseHolidayImpl.fromJson;

  @override
  int get id;
  @override
  String get targetDay;
  @override
  String get name;
  @override
  String? get memo;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of JapaneseHoliday
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JapaneseHolidayImplCopyWith<_$JapaneseHolidayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
