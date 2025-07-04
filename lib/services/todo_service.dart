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
