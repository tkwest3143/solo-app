// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../timer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimerSettings {
  int get workMinutes;
  int get shortBreakMinutes;
  int get longBreakMinutes;
  int get cyclesUntilLongBreak;

  /// Create a copy of TimerSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimerSettingsCopyWith<TimerSettings> get copyWith =>
      _$TimerSettingsCopyWithImpl<TimerSettings>(
          this as TimerSettings, _$identity);

  /// Serializes this TimerSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimerSettings &&
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

  @override
  String toString() {
    return 'TimerSettings(workMinutes: $workMinutes, shortBreakMinutes: $shortBreakMinutes, longBreakMinutes: $longBreakMinutes, cyclesUntilLongBreak: $cyclesUntilLongBreak)';
  }
}

/// @nodoc
abstract mixin class $TimerSettingsCopyWith<$Res> {
  factory $TimerSettingsCopyWith(
          TimerSettings value, $Res Function(TimerSettings) _then) =
      _$TimerSettingsCopyWithImpl;
  @useResult
  $Res call(
      {int workMinutes,
      int shortBreakMinutes,
      int longBreakMinutes,
      int cyclesUntilLongBreak});
}

/// @nodoc
class _$TimerSettingsCopyWithImpl<$Res>
    implements $TimerSettingsCopyWith<$Res> {
  _$TimerSettingsCopyWithImpl(this._self, this._then);

  final TimerSettings _self;
  final $Res Function(TimerSettings) _then;

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
    return _then(_self.copyWith(
      workMinutes: null == workMinutes
          ? _self.workMinutes
          : workMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakMinutes: null == shortBreakMinutes
          ? _self.shortBreakMinutes
          : shortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      longBreakMinutes: null == longBreakMinutes
          ? _self.longBreakMinutes
          : longBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      cyclesUntilLongBreak: null == cyclesUntilLongBreak
          ? _self.cyclesUntilLongBreak
          : cyclesUntilLongBreak // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [TimerSettings].
extension TimerSettingsPatterns on TimerSettings {
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
    TResult Function(_TimerSettings value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TimerSettings() when $default != null:
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
    TResult Function(_TimerSettings value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimerSettings():
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
    TResult? Function(_TimerSettings value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimerSettings() when $default != null:
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
    TResult Function(int workMinutes, int shortBreakMinutes,
            int longBreakMinutes, int cyclesUntilLongBreak)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TimerSettings() when $default != null:
        return $default(_that.workMinutes, _that.shortBreakMinutes,
            _that.longBreakMinutes, _that.cyclesUntilLongBreak);
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
    TResult Function(int workMinutes, int shortBreakMinutes,
            int longBreakMinutes, int cyclesUntilLongBreak)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimerSettings():
        return $default(_that.workMinutes, _that.shortBreakMinutes,
            _that.longBreakMinutes, _that.cyclesUntilLongBreak);
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
    TResult? Function(int workMinutes, int shortBreakMinutes,
            int longBreakMinutes, int cyclesUntilLongBreak)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimerSettings() when $default != null:
        return $default(_that.workMinutes, _that.shortBreakMinutes,
            _that.longBreakMinutes, _that.cyclesUntilLongBreak);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TimerSettings implements TimerSettings {
  const _TimerSettings(
      {this.workMinutes = 25,
      this.shortBreakMinutes = 5,
      this.longBreakMinutes = 15,
      this.cyclesUntilLongBreak = 4});
  factory _TimerSettings.fromJson(Map<String, dynamic> json) =>
      _$TimerSettingsFromJson(json);

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

  /// Create a copy of TimerSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TimerSettingsCopyWith<_TimerSettings> get copyWith =>
      __$TimerSettingsCopyWithImpl<_TimerSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TimerSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TimerSettings &&
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

  @override
  String toString() {
    return 'TimerSettings(workMinutes: $workMinutes, shortBreakMinutes: $shortBreakMinutes, longBreakMinutes: $longBreakMinutes, cyclesUntilLongBreak: $cyclesUntilLongBreak)';
  }
}

/// @nodoc
abstract mixin class _$TimerSettingsCopyWith<$Res>
    implements $TimerSettingsCopyWith<$Res> {
  factory _$TimerSettingsCopyWith(
          _TimerSettings value, $Res Function(_TimerSettings) _then) =
      __$TimerSettingsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int workMinutes,
      int shortBreakMinutes,
      int longBreakMinutes,
      int cyclesUntilLongBreak});
}

/// @nodoc
class __$TimerSettingsCopyWithImpl<$Res>
    implements _$TimerSettingsCopyWith<$Res> {
  __$TimerSettingsCopyWithImpl(this._self, this._then);

  final _TimerSettings _self;
  final $Res Function(_TimerSettings) _then;

  /// Create a copy of TimerSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? workMinutes = null,
    Object? shortBreakMinutes = null,
    Object? longBreakMinutes = null,
    Object? cyclesUntilLongBreak = null,
  }) {
    return _then(_TimerSettings(
      workMinutes: null == workMinutes
          ? _self.workMinutes
          : workMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakMinutes: null == shortBreakMinutes
          ? _self.shortBreakMinutes
          : shortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      longBreakMinutes: null == longBreakMinutes
          ? _self.longBreakMinutes
          : longBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      cyclesUntilLongBreak: null == cyclesUntilLongBreak
          ? _self.cyclesUntilLongBreak
          : cyclesUntilLongBreak // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$TimerSession {
  TimerMode get mode;
  TimerStatus get state;
  PomodoroPhase get currentPhase;
  int get remainingSeconds;
  int get elapsedSeconds;
  int get currentCycle;
  int get completedCycles;
  TimerSettings get settings;

  /// Create a copy of TimerSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimerSessionCopyWith<TimerSession> get copyWith =>
      _$TimerSessionCopyWithImpl<TimerSession>(
          this as TimerSession, _$identity);

  /// Serializes this TimerSession to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimerSession &&
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

  @override
  String toString() {
    return 'TimerSession(mode: $mode, state: $state, currentPhase: $currentPhase, remainingSeconds: $remainingSeconds, elapsedSeconds: $elapsedSeconds, currentCycle: $currentCycle, completedCycles: $completedCycles, settings: $settings)';
  }
}

/// @nodoc
abstract mixin class $TimerSessionCopyWith<$Res> {
  factory $TimerSessionCopyWith(
          TimerSession value, $Res Function(TimerSession) _then) =
      _$TimerSessionCopyWithImpl;
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
class _$TimerSessionCopyWithImpl<$Res> implements $TimerSessionCopyWith<$Res> {
  _$TimerSessionCopyWithImpl(this._self, this._then);

  final TimerSession _self;
  final $Res Function(TimerSession) _then;

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
    return _then(_self.copyWith(
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as TimerMode,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as TimerStatus,
      currentPhase: null == currentPhase
          ? _self.currentPhase
          : currentPhase // ignore: cast_nullable_to_non_nullable
              as PomodoroPhase,
      remainingSeconds: null == remainingSeconds
          ? _self.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      elapsedSeconds: null == elapsedSeconds
          ? _self.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      currentCycle: null == currentCycle
          ? _self.currentCycle
          : currentCycle // ignore: cast_nullable_to_non_nullable
              as int,
      completedCycles: null == completedCycles
          ? _self.completedCycles
          : completedCycles // ignore: cast_nullable_to_non_nullable
              as int,
      settings: null == settings
          ? _self.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as TimerSettings,
    ));
  }

  /// Create a copy of TimerSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimerSettingsCopyWith<$Res> get settings {
    return $TimerSettingsCopyWith<$Res>(_self.settings, (value) {
      return _then(_self.copyWith(settings: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TimerSession].
extension TimerSessionPatterns on TimerSession {
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
    TResult Function(_TimerSession value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TimerSession() when $default != null:
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
    TResult Function(_TimerSession value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimerSession():
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
    TResult? Function(_TimerSession value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimerSession() when $default != null:
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
            TimerMode mode,
            TimerStatus state,
            PomodoroPhase currentPhase,
            int remainingSeconds,
            int elapsedSeconds,
            int currentCycle,
            int completedCycles,
            TimerSettings settings)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TimerSession() when $default != null:
        return $default(
            _that.mode,
            _that.state,
            _that.currentPhase,
            _that.remainingSeconds,
            _that.elapsedSeconds,
            _that.currentCycle,
            _that.completedCycles,
            _that.settings);
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
            TimerMode mode,
            TimerStatus state,
            PomodoroPhase currentPhase,
            int remainingSeconds,
            int elapsedSeconds,
            int currentCycle,
            int completedCycles,
            TimerSettings settings)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimerSession():
        return $default(
            _that.mode,
            _that.state,
            _that.currentPhase,
            _that.remainingSeconds,
            _that.elapsedSeconds,
            _that.currentCycle,
            _that.completedCycles,
            _that.settings);
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
            TimerMode mode,
            TimerStatus state,
            PomodoroPhase currentPhase,
            int remainingSeconds,
            int elapsedSeconds,
            int currentCycle,
            int completedCycles,
            TimerSettings settings)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimerSession() when $default != null:
        return $default(
            _that.mode,
            _that.state,
            _that.currentPhase,
            _that.remainingSeconds,
            _that.elapsedSeconds,
            _that.currentCycle,
            _that.completedCycles,
            _that.settings);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TimerSession implements TimerSession {
  const _TimerSession(
      {this.mode = TimerMode.pomodoro,
      this.state = TimerStatus.idle,
      this.currentPhase = PomodoroPhase.work,
      this.remainingSeconds = 0,
      this.elapsedSeconds = 0,
      this.currentCycle = 0,
      this.completedCycles = 0,
      required this.settings});
  factory _TimerSession.fromJson(Map<String, dynamic> json) =>
      _$TimerSessionFromJson(json);

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

  /// Create a copy of TimerSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TimerSessionCopyWith<_TimerSession> get copyWith =>
      __$TimerSessionCopyWithImpl<_TimerSession>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TimerSessionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TimerSession &&
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

  @override
  String toString() {
    return 'TimerSession(mode: $mode, state: $state, currentPhase: $currentPhase, remainingSeconds: $remainingSeconds, elapsedSeconds: $elapsedSeconds, currentCycle: $currentCycle, completedCycles: $completedCycles, settings: $settings)';
  }
}

/// @nodoc
abstract mixin class _$TimerSessionCopyWith<$Res>
    implements $TimerSessionCopyWith<$Res> {
  factory _$TimerSessionCopyWith(
          _TimerSession value, $Res Function(_TimerSession) _then) =
      __$TimerSessionCopyWithImpl;
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
class __$TimerSessionCopyWithImpl<$Res>
    implements _$TimerSessionCopyWith<$Res> {
  __$TimerSessionCopyWithImpl(this._self, this._then);

  final _TimerSession _self;
  final $Res Function(_TimerSession) _then;

  /// Create a copy of TimerSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_TimerSession(
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as TimerMode,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as TimerStatus,
      currentPhase: null == currentPhase
          ? _self.currentPhase
          : currentPhase // ignore: cast_nullable_to_non_nullable
              as PomodoroPhase,
      remainingSeconds: null == remainingSeconds
          ? _self.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      elapsedSeconds: null == elapsedSeconds
          ? _self.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      currentCycle: null == currentCycle
          ? _self.currentCycle
          : currentCycle // ignore: cast_nullable_to_non_nullable
              as int,
      completedCycles: null == completedCycles
          ? _self.completedCycles
          : completedCycles // ignore: cast_nullable_to_non_nullable
              as int,
      settings: null == settings
          ? _self.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as TimerSettings,
    ));
  }

  /// Create a copy of TimerSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimerSettingsCopyWith<$Res> get settings {
    return $TimerSettingsCopyWith<$Res>(_self.settings, (value) {
      return _then(_self.copyWith(settings: value));
    });
  }
}

// dart format on
