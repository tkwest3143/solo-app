// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../todo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoModel {
  int get id;
  DateTime get dueDate;
  String get title;
  bool get isCompleted;
  String? get description;
  String? get color; // Keep for backward compatibility
  int? get categoryId; // New category reference
  String? get icon;
  DateTime? get createdAt;
  DateTime? get updatedAt; // Recurring fields
  bool? get isRecurring;
  RecurringType get recurringType;
  DateTime? get recurringEndDate;
  int? get parentTodoId;
  List<TodoCheckListItemModel> get checklistItem; // Optional checklist item
  TimerType get timerType; // 'none', 'pomodoro', 'countup'
  int? get countupElapsedSeconds; // For countup timer
  int? get pomodoroWorkMinutes; // For pomodoro timer
  int? get pomodoroShortBreakMinutes; // For short break
  int? get pomodoroLongBreakMinutes; // For long break
  int? get pomodoroCycle; // Number of pomodoro cycles
  int? get pomodoroCompletedCycle; // Completed pomodoro cycles
  bool get isDeleted;

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TodoModelCopyWith<TodoModel> get copyWith =>
      _$TodoModelCopyWithImpl<TodoModel>(this as TodoModel, _$identity);

  /// Serializes this TodoModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TodoModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
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
            (identical(other.parentTodoId, parentTodoId) ||
                other.parentTodoId == parentTodoId) &&
            const DeepCollectionEquality()
                .equals(other.checklistItem, checklistItem) &&
            (identical(other.timerType, timerType) ||
                other.timerType == timerType) &&
            (identical(other.countupElapsedSeconds, countupElapsedSeconds) ||
                other.countupElapsedSeconds == countupElapsedSeconds) &&
            (identical(other.pomodoroWorkMinutes, pomodoroWorkMinutes) ||
                other.pomodoroWorkMinutes == pomodoroWorkMinutes) &&
            (identical(other.pomodoroShortBreakMinutes,
                    pomodoroShortBreakMinutes) ||
                other.pomodoroShortBreakMinutes == pomodoroShortBreakMinutes) &&
            (identical(
                    other.pomodoroLongBreakMinutes, pomodoroLongBreakMinutes) ||
                other.pomodoroLongBreakMinutes == pomodoroLongBreakMinutes) &&
            (identical(other.pomodoroCycle, pomodoroCycle) ||
                other.pomodoroCycle == pomodoroCycle) &&
            (identical(other.pomodoroCompletedCycle, pomodoroCompletedCycle) ||
                other.pomodoroCompletedCycle == pomodoroCompletedCycle) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        dueDate,
        title,
        isCompleted,
        description,
        color,
        categoryId,
        icon,
        createdAt,
        updatedAt,
        isRecurring,
        recurringType,
        recurringEndDate,
        parentTodoId,
        const DeepCollectionEquality().hash(checklistItem),
        timerType,
        countupElapsedSeconds,
        pomodoroWorkMinutes,
        pomodoroShortBreakMinutes,
        pomodoroLongBreakMinutes,
        pomodoroCycle,
        pomodoroCompletedCycle,
        isDeleted
      ]);

  @override
  String toString() {
    return 'TodoModel(id: $id, dueDate: $dueDate, title: $title, isCompleted: $isCompleted, description: $description, color: $color, categoryId: $categoryId, icon: $icon, createdAt: $createdAt, updatedAt: $updatedAt, isRecurring: $isRecurring, recurringType: $recurringType, recurringEndDate: $recurringEndDate, parentTodoId: $parentTodoId, checklistItem: $checklistItem, timerType: $timerType, countupElapsedSeconds: $countupElapsedSeconds, pomodoroWorkMinutes: $pomodoroWorkMinutes, pomodoroShortBreakMinutes: $pomodoroShortBreakMinutes, pomodoroLongBreakMinutes: $pomodoroLongBreakMinutes, pomodoroCycle: $pomodoroCycle, pomodoroCompletedCycle: $pomodoroCompletedCycle, isDeleted: $isDeleted)';
  }
}

/// @nodoc
abstract mixin class $TodoModelCopyWith<$Res> {
  factory $TodoModelCopyWith(TodoModel value, $Res Function(TodoModel) _then) =
      _$TodoModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      DateTime dueDate,
      String title,
      bool isCompleted,
      String? description,
      String? color,
      int? categoryId,
      String? icon,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool? isRecurring,
      RecurringType recurringType,
      DateTime? recurringEndDate,
      int? parentTodoId,
      List<TodoCheckListItemModel> checklistItem,
      TimerType timerType,
      int? countupElapsedSeconds,
      int? pomodoroWorkMinutes,
      int? pomodoroShortBreakMinutes,
      int? pomodoroLongBreakMinutes,
      int? pomodoroCycle,
      int? pomodoroCompletedCycle,
      bool isDeleted});
}

/// @nodoc
class _$TodoModelCopyWithImpl<$Res> implements $TodoModelCopyWith<$Res> {
  _$TodoModelCopyWithImpl(this._self, this._then);

  final TodoModel _self;
  final $Res Function(TodoModel) _then;

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
    Object? categoryId = freezed,
    Object? icon = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isRecurring = freezed,
    Object? recurringType = null,
    Object? recurringEndDate = freezed,
    Object? parentTodoId = freezed,
    Object? checklistItem = null,
    Object? timerType = null,
    Object? countupElapsedSeconds = freezed,
    Object? pomodoroWorkMinutes = freezed,
    Object? pomodoroShortBreakMinutes = freezed,
    Object? pomodoroLongBreakMinutes = freezed,
    Object? pomodoroCycle = freezed,
    Object? pomodoroCompletedCycle = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      dueDate: null == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _self.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRecurring: freezed == isRecurring
          ? _self.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurringType: null == recurringType
          ? _self.recurringType
          : recurringType // ignore: cast_nullable_to_non_nullable
              as RecurringType,
      recurringEndDate: freezed == recurringEndDate
          ? _self.recurringEndDate
          : recurringEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      parentTodoId: freezed == parentTodoId
          ? _self.parentTodoId
          : parentTodoId // ignore: cast_nullable_to_non_nullable
              as int?,
      checklistItem: null == checklistItem
          ? _self.checklistItem
          : checklistItem // ignore: cast_nullable_to_non_nullable
              as List<TodoCheckListItemModel>,
      timerType: null == timerType
          ? _self.timerType
          : timerType // ignore: cast_nullable_to_non_nullable
              as TimerType,
      countupElapsedSeconds: freezed == countupElapsedSeconds
          ? _self.countupElapsedSeconds
          : countupElapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      pomodoroWorkMinutes: freezed == pomodoroWorkMinutes
          ? _self.pomodoroWorkMinutes
          : pomodoroWorkMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      pomodoroShortBreakMinutes: freezed == pomodoroShortBreakMinutes
          ? _self.pomodoroShortBreakMinutes
          : pomodoroShortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      pomodoroLongBreakMinutes: freezed == pomodoroLongBreakMinutes
          ? _self.pomodoroLongBreakMinutes
          : pomodoroLongBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      pomodoroCycle: freezed == pomodoroCycle
          ? _self.pomodoroCycle
          : pomodoroCycle // ignore: cast_nullable_to_non_nullable
              as int?,
      pomodoroCompletedCycle: freezed == pomodoroCompletedCycle
          ? _self.pomodoroCompletedCycle
          : pomodoroCompletedCycle // ignore: cast_nullable_to_non_nullable
              as int?,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [TodoModel].
extension TodoModelPatterns on TodoModel {
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
    TResult Function(_TodoModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TodoModel() when $default != null:
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
    TResult Function(_TodoModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodoModel():
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
    TResult? Function(_TodoModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodoModel() when $default != null:
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
    TResult Function(
            int id,
            DateTime dueDate,
            String title,
            bool isCompleted,
            String? description,
            String? color,
            int? categoryId,
            String? icon,
            DateTime? createdAt,
            DateTime? updatedAt,
            bool? isRecurring,
            RecurringType recurringType,
            DateTime? recurringEndDate,
            int? parentTodoId,
            List<TodoCheckListItemModel> checklistItem,
            TimerType timerType,
            int? countupElapsedSeconds,
            int? pomodoroWorkMinutes,
            int? pomodoroShortBreakMinutes,
            int? pomodoroLongBreakMinutes,
            int? pomodoroCycle,
            int? pomodoroCompletedCycle,
            bool isDeleted)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TodoModel() when $default != null:
        return $default(
            _that.id,
            _that.dueDate,
            _that.title,
            _that.isCompleted,
            _that.description,
            _that.color,
            _that.categoryId,
            _that.icon,
            _that.createdAt,
            _that.updatedAt,
            _that.isRecurring,
            _that.recurringType,
            _that.recurringEndDate,
            _that.parentTodoId,
            _that.checklistItem,
            _that.timerType,
            _that.countupElapsedSeconds,
            _that.pomodoroWorkMinutes,
            _that.pomodoroShortBreakMinutes,
            _that.pomodoroLongBreakMinutes,
            _that.pomodoroCycle,
            _that.pomodoroCompletedCycle,
            _that.isDeleted);
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
    TResult Function(
            int id,
            DateTime dueDate,
            String title,
            bool isCompleted,
            String? description,
            String? color,
            int? categoryId,
            String? icon,
            DateTime? createdAt,
            DateTime? updatedAt,
            bool? isRecurring,
            RecurringType recurringType,
            DateTime? recurringEndDate,
            int? parentTodoId,
            List<TodoCheckListItemModel> checklistItem,
            TimerType timerType,
            int? countupElapsedSeconds,
            int? pomodoroWorkMinutes,
            int? pomodoroShortBreakMinutes,
            int? pomodoroLongBreakMinutes,
            int? pomodoroCycle,
            int? pomodoroCompletedCycle,
            bool isDeleted)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodoModel():
        return $default(
            _that.id,
            _that.dueDate,
            _that.title,
            _that.isCompleted,
            _that.description,
            _that.color,
            _that.categoryId,
            _that.icon,
            _that.createdAt,
            _that.updatedAt,
            _that.isRecurring,
            _that.recurringType,
            _that.recurringEndDate,
            _that.parentTodoId,
            _that.checklistItem,
            _that.timerType,
            _that.countupElapsedSeconds,
            _that.pomodoroWorkMinutes,
            _that.pomodoroShortBreakMinutes,
            _that.pomodoroLongBreakMinutes,
            _that.pomodoroCycle,
            _that.pomodoroCompletedCycle,
            _that.isDeleted);
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
    TResult? Function(
            int id,
            DateTime dueDate,
            String title,
            bool isCompleted,
            String? description,
            String? color,
            int? categoryId,
            String? icon,
            DateTime? createdAt,
            DateTime? updatedAt,
            bool? isRecurring,
            RecurringType recurringType,
            DateTime? recurringEndDate,
            int? parentTodoId,
            List<TodoCheckListItemModel> checklistItem,
            TimerType timerType,
            int? countupElapsedSeconds,
            int? pomodoroWorkMinutes,
            int? pomodoroShortBreakMinutes,
            int? pomodoroLongBreakMinutes,
            int? pomodoroCycle,
            int? pomodoroCompletedCycle,
            bool isDeleted)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodoModel() when $default != null:
        return $default(
            _that.id,
            _that.dueDate,
            _that.title,
            _that.isCompleted,
            _that.description,
            _that.color,
            _that.categoryId,
            _that.icon,
            _that.createdAt,
            _that.updatedAt,
            _that.isRecurring,
            _that.recurringType,
            _that.recurringEndDate,
            _that.parentTodoId,
            _that.checklistItem,
            _that.timerType,
            _that.countupElapsedSeconds,
            _that.pomodoroWorkMinutes,
            _that.pomodoroShortBreakMinutes,
            _that.pomodoroLongBreakMinutes,
            _that.pomodoroCycle,
            _that.pomodoroCompletedCycle,
            _that.isDeleted);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TodoModel implements TodoModel {
  const _TodoModel(
      {required this.id,
      required this.dueDate,
      required this.title,
      required this.isCompleted,
      this.description,
      this.color,
      this.categoryId,
      this.icon,
      this.createdAt,
      this.updatedAt,
      this.isRecurring,
      this.recurringType = RecurringType.daily,
      this.recurringEndDate,
      this.parentTodoId,
      final List<TodoCheckListItemModel> checklistItem = const [],
      this.timerType = TimerType.none,
      this.countupElapsedSeconds,
      this.pomodoroWorkMinutes,
      this.pomodoroShortBreakMinutes,
      this.pomodoroLongBreakMinutes,
      this.pomodoroCycle,
      this.pomodoroCompletedCycle,
      this.isDeleted = false})
      : _checklistItem = checklistItem;
  factory _TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

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
// Keep for backward compatibility
  @override
  final int? categoryId;
// New category reference
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
  @JsonKey()
  final RecurringType recurringType;
  @override
  final DateTime? recurringEndDate;
  @override
  final int? parentTodoId;
  final List<TodoCheckListItemModel> _checklistItem;
  @override
  @JsonKey()
  List<TodoCheckListItemModel> get checklistItem {
    if (_checklistItem is EqualUnmodifiableListView) return _checklistItem;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_checklistItem);
  }

// Optional checklist item
  @override
  @JsonKey()
  final TimerType timerType;
// 'none', 'pomodoro', 'countup'
  @override
  final int? countupElapsedSeconds;
// For countup timer
  @override
  final int? pomodoroWorkMinutes;
// For pomodoro timer
  @override
  final int? pomodoroShortBreakMinutes;
// For short break
  @override
  final int? pomodoroLongBreakMinutes;
// For long break
  @override
  final int? pomodoroCycle;
// Number of pomodoro cycles
  @override
  final int? pomodoroCompletedCycle;
// Completed pomodoro cycles
  @override
  @JsonKey()
  final bool isDeleted;

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TodoModelCopyWith<_TodoModel> get copyWith =>
      __$TodoModelCopyWithImpl<_TodoModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TodoModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TodoModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
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
            (identical(other.parentTodoId, parentTodoId) ||
                other.parentTodoId == parentTodoId) &&
            const DeepCollectionEquality()
                .equals(other._checklistItem, _checklistItem) &&
            (identical(other.timerType, timerType) ||
                other.timerType == timerType) &&
            (identical(other.countupElapsedSeconds, countupElapsedSeconds) ||
                other.countupElapsedSeconds == countupElapsedSeconds) &&
            (identical(other.pomodoroWorkMinutes, pomodoroWorkMinutes) ||
                other.pomodoroWorkMinutes == pomodoroWorkMinutes) &&
            (identical(other.pomodoroShortBreakMinutes,
                    pomodoroShortBreakMinutes) ||
                other.pomodoroShortBreakMinutes == pomodoroShortBreakMinutes) &&
            (identical(
                    other.pomodoroLongBreakMinutes, pomodoroLongBreakMinutes) ||
                other.pomodoroLongBreakMinutes == pomodoroLongBreakMinutes) &&
            (identical(other.pomodoroCycle, pomodoroCycle) ||
                other.pomodoroCycle == pomodoroCycle) &&
            (identical(other.pomodoroCompletedCycle, pomodoroCompletedCycle) ||
                other.pomodoroCompletedCycle == pomodoroCompletedCycle) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        dueDate,
        title,
        isCompleted,
        description,
        color,
        categoryId,
        icon,
        createdAt,
        updatedAt,
        isRecurring,
        recurringType,
        recurringEndDate,
        parentTodoId,
        const DeepCollectionEquality().hash(_checklistItem),
        timerType,
        countupElapsedSeconds,
        pomodoroWorkMinutes,
        pomodoroShortBreakMinutes,
        pomodoroLongBreakMinutes,
        pomodoroCycle,
        pomodoroCompletedCycle,
        isDeleted
      ]);

  @override
  String toString() {
    return 'TodoModel(id: $id, dueDate: $dueDate, title: $title, isCompleted: $isCompleted, description: $description, color: $color, categoryId: $categoryId, icon: $icon, createdAt: $createdAt, updatedAt: $updatedAt, isRecurring: $isRecurring, recurringType: $recurringType, recurringEndDate: $recurringEndDate, parentTodoId: $parentTodoId, checklistItem: $checklistItem, timerType: $timerType, countupElapsedSeconds: $countupElapsedSeconds, pomodoroWorkMinutes: $pomodoroWorkMinutes, pomodoroShortBreakMinutes: $pomodoroShortBreakMinutes, pomodoroLongBreakMinutes: $pomodoroLongBreakMinutes, pomodoroCycle: $pomodoroCycle, pomodoroCompletedCycle: $pomodoroCompletedCycle, isDeleted: $isDeleted)';
  }
}

/// @nodoc
abstract mixin class _$TodoModelCopyWith<$Res>
    implements $TodoModelCopyWith<$Res> {
  factory _$TodoModelCopyWith(
          _TodoModel value, $Res Function(_TodoModel) _then) =
      __$TodoModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      DateTime dueDate,
      String title,
      bool isCompleted,
      String? description,
      String? color,
      int? categoryId,
      String? icon,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool? isRecurring,
      RecurringType recurringType,
      DateTime? recurringEndDate,
      int? parentTodoId,
      List<TodoCheckListItemModel> checklistItem,
      TimerType timerType,
      int? countupElapsedSeconds,
      int? pomodoroWorkMinutes,
      int? pomodoroShortBreakMinutes,
      int? pomodoroLongBreakMinutes,
      int? pomodoroCycle,
      int? pomodoroCompletedCycle,
      bool isDeleted});
}

/// @nodoc
class __$TodoModelCopyWithImpl<$Res> implements _$TodoModelCopyWith<$Res> {
  __$TodoModelCopyWithImpl(this._self, this._then);

  final _TodoModel _self;
  final $Res Function(_TodoModel) _then;

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? dueDate = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? description = freezed,
    Object? color = freezed,
    Object? categoryId = freezed,
    Object? icon = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isRecurring = freezed,
    Object? recurringType = null,
    Object? recurringEndDate = freezed,
    Object? parentTodoId = freezed,
    Object? checklistItem = null,
    Object? timerType = null,
    Object? countupElapsedSeconds = freezed,
    Object? pomodoroWorkMinutes = freezed,
    Object? pomodoroShortBreakMinutes = freezed,
    Object? pomodoroLongBreakMinutes = freezed,
    Object? pomodoroCycle = freezed,
    Object? pomodoroCompletedCycle = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_TodoModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      dueDate: null == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _self.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRecurring: freezed == isRecurring
          ? _self.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurringType: null == recurringType
          ? _self.recurringType
          : recurringType // ignore: cast_nullable_to_non_nullable
              as RecurringType,
      recurringEndDate: freezed == recurringEndDate
          ? _self.recurringEndDate
          : recurringEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      parentTodoId: freezed == parentTodoId
          ? _self.parentTodoId
          : parentTodoId // ignore: cast_nullable_to_non_nullable
              as int?,
      checklistItem: null == checklistItem
          ? _self._checklistItem
          : checklistItem // ignore: cast_nullable_to_non_nullable
              as List<TodoCheckListItemModel>,
      timerType: null == timerType
          ? _self.timerType
          : timerType // ignore: cast_nullable_to_non_nullable
              as TimerType,
      countupElapsedSeconds: freezed == countupElapsedSeconds
          ? _self.countupElapsedSeconds
          : countupElapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      pomodoroWorkMinutes: freezed == pomodoroWorkMinutes
          ? _self.pomodoroWorkMinutes
          : pomodoroWorkMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      pomodoroShortBreakMinutes: freezed == pomodoroShortBreakMinutes
          ? _self.pomodoroShortBreakMinutes
          : pomodoroShortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      pomodoroLongBreakMinutes: freezed == pomodoroLongBreakMinutes
          ? _self.pomodoroLongBreakMinutes
          : pomodoroLongBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      pomodoroCycle: freezed == pomodoroCycle
          ? _self.pomodoroCycle
          : pomodoroCycle // ignore: cast_nullable_to_non_nullable
              as int?,
      pomodoroCompletedCycle: freezed == pomodoroCompletedCycle
          ? _self.pomodoroCompletedCycle
          : pomodoroCompletedCycle // ignore: cast_nullable_to_non_nullable
              as int?,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
