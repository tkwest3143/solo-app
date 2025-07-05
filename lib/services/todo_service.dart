import 'package:solo/models/todo_model.dart';
import 'package:solo/repositories/database.dart';

class TodoService {
  // In-memory storage for prototype - in real app this would be persisted
  static final List<TodoModel> _inMemoryTodos = [];
  static int _nextId = 1;
  Future<List<TodoModel>> getTodo() async {
    final todoTableRepository = TodoTableRepository();
    final todos = await todoTableRepository.findAll();

    if (todos.isNotEmpty) {
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

    // If no todos in database, use in-memory todos with dummy data
    if (_inMemoryTodos.isEmpty) {
      _initializeDummyData();
    }

    return List.from(_inMemoryTodos);
  }

  void _initializeDummyData() {
    final now = DateTime.now();
    _inMemoryTodos.addAll([
      TodoModel(
        id: _nextId++,
        title: 'ミーティング準備',
        description: '資料を用意して会議室を予約する',
        dueDate: DateTime(now.year, now.month, now.day, 10, 0),
        isCompleted: false,
        color: 'blue',
      ),
      TodoModel(
        id: _nextId++,
        title: '買い物',
        description: '食材と日用品を購入',
        dueDate: DateTime(now.year, now.month, now.day + 1, 15, 30),
        isCompleted: false,
        color: 'orange',
      ),
      TodoModel(
        id: _nextId++,
        title: '完了済みタスク',
        description: '既に完了したタスクのサンプル',
        dueDate: DateTime(now.year, now.month, now.day - 1, 9, 0),
        isCompleted: true,
        color: 'green',
      ),
      TodoModel(
        id: _nextId++,
        title: 'プロジェクト計画',
        description: '次四半期の計画を立てる',
        dueDate: DateTime(now.year, now.month, now.day + 2, 14, 0),
        isCompleted: false,
        color: 'blue',
      ),
      TodoModel(
        id: _nextId++,
        title: '健康診断',
        description: '',
        dueDate: DateTime(now.year, now.month, now.day + 3, 11, 30),
        isCompleted: false,
        color: 'green',
      ),
    ]);
  }

  Future<TodoModel> createTodo({
    required String title,
    String? description,
    required DateTime dueDate,
    String? color,
  }) async {
    final newTodo = TodoModel(
      id: _nextId++,
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: false,
      color: color ?? 'blue',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _inMemoryTodos.add(newTodo);
    return newTodo;
  }

  Future<TodoModel?> updateTodo(
    int id, {
    String? title,
    String? description,
    DateTime? dueDate,
    String? color,
    bool? isCompleted,
  }) async {
    final index = _inMemoryTodos.indexWhere((todo) => todo.id == id);
    if (index == -1) return null;

    final oldTodo = _inMemoryTodos[index];
    final updatedTodo = TodoModel(
      id: oldTodo.id,
      title: title ?? oldTodo.title,
      description: description ?? oldTodo.description,
      dueDate: dueDate ?? oldTodo.dueDate,
      isCompleted: isCompleted ?? oldTodo.isCompleted,
      color: color ?? oldTodo.color,
      icon: oldTodo.icon,
      createdAt: oldTodo.createdAt,
      updatedAt: DateTime.now(),
    );

    _inMemoryTodos[index] = updatedTodo;
    return updatedTodo;
  }

  Future<bool> deleteTodo(int id) async {
    final index = _inMemoryTodos.indexWhere((todo) => todo.id == id);
    if (index == -1) return false;

    _inMemoryTodos.removeAt(index);
    return true;
  }

  Future<TodoModel?> toggleTodoComplete(int id) async {
    final index = _inMemoryTodos.indexWhere((todo) => todo.id == id);
    if (index == -1) return null;

    final oldTodo = _inMemoryTodos[index];
    final updatedTodo = TodoModel(
      id: oldTodo.id,
      title: oldTodo.title,
      description: oldTodo.description,
      dueDate: oldTodo.dueDate,
      isCompleted: !oldTodo.isCompleted,
      color: oldTodo.color,
      icon: oldTodo.icon,
      createdAt: oldTodo.createdAt,
      updatedAt: DateTime.now(),
    );

    _inMemoryTodos[index] = updatedTodo;
    return updatedTodo;
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
      return !isToday &&
          todoDate.isAfter(today) &&
          todoDate.isBefore(weekFromNow);
    }).toList();
  }

  Future<List<TodoModel>> getFilteredTodos({
    bool? isCompleted,
    String? category,
  }) async {
    final allTodos = await getTodo();

    return allTodos.where((todo) {
      bool matchesCompletion =
          isCompleted == null || todo.isCompleted == isCompleted;
      bool matchesCategory =
          category == null || category.isEmpty || todo.color == category;
      return matchesCompletion && matchesCategory;
    }).toList();
  }

  Future<List<TodoModel>> getTodosForDate(DateTime date) async {
    // ダミーデータを返す
    return [
      TodoModel(
        id: 1,
        title: 'ダミーTodo 1',
        description: 'ダミー詳細 1',
        dueDate: date,
        isCompleted: false,
        color: 'blue',
      ),
      TodoModel(
        id: 2,
        title: 'ダミーTodo 2',
        description: 'ダミー詳細 2',
        dueDate: date,
        isCompleted: true,
        color: 'orange',
      ),
      TodoModel(
        id: 3,
        title: 'ダミーTodo 3',
        description: 'ダミー詳細 3',
        dueDate: date,
        isCompleted: false,
        color: 'green',
      ),
    ];
  }

  Future<Map<DateTime, List<TodoModel>>> getTodosForMonth(
      DateTime month) async {
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
