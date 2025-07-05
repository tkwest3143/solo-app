import 'package:drift/drift.dart';
import 'package:solo/repositories/database/drift.dart';

class TodoTableRepository {
  Future<List<Todo>> findAll() async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await database.todos.select().get();
    return data
        .map((e) => Todo(
              id: e.id,
              dueDate: e.dueDate,
              title: e.title,
              isCompleted: e.isCompleted,
              description: e.description,
              color: e.color,
              categoryId: e.categoryId,
              icon: e.icon,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              isRecurring: e.isRecurring,
              recurringType: e.recurringType,
              recurringEndDate: e.recurringEndDate,
              recurringDayOfWeek: e.recurringDayOfWeek,
              recurringDayOfMonth: e.recurringDayOfMonth,
            ))
        .toList();
  }
}

class CategoryTableRepository {
  Future<List<Category>> findAll() async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await database.categories.select().get();
    return data
        .map((e) => Category(
              id: e.id,
              title: e.title,
              description: e.description,
              color: e.color,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
            ))
        .toList();
  }

  Future<int> insert(CategoriesCompanion category) async {
    final database = await AppDatabase.getSingletonInstance();
    return await database.into(database.categories).insert(category);
  }

  Future<bool> update(int id, CategoriesCompanion category) async {
    final database = await AppDatabase.getSingletonInstance();
    final result = await (database.update(database.categories)
          ..where((tbl) => tbl.id.equals(id)))
        .write(category);
    return result > 0;
  }

  Future<bool> delete(int id) async {
    final database = await AppDatabase.getSingletonInstance();
    final result = await (database.delete(database.categories)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
    return result > 0;
  }
}

class TodoCheckListItemTableRepository {
  Future<List<TodoCheckListItem>> findByTodoId(int todoId) async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await (database.todoCheckListItems.select()
          ..where((tbl) => tbl.todoId.equals(todoId))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.order)]))
        .get();
    return data
        .map((e) => TodoCheckListItem(
              id: e.id,
              todoId: e.todoId,
              title: e.title,
              isCompleted: e.isCompleted,
              order: e.order,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
            ))
        .toList();
  }

  Future<int> insert(TodoCheckListItemsCompanion item) async {
    final database = await AppDatabase.getSingletonInstance();
    return await database.into(database.todoCheckListItems).insert(item);
  }

  Future<bool> update(int id, TodoCheckListItemsCompanion item) async {
    final database = await AppDatabase.getSingletonInstance();
    final result = await (database.update(database.todoCheckListItems)
          ..where((tbl) => tbl.id.equals(id)))
        .write(item);
    return result > 0;
  }

  Future<bool> delete(int id) async {
    final database = await AppDatabase.getSingletonInstance();
    final result = await (database.delete(database.todoCheckListItems)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
    return result > 0;
  }

  Future<bool> deleteByTodoId(int todoId) async {
    final database = await AppDatabase.getSingletonInstance();
    final result = await (database.delete(database.todoCheckListItems)
          ..where((tbl) => tbl.todoId.equals(todoId)))
        .go();
    return result > 0;
  }

  Future<TodoCheckListItem?> findById(int id) async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await (database.todoCheckListItems.select()
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    
    if (data != null) {
      return TodoCheckListItem(
        id: data.id,
        todoId: data.todoId,
        title: data.title,
        isCompleted: data.isCompleted,
        order: data.order,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );
    }
    return null;
  }
}
