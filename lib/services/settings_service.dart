import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo/models/settings_model.dart';

class SettingsService {
  static const String _settingsKey = 'app_settings';
  
  /// Load settings from SharedPreferences
  /// Returns default settings if no saved settings found
  static Future<AppSettings> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      
      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        return AppSettings.fromJson(settingsMap);
      }
    } catch (e) {
      // If there's any error loading settings, fall back to defaults
      print('Error loading settings: $e');
    }
    
    // Return default settings if no saved settings or error occurred
    return const AppSettings();
  }
  
  /// Save settings to SharedPreferences
  static Future<bool> saveSettings(AppSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(settings.toJson());
      return await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      print('Error saving settings: $e');
      return false;
    }
  }
  
  /// Clear all saved settings (for reset functionality)
  static Future<bool> clearSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_settingsKey);
    } catch (e) {
      print('Error clearing settings: $e');
      return false;
    }
  }

  /// Update default pomodoro settings
  static Future<bool> updateDefaultPomodoroSettings({
    required int workMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
    required int cyclesUntilLongBreak,
  }) async {
    try {
      final currentSettings = await loadSettings();
      final updatedSettings = currentSettings.copyWith(
        defaultWorkMinutes: workMinutes,
        defaultShortBreakMinutes: shortBreakMinutes,
        defaultLongBreakMinutes: longBreakMinutes,
        defaultCyclesUntilLongBreak: cyclesUntilLongBreak,
      );
      return await saveSettings(updatedSettings);
    } catch (e) {
      print('Error updating default pomodoro settings: $e');
      return false;
    }
  }
}