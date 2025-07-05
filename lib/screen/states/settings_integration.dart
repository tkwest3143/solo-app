import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solo/screen/states/settings_state.dart';
import 'package:solo/screen/states/timer_state.dart';
import 'package:solo/models/timer_model.dart';

part 'build/settings_integration.g.dart';

/// Integration provider that syncs settings with timer defaults
@riverpod
class SettingsIntegration extends _$SettingsIntegration {
  @override
  void build() {
    // Watch settings changes and update timer defaults accordingly
    ref.listen(settingsStateProvider, (previous, next) {
      if (previous?.defaultWorkMinutes != next.defaultWorkMinutes ||
          previous?.defaultShortBreakMinutes != next.defaultShortBreakMinutes ||
          previous?.defaultLongBreakMinutes != next.defaultLongBreakMinutes ||
          previous?.defaultCyclesUntilLongBreak != next.defaultCyclesUntilLongBreak) {
        
        // Update timer settings with new defaults
        final timerController = ref.read(timerStateProvider.notifier);
        final newTimerSettings = TimerSettings(
          workMinutes: next.defaultWorkMinutes,
          shortBreakMinutes: next.defaultShortBreakMinutes,
          longBreakMinutes: next.defaultLongBreakMinutes,
          cyclesUntilLongBreak: next.defaultCyclesUntilLongBreak,
        );
        
        timerController.updateSettings(newTimerSettings);
      }
    });
  }
  
  /// Initialize timer with current settings defaults
  void initializeTimerWithSettings() {
    final settings = ref.read(settingsStateProvider);
    final timerController = ref.read(timerStateProvider.notifier);
    
    final timerSettings = TimerSettings(
      workMinutes: settings.defaultWorkMinutes,
      shortBreakMinutes: settings.defaultShortBreakMinutes,
      longBreakMinutes: settings.defaultLongBreakMinutes,
      cyclesUntilLongBreak: settings.defaultCyclesUntilLongBreak,
    );
    
    timerController.updateSettings(timerSettings);
  }
}