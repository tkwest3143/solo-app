import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/models/settings_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// 通知サービスを初期化する
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Request permissions for iOS
    await _requestPermissions();

    _isInitialized = true;
  }

  /// 通知権限をリクエストする
  Future<void> _requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// 通知タップ時の処理
  void _onDidReceiveNotificationResponse(NotificationResponse response) {}

  /// TodoのID用の通知IDを生成（重複を避けるため1000番台を使用）
  int _generateNotificationId(int todoId) {
    return 1000 + todoId;
  }

  /// タイマー通知用の通知IDを生成（重複を避けるため2000番台を使用）
  int _generateTimerNotificationId() {
    return 2000; // タイマー通知は単一なので固定ID
  }

  /// Todoの期限1時間前に通知をスケジュールする
  Future<void> scheduleTodoDeadlineNotification(TodoModel todo, {AppSettings? settings}) async {
    // 設定で期限日通知が無効な場合は通知しない
    if (settings != null && !settings.todoDueDateNotificationsEnabled) {
      return;
    }

    // 完了済みのTodoは通知しない
    if (todo.isCompleted) {
      return;
    }

    // 期限の1時間前を計算
    final notificationTime = todo.dueDate.subtract(const Duration(hours: 1));

    // 過去の時間の場合は通知しない
    if (notificationTime.isBefore(DateTime.now())) {
      return;
    }

    // 初期化されていない場合は早期リターン（テスト環境対応）
    if (!_isInitialized) {
      return;
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _generateNotificationId(todo.id),
      'Todo期限のお知らせ',
      '「${todo.title}」の期限まで1時間です',
      tz.TZDateTime.from(notificationTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_deadline_channel',
          'Todo期限通知',
          channelDescription: 'Todoの期限1時間前に通知します',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'todo_${todo.id}',
    );
  }

  /// 複数のTodoに対して一括で通知をスケジュールする
  Future<void> scheduleAllTodoNotifications(List<TodoModel> todos, {AppSettings? settings}) async {
    for (final todo in todos) {
      await scheduleTodoDeadlineNotification(todo, settings: settings);
    }
  }

  /// 指定したTodoの通知をキャンセルする
  Future<void> cancelTodoNotification(int todoId) async {
    await _flutterLocalNotificationsPlugin
        .cancel(_generateNotificationId(todoId));
  }

  /// すべての通知をキャンセルする
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// 今日のTodoに対して通知をスケジュールする
  Future<void> scheduleTodayTodoNotifications(
      List<TodoModel> todayTodos, {AppSettings? settings}) async {
    // 今日のTodoのうち、未完了で期限が1時間以上先のものに対して通知をスケジュール
    final notifiableTodos = todayTodos.where((todo) {
      if (todo.isCompleted) return false;

      final notificationTime = todo.dueDate.subtract(const Duration(hours: 1));
      return notificationTime.isAfter(DateTime.now());
    }).toList();

    await scheduleAllTodoNotifications(notifiableTodos, settings: settings);
  }

  /// ポモドーロタイマーの状態変更通知を表示
  Future<void> showTimerPhaseNotification({
    required TimerSession timerSession,
    String? todoTitle,
    AppSettings? settings,
  }) async {
    // 設定でポモドーロ完了通知が無効な場合は通知しない
    if (settings != null && !settings.pomodoroCompletionNotificationsEnabled) {
      return;
    }

    // 初期化されていない場合は早期リターン
    if (!_isInitialized) {
      return;
    }

    String title;
    String body;

    switch (timerSession.currentPhase) {
      case PomodoroPhase.work:
        title = '作業開始';
        body = todoTitle != null ? '「$todoTitle」の作業を開始しましょう' : '作業を開始しましょう';
        break;
      case PomodoroPhase.shortBreak:
        title = '短い休憩';
        body = '${timerSession.settings.shortBreakMinutes}分間の休憩を取りましょう';
        break;
      case PomodoroPhase.longBreak:
        title = '長い休憩';
        body = '${timerSession.settings.longBreakMinutes}分間の休憩を取りましょう';
        break;
    }

    // 経過時間情報を追加
    if (timerSession.completedCycles > 0) {
      body += '\n完了サイクル: ${timerSession.completedCycles}';
    }

    await _flutterLocalNotificationsPlugin.show(
      _generateTimerNotificationId(),
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'timer_phase_channel',
          'ポモドーロタイマー',
          channelDescription: 'ポモドーロタイマーの状態変更を通知します',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'timer_phase_${timerSession.currentPhase.name}',
    );
  }

  /// タイマー完了通知を表示
  Future<void> showTimerCompletionNotification({
    required TimerSession timerSession,
    String? todoTitle,
    AppSettings? settings,
  }) async {
    // 設定に基づいて通知を制御
    if (settings != null) {
      if (timerSession.mode == TimerMode.pomodoro && 
          !settings.pomodoroCompletionNotificationsEnabled) {
        return;
      }
      if (timerSession.mode == TimerMode.countUp && 
          !settings.countUpTimerNotificationsEnabled) {
        return;
      }
    }

    // 初期化されていない場合は早期リターン
    if (!_isInitialized) {
      return;
    }

    String title;
    String body;

    if (timerSession.mode == TimerMode.pomodoro) {
      title = 'ポモドーロセッション完了';
      body = todoTitle != null
          ? '「$todoTitle」のポモドーロセッションが完了しました！'
          : 'ポモドーロセッションが完了しました！';
      body += '\n完了サイクル: ${timerSession.completedCycles}';
    } else {
      title = 'カウントアップタイマー';
      final minutes = timerSession.elapsedSeconds ~/ 60;
      final seconds = timerSession.elapsedSeconds % 60;
      body = todoTitle != null
          ? '「$todoTitle」: $minutes分$seconds秒経過'
          : '$minutes分$seconds秒経過';
    }

    await _flutterLocalNotificationsPlugin.show(
      _generateTimerNotificationId(),
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'timer_completion_channel',
          'タイマー完了',
          channelDescription: 'タイマー完了を通知します',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'timer_completion',
    );
  }

  /// タイマー通知をキャンセル
  Future<void> cancelTimerNotification() async {
    await _flutterLocalNotificationsPlugin
        .cancel(_generateTimerNotificationId());
  }

  /// バックグラウンドタイマー通知用のIDを生成（3000番台を使用）
  int _generateBackgroundTimerNotificationId(int index) {
    return 3000 + index;
  }

  /// バックグラウンドでタイマー通知をスケジュール
  Future<void> scheduleBackgroundTimerNotifications({
    required TimerSession timerSession,
    TodoModel? todo, // Todoタイトルはオプション
    AppSettings? settings,
  }) async {
    // 設定に基づいて通知を制御
    if (settings != null) {
      if (timerSession.mode == TimerMode.pomodoro && 
          !settings.pomodoroCompletionNotificationsEnabled) {
        return;
      }
      if (timerSession.mode == TimerMode.countUp && 
          !settings.countUpTimerNotificationsEnabled) {
        return;
      }
    }

    // 初期化されていない場合は早期リターン
    if (!_isInitialized) {
      return;
    }

    // 既存のバックグラウンドタイマー通知をキャンセル
    await cancelBackgroundTimerNotifications();

    if (timerSession.mode == TimerMode.pomodoro) {
      // ポモドーロモードの場合、残り時間で通知をスケジュール
      await _schedulePomodoroBackgroundNotification(
        timerSession: timerSession,
        todo: todo,
        settings: settings,
      );
    } else if (timerSession.mode == TimerMode.countUp) {
      // カウントアップモードの場合、定期的な通知をスケジュール
      await _scheduleCountUpBackgroundNotifications(
        timerSession: timerSession,
        todoTitle: todo?.title,
        settings: settings,
      );
    }
  }

  /// ポモドーロモードのバックグラウンド通知をスケジュール
  Future<void> _schedulePomodoroBackgroundNotification({
    required TimerSession timerSession,
    TodoModel? todo,
    AppSettings? settings,
  }) async {
    if (timerSession.remainingSeconds <= 0) return;

    // 現在の状態をベースに通知をスケジュール
    await _scheduleAllPhaseNotifications(
        timerSession: timerSession, todo: todo, settings: settings);
  }

  /// 全フェーズの通知をスケジュール
  Future<void> _scheduleAllPhaseNotifications(
      {required TimerSession timerSession, TodoModel? todo, AppSettings? settings}) async {
    int notificationIndex = 0;
    DateTime currentTime = DateTime.now();

    // 現在のフェーズの残り時間から開始
    int remainingSeconds = timerSession.remainingSeconds;
    PomodoroPhase currentPhase = timerSession.currentPhase;
    int currentCycle = timerSession.currentCycle;
    int completedCycles = timerSession.completedCycles;

    // 最大100個の通知を制限として設定
    const maxNotifications = 100;
    
    // Todo完了サイクル数を取得
    final targetCompletedCycles = todo?.pomodoroCycle;

    while (notificationIndex < maxNotifications) {
      // 現在のフェーズの通知をスケジュール
      final phaseEndTime = currentTime.add(Duration(seconds: remainingSeconds));
      
      // 通常のフェーズ通知をスケジュール
      await _schedulePhaseNotification(
        notificationIndex: notificationIndex,
        notificationTime: phaseEndTime,
        phase: currentPhase,
        cycleInfo: _getCycleInfo(currentCycle, completedCycles),
        todo: todo,
      );
      
      notificationIndex++;

      // 次のフェーズを計算
      final nextPhaseInfo = _getNextPhaseInfo(
        currentPhase: currentPhase,
        currentCycle: currentCycle,
        completedCycles: completedCycles,
        settings: timerSession.settings,
      );

      if (nextPhaseInfo == null) {
        // セッション完了
        break;
      }

      // 作業フェーズ→休憩フェーズの遷移時に、Todo完了サイクル数に達するかチェック
      if (currentPhase == PomodoroPhase.work && 
          targetCompletedCycles != null) {
        // 作業フェーズ終了後の完了サイクル数を計算
        final nextCycle = currentCycle + 1;
        final willCompleteCycle = nextCycle >= timerSession.settings.cyclesUntilLongBreak;
        final newCompletedCycles = willCompleteCycle ? completedCycles + 1 : completedCycles;
        
        if (newCompletedCycles >= targetCompletedCycles) {
          // 休憩フェーズの通知もスケジュールしてから、タイマー完了通知をスケジュール
          final breakPhaseEndTime = phaseEndTime.add(Duration(seconds: _getSecondsForPhase(nextPhaseInfo.phase, timerSession.settings)));
          
          // 休憩フェーズの通知をスケジュール
          await _schedulePhaseNotification(
            notificationIndex: notificationIndex,
            notificationTime: breakPhaseEndTime,
            phase: nextPhaseInfo.phase,
            cycleInfo: _getCycleInfo(nextPhaseInfo.currentCycle, nextPhaseInfo.completedCycles),
            todo: todo,
          );
          
          notificationIndex++;
          
          // タイマー完了通知をスケジュール（休憩終了時）
          await _scheduleTimerCompletionNotification(
            notificationIndex: notificationIndex,
            notificationTime: breakPhaseEndTime,
            todo: todo,
            completedCycles: targetCompletedCycles,
          );
          
          break; // タイマー完了時は以降の通知は不要
        }
      }

      // Todo完了サイクル数に達した場合は終了
      if (targetCompletedCycles != null &&
          nextPhaseInfo.completedCycles >= targetCompletedCycles) {
        break;
      }

      // 次のフェーズに移行
      currentTime = phaseEndTime;
      currentPhase = nextPhaseInfo.phase;
      currentCycle = nextPhaseInfo.currentCycle;
      completedCycles = nextPhaseInfo.completedCycles;
      remainingSeconds =
          _getSecondsForPhase(currentPhase, timerSession.settings);
    }
  }

  /// 個別のフェーズ通知をスケジュール
  Future<void> _schedulePhaseNotification({
    required int notificationIndex,
    required DateTime notificationTime,
    required PomodoroPhase phase,
    required String cycleInfo,
    TodoModel? todo,
  }) async {
    String title = _getPhaseEndTitle(phase);
    String body = _getPhaseEndBody(phase, cycleInfo, todo);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _generateBackgroundTimerNotificationId(notificationIndex),
      title,
      body,
      tz.TZDateTime.from(notificationTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'background_timer_channel',
          'バックグラウンドタイマー',
          channelDescription: 'バックグラウンドでのタイマー通知',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'background_timer_${phase.name}_$notificationIndex',
    );
  }

  /// タイマー完了通知をスケジュール
  Future<void> _scheduleTimerCompletionNotification({
    required int notificationIndex,
    required DateTime notificationTime,
    TodoModel? todo,
    int? completedCycles,
  }) async {
    String title = 'ポモドーロタイマー完了';
    String body = todo != null 
        ? '「${todo.title}」のタイマーが完了しました！'
        : 'ポモドーロタイマーが完了しました！';
    
    if (completedCycles != null) {
      body += '\n完了サイクル: $completedCycles';
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _generateBackgroundTimerNotificationId(notificationIndex),
      title,
      body,
      tz.TZDateTime.from(notificationTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'background_timer_channel',
          'バックグラウンドタイマー',
          channelDescription: 'バックグラウンドでのタイマー通知',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'background_timer_completion_$notificationIndex',
    );
  }

  /// 次のフェーズ情報を取得
  _NextPhaseInfo? _getNextPhaseInfo({
    required PomodoroPhase currentPhase,
    required int currentCycle,
    required int completedCycles,
    required TimerSettings settings,
  }) {
    PomodoroPhase? nextPhase;
    int newCurrentCycle = currentCycle;
    int newCompletedCycles = completedCycles;

    switch (currentPhase) {
      case PomodoroPhase.work:
        // 作業フェーズから休憩フェーズへ
        final nextCycle = currentCycle + 1;
        if (nextCycle >= settings.cyclesUntilLongBreak) {
          nextPhase = PomodoroPhase.longBreak;
        } else {
          nextPhase = PomodoroPhase.shortBreak;
        }
        break;
      case PomodoroPhase.shortBreak:
        // 短い休憩から作業フェーズへ
        nextPhase = PomodoroPhase.work;
        newCurrentCycle = currentCycle + 1;
        break;
      case PomodoroPhase.longBreak:
        // 長い休憩から作業フェーズへ
        nextPhase = PomodoroPhase.work;
        newCompletedCycles = completedCycles + 1;
        newCurrentCycle = 0;
        break;
    }

    return _NextPhaseInfo(
      phase: nextPhase,
      currentCycle: newCurrentCycle,
      completedCycles: newCompletedCycles,
    );
  }

  /// フェーズの秒数を取得
  int _getSecondsForPhase(PomodoroPhase phase, TimerSettings settings) {
    switch (phase) {
      case PomodoroPhase.work:
        return settings.workMinutes * 60;
      case PomodoroPhase.shortBreak:
        return settings.shortBreakMinutes * 60;
      case PomodoroPhase.longBreak:
        return settings.longBreakMinutes * 60;
    }
  }

  /// フェーズ終了タイトルを取得
  String _getPhaseEndTitle(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return '作業終了';
      case PomodoroPhase.shortBreak:
        return '短い休憩終了';
      case PomodoroPhase.longBreak:
        return '長い休憩終了';
    }
  }

  /// フェーズ終了メッセージを取得
  String _getPhaseEndBody(
      PomodoroPhase phase, String cycleInfo, TodoModel? todo) {
    String baseMessage;
    switch (phase) {
      case PomodoroPhase.work:
        baseMessage = '作業が終了しました。休憩を取りましょう';
        break;
      case PomodoroPhase.shortBreak:
        baseMessage = '短い休憩が終了しました。作業を再開しましょう';
        break;
      case PomodoroPhase.longBreak:
        baseMessage = '長い休憩が終了しました。作業を再開しましょう';
        break;
    }

    String message =
        todo != null ? '「${todo.title}」: $baseMessage' : baseMessage;
    return '$message\n$cycleInfo';
  }

  /// サイクル情報を取得
  String _getCycleInfo(int currentCycle, int completedCycles) {
    if (completedCycles > 0) {
      return '完了サイクル: $completedCycles, 現在: ${currentCycle + 1}サイクル目';
    } else {
      return '現在: ${currentCycle + 1}サイクル目';
    }
  }

  /// カウントアップモードのバックグラウンド通知をスケジュール
  Future<void> _scheduleCountUpBackgroundNotifications({
    required TimerSession timerSession,
    String? todoTitle,
    AppSettings? settings,
  }) async {
    // 設定から通知間隔を取得
    final notificationIntervalMinutes = settings?.countUpNotificationMinutes ?? 60;

    // 最大5つまで通知をスケジュール
    for (int i = 1; i <= 5; i++) {
      final totalMinutes = (timerSession.elapsedSeconds ~/ 60) +
          (notificationIntervalMinutes * i);
      final notificationTime = DateTime.now().add(
        Duration(minutes: notificationIntervalMinutes * i),
      );

      String body = todoTitle != null
          ? '「$todoTitle」: $totalMinutes分経過しました'
          : '$totalMinutes分経過しました';

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        _generateBackgroundTimerNotificationId(i),
        'カウントアップタイマー',
        body,
        tz.TZDateTime.from(notificationTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'background_timer_channel',
            'バックグラウンドタイマー',
            channelDescription: 'バックグラウンドでのタイマー通知',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'background_timer_countup_$i',
      );
    }
  }

  /// バックグラウンドタイマー通知をキャンセル
  Future<void> cancelBackgroundTimerNotifications() async {
    // 3000-3100の範囲の通知をキャンセル（最大100個の通知に対応）
    for (int i = 0; i <= 100; i++) {
      await _flutterLocalNotificationsPlugin.cancel(
        _generateBackgroundTimerNotificationId(i),
      );
    }
  }
}

/// 次のフェーズ情報を保持するクラス
class _NextPhaseInfo {
  final PomodoroPhase phase;
  final int currentCycle;
  final int completedCycles;

  _NextPhaseInfo({
    required this.phase,
    required this.currentCycle,
    required this.completedCycles,
  });
}
