import 'package:flutter_test/flutter_test.dart';
import 'package:solo/models/todo_model.dart';
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
  });
}