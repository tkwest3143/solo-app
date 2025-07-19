import 'package:flutter/material.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/screen/widgets/todo/multi_step_add_todo_dialog.dart';

class AddTodoDialog {
  static Future<void> show(
    BuildContext context, {
    DateTime? initialDate,
    TodoModel? initialTodo,
    VoidCallback? onSaved,
  }) async {
    return MultiStepAddTodoDialog.show(
      context,
      initialDate: initialDate,
      initialTodo: initialTodo,
      onSaved: onSaved,
    );
  }
}