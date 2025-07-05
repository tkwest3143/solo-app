import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo/services/settings_service.dart';
import 'package:solo/models/settings_model.dart';
import 'package:flutter/material.dart';

void main() {
  group('SettingsService', () {
    setUp(() async {
      // Clear any existing preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('should save and load settings correctly', () async {
      // Create test settings
      const testSettings = AppSettings(
        themeMode: ThemeMode.dark,
        defaultWorkMinutes: 30,
        defaultShortBreakMinutes: 10,
        defaultLongBreakMinutes: 20,
        defaultCyclesUntilLongBreak: 3,
        todoDueDateNotificationsEnabled: true,
        pomodoroCompletionNotificationsEnabled: true,
        countUpTimerNotificationsEnabled: true,
        todoDeadlineRemindersEnabled: false,
        appUpdateNotificationsEnabled: false,
        countUpNotificationMinutes: 120,
      );

      // Save settings
      final saveResult = await SettingsService.saveSettings(testSettings);
      expect(saveResult, true);

      // Load settings
      final loadedSettings = await SettingsService.loadSettings();

      // Verify all settings are loaded correctly
      expect(loadedSettings.themeMode, ThemeMode.dark);
      expect(loadedSettings.defaultWorkMinutes, 30);
      expect(loadedSettings.defaultShortBreakMinutes, 10);
      expect(loadedSettings.defaultLongBreakMinutes, 20);
      expect(loadedSettings.defaultCyclesUntilLongBreak, 3);
      expect(loadedSettings.todoDueDateNotificationsEnabled, true);
      expect(loadedSettings.pomodoroCompletionNotificationsEnabled, true);
      expect(loadedSettings.countUpTimerNotificationsEnabled, true);
      expect(loadedSettings.todoDeadlineRemindersEnabled, false);
      expect(loadedSettings.appUpdateNotificationsEnabled, false);
      expect(loadedSettings.countUpNotificationMinutes, 120);
    });

    test('should return default settings when no saved settings exist', () async {
      // Load settings when none exist
      final loadedSettings = await SettingsService.loadSettings();
      const defaultSettings = AppSettings();

      // Should match default settings
      expect(loadedSettings.themeMode, defaultSettings.themeMode);
      expect(loadedSettings.defaultWorkMinutes, defaultSettings.defaultWorkMinutes);
      expect(loadedSettings.defaultShortBreakMinutes, defaultSettings.defaultShortBreakMinutes);
      expect(loadedSettings.defaultLongBreakMinutes, defaultSettings.defaultLongBreakMinutes);
      expect(loadedSettings.defaultCyclesUntilLongBreak, defaultSettings.defaultCyclesUntilLongBreak);
      expect(loadedSettings.todoDueDateNotificationsEnabled, defaultSettings.todoDueDateNotificationsEnabled);
      expect(loadedSettings.pomodoroCompletionNotificationsEnabled, defaultSettings.pomodoroCompletionNotificationsEnabled);
      expect(loadedSettings.countUpTimerNotificationsEnabled, defaultSettings.countUpTimerNotificationsEnabled);
      expect(loadedSettings.todoDeadlineRemindersEnabled, defaultSettings.todoDeadlineRemindersEnabled);
      expect(loadedSettings.appUpdateNotificationsEnabled, defaultSettings.appUpdateNotificationsEnabled);
      expect(loadedSettings.countUpNotificationMinutes, defaultSettings.countUpNotificationMinutes);
    });

    test('should clear settings correctly', () async {
      // Save some settings first
      const testSettings = AppSettings(themeMode: ThemeMode.dark);
      await SettingsService.saveSettings(testSettings);

      // Clear settings
      final clearResult = await SettingsService.clearSettings();
      expect(clearResult, true);

      // Load settings should return defaults
      final loadedSettings = await SettingsService.loadSettings();
      expect(loadedSettings.themeMode, ThemeMode.system); // Default theme
    });
  });
}