# Settings Persistence Implementation

## Overview
This implementation adds local storage persistence to the existing settings screen using SharedPreferences. All settings are now automatically saved when changed and restored when the app is restarted.

## Implemented Features

### 1. Settings Service (`lib/services/settings_service.dart`)
- **Load Settings**: Retrieves saved settings from SharedPreferences with fallback to defaults
- **Save Settings**: Stores current settings as JSON in SharedPreferences
- **Clear Settings**: Removes saved settings (used for reset functionality)
- **Error Handling**: Graceful handling of storage errors with fallbacks

### 2. Persistent Settings State (`lib/screen/states/settings_state.dart`)
- **Initialization**: Loads saved settings on app startup
- **Auto-save**: Automatically saves settings after any change
- **Reset Functionality**: Clears saved settings and reverts to defaults

### 3. App Initialization (`lib/main.dart`)
- **Startup Loading**: Initializes settings from storage when app starts
- **Async Handling**: Properly handles asynchronous settings loading

## Settings Being Persisted

### ポモドーロ初期設定 (Pomodoro Default Settings)
- ✅ 作業時間 (Work duration): 1-60 minutes, default 25
- ✅ 短い休憩 (Short break): 1-30 minutes, default 5  
- ✅ 長い休憩 (Long break): 5-60 minutes, default 15
- ✅ 長い休憩までのサイクル (Cycles until long break): 2-10, default 4

### カラーテーマの設定 (Theme Settings)
- ✅ テーマモード (Theme mode): Light/Dark/System, default System

### 通知設定 (Notification Permissions)
- ✅ Todo期限日通知 (Todo due date notifications): default false
- ✅ ポモドーロ完了通知 (Pomodoro completion notifications): default false
- ✅ カウントアップタイマー通知 (Count-up timer notifications): default false
- ✅ 通知する時間 (Notification timing): 5-300 minutes, default 60

### お知らせ設定 (Notification Preferences)
- ✅ Todo期限日のお知らせ (Todo deadline reminders): default true
- ✅ アプリからのお知らせ (App update notifications): default true

## Technical Implementation

### Storage Format
Settings are stored as JSON in SharedPreferences under the key `app_settings`:

```json
{
  "themeMode": "system",
  "defaultWorkMinutes": 25,
  "defaultShortBreakMinutes": 5,
  "defaultLongBreakMinutes": 15,
  "defaultCyclesUntilLongBreak": 4,
  "todoDueDateNotificationsEnabled": false,
  "pomodoroCompletionNotificationsEnabled": false,
  "countUpTimerNotificationsEnabled": false,
  "todoDeadlineRemindersEnabled": true,
  "appUpdateNotificationsEnabled": true,
  "countUpNotificationMinutes": 60
}
```

### State Management Flow
1. **App Startup**: `main.dart` → `SettingsState.initialize()` → `SettingsService.loadSettings()`
2. **User Changes Setting**: UI → `SettingsState.updateXxx()` → `SettingsService.saveSettings()`
3. **Reset Settings**: UI → `SettingsState.resetToDefaults()` → `SettingsService.clearSettings()`

### Error Handling
- Failed loads return default settings
- Failed saves log errors but don't crash the app
- Malformed JSON data falls back to defaults

## Testing

### Automated Tests (`test/settings_service_test.dart`)
- ✅ Save and load settings correctly
- ✅ Return defaults when no saved settings exist
- ✅ Clear settings functionality
- ✅ Error handling for malformed data

### Manual Testing Checklist
- [ ] Change theme settings → verify persisted after app restart
- [ ] Modify pomodoro timers → verify values retained after restart  
- [ ] Toggle notification settings → verify switches remember state
- [ ] Use reset button → verify all settings return to defaults
- [ ] Verify timer integration still works with new defaults

## Dependencies Added
- `shared_preferences: ^2.3.2` - For local storage persistence

## Files Modified/Created
- **Created**: `lib/services/settings_service.dart` - Settings persistence logic
- **Created**: `test/settings_service_test.dart` - Test coverage
- **Modified**: `lib/screen/states/settings_state.dart` - Added persistence calls
- **Modified**: `lib/main.dart` - Added settings initialization  
- **Modified**: `pubspec.yaml` - Added shared_preferences dependency

## User Experience
- Settings now persist between app sessions automatically
- No additional UI changes needed - existing settings screen works seamlessly
- Reset functionality clears saved settings properly
- Smooth loading experience with proper fallbacks