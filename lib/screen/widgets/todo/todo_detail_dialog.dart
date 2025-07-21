import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/models/category_model.dart';
import 'package:solo/models/todo_checklist_item_model.dart';
import 'package:solo/screen/widgets/todo/add_todo_dialog.dart';
import 'package:solo/screen/widgets/common/confirmation_dialog.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/services/category_service.dart';
import 'package:solo/services/todo_checklist_item_service.dart';
import 'package:solo/utilities/date.dart';
import 'package:solo/enums/todo_color.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:go_router/go_router.dart';

class TodoDetailDialog {
  static void show(
    BuildContext context,
    TodoModel todo, {
    VoidCallback? onRefresh,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TodoDetailContent(
        todo: todo,
        onRefresh: onRefresh,
      ),
    );
  }
}

class _TodoDetailContent extends HookConsumerWidget {
  final TodoModel todo;
  final VoidCallback? onRefresh;
  const _TodoDetailContent({required this.todo, this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realTodo = useState(todo);
    final color = TodoColor.getColorFromString(todo.color);
    final checklistItems = useState<List<TodoCheckListItemModel>>([]);
    final isLoading = useState<bool>(true);

    // Load checklist items and register new Todo if id is negative
    useEffect(() {
      void loadChecklistItems() async {
        try {
          isLoading.value = true;

          final id = todo.id < 0 ? todo.id.abs() : todo.id;
          final items =
              await TodoCheckListItemService().getCheckListItemsForTodo(id);

          if (todo.id < 0) {
            // 新規Todoとして登録
            final newTodo = await TodoService().createTodo(
              title: todo.title,
              description: todo.description,
              dueDate: todo.dueDate,
              color: todo.color,
              categoryId: todo.categoryId,
              isRecurring: todo.isRecurring,
              recurringType: todo.recurringType,
              recurringEndDate: todo.recurringEndDate,
              parentTodoId: todo.parentTodoId,
              // タイマー設定を引き継ぎ
              timerType: todo.timerType,
              countupElapsedSeconds: todo.countupElapsedSeconds,
              pomodoroWorkMinutes: todo.pomodoroWorkMinutes,
              pomodoroShortBreakMinutes: todo.pomodoroShortBreakMinutes,
              pomodoroLongBreakMinutes: todo.pomodoroLongBreakMinutes,
              pomodoroCycle: todo.pomodoroCycle,
              pomodoroCompletedCycle: todo.pomodoroCompletedCycle,
            );
            // 新規TodoのIDでチェックリストも新規登録
            final newItems = <TodoCheckListItemModel>[];
            for (final item in items) {
              final newItem =
                  await TodoCheckListItemService().createCheckListItem(
                todoId: newTodo.id,
                title: item.title,
                order: item.order,
              );
              newItems.add(newItem);
            }
            // 状態を新しいTodo/new checklistに更新
            realTodo.value = newTodo;
            checklistItems.value = newItems;
            // 追加: onRefreshを呼び出してUIをリロード（カレンダーやリストのアイコン更新用）
            onRefresh?.call();
            return;
          } else {
            // 既存のTodoのチェックリストアイテムを取得
            if (items.isEmpty) {
              checklistItems.value = [];
            } else {
              checklistItems.value = items;
            }
          }
        } finally {
          isLoading.value = false;
        }
      }

      loadChecklistItems();
      return null;
    }, [todo.id]);

    void refreshChecklistItems() async {
      try {
        isLoading.value = true;
        final items = await TodoCheckListItemService()
            .getCheckListItemsForTodo(realTodo.value.id);
        checklistItems.value = items;
      } finally {
        isLoading.value = false;
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 32,
        left: 0,
        right: 0,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.mediumShadowColor,
                blurRadius: 24,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: FutureBuilder<CategoryModel?>(
            future: realTodo.value.categoryId != null
                ? CategoryService().getCategoryById(realTodo.value.categoryId!)
                : Future.value(null),
            builder: (context, snapshot) {
              final category = snapshot.data;
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // カラー・カテゴリ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 2,
                            ),
                          ),
                        ),
                        if (category != null) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.category,
                                      size: 16,
                                      color: color.computeLuminance() > 0.5
                                          ? Colors.black
                                          : Colors.white),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      category.title,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    // タイトル
                    Center(
                      child: Text(
                        todo.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                        ),
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 詳細カード
                    Card(
                      elevation: 0,
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  todo.isCompleted
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: todo.isCompleted
                                      ? Theme.of(context)
                                          .colorScheme
                                          .successColor
                                      : Theme.of(context)
                                          .colorScheme
                                          .primaryTextColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  realTodo.value.isCompleted ? '完了済み' : '未完了',
                                  style: TextStyle(
                                    color: realTodo.value.isCompleted
                                        ? Theme.of(context)
                                            .colorScheme
                                            .successColor
                                        : Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.schedule_rounded,
                                    size: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryTextColor),
                                const SizedBox(width: 4),
                                Text(
                                  formatDate(realTodo.value.dueDate,
                                      format: 'yyyy/MM/dd (EEE) HH:mm'),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryTextColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            if (realTodo.value.isRecurring == true) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.repeat,
                                      size: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    _getRecurringLabel(
                                        realTodo.value.recurringType),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (realTodo.value.description != null &&
                                realTodo.value.description!.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.notes,
                                      size: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryTextColor),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      todo.description!,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryTextColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            // Checklist items
                            if (checklistItems.value.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Icon(Icons.checklist,
                                          size: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryTextColor),
                                      const SizedBox(width: 6),
                                      Text(
                                        'チェックリスト (${checklistItems.value.where((item) => item.isCompleted).length}/${checklistItems.value.length})',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...checklistItems.value.map((item) =>
                                      _buildChecklistItemRow(
                                          context,
                                          item,
                                          realTodo.value,
                                          refreshChecklistItems)),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // タイマー関連のタスクの場合、タイマーへのボタンを表示
                    if (realTodo.value.timerType != TimerType.none &&
                        !realTodo.value.isCompleted) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(
                            realTodo.value.timerType == TimerType.pomodoro
                                ? Icons.timer
                                : Icons.timer_outlined,
                            color: Theme.of(context).colorScheme.surface,
                            size: 24,
                          ),
                          label: Text(
                            realTodo.value.timerType == TimerType.pomodoro
                                ? 'ポモドーロタイマーを開始'
                                : 'カウントアップタイマーを開始',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.accentColor,
                            foregroundColor:
                                Theme.of(context).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            // タイマー画面に遷移してこのTodoを選択し、適切なタイマーモードを設定
                            final timerMode =
                                realTodo.value.timerType == TimerType.pomodoro
                                    ? 'pomodoro'
                                    : 'countup';
                            context.go(
                                '/timer?todoId=${realTodo.value.id}&mode=$timerMode');
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 繰り返しTodo全削除ボタン（繰り返しTodoの場合のみ表示）
                    if (realTodo.value.isRecurring == true) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Theme.of(context).colorScheme.surface,
                            size: 24,
                          ),
                          label: const Text(
                            '全ての繰り返しTodoを削除',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.errorColor,
                            foregroundColor:
                                Theme.of(context).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          onPressed: () async {
                            // 確認ダイアログを表示
                            final confirmed = await ConfirmationDialog.showDeleteAllRecurringConfirmation(
                              context,
                              todoTitle: realTodo.value.title,
                            );

                            if (confirmed && context.mounted) {
                              Navigator.of(context).pop();
                              await TodoService().deleteAllRecurringTodos(realTodo.value.id);
                              onRefresh?.call();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          '「${realTodo.value.title}」に関連する全ての繰り返しTodoを削除しました',
                                          overflow: TextOverflow.visible,
                                          softWrap: true,)),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // アクションボタン
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (!realTodo.value.isCompleted)
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.check,
                                  color: Theme.of(context).colorScheme.surface,
                                  size: 24),
                              label: const Text('完了',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.successColor,
                                foregroundColor:
                                    Theme.of(context).colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await TodoService()
                                    .toggleTodoComplete(realTodo.value.id);
                                onRefresh?.call();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${realTodo.value.title}を完了にしました',
                                            overflow: TextOverflow.visible,
                                            softWrap: true,)),
                                  );
                                }
                              },
                            ),
                          ),
                        if (!realTodo.value.isCompleted)
                          const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).colorScheme.surface,
                                size: 24),
                            label: const Text('編集',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await AddTodoDialog.show(
                                context,
                                initialTodo: realTodo.value,
                                onSaved: onRefresh,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.delete,
                                color: Theme.of(context).colorScheme.surface,
                                size: 24),
                            label: const Text('削除',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.errorColor,
                              foregroundColor:
                                  Theme.of(context).colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await TodoService().deleteTodo(realTodo.value.id,
                                  date: realTodo.value.dueDate);
                              onRefresh?.call();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          '${realTodo.value.title}を削除しました',
                                          overflow: TextOverflow.visible,
                                          softWrap: true,)),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close_rounded,
                            color: Theme.of(context).colorScheme.mutedTextColor,
                            size: 22),
                        label: Text(
                          '閉じる',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.mutedTextColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.mutedTextColor,
                              width: 1.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getRecurringLabel(RecurringType? recurringType) {
    if (recurringType == null) return '';
    return recurringType.label;
  }

  Widget _buildChecklistItemRow(
      BuildContext context,
      TodoCheckListItemModel item,
      TodoModel todo,
      VoidCallback refreshChecklistItems) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            // 仮想インスタンスの場合は新規Todo生成し、onRefreshでUI再取得
            int realTodoId = todo.id;
            if (todo.id < 0) {
              final todoService = TodoService();
              final newTodo =
                  await todoService.generateNextRecurringInstance(todo);
              if (newTodo != null) {
                realTodoId = newTodo.id;
                onRefresh?.call();
                return;
              }
            }
            // Toggle checklist item completion
            final checklistService = TodoCheckListItemService();
            await checklistService.toggleCheckListItemComplete(item.id);

            // Check if todo should be auto-completed
            final todoService = TodoService();
            final wasCompleted = await todoService
                .checkAndUpdateTodoCompletionByChecklist(realTodoId);

            if (wasCompleted && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${todo.title}を完了にしました',
                    overflow: TextOverflow.visible,
                    softWrap: true,)),
              );
            }

            // Refresh the UI
            refreshChecklistItems();
            onRefresh?.call();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: item.isCompleted
                  ? Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.05)
                  : null,
            ),
            child: Row(
              children: [
                const SizedBox(width: 22), // Align with icon above
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: item.isCompleted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      width: 1.5,
                    ),
                    boxShadow: item.isCompleted
                        ? [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.2),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: item.isCompleted
                      ? Icon(
                          Icons.check,
                          size: 12,
                          color: Theme.of(context).colorScheme.surface,
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: item.isCompleted
                          ? Theme.of(context).colorScheme.outline
                          : Theme.of(context).colorScheme.secondaryTextColor,
                      fontSize: 13,
                      decoration:
                          item.isCompleted ? TextDecoration.lineThrough : null,
                      decorationColor: Theme.of(context).colorScheme.outline,
                    ),
                    child: Text(
                      item.title,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ),
                if (!item.isCompleted)
                  Icon(
                    Icons.radio_button_unchecked,
                    size: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.6),
                  )
                else
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.8),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
