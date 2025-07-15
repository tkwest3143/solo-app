import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/models/timer_model.dart';
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
  Future<void> scheduleTodoDeadlineNotification(TodoModel todo) async {
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
  Future<void> scheduleAllTodoNotifications(List<TodoModel> todos) async {
    for (final todo in todos) {
      await scheduleTodoDeadlineNotification(todo);
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
      List<TodoModel> todayTodos) async {
    // 今日のTodoのうち、未完了で期限が1時間以上先のものに対して通知をスケジュール
    final notifiableTodos = todayTodos.where((todo) {
      if (todo.isCompleted) return false;

      final notificationTime = todo.dueDate.subtract(const Duration(hours: 1));
      return notificationTime.isAfter(DateTime.now());
    }).toList();

    await scheduleAllTodoNotifications(notifiableTodos);
  }

  /// ポモドーロタイマーの状態変更通知を表示
  Future<void> showTimerPhaseNotification({
    required TimerSession timerSession,
    String? todoTitle,
  }) async {
    // 初期化されていない場合は早期リターン
    if (!_isInitialized) {
      return;
    }

    String title;
    String body;
    
    switch (timerSession.currentPhase) {
      case PomodoroPhase.work:
        title = '作業開始';
        body = todoTitle != null 
            ? '「$todoTitle」の作業を開始しましょう'
            : '作業を開始しましょう';
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
  }) async {
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
    await _flutterLocalNotificationsPlugin.cancel(_generateTimerNotificationId());
  }

  /// バックグラウンドタイマー通知用のIDを生成（3000番台を使用）
  int _generateBackgroundTimerNotificationId(int index) {
    return 3000 + index;
  }

  /// バックグラウンドでタイマー通知をスケジュール
  Future<void> scheduleBackgroundTimerNotifications({
    required TimerSession timerSession,
    String? todoTitle,
  }) async {
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
        todoTitle: todoTitle,
      );
    } else if (timerSession.mode == TimerMode.countUp) {
      // カウントアップモードの場合、定期的な通知をスケジュール
      await _scheduleCountUpBackgroundNotifications(
        timerSession: timerSession,
        todoTitle: todoTitle,
      );
    }
  }

  /// ポモドーロモードのバックグラウンド通知をスケジュール
  Future<void> _schedulePomodoroBackgroundNotification({
    required TimerSession timerSession,
    String? todoTitle,
  }) async {
    if (timerSession.remainingSeconds <= 0) return;

    final notificationTime = DateTime.now().add(
      Duration(seconds: timerSession.remainingSeconds),
    );

    String title = '${timerSession.currentPhaseDisplayName}終了';
    String body = todoTitle != null
        ? '「$todoTitle」の${timerSession.currentPhaseDisplayName}が終了しました'
        : '${timerSession.currentPhaseDisplayName}が終了しました';

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _generateBackgroundTimerNotificationId(0),
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
      payload: 'background_timer_pomodoro',
    );
  }

  /// カウントアップモードのバックグラウンド通知をスケジュール
  Future<void> _scheduleCountUpBackgroundNotifications({
    required TimerSession timerSession,
    String? todoTitle,
  }) async {
    // 設定から通知間隔を取得（将来的に設定可能にする場合）
    const notificationIntervalMinutes = 30; // 30分ごと

    // 最大5つまで通知をスケジュール（2.5時間分）
    for (int i = 1; i <= 5; i++) {
      final totalMinutes = (timerSession.elapsedSeconds ~/ 60) + (notificationIntervalMinutes * i);
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
    // 3000-3005の範囲の通知をキャンセル
    for (int i = 0; i <= 5; i++) {
      await _flutterLocalNotificationsPlugin.cancel(
        _generateBackgroundTimerNotificationId(i),
      );
    }
  }

}
