import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo/services/settings_service.dart';
import 'package:solo/models/settings_model.dart';
import 'package:flutter/material.dart';

void main() {
  group('Settings Persistence Integration', () {
    setUp(() async {
      // Clear any existing preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('should handle complete persistence workflow', () async {
      // 1. Start with no saved settings - should get defaults
      var loadedSettings = await SettingsService.loadSettings();
      expect(loadedSettings.themeMode, ThemeMode.system);
      expect(loadedSettings.defaultWorkMinutes, 25);
      expect(loadedSettings.defaultShortBreakMinutes, 5);
      expect(loadedSettings.defaultLongBreakMinutes, 15);
      expect(loadedSettings.defaultCyclesUntilLongBreak, 4);
      expect(loadedSettings.todoDueDateNotificationsEnabled, false);
      expect(loadedSettings.pomodoroCompletionNotificationsEnabled, false);
      expect(loadedSettings.countUpTimerNotificationsEnabled, false);
      expect(loadedSettings.todoDeadlineRemindersEnabled, true);
      expect(loadedSettings.appUpdateNotificationsEnabled, true);
      expect(loadedSettings.countUpNotificationMinutes, 60);

      // 2. Modify settings to simulate user changes
      var modifiedSettings = loadedSettings.copyWith(
        themeMode: ThemeMode.dark,
        defaultWorkMinutes: 45,
        defaultShortBreakMinutes: 10,
        defaultLongBreakMinutes: 25,
        defaultCyclesUntilLongBreak: 3,
        todoDueDateNotificationsEnabled: true,
        pomodoroCompletionNotificationsEnabled: true,
        countUpTimerNotificationsEnabled: true,
        todoDeadlineRemindersEnabled: false,
        appUpdateNotificationsEnabled: false,
        countUpNotificationMinutes: 90,
      );

      // 3. Save the modified settings
      var saveResult = await SettingsService.saveSettings(modifiedSettings);
      expect(saveResult, true);

      // 4. Load settings again to simulate app restart
      var reloadedSettings = await SettingsService.loadSettings();
      expect(reloadedSettings.themeMode, ThemeMode.dark);
      expect(reloadedSettings.defaultWorkMinutes, 45);
      expect(reloadedSettings.defaultShortBreakMinutes, 10);
      expect(reloadedSettings.defaultLongBreakMinutes, 25);
      expect(reloadedSettings.defaultCyclesUntilLongBreak, 3);
      expect(reloadedSettings.todoDueDateNotificationsEnabled, true);
      expect(reloadedSettings.pomodoroCompletionNotificationsEnabled, true);
      expect(reloadedSettings.countUpTimerNotificationsEnabled, true);
      expect(reloadedSettings.todoDeadlineRemindersEnabled, false);
      expect(reloadedSettings.appUpdateNotificationsEnabled, false);
      expect(reloadedSettings.countUpNotificationMinutes, 90);

      // 5. Test reset functionality
      var clearResult = await SettingsService.clearSettings();
      expect(clearResult, true);

      // 6. After reset, should get defaults again
      var resetSettings = await SettingsService.loadSettings();
      expect(resetSettings.themeMode, ThemeMode.system);
      expect(resetSettings.defaultWorkMinutes, 25);
      expect(resetSettings.defaultShortBreakMinutes, 5);
      expect(resetSettings.defaultLongBreakMinutes, 15);
      expect(resetSettings.defaultCyclesUntilLongBreak, 4);
      expect(resetSettings.todoDueDateNotificationsEnabled, false);
      expect(resetSettings.pomodoroCompletionNotificationsEnabled, false);
      expect(resetSettings.countUpTimerNotificationsEnabled, false);
      expect(resetSettings.todoDeadlineRemindersEnabled, true);
      expect(resetSettings.appUpdateNotificationsEnabled, true);
      expect(resetSettings.countUpNotificationMinutes, 60);
    });

    test('should handle edge case values correctly', () async {
      // Test with minimum and maximum allowed values
      const edgeSettings = AppSettings(
        themeMode: ThemeMode.light,
        defaultWorkMinutes: 1, // minimum
        defaultShortBreakMinutes: 30, // maximum
        defaultLongBreakMinutes: 60, // maximum
        defaultCyclesUntilLongBreak: 10, // maximum
        countUpNotificationMinutes: 300, // maximum
      );

      // Save and reload
      await SettingsService.saveSettings(edgeSettings);
      final reloaded = await SettingsService.loadSettings();

      expect(reloaded.defaultWorkMinutes, 1);
      expect(reloaded.defaultShortBreakMinutes, 30);
      expect(reloaded.defaultLongBreakMinutes, 60);
      expect(reloaded.defaultCyclesUntilLongBreak, 10);
      expect(reloaded.countUpNotificationMinutes, 300);
    });

    test('should maintain data integrity across multiple save/load cycles', () async {
      // Simulate multiple user sessions with different settings
      final sessions = [
        const AppSettings(themeMode: ThemeMode.dark, defaultWorkMinutes: 30),
        const AppSettings(themeMode: ThemeMode.light, defaultWorkMinutes: 20),
        const AppSettings(themeMode: ThemeMode.system, defaultWorkMinutes: 50),
      ];

      for (final session in sessions) {
        await SettingsService.saveSettings(session);
        final loaded = await SettingsService.loadSettings();
        expect(loaded.themeMode, session.themeMode);
        expect(loaded.defaultWorkMinutes, session.defaultWorkMinutes);
      }
    });
  });
}