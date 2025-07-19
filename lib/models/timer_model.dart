import 'package:freezed_annotation/freezed_annotation.dart';

part 'build/timer_model.freezed.dart';
part 'build/timer_model.g.dart';

enum TimerMode {
  pomodoro,
  countUp,
}

enum PomodoroPhase {
  work,
  shortBreak,
  longBreak,
}

enum TimerStatus {
  idle,
  running,
  paused,
  completed,
}

@freezed
sealed class TimerSettings with _$TimerSettings {
  const factory TimerSettings({
    @Default(25) int workMinutes,
    @Default(5) int shortBreakMinutes,
    @Default(15) int longBreakMinutes,
    @Default(4) int cyclesUntilLongBreak,
  }) = _TimerSettings;

  factory TimerSettings.fromJson(Map<String, dynamic> json) =>
      _$TimerSettingsFromJson(json);
}

@freezed
sealed class TimerSession with _$TimerSession {
  const factory TimerSession({
    @Default(TimerMode.pomodoro) TimerMode mode,
    @Default(TimerStatus.idle) TimerStatus state,
    @Default(PomodoroPhase.work) PomodoroPhase currentPhase,
    @Default(0) int remainingSeconds,
    @Default(0) int elapsedSeconds,
    @Default(0) int currentCycle,
    @Default(0) int completedCycles,
    required TimerSettings settings,
    int? selectedTodoId,
    DateTime? backgroundTime, // バックグラウンドに入った時刻
    bool? isInBackground, // バックグラウンド状態
  }) = _TimerSession;

  factory TimerSession.fromJson(Map<String, dynamic> json) =>
      _$TimerSessionFromJson(json);
}

extension TimerSessionExtension on TimerSession {
  int get totalSecondsForCurrentPhase {
    switch (mode) {
      case TimerMode.pomodoro:
        switch (currentPhase) {
          case PomodoroPhase.work:
            return settings.workMinutes * 60;
          case PomodoroPhase.shortBreak:
            return settings.shortBreakMinutes * 60;
          case PomodoroPhase.longBreak:
            return settings.longBreakMinutes * 60;
        }
      case TimerMode.countUp:
        return 0; // No limit for count-up timer
    }
  }

  double get progress {
    if (mode == TimerMode.countUp) return 0.0;
    final total = totalSecondsForCurrentPhase;
    if (total == 0) return 0.0;
    return (total - remainingSeconds) / total;
  }

  String get displayTime {
    final seconds =
        mode == TimerMode.countUp ? elapsedSeconds : remainingSeconds;
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String get currentPhaseDisplayName {
    switch (currentPhase) {
      case PomodoroPhase.work:
        return '作業中';
      case PomodoroPhase.shortBreak:
        return '短い休憩中';
      case PomodoroPhase.longBreak:
        return '長い休憩中';
    }
  }

  bool get isWorkPhase => currentPhase == PomodoroPhase.work;
  bool get isBreakPhase =>
      currentPhase == PomodoroPhase.shortBreak ||
      currentPhase == PomodoroPhase.longBreak;
  
  /// タイマーが実行中または進行中（一時停止を含む）かどうか
  bool get isActiveOrHasProgress => 
      state == TimerStatus.running || 
      state == TimerStatus.paused || 
      (mode == TimerMode.countUp && elapsedSeconds > 0);
}
