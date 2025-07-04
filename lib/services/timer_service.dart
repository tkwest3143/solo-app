import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solo/models/timer_model.dart';

part 'build/timer_service.g.dart';

@riverpod
class TimerService extends _$TimerService {
  Timer? _timer;

  @override
  TimerSession build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    
    return TimerSession(
      settings: const TimerSettings(),
    );
  }

  void switchMode(TimerMode mode) {
    _stopTimer();
    state = state.copyWith(
      mode: mode,
      state: TimerState.idle,
      remainingSeconds: 0,
      elapsedSeconds: 0,
      currentCycle: 0,
      currentPhase: PomodoroPhase.work,
    );
    
    if (mode == TimerMode.pomodoro) {
      _initializePomodoroSession();
    }
  }

  void updateSettings(TimerSettings settings) {
    state = state.copyWith(settings: settings);
    if (state.mode == TimerMode.pomodoro && state.state == TimerState.idle) {
      _initializePomodoroSession();
    }
  }

  void startTimer() {
    if (state.state == TimerState.running) return;
    
    if (state.state == TimerState.idle) {
      _initializeSession();
    }
    
    state = state.copyWith(state: TimerState.running);
    _startTicking();
  }

  void pauseTimer() {
    if (state.state != TimerState.running) return;
    
    _stopTimer();
    state = state.copyWith(state: TimerState.paused);
  }

  void resetTimer() {
    _stopTimer();
    
    if (state.mode == TimerMode.pomodoro) {
      _initializePomodoroSession();
    } else {
      state = state.copyWith(
        state: TimerState.idle,
        elapsedSeconds: 0,
      );
    }
  }

  void skipPhase() {
    if (state.mode != TimerMode.pomodoro) return;
    
    _completeCurrentPhase();
  }

  void _initializeSession() {
    if (state.mode == TimerMode.pomodoro) {
      _initializePomodoroSession();
    } else {
      state = state.copyWith(
        elapsedSeconds: 0,
        state: TimerState.idle,
      );
    }
  }

  void _initializePomodoroSession() {
    state = state.copyWith(
      state: TimerState.idle,
      currentPhase: PomodoroPhase.work,
      remainingSeconds: state.settings.workMinutes * 60,
      currentCycle: 0,
      completedCycles: 0,
    );
  }

  void _startTicking() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.mode == TimerMode.countUp) {
        _handleCountUpTick();
      } else {
        _handlePomodoroTick();
      }
    });
  }

  void _handleCountUpTick() {
    state = state.copyWith(
      elapsedSeconds: state.elapsedSeconds + 1,
    );
  }

  void _handlePomodoroTick() {
    if (state.remainingSeconds <= 0) {
      _completeCurrentPhase();
      return;
    }
    
    state = state.copyWith(
      remainingSeconds: state.remainingSeconds - 1,
    );
    
    if (state.remainingSeconds == 0) {
      _completeCurrentPhase();
    }
  }

  void _completeCurrentPhase() {
    _stopTimer();
    
    // Determine next phase
    final nextPhase = _getNextPhase();
    final nextRemainingSeconds = _getSecondsForPhase(nextPhase);
    
    if (nextPhase == null) {
      // All cycles completed
      state = state.copyWith(
        state: TimerState.completed,
        remainingSeconds: 0,
      );
      return;
    }
    
    // Update cycle count if completing a work session
    int newCompletedCycles = state.completedCycles;
    int newCurrentCycle = state.currentCycle;
    
    if (state.currentPhase == PomodoroPhase.work) {
      newCurrentCycle = state.currentCycle + 1;
      if (newCurrentCycle >= state.settings.cyclesUntilLongBreak) {
        newCompletedCycles = state.completedCycles + 1;
        newCurrentCycle = 0;
      }
    }
    
    state = state.copyWith(
      currentPhase: nextPhase,
      remainingSeconds: nextRemainingSeconds,
      currentCycle: newCurrentCycle,
      completedCycles: newCompletedCycles,
      state: TimerState.idle,
    );
  }

  PomodoroPhase? _getNextPhase() {
    switch (state.currentPhase) {
      case PomodoroPhase.work:
        // After work, check if it's time for long break
        final nextCycle = state.currentCycle + 1;
        if (nextCycle >= state.settings.cyclesUntilLongBreak) {
          return PomodoroPhase.longBreak;
        } else {
          return PomodoroPhase.shortBreak;
        }
      case PomodoroPhase.shortBreak:
      case PomodoroPhase.longBreak:
        return PomodoroPhase.work;
    }
  }

  int _getSecondsForPhase(PomodoroPhase? phase) {
    if (phase == null) return 0;
    
    switch (phase) {
      case PomodoroPhase.work:
        return state.settings.workMinutes * 60;
      case PomodoroPhase.shortBreak:
        return state.settings.shortBreakMinutes * 60;
      case PomodoroPhase.longBreak:
        return state.settings.longBreakMinutes * 60;
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

@riverpod
TimerSettings timerSettings(TimerSettingsRef ref) {
  final session = ref.watch(timerServiceProvider);
  return session.settings;
}

@riverpod
bool isTimerRunning(IsTimerRunningRef ref) {
  final session = ref.watch(timerServiceProvider);
  return session.state == TimerState.running;
}

@riverpod
bool isTimerPaused(IsTimerPausedRef ref) {
  final session = ref.watch(timerServiceProvider);
  return session.state == TimerState.paused;
}

@riverpod
bool canStartTimer(CanStartTimerRef ref) {
  final session = ref.watch(timerServiceProvider);
  return session.state == TimerState.idle || session.state == TimerState.paused;
}

@riverpod
bool canPauseTimer(CanPauseTimerRef ref) {
  final session = ref.watch(timerServiceProvider);
  return session.state == TimerState.running;
}

@riverpod
bool showSkipButton(ShowSkipButtonRef ref) {
  final session = ref.watch(timerServiceProvider);
  return session.mode == TimerMode.pomodoro && 
         (session.state == TimerState.running || session.state == TimerState.paused);
}