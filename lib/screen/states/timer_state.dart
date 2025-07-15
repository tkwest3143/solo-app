import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:solo/services/settings_service.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/services/notification_service.dart';
import 'package:flutter/widgets.dart';
import 'package:audioplayers/audioplayers.dart';

part 'build/timer_state.g.dart';

@riverpod
class TimerState extends _$TimerState {
  Timer? _timer;
  final NotificationService _notificationService = NotificationService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<AppLifecycleState>? _lifecycleSubscription;
  DateTime? _lastLifecycleChange;

  @override
  TimerSession build() {
    // 初期値はデフォルト
    const settings = TimerSettings();
    // 非同期でローカルから設定を取得し、stateを更新
    _loadSettings();
    // ライフサイクル監視を開始
    _initializeLifecycleListener();
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

    // フェーズ完了時に音を再生（スキップでない場合のみ）
    if (!forceSkip) {
      _playTimerSound();
    }

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
      // フォアグラウンド時は通知なし（音のみ）
      return;
    }
    int newCompletedCycles = state.completedCycles;
    int newCurrentCycle = state.currentCycle;
    // 作業→休憩に進む場合
    if (state.currentPhase == PomodoroPhase.work) {}
    // 休憩→作業に進む場合（スキップ含む）
    if (state.currentPhase == PomodoroPhase.shortBreak) {
      newCurrentCycle = state.currentCycle + 1;
    }
    if (state.currentPhase == PomodoroPhase.longBreak) {
      newCompletedCycles = state.completedCycles + 1;
      newCurrentCycle = 0;
      // Todo選択されている場合、Todoのサイクル完了をチェック
      if (state.selectedTodoId != null) {
        _checkTodoCompletionAfterWork(newCompletedCycles);
        return; // 非同期処理のため早期リターン
      }
    }

    _continueToNextPhase(
        nextPhase, nextRemainingSeconds, newCurrentCycle, newCompletedCycles);
  }

  void _continueToNextPhase(PomodoroPhase nextPhase, int nextRemainingSeconds,
      int newCurrentCycle, int newCompletedCycles) {
    state = state.copyWith(
      currentPhase: nextPhase,
      remainingSeconds: nextRemainingSeconds,
      currentCycle: newCurrentCycle,
      completedCycles: newCompletedCycles,
      state: TimerStatus.running, // 実行中のまま継続
    );

    // タイマーを再開
    _startTicking();

    // フォアグラウンド時は通知なし（音のみで通知）
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
    // 既存のタイマーがある場合は停止
    _stopTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.mode == TimerMode.countUp) {
        _handleCountUpTick();
      } else {
        _handlePomodoroTick();
      }
    });
  }

  void _handleCountUpTick() {
    final newElapsedSeconds = state.elapsedSeconds + 1;
    state = state.copyWith(
      elapsedSeconds: newElapsedSeconds,
    );

    // 目標時間に達した場合の処理
    _checkCountUpTargetReached(newElapsedSeconds);
  }

  Future<void> _checkCountUpTargetReached(int elapsedSeconds) async {
    if (state.selectedTodoId != null && state.state == TimerStatus.running) {
      try {
        final todos = await TodoService().getTodo();
        final todo = todos.firstWhere(
          (t) => t.id == state.selectedTodoId,
          orElse: () => throw Exception('Todo not found'),
        );

        if (todo.timerType == TimerType.countup &&
            todo.countupElapsedSeconds != null &&
            elapsedSeconds >= todo.countupElapsedSeconds!) {
          // 目標時間達成時にタイマーを停止
          _stopTimer();
          state = state.copyWith(state: TimerStatus.idle);
        }
      } catch (e) {
        // エラーハンドリング - デバッグ時のみログ出力
        assert(() {
          print('Failed to check target time: $e');
          return true;
        }());
      }
    }
  }

  void _handlePomodoroTick() {
    if (state.remainingSeconds <= 0) {
      return; // 既に0以下の場合は何もしない
    }

    final newRemainingSeconds = state.remainingSeconds - 1;
    state = state.copyWith(
      remainingSeconds: newRemainingSeconds,
    );

    if (newRemainingSeconds <= 0) {
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

  /// 作業フェーズ完了後にTodoのサイクル完了をチェック
  Future<void> _checkTodoCompletionAfterWork(int newCompletedCycles) async {
    if (state.selectedTodoId == null) return;

    try {
      final todos = await TodoService().getTodo();
      final todo = todos.firstWhere(
        (t) => t.id == state.selectedTodoId,
        orElse: () => throw Exception('Todo not found'),
      );

      // ポモドーロタイマーの場合のみサイクル完了判定
      if (todo.timerType == TimerType.pomodoro && todo.pomodoroCycle != null) {
        // Todoで設定されたサイクル数に達した場合
        if (newCompletedCycles >= todo.pomodoroCycle!) {
          // タイマー完了
          state = state.copyWith(
            state: TimerStatus.completed,
            remainingSeconds: 0,
            completedCycles: newCompletedCycles,
          );
          // Todoを完了にする
          await _completeTodoIfSelected();
          return;
        }
      }

      // Todoサイクル完了していない場合、通常の次フェーズに進む
      final nextPhase = _getNextPhase();
      final nextRemainingSeconds = _getSecondsForPhase(nextPhase);

      if (nextPhase != null) {
        int newCurrentCycle = state.currentCycle + 1;
        if (nextPhase == PomodoroPhase.longBreak) {
          newCurrentCycle = 0;
        }

        _continueToNextPhase(nextPhase, nextRemainingSeconds, newCurrentCycle,
            newCompletedCycles);
      }
    } catch (e) {
      // エラーの場合、通常の次フェーズに進む
      final nextPhase = _getNextPhase();
      final nextRemainingSeconds = _getSecondsForPhase(nextPhase);

      if (nextPhase != null) {
        int newCurrentCycle = state.currentCycle + 1;
        int finalCompletedCycles = newCompletedCycles;
        if (nextPhase == PomodoroPhase.longBreak) {
          newCurrentCycle = 0;
        }

        _continueToNextPhase(nextPhase, nextRemainingSeconds, newCurrentCycle,
            finalCompletedCycles);
      }
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
    if (state.selectedTodoId != null) {
      try {
        await TodoService().completeTodoById(state.selectedTodoId!);
        // Todoを完了したらタイマーの選択をクリア
        await selectTodo(null);
      } catch (e) {
        // エラーハンドリング - デバッグ時のみログ出力
        assert(() {
          print('Failed to complete todo: $e');
          return true;
        }());
      }
    }
  }

  Future<void> completeTodoIfSelected() async {
    await _completeTodoIfSelected();
  }

  /// ライフサイクル監視を初期化
  void _initializeLifecycleListener() {
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver(
      onBackground: _handleAppBackground,
      onForeground: _handleAppForeground,
    ));
  }

  /// アプリがバックグラウンドに入った時の処理
  void _handleAppBackground() {
    final now = DateTime.now();
    // 1秒以内の連続呼び出しを防ぐ
    if (_lastLifecycleChange != null &&
        now.difference(_lastLifecycleChange!).inMilliseconds < 1000) {
      return;
    }
    _lastLifecycleChange = now;

    if (state.state == TimerStatus.running && state.isInBackground != true) {
      // タイマーを停止し、経遊時間と現在時間をstateに保存
      _stopTimer();
      state = state.copyWith(
        isInBackground: true,
        backgroundTime: DateTime.now(),
      );

      // バックグラウンドになった際、残り時間/経過時間から通知を登録
      _scheduleBackgroundNotifications();

      // デバッグ用ログ
      assert(() {
        print('[Timer] App moved to background at ${state.backgroundTime}');
        return true;
      }());
    }
  }

  /// アプリがフォアグラウンドに戻った時の処理
  void _handleAppForeground() {
    final now = DateTime.now();
    // 1秒以内の連続呼び出しを防ぐ
    if (_lastLifecycleChange != null &&
        now.difference(_lastLifecycleChange!).inMilliseconds < 1000) {
      return;
    }
    _lastLifecycleChange = now;

    // フォアグラウンドになった際、通知を消す
    _cancelBackgroundNotifications();

    if (state.isInBackground == true && state.backgroundTime != null) {
      // 現在時刻を取得し、バックグラウンドに移動した時間と比較して経過秒数を算出
      final backgroundDuration = now.difference(state.backgroundTime!);
      final elapsedSeconds = backgroundDuration.inSeconds;

      // デバッグ用ログ
      assert(() {
        print(
            '[Timer] App moved to foreground. Background duration: ${elapsedSeconds}s');
        return true;
      }());

      // 経過時間分、タイマーを経遊させる
      _syncTimerAfterBackground(elapsedSeconds);

      state = state.copyWith(
        isInBackground: false,
        backgroundTime: null,
      );

      // タイマーが実行中の場合は再度タイマースタート
      if (state.state == TimerStatus.running) {
        _startTicking();
      }
    }
  }

  /// バックグラウンド後のタイマー状態同期
  void _syncTimerAfterBackground(int elapsedSeconds) {
    if (state.mode == TimerMode.countUp) {
      // カウントアップモードの場合
      final newElapsedSeconds = state.elapsedSeconds + elapsedSeconds;
      state = state.copyWith(
        elapsedSeconds: newElapsedSeconds,
      );

      // 目標時間達成チェック
      _checkCountUpTargetReached(newElapsedSeconds);
    } else {
      // ポモドーロモードの場合
      _syncPomodoroAfterBackground(elapsedSeconds);
    }
  }

  /// ポモドーロタイマーのバックグラウンド後同期
  void _syncPomodoroAfterBackground(int elapsedSeconds) {
    int remainingElapsed = elapsedSeconds;
    var currentState = state;

    while (remainingElapsed > 0 && currentState.state == TimerStatus.running) {
      final phaseRemaining = currentState.remainingSeconds;

      if (remainingElapsed >= phaseRemaining) {
        // 次のフェーズに進む
        remainingElapsed -= phaseRemaining;
        currentState = _getNextPhaseState(currentState);

        if (currentState.state == TimerStatus.completed) {
          // セッション完了
          state = currentState; // 先にstateを更新
          _completeTodoIfSelected();
          _showTimerCompletionNotification(); // バックグラウンド復帰時は通知表示のみ
          return; // 早期リターン
        }
      } else {
        // フェーズ途中
        currentState = currentState.copyWith(
          remainingSeconds: currentState.remainingSeconds - remainingElapsed,
        );
        remainingElapsed = 0;
      }
    }

    // stateを更新
    state = currentState;

    // バックグラウンド復帰時は音なし（通知のみ）
  }

  /// 次のフェーズ状態を取得（通知やタイマー処理なし）
  TimerSession _getNextPhaseState(TimerSession currentState) {
    final nextPhase = _getNextPhase();
    if (nextPhase == null) {
      // セッション完了
      return currentState.copyWith(
        state: TimerStatus.completed,
        remainingSeconds: 0,
      );
    }

    final nextRemainingSeconds = _getSecondsForPhase(nextPhase);
    int newCompletedCycles = currentState.completedCycles;
    int newCurrentCycle = currentState.currentCycle;

    // サイクル計算ロジック（_goToNextPhaseと同じ）
    if (currentState.currentPhase == PomodoroPhase.work) {
      newCurrentCycle = currentState.currentCycle + 1;
      if (nextPhase == PomodoroPhase.longBreak) {
        newCompletedCycles = currentState.completedCycles + 1;
        newCurrentCycle = 0;
      }

      // NOTE: バックグラウンド処理では非同期のTodo取得ができないため、
      // Todo完了判定はフォアグラウンド復帰時に別途実装する必要がある
    }

    if (currentState.currentPhase == PomodoroPhase.shortBreak ||
        currentState.currentPhase == PomodoroPhase.longBreak) {
      newCurrentCycle = currentState.currentCycle + 1;
      if (currentState.currentPhase == PomodoroPhase.longBreak) {
        newCompletedCycles = currentState.completedCycles + 1;
        newCurrentCycle = 0;
      }
    }

    return currentState.copyWith(
      currentPhase: nextPhase,
      remainingSeconds: nextRemainingSeconds,
      currentCycle: newCurrentCycle,
      completedCycles: newCompletedCycles,
      state: TimerStatus.running,
    );
  }

  /// タイマー完了時の通知
  Future<void> _showTimerCompletionNotification() async {
    String? todoTitle;
    if (state.selectedTodoId != null) {
      try {
        final todos = await TodoService().getTodo();
        final todo = todos.firstWhere((t) => t.id == state.selectedTodoId);
        todoTitle = todo.title;
      } catch (e) {
        // Todo取得に失敗した場合はnullのまま
      }
    }

    await _notificationService.showTimerCompletionNotification(
      timerSession: state,
      todoTitle: todoTitle,
    );
  }

  /// バックグラウンド通知をスケジュール
  Future<void> _scheduleBackgroundNotifications() async {
    String? todoTitle;
    if (state.selectedTodoId != null) {
      try {
        final todos = await TodoService().getTodo();
        final todo = todos.firstWhere((t) => t.id == state.selectedTodoId);
        todoTitle = todo.title;
      } catch (e) {
        // Todo取得に失敗した場合はnullのまま
      }
    }

    await _notificationService.scheduleBackgroundTimerNotifications(
      timerSession: state,
      todoTitle: todoTitle,
    );
  }

  /// バックグラウンド通知をキャンセル
  Future<void> _cancelBackgroundNotifications() async {
    await _notificationService.cancelBackgroundTimerNotifications();
  }

  /// タイマー終了時の音を再生
  Future<void> _playTimerSound() async {
    try {
      // システムのデフォルト音を使用（カスタム音声ファイルがない場合）
      // 将来的にカスタム音声ファイルに変更可能
      await _audioPlayer.play(AssetSource('sounds/timer_complete.mp3'));

      // デバッグ用ログ
      assert(() {
        print('[Timer] Playing timer completion sound');
        return true;
      }());
    } catch (e) {
      // 音声再生に失敗した場合はログを出力して続行
      assert(() {
        print('[Timer] Failed to play timer sound: $e');
        return true;
      }());
    }
  }

  void cleanup() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _lifecycleSubscription?.cancel();
    _lastLifecycleChange = null;

    // クリーンアップ時に通知もキャンセル
    _cancelBackgroundNotifications();

    WidgetsBinding.instance.removeObserver(_AppLifecycleObserver(
      onBackground: _handleAppBackground,
      onForeground: _handleAppForeground,
    ));
  }
}

/// アプリのライフサイクル監視用Observer
class _AppLifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onBackground;
  final VoidCallback onForeground;

  _AppLifecycleObserver({
    required this.onBackground,
    required this.onForeground,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // デバッグ用ログ
    assert(() {
      print('[Timer] AppLifecycleState changed to: $state');
      return true;
    }());

    switch (state) {
      case AppLifecycleState.paused:
        // アプリが一時停止された時のみバックグラウンドとして扱う
        onBackground();
        break;
      case AppLifecycleState.resumed:
        // アプリが再開された時のみフォアグラウンドとして扱う
        onForeground();
        break;
      case AppLifecycleState.inactive:
        // アプリが非アクティブ状態（例：通知センターやコントロールセンターを開いた時）
        // この状態では何もしない
        break;
      case AppLifecycleState.detached:
        // アプリがデタッチされた状態
        // この状態では何もしない
        break;
      case AppLifecycleState.hidden:
        // iOS 17以降の新しい状態
        // この状態では何もしない（pausedで処理される）
        break;
    }
  }
}
