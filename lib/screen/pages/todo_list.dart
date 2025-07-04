import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/utilities/date.dart';

class TodoListPage extends HookConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8F9FA),
            Color(0xFFE9ECEF),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Todo一覧',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
            
            // Todo List
            Expanded(
              child: FutureBuilder<List<TodoModel>>(
                future: TodoService().getTodo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'エラーが発生しました: ${snapshot.error}',
                        style: const TextStyle(
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    );
                  }

                  final todos = snapshot.data ?? [];
                  
                  if (todos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF0F0F0),
                            ),
                            child: const Icon(
                              Icons.checklist_rounded,
                              size: 60,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'まだTodoがありません',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6C757D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '新しいタスクを追加してみましょう',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoCard(todo: todo);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  final TodoModel todo;

  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(todo.dueDate);
    final isOverdue = todo.dueDate.isBefore(DateTime.now()) && !todo.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
          color: isOverdue
              ? Colors.red.withValues(alpha: 0.3)
              : isToday
                  ? const Color(0xFF667eea).withValues(alpha: 0.3)
                  : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: todo.isCompleted
                      ? const Color(0xFF4CAF50)
                      : Colors.transparent,
                  border: Border.all(
                    color: todo.isCompleted
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFE0E0E0),
                    width: 2,
                  ),
                ),
                child: todo.isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: todo.isCompleted
                        ? const Color(0xFF9E9E9E)
                        : const Color(0xFF2C3E50),
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              if (isOverdue && !todo.isCompleted) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red.withValues(alpha: 0.1),
                  ),
                  child: const Text(
                    '期限切れ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ] else if (isToday && !todo.isCompleted) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF667eea).withValues(alpha: 0.1),
                  ),
                  child: const Text(
                    '今日',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF667eea),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (todo.description != null && todo.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              todo.description!,
              style: TextStyle(
                fontSize: 14,
                color: todo.isCompleted
                    ? const Color(0xFFBDBDBD)
                    : const Color(0xFF6C757D),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 16,
                color: isOverdue && !todo.isCompleted
                    ? Colors.red
                    : const Color(0xFF9E9E9E),
              ),
              const SizedBox(width: 4),
              Text(
                formatDate(todo.dueDate, format: 'yyyy/MM/dd (EEE) HH:mm'),
                style: TextStyle(
                  fontSize: 12,
                  color: isOverdue && !todo.isCompleted
                      ? Colors.red
                      : const Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
}