import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:solo/models/settings_model.dart';

part 'build/settings_state.g.dart';

@riverpod
class SettingsState extends _$SettingsState {
  @override
  AppSettings build() {
    return const AppSettings();
  }

  void updateThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
  }

  void updateDefaultWorkMinutes(int minutes) {
    state = state.copyWith(defaultWorkMinutes: minutes);
  }

  void updateDefaultShortBreakMinutes(int minutes) {
    state = state.copyWith(defaultShortBreakMinutes: minutes);
  }

  void updateDefaultLongBreakMinutes(int minutes) {
    state = state.copyWith(defaultLongBreakMinutes: minutes);
  }

  void updateDefaultCyclesUntilLongBreak(int cycles) {
    state = state.copyWith(defaultCyclesUntilLongBreak: cycles);
  }

  void toggleTodoDueDateNotifications(bool enabled) {
    state = state.copyWith(todoDueDateNotificationsEnabled: enabled);
  }

  void togglePomodoroCompletionNotifications(bool enabled) {
    state = state.copyWith(pomodoroCompletionNotificationsEnabled: enabled);
  }

  void toggleCountUpTimerNotifications(bool enabled) {
    state = state.copyWith(countUpTimerNotificationsEnabled: enabled);
  }

  void toggleTodoDeadlineReminders(bool enabled) {
    state = state.copyWith(todoDeadlineRemindersEnabled: enabled);
  }

  void toggleAppUpdateNotifications(bool enabled) {
    state = state.copyWith(appUpdateNotificationsEnabled: enabled);
  }

  void updateCountUpNotificationMinutes(int minutes) {
    state = state.copyWith(countUpNotificationMinutes: minutes);
  }

  void resetToDefaults() {
    state = const AppSettings();
  }
}