import 'package:solo/models/todo_model.dart';
import 'package:solo/repositories/database.dart';

class TodoService {
  Future<List<TodoModel>> getTodo() async {
    final todoTableRepository = TodoTableRepository();
    final todos = await todoTableRepository.findAll();
    return todos
        .map((todo) => TodoModel(
              id: todo.id,
              dueDate: todo.dueDate,
              title: todo.title,
              isCompleted: todo.isCompleted,
              description: todo.description,
              color: todo.color,
              icon: todo.icon,
              createdAt: todo.createdAt,
              updatedAt: todo.updatedAt,
            ))
        .toList();
  }

  Future<List<TodoModel>> getTodayTodos() async {
    final allTodos = await getTodo();
    final today = DateTime.now();
    
    return allTodos.where((todo) {
      final todoDate = todo.dueDate;
      return todoDate.year == today.year &&
          todoDate.month == today.month &&
          todoDate.day == today.day;
    }).toList();
  }

  Future<List<TodoModel>> getUpcomingTodos() async {
    final allTodos = await getTodo();
    final today = DateTime.now();
    final weekFromNow = today.add(const Duration(days: 7));
    
    return allTodos.where((todo) {
      final todoDate = todo.dueDate;
      final isToday = todoDate.year == today.year &&
          todoDate.month == today.month &&
          todoDate.day == today.day;
      return !isToday && todoDate.isAfter(today) && todoDate.isBefore(weekFromNow);
    }).toList();
  }

  Future<List<TodoModel>> getFilteredTodos({
    bool? isCompleted,
    String? category,
  }) async {
    final allTodos = await getTodo();
    
    return allTodos.where((todo) {
      bool matchesCompletion = isCompleted == null || todo.isCompleted == isCompleted;
      bool matchesCategory = category == null || category.isEmpty || todo.color == category;
      return matchesCompletion && matchesCategory;
    }).toList();
  }

  Future<List<TodoModel>> getTodosForDate(DateTime date) async {
    final allTodos = await getTodo();
    
    // Add dummy data for prototype if no todos exist
    if (allTodos.isEmpty) {
      final now = DateTime.now();
      final dummyTodos = [
        TodoModel(
          id: 1,
          title: 'ミーティング準備',
          description: '資料を用意して会議室を予約する',
          dueDate: DateTime(now.year, now.month, now.day, 10, 0),
          isCompleted: false,
          color: 'blue',
        ),
        TodoModel(
          id: 2,
          title: '買い物',
          description: '食材と日用品を購入',
          dueDate: DateTime(now.year, now.month, now.day + 1, 15, 30),
          isCompleted: false,
          color: 'orange',
        ),
        TodoModel(
          id: 3,
          title: '完了済みタスク',
          description: '既に完了したタスクのサンプル',
          dueDate: DateTime(now.year, now.month, now.day - 1, 9, 0),
          isCompleted: true,
          color: 'green',
        ),
        TodoModel(
          id: 4,
          title: 'プロジェクト計画',
          description: '次四半期の計画を立てる',
          dueDate: DateTime(now.year, now.month, now.day + 2, 14, 0),
          isCompleted: false,
          color: 'blue',
        ),
        TodoModel(
          id: 5,
          title: '健康診断',
          description: '',
          dueDate: DateTime(now.year, now.month, now.day + 3, 11, 30),
          isCompleted: false,
          color: 'green',
        ),
      ];
      
      return dummyTodos.where((todo) {
        final todoDate = todo.dueDate;
        return todoDate.year == date.year &&
            todoDate.month == date.month &&
            todoDate.day == date.day;
      }).toList();
    }
    
    return allTodos.where((todo) {
      final todoDate = todo.dueDate;
      return todoDate.year == date.year &&
          todoDate.month == date.month &&
          todoDate.day == date.day;
    }).toList();
  }

  Future<Map<DateTime, List<TodoModel>>> getTodosForMonth(DateTime month) async {
    final allTodos = await getTodo();
    final Map<DateTime, List<TodoModel>> todosByDate = {};
    
    // Add dummy data for prototype if no todos exist
    if (allTodos.isEmpty) {
      final now = DateTime.now();
      final dummyTodos = [
        TodoModel(
          id: 1,
          title: 'ミーティング準備',
          description: '資料を用意して会議室を予約する',
          dueDate: DateTime(now.year, now.month, now.day, 10, 0),
          isCompleted: false,
          color: 'blue',
        ),
        TodoModel(
          id: 2,
          title: '買い物',
          description: '食材と日用品を購入',
          dueDate: DateTime(now.year, now.month, now.day + 1, 15, 30),
          isCompleted: false,
          color: 'orange',
        ),
        TodoModel(
          id: 3,
          title: '完了済みタスク',
          description: '既に完了したタスクのサンプル',
          dueDate: DateTime(now.year, now.month, now.day - 1, 9, 0),
          isCompleted: true,
          color: 'green',
        ),
        TodoModel(
          id: 4,
          title: 'プロジェクト計画',
          description: '次四半期の計画を立てる',
          dueDate: DateTime(now.year, now.month, now.day + 2, 14, 0),
          isCompleted: false,
          color: 'blue',
        ),
        TodoModel(
          id: 5,
          title: '健康診断',
          description: '',
          dueDate: DateTime(now.year, now.month, now.day + 3, 11, 30),
          isCompleted: false,
          color: 'green',
        ),
      ];
      
      for (final todo in dummyTodos) {
        final todoDate = todo.dueDate;
        if (todoDate.year == month.year && todoDate.month == month.month) {
          final dateKey = DateTime(todoDate.year, todoDate.month, todoDate.day);
          todosByDate[dateKey] = todosByDate[dateKey] ?? [];
          todosByDate[dateKey]!.add(todo);
        }
      }
      
      return todosByDate;
    }
    
    for (final todo in allTodos) {
      final todoDate = todo.dueDate;
      if (todoDate.year == month.year && todoDate.month == month.month) {
        final dateKey = DateTime(todoDate.year, todoDate.month, todoDate.day);
        todosByDate[dateKey] = todosByDate[dateKey] ?? [];
        todosByDate[dateKey]!.add(todo);
      }
    }
    
    return todosByDate;
  }
}
