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
                isRecurring: todo.isRecurring,
                recurringType: todo.recurringType,
                recurringEndDate: todo.recurringEndDate,
                recurringDayOfWeek: todo.recurringDayOfWeek,
                recurringDayOfMonth: todo.recurringDayOfMonth,
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
    // Recurring parameters
    bool? isRecurring,
    String? recurringType,
    DateTime? recurringEndDate,
    int? recurringDayOfWeek,
    int? recurringDayOfMonth,
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
      isRecurring: isRecurring ?? false,
      recurringType: recurringType,
      recurringEndDate: recurringEndDate,
      recurringDayOfWeek: recurringDayOfWeek,
      recurringDayOfMonth: recurringDayOfMonth,
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
    // Recurring parameters
    bool? isRecurring,
    String? recurringType,
    DateTime? recurringEndDate,
    int? recurringDayOfWeek,
    int? recurringDayOfMonth,
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
      isRecurring: isRecurring ?? oldTodo.isRecurring,
      recurringType: recurringType ?? oldTodo.recurringType,
      recurringEndDate: recurringEndDate ?? oldTodo.recurringEndDate,
      recurringDayOfWeek: recurringDayOfWeek ?? oldTodo.recurringDayOfWeek,
      recurringDayOfMonth: recurringDayOfMonth ?? oldTodo.recurringDayOfMonth,
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
      isRecurring: oldTodo.isRecurring,
      recurringType: oldTodo.recurringType,
      recurringEndDate: oldTodo.recurringEndDate,
      recurringDayOfWeek: oldTodo.recurringDayOfWeek,
      recurringDayOfMonth: oldTodo.recurringDayOfMonth,
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

  /// Calculate the next due date for a recurring todo
  DateTime? calculateNextRecurringDate(TodoModel todo) {
    if (todo.isRecurring != true || todo.recurringType == null) {
      return null;
    }

    final currentDate = todo.dueDate;
    final recurringType = todo.recurringType!;

    switch (recurringType) {
      case 'daily':
        return DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day + 1,
          currentDate.hour,
          currentDate.minute,
        );
      
      case 'weekly':
        return DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day + 7,
          currentDate.hour,
          currentDate.minute,
        );
      
      case 'monthly':
        if (todo.recurringDayOfMonth != null) {
          final nextMonth = currentDate.month == 12 
              ? DateTime(currentDate.year + 1, 1, 1)
              : DateTime(currentDate.year, currentDate.month + 1, 1);
          final targetDay = todo.recurringDayOfMonth!;
          final lastDayOfMonth = DateTime(nextMonth.year, nextMonth.month + 1, 0).day;
          final actualDay = targetDay > lastDayOfMonth ? lastDayOfMonth : targetDay;
          
          return DateTime(
            nextMonth.year,
            nextMonth.month,
            actualDay,
            currentDate.hour,
            currentDate.minute,
          );
        }
        break;
      
      case 'monthly_last':
        final nextMonth = currentDate.month == 12 
            ? DateTime(currentDate.year + 1, 1, 1)
            : DateTime(currentDate.year, currentDate.month + 1, 1);
        final lastDayOfNextMonth = DateTime(nextMonth.year, nextMonth.month + 1, 0).day;
        
        return DateTime(
          nextMonth.year,
          nextMonth.month,
          lastDayOfNextMonth,
          currentDate.hour,
          currentDate.minute,
        );
    }

    return null;
  }

  /// Generate the next instance of a recurring todo
  Future<TodoModel?> generateNextRecurringInstance(TodoModel originalTodo) async {
    if (originalTodo.isRecurring != true) return null;

    final nextDate = calculateNextRecurringDate(originalTodo);
    if (nextDate == null) return null;

    // Check if we've passed the end date
    if (originalTodo.recurringEndDate != null && 
        nextDate.isAfter(originalTodo.recurringEndDate!)) {
      return null;
    }

    // Create the next instance
    final nextInstance = TodoModel(
      id: _nextId++,
      title: originalTodo.title,
      description: originalTodo.description,
      dueDate: nextDate,
      isCompleted: false,
      color: originalTodo.color,
      icon: originalTodo.icon,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isRecurring: originalTodo.isRecurring,
      recurringType: originalTodo.recurringType,
      recurringEndDate: originalTodo.recurringEndDate,
      recurringDayOfWeek: originalTodo.recurringDayOfWeek,
      recurringDayOfMonth: originalTodo.recurringDayOfMonth,
    );

    _inMemoryTodos.add(nextInstance);
    return nextInstance;
  }
}
