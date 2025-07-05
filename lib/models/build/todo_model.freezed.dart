// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../todo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) {
  return _TodoModel.fromJson(json);
}

/// @nodoc
mixin _$TodoModel {
  int get id => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  int? get categoryId => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Recurring fields
  bool? get isRecurring => throw _privateConstructorUsedError;
  String? get recurringType => throw _privateConstructorUsedError;
  DateTime? get recurringEndDate => throw _privateConstructorUsedError;
  int? get recurringDayOfWeek =>
      throw _privateConstructorUsedError; // 1-7 for weekly (Monday = 1)
  int? get recurringDayOfMonth => throw _privateConstructorUsedError;

  /// Serializes this TodoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodoModelCopyWith<TodoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoModelCopyWith<$Res> {
  factory $TodoModelCopyWith(TodoModel value, $Res Function(TodoModel) then) =
      _$TodoModelCopyWithImpl<$Res, TodoModel>;
  @useResult
  $Res call(
      {int id,
      DateTime dueDate,
      String title,
      bool isCompleted,
      String? description,
      String? color,
      String? icon,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool? isRecurring,
      String? recurringType,
      DateTime? recurringEndDate,
      int? recurringDayOfWeek,
      int? recurringDayOfMonth});
}

/// @nodoc
class _$TodoModelCopyWithImpl<$Res, $Val extends TodoModel>
    implements $TodoModelCopyWith<$Res> {
  _$TodoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dueDate = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? description = freezed,
    Object? color = freezed,
    Object? icon = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isRecurring = freezed,
    Object? recurringType = freezed,
    Object? recurringEndDate = freezed,
    Object? recurringDayOfWeek = freezed,
    Object? recurringDayOfMonth = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRecurring: freezed == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurringType: freezed == recurringType
          ? _value.recurringType
          : recurringType // ignore: cast_nullable_to_non_nullable
              as String?,
      recurringEndDate: freezed == recurringEndDate
          ? _value.recurringEndDate
          : recurringEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recurringDayOfWeek: freezed == recurringDayOfWeek
          ? _value.recurringDayOfWeek
          : recurringDayOfWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      recurringDayOfMonth: freezed == recurringDayOfMonth
          ? _value.recurringDayOfMonth
          : recurringDayOfMonth // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodoModelImplCopyWith<$Res>
    implements $TodoModelCopyWith<$Res> {
  factory _$$TodoModelImplCopyWith(
          _$TodoModelImpl value, $Res Function(_$TodoModelImpl) then) =
      __$$TodoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      DateTime dueDate,
      String title,
      bool isCompleted,
      String? description,
      String? color,
      String? icon,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool? isRecurring,
      String? recurringType,
      DateTime? recurringEndDate,
      int? recurringDayOfWeek,
      int? recurringDayOfMonth});
}

/// @nodoc
class __$$TodoModelImplCopyWithImpl<$Res>
    extends _$TodoModelCopyWithImpl<$Res, _$TodoModelImpl>
    implements _$$TodoModelImplCopyWith<$Res> {
  __$$TodoModelImplCopyWithImpl(
      _$TodoModelImpl _value, $Res Function(_$TodoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dueDate = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? description = freezed,
    Object? color = freezed,
    Object? icon = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isRecurring = freezed,
    Object? recurringType = freezed,
    Object? recurringEndDate = freezed,
    Object? recurringDayOfWeek = freezed,
    Object? recurringDayOfMonth = freezed,
  }) {
    return _then(_$TodoModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRecurring: freezed == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurringType: freezed == recurringType
          ? _value.recurringType
          : recurringType // ignore: cast_nullable_to_non_nullable
              as String?,
      recurringEndDate: freezed == recurringEndDate
          ? _value.recurringEndDate
          : recurringEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recurringDayOfWeek: freezed == recurringDayOfWeek
          ? _value.recurringDayOfWeek
          : recurringDayOfWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      recurringDayOfMonth: freezed == recurringDayOfMonth
          ? _value.recurringDayOfMonth
          : recurringDayOfMonth // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TodoModelImpl implements _TodoModel {
  const _$TodoModelImpl(
      {required this.id,
      required this.dueDate,
      required this.title,
      required this.isCompleted,
      this.description,
      this.color,
      this.icon,
      this.createdAt,
      this.updatedAt,
      this.isRecurring,
      this.recurringType,
      this.recurringEndDate,
      this.recurringDayOfWeek,
      this.recurringDayOfMonth});

  factory _$TodoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodoModelImplFromJson(json);

  @override
  final int id;
  @override
  final DateTime dueDate;
  @override
  final String title;
  @override
  final bool isCompleted;
  @override
  final String? description;
  @override
  final String? color;
  @override
  final String? icon;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Recurring fields
  @override
  final bool? isRecurring;
  @override
  final String? recurringType;
  @override
  final DateTime? recurringEndDate;
  @override
  final int? recurringDayOfWeek;
// 1-7 for weekly (Monday = 1)
  @override
  final int? recurringDayOfMonth;

  @override
  String toString() {
    return 'TodoModel(id: $id, dueDate: $dueDate, title: $title, isCompleted: $isCompleted, description: $description, color: $color, icon: $icon, createdAt: $createdAt, updatedAt: $updatedAt, isRecurring: $isRecurring, recurringType: $recurringType, recurringEndDate: $recurringEndDate, recurringDayOfWeek: $recurringDayOfWeek, recurringDayOfMonth: $recurringDayOfMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurringType, recurringType) ||
                other.recurringType == recurringType) &&
            (identical(other.recurringEndDate, recurringEndDate) ||
                other.recurringEndDate == recurringEndDate) &&
            (identical(other.recurringDayOfWeek, recurringDayOfWeek) ||
                other.recurringDayOfWeek == recurringDayOfWeek) &&
            (identical(other.recurringDayOfMonth, recurringDayOfMonth) ||
                other.recurringDayOfMonth == recurringDayOfMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      dueDate,
      title,
      isCompleted,
      description,
      color,
      icon,
      createdAt,
      updatedAt,
      isRecurring,
      recurringType,
      recurringEndDate,
      recurringDayOfWeek,
      recurringDayOfMonth);

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoModelImplCopyWith<_$TodoModelImpl> get copyWith =>
      __$$TodoModelImplCopyWithImpl<_$TodoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodoModelImplToJson(
      this,
    );
  }
}

abstract class _TodoModel implements TodoModel {
  const factory _TodoModel(
      {required final int id,
      required final DateTime dueDate,
      required final String title,
      required final bool isCompleted,
      final String? description,
      final String? color,
      final String? icon,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final bool? isRecurring,
      final String? recurringType,
      final DateTime? recurringEndDate,
      final int? recurringDayOfWeek,
      final int? recurringDayOfMonth}) = _$TodoModelImpl;

  factory _TodoModel.fromJson(Map<String, dynamic> json) =
      _$TodoModelImpl.fromJson;

  @override
  int get id;
  @override
  DateTime get dueDate;
  @override
  String get title;
  @override
  bool get isCompleted;
  @override
  String? get description;
  @override
  String? get color;
  @override
  String? get icon;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Recurring fields
  @override
  bool? get isRecurring;
  @override
  String? get recurringType;
  @override
  DateTime? get recurringEndDate;
  @override
  int? get recurringDayOfWeek; // 1-7 for weekly (Monday = 1)
  @override
  int? get recurringDayOfMonth;

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodoModelImplCopyWith<_$TodoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
