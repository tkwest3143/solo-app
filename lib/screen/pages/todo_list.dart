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
          colors: Theme.of(context).colorScheme.backgroundGradient,
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
                  SizedBox(width: 12),
                  Text(
                    'Todo一覧',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primaryTextColor,
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
                    // ダミーデータを表示
                    final dummyData = [
                      TodoModel(
                          id: 1,
                          title: 'ダミーTodo 1',
                          description: '詳細 1',
                          dueDate: DateTime.now(),
                          isCompleted: false),
                      TodoModel(
                          id: 2,
                          title: 'ダミーTodo 2',
                          description: '詳細 2',
                          dueDate: DateTime.now().add(Duration(days: 1)),
                          isCompleted: false),
                    ];

                    return ListView.builder(
                      itemCount: dummyData.length,
                      itemBuilder: (context, index) {
                        final todo = dummyData[index];
                        return ListTile(
                          title: Text(todo.title),
                          subtitle: Text(todo.description ?? ''),
                          trailing: Text(formatDate(todo.dueDate)),
                        );
                      },
                    );
                  }),
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
    final isOverdue =
        todo.dueDate.isBefore(DateTime.now()) && !todo.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
          color: isOverdue
              ? Theme.of(context).colorScheme.errorColor.withValues(alpha: 0.3)
              : isToday
                  ? Theme.of(context).colorScheme.todayTagColor.withValues(alpha: 0.3)
                  : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.lightShadowColor,
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
                      ? Theme.of(context).colorScheme.successColor
                      : Colors.transparent,
                  border: Border.all(
                    color: todo.isCompleted
                        ? Theme.of(context).colorScheme.successColor
                        : Theme.of(context).colorScheme.outline,
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
                        ? Theme.of(context).colorScheme.mutedTextColor
                        : Theme.of(context).colorScheme.primaryTextColor,
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              if (isOverdue && !todo.isCompleted) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.errorBackgroundColor,
                  ),
                  child: const Text(
                    '期限切れ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.errorColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ] else if (isToday && !todo.isCompleted) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.todayTagBackgroundColor,
                  ),
                  child: Text(
                    '今日',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.todayTagColor,
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
                    ? Theme.of(context).colorScheme.mutedTextColor
                    : Theme.of(context).colorScheme.secondaryTextColor,
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
                    ? Theme.of(context).colorScheme.errorColor
                    : Theme.of(context).colorScheme.mutedTextColor,
              ),
              const SizedBox(width: 4),
              Text(
                formatDate(todo.dueDate, format: 'yyyy/MM/dd (EEE) HH:mm'),
                style: TextStyle(
                  fontSize: 12,
                  color: isOverdue && !todo.isCompleted
                      ? Theme.of(context).colorScheme.errorColor
                      : Theme.of(context).colorScheme.mutedTextColor,
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
