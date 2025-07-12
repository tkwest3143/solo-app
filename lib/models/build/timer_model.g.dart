// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../timer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimerSettings _$TimerSettingsFromJson(Map<String, dynamic> json) =>
    _TimerSettings(
      workMinutes: (json['workMinutes'] as num?)?.toInt() ?? 25,
      shortBreakMinutes: (json['shortBreakMinutes'] as num?)?.toInt() ?? 5,
      longBreakMinutes: (json['longBreakMinutes'] as num?)?.toInt() ?? 15,
      cyclesUntilLongBreak:
          (json['cyclesUntilLongBreak'] as num?)?.toInt() ?? 4,
    );

Map<String, dynamic> _$TimerSettingsToJson(_TimerSettings instance) =>
    <String, dynamic>{
      'workMinutes': instance.workMinutes,
      'shortBreakMinutes': instance.shortBreakMinutes,
      'longBreakMinutes': instance.longBreakMinutes,
      'cyclesUntilLongBreak': instance.cyclesUntilLongBreak,
    };

_TimerSession _$TimerSessionFromJson(Map<String, dynamic> json) =>
    _TimerSession(
      mode: $enumDecodeNullable(_$TimerModeEnumMap, json['mode']) ??
          TimerMode.pomodoro,
      state: $enumDecodeNullable(_$TimerStatusEnumMap, json['state']) ??
          TimerStatus.idle,
      currentPhase:
          $enumDecodeNullable(_$PomodoroPhaseEnumMap, json['currentPhase']) ??
              PomodoroPhase.work,
      remainingSeconds: (json['remainingSeconds'] as num?)?.toInt() ?? 0,
      elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt() ?? 0,
      currentCycle: (json['currentCycle'] as num?)?.toInt() ?? 0,
      completedCycles: (json['completedCycles'] as num?)?.toInt() ?? 0,
      settings:
          TimerSettings.fromJson(json['settings'] as Map<String, dynamic>),
      selectedTodoId: (json['selectedTodoId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TimerSessionToJson(_TimerSession instance) =>
    <String, dynamic>{
      'mode': _$TimerModeEnumMap[instance.mode]!,
      'state': _$TimerStatusEnumMap[instance.state]!,
      'currentPhase': _$PomodoroPhaseEnumMap[instance.currentPhase]!,
      'remainingSeconds': instance.remainingSeconds,
      'elapsedSeconds': instance.elapsedSeconds,
      'currentCycle': instance.currentCycle,
      'completedCycles': instance.completedCycles,
      'settings': instance.settings,
      'selectedTodoId': instance.selectedTodoId,
    };

const _$TimerModeEnumMap = {
  TimerMode.pomodoro: 'pomodoro',
  TimerMode.countUp: 'countUp',
};

const _$TimerStatusEnumMap = {
  TimerStatus.idle: 'idle',
  TimerStatus.running: 'running',
  TimerStatus.paused: 'paused',
  TimerStatus.completed: 'completed',
};

const _$PomodoroPhaseEnumMap = {
  PomodoroPhase.work: 'work',
  PomodoroPhase.shortBreak: 'shortBreak',
  PomodoroPhase.longBreak: 'longBreak',
};
