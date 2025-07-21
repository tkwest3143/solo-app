import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:solo/services/todo_service.dart';

void main() {
  group('Recurring Todo Edit Bug Tests', () {
    late TodoService todoService;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      // Setup for database initialization
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (MethodCall methodCall) async {
          return '/tmp';
        }
      );
    });

    setUp(() {
      todoService = TodoService();
    });

    test('編集時に親Todoの情報が子Todoに伝播される', () async {
      // 1. Create a recurring parent Todo with initial category
      final parentTodo = await todoService.createTodo(
        title: '勉強',
        description: '毎週の勉強',
        dueDate: DateTime(2024, 7, 21, 9, 0), // 7/21 start date
        categoryId: 1, // 勉強カテゴリ
        isRecurring: true,
        recurringType: RecurringType.weekly,
      );

      // Get the created child Todo for 7/21
      final todos = await todoService.getTodoIncludingParents();
      final childTodo = todos.firstWhere(
        (t) => t.parentTodoId == parentTodo.id && t.id != parentTodo.id,
      );

      expect(childTodo.categoryId, equals(1));
      expect(childTodo.title, equals('勉強'));

      // 2. Update the child Todo with a new category (simulating edit on 7/28)
      final updatedChildTodo = await todoService.updateTodo(
        childTodo.id,
        categoryId: 2, // 新しいカテゴリ
      );

      expect(updatedChildTodo?.categoryId, equals(2));

      // 3. Verify that the parent Todo was also updated
      final allTodos = await todoService.getTodoIncludingParents();
      final updatedParentTodo = allTodos.firstWhere((t) => t.id == parentTodo.id);
      
      // This should pass after fix: parent Todo should also have the new category
      expect(updatedParentTodo.categoryId, equals(2));

      // 4. Verify that any other existing child Todos also get updated
      final allChildTodos = allTodos.where(
        (t) => t.parentTodoId == parentTodo.id && t.id != parentTodo.id,
      ).toList();

      for (final child in allChildTodos) {
        expect(child.categoryId, equals(2), 
               reason: 'All child Todos should have the updated category');
      }
    });

    test('子Todoの編集時に新しい親Todoが作成されない', () async {
      // 1. Create a recurring parent Todo
      final parentTodo = await todoService.createTodo(
        title: '勉強',
        description: '毎週の勉強',
        dueDate: DateTime(2024, 7, 21, 9, 0),
        categoryId: 1,
        isRecurring: true,
        recurringType: RecurringType.weekly,
      );

      final initialTodos = await todoService.getTodoIncludingParents();
      final initialParentCount = initialTodos.where(
        (t) => t.isRecurring == true && t.parentTodoId == null,
      ).length;

      // Get the child Todo
      final childTodo = initialTodos.firstWhere(
        (t) => t.parentTodoId == parentTodo.id && t.id != parentTodo.id,
      );

      // 2. Update the child Todo
      await todoService.updateTodo(
        childTodo.id,
        categoryId: 2,
        title: '新しいタイトル',
      );

      // 3. Verify that no new parent Todo was created
      final updatedTodos = await todoService.getTodoIncludingParents();
      final finalParentCount = updatedTodos.where(
        (t) => t.isRecurring == true && t.parentTodoId == null,
      ).length;

      expect(finalParentCount, equals(initialParentCount),
             reason: 'Editing a child Todo should not create a new parent Todo');

      // 4. Verify that the original parent still exists
      final originalParent = updatedTodos.firstWhere((t) => t.id == parentTodo.id);
      expect(originalParent.isRecurring, isTrue);
    });

    test('複数の子Todoが存在する場合の一括更新', () async {
      // 1. Create a recurring parent Todo
      final parentTodo = await todoService.createTodo(
        title: '運動',
        description: '毎日の運動',
        dueDate: DateTime(2024, 7, 21, 18, 0),
        categoryId: 3,
        isRecurring: true,
        recurringType: RecurringType.daily,
      );

      // 2. Manually create additional child Todos for different dates
      await todoService.createTodo(
        title: '運動',
        description: '毎日の運動',
        dueDate: DateTime(2024, 7, 22, 18, 0),
        categoryId: 3,
        isRecurring: false,
        parentTodoId: parentTodo.id,
      );

      await todoService.createTodo(
        title: '運動',
        description: '毎日の運動',
        dueDate: DateTime(2024, 7, 23, 18, 0),
        categoryId: 3,
        isRecurring: false,
        parentTodoId: parentTodo.id,
      );

      // 3. Get all child Todos
      final allTodos = await todoService.getTodoIncludingParents();
      final childTodos = allTodos.where(
        (t) => t.parentTodoId == parentTodo.id && t.id != parentTodo.id,
      ).toList();

      expect(childTodos.length, greaterThanOrEqualTo(3));

      // 4. Update one child Todo
      final firstChild = childTodos.first;
      await todoService.updateTodo(
        firstChild.id,
        categoryId: 4,
        title: '新しい運動',
      );

      // 5. Verify all child Todos and parent are updated
      final updatedTodos = await todoService.getTodoIncludingParents();
      final updatedParent = updatedTodos.firstWhere((t) => t.id == parentTodo.id);
      final updatedChildren = updatedTodos.where(
        (t) => t.parentTodoId == parentTodo.id && t.id != parentTodo.id,
      ).toList();

      expect(updatedParent.categoryId, equals(4));
      expect(updatedParent.title, equals('新しい運動'));

      for (final child in updatedChildren) {
        expect(child.categoryId, equals(4));
        expect(child.title, equals('新しい運動'));
      }
    });

    test('親Todoを直接編集した場合の子Todo更新', () async {
      // 1. Create a recurring parent Todo
      final parentTodo = await todoService.createTodo(
        title: '読書',
        description: '毎日の読書',
        dueDate: DateTime(2024, 7, 21, 20, 0),
        categoryId: 5,
        isRecurring: true,
        recurringType: RecurringType.daily,
      );

      // Create additional child Todo
      await todoService.createTodo(
        title: '読書',
        description: '毎日の読書',
        dueDate: DateTime(2024, 7, 22, 20, 0),
        categoryId: 5,
        isRecurring: false,
        parentTodoId: parentTodo.id,
      );

      // 2. Update the parent Todo directly (allowed fields only)
      final updatedParent = await todoService.updateTodo(
        parentTodo.id,
        title: '読書タイム',
        description: '集中読書時間',
        categoryId: 6,
      );

      expect(updatedParent, isNotNull);

      // 3. Verify that child Todos are also updated
      final allTodos = await todoService.getTodoIncludingParents();
      final childTodos = allTodos.where(
        (t) => t.parentTodoId == parentTodo.id && t.id != parentTodo.id,
      ).toList();

      for (final child in childTodos) {
        expect(child.title, equals('読書タイム'));
        expect(child.description, equals('集中読書時間'));
        expect(child.categoryId, equals(6));
      }
    });
  });
}