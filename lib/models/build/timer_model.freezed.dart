// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../timer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TimerSettings _$TimerSettingsFromJson(Map<String, dynamic> json) {
  return _TimerSettings.fromJson(json);
}

/// @nodoc
mixin _$TimerSettings {
  int get workMinutes => throw _privateConstructorUsedError;
  int get shortBreakMinutes => throw _privateConstructorUsedError;
  int get longBreakMinutes => throw _privateConstructorUsedError;
  int get cyclesUntilLongBreak => throw _privateConstructorUsedError;

  /// Serializes this TimerSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimerSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimerSettingsCopyWith<TimerSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerSettingsCopyWith<$Res> {
  factory $TimerSettingsCopyWith(
          TimerSettings value, $Res Function(TimerSettings) then) =
      _$TimerSettingsCopyWithImpl<$Res, TimerSettings>;
  @useResult
  $Res call(
      {int workMinutes,
      int shortBreakMinutes,
      int longBreakMinutes,
      int cyclesUntilLongBreak});
}

/// @nodoc
class _$TimerSettingsCopyWithImpl<$Res, $Val extends TimerSettings>
    implements $TimerSettingsCopyWith<$Res> {
  _$TimerSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimerSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workMinutes = null,
    Object? shortBreakMinutes = null,
    Object? longBreakMinutes = null,
    Object? cyclesUntilLongBreak = null,
  }) {
    return _then(_value.copyWith(
      workMinutes: null == workMinutes
          ? _value.workMinutes
          : workMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakMinutes: null == shortBreakMinutes
          ? _value.shortBreakMinutes
          : shortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      longBreakMinutes: null == longBreakMinutes
          ? _value.longBreakMinutes
          : longBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      cyclesUntilLongBreak: null == cyclesUntilLongBreak
          ? _value.cyclesUntilLongBreak
          : cyclesUntilLongBreak // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimerSettingsImplCopyWith<$Res>
    implements $TimerSettingsCopyWith<$Res> {
  factory _$$TimerSettingsImplCopyWith(
          _$TimerSettingsImpl value, $Res Function(_$TimerSettingsImpl) then) =
      __$$TimerSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int workMinutes,
      int shortBreakMinutes,
      int longBreakMinutes,
      int cyclesUntilLongBreak});
}

/// @nodoc
class __$$TimerSettingsImplCopyWithImpl<$Res>
    extends _$TimerSettingsCopyWithImpl<$Res, _$TimerSettingsImpl>
    implements _$$TimerSettingsImplCopyWith<$Res> {
  __$$TimerSettingsImplCopyWithImpl(
      _$TimerSettingsImpl _value, $Res Function(_$TimerSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimerSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workMinutes = null,
    Object? shortBreakMinutes = null,
    Object? longBreakMinutes = null,
    Object? cyclesUntilLongBreak = null,
  }) {
    return _then(_$TimerSettingsImpl(
      workMinutes: null == workMinutes
          ? _value.workMinutes
          : workMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakMinutes: null == shortBreakMinutes
          ? _value.shortBreakMinutes
          : shortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      longBreakMinutes: null == longBreakMinutes
          ? _value.longBreakMinutes
          : longBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      cyclesUntilLongBreak: null == cyclesUntilLongBreak
          ? _value.cyclesUntilLongBreak
          : cyclesUntilLongBreak // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimerSettingsImpl implements _TimerSettings {
  const _$TimerSettingsImpl(
      {this.workMinutes = 25,
      this.shortBreakMinutes = 5,
      this.longBreakMinutes = 15,
      this.cyclesUntilLongBreak = 4});

  factory _$TimerSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimerSettingsImplFromJson(json);

  @override
  @JsonKey()
  final int workMinutes;
  @override
  @JsonKey()
  final int shortBreakMinutes;
  @override
  @JsonKey()
  final int longBreakMinutes;
  @override
  @JsonKey()
  final int cyclesUntilLongBreak;

  @override
  String toString() {
    return 'TimerSettings(workMinutes: $workMinutes, shortBreakMinutes: $shortBreakMinutes, longBreakMinutes: $longBreakMinutes, cyclesUntilLongBreak: $cyclesUntilLongBreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerSettingsImpl &&
            (identical(other.workMinutes, workMinutes) ||
                other.workMinutes == workMinutes) &&
            (identical(other.shortBreakMinutes, shortBreakMinutes) ||
                other.shortBreakMinutes == shortBreakMinutes) &&
            (identical(other.longBreakMinutes, longBreakMinutes) ||
                other.longBreakMinutes == longBreakMinutes) &&
            (identical(other.cyclesUntilLongBreak, cyclesUntilLongBreak) ||
                other.cyclesUntilLongBreak == cyclesUntilLongBreak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, workMinutes, shortBreakMinutes,
      longBreakMinutes, cyclesUntilLongBreak);

  /// Create a copy of TimerSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerSettingsImplCopyWith<_$TimerSettingsImpl> get copyWith =>
      __$$TimerSettingsImplCopyWithImpl<_$TimerSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimerSettingsImplToJson(
      this,
    );
  }
}

abstract class _TimerSettings implements TimerSettings {
  const factory _TimerSettings(
      {final int workMinutes,
      final int shortBreakMinutes,
      final int longBreakMinutes,
      final int cyclesUntilLongBreak}) = _$TimerSettingsImpl;

  factory _TimerSettings.fromJson(Map<String, dynamic> json) =
      _$TimerSettingsImpl.fromJson;

  @override
  int get workMinutes;
  @override
  int get shortBreakMinutes;
  @override
  int get longBreakMinutes;
  @override
  int get cyclesUntilLongBreak;

  /// Create a copy of TimerSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerSettingsImplCopyWith<_$TimerSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimerSession _$TimerSessionFromJson(Map<String, dynamic> json) {
  return _TimerSession.fromJson(json);
}

/// @nodoc
mixin _$TimerSession {
  TimerMode get mode => throw _privateConstructorUsedError;
  TimerStatus get state => throw _privateConstructorUsedError;
  PomodoroPhase get currentPhase => throw _privateConstructorUsedError;
  int get remainingSeconds => throw _privateConstructorUsedError;
  int get elapsedSeconds => throw _privateConstructorUsedError;
  int get currentCycle => throw _privateConstructorUsedError;
  int get completedCycles => throw _privateConstructorUsedError;
  TimerSettings get settings => throw _privateConstructorUsedError;

  /// Serializes this TimerSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimerSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimerSessionCopyWith<TimerSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerSessionCopyWith<$Res> {
  factory $TimerSessionCopyWith(
          TimerSession value, $Res Function(TimerSession) then) =
      _$TimerSessionCopyWithImpl<$Res, TimerSession>;
  @useResult
  $Res call(
      {TimerMode mode,
      TimerStatus state,
      PomodoroPhase currentPhase,
      int remainingSeconds,
      int elapsedSeconds,
      int currentCycle,
      int completedCycles,
      TimerSettings settings});

  $TimerSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$TimerSessionCopyWithImpl<$Res, $Val extends TimerSession>
    implements $TimerSessionCopyWith<$Res> {
  _$TimerSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimerSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? state = null,
    Object? currentPhase = null,
    Object? remainingSeconds = null,
    Object? elapsedSeconds = null,
    Object? currentCycle = null,
    Object? completedCycles = null,
    Object? settings = null,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as TimerMode,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as TimerStatus,
      currentPhase: null == currentPhase
          ? _value.currentPhase
          : currentPhase // ignore: cast_nullable_to_non_nullable
              as PomodoroPhase,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      currentCycle: null == currentCycle
          ? _value.currentCycle
          : currentCycle // ignore: cast_nullable_to_non_nullable
              as int,
      completedCycles: null == completedCycles
          ? _value.completedCycles
          : completedCycles // ignore: cast_nullable_to_non_nullable
              as int,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as TimerSettings,
    ) as $Val);
  }

  /// Create a copy of TimerSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimerSettingsCopyWith<$Res> get settings {
    return $TimerSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TimerSessionImplCopyWith<$Res>
    implements $TimerSessionCopyWith<$Res> {
  factory _$$TimerSessionImplCopyWith(
          _$TimerSessionImpl value, $Res Function(_$TimerSessionImpl) then) =
      __$$TimerSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TimerMode mode,
      TimerStatus state,
      PomodoroPhase currentPhase,
      int remainingSeconds,
      int elapsedSeconds,
      int currentCycle,
      int completedCycles,
      TimerSettings settings});

  @override
  $TimerSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$TimerSessionImplCopyWithImpl<$Res>
    extends _$TimerSessionCopyWithImpl<$Res, _$TimerSessionImpl>
    implements _$$TimerSessionImplCopyWith<$Res> {
  __$$TimerSessionImplCopyWithImpl(
      _$TimerSessionImpl _value, $Res Function(_$TimerSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimerSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? state = null,
    Object? currentPhase = null,
    Object? remainingSeconds = null,
    Object? elapsedSeconds = null,
    Object? currentCycle = null,
    Object? completedCycles = null,
    Object? settings = null,
  }) {
    return _then(_$TimerSessionImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as TimerMode,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as TimerStatus,
      currentPhase: null == currentPhase
          ? _value.currentPhase
          : currentPhase // ignore: cast_nullable_to_non_nullable
              as PomodoroPhase,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      currentCycle: null == currentCycle
          ? _value.currentCycle
          : currentCycle // ignore: cast_nullable_to_non_nullable
              as int,
      completedCycles: null == completedCycles
          ? _value.completedCycles
          : completedCycles // ignore: cast_nullable_to_non_nullable
              as int,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as TimerSettings,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimerSessionImpl implements _TimerSession {
  const _$TimerSessionImpl(
      {this.mode = TimerMode.pomodoro,
      this.state = TimerStatus.idle,
      this.currentPhase = PomodoroPhase.work,
      this.remainingSeconds = 0,
      this.elapsedSeconds = 0,
      this.currentCycle = 0,
      this.completedCycles = 0,
      required this.settings});

  factory _$TimerSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimerSessionImplFromJson(json);

  @override
  @JsonKey()
  final TimerMode mode;
  @override
  @JsonKey()
  final TimerStatus state;
  @override
  @JsonKey()
  final PomodoroPhase currentPhase;
  @override
  @JsonKey()
  final int remainingSeconds;
  @override
  @JsonKey()
  final int elapsedSeconds;
  @override
  @JsonKey()
  final int currentCycle;
  @override
  @JsonKey()
  final int completedCycles;
  @override
  final TimerSettings settings;

  @override
  String toString() {
    return 'TimerSession(mode: $mode, state: $state, currentPhase: $currentPhase, remainingSeconds: $remainingSeconds, elapsedSeconds: $elapsedSeconds, currentCycle: $currentCycle, completedCycles: $completedCycles, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerSessionImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.currentPhase, currentPhase) ||
                other.currentPhase == currentPhase) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.currentCycle, currentCycle) ||
                other.currentCycle == currentCycle) &&
            (identical(other.completedCycles, completedCycles) ||
                other.completedCycles == completedCycles) &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mode,
      state,
      currentPhase,
      remainingSeconds,
      elapsedSeconds,
      currentCycle,
      completedCycles,
      settings);

  /// Create a copy of TimerSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerSessionImplCopyWith<_$TimerSessionImpl> get copyWith =>
      __$$TimerSessionImplCopyWithImpl<_$TimerSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimerSessionImplToJson(
      this,
    );
  }
}

abstract class _TimerSession implements TimerSession {
  const factory _TimerSession(
      {final TimerMode mode,
      final TimerStatus state,
      final PomodoroPhase currentPhase,
      final int remainingSeconds,
      final int elapsedSeconds,
      final int currentCycle,
      final int completedCycles,
      required final TimerSettings settings}) = _$TimerSessionImpl;

  factory _TimerSession.fromJson(Map<String, dynamic> json) =
      _$TimerSessionImpl.fromJson;

  @override
  TimerMode get mode;
  @override
  TimerStatus get state;
  @override
  PomodoroPhase get currentPhase;
  @override
  int get remainingSeconds;
  @override
  int get elapsedSeconds;
  @override
  int get currentCycle;
  @override
  int get completedCycles;
  @override
  TimerSettings get settings;

  /// Create a copy of TimerSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerSessionImplCopyWith<_$TimerSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
