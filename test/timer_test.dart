import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/services/timer_service.dart';

void main() {
  group('Timer Models', () {
    test('TimerSettings should have correct default values', () {
      const settings = TimerSettings();
      
      expect(settings.workMinutes, 25);
      expect(settings.shortBreakMinutes, 5);
      expect(settings.longBreakMinutes, 15);
      expect(settings.cyclesUntilLongBreak, 4);
    });

    test('TimerSession should initialize correctly', () {
      const settings = TimerSettings();
      const session = TimerSession(settings: settings);
      
      expect(session.mode, TimerMode.pomodoro);
      expect(session.state, TimerState.idle);
      expect(session.currentPhase, PomodoroPhase.work);
      expect(session.remainingSeconds, 0);
      expect(session.elapsedSeconds, 0);
      expect(session.currentCycle, 0);
      expect(session.completedCycles, 0);
    });

    test('TimerSession extension methods work correctly', () {
      const settings = TimerSettings(workMinutes: 10, shortBreakMinutes: 3);
      const session = TimerSession(
        settings: settings,
        mode: TimerMode.pomodoro,
        currentPhase: PomodoroPhase.work,
        remainingSeconds: 300, // 5 minutes remaining out of 10
      );
      
      expect(session.totalSecondsForCurrentPhase, 600); // 10 minutes in seconds
      expect(session.progress, 0.5); // 50% complete
      expect(session.displayTime, '05:00');
      expect(session.currentPhaseDisplayName, '作業時間');
      expect(session.isWorkPhase, true);
      expect(session.isBreakPhase, false);
    });

    test('Count-up timer session works correctly', () {
      const settings = TimerSettings();
      const session = TimerSession(
        settings: settings,
        mode: TimerMode.countUp,
        elapsedSeconds: 125, // 2 minutes 5 seconds
      );
      
      expect(session.totalSecondsForCurrentPhase, 0); // No limit for count-up
      expect(session.progress, 0.0); // No progress for count-up
      expect(session.displayTime, '02:05');
    });
  });

  group('Timer Service', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Timer service initializes with correct default state', () {
      final timerSession = container.read(timerServiceProvider);
      
      expect(timerSession.mode, TimerMode.pomodoro);
      expect(timerSession.state, TimerState.idle);
      expect(timerSession.settings.workMinutes, 25);
    });

    test('Switch to count-up mode works', () {
      final timerService = container.read(timerServiceProvider.notifier);
      
      timerService.switchMode(TimerMode.countUp);
      final session = container.read(timerServiceProvider);
      
      expect(session.mode, TimerMode.countUp);
      expect(session.state, TimerState.idle);
      expect(session.elapsedSeconds, 0);
    });

    test('Update settings works', () {
      final timerService = container.read(timerServiceProvider.notifier);
      const newSettings = TimerSettings(
        workMinutes: 30,
        shortBreakMinutes: 10,
      );
      
      timerService.updateSettings(newSettings);
      final session = container.read(timerServiceProvider);
      
      expect(session.settings.workMinutes, 30);
      expect(session.settings.shortBreakMinutes, 10);
    });

    test('Timer state transitions work correctly', () {
      final timerService = container.read(timerServiceProvider.notifier);
      
      // Initial state
      expect(container.read(canStartTimerProvider), true);
      expect(container.read(canPauseTimerProvider), false);
      expect(container.read(isTimerRunningProvider), false);
      
      // Start timer
      timerService.startTimer();
      expect(container.read(isTimerRunningProvider), true);
      expect(container.read(canStartTimerProvider), false);
      expect(container.read(canPauseTimerProvider), true);
      
      // Pause timer
      timerService.pauseTimer();
      expect(container.read(isTimerPausedProvider), true);
      expect(container.read(canStartTimerProvider), true);
      expect(container.read(canPauseTimerProvider), false);
      
      // Reset timer
      timerService.resetTimer();
      expect(container.read(timerServiceProvider).state, TimerState.idle);
    });
  });
}