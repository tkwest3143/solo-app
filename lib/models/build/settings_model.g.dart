// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      defaultWorkMinutes: (json['defaultWorkMinutes'] as num?)?.toInt() ?? 25,
      defaultShortBreakMinutes:
          (json['defaultShortBreakMinutes'] as num?)?.toInt() ?? 5,
      defaultLongBreakMinutes:
          (json['defaultLongBreakMinutes'] as num?)?.toInt() ?? 15,
      defaultCyclesUntilLongBreak:
          (json['defaultCyclesUntilLongBreak'] as num?)?.toInt() ?? 4,
      todoDueDateNotificationsEnabled:
          json['todoDueDateNotificationsEnabled'] as bool? ?? true,
      pomodoroCompletionNotificationsEnabled:
          json['pomodoroCompletionNotificationsEnabled'] as bool? ?? true,
      countUpTimerNotificationsEnabled:
          json['countUpTimerNotificationsEnabled'] as bool? ?? true,
      todoDeadlineRemindersEnabled:
          json['todoDeadlineRemindersEnabled'] as bool? ?? true,
      appUpdateNotificationsEnabled:
          json['appUpdateNotificationsEnabled'] as bool? ?? true,
      countUpNotificationMinutes:
          (json['countUpNotificationMinutes'] as num?)?.toInt() ?? 60,
    );

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'defaultWorkMinutes': instance.defaultWorkMinutes,
      'defaultShortBreakMinutes': instance.defaultShortBreakMinutes,
      'defaultLongBreakMinutes': instance.defaultLongBreakMinutes,
      'defaultCyclesUntilLongBreak': instance.defaultCyclesUntilLongBreak,
      'todoDueDateNotificationsEnabled':
          instance.todoDueDateNotificationsEnabled,
      'pomodoroCompletionNotificationsEnabled':
          instance.pomodoroCompletionNotificationsEnabled,
      'countUpTimerNotificationsEnabled':
          instance.countUpTimerNotificationsEnabled,
      'todoDeadlineRemindersEnabled': instance.todoDeadlineRemindersEnabled,
      'appUpdateNotificationsEnabled': instance.appUpdateNotificationsEnabled,
      'countUpNotificationMinutes': instance.countUpNotificationMinutes,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
