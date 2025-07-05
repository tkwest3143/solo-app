// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../todo_checklist_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TodoCheckListItemModel _$TodoCheckListItemModelFromJson(
    Map<String, dynamic> json) {
  return _TodoCheckListItemModel.fromJson(json);
}

/// @nodoc
mixin _$TodoCheckListItemModel {
  int get id => throw _privateConstructorUsedError;
  int get todoId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TodoCheckListItemModelCopyWith<TodoCheckListItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoCheckListItemModelCopyWith<$Res> {
  factory $TodoCheckListItemModelCopyWith(TodoCheckListItemModel value,
          $Res Function(TodoCheckListItemModel) then) =
      _$TodoCheckListItemModelCopyWithImpl<$Res, TodoCheckListItemModel>;
  @useResult
  $Res call(
      {int id,
      int todoId,
      String title,
      bool isCompleted,
      int order,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$TodoCheckListItemModelCopyWithImpl<$Res,
        $Val extends TodoCheckListItemModel>
    implements $TodoCheckListItemModelCopyWith<$Res> {
  _$TodoCheckListItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? todoId = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? order = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      todoId: null == todoId
          ? _value.todoId
          : todoId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
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
abstract class _$$TodoCheckListItemModelImplCopyWith<$Res>
    implements $TodoCheckListItemModelCopyWith<$Res> {
  factory _$$TodoCheckListItemModelImplCopyWith(
          _$TodoCheckListItemModelImpl value,
          $Res Function(_$TodoCheckListItemModelImpl) then) =
      __$$TodoCheckListItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int todoId,
      String title,
      bool isCompleted,
      int order,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$TodoCheckListItemModelImplCopyWithImpl<$Res>
    extends _$TodoCheckListItemModelCopyWithImpl<$Res,
        _$TodoCheckListItemModelImpl>
    implements _$$TodoCheckListItemModelImplCopyWith<$Res> {
  __$$TodoCheckListItemModelImplCopyWithImpl(
      _$TodoCheckListItemModelImpl _value,
      $Res Function(_$TodoCheckListItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? todoId = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? order = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TodoCheckListItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      todoId: null == todoId
          ? _value.todoId
          : todoId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
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
class _$TodoCheckListItemModelImpl implements _TodoCheckListItemModel {
  const _$TodoCheckListItemModelImpl(
      {required this.id,
      required this.todoId,
      required this.title,
      required this.isCompleted,
      required this.order,
      this.createdAt,
      this.updatedAt});

  factory _$TodoCheckListItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodoCheckListItemModelImplFromJson(json);

  @override
  final int id;
  @override
  final int todoId;
  @override
  final String title;
  @override
  final bool isCompleted;
  @override
  final int order;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TodoCheckListItemModel(id: $id, todoId: $todoId, title: $title, isCompleted: $isCompleted, order: $order, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodoCheckListItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.todoId, todoId) || other.todoId == todoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, todoId, title, isCompleted, order, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoCheckListItemModelImplCopyWith<_$TodoCheckListItemModelImpl>
      get copyWith => __$$TodoCheckListItemModelImplCopyWithImpl<
          _$TodoCheckListItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodoCheckListItemModelImplToJson(
      this,
    );
  }
}

abstract class _TodoCheckListItemModel implements TodoCheckListItemModel {
  const factory _TodoCheckListItemModel(
      {required final int id,
      required final int todoId,
      required final String title,
      required final bool isCompleted,
      required final int order,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$TodoCheckListItemModelImpl;

  factory _TodoCheckListItemModel.fromJson(Map<String, dynamic> json) =
      _$TodoCheckListItemModelImpl.fromJson;

  @override
  int get id;
  @override
  int get todoId;
  @override
  String get title;
  @override
  bool get isCompleted;
  @override
  int get order;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TodoCheckListItemModelImplCopyWith<_$TodoCheckListItemModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}