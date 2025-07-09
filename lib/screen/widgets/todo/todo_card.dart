import 'package:solo/screen/colors.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/models/category_model.dart';
import 'package:solo/screen/widgets/todo/add_todo_dialog.dart';
import 'package:solo/screen/widgets/todo/todo_detail_dialog.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/services/category_service.dart';
import 'package:solo/utilities/date.dart';
import 'package:solo/enums/todo_color.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRefresh;

  const TodoCard({
    super.key,
    required this.todo,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isTodayTag = isToday(todo.dueDate);
    final isOverdue =
        todo.dueDate.isBefore(DateTime.now()) && !todo.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: isOverdue
              ? Theme.of(context).colorScheme.errorColor.withValues(alpha: 0.3)
              : isTodayTag
                  ? Theme.of(context)
                      .colorScheme
                      .todayTagColor
                      .withValues(alpha: 0.3)
                  : TodoColor.getColorFromString(todo.color)
                      .withValues(alpha: 0.3),
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
      child: InkWell(
        onTap: () => TodoDetailDialog.show(
          context,
          todo,
          onRefresh: onRefresh,
        ),
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await TodoService().toggleTodoComplete(todo.id);
                    onRefresh?.call();
                  },
                  child: Container(
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
                            : TodoColor.getColorFromString(todo.color),
                        width: 2,
                      ),
                    ),
                    child: todo.isCompleted
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: Theme.of(context).colorScheme.surface,
                          )
                        : null,
                  ),
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
                    child: Text(
                      '期限切れ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.errorColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ] else if (isTodayTag && !todo.isCompleted) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:
                          Theme.of(context).colorScheme.todayTagBackgroundColor,
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
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case 'edit':
                        await AddTodoDialog.show(
                          context,
                          initialTodo: todo,
                          onSaved: onRefresh,
                        );
                        break;
                      case 'delete':
                        _showDeleteConfirmation(context, todo);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('編集'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete,
                              size: 16,
                              color: Theme.of(context).colorScheme.errorColor),
                          SizedBox(width: 8),
                          Text('削除',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .errorColor)),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.mutedTextColor,
                  ),
                ),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            FutureBuilder<CategoryModel?>(
              future: todo.categoryId != null
                  ? CategoryService().getCategoryById(todo.categoryId!)
                  : Future.value(null),
              builder: (context, snapshot) {
                final category = snapshot.data;
                if (category == null) {
                  return const SizedBox.shrink(); // Show nothing while loading
                }
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: TodoColor.getColorFromString(category.color)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: TodoColor.getColorFromString(category.color)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: TodoColor.getColorFromString(category.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: TodoColor.getColorFromString(category.color),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 8),
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
                if (todo.isRecurring == true) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.repeat,
                    size: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    _getRecurringLabel(todo.recurringType),
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRecurringLabel(String? recurringType) {
    if (recurringType == null) return '';
    final type = RecurringType.fromString(recurringType);
    return type?.label ?? '';
  }

  void _showDeleteConfirmation(BuildContext context, TodoModel todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除確認'),
        content: Text('「${todo.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await TodoService().deleteTodo(todo.id);
              onRefresh?.call();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${todo.title}を削除しました')),
                );
              }
            },
            child: Text(
              '削除',
              style: TextStyle(color: Theme.of(context).colorScheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
