// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../timer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimerSettingsImpl _$$TimerSettingsImplFromJson(Map<String, dynamic> json) =>
    _$TimerSettingsImpl(
      workMinutes: (json['workMinutes'] as num?)?.toInt() ?? 25,
      shortBreakMinutes: (json['shortBreakMinutes'] as num?)?.toInt() ?? 5,
      longBreakMinutes: (json['longBreakMinutes'] as num?)?.toInt() ?? 15,
      cyclesUntilLongBreak:
          (json['cyclesUntilLongBreak'] as num?)?.toInt() ?? 4,
    );

Map<String, dynamic> _$$TimerSettingsImplToJson(_$TimerSettingsImpl instance) =>
    <String, dynamic>{
      'workMinutes': instance.workMinutes,
      'shortBreakMinutes': instance.shortBreakMinutes,
      'longBreakMinutes': instance.longBreakMinutes,
      'cyclesUntilLongBreak': instance.cyclesUntilLongBreak,
    };

_$TimerSessionImpl _$$TimerSessionImplFromJson(Map<String, dynamic> json) =>
    _$TimerSessionImpl(
      mode: $enumDecodeNullable(_$TimerModeEnumMap, json['mode']) ??
          TimerMode.pomodoro,
      state: $enumDecodeNullable(_$TimerStateEnumMap, json['state']) ??
          TimerState.idle,
      currentPhase:
          $enumDecodeNullable(_$PomodoroPhaseEnumMap, json['currentPhase']) ??
              PomodoroPhase.work,
      remainingSeconds: (json['remainingSeconds'] as num?)?.toInt() ?? 0,
      elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt() ?? 0,
      currentCycle: (json['currentCycle'] as num?)?.toInt() ?? 0,
      completedCycles: (json['completedCycles'] as num?)?.toInt() ?? 0,
      settings:
          TimerSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TimerSessionImplToJson(_$TimerSessionImpl instance) =>
    <String, dynamic>{
      'mode': _$TimerModeEnumMap[instance.mode]!,
      'state': _$TimerStateEnumMap[instance.state]!,
      'currentPhase': _$PomodoroPhaseEnumMap[instance.currentPhase]!,
      'remainingSeconds': instance.remainingSeconds,
      'elapsedSeconds': instance.elapsedSeconds,
      'currentCycle': instance.currentCycle,
      'completedCycles': instance.completedCycles,
      'settings': instance.settings,
    };

const _$TimerModeEnumMap = {
  TimerMode.pomodoro: 'pomodoro',
  TimerMode.countUp: 'countUp',
};

const _$TimerStateEnumMap = {
  TimerState.idle: 'idle',
  TimerState.running: 'running',
  TimerState.paused: 'paused',
  TimerState.completed: 'completed',
};

const _$PomodoroPhaseEnumMap = {
  PomodoroPhase.work: 'work',
  PomodoroPhase.shortBreak: 'shortBreak',
  PomodoroPhase.longBreak: 'longBreak',
};
