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
}
