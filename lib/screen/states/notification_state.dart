import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solo/services/notification_service.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/models/todo_model.dart';

part 'build/notification_state.g.dart';

@riverpod
class NotificationState extends _$NotificationState {
  late final NotificationService _notificationService;

  @override
  bool build() {
    _notificationService = NotificationService();
    return false; // 初期状態: 未初期化
  }

  /// 通知サービスを初期化する
  Future<void> initialize() async {
    await _notificationService.initialize();
    state = true; // 初期化完了
  }

  /// 今日のTodoに対して通知をスケジュールする
  Future<void> scheduleTodayNotifications() async {
    if (!state) {
      await initialize();
    }

    final todoService = TodoService();
    
    try {
      final todayTodos = await todoService.getTodayTodos();
      await _notificationService.scheduleTodayTodoNotifications(todayTodos);
    } catch (e) {
      // エラーハンドリング（ログ出力等）
      if (kDebugMode) {
        print('通知スケジュール中にエラーが発生しました: $e');
      }
    }
  }

  /// 特定のTodoの通知をスケジュールする
  Future<void> scheduleTodoNotification(TodoModel todo) async {
    if (!state) {
      await initialize();
    }
    
    try {
      await _notificationService.scheduleTodoDeadlineNotification(todo);
    } catch (e) {
      if (kDebugMode) {
        print('Todo通知スケジュール中にエラーが発生しました: $e');
      }
    }
  }

  /// 特定のTodoの通知をキャンセルする
  Future<void> cancelTodoNotification(int todoId) async {
    if (!state) {
      return; // 初期化されていない場合はキャンセルする必要なし
    }
    
    try {
      await _notificationService.cancelTodoNotification(todoId);
    } catch (e) {
      if (kDebugMode) {
        print('Todo通知キャンセル中にエラーが発生しました: $e');
      }
    }
  }

  /// すべての通知をキャンセルする
  Future<void> cancelAllNotifications() async {
    if (!state) {
      return; // 初期化されていない場合はキャンセルする必要なし
    }
    
    try {
      await _notificationService.cancelAllNotifications();
    } catch (e) {
      if (kDebugMode) {
        print('すべての通知キャンセル中にエラーが発生しました: $e');
      }
    }
  }

  /// Todoが完了/未完了に変更された時の通知管理
  Future<void> handleTodoCompletionChange(TodoModel todo) async {
    if (todo.isCompleted) {
      // 完了した場合は通知をキャンセル
      await cancelTodoNotification(todo.id);
    } else {
      // 未完了に戻した場合は通知を再スケジュール
      await scheduleTodoNotification(todo);
    }
  }

  /// Todoが作成された時の通知管理
  Future<void> handleTodoCreated(TodoModel todo) async {
    if (!todo.isCompleted) {
      await scheduleTodoNotification(todo);
    }
  }

  /// Todoが更新された時の通知管理
  Future<void> handleTodoUpdated(TodoModel todo) async {
    // 既存の通知をキャンセルして新しい通知をスケジュール
    await cancelTodoNotification(todo.id);
    if (!todo.isCompleted) {
      await scheduleTodoNotification(todo);
    }
  }

  /// Todoが削除された時の通知管理
  Future<void> handleTodoDeleted(int todoId) async {
    await cancelTodoNotification(todoId);
  }
}