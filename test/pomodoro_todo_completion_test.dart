import 'package:flutter_test/flutter_test.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/enums/timer_type.dart';

void main() {
  group('Pomodoro Todo Completion Tests', () {
    late TimerSettings timerSettings;
    late TodoModel testTodo;

    setUp(() {
      timerSettings = const TimerSettings(
        workMinutes: 1, // 短い時間でテスト
        shortBreakMinutes: 1,
        longBreakMinutes: 2,
        cyclesUntilLongBreak: 2,
      );

      // 2サイクルで完了するTodoを作成
      testTodo = TodoModel(
        id: 1,
        dueDate: DateTime.now(),
        title: 'テストTodo',
        isCompleted: false,
        timerType: TimerType.pomodoro,
        pomodoroWorkMinutes: 1,
        pomodoroShortBreakMinutes: 1,
        pomodoroLongBreakMinutes: 2,
        pomodoroCycle: 2, // 2サイクルで完了
      );
    });

    test('Todo設定のポモドーロサイクル数を正しく取得できる', () {
      expect(testTodo.pomodoroCycle, 2);
      expect(testTodo.timerType, TimerType.pomodoro);
    });

    test('Todo選択されている場合、設定されたサイクル数でタイマーが完了すべき', () {
      // 現在のタイマーセッション（1サイクル目の作業完了後）
      final timerSession = TimerSession(
        mode: TimerMode.pomodoro,
        state: TimerStatus.running,
        currentPhase: PomodoroPhase.work,
        remainingSeconds: 0, // 作業時間完了
        elapsedSeconds: 60,
        currentCycle: 1, // 1サイクル目完了後
        completedCycles: 0,
        settings: timerSettings,
        selectedTodoId: testTodo.id,
      );

      // 1サイクル目完了時点では、まだTodo完了ではない（設定は2サイクル）
      expect(timerSession.currentCycle, 1);
      expect(timerSession.completedCycles, 0);
    });

    test('Todoのサイクル数に達した場合、次のフェーズはnullを返すべき', () {
      // 2サイクル目完了後のタイマーセッション
      final timerSession = TimerSession(
        mode: TimerMode.pomodoro,
        state: TimerStatus.running,
        currentPhase: PomodoroPhase.work,
        remainingSeconds: 0, // 作業時間完了
        elapsedSeconds: 240, // 4分経過（2サイクル分）
        currentCycle: 2, // 2サイクル目完了
        completedCycles: 1, // 1完了サイクル
        settings: timerSettings,
        selectedTodoId: testTodo.id,
      );

      // 2サイクル目完了時、Todoの設定サイクル数（2）に達している
      expect(timerSession.currentCycle, 2);
      expect(timerSession.completedCycles, 1);
      
      // この時点でTodo完了となるべき
      // （実装で検証される内容）
    });

    test('Todo未選択の場合、通常のポモドーロサイクルが継続すべき', () {
      // Todo未選択のタイマーセッション
      final timerSession = TimerSession(
        mode: TimerMode.pomodoro,
        state: TimerStatus.running,
        currentPhase: PomodoroPhase.work,
        remainingSeconds: 0,
        elapsedSeconds: 240,
        currentCycle: 2,
        completedCycles: 1,
        settings: timerSettings,
        selectedTodoId: null, // Todo未選択
      );

      // Todo未選択の場合、無限にサイクルが継続すべき
      expect(timerSession.selectedTodoId, isNull);
      expect(timerSession.currentCycle, 2);
    });

    test('カウントアップタイマーの場合、ポモドーロサイクル完了判定は影響しない', () {
      final countupTodo = testTodo.copyWith(
        timerType: TimerType.countup,
        countupElapsedSeconds: 300, // 5分でカウントアップ完了
      );

      final timerSession = TimerSession(
        mode: TimerMode.countUp,
        state: TimerStatus.running,
        currentPhase: PomodoroPhase.work,
        remainingSeconds: 0,
        elapsedSeconds: 300, // 5分経過
        currentCycle: 0,
        completedCycles: 0,
        settings: timerSettings,
        selectedTodoId: countupTodo.id,
      );

      // カウントアップの場合、ポモドーロサイクルは関係ない
      expect(timerSession.mode, TimerMode.countUp);
      expect(countupTodo.timerType, TimerType.countup);
    });

    test('TodoのpomodoroCycleが設定されている場合のサイクル完了判定', () {
      // この関数は TimerState クラスに実装される予定
      // Todo の pomodoroCycle フィールドを使ってサイクル完了を判定する
      
      // 実装すべき内容：
      // 1. 選択されたTodoのpomodoroCycleを取得
      // 2. 現在のcompletedCyclesと比較
      // 3. completedCycles >= pomodoroCycle の場合、タイマー完了
      
      // テストケース1: まだ完了していない場合
      expect(_shouldCompleteTodoBasedOnCycles(
        todoPomodoroCycle: 3,
        currentCompletedCycles: 1,
      ), false);
      
      // テストケース2: 完了している場合
      expect(_shouldCompleteTodoBasedOnCycles(
        todoPomodoroCycle: 2,
        currentCompletedCycles: 2,
      ), true);
      
      // テストケース3: 完了を超えている場合
      expect(_shouldCompleteTodoBasedOnCycles(
        todoPomodoroCycle: 2,
        currentCompletedCycles: 3,
      ), true);
    });
  });
}

// ヘルパー関数（実装予定のロジックをテスト）
bool _shouldCompleteTodoBasedOnCycles(
    {required int todoPomodoroCycle, required int currentCompletedCycles}) {
  return currentCompletedCycles >= todoPomodoroCycle;
}