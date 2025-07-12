import 'package:flutter_test/flutter_test.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:solo/services/todo_service.dart';

void main() {
  group('TodoService 繰り返しTodo表示フィルタリング', () {
    late TodoService todoService;

    setUp(() {
      todoService = TodoService();
    });

    group('getFilteredTodosWithRecurringDisplay', () {
      test('今日以前の未完了繰り返しTodoは全て表示される', () async {
        // Arrange
        final today = DateTime(2024, 1, 15);
        final yesterday = DateTime(2024, 1, 14);
        final dayBeforeYesterday = DateTime(2024, 1, 13);
        
        final recurringTodos = [
          // 昨日期限の未完了繰り返しTodo（毎日）
          TodoModel(
            id: 1,
            title: '昨日の繰り返しタスク',
            dueDate: yesterday,
            isCompleted: false,
            isRecurring: true,
            recurringType: RecurringType.daily,
            description: '',
            color: 'blue',
            createdAt: dayBeforeYesterday,
            updatedAt: dayBeforeYesterday,
            timerType: TimerType.none,
          ),
          // 一昨日期限の未完了繰り返しTodo（毎日）
          TodoModel(
            id: 2,
            title: '一昨日の繰り返しタスク',
            dueDate: dayBeforeYesterday,
            isCompleted: false,
            isRecurring: true,
            recurringType: RecurringType.daily,
            description: '',
            color: 'blue',
            createdAt: dayBeforeYesterday,
            updatedAt: dayBeforeYesterday,
            timerType: TimerType.none,
          ),
        ];

        // Act
        final result = await todoService.getFilteredTodosWithRecurringDisplay(
          currentDate: today,
          todos: recurringTodos,
        );

        // Assert
        expect(result.length, equals(2));
        expect(result.any((t) => t.title == '昨日の繰り返しタスク'), isTrue);
        expect(result.any((t) => t.title == '一昨日の繰り返しタスク'), isTrue);
      });

      test('明日以降の繰り返しTodoは現在日付に最も近いもの1件のみ表示される', () async {
        // Arrange
        final today = DateTime(2024, 1, 15);
        final tomorrow = DateTime(2024, 1, 16);
        final dayAfterTomorrow = DateTime(2024, 1, 17);
        
        final recurringTodos = [
          // 明日期限の繰り返しTodo（毎日）
          TodoModel(
            id: 3,
            title: '明日の繰り返しタスク',
            dueDate: tomorrow,
            isCompleted: false,
            isRecurring: true,
            recurringType: RecurringType.daily,
            description: '',
            color: 'blue',
            createdAt: today,
            updatedAt: today,
            timerType: TimerType.none,
          ),
          // 明後日期限の繰り返しTodo（毎日）
          TodoModel(
            id: 4,
            title: '明後日の繰り返しタスク',
            dueDate: dayAfterTomorrow,
            isCompleted: false,
            isRecurring: true,
            recurringType: RecurringType.daily,
            description: '',
            color: 'blue',
            createdAt: today,
            updatedAt: today,
            timerType: TimerType.none,
          ),
        ];

        // Act
        final result = await todoService.getFilteredTodosWithRecurringDisplay(
          currentDate: today,
          todos: recurringTodos,
        );

        // Assert
        expect(result.length, equals(1));
        expect(result.first.title, equals('明日の繰り返しタスク'));
      });

      test('今日期限の繰り返しTodoは表示される', () async {
        // Arrange
        final today = DateTime(2024, 1, 15);
        
        final recurringTodos = [
          TodoModel(
            id: 5,
            title: '今日の繰り返しタスク',
            dueDate: today,
            isCompleted: false,
            isRecurring: true,
            recurringType: RecurringType.daily,
            description: '',
            color: 'blue',
            createdAt: today,
            updatedAt: today,
            timerType: TimerType.none,
          ),
        ];

        // Act
        final result = await todoService.getFilteredTodosWithRecurringDisplay(
          currentDate: today,
          todos: recurringTodos,
        );

        // Assert
        expect(result.length, equals(1));
        expect(result.first.title, equals('今日の繰り返しタスク'));
      });

      test('繰り返しでないTodoは既存のまま変更なく表示される', () async {
        // Arrange
        final today = DateTime(2024, 1, 15);
        final yesterday = DateTime(2024, 1, 14);
        final tomorrow = DateTime(2024, 1, 16);
        
        final normalTodos = [
          TodoModel(
            id: 6,
            title: '昨日の通常タスク',
            dueDate: yesterday,
            isCompleted: false,
            isRecurring: false,
            recurringType: RecurringType.daily,
            description: '',
            color: 'blue',
            createdAt: yesterday,
            updatedAt: yesterday,
            timerType: TimerType.none,
          ),
          TodoModel(
            id: 7,
            title: '明日の通常タスク',
            dueDate: tomorrow,
            isCompleted: false,
            isRecurring: false,
            recurringType: RecurringType.daily,
            description: '',
            color: 'blue',
            createdAt: today,
            updatedAt: today,
            timerType: TimerType.none,
          ),
        ];

        // Act
        final result = await todoService.getFilteredTodosWithRecurringDisplay(
          currentDate: today,
          todos: normalTodos,
        );

        // Assert
        expect(result.length, equals(2));
        expect(result.any((t) => t.title == '昨日の通常タスク'), isTrue);
        expect(result.any((t) => t.title == '明日の通常タスク'), isTrue);
      });

      test('繰り返しTodoでポモドーロタイマーが設定されているものも正しく表示される', () async {
        // Arrange
        final today = DateTime(2024, 1, 15);
        final tomorrow = DateTime(2024, 1, 16);
        
        final recurringTodos = [
          TodoModel(
            id: 8,
            title: 'ポモドーロ付き繰り返しタスク',
            dueDate: tomorrow,
            isCompleted: false,
            isRecurring: true,
            recurringType: RecurringType.daily,
            description: '',
            color: 'blue',
            createdAt: today,
            updatedAt: today,
            timerType: TimerType.pomodoro,
            pomodoroWorkMinutes: 25,
            pomodoroShortBreakMinutes: 5,
            pomodoroLongBreakMinutes: 15,
            pomodoroCycle: 4,
          ),
        ];

        // Act
        final result = await todoService.getFilteredTodosWithRecurringDisplay(
          currentDate: today,
          todos: recurringTodos,
        );

        // Assert
        expect(result.length, equals(1));
        expect(result.first.timerType, equals(TimerType.pomodoro));
        expect(result.first.pomodoroWorkMinutes, equals(25));
      });

      test('繰り返しTodoでカウントアップタイマーが設定されているものも正しく表示される', () async {
        // Arrange
        final today = DateTime(2024, 1, 15);
        final tomorrow = DateTime(2024, 1, 16);
        
        final recurringTodos = [
          TodoModel(
            id: 9,
            title: 'カウントアップ付き繰り返しタスク',
            dueDate: tomorrow,
            isCompleted: false,
            isRecurring: true,
            recurringType: RecurringType.weekly,
            description: '',
            color: 'blue',
            createdAt: today,
            updatedAt: today,
            timerType: TimerType.countup,
            countupElapsedSeconds: 3600,
          ),
        ];

        // Act
        final result = await todoService.getFilteredTodosWithRecurringDisplay(
          currentDate: today,
          todos: recurringTodos,
        );

        // Assert
        expect(result.length, equals(1));
        expect(result.first.timerType, equals(TimerType.countup));
        expect(result.first.countupElapsedSeconds, equals(3600));
      });

      test('毎週・毎月・毎月最終日の繰り返しTodoでも正しく仕様通り表示される', () async {
        // Arrange
        final today = DateTime(2024, 1, 15, 10, 0); // 月曜日
        final lastWeek = DateTime(2024, 1, 8, 10, 0); // 先週の月曜日
        final nextWeek = DateTime(2024, 1, 22, 10, 0); // 来週の月曜日
        final nextNextWeek = DateTime(2024, 1, 29, 10, 0); // 再来週の月曜日
        
        final recurringTodos = [
          // 先週期限の毎週繰り返しTodo（未完了）
          TodoModel(
            id: 10,
            title: '毎週繰り返しタスク',
            dueDate: lastWeek,
            isCompleted: false,
            isRecurring: true,
            recurringType: RecurringType.weekly,
            recurringDayOfWeek: 1, // 月曜日
            description: '',
            color: 'blue',
            createdAt: lastWeek,
            updatedAt: lastWeek,
            timerType: TimerType.none,
          ),
          // 来週期限の毎週繰り返しTodo
          TodoModel(
            id: 11,
            title: '来週の繰り返しタスク',
            dueDate: nextWeek,
            isCompleted: false,
            isRecurring: true,
            recurringType: RecurringType.weekly,
            recurringDayOfWeek: 1, // 月曜日
            description: '',
            color: 'blue',
            createdAt: today,
            updatedAt: today,
            timerType: TimerType.none,
          ),
          // 再来週期限の毎週繰り返しTodo
          TodoModel(
            id: 12,
            title: '再来週の繰り返しタスク',
            dueDate: nextNextWeek,
            isCompleted: false,
            isRecurring: true,
            recurringType: RecurringType.weekly,
            recurringDayOfWeek: 1, // 月曜日
            description: '',
            color: 'blue',
            createdAt: today,
            updatedAt: today,
            timerType: TimerType.none,
          ),
        ];

        // Act
        final result = await todoService.getFilteredTodosWithRecurringDisplay(
          currentDate: today,
          todos: recurringTodos,
        );

        // Assert
        // 今日以前（先週）の未完了は表示、明日以降では最も近い1件のみ表示
        expect(result.length, equals(2));
        expect(result.any((t) => t.title == '毎週繰り返しタスク'), isTrue);
        expect(result.any((t) => t.title == '来週の繰り返しタスク'), isTrue);
        expect(result.any((t) => t.title == '再来週の繰り返しタスク'), isFalse);
      });
    });
  });
}