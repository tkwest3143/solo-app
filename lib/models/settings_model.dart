import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'build/settings_model.freezed.dart';
part 'build/settings_model.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    // Theme settings
    @Default(ThemeMode.system) ThemeMode themeMode,
    
    // Pomodoro default settings
    @Default(25) int defaultWorkMinutes,
    @Default(5) int defaultShortBreakMinutes,
    @Default(15) int defaultLongBreakMinutes,
    @Default(4) int defaultCyclesUntilLongBreak,
    
    // Notification permissions
    @Default(false) bool todoDueDateNotificationsEnabled,
    @Default(false) bool pomodoroCompletionNotificationsEnabled,
    @Default(false) bool countUpTimerNotificationsEnabled,
    
    // Notification preferences
    @Default(true) bool todoDeadlineRemindersEnabled,
    @Default(true) bool appUpdateNotificationsEnabled,
    
    // Count-up timer notification time (in minutes)
    @Default(60) int countUpNotificationMinutes,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

extension AppSettingsExtension on AppSettings {
  String get themeDisplayName {
    switch (themeMode) {
      case ThemeMode.light:
        return 'ライトテーマ';
      case ThemeMode.dark:
        return 'ダークテーマ';
      case ThemeMode.system:
        return 'システム設定に従う';
    }
  }
  
  String get countUpNotificationDisplayTime {
    if (countUpNotificationMinutes < 60) {
      return '${countUpNotificationMinutes}分';
    } else {
      final hours = countUpNotificationMinutes ~/ 60;
      final minutes = countUpNotificationMinutes % 60;
      if (minutes == 0) {
        return '${hours}時間';
      } else {
        return '${hours}時間${minutes}分';
      }
    }
  }
}