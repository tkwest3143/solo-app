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
