import 'package:solo/screen/colors.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/models/category_model.dart';
import 'package:solo/screen/widgets/todo/todo_detail_dialog.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/services/category_service.dart';
import 'package:solo/utilities/date.dart';
import 'package:solo/enums/todo_color.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:solo/screen/states/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoCard extends ConsumerWidget {
  final TodoModel todo;
  final VoidCallback? onRefresh;

  const TodoCard({
    super.key,
    required this.todo,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    final updatedTodo =
                        await TodoService().toggleTodoComplete(todo.id);
                    if (updatedTodo != null) {
                      // 通知管理を更新
                      await ref
                          .read(notificationStateProvider.notifier)
                          .handleTodoCompletionChange(updatedTodo);
                    }
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
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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
                // タイマー設定インジケーター
                if (todo.timerType != TimerType.none && !todo.isCompleted) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Theme.of(context)
                          .colorScheme
                          .accentColor
                          .withValues(alpha: 0.1),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .accentColor
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      todo.timerType == TimerType.pomodoro
                          ? Icons.timer
                          : Icons.timer_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.accentColor,
                    ),
                  ),
                ],
                const SizedBox(width: 8),
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
                      Expanded(
                        child: Text(
                          category.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: TodoColor.getColorFromString(category.color),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
                      fontSize: 12,
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

  String _getRecurringLabel(RecurringType? recurringType) {
    if (recurringType == null) return '';
    return recurringType.label;
  }
}
