import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:solo/services/settings_service.dart';
import 'package:solo/services/todo_service.dart';

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

  Future<void> selectTodo(int? todoId) async {
    // Todo切り替え時は常にタイマーをリセット
    _stopTimer();
    
    state = state.copyWith(
      selectedTodoId: todoId,
      state: TimerStatus.idle,
      elapsedSeconds: 0,
      currentCycle: 0,
      completedCycles: 0,
      currentPhase: PomodoroPhase.work,
    );
    
    // Todo選択時に設定を自動適用
    if (todoId != null) {
      await _loadAndApplyTodoSettings(todoId);
    } else {
      // Todo選択解除時は、ポモドーロモードならデフォルト設定を適用
      if (state.mode == TimerMode.pomodoro) {
        await _ensureDefaultSettingsForPomodoro();
        // ポモドーロの初期状態を設定
        state = state.copyWith(
          remainingSeconds: state.settings.workMinutes * 60,
        );
      } else if (state.mode == TimerMode.countUp) {
        // カウントアップの場合は0秒から開始
        state = state.copyWith(
          remainingSeconds: 0,
        );
      }
    }
  }

  Future<void> _loadAndApplyTodoSettings(int todoId) async {
    try {
      final todos = await TodoService().getTodo();
      final todo = todos.firstWhere(
        (t) => t.id == todoId,
        orElse: () => throw Exception('Todo not found'),
      );
      
      // ポモドーロタイマーの設定を適用
      if (todo.timerType == TimerType.pomodoro &&
          todo.pomodoroWorkMinutes != null &&
          todo.pomodoroShortBreakMinutes != null &&
          todo.pomodoroLongBreakMinutes != null &&
          todo.pomodoroCycle != null) {
        
        // タイマーモードをポモドーロに切り替え（Todo選択は保持）
        if (state.mode != TimerMode.pomodoro) {
          _stopTimer();
          state = state.copyWith(
            mode: TimerMode.pomodoro,
            state: TimerStatus.idle,
            elapsedSeconds: 0,
            currentCycle: 0,
            currentPhase: PomodoroPhase.work,
          );
          await _ensureDefaultSettingsForPomodoro();
        }
        
        // Todo固有の設定を適用
        applyTodoSettings(
          workMinutes: todo.pomodoroWorkMinutes!,
          shortBreakMinutes: todo.pomodoroShortBreakMinutes!,
          longBreakMinutes: todo.pomodoroLongBreakMinutes!,
          cyclesUntilLongBreak: todo.pomodoroCycle!,
        );
        
        // ポモドーロタイマーを初期状態にリセット
        state = state.copyWith(
          remainingSeconds: todo.pomodoroWorkMinutes! * 60,
          currentPhase: PomodoroPhase.work,
        );
      }
      // カウントアップタイマーの設定を適用
      else if (todo.timerType == TimerType.countup) {
        // タイマーモードをカウントアップに切り替え（Todo選択は保持）
        if (state.mode != TimerMode.countUp) {
          _stopTimer();
          state = state.copyWith(
            mode: TimerMode.countUp,
            state: TimerStatus.idle,
            elapsedSeconds: 0,
            currentCycle: 0,
            currentPhase: PomodoroPhase.work,
          );
        }
        
        // カウントアップタイマーをリセット
        state = state.copyWith(
          elapsedSeconds: 0,
          remainingSeconds: 0,
        );
      }
    } catch (e) {
      // エラーハンドリング - デバッグ時のみログ出力
      assert(() {
        print('Failed to load todo settings: $e');
        return true;
      }());
    }
  }

  void applyTodoSettings({
    required int workMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
    required int cyclesUntilLongBreak,
  }) {
    // タイマーが動いていない場合のみ設定を適用
    if (state.state == TimerStatus.idle) {
      final newSettings = TimerSettings(
        workMinutes: workMinutes,
        shortBreakMinutes: shortBreakMinutes,
        longBreakMinutes: longBreakMinutes,
        cyclesUntilLongBreak: cyclesUntilLongBreak,
      );
      
      state = state.copyWith(
        settings: newSettings,
        remainingSeconds: workMinutes * 60,
      );
    }
  }

  Future<void> switchMode(TimerMode mode) async {
    _stopTimer();
    state = state.copyWith(
      mode: mode,
      state: TimerStatus.idle,
      remainingSeconds:
          mode == TimerMode.pomodoro ? state.settings.workMinutes * 60 : 0,
      elapsedSeconds: 0,
      currentCycle: 0,
      currentPhase: PomodoroPhase.work,
      selectedTodoId: null, // モード切り替え時にTodo選択をクリア
    );
    if (mode == TimerMode.pomodoro) {
      await _ensureDefaultSettingsForPomodoro();
      _initializePomodoroSession();
    }
  }

  Future<void> _ensureDefaultSettingsForPomodoro() async {
    // Todo未選択時またはTodo設定がない場合、デフォルト設定を使用
    if (state.selectedTodoId == null) {
      final appSettings = await SettingsService.loadSettings();
      final defaultSettings = TimerSettings(
        workMinutes: appSettings.defaultWorkMinutes,
        shortBreakMinutes: appSettings.defaultShortBreakMinutes,
        longBreakMinutes: appSettings.defaultLongBreakMinutes,
        cyclesUntilLongBreak: appSettings.defaultCyclesUntilLongBreak,
      );
      
      state = state.copyWith(
        settings: defaultSettings,
        remainingSeconds: defaultSettings.workMinutes * 60,
      );
    }
  }

  void updateSettings(TimerSettings settings) {
    state = state.copyWith(settings: settings);
    if (state.mode == TimerMode.pomodoro && state.state == TimerStatus.idle) {
      _initializePomodoroSession();
    }
  }

  Future<void> saveTimerSettings(TimerSettings settings) async {
    // タイマー設定の更新
    updateSettings(settings);
    
    // Todo選択されている場合はTodo設定を更新、未選択の場合はアプリデフォルト設定を更新
    if (state.selectedTodoId != null) {
      await _updateTodoSettings(state.selectedTodoId!, settings);
    } else {
      await _updateAppDefaultSettings(settings);
    }
  }

  Future<void> _updateTodoSettings(int todoId, TimerSettings settings) async {
    try {
      // TodoServiceを使用してTodoのポモドーロ設定を更新
      await TodoService().updateTodoPomodoroSettings(
        todoId,
        workMinutes: settings.workMinutes,
        shortBreakMinutes: settings.shortBreakMinutes,
        longBreakMinutes: settings.longBreakMinutes,
        cycle: settings.cyclesUntilLongBreak,
      );
    } catch (e) {
      // エラーハンドリング
      assert(() {
        print('Failed to update todo settings: $e');
        return true;
      }());
    }
  }

  Future<void> _updateAppDefaultSettings(TimerSettings settings) async {
    try {
      // SettingsServiceを使用してアプリデフォルト設定を更新
      await SettingsService.updateDefaultPomodoroSettings(
        workMinutes: settings.workMinutes,
        shortBreakMinutes: settings.shortBreakMinutes,
        longBreakMinutes: settings.longBreakMinutes,
        cyclesUntilLongBreak: settings.cyclesUntilLongBreak,
      );
    } catch (e) {
      // エラーハンドリング
      assert(() {
        print('Failed to update app default settings: $e');
        return true;
      }());
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
      // 選択されたTodoを完了にする
      _completeTodoIfSelected();
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

  void stop() {
    _stopTimer();
    
    // カウントアップタイマーの場合、停止時にTodoを完了にする
    if (state.mode == TimerMode.countUp && state.elapsedSeconds > 0) {
      _completeTodoIfSelected();
    }
    
    state = state.copyWith(state: TimerStatus.idle);
    _initializeSession();
  }

  Future<void> _completeTodoIfSelected() async {
    // if (state.selectedTodoId != null) {
    //   try {
    //     await TodoService().toggleTodoComplete(state.selectedTodoId!);
    //   } catch (e) {
    //     // エラーハンドリング - ログ出力など
    //     print('Failed to complete todo: $e');
    //   }
    // }
  }
}
