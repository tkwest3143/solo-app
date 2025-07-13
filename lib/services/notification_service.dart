import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:solo/models/todo_model.dart';
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
}
