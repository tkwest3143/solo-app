import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/services/settings_service.dart';

part 'build/timer_state.g.dart';

@riverpod
class TimerState extends _$TimerState {
  Timer? _timer;

  @override
  TimerSession build() {
    // 初期値はデフォルト
    const settings = TimerSettings();
    // 非同期でローカルから設定を取得し、stateを更新
    _loadSettings();
    return TimerSession(
      settings: settings,
      mode: TimerMode.pomodoro,
      remainingSeconds: settings.workMinutes * 60,
    );
  }

  Future<void> _loadSettings() async {
    // AppSettingsを取得
    final appSettings = await SettingsService.loadSettings();
    // AppSettingsからTimerSettingsを生成
    final loadedSettings = TimerSettings(
      workMinutes: appSettings.defaultWorkMinutes,
      shortBreakMinutes: appSettings.defaultShortBreakMinutes,
      longBreakMinutes: appSettings.defaultLongBreakMinutes,
      cyclesUntilLongBreak: appSettings.defaultCyclesUntilLongBreak,
    );
    state = state.copyWith(
      settings: loadedSettings,
      remainingSeconds: loadedSettings.workMinutes * 60,
    );
  }

  void switchMode(TimerMode mode) {
    _stopTimer();
    state = state.copyWith(
      mode: mode,
      state: TimerStatus.idle,
      remainingSeconds:
          mode == TimerMode.pomodoro ? state.settings.workMinutes * 60 : 0,
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
    if (state.mode == TimerMode.pomodoro && state.state == TimerStatus.idle) {
      _initializePomodoroSession();
    }
  }

  void startTimer() {
    if (state.state == TimerStatus.running) return;
    // idle かつ 残り時間が0の場合のみ初期化
    if (state.state == TimerStatus.idle && state.remainingSeconds == 0) {
      _initializeSession();
    }
    // それ以外は現在のフェーズ・残り時間を維持して running に
    state = state.copyWith(state: TimerStatus.running);
    _startTicking();
  }

  void pauseTimer() {
    if (state.state != TimerStatus.running) return;
    _stopTimer();
    state = state.copyWith(state: TimerStatus.paused);
  }

  void resetTimer() {
    _stopTimer();
    if (state.mode == TimerMode.pomodoro) {
      // サイクルもリセット
      state = state.copyWith(
        state: TimerStatus.idle,
        currentPhase: PomodoroPhase.work,
        remainingSeconds: state.settings.workMinutes * 60,
        currentCycle: 0,
        completedCycles: 0,
      );
    } else {
      state = state.copyWith(
        state: TimerStatus.idle,
        elapsedSeconds: 0,
      );
    }
  }

  void skipPhase() {
    if (state.mode != TimerMode.pomodoro) return;
    _goToNextPhase(forceSkip: true);
  }

  void _goToNextPhase({bool forceSkip = false}) {
    _stopTimer();
    final nextPhase = _getNextPhase();
    final nextRemainingSeconds = _getSecondsForPhase(nextPhase);
    if (nextPhase == null) {
      // セッション完了
      state = state.copyWith(
        state: TimerStatus.completed,
        remainingSeconds: 0,
      );
      return;
    }
    int newCompletedCycles = state.completedCycles;
    int newCurrentCycle = state.currentCycle;
    // 作業→休憩に進む場合
    if (state.currentPhase == PomodoroPhase.work) {
      if (!forceSkip) {
        newCurrentCycle = state.currentCycle + 1;
        if (nextPhase == PomodoroPhase.longBreak) {
          newCompletedCycles = state.completedCycles + 1;
          newCurrentCycle = 0;
        }
      }
    }
    // 休憩→作業に進む場合（スキップ含む）
    if (state.currentPhase == PomodoroPhase.shortBreak ||
        state.currentPhase == PomodoroPhase.longBreak) {
      newCurrentCycle = state.currentCycle + 1;
      // 長い休憩後はサイクルリセット＆完了サイクル+1
      if (state.currentPhase == PomodoroPhase.longBreak) {
        newCompletedCycles = state.completedCycles + 1;
        newCurrentCycle = 0;
      }
    }
    state = state.copyWith(
      currentPhase: nextPhase,
      remainingSeconds: nextRemainingSeconds,
      currentCycle: newCurrentCycle,
      completedCycles: newCompletedCycles,
      state: TimerStatus.idle,
    );
  }

  void _initializeSession() {
    if (state.mode == TimerMode.pomodoro) {
      _initializePomodoroSession();
    } else {
      state = state.copyWith(
        elapsedSeconds: 0,
        state: TimerStatus.idle,
      );
    }
  }

  void _initializePomodoroSession() {
    // サイクルはリセットしない
    state = state.copyWith(
      state: TimerStatus.idle,
      currentPhase: PomodoroPhase.work,
      remainingSeconds: state.settings.workMinutes * 60,
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
      _goToNextPhase();
      return;
    }
    state = state.copyWith(
      remainingSeconds: state.remainingSeconds - 1,
    );
    if (state.remainingSeconds == 0) {
      _goToNextPhase();
    }
  }

  PomodoroPhase? _getNextPhase() {
    switch (state.currentPhase) {
      case PomodoroPhase.work:
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
