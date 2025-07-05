// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
// Theme settings
  ThemeMode get themeMode =>
      throw _privateConstructorUsedError; // Pomodoro default settings
  int get defaultWorkMinutes => throw _privateConstructorUsedError;
  int get defaultShortBreakMinutes => throw _privateConstructorUsedError;
  int get defaultLongBreakMinutes => throw _privateConstructorUsedError;
  int get defaultCyclesUntilLongBreak =>
      throw _privateConstructorUsedError; // Notification permissions
  bool get todoDueDateNotificationsEnabled =>
      throw _privateConstructorUsedError;
  bool get pomodoroCompletionNotificationsEnabled =>
      throw _privateConstructorUsedError;
  bool get countUpTimerNotificationsEnabled =>
      throw _privateConstructorUsedError; // Notification preferences
  bool get todoDeadlineRemindersEnabled => throw _privateConstructorUsedError;
  bool get appUpdateNotificationsEnabled =>
      throw _privateConstructorUsedError; // Count-up timer notification time (in minutes)
  int get countUpNotificationMinutes => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
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
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      defaultWorkMinutes: null == defaultWorkMinutes
          ? _value.defaultWorkMinutes
          : defaultWorkMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultShortBreakMinutes: null == defaultShortBreakMinutes
          ? _value.defaultShortBreakMinutes
          : defaultShortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultLongBreakMinutes: null == defaultLongBreakMinutes
          ? _value.defaultLongBreakMinutes
          : defaultLongBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultCyclesUntilLongBreak: null == defaultCyclesUntilLongBreak
          ? _value.defaultCyclesUntilLongBreak
          : defaultCyclesUntilLongBreak // ignore: cast_nullable_to_non_nullable
              as int,
      todoDueDateNotificationsEnabled: null == todoDueDateNotificationsEnabled
          ? _value.todoDueDateNotificationsEnabled
          : todoDueDateNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      pomodoroCompletionNotificationsEnabled: null ==
              pomodoroCompletionNotificationsEnabled
          ? _value.pomodoroCompletionNotificationsEnabled
          : pomodoroCompletionNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      countUpTimerNotificationsEnabled: null == countUpTimerNotificationsEnabled
          ? _value.countUpTimerNotificationsEnabled
          : countUpTimerNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      todoDeadlineRemindersEnabled: null == todoDeadlineRemindersEnabled
          ? _value.todoDeadlineRemindersEnabled
          : todoDeadlineRemindersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      appUpdateNotificationsEnabled: null == appUpdateNotificationsEnabled
          ? _value.appUpdateNotificationsEnabled
          : appUpdateNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      countUpNotificationMinutes: null == countUpNotificationMinutes
          ? _value.countUpNotificationMinutes
          : countUpNotificationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
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
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

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
    return _then(_$AppSettingsImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      defaultWorkMinutes: null == defaultWorkMinutes
          ? _value.defaultWorkMinutes
          : defaultWorkMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultShortBreakMinutes: null == defaultShortBreakMinutes
          ? _value.defaultShortBreakMinutes
          : defaultShortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultLongBreakMinutes: null == defaultLongBreakMinutes
          ? _value.defaultLongBreakMinutes
          : defaultLongBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      defaultCyclesUntilLongBreak: null == defaultCyclesUntilLongBreak
          ? _value.defaultCyclesUntilLongBreak
          : defaultCyclesUntilLongBreak // ignore: cast_nullable_to_non_nullable
              as int,
      todoDueDateNotificationsEnabled: null == todoDueDateNotificationsEnabled
          ? _value.todoDueDateNotificationsEnabled
          : todoDueDateNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      pomodoroCompletionNotificationsEnabled: null ==
              pomodoroCompletionNotificationsEnabled
          ? _value.pomodoroCompletionNotificationsEnabled
          : pomodoroCompletionNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      countUpTimerNotificationsEnabled: null == countUpTimerNotificationsEnabled
          ? _value.countUpTimerNotificationsEnabled
          : countUpTimerNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      todoDeadlineRemindersEnabled: null == todoDeadlineRemindersEnabled
          ? _value.todoDeadlineRemindersEnabled
          : todoDeadlineRemindersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      appUpdateNotificationsEnabled: null == appUpdateNotificationsEnabled
          ? _value.appUpdateNotificationsEnabled
          : appUpdateNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      countUpNotificationMinutes: null == countUpNotificationMinutes
          ? _value.countUpNotificationMinutes
          : countUpNotificationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {this.themeMode = ThemeMode.system,
      this.defaultWorkMinutes = 25,
      this.defaultShortBreakMinutes = 5,
      this.defaultLongBreakMinutes = 15,
      this.defaultCyclesUntilLongBreak = 4,
      this.todoDueDateNotificationsEnabled = false,
      this.pomodoroCompletionNotificationsEnabled = false,
      this.countUpTimerNotificationsEnabled = false,
      this.todoDeadlineRemindersEnabled = true,
      this.appUpdateNotificationsEnabled = true,
      this.countUpNotificationMinutes = 60});

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

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

  @override
  String toString() {
    return 'AppSettings(themeMode: $themeMode, defaultWorkMinutes: $defaultWorkMinutes, defaultShortBreakMinutes: $defaultShortBreakMinutes, defaultLongBreakMinutes: $defaultLongBreakMinutes, defaultCyclesUntilLongBreak: $defaultCyclesUntilLongBreak, todoDueDateNotificationsEnabled: $todoDueDateNotificationsEnabled, pomodoroCompletionNotificationsEnabled: $pomodoroCompletionNotificationsEnabled, countUpTimerNotificationsEnabled: $countUpTimerNotificationsEnabled, todoDeadlineRemindersEnabled: $todoDeadlineRemindersEnabled, appUpdateNotificationsEnabled: $appUpdateNotificationsEnabled, countUpNotificationMinutes: $countUpNotificationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
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

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {final ThemeMode themeMode,
      final int defaultWorkMinutes,
      final int defaultShortBreakMinutes,
      final int defaultLongBreakMinutes,
      final int defaultCyclesUntilLongBreak,
      final bool todoDueDateNotificationsEnabled,
      final bool pomodoroCompletionNotificationsEnabled,
      final bool countUpTimerNotificationsEnabled,
      final bool todoDeadlineRemindersEnabled,
      final bool appUpdateNotificationsEnabled,
      final int countUpNotificationMinutes}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

// Theme settings
  @override
  ThemeMode get themeMode; // Pomodoro default settings
  @override
  int get defaultWorkMinutes;
  @override
  int get defaultShortBreakMinutes;
  @override
  int get defaultLongBreakMinutes;
  @override
  int get defaultCyclesUntilLongBreak; // Notification permissions
  @override
  bool get todoDueDateNotificationsEnabled;
  @override
  bool get pomodoroCompletionNotificationsEnabled;
  @override
  bool get countUpTimerNotificationsEnabled; // Notification preferences
  @override
  bool get todoDeadlineRemindersEnabled;
  @override
  bool
      get appUpdateNotificationsEnabled; // Count-up timer notification time (in minutes)
  @override
  int get countUpNotificationMinutes;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
