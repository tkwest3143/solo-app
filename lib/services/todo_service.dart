import 'package:drift/drift.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/repositories/database/drift.dart';
import 'package:solo/repositories/database.dart';
import 'package:solo/services/todo_checklist_item_service.dart';

class TodoService {
  final TodoTableRepository _todoTableRepository = TodoTableRepository();

  Future<List<TodoModel>> getTodo() async {
    final todos = await _todoTableRepository.findAll();
    return todos
        .map((todo) => TodoModel(
              id: todo.id,
              dueDate: todo.dueDate,
              title: todo.title,
              isCompleted: todo.isCompleted,
              description: todo.description,
              color: todo.color,
              categoryId: todo.categoryId,
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

  Future<TodoModel> createTodo({
    required String title,
    String? description,
    required DateTime dueDate,
    String? color,
    int? categoryId,
    bool? isRecurring,
    String? recurringType,
    DateTime? recurringEndDate,
    int? recurringDayOfWeek,
    int? recurringDayOfMonth,
  }) async {
    final now = DateTime.now();
    final companion = TodosCompanion(
      title: Value(title),
      description: Value(description),
      dueDate: Value(dueDate),
      isCompleted: const Value(false),
      color: Value(color ?? 'blue'),
      categoryId: Value(categoryId),
      createdAt: Value(now),
      updatedAt: Value(now),
      isRecurring: Value(isRecurring ?? false),
      recurringType: Value(recurringType),
      recurringEndDate: Value(recurringEndDate),
      recurringDayOfWeek: Value(recurringDayOfWeek),
      recurringDayOfMonth: Value(recurringDayOfMonth),
    );
    final id = await _todoTableRepository.insert(companion);
    return TodoModel(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: false,
      color: color ?? 'blue',
      categoryId: categoryId,
      createdAt: now,
      updatedAt: now,
      isRecurring: isRecurring ?? false,
      recurringType: recurringType,
      recurringEndDate: recurringEndDate,
      recurringDayOfWeek: recurringDayOfWeek,
      recurringDayOfMonth: recurringDayOfMonth,
    );
  }

  Future<TodoModel?> updateTodo(
    int id, {
    String? title,
    String? description,
    DateTime? dueDate,
    String? color,
    int? categoryId,
    bool? isCompleted,
    bool? isRecurring,
    String? recurringType,
    DateTime? recurringEndDate,
    int? recurringDayOfWeek,
    int? recurringDayOfMonth,
  }) async {
    final now = DateTime.now();
    final companion = TodosCompanion(
      title: title != null ? Value(title) : const Value.absent(),
      description:
          description != null ? Value(description) : const Value.absent(),
      dueDate: dueDate != null ? Value(dueDate) : const Value.absent(),
      color: color != null ? Value(color) : const Value.absent(),
      categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
      isCompleted:
          isCompleted != null ? Value(isCompleted) : const Value.absent(),
      updatedAt: Value(now),
      isRecurring:
          isRecurring != null ? Value(isRecurring) : const Value.absent(),
      recurringType:
          recurringType != null ? Value(recurringType) : const Value.absent(),
      recurringEndDate: recurringEndDate != null
          ? Value(recurringEndDate)
          : const Value.absent(),
      recurringDayOfWeek: recurringDayOfWeek != null
          ? Value(recurringDayOfWeek)
          : const Value.absent(),
      recurringDayOfMonth: recurringDayOfMonth != null
          ? Value(recurringDayOfMonth)
          : const Value.absent(),
    );
    final success = await _todoTableRepository.update(id, companion);
    if (!success) return null;
    final todos = await _todoTableRepository.findAll();
    Todo? todo;
    try {
      todo = todos.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
    return TodoModel(
      id: todo.id,
      dueDate: todo.dueDate,
      title: todo.title,
      isCompleted: todo.isCompleted,
      description: todo.description,
      color: todo.color,
      categoryId: todo.categoryId,
      icon: todo.icon,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
      isRecurring: todo.isRecurring,
      recurringType: todo.recurringType,
      recurringEndDate: todo.recurringEndDate,
      recurringDayOfWeek: todo.recurringDayOfWeek,
      recurringDayOfMonth: todo.recurringDayOfMonth,
    );
  }

  Future<bool> deleteTodo(int id) async {
    return await _todoTableRepository.delete(id);
  }

  Future<TodoModel?> toggleTodoComplete(int id) async {
    final todos = await _todoTableRepository.findAll();
    Todo? todo;
    try {
      todo = todos.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
    final companion = TodosCompanion(
      isCompleted: Value(!todo.isCompleted),
      updatedAt: Value(DateTime.now()),
    );
    final success = await _todoTableRepository.update(id, companion);
    if (!success) return null;
    final updatedTodos = await _todoTableRepository.findAll();
    Todo? updatedTodo;
    try {
      updatedTodo = updatedTodos.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
    return TodoModel(
      id: updatedTodo.id,
      dueDate: updatedTodo.dueDate,
      title: updatedTodo.title,
      isCompleted: updatedTodo.isCompleted,
      description: updatedTodo.description,
      color: updatedTodo.color,
      categoryId: updatedTodo.categoryId,
      icon: updatedTodo.icon,
      createdAt: updatedTodo.createdAt,
      updatedAt: updatedTodo.updatedAt,
      isRecurring: updatedTodo.isRecurring,
      recurringType: updatedTodo.recurringType,
      recurringEndDate: updatedTodo.recurringEndDate,
      recurringDayOfWeek: updatedTodo.recurringDayOfWeek,
      recurringDayOfMonth: updatedTodo.recurringDayOfMonth,
    );
  }

  Future<bool> checkAndUpdateTodoCompletionByChecklist(int todoId) async {
    final checklistService = TodoCheckListItemService();
    final allItemsCompleted =
        await checklistService.areAllCheckListItemsCompleted(todoId);
    if (allItemsCompleted) {
      final todos = await _todoTableRepository.findAll();
      Todo? todo;
      try {
        todo = todos.firstWhere((t) => t.id == todoId);
      } catch (e) {
        return false;
      }
      if (!todo.isCompleted) {
        final companion = TodosCompanion(
          isCompleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        );
        final success = await _todoTableRepository.update(todoId, companion);
        return success;
      }
    }
    return false;
  }

  Future<List<TodoModel>> getTodayTodos() async {
    final today = DateTime.now();
    final todos = await _todoTableRepository.findByDate(today);
    return todos
        .map((todo) => TodoModel(
              id: todo.id,
              dueDate: todo.dueDate,
              title: todo.title,
              isCompleted: todo.isCompleted,
              description: todo.description,
              color: todo.color,
              categoryId: todo.categoryId,
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

  Future<List<TodoModel>> getUpcomingTodos() async {
    final today = DateTime.now();
    final weekFromNow = today.add(const Duration(days: 7));
    final todos = await _todoTableRepository.findUpcoming(today, weekFromNow);
    return todos
        .where((todo) {
          final todoDate = todo.dueDate;
          final isToday = todoDate.year == today.year &&
              todoDate.month == today.month &&
              todoDate.day == today.day;
          return !isToday;
        })
        .map((todo) => TodoModel(
              id: todo.id,
              dueDate: todo.dueDate,
              title: todo.title,
              isCompleted: todo.isCompleted,
              description: todo.description,
              color: todo.color,
              categoryId: todo.categoryId,
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

  Future<List<TodoModel>> getFilteredTodos({
    bool? isCompleted,
    int? categoryId,
  }) async {
    final todos = await _todoTableRepository.findFiltered(
      isCompleted: isCompleted,
      categoryId: categoryId,
    );
    return todos
        .map((todo) => TodoModel(
              id: todo.id,
              dueDate: todo.dueDate,
              title: todo.title,
              isCompleted: todo.isCompleted,
              description: todo.description,
              color: todo.color,
              categoryId: todo.categoryId,
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

  Future<List<TodoModel>> getTodosForDate(DateTime date) async {
    final todos = await _todoTableRepository.findByDate(date);
    return todos
        .map((todo) => TodoModel(
              id: todo.id,
              dueDate: todo.dueDate,
              title: todo.title,
              isCompleted: todo.isCompleted,
              description: todo.description,
              color: todo.color,
              categoryId: todo.categoryId,
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

  Future<Map<DateTime, List<TodoModel>>> getTodosForMonth(
      DateTime month) async {
    final todos = await _todoTableRepository.findByMonth(month);
    final Map<DateTime, List<TodoModel>> todosByDate = {};
    for (final todo in todos) {
      final todoDate = todo.dueDate;
      final dateKey = DateTime(todoDate.year, todoDate.month, todoDate.day);
      todosByDate[dateKey] = todosByDate[dateKey] ?? [];
      todosByDate[dateKey]!.add(TodoModel(
        id: todo.id,
        dueDate: todo.dueDate,
        title: todo.title,
        isCompleted: todo.isCompleted,
        description: todo.description,
        color: todo.color,
        categoryId: todo.categoryId,
        icon: todo.icon,
        createdAt: todo.createdAt,
        updatedAt: todo.updatedAt,
        isRecurring: todo.isRecurring,
        recurringType: todo.recurringType,
        recurringEndDate: todo.recurringEndDate,
        recurringDayOfWeek: todo.recurringDayOfWeek,
        recurringDayOfMonth: todo.recurringDayOfMonth,
      ));
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
          final lastDayOfMonth =
              DateTime(nextMonth.year, nextMonth.month + 1, 0).day;
          final actualDay =
              targetDay > lastDayOfMonth ? lastDayOfMonth : targetDay;

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
        final lastDayOfNextMonth =
            DateTime(nextMonth.year, nextMonth.month + 1, 0).day;

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
  Future<TodoModel?> generateNextRecurringInstance(
      TodoModel originalTodo) async {
    if (originalTodo.isRecurring != true) return null;

    final nextDate = calculateNextRecurringDate(originalTodo);
    if (nextDate == null) return null;

    // Check if we've passed the end date
    if (originalTodo.recurringEndDate != null &&
        nextDate.isAfter(originalTodo.recurringEndDate!)) {
      return null;
    }

    final now = DateTime.now();
    final companion = TodosCompanion(
      title: Value(originalTodo.title),
      description: Value(originalTodo.description),
      dueDate: Value(nextDate),
      isCompleted: const Value(false),
      color: Value(originalTodo.color),
      icon: Value(originalTodo.icon),
      categoryId: Value(originalTodo.categoryId),
      createdAt: Value(now),
      updatedAt: Value(now),
      isRecurring: Value(originalTodo.isRecurring ?? false),
      recurringType: Value(originalTodo.recurringType),
      recurringEndDate: Value(originalTodo.recurringEndDate),
      recurringDayOfWeek: Value(originalTodo.recurringDayOfWeek),
      recurringDayOfMonth: Value(originalTodo.recurringDayOfMonth),
    );
    final id = await _todoTableRepository.insert(companion);
    return TodoModel(
      id: id,
      title: originalTodo.title,
      description: originalTodo.description,
      dueDate: nextDate,
      isCompleted: false,
      color: originalTodo.color,
      icon: originalTodo.icon,
      categoryId: originalTodo.categoryId,
      createdAt: now,
      updatedAt: now,
      isRecurring: originalTodo.isRecurring ?? false,
      recurringType: originalTodo.recurringType,
      recurringEndDate: originalTodo.recurringEndDate,
      recurringDayOfWeek: originalTodo.recurringDayOfWeek,
      recurringDayOfMonth: originalTodo.recurringDayOfMonth,
    );
  }

  /// Auto-generate recurring todos when needed
  Future<List<TodoModel>> generateUpcomingRecurringTodos() async {
    final allTodos = await getTodo();
    final now = DateTime.now();
    final oneWeekFromNow = now.add(const Duration(days: 7));
    final generatedTodos = <TodoModel>[];

    for (final todo in allTodos) {
      if (todo.isRecurring == true && !todo.isCompleted) {
        // Check if we need to generate upcoming instances
        var currentTodo = todo;

        // Generate up to 3 future instances within the next week
        for (int i = 0; i < 3; i++) {
          final nextDate = calculateNextRecurringDate(currentTodo);
          if (nextDate == null || nextDate.isAfter(oneWeekFromNow)) break;

          // Check if we've passed the end date
          if (todo.recurringEndDate != null &&
              nextDate.isAfter(todo.recurringEndDate!)) break;

          // Check if this instance already exists
          final exists = allTodos.any((t) =>
              t.title == todo.title &&
              t.dueDate.year == nextDate.year &&
              t.dueDate.month == nextDate.month &&
              t.dueDate.day == nextDate.day &&
              t.dueDate.hour == nextDate.hour &&
              t.dueDate.minute == nextDate.minute);
          if (!exists) {
            final now = DateTime.now();
            final companion = TodosCompanion(
              title: Value(todo.title),
              description: Value(todo.description),
              dueDate: Value(nextDate),
              isCompleted: const Value(false),
              color: Value(todo.color),
              icon: Value(todo.icon),
              categoryId: Value(todo.categoryId),
              createdAt: Value(now),
              updatedAt: Value(now),
              isRecurring: Value(todo.isRecurring ?? false),
              recurringType: Value(todo.recurringType),
              recurringEndDate: Value(todo.recurringEndDate),
              recurringDayOfWeek: Value(todo.recurringDayOfWeek),
              recurringDayOfMonth: Value(todo.recurringDayOfMonth),
            );
            final id = await _todoTableRepository.insert(companion);
            final nextInstance = TodoModel(
              id: id,
              title: todo.title,
              description: todo.description,
              dueDate: nextDate,
              isCompleted: false,
              color: todo.color,
              icon: todo.icon,
              categoryId: todo.categoryId,
              createdAt: now,
              updatedAt: now,
              isRecurring: todo.isRecurring ?? false,
              recurringType: todo.recurringType,
              recurringEndDate: todo.recurringEndDate,
              recurringDayOfWeek: todo.recurringDayOfWeek,
              recurringDayOfMonth: todo.recurringDayOfMonth,
            );
            generatedTodos.add(nextInstance);
            currentTodo = nextInstance;
          } else {
            break;
          }
        }
      }
    }

    return generatedTodos;
  }
}
