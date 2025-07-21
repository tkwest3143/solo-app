import 'package:drift/drift.dart';
import 'package:solo/repositories/database/drift.dart';

class TodoTableRepository {
  Future<Todo?> findById(int id) async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await (database.todos.select()
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (data != null) {
      return Todo(
        id: data.id,
        dueDate: data.dueDate,
        title: data.title,
        isCompleted: data.isCompleted,
        description: data.description,
        color: data.color,
        categoryId: data.categoryId,
        parentTodoId: data.parentTodoId,
        icon: data.icon,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
        isRecurring: data.isRecurring,
        recurringType: data.recurringType,
        recurringEndDate: data.recurringEndDate,
        timerType: data.timerType,
        countupElapsedSeconds: data.countupElapsedSeconds,
        pomodoroWorkMinutes: data.pomodoroWorkMinutes,
        pomodoroShortBreakMinutes: data.pomodoroShortBreakMinutes,
        pomodoroLongBreakMinutes: data.pomodoroLongBreakMinutes,
        pomodoroCycle: data.pomodoroCycle,
        pomodoroCompletedCycle: data.pomodoroCompletedCycle,
        isDeleted: data.isDeleted,
      );
    }
    return null;
  }

  Future<List<Todo>> findAll() async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await (database.todos.select()
          ..where((tbl) => 
              tbl.isDeleted.equals(false) &
              // 繰り返しの親Todo（isRecurring=true かつ parentTodoId=null）を除外
              (tbl.isRecurring.equals(true) & tbl.parentTodoId.isNull()).not()))
        .get();
    return data
        .map((e) => Todo(
              id: e.id,
              dueDate: e.dueDate,
              title: e.title,
              isCompleted: e.isCompleted,
              description: e.description,
              color: e.color,
              categoryId: e.categoryId,
              parentTodoId: e.parentTodoId,
              icon: e.icon,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              isRecurring: e.isRecurring,
              recurringType: e.recurringType,
              recurringEndDate: e.recurringEndDate,
              timerType: e.timerType,
              countupElapsedSeconds: e.countupElapsedSeconds,
              pomodoroWorkMinutes: e.pomodoroWorkMinutes,
              pomodoroShortBreakMinutes: e.pomodoroShortBreakMinutes,
              pomodoroLongBreakMinutes: e.pomodoroLongBreakMinutes,
              pomodoroCycle: e.pomodoroCycle,
              pomodoroCompletedCycle: e.pomodoroCompletedCycle,
              isDeleted: e.isDeleted,
            ))
        .toList();
  }

  /// テスト用: 繰り返しの親Todoを含むすべてのTodoを取得
  Future<List<Todo>> findAllIncludingParents() async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await (database.todos.select()
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    return data
        .map((e) => Todo(
              id: e.id,
              dueDate: e.dueDate,
              title: e.title,
              isCompleted: e.isCompleted,
              description: e.description,
              color: e.color,
              categoryId: e.categoryId,
              parentTodoId: e.parentTodoId,
              icon: e.icon,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              isRecurring: e.isRecurring,
              recurringType: e.recurringType,
              recurringEndDate: e.recurringEndDate,
              timerType: e.timerType,
              countupElapsedSeconds: e.countupElapsedSeconds,
              pomodoroWorkMinutes: e.pomodoroWorkMinutes,
              pomodoroShortBreakMinutes: e.pomodoroShortBreakMinutes,
              pomodoroLongBreakMinutes: e.pomodoroLongBreakMinutes,
              pomodoroCycle: e.pomodoroCycle,
              pomodoroCompletedCycle: e.pomodoroCompletedCycle,
              isDeleted: e.isDeleted,
            ))
        .toList();
  }

  Future<int> insert(TodosCompanion todo) async {
    final database = await AppDatabase.getSingletonInstance();
    return await database.into(database.todos).insert(todo);
  }

  Future<bool> update(int id, TodosCompanion todo) async {
    final database = await AppDatabase.getSingletonInstance();
    final result = await (database.update(database.todos)
          ..where((tbl) => tbl.id.equals(id)))
        .write(todo);
    return result > 0;
  }

  Future<bool> delete(int id) async {
    final database = await AppDatabase.getSingletonInstance();
    final result = await (database.delete(database.todos)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
    return result > 0;
  }

  /// 論理削除（isDeletedフラグをtrueに設定）
  Future<bool> softDelete(int id) async {
    final database = await AppDatabase.getSingletonInstance();
    final result = await (database.update(database.todos)
          ..where((tbl) => tbl.id.equals(id)))
        .write(TodosCompanion(
      isDeleted: const Value(true),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  /// 物理削除（レコードを完全に削除）
  Future<bool> physicalDelete(int id) async {
    final database = await AppDatabase.getSingletonInstance();
    final result = await (database.delete(database.todos)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
    return result > 0;
  }

  /// parentTodoIdで指定された全ての子Todoを物理削除
  Future<bool> physicalDeleteByParentTodoId(int parentTodoId) async {
    final database = await AppDatabase.getSingletonInstance();
    final result = await (database.delete(database.todos)
          ..where((tbl) => tbl.parentTodoId.equals(parentTodoId)))
        .go();
    return result > 0;
  }

  /// トランザクション内で繰り返しTodoとその子Todoを一括物理削除
  Future<bool> physicalDeleteRecurringTodoWithChildren(int parentTodoId) async {
    final database = await AppDatabase.getSingletonInstance();
    return await database.transaction(() async {
      try {
        // 子Todoを削除
        await (database.delete(database.todos)
              ..where((tbl) => tbl.parentTodoId.equals(parentTodoId)))
            .go();

        // 親Todoを削除
        await (database.delete(database.todos)
              ..where((tbl) => tbl.id.equals(parentTodoId)))
            .go();

        return true;
      } catch (e) {
        // トランザクションが自動的にロールバックされる
        return false;
      }
    });
  }

  /// トランザクション内で複数のTodoを一括更新
  Future<bool> updateMultipleInTransaction(
      List<MapEntry<int, TodosCompanion>> updates) async {
    final database = await AppDatabase.getSingletonInstance();
    return await database.transaction(() async {
      try {
        for (final update in updates) {
          final result = await (database.update(database.todos)
                ..where((tbl) => tbl.id.equals(update.key)))
              .write(update.value);
          if (result == 0) {
            throw Exception('Failed to update Todo with id: ${update.key}');
          }
        }
        return true;
      } catch (e) {
        // トランザクションが自動的にロールバックされる
        return false;
      }
    });
  }

  /// parentTodoIdで指定されたTodoを取得（親Todoも含む）
  Future<List<Todo>> findByParentTodoId(int parentTodoId) async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await (database.todos.select()
          ..where((tbl) =>
              tbl.isDeleted.equals(false) &
              (tbl.id.equals(parentTodoId) |
                  tbl.parentTodoId.equals(parentTodoId))))
        .get();

    return data
        .map((e) => Todo(
              id: e.id,
              dueDate: e.dueDate,
              title: e.title,
              isCompleted: e.isCompleted,
              description: e.description,
              color: e.color,
              categoryId: e.categoryId,
              parentTodoId: e.parentTodoId,
              icon: e.icon,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              isRecurring: e.isRecurring,
              recurringType: e.recurringType,
              recurringEndDate: e.recurringEndDate,
              timerType: e.timerType,
              countupElapsedSeconds: e.countupElapsedSeconds,
              pomodoroWorkMinutes: e.pomodoroWorkMinutes,
              pomodoroShortBreakMinutes: e.pomodoroShortBreakMinutes,
              pomodoroLongBreakMinutes: e.pomodoroLongBreakMinutes,
              pomodoroCycle: e.pomodoroCycle,
              pomodoroCompletedCycle: e.pomodoroCompletedCycle,
              isDeleted: e.isDeleted,
            ))
        .toList();
  }

  /// 指定期間内の削除されたレコードを取得
  Future<List<Todo>> findDeletedTodosForPeriod(
      DateTime start, DateTime end) async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await (database.todos.select()
          ..where((tbl) =>
              tbl.isDeleted.equals(true) &
              tbl.parentTodoId.isNotNull() &
              tbl.dueDate.isBiggerOrEqualValue(start) &
              tbl.dueDate.isSmallerThanValue(end.add(const Duration(days: 1)))))
        .get();

    return data
        .map((e) => Todo(
              id: e.id,
              dueDate: e.dueDate,
              title: e.title,
              isCompleted: e.isCompleted,
              description: e.description,
              color: e.color,
              categoryId: e.categoryId,
              parentTodoId: e.parentTodoId,
              icon: e.icon,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              isRecurring: e.isRecurring,
              recurringType: e.recurringType,
              recurringEndDate: e.recurringEndDate,
              timerType: e.timerType,
              countupElapsedSeconds: e.countupElapsedSeconds,
              pomodoroWorkMinutes: e.pomodoroWorkMinutes,
              pomodoroShortBreakMinutes: e.pomodoroShortBreakMinutes,
              pomodoroLongBreakMinutes: e.pomodoroLongBreakMinutes,
              pomodoroCycle: e.pomodoroCycle,
              pomodoroCompletedCycle: e.pomodoroCompletedCycle,
              isDeleted: e.isDeleted,
            ))
        .toList();
  }

  /// 指定された親TodoIDと日付で削除済みレコードが存在するかチェック
  Future<bool> isDateDeleted(int parentTodoId, DateTime date) async {
    final database = await AppDatabase.getSingletonInstance();
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await (database.todos.select()
          ..where((tbl) =>
              tbl.parentTodoId.equals(parentTodoId) &
              tbl.isDeleted.equals(true) &
              tbl.dueDate.isBiggerOrEqualValue(startOfDay) &
              tbl.dueDate.isSmallerThanValue(endOfDay)))
        .getSingleOrNull();

    return result != null;
  }

  Future<List<Todo>> findByDate(DateTime date) async {
    final database = await AppDatabase.getSingletonInstance();
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final data = await (database.todos.select()
          ..where((tbl) =>
              tbl.dueDate.isBiggerOrEqualValue(start) &
              tbl.dueDate.isSmallerThanValue(end) &
              tbl.isDeleted.equals(false)))
        .get();
    return data
        .map((e) => Todo(
              id: e.id,
              dueDate: e.dueDate,
              title: e.title,
              isCompleted: e.isCompleted,
              description: e.description,
              color: e.color,
              categoryId: e.categoryId,
              parentTodoId: e.parentTodoId,
              icon: e.icon,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              isRecurring: e.isRecurring,
              recurringType: e.recurringType,
              recurringEndDate: e.recurringEndDate,
              timerType: e.timerType,
              countupElapsedSeconds: e.countupElapsedSeconds,
              pomodoroWorkMinutes: e.pomodoroWorkMinutes,
              pomodoroShortBreakMinutes: e.pomodoroShortBreakMinutes,
              pomodoroLongBreakMinutes: e.pomodoroLongBreakMinutes,
              pomodoroCycle: e.pomodoroCycle,
              pomodoroCompletedCycle: e.pomodoroCompletedCycle,
              isDeleted: e.isDeleted,
            ))
        .toList();
  }

  Future<List<Todo>> findUpcoming(DateTime from, DateTime to) async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await (database.todos.select()
          ..where((tbl) =>
              tbl.dueDate.isBiggerThanValue(from) &
              tbl.dueDate.isSmallerThanValue(to) &
              tbl.isDeleted.equals(false)))
        .get();
    return data
        .map((e) => Todo(
              id: e.id,
              dueDate: e.dueDate,
              title: e.title,
              isCompleted: e.isCompleted,
              description: e.description,
              color: e.color,
              categoryId: e.categoryId,
              parentTodoId: e.parentTodoId,
              icon: e.icon,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              isRecurring: e.isRecurring,
              recurringType: e.recurringType,
              recurringEndDate: e.recurringEndDate,
              timerType: e.timerType,
              countupElapsedSeconds: e.countupElapsedSeconds,
              pomodoroWorkMinutes: e.pomodoroWorkMinutes,
              pomodoroShortBreakMinutes: e.pomodoroShortBreakMinutes,
              pomodoroLongBreakMinutes: e.pomodoroLongBreakMinutes,
              pomodoroCycle: e.pomodoroCycle,
              pomodoroCompletedCycle: e.pomodoroCompletedCycle,
              isDeleted: e.isDeleted,
            ))
        .toList();
  }

  Future<List<Todo>> findFiltered({bool? isCompleted, int? categoryId}) async {
    final database = await AppDatabase.getSingletonInstance();
    final query = database.todos.select();
    // 論理削除されていないもののみ取得
    query.where((tbl) => tbl.isDeleted.equals(false));

    if (isCompleted != null) {
      query.where((tbl) => tbl.isCompleted.equals(isCompleted));
    }
    if (categoryId != null) {
      query.where((tbl) => tbl.categoryId.equals(categoryId));
    }
    final data = await query.get();
    return data
        .map((e) => Todo(
              id: e.id,
              dueDate: e.dueDate,
              title: e.title,
              isCompleted: e.isCompleted,
              description: e.description,
              color: e.color,
              categoryId: e.categoryId,
              parentTodoId: e.parentTodoId,
              icon: e.icon,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              isRecurring: e.isRecurring,
              recurringType: e.recurringType,
              recurringEndDate: e.recurringEndDate,
              timerType: e.timerType,
              countupElapsedSeconds: e.countupElapsedSeconds,
              pomodoroWorkMinutes: e.pomodoroWorkMinutes,
              pomodoroShortBreakMinutes: e.pomodoroShortBreakMinutes,
              pomodoroLongBreakMinutes: e.pomodoroLongBreakMinutes,
              pomodoroCycle: e.pomodoroCycle,
              pomodoroCompletedCycle: e.pomodoroCompletedCycle,
              isDeleted: e.isDeleted,
            ))
        .toList();
  }

  Future<List<Todo>> findByMonth(DateTime month) async {
    final database = await AppDatabase.getSingletonInstance();
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final data = await (database.todos.select()
          ..where((tbl) =>
              tbl.dueDate.isBiggerOrEqualValue(start) &
              tbl.dueDate.isSmallerThanValue(end) &
              tbl.isDeleted.equals(false)))
        .get();
    return data
        .map((e) => Todo(
              id: e.id,
              dueDate: e.dueDate,
              title: e.title,
              isCompleted: e.isCompleted,
              description: e.description,
              color: e.color,
              categoryId: e.categoryId,
              parentTodoId: e.parentTodoId,
              icon: e.icon,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              isRecurring: e.isRecurring,
              recurringType: e.recurringType,
              recurringEndDate: e.recurringEndDate,
              timerType: e.timerType,
              countupElapsedSeconds: e.countupElapsedSeconds,
              pomodoroWorkMinutes: e.pomodoroWorkMinutes,
              pomodoroShortBreakMinutes: e.pomodoroShortBreakMinutes,
              pomodoroLongBreakMinutes: e.pomodoroLongBreakMinutes,
              pomodoroCycle: e.pomodoroCycle,
              pomodoroCompletedCycle: e.pomodoroCompletedCycle,
              isDeleted: e.isDeleted,
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

  Future<List<TodoCheckListItem>> findByTodoIds(List<int> todoIds) async {
    if (todoIds.isEmpty) return [];
    final database = await AppDatabase.getSingletonInstance();
    final data = await (database.todoCheckListItems.select()
          ..where((tbl) => tbl.todoId.isIn(todoIds))
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
}
