import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo/screen/states/timer_state.dart';
import 'package:solo/screen/states/settings_state.dart';
import 'package:solo/screen/states/settings_integration.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/models/settings_model.dart';

void main() {
  group('Timer Settings Integration', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('timer should initialize with default work minutes from TimerSettings', () {
      // Get initial timer state
      final timerState = container.read(timerStateProvider);
      
      // Should use TimerSettings default (25 minutes), not hardcoded value
      expect(timerState.remainingSeconds, 25 * 60);
      expect(timerState.settings.workMinutes, 25);
    });

    test('timer should update when settings are changed', () {
      // Get timer controller
      final timerController = container.read(timerStateProvider.notifier);
      
      // Update timer settings to 40 minutes (as mentioned in the bug report)
      final newSettings = TimerSettings(
        workMinutes: 40,
        shortBreakMinutes: 5,
        longBreakMinutes: 15,
        cyclesUntilLongBreak: 4,
      );
      
      timerController.updateSettings(newSettings);
      
      // Check that timer state reflects the new settings
      final updatedState = container.read(timerStateProvider);
      expect(updatedState.settings.workMinutes, 40);
      expect(updatedState.remainingSeconds, 40 * 60);
    });

    test('settings integration should sync app settings with timer settings', () {
      // Initialize settings integration
      container.read(settingsIntegrationProvider);
      final settingsIntegration = container.read(settingsIntegrationProvider.notifier);
      
      // Mock app settings with custom work minutes
      final appSettings = AppSettings(defaultWorkMinutes: 35);
      container.read(settingsStateProvider.notifier).state = appSettings;
      
      // Initialize timer with settings
      settingsIntegration.initializeTimerWithSettings();
      
      // Verify timer reflects the app settings
      final timerState = container.read(timerStateProvider);
      expect(timerState.settings.workMinutes, 35);
      expect(timerState.remainingSeconds, 35 * 60);
    });
  });
}