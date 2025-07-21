import 'package:flutter_test/flutter_test.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/enums/timer_type.dart';

void main() {
  group('タイマー完了時のTodo完了機能テスト', () {
    group('TodoModel タイマー関連機能テスト', () {
      test('ポモドーロタイマー設定のTodoを作成できる', () {
        // Arrange & Act
        final pomodoroTodo = TodoModel(
          id: 1,
          title: 'ポモドーロTodo',
          dueDate: DateTime.now(),
          isCompleted: false,
          timerType: TimerType.pomodoro,
          pomodoroWorkMinutes: 25,
          pomodoroShortBreakMinutes: 5,
          pomodoroLongBreakMinutes: 15,
          pomodoroCycle: 4,
          description: '',
          color: 'blue',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Assert
        expect(pomodoroTodo.timerType, TimerType.pomodoro);
        expect(pomodoroTodo.pomodoroWorkMinutes, 25);
        expect(pomodoroTodo.pomodoroShortBreakMinutes, 5);
        expect(pomodoroTodo.pomodoroLongBreakMinutes, 15);
        expect(pomodoroTodo.pomodoroCycle, 4);
        expect(pomodoroTodo.isCompleted, isFalse);
      });

      test('カウントアップタイマー設定のTodoを作成できる', () {
        // Arrange & Act
        final countupTodo = TodoModel(
          id: 2,
          title: 'カウントアップTodo',
          dueDate: DateTime.now(),
          isCompleted: false,
          timerType: TimerType.countup,
          countupElapsedSeconds: 0,
          description: '',
          color: 'blue',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Assert
        expect(countupTodo.timerType, TimerType.countup);
        expect(countupTodo.countupElapsedSeconds, 0);
        expect(countupTodo.isCompleted, isFalse);
      });

      test('Todoを完了状態に変更できる', () {
        // Arrange
        final todo = TodoModel(
          id: 3,
          title: 'テスト用Todo',
          dueDate: DateTime.now(),
          isCompleted: false,
          timerType: TimerType.pomodoro,
          description: '',
          color: 'blue',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act
        final completedTodo = todo.copyWith(isCompleted: true);

        // Assert
        expect(todo.isCompleted, isFalse);
        expect(completedTodo.isCompleted, isTrue);
        expect(completedTodo.id, todo.id);
        expect(completedTodo.title, todo.title);
      });

      test('タイマー設定有無の判定ができる', () {
        // Arrange
        final pomodoroTodo = TodoModel(
          id: 4,
          title: 'ポモドーロTodo',
          dueDate: DateTime.now(),
          isCompleted: false,
          timerType: TimerType.pomodoro,
          description: '',
          color: 'blue',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final countupTodo = TodoModel(
          id: 5,
          title: 'カウントアップTodo',
          dueDate: DateTime.now(),
          isCompleted: false,
          timerType: TimerType.countup,
          description: '',
          color: 'blue',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final normalTodo = TodoModel(
          id: 6,
          title: '通常Todo',
          dueDate: DateTime.now(),
          isCompleted: false,
          timerType: TimerType.none,
          description: '',
          color: 'blue',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Assert
        expect(pomodoroTodo.timerType, TimerType.pomodoro);
        expect(countupTodo.timerType, TimerType.countup);
        expect(normalTodo.timerType, TimerType.none);
      });
    });
  });
}
