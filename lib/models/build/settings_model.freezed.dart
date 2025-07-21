// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {
// Theme settings
  ThemeMode get themeMode; // Pomodoro default settings
  int get defaultWorkMinutes;
  int get defaultShortBreakMinutes;
  int get defaultLongBreakMinutes;
  int get defaultCyclesUntilLongBreak; // Notification permissions
  bool get todoDueDateNotificationsEnabled;
  bool get pomodoroCompletionNotificationsEnabled;
  bool get countUpTimerNotificationsEnabled; // Notification preferences
  bool get todoDeadlineRemindersEnabled;
  bool
      get appUpdateNotificationsEnabled; // Count-up timer notification time (in minutes)
  int get countUpNotificationMinutes;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppSettings &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.defaultWorkMinutes, defaultWorkMinutes) ||
                other.defaultWorkMinutes == defaultWorkMinutes) &&
            (identical(other.defaultShortBreakMinutes, defaultShortBreakMinutes) ||
                other.defaultShortBreakMinutes == defaultShortBreakMinutes) &&
            (identical(other.defaultLongBreakMinutes, defaultLongBreakMinutes) ||
                other.defaultLongBreakMinutes == defaultLongBreakMinutes) &&
            (identical(other.defaultCyclesUntilLongBreak, defaultCyclesUntilLongBreak) ||
                other.defaultCyclesUntilLongBreak ==
                    defaultCyclesUntilLongBreak) &&
            (identical(other.todoDueDateNotificationsEnabled, todoDueDateNotificationsEnabled) ||
                other.todoDueDateNotificationsEnabled ==
                    todoDueDateNotificationsEnabled) &&
            (identical(other.pomodoroCompletionNotificationsEnabled,
                    pomodoroCompletionNotificationsEnabled) ||
                other.pomodoroCompletionNotificationsEnabled ==
                    pomodoroCompletionNotificationsEnabled) &&
            (identical(other.countUpTimerNotificationsEnabled, countUpTimerNotificationsEnabled) ||
                other.countUpTimerNotificationsEnabled ==
                    countUpTimerNotificationsEnabled) &&
            (identical(other.todoDeadlineRemindersEnabled, todoDeadlineRemindersEnabled) ||
                other.todoDeadlineRemindersEnabled ==
                    todoDeadlineRemindersEnabled) &&
            (identical(other.appUpdateNotificationsEnabled, appUpdateNotificationsEnabled) ||
                other.appUpdateNotificationsEnabled ==
                    appUpdateNotificationsEnabled) &&
            (identical(
                    other.countUpNotificationMinutes, countUpNotificationMinutes) ||
                other.countUpNotificationMinutes == countUpNotificationMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      themeMode,
      defaultWorkMinutes,
      defaultShortBreakMinutes,
      defaultLongBreakMinutes,
      defaultCyclesUntilLongBreak,
      todoDueDateNotificationsEnabled,
      pomodoroCompletionNotificationsEnabled,
      countUpTimerNotificationsEnabled,
      todoDeadlineRemindersEnabled,
      appUpdateNotificationsEnabled,
      countUpNotificationMinutes);

  @override
  String toString() {
    return 'AppSettings(themeMode: $themeMode, defaultWorkMinutes: $defaultWorkMinutes, defaultShortBreakMinutes: $defaultShortBreakMinutes, defaultLongBreakMinutes: $defaultLongBreakMinutes, defaultCyclesUntilLongBreak: $defaultCyclesUntilLongBreak, todoDueDateNotificationsEnabled: $todoDueDateNotificationsEnabled, pomodoroCompletionNotificationsEnabled: $pomodoroCompletionNotificationsEnabled, countUpTimerNotificationsEnabled: $countUpTimerNotificationsEnabled, todoDeadlineRemindersEnabled: $todoDeadlineRemindersEnabled, appUpdateNotificationsEnabled: $appUpdateNotificationsEnabled, countUpNotificationMinutes: $countUpNotificationMinutes)';
  }
}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) _then) =
      _$AppSettingsCopyWithImpl;
  @useResult
  $Res call(
      {ThemeMode themeMode,
      int defaultWorkMinutes,
      int defaultShortBreakMinutes,
      int defaultLongBreakMinutes,
      int defaultCyclesUntilLongBreak,
      bool todoDueDateNotificationsEnabled,
      bool pomodoroCompletionNotificationsEnabled,
      bool countUpTimerNotificationsEnabled,
      bool todoDeadlineRemindersEnabled,
      bool appUpdateNotificationsEnabled,
      int countUpNotificationMinutes});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res> implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? defaultWorkMinutes = null,
    Object? defaultShortBreakMinutes = null,
    Object? defaultLongBreakMinutes = null,
    Object? defaultCyclesUntilLongBreak = null,
    Object? todoDueDateNotificationsEnabled = null,
    Object? pomodoroCompletionNotificationsEnabled = null,
    Object? countUpTimerNotificationsEnabled = null,
    Object? todoDeadlineRemindersEnabled = null,
    Object? appUpdateNotificationsEnabled = null,
    Object? countUpNotificationMinutes = null,
  }) {
    return _then(_self.copyWith(
      themeMode: null == themeMode
          ? _self.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      defaultWorkMinutes: null == defaultWorkMinutes
          ? _self.defaultWorkMinutes
          : defaultWorkMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultShortBreakMinutes: null == defaultShortBreakMinutes
          ? _self.defaultShortBreakMinutes
          : defaultShortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultLongBreakMinutes: null == defaultLongBreakMinutes
          ? _self.defaultLongBreakMinutes
          : defaultLongBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultCyclesUntilLongBreak: null == defaultCyclesUntilLongBreak
          ? _self.defaultCyclesUntilLongBreak
          : defaultCyclesUntilLongBreak // ignore: cast_nullable_to_non_nullable
              as int,
      todoDueDateNotificationsEnabled: null == todoDueDateNotificationsEnabled
          ? _self.todoDueDateNotificationsEnabled
          : todoDueDateNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      pomodoroCompletionNotificationsEnabled: null ==
              pomodoroCompletionNotificationsEnabled
          ? _self.pomodoroCompletionNotificationsEnabled
          : pomodoroCompletionNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      countUpTimerNotificationsEnabled: null == countUpTimerNotificationsEnabled
          ? _self.countUpTimerNotificationsEnabled
          : countUpTimerNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      todoDeadlineRemindersEnabled: null == todoDeadlineRemindersEnabled
          ? _self.todoDeadlineRemindersEnabled
          : todoDeadlineRemindersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      appUpdateNotificationsEnabled: null == appUpdateNotificationsEnabled
          ? _self.appUpdateNotificationsEnabled
          : appUpdateNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      countUpNotificationMinutes: null == countUpNotificationMinutes
          ? _self.countUpNotificationMinutes
          : countUpNotificationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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
    TResult Function(_AppSettings value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppSettings() when $default != null:
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
    TResult Function(_AppSettings value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppSettings():
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
    TResult? Function(_AppSettings value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppSettings() when $default != null:
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
            ThemeMode themeMode,
            int defaultWorkMinutes,
            int defaultShortBreakMinutes,
            int defaultLongBreakMinutes,
            int defaultCyclesUntilLongBreak,
            bool todoDueDateNotificationsEnabled,
            bool pomodoroCompletionNotificationsEnabled,
            bool countUpTimerNotificationsEnabled,
            bool todoDeadlineRemindersEnabled,
            bool appUpdateNotificationsEnabled,
            int countUpNotificationMinutes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppSettings() when $default != null:
        return $default(
            _that.themeMode,
            _that.defaultWorkMinutes,
            _that.defaultShortBreakMinutes,
            _that.defaultLongBreakMinutes,
            _that.defaultCyclesUntilLongBreak,
            _that.todoDueDateNotificationsEnabled,
            _that.pomodoroCompletionNotificationsEnabled,
            _that.countUpTimerNotificationsEnabled,
            _that.todoDeadlineRemindersEnabled,
            _that.appUpdateNotificationsEnabled,
            _that.countUpNotificationMinutes);
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
            ThemeMode themeMode,
            int defaultWorkMinutes,
            int defaultShortBreakMinutes,
            int defaultLongBreakMinutes,
            int defaultCyclesUntilLongBreak,
            bool todoDueDateNotificationsEnabled,
            bool pomodoroCompletionNotificationsEnabled,
            bool countUpTimerNotificationsEnabled,
            bool todoDeadlineRemindersEnabled,
            bool appUpdateNotificationsEnabled,
            int countUpNotificationMinutes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppSettings():
        return $default(
            _that.themeMode,
            _that.defaultWorkMinutes,
            _that.defaultShortBreakMinutes,
            _that.defaultLongBreakMinutes,
            _that.defaultCyclesUntilLongBreak,
            _that.todoDueDateNotificationsEnabled,
            _that.pomodoroCompletionNotificationsEnabled,
            _that.countUpTimerNotificationsEnabled,
            _that.todoDeadlineRemindersEnabled,
            _that.appUpdateNotificationsEnabled,
            _that.countUpNotificationMinutes);
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
            ThemeMode themeMode,
            int defaultWorkMinutes,
            int defaultShortBreakMinutes,
            int defaultLongBreakMinutes,
            int defaultCyclesUntilLongBreak,
            bool todoDueDateNotificationsEnabled,
            bool pomodoroCompletionNotificationsEnabled,
            bool countUpTimerNotificationsEnabled,
            bool todoDeadlineRemindersEnabled,
            bool appUpdateNotificationsEnabled,
            int countUpNotificationMinutes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppSettings() when $default != null:
        return $default(
            _that.themeMode,
            _that.defaultWorkMinutes,
            _that.defaultShortBreakMinutes,
            _that.defaultLongBreakMinutes,
            _that.defaultCyclesUntilLongBreak,
            _that.todoDueDateNotificationsEnabled,
            _that.pomodoroCompletionNotificationsEnabled,
            _that.countUpTimerNotificationsEnabled,
            _that.todoDeadlineRemindersEnabled,
            _that.appUpdateNotificationsEnabled,
            _that.countUpNotificationMinutes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AppSettings implements AppSettings {
  const _AppSettings(
      {this.themeMode = ThemeMode.system,
      this.defaultWorkMinutes = 25,
      this.defaultShortBreakMinutes = 5,
      this.defaultLongBreakMinutes = 15,
      this.defaultCyclesUntilLongBreak = 4,
      this.todoDueDateNotificationsEnabled = true,
      this.pomodoroCompletionNotificationsEnabled = true,
      this.countUpTimerNotificationsEnabled = true,
      this.todoDeadlineRemindersEnabled = true,
      this.appUpdateNotificationsEnabled = true,
      this.countUpNotificationMinutes = 60});
  factory _AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

// Theme settings
  @override
  @JsonKey()
  final ThemeMode themeMode;
// Pomodoro default settings
  @override
  @JsonKey()
  final int defaultWorkMinutes;
  @override
  @JsonKey()
  final int defaultShortBreakMinutes;
  @override
  @JsonKey()
  final int defaultLongBreakMinutes;
  @override
  @JsonKey()
  final int defaultCyclesUntilLongBreak;
// Notification permissions
  @override
  @JsonKey()
  final bool todoDueDateNotificationsEnabled;
  @override
  @JsonKey()
  final bool pomodoroCompletionNotificationsEnabled;
  @override
  @JsonKey()
  final bool countUpTimerNotificationsEnabled;
// Notification preferences
  @override
  @JsonKey()
  final bool todoDeadlineRemindersEnabled;
  @override
  @JsonKey()
  final bool appUpdateNotificationsEnabled;
// Count-up timer notification time (in minutes)
  @override
  @JsonKey()
  final int countUpNotificationMinutes;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppSettingsCopyWith<_AppSettings> get copyWith =>
      __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AppSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppSettings &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.defaultWorkMinutes, defaultWorkMinutes) ||
                other.defaultWorkMinutes == defaultWorkMinutes) &&
            (identical(other.defaultShortBreakMinutes, defaultShortBreakMinutes) ||
                other.defaultShortBreakMinutes == defaultShortBreakMinutes) &&
            (identical(other.defaultLongBreakMinutes, defaultLongBreakMinutes) ||
                other.defaultLongBreakMinutes == defaultLongBreakMinutes) &&
            (identical(other.defaultCyclesUntilLongBreak, defaultCyclesUntilLongBreak) ||
                other.defaultCyclesUntilLongBreak ==
                    defaultCyclesUntilLongBreak) &&
            (identical(other.todoDueDateNotificationsEnabled, todoDueDateNotificationsEnabled) ||
                other.todoDueDateNotificationsEnabled ==
                    todoDueDateNotificationsEnabled) &&
            (identical(other.pomodoroCompletionNotificationsEnabled,
                    pomodoroCompletionNotificationsEnabled) ||
                other.pomodoroCompletionNotificationsEnabled ==
                    pomodoroCompletionNotificationsEnabled) &&
            (identical(other.countUpTimerNotificationsEnabled, countUpTimerNotificationsEnabled) ||
                other.countUpTimerNotificationsEnabled ==
                    countUpTimerNotificationsEnabled) &&
            (identical(other.todoDeadlineRemindersEnabled, todoDeadlineRemindersEnabled) ||
                other.todoDeadlineRemindersEnabled ==
                    todoDeadlineRemindersEnabled) &&
            (identical(other.appUpdateNotificationsEnabled, appUpdateNotificationsEnabled) ||
                other.appUpdateNotificationsEnabled ==
                    appUpdateNotificationsEnabled) &&
            (identical(
                    other.countUpNotificationMinutes, countUpNotificationMinutes) ||
                other.countUpNotificationMinutes == countUpNotificationMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      themeMode,
      defaultWorkMinutes,
      defaultShortBreakMinutes,
      defaultLongBreakMinutes,
      defaultCyclesUntilLongBreak,
      todoDueDateNotificationsEnabled,
      pomodoroCompletionNotificationsEnabled,
      countUpTimerNotificationsEnabled,
      todoDeadlineRemindersEnabled,
      appUpdateNotificationsEnabled,
      countUpNotificationMinutes);

  @override
  String toString() {
    return 'AppSettings(themeMode: $themeMode, defaultWorkMinutes: $defaultWorkMinutes, defaultShortBreakMinutes: $defaultShortBreakMinutes, defaultLongBreakMinutes: $defaultLongBreakMinutes, defaultCyclesUntilLongBreak: $defaultCyclesUntilLongBreak, todoDueDateNotificationsEnabled: $todoDueDateNotificationsEnabled, pomodoroCompletionNotificationsEnabled: $pomodoroCompletionNotificationsEnabled, countUpTimerNotificationsEnabled: $countUpTimerNotificationsEnabled, todoDeadlineRemindersEnabled: $todoDeadlineRemindersEnabled, appUpdateNotificationsEnabled: $appUpdateNotificationsEnabled, countUpNotificationMinutes: $countUpNotificationMinutes)';
  }
}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(
          _AppSettings value, $Res Function(_AppSettings) _then) =
      __$AppSettingsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ThemeMode themeMode,
      int defaultWorkMinutes,
      int defaultShortBreakMinutes,
      int defaultLongBreakMinutes,
      int defaultCyclesUntilLongBreak,
      bool todoDueDateNotificationsEnabled,
      bool pomodoroCompletionNotificationsEnabled,
      bool countUpTimerNotificationsEnabled,
      bool todoDeadlineRemindersEnabled,
      bool appUpdateNotificationsEnabled,
      int countUpNotificationMinutes});
}

/// @nodoc
class __$AppSettingsCopyWithImpl<$Res> implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? themeMode = null,
    Object? defaultWorkMinutes = null,
    Object? defaultShortBreakMinutes = null,
    Object? defaultLongBreakMinutes = null,
    Object? defaultCyclesUntilLongBreak = null,
    Object? todoDueDateNotificationsEnabled = null,
    Object? pomodoroCompletionNotificationsEnabled = null,
    Object? countUpTimerNotificationsEnabled = null,
    Object? todoDeadlineRemindersEnabled = null,
    Object? appUpdateNotificationsEnabled = null,
    Object? countUpNotificationMinutes = null,
  }) {
    return _then(_AppSettings(
      themeMode: null == themeMode
          ? _self.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      defaultWorkMinutes: null == defaultWorkMinutes
          ? _self.defaultWorkMinutes
          : defaultWorkMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultShortBreakMinutes: null == defaultShortBreakMinutes
          ? _self.defaultShortBreakMinutes
          : defaultShortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultLongBreakMinutes: null == defaultLongBreakMinutes
          ? _self.defaultLongBreakMinutes
          : defaultLongBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultCyclesUntilLongBreak: null == defaultCyclesUntilLongBreak
          ? _self.defaultCyclesUntilLongBreak
          : defaultCyclesUntilLongBreak // ignore: cast_nullable_to_non_nullable
              as int,
      todoDueDateNotificationsEnabled: null == todoDueDateNotificationsEnabled
          ? _self.todoDueDateNotificationsEnabled
          : todoDueDateNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      pomodoroCompletionNotificationsEnabled: null ==
              pomodoroCompletionNotificationsEnabled
          ? _self.pomodoroCompletionNotificationsEnabled
          : pomodoroCompletionNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      countUpTimerNotificationsEnabled: null == countUpTimerNotificationsEnabled
          ? _self.countUpTimerNotificationsEnabled
          : countUpTimerNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      todoDeadlineRemindersEnabled: null == todoDeadlineRemindersEnabled
          ? _self.todoDeadlineRemindersEnabled
          : todoDeadlineRemindersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      appUpdateNotificationsEnabled: null == appUpdateNotificationsEnabled
          ? _self.appUpdateNotificationsEnabled
          : appUpdateNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      countUpNotificationMinutes: null == countUpNotificationMinutes
          ? _self.countUpNotificationMinutes
          : countUpNotificationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
