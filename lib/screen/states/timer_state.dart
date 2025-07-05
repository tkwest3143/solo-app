import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:solo/models/timer_model.dart';

class TimerStateController extends ChangeNotifier {
  Timer? _timer;
  TimerSession _session = const TimerSession(
    settings: TimerSettings(),
  );

  TimerSession get session => _session;

  void switchMode(TimerMode mode) {
    _stopTimer();
    _session = _session.copyWith(
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
    notifyListeners();
  }

  void updateSettings(TimerSettings settings) {
    _session = _session.copyWith(settings: settings);
    if (_session.mode == TimerMode.pomodoro && _session.state == TimerState.idle) {
      _initializePomodoroSession();
    }
    notifyListeners();
  }

  void startTimer() {
    if (_session.state == TimerState.running) return;
    
    if (_session.state == TimerState.idle) {
      _initializeSession();
    }
    
    _session = _session.copyWith(state: TimerState.running);
    _startTicking();
    notifyListeners();
  }

  void pauseTimer() {
    if (_session.state != TimerState.running) return;
    
    _stopTimer();
    _session = _session.copyWith(state: TimerState.paused);
    notifyListeners();
  }

  void resetTimer() {
    _stopTimer();
    
    if (_session.mode == TimerMode.pomodoro) {
      _initializePomodoroSession();
    } else {
      _session = _session.copyWith(
        state: TimerState.idle,
        elapsedSeconds: 0,
      );
    }
    notifyListeners();
  }

  void skipPhase() {
    if (_session.mode != TimerMode.pomodoro) return;
    
    _completeCurrentPhase();
  }

  void _initializeSession() {
    if (_session.mode == TimerMode.pomodoro) {
      _initializePomodoroSession();
    } else {
      _session = _session.copyWith(
        elapsedSeconds: 0,
        state: TimerState.idle,
      );
    }
  }

  void _initializePomodoroSession() {
    _session = _session.copyWith(
      state: TimerState.idle,
      currentPhase: PomodoroPhase.work,
      remainingSeconds: _session.settings.workMinutes * 60,
      currentCycle: 0,
      completedCycles: 0,
    );
  }

  void _startTicking() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_session.mode == TimerMode.countUp) {
        _handleCountUpTick();
      } else {
        _handlePomodoroTick();
      }
    });
  }

  void _handleCountUpTick() {
    _session = _session.copyWith(
      elapsedSeconds: _session.elapsedSeconds + 1,
    );
    notifyListeners();
  }

  void _handlePomodoroTick() {
    if (_session.remainingSeconds <= 0) {
      _completeCurrentPhase();
      return;
    }
    
    _session = _session.copyWith(
      remainingSeconds: _session.remainingSeconds - 1,
    );
    
    notifyListeners();
    
    if (_session.remainingSeconds == 0) {
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
      _session = _session.copyWith(
        state: TimerState.completed,
        remainingSeconds: 0,
      );
      notifyListeners();
      return;
    }
    
    // Update cycle count if completing a work session
    int newCompletedCycles = _session.completedCycles;
    int newCurrentCycle = _session.currentCycle;
    
    if (_session.currentPhase == PomodoroPhase.work) {
      newCurrentCycle = _session.currentCycle + 1;
      if (newCurrentCycle >= _session.settings.cyclesUntilLongBreak) {
        newCompletedCycles = _session.completedCycles + 1;
        newCurrentCycle = 0;
      }
    }
    
    _session = _session.copyWith(
      currentPhase: nextPhase,
      remainingSeconds: nextRemainingSeconds,
      currentCycle: newCurrentCycle,
      completedCycles: newCompletedCycles,
      state: TimerState.idle,
    );
    notifyListeners();
  }

  PomodoroPhase? _getNextPhase() {
    switch (_session.currentPhase) {
      case PomodoroPhase.work:
        // After work, check if it's time for long break
        final nextCycle = _session.currentCycle + 1;
        if (nextCycle >= _session.settings.cyclesUntilLongBreak) {
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
        return _session.settings.workMinutes * 60;
      case PomodoroPhase.shortBreak:
        return _session.settings.shortBreakMinutes * 60;
      case PomodoroPhase.longBreak:
        return _session.settings.longBreakMinutes * 60;
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}