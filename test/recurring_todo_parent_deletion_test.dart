import 'package:flutter_test/flutter_test.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/models/todo_model.dart';

void main() {
  group('繰り返しTodo親削除バグテスト', () {
    late TodoService todoService;

    setUp(() {
      todoService = TodoService();
    });

    test('繰り返しTodo作成時の構造テスト', () {
      // このテストでは基本的なEnum値の検証を行う
      expect(RecurringType.daily.value, 'daily');
      expect(RecurringType.weekly.value, 'weekly');
      expect(RecurringType.monthly.value, 'monthly');
      expect(RecurringType.monthlyLast.value, 'monthlyLast');
    });

    test('繰り返しTodo作成時に親Todo+子Todoが作成されることを検証', () async {
      // 開始日を設定
      final startDate = DateTime(2024, 1, 15, 10, 0);
      
      // 繰り返しTodoを作成
      final parentTodo = await todoService.createTodo(
        title: 'テスト繰り返しTodo',
        description: 'バグ修正テスト用',
        dueDate: startDate,
        color: 'blue',
        isRecurring: true,
        recurringType: RecurringType.daily,
        timerType: TimerType.none,
      );

      // 親Todoが作成されていることを確認
      expect(parentTodo.id, greaterThan(0));
      expect(parentTodo.isRecurring, isTrue);
      expect(parentTodo.title, 'テスト繰り返しTodo');

      // 開始日のTodoを取得して子Todoが存在することを確認
      final todosOnStartDate = await todoService.getTodosForDate(startDate);
      
      // 開始日に表示されるTodoの中に子Todoがあることを確認
      final childTodos = todosOnStartDate.where((todo) => 
        todo.parentTodoId == parentTodo.id && 
        todo.id != parentTodo.id && 
        todo.id > 0 // 正のIDの子Todo
      ).toList();
      
      expect(childTodos.length, 1);
      expect(childTodos.first.title, 'テスト繰り返しTodo');
      expect(childTodos.first.parentTodoId, parentTodo.id);
      expect(childTodos.first.isRecurring, isFalse); // 子Todoは繰り返しではない
    });

    test('開始日の子Todo削除後も他の日の仮想インスタンスが残存することを検証', () async {
      // 開始日を設定
      final startDate = DateTime(2024, 1, 15, 10, 0);
      final nextDay = DateTime(2024, 1, 16, 10, 0);
      final dayAfter = DateTime(2024, 1, 17, 10, 0);

      // 繰り返しTodoを作成
      final parentTodo = await todoService.createTodo(
        title: 'デイリー繰り返しTodo',
        description: 'バグ修正テスト用',
        dueDate: startDate,
        color: 'green',
        isRecurring: true,
        recurringType: RecurringType.daily,
        timerType: TimerType.none,
      );

      // 開始日の子Todoを取得
      final todosOnStartDate = await todoService.getTodosForDate(startDate);
      final childTodoOnStartDate = todosOnStartDate.firstWhere((todo) => 
        todo.parentTodoId == parentTodo.id && todo.id > 0
      );

      // 開始日の子Todoを削除
      await todoService.deleteTodo(childTodoOnStartDate.id, date: startDate);

      // 削除後、開始日にTodoが存在しないことを確認
      final todosOnStartDateAfterDeletion = await todoService.getTodosForDate(startDate);
      final remainingTodosOnStartDate = todosOnStartDateAfterDeletion.where((todo) =>
        todo.title == 'デイリー繰り返しTodo'
      ).toList();
      expect(remainingTodosOnStartDate.length, 0);

      // 翌日と翌々日に仮想インスタンスが存在することを確認
      final todosOnNextDay = await todoService.getTodosForDate(nextDay);
      final virtualInstanceNextDay = todosOnNextDay.where((todo) =>
        todo.title == 'デイリー繰り返しTodo' && todo.id < 0 // 負のIDの仮想インスタンス
      ).toList();
      expect(virtualInstanceNextDay.length, 1);

      final todosOnDayAfter = await todoService.getTodosForDate(dayAfter);
      final virtualInstanceDayAfter = todosOnDayAfter.where((todo) =>
        todo.title == 'デイリー繰り返しTodo' && todo.id < 0
      ).toList();
      expect(virtualInstanceDayAfter.length, 1);
    });

    test('親Todoが除外されて表示されないことを検証', () async {
      // 開始日を設定
      final startDate = DateTime(2024, 2, 1, 14, 30);

      // 繰り返しTodoを作成
      final parentTodo = await todoService.createTodo(
        title: 'ウィークリー繰り返しTodo',
        description: 'バグ修正テスト用',
        dueDate: startDate,
        color: 'red',
        isRecurring: true,
        recurringType: RecurringType.weekly,
        timerType: TimerType.none,
      );

      // 開始日のTodo一覧を取得
      final todosOnStartDate = await todoService.getTodosForDate(startDate);
      
      // 親Todo（isRecurring=true かつ parentTodoId=null）が表示されていないことを確認
      final parentTodosInList = todosOnStartDate.where((todo) =>
        todo.id == parentTodo.id && todo.isRecurring == true && todo.parentTodoId == null
      ).toList();
      expect(parentTodosInList.length, 0);

      // 代わりに子Todoが表示されていることを確認
      final childTodosInList = todosOnStartDate.where((todo) =>
        todo.parentTodoId == parentTodo.id && todo.id > 0
      ).toList();
      expect(childTodosInList.length, 1);
      expect(childTodosInList.first.title, 'ウィークリー繰り返しTodo');
    });

    test('月表示でも親Todoが除外されることを検証', () async {
      // 開始日を設定
      final startDate = DateTime(2024, 3, 10, 9, 0);
      final targetMonth = DateTime(2024, 3);

      // 繰り返しTodoを作成
      final parentTodo = await todoService.createTodo(
        title: 'マンスリー繰り返しTodo',
        description: 'バグ修正テスト用',
        dueDate: startDate,
        color: 'purple',
        isRecurring: true,
        recurringType: RecurringType.monthly,
        timerType: TimerType.none,
      );

      // 月のTodo一覧を取得
      final todosByDate = await todoService.getTodosForMonth(targetMonth);
      
      // 全てのTodoを平坦化
      final allTodosInMonth = <TodoModel>[];
      todosByDate.forEach((date, todos) {
        allTodosInMonth.addAll(todos);
      });

      // 親Todoが月表示に含まれていないことを確認
      final parentTodosInMonth = allTodosInMonth.where((todo) =>
        todo.id == parentTodo.id && todo.isRecurring == true && todo.parentTodoId == null
      ).toList();
      expect(parentTodosInMonth.length, 0);

      // 開始日に子Todoが存在することを確認
      final startDateKey = DateTime(startDate.year, startDate.month, startDate.day);
      final todosOnStartDate = todosByDate[startDateKey] ?? [];
      final childTodosOnStartDate = todosOnStartDate.where((todo) =>
        todo.parentTodoId == parentTodo.id && todo.id > 0
      ).toList();
      expect(childTodosOnStartDate.length, 1);
    });

    test('繰り返しTodo削除の仕組み説明', () {
      // このテストでは修正された仕組みを説明する
      
      // 修正前の問題：
      // 1. 繰り返しTodoが親Todoとして作成される（parentTodoId = null）
      // 2. 表示時に仮想インスタンス（負のID）が生成される
      // 3. 開始日では親Todo自体（正のID）が表示される
      // 4. 親Todoを削除すると全ての仮想インスタンスが消える
      
      // 修正後の仕組み：
      // 1. 繰り返しTodo作成時に親Todo + 開始日の子Todoを作成
      // 2. 表示時は親Todoは除外し、子Todoと仮想インスタンスのみ表示
      // 3. 開始日でも子Todoが表示される（削除しても親は残る）
      
      const originalProblem = 'Parent todo deletion removes all virtual instances';
      const fixedSolution = 'Start date child todo prevents parent deletion issue';
      
      expect(originalProblem.isNotEmpty, isTrue);
      expect(fixedSolution.isNotEmpty, isTrue);
    });
  });
}