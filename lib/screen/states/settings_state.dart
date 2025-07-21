import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:solo/models/settings_model.dart';
import 'package:solo/services/settings_service.dart';

part 'build/settings_state.g.dart';

@riverpod
class SettingsState extends _$SettingsState {
  @override
  AppSettings build() {
    // Initialize with default settings
    // Actual loading will be handled by the initialization method
    return const AppSettings();
  }
  
  /// Initialize settings from storage
  /// This should be called during app startup
  Future<void> initialize() async {
    final loadedSettings = await SettingsService.loadSettings();
    state = loadedSettings;
  }
  
  Future<void> _saveSettings() async {
    await SettingsService.saveSettings(state);
  }

  void updateThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
    _saveSettings();
  }

  void updateDefaultWorkMinutes(int minutes) {
    state = state.copyWith(defaultWorkMinutes: minutes);
    _saveSettings();
  }

  void updateDefaultShortBreakMinutes(int minutes) {
    state = state.copyWith(defaultShortBreakMinutes: minutes);
    _saveSettings();
  }

  void updateDefaultLongBreakMinutes(int minutes) {
    state = state.copyWith(defaultLongBreakMinutes: minutes);
    _saveSettings();
  }

  void updateDefaultCyclesUntilLongBreak(int cycles) {
    state = state.copyWith(defaultCyclesUntilLongBreak: cycles);
    _saveSettings();
  }

  void toggleTodoDueDateNotifications(bool enabled) {
    state = state.copyWith(todoDueDateNotificationsEnabled: enabled);
    _saveSettings();
  }

  void togglePomodoroCompletionNotifications(bool enabled) {
    state = state.copyWith(pomodoroCompletionNotificationsEnabled: enabled);
    _saveSettings();
  }

  void toggleCountUpTimerNotifications(bool enabled) {
    state = state.copyWith(countUpTimerNotificationsEnabled: enabled);
    _saveSettings();
  }

  void toggleTodoDeadlineReminders(bool enabled) {
    state = state.copyWith(todoDeadlineRemindersEnabled: enabled);
    _saveSettings();
  }

  void toggleAppUpdateNotifications(bool enabled) {
    state = state.copyWith(appUpdateNotificationsEnabled: enabled);
    _saveSettings();
  }

  void updateCountUpNotificationMinutes(int minutes) {
    state = state.copyWith(countUpNotificationMinutes: minutes);
    _saveSettings();
  }

  void updateHasCompletedTutorial(bool completed) {
    state = state.copyWith(hasCompletedTutorial: completed);
    _saveSettings();
  }

  void resetToDefaults() {
    state = const AppSettings();
    // Clear saved settings and save the new default state
    SettingsService.clearSettings().then((_) => _saveSettings());
  }
}