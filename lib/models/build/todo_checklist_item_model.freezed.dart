// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../todo_checklist_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoCheckListItemModel {
  int get id;
  int get todoId;
  String get title;
  bool get isCompleted;
  int get order; // For ordering checklist items
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of TodoCheckListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TodoCheckListItemModelCopyWith<TodoCheckListItemModel> get copyWith =>
      _$TodoCheckListItemModelCopyWithImpl<TodoCheckListItemModel>(
          this as TodoCheckListItemModel, _$identity);

  /// Serializes this TodoCheckListItemModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TodoCheckListItemModel &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, todoId, title, isCompleted, order, createdAt, updatedAt);

  @override
  String toString() {
    return 'TodoCheckListItemModel(id: $id, todoId: $todoId, title: $title, isCompleted: $isCompleted, order: $order, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $TodoCheckListItemModelCopyWith<$Res> {
  factory $TodoCheckListItemModelCopyWith(TodoCheckListItemModel value,
          $Res Function(TodoCheckListItemModel) _then) =
      _$TodoCheckListItemModelCopyWithImpl;
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
class _$TodoCheckListItemModelCopyWithImpl<$Res>
    implements $TodoCheckListItemModelCopyWith<$Res> {
  _$TodoCheckListItemModelCopyWithImpl(this._self, this._then);

  final TodoCheckListItemModel _self;
  final $Res Function(TodoCheckListItemModel) _then;

  /// Create a copy of TodoCheckListItemModel
  /// with the given fields replaced by the non-null parameter values.
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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      todoId: null == todoId
          ? _self.todoId
          : todoId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _self.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TodoCheckListItemModel].
extension TodoCheckListItemModelPatterns on TodoCheckListItemModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TodoCheckListItemModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TodoCheckListItemModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TodoCheckListItemModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodoCheckListItemModel():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TodoCheckListItemModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodoCheckListItemModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int id, int todoId, String title, bool isCompleted,
            int order, DateTime? createdAt, DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TodoCheckListItemModel() when $default != null:
        return $default(_that.id, _that.todoId, _that.title, _that.isCompleted,
            _that.order, _that.createdAt, _that.updatedAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int id, int todoId, String title, bool isCompleted,
            int order, DateTime? createdAt, DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodoCheckListItemModel():
        return $default(_that.id, _that.todoId, _that.title, _that.isCompleted,
            _that.order, _that.createdAt, _that.updatedAt);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int id, int todoId, String title, bool isCompleted,
            int order, DateTime? createdAt, DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodoCheckListItemModel() when $default != null:
        return $default(_that.id, _that.todoId, _that.title, _that.isCompleted,
            _that.order, _that.createdAt, _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TodoCheckListItemModel implements TodoCheckListItemModel {
  const _TodoCheckListItemModel(
      {required this.id,
      required this.todoId,
      required this.title,
      required this.isCompleted,
      required this.order,
      this.createdAt,
      this.updatedAt});
  factory _TodoCheckListItemModel.fromJson(Map<String, dynamic> json) =>
      _$TodoCheckListItemModelFromJson(json);

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
// For ordering checklist items
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of TodoCheckListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TodoCheckListItemModelCopyWith<_TodoCheckListItemModel> get copyWith =>
      __$TodoCheckListItemModelCopyWithImpl<_TodoCheckListItemModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TodoCheckListItemModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TodoCheckListItemModel &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, todoId, title, isCompleted, order, createdAt, updatedAt);

  @override
  String toString() {
    return 'TodoCheckListItemModel(id: $id, todoId: $todoId, title: $title, isCompleted: $isCompleted, order: $order, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$TodoCheckListItemModelCopyWith<$Res>
    implements $TodoCheckListItemModelCopyWith<$Res> {
  factory _$TodoCheckListItemModelCopyWith(_TodoCheckListItemModel value,
          $Res Function(_TodoCheckListItemModel) _then) =
      __$TodoCheckListItemModelCopyWithImpl;
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
class __$TodoCheckListItemModelCopyWithImpl<$Res>
    implements _$TodoCheckListItemModelCopyWith<$Res> {
  __$TodoCheckListItemModelCopyWithImpl(this._self, this._then);

  final _TodoCheckListItemModel _self;
  final $Res Function(_TodoCheckListItemModel) _then;

  /// Create a copy of TodoCheckListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? todoId = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? order = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_TodoCheckListItemModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      todoId: null == todoId
          ? _self.todoId
          : todoId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _self.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
