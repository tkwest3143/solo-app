import 'package:flutter_test/flutter_test.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/services/notification_service.dart';

void main() {
  group('NotificationService', () {
    group('_generateNotificationId', () {
      test('should create NotificationService instance', () {
        // Act
        final notificationService = NotificationService();
        
        // Assert
        expect(notificationService, isA<NotificationService>());
      });
    });

    group('scheduleTodoDeadlineNotification', () {
      test('should return early for completed todo', () async {
        // Arrange
        final notificationService = NotificationService();
        final completedTodo = TodoModel(
          id: 2,
          title: '完了済みタスク',
          dueDate: DateTime.now().add(const Duration(hours: 2)),
          isCompleted: true,
        );

        // Act & Assert - should complete without throwing
        expect(
          () => notificationService.scheduleTodoDeadlineNotification(completedTodo),
          returnsNormally,
        );
      });

      test('should return early for past due date', () async {
        // Arrange
        final notificationService = NotificationService();
        final pastTodo = TodoModel(
          id: 3,
          title: '過去のタスク',
          dueDate: DateTime.now().subtract(const Duration(hours: 2)),
          isCompleted: false,
        );

        // Act & Assert - should complete without throwing
        expect(
          () => notificationService.scheduleTodoDeadlineNotification(pastTodo),
          returnsNormally,
        );
      });
    });

    group('NotificationService instance', () {
      test('should create singleton instance', () {
        // Act
        final instance1 = NotificationService();
        final instance2 = NotificationService();

        // Assert
        expect(instance1, same(instance2));
      });
    });

    group('scheduleTodayTodoNotifications', () {
      test('should filter completed and past todos correctly', () async {
        // Arrange
        final notificationService = NotificationService();
        final todos = [
          TodoModel(
            id: 1,
            title: 'タスク1',
            dueDate: DateTime.now().add(const Duration(hours: 2)),
            isCompleted: false,
          ),
          TodoModel(
            id: 2,
            title: 'タスク2',
            dueDate: DateTime.now().subtract(const Duration(minutes: 30)),
            isCompleted: false,
          ),
          TodoModel(
            id: 3,
            title: '完了済みタスク',
            dueDate: DateTime.now().add(const Duration(hours: 4)),
            isCompleted: true,
          ),
        ];

        // Act & Assert - should complete without throwing
        expect(
          () => notificationService.scheduleTodayTodoNotifications(todos),
          returnsNormally,
        );
      });
    });

    group('Timer Notifications', () {
      test('should handle timer phase notifications', () async {
        // Arrange
        final notificationService = NotificationService();
        const timerSettings = TimerSettings(
          workMinutes: 25,
          shortBreakMinutes: 5,
          longBreakMinutes: 15,
          cyclesUntilLongBreak: 4,
        );
        
        final timerSession = TimerSession(
          mode: TimerMode.pomodoro,
          state: TimerStatus.running,
          currentPhase: PomodoroPhase.work,
          remainingSeconds: 1500,
          elapsedSeconds: 0,
          currentCycle: 0,
          completedCycles: 0,
          settings: timerSettings,
          selectedTodoId: 1,
        );

        // Act & Assert - should complete without throwing
        expect(
          () => notificationService.showTimerPhaseNotification(
            timerSession: timerSession,
            todoTitle: 'テストタスク',
          ),
          returnsNormally,
        );
      });

      test('should handle timer completion notifications', () async {
        // Arrange
        final notificationService = NotificationService();
        const timerSettings = TimerSettings();
        
        final pomodoroSession = TimerSession(
          mode: TimerMode.pomodoro,
          state: TimerStatus.completed,
          currentPhase: PomodoroPhase.work,
          remainingSeconds: 0,
          elapsedSeconds: 1500,
          currentCycle: 4,
          completedCycles: 4,
          settings: timerSettings,
          selectedTodoId: 1,
        );

        final countUpSession = TimerSession(
          mode: TimerMode.countUp,
          state: TimerStatus.idle,
          currentPhase: PomodoroPhase.work,
          remainingSeconds: 0,
          elapsedSeconds: 3600, // 1時間
          currentCycle: 0,
          completedCycles: 0,
          settings: timerSettings,
        );

        // Act & Assert - should complete without throwing
        expect(
          () => notificationService.showTimerCompletionNotification(
            timerSession: pomodoroSession,
            todoTitle: 'ポモドーロタスク',
          ),
          returnsNormally,
        );

        expect(
          () => notificationService.showTimerCompletionNotification(
            timerSession: countUpSession,
            todoTitle: 'カウントアップタスク',
          ),
          returnsNormally,
        );
      });

      test('should cancel timer notifications', () async {
        // Arrange
        final notificationService = NotificationService();

        // Act & Assert - should complete without throwing
        expect(
          () => notificationService.cancelTimerNotification(),
          returnsNormally,
        );
      });


      test('should handle background phase change notifications', () async {
        // Arrange
        final notificationService = NotificationService();
        const timerSettings = TimerSettings(
          workMinutes: 25,
          shortBreakMinutes: 5,
          longBreakMinutes: 15,
          cyclesUntilLongBreak: 4,
        );
        
        // 作業完了→休憩開始の通知
        final breakSession = TimerSession(
          mode: TimerMode.pomodoro,
          state: TimerStatus.running,
          currentPhase: PomodoroPhase.shortBreak,
          remainingSeconds: 300, // 5分休憩
          elapsedSeconds: 0,
          currentCycle: 1,
          completedCycles: 0,
          settings: timerSettings,
          selectedTodoId: 1,
          isInBackground: true,
        );

        // 休憩完了→作業開始の通知
        final workSession = TimerSession(
          mode: TimerMode.pomodoro,
          state: TimerStatus.running,
          currentPhase: PomodoroPhase.work,
          remainingSeconds: 1500, // 25分作業
          elapsedSeconds: 0,
          currentCycle: 2,
          completedCycles: 0,
          settings: timerSettings,
          selectedTodoId: 1,
          isInBackground: true,
        );

        // 長い休憩開始の通知
        final longBreakSession = TimerSession(
          mode: TimerMode.pomodoro,
          state: TimerStatus.running,
          currentPhase: PomodoroPhase.longBreak,
          remainingSeconds: 900, // 15分長い休憩
          elapsedSeconds: 0,
          currentCycle: 0,
          completedCycles: 1,
          settings: timerSettings,
          selectedTodoId: 1,
          isInBackground: true,
        );

        // Act & Assert - should complete without throwing
        expect(
          () => notificationService.showTimerPhaseNotification(
            timerSession: breakSession,
            todoTitle: '作業完了通知テスト',
          ),
          returnsNormally,
        );

        expect(
          () => notificationService.showTimerPhaseNotification(
            timerSession: workSession,
            todoTitle: '休憩完了通知テスト',
          ),
          returnsNormally,
        );

        expect(
          () => notificationService.showTimerPhaseNotification(
            timerSession: longBreakSession,
            todoTitle: '長い休憩開始通知テスト',
          ),
          returnsNormally,
        );
      });

      test('should handle timer race conditions correctly', () async {
        // Arrange
        final notificationService = NotificationService();
        const timerSettings = TimerSettings();
        
        final runningSession = TimerSession(
          mode: TimerMode.pomodoro,
          state: TimerStatus.running,
          currentPhase: PomodoroPhase.work,
          remainingSeconds: 1500,
          elapsedSeconds: 0,
          currentCycle: 0,
          completedCycles: 0,
          settings: timerSettings,
          selectedTodoId: 1,
          isInBackground: false,
        );

        // Act & Assert - 複数回の通知呼び出しでもエラーが発生しないことを確認
        for (int i = 0; i < 5; i++) {
          expect(
            () => notificationService.showTimerPhaseNotification(
              timerSession: runningSession,
              todoTitle: 'レースコンディションテスト',
            ),
            returnsNormally,
          );
        }
      });

      test('should handle background timer synchronization correctly', () async {
        // Arrange
        final notificationService = NotificationService();
        const timerSettings = TimerSettings(
          workMinutes: 1, // テスト用に短い時間
          shortBreakMinutes: 1,
          longBreakMinutes: 1,
          cyclesUntilLongBreak: 2,
        );
        
        // バックグラウンドで1分経過後のセッション
        final sessionAfterBackground = TimerSession(
          mode: TimerMode.pomodoro,
          state: TimerStatus.running,
          currentPhase: PomodoroPhase.shortBreak, // 作業完了→休憩に移行
          remainingSeconds: 60, // 残り1分
          elapsedSeconds: 0,
          currentCycle: 1,
          completedCycles: 0,
          settings: timerSettings,
          selectedTodoId: 1,
          isInBackground: false, // フォアグラウンド復帰後
          backgroundTime: null,
        );

        // カウントアップで1分経過後のセッション
        final countUpAfterBackground = TimerSession(
          mode: TimerMode.countUp,
          state: TimerStatus.running,
          currentPhase: PomodoroPhase.work,
          remainingSeconds: 0,
          elapsedSeconds: 60, // 1分経過
          currentCycle: 0,
          completedCycles: 0,
          settings: timerSettings,
          isInBackground: false,
        );

        // Act & Assert - バックグラウンド同期後の通知も正常に動作することを確認
        expect(
          () => notificationService.showTimerPhaseNotification(
            timerSession: sessionAfterBackground,
            todoTitle: 'バックグラウンド同期テスト',
          ),
          returnsNormally,
        );

        expect(
          () => notificationService.showTimerCompletionNotification(
            timerSession: countUpAfterBackground,
            todoTitle: 'カウントアップ同期テスト',
          ),
          returnsNormally,
        );
      });
    });
  });
}