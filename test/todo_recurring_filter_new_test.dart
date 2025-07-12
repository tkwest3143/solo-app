import 'package:flutter_test/flutter_test.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:solo/services/todo_service.dart';

void main() {
  group('TodoService 繰り返し日付算出テスト', () {
    late TodoService todoService;

    setUp(() {
      todoService = TodoService();
    });

    group('getNextRecurringDateFromToday', () {
      test('毎日繰り返しで今日以降の最初の日付を正しく算出', () {
        // Arrange
        final today = DateTime(2024, 1, 15);
        final recurringTodo = TodoModel(
          id: 1,
          title: '毎日のタスク',
          dueDate: DateTime(2024, 1, 10, 9, 0), // 過去の日付
          isCompleted: false,
          isRecurring: true,
          recurringType: RecurringType.daily,
          description: '',
          color: 'blue',
          createdAt: DateTime(2024, 1, 10),
          updatedAt: DateTime(2024, 1, 10),
          timerType: TimerType.none,
        );

        // Act
        final result = todoService.getNextRecurringDateFromToday(recurringTodo, today);

        // Assert
        expect(result, isNotNull);
        expect(result!.year, equals(2024));
        expect(result.month, equals(1));
        expect(result.day, equals(15)); // 今日
        expect(result.hour, equals(9));
        expect(result.minute, equals(0));
      });

      test('毎週繰り返しで次の該当曜日を正しく算出', () {
        // Arrange
        final today = DateTime(2024, 1, 15); // 月曜日
        final recurringTodo = TodoModel(
          id: 2,
          title: '毎週水曜日のタスク',
          dueDate: DateTime(2024, 1, 10, 14, 30), // 過去の水曜日
          isCompleted: false,
          isRecurring: true,
          recurringType: RecurringType.weekly,
          recurringDayOfWeek: 3, // 水曜日
          description: '',
          color: 'blue',
          createdAt: DateTime(2024, 1, 10),
          updatedAt: DateTime(2024, 1, 10),
          timerType: TimerType.none,
        );

        // Act
        final result = todoService.getNextRecurringDateFromToday(recurringTodo, today);

        // Assert
        expect(result, isNotNull);
        expect(result!.year, equals(2024));
        expect(result.month, equals(1));
        expect(result.day, equals(17)); // 次の水曜日
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
      });

      test('毎月繰り返しで次の該当日を正しく算出', () {
        // Arrange
        final today = DateTime(2024, 1, 15);
        final recurringTodo = TodoModel(
          id: 3,
          title: '毎月20日のタスク',
          dueDate: DateTime(2023, 12, 20, 10, 0), // 前月
          isCompleted: false,
          isRecurring: true,
          recurringType: RecurringType.monthly,
          recurringDayOfMonth: 20,
          description: '',
          color: 'blue',
          createdAt: DateTime(2023, 12, 20),
          updatedAt: DateTime(2023, 12, 20),
          timerType: TimerType.none,
        );

        // Act
        final result = todoService.getNextRecurringDateFromToday(recurringTodo, today);

        // Assert
        expect(result, isNotNull);
        expect(result!.year, equals(2024));
        expect(result.month, equals(1));
        expect(result.day, equals(20)); // 今月の20日
        expect(result.hour, equals(10));
        expect(result.minute, equals(0));
      });

      test('毎月最終日の繰り返しで次の月末を正しく算出', () {
        // Arrange
        final today = DateTime(2024, 1, 15);
        final recurringTodo = TodoModel(
          id: 4,
          title: '毎月最終日のタスク',
          dueDate: DateTime(2023, 12, 31, 23, 59), // 前月末
          isCompleted: false,
          isRecurring: true,
          recurringType: RecurringType.monthlyLast,
          description: '',
          color: 'blue',
          createdAt: DateTime(2023, 12, 31),
          updatedAt: DateTime(2023, 12, 31),
          timerType: TimerType.none,
        );

        // Act
        final result = todoService.getNextRecurringDateFromToday(recurringTodo, today);

        // Assert
        expect(result, isNotNull);
        expect(result!.year, equals(2024));
        expect(result.month, equals(1));
        expect(result.day, equals(31)); // 今月末
        expect(result.hour, equals(23));
        expect(result.minute, equals(59));
      });

      test('繰り返し終了日を過ぎた場合はnullを返す', () {
        // Arrange
        final today = DateTime(2024, 1, 15);
        final recurringTodo = TodoModel(
          id: 5,
          title: '期限切れ繰り返しタスク',
          dueDate: DateTime(2024, 1, 1, 9, 0),
          isCompleted: false,
          isRecurring: true,
          recurringType: RecurringType.daily,
          recurringEndDate: DateTime(2024, 1, 10), // 既に過ぎた終了日
          description: '',
          color: 'blue',
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          timerType: TimerType.none,
        );

        // Act
        final result = todoService.getNextRecurringDateFromToday(recurringTodo, today);

        // Assert
        expect(result, isNull);
      });

      test('繰り返しではないTodoの場合はnullを返す', () {
        // Arrange
        final today = DateTime(2024, 1, 15);
        final normalTodo = TodoModel(
          id: 6,
          title: '通常タスク',
          dueDate: DateTime(2024, 1, 10, 9, 0),
          isCompleted: false,
          isRecurring: false,
          recurringType: RecurringType.daily,
          description: '',
          color: 'blue',
          createdAt: DateTime(2024, 1, 10),
          updatedAt: DateTime(2024, 1, 10),
          timerType: TimerType.none,
        );

        // Act
        final result = todoService.getNextRecurringDateFromToday(normalTodo, today);

        // Assert
        expect(result, isNull);
      });

      test('今日が繰り返し日の場合、今日の日付を返す', () {
        // Arrange
        final today = DateTime(2024, 1, 15); // 月曜日
        final recurringTodo = TodoModel(
          id: 7,
          title: '毎日のタスク',
          dueDate: DateTime(2024, 1, 1, 10, 0), // 過去の日付から開始
          isCompleted: false,
          isRecurring: true,
          recurringType: RecurringType.daily,
          description: '',
          color: 'blue',
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          timerType: TimerType.none,
        );

        // Act
        final result = todoService.getNextRecurringDateFromToday(recurringTodo, today);

        // Assert
        expect(result, isNotNull);
        expect(result!.year, equals(2024));
        expect(result.month, equals(1));
        expect(result.day, equals(15)); // 今日の日付
        expect(result.hour, equals(10));
        expect(result.minute, equals(0));
      });

      test('今日が毎週の繰り返し曜日の場合、今日の日付を返す', () {
        // Arrange
        final today = DateTime(2024, 1, 17); // 水曜日
        final recurringTodo = TodoModel(
          id: 8,
          title: '毎週水曜日のタスク',
          dueDate: DateTime(2024, 1, 3, 14, 30), // 過去の水曜日
          isCompleted: false,
          isRecurring: true,
          recurringType: RecurringType.weekly,
          recurringDayOfWeek: 3, // 水曜日
          description: '',
          color: 'blue',
          createdAt: DateTime(2024, 1, 3),
          updatedAt: DateTime(2024, 1, 3),
          timerType: TimerType.none,
        );

        // Act
        final result = todoService.getNextRecurringDateFromToday(recurringTodo, today);

        // Assert
        expect(result, isNotNull);
        expect(result!.year, equals(2024));
        expect(result.month, equals(1));
        expect(result.day, equals(17)); // 今日（水曜日）
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
      });
    });
  });
}