import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/models/category_model.dart';
import 'package:solo/models/todo_checklist_item_model.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/services/category_service.dart';
import 'package:solo/services/todo_checklist_item_service.dart';
import 'package:solo/utilities/date.dart';
import 'package:solo/enums/todo_color.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:solo/screen/widgets/todo_checklist_widget.dart';

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
            const SizedBox(height: 12),
            Row(
              children: [
                // Category chip
                FutureBuilder<CategoryModel?>(
                  future: todo.categoryId != null
                      ? CategoryService().getCategoryById(todo.categoryId!)
                      : Future.value(null),
                  builder: (context, snapshot) {
                    final category = snapshot.data;
                    if (category != null) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                                color: TodoColor.getColorFromString(
                                    category.color),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              category.title,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: TodoColor.getColorFromString(
                                    category.color),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: TodoColor.getColorFromString(todo.color),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
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

class AddTodoDialog {
  static Future<void> show(
    BuildContext context, {
    DateTime? initialDate,
    TodoModel? initialTodo,
    VoidCallback? onSaved,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddTodoDialogContent(
        initialDate: initialDate,
        initialTodo: initialTodo,
        onSaved: onSaved,
      ),
    );
  }
}

class _AddTodoDialogContent extends HookConsumerWidget {
  final DateTime? initialDate;
  final TodoModel? initialTodo;
  final VoidCallback? onSaved;

  const _AddTodoDialogContent({
    this.initialDate,
    this.initialTodo,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController =
        useTextEditingController(text: initialTodo?.title ?? '');
    final descriptionController =
        useTextEditingController(text: initialTodo?.description ?? '');

    final selectedDate = useState<DateTime>(
      initialDate ?? initialTodo?.dueDate ?? DateTime.now(),
    );
    final selectedTime = useState<TimeOfDay>(
      TimeOfDay.fromDateTime(initialTodo?.dueDate ?? DateTime.now()),
    );
    final selectedColor = useState<String>(initialTodo?.color ?? 'blue');
    final selectedCategory = useState<CategoryModel?>(null);

    // Recurring state variables
    final isRecurring = useState<bool>(initialTodo?.isRecurring ?? false);
    final recurringType = useState<RecurringType?>(
      RecurringType.fromString(initialTodo?.recurringType),
    );
    final recurringEndDate = useState<DateTime?>(initialTodo?.recurringEndDate);
    final recurringDayOfWeek = useState<int?>(initialTodo?.recurringDayOfWeek);
    final recurringDayOfMonth =
        useState<int?>(initialTodo?.recurringDayOfMonth);

    // Checklist state
    final checklistItems = useState<List<TodoCheckListItemModel>>([]);

    // Initialize category if todo has categoryId
    useEffect(() {
      if (initialTodo?.categoryId != null) {
        CategoryService()
            .getCategoryById(initialTodo!.categoryId!)
            .then((category) {
          if (category != null) {
            selectedCategory.value = category;
          }
        });
      }
      return null;
    }, [initialTodo?.categoryId]);

    // Load existing checklist items if editing a todo
    useEffect(() {
      if (initialTodo != null) {
        TodoCheckListItemService()
            .getCheckListItemsForTodo(initialTodo!.id)
            .then((items) {
          checklistItems.value = items;
        });
      }
      return null;
    }, [initialTodo?.id]);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.mediumShadowColor,
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      initialTodo != null
                          ? Icons.edit
                          : Icons.add_circle_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      initialTodo != null ? 'Todoを編集' : '新しいTodoを追加',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primaryTextColor,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'タイトル',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.05),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '期限: ${formatDate(selectedDate.value, format: 'yyyy/MM/dd (EEE)')}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryTextColor,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate.value,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (pickedDate != null) {
                          selectedDate.value = pickedDate;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 0,
                      ),
                      child: const Text('日付を選択'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '時間: ${selectedTime.value.format(context)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryTextColor,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime.value,
                        );
                        if (pickedTime != null) {
                          selectedTime.value = pickedTime;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 0,
                      ),
                      child: const Text('時間を選択'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Recurring section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.repeat,
                          color: Theme.of(context).colorScheme.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '繰り返し',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.primaryTextColor,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: isRecurring.value,
                          onChanged: (value) => isRecurring.value = value,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                    if (isRecurring.value) ...[
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '繰り返しタイプ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<RecurringType?>(
                                value: recurringType.value,
                                isExpanded: true,
                                hint: const Text('タイプを選択'),
                                items:
                                    RecurringType.values.map((recurringType) {
                                  return DropdownMenuItem<RecurringType>(
                                    value: recurringType,
                                    child: Text(recurringType.label),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  recurringType.value = value;
                                  // Reset specific day/month when type changes
                                  if (value == RecurringType.weekly) {
                                    recurringDayOfWeek.value =
                                        selectedDate.value.weekday;
                                  } else if (value == RecurringType.monthly) {
                                    recurringDayOfMonth.value =
                                        selectedDate.value.day;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.event_busy,
                            color: Theme.of(context).colorScheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            recurringEndDate.value != null
                                ? '終了日: ${formatDate(recurringEndDate.value!, format: 'yyyy/MM/dd')}'
                                : '終了日: 未設定',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryTextColor,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: recurringEndDate.value ??
                                    DateTime.now()
                                        .add(const Duration(days: 30)),
                                firstDate: selectedDate.value,
                                lastDate: DateTime(2030),
                              );
                              recurringEndDate.value = pickedDate;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              elevation: 0,
                            ),
                            child: Text(
                                recurringEndDate.value != null ? '変更' : '設定'),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (recurringType.value == RecurringType.weekly)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '曜日',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value:
                                    recurringDayOfWeek.value ?? DateTime.monday,
                                isExpanded: true,
                                items: [
                                  DropdownMenuItem(
                                      value: DateTime.monday,
                                      child: Text('月曜日')),
                                  DropdownMenuItem(
                                      value: DateTime.tuesday,
                                      child: Text('火曜日')),
                                  DropdownMenuItem(
                                      value: DateTime.wednesday,
                                      child: Text('水曜日')),
                                  DropdownMenuItem(
                                      value: DateTime.thursday,
                                      child: Text('木曜日')),
                                  DropdownMenuItem(
                                      value: DateTime.friday,
                                      child: Text('金曜日')),
                                  DropdownMenuItem(
                                      value: DateTime.saturday,
                                      child: Text('土曜日')),
                                  DropdownMenuItem(
                                      value: DateTime.sunday,
                                      child: Text('日曜日')),
                                ],
                                onChanged: (value) =>
                                    recurringDayOfWeek.value = value,
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (recurringType.value == RecurringType.monthly)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '日付',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: recurringDayOfMonth.value ?? 1,
                                isExpanded: true,
                                items: List.generate(31, (index) {
                                  final day = index + 1;
                                  return DropdownMenuItem(
                                    value: day,
                                    child: Text('$day日'),
                                  );
                                }),
                                onChanged: (value) =>
                                    recurringDayOfMonth.value = value,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                TodoChecklistWidget(
                  todoId: initialTodo?.id,
                  initialItems: checklistItems.value,
                  onChecklistChanged: (updatedItems) {
                    checklistItems.value = updatedItems;
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final result = await CategorySelectionDialog.show(
                      context,
                      initialCategory: selectedCategory.value,
                    );
                    if (result != null) {
                      selectedCategory.value = result;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: selectedCategory.value != null
                                ? TodoColor.getColorFromString(
                                    selectedCategory.value!.color)
                                : Theme.of(context).colorScheme.outline,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.category,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedCategory.value?.title ?? 'カテゴリを選択',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: selectedCategory.value != null
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryTextColor
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondaryTextColor,
                                ),
                              ),
                              if (selectedCategory.value?.description != null &&
                                  selectedCategory
                                      .value!.description!.isNotEmpty)
                                Text(
                                  selectedCategory.value!.description!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryTextColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color:
                              Theme.of(context).colorScheme.secondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: '詳細（オプション）',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.05),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (titleController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('タイトルを入力してください')),
                        );
                        return;
                      }

                      final dueDate = DateTime(
                        selectedDate.value.year,
                        selectedDate.value.month,
                        selectedDate.value.day,
                        selectedTime.value.hour,
                        selectedTime.value.minute,
                      );

                      if (initialTodo != null) {
                        // Update existing todo
                        await TodoService().updateTodo(
                          initialTodo!.id,
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim().isEmpty
                              ? null
                              : descriptionController.text.trim(),
                          dueDate: dueDate,
                          color: selectedCategory.value?.color ??
                              selectedColor.value,
                          categoryId: selectedCategory.value?.id,
                          isRecurring: isRecurring.value,
                          recurringType: isRecurring.value
                              ? recurringType.value?.value
                              : null,
                          recurringEndDate:
                              isRecurring.value ? recurringEndDate.value : null,
                          recurringDayOfWeek: isRecurring.value &&
                                  recurringType.value == RecurringType.weekly
                              ? recurringDayOfWeek.value
                              : null,
                          recurringDayOfMonth: isRecurring.value &&
                                  recurringType.value == RecurringType.monthly
                              ? recurringDayOfMonth.value
                              : null,
                        );

                        // Update checklist items for existing todo
                        final checklistService = TodoCheckListItemService();
                        await checklistService
                            .deleteAllCheckListItemsForTodo(initialTodo!.id);
                        for (int i = 0; i < checklistItems.value.length; i++) {
                          final item = checklistItems.value[i];
                          await checklistService.createCheckListItem(
                            todoId: initialTodo!.id,
                            title: item.title,
                            order: i,
                          );
                        }
                      } else {
                        // Create new todo
                        final newTodo = await TodoService().createTodo(
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim().isEmpty
                              ? null
                              : descriptionController.text.trim(),
                          dueDate: dueDate,
                          color: selectedCategory.value?.color ??
                              selectedColor.value,
                          categoryId: selectedCategory.value?.id,
                          isRecurring: isRecurring.value,
                          recurringType: isRecurring.value
                              ? recurringType.value?.value
                              : null,
                          recurringEndDate:
                              isRecurring.value ? recurringEndDate.value : null,
                          recurringDayOfWeek: isRecurring.value &&
                                  recurringType.value == RecurringType.weekly
                              ? recurringDayOfWeek.value
                              : null,
                          recurringDayOfMonth: isRecurring.value &&
                                  recurringType.value == RecurringType.monthly
                              ? recurringDayOfMonth.value
                              : null,
                        );

                        // Create checklist items for new todo
                        final checklistService = TodoCheckListItemService();
                        for (int i = 0; i < checklistItems.value.length; i++) {
                          final item = checklistItems.value[i];
                          await checklistService.createCheckListItem(
                            todoId: newTodo.id,
                            title: item.title,
                            order: i,
                          );
                        }
                      }

                      if (context.mounted) {
                        Navigator.of(context).pop();
                        onSaved?.call();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              initialTodo != null
                                  ? 'Todoを更新しました'
                                  : 'Todoを追加しました',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    child: Text(
                      initialTodo != null ? '更新' : '追加',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

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
    final color = TodoColor.getColorFromString(todo.color);
    final checklistItems = useState<List<TodoCheckListItemModel>>([]);
    final isLoading = useState<bool>(true);

    // Load checklist items
    useEffect(() {
      void loadChecklistItems() async {
        try {
          isLoading.value = true;
          final items = await TodoCheckListItemService()
              .getCheckListItemsForTodo(todo.id);
          checklistItems.value = items;
        } finally {
          isLoading.value = false;
        }
      }

      loadChecklistItems();
      return null;
    }, [todo.id]);

    // Refresh checklist items when refresh is called
    void refreshChecklistItems() async {
      try {
        isLoading.value = true;
        final items =
            await TodoCheckListItemService().getCheckListItemsForTodo(todo.id);
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: FutureBuilder<CategoryModel?>(
          future: todo.categoryId != null
              ? CategoryService().getCategoryById(todo.categoryId!)
              : Future.value(null),
          builder: (context, snapshot) {
            final category = snapshot.data;
            return Column(
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.category,
                                size: 16,
                                color: color.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              category.title,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
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
                                  ? Theme.of(context).colorScheme.successColor
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              todo.isCompleted ? '完了済み' : '未完了',
                              style: TextStyle(
                                color: todo.isCompleted
                                    ? Theme.of(context).colorScheme.successColor
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
                              formatDate(todo.dueDate,
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
                        if (todo.isRecurring == true) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.repeat,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                _getRecurringLabel(todo.recurringType),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (todo.description != null &&
                            todo.description!.isNotEmpty) ...[
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
                                  _buildChecklistItemRow(context, item, todo,
                                      refreshChecklistItems)),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // アクションボタン
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!todo.isCompleted)
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.check,
                              color: Theme.of(context).colorScheme.surface,
                              size: 24),
                          label: const Text('完了',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.successColor,
                            foregroundColor:
                                Theme.of(context).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await TodoService().toggleTodoComplete(todo.id);
                            onRefresh?.call();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('${todo.title}を完了にしました')),
                              );
                            }
                          },
                        ),
                      ),
                    if (!todo.isCompleted) const SizedBox(width: 12),
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
                            initialTodo: todo,
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
                          await TodoService().deleteTodo(todo.id);
                          onRefresh?.call();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${todo.title}を削除しました')),
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
                          color: Theme.of(context).colorScheme.mutedTextColor,
                          width: 1.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getRecurringLabel(String? recurringType) {
    if (recurringType == null) return '';
    final type = RecurringType.fromString(recurringType);
    return type?.label ?? '';
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
            // Toggle checklist item completion
            final checklistService = TodoCheckListItemService();
            await checklistService.toggleCheckListItemComplete(item.id);

            // Check if todo should be auto-completed
            final todoService = TodoService();
            final wasCompleted = await todoService
                .checkAndUpdateTodoCompletionByChecklist(todo.id);

            if (wasCompleted && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${todo.title}を完了にしました')),
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
                    child: Text(item.title),
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

Future<Map<String, dynamic>?> showTodoFilterDialog({
  required BuildContext context,
  int? initialCategoryId,
  String? initialStatus,
}) {
  int? tempSelectedCategoryId = initialCategoryId;
  String? tempSelectedStatus = initialStatus;

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Row(
              children: [
                Icon(Icons.filter_alt,
                    color: Theme.of(context).colorScheme.primary, size: 28),
                const SizedBox(width: 8),
                const Text('絞り込み',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ステータス',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.primaryTextColor)),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatusChip(
                        label: 'すべて',
                        selected: tempSelectedStatus == null,
                        onTap: () => setState(() => tempSelectedStatus = null),
                        icon: Icons.all_inclusive,
                      ),
                      const SizedBox(height: 8),
                      _StatusChip(
                        label: '未完了',
                        selected: tempSelectedStatus == 'incomplete',
                        onTap: () =>
                            setState(() => tempSelectedStatus = 'incomplete'),
                        icon: Icons.radio_button_unchecked,
                      ),
                      const SizedBox(height: 8),
                      _StatusChip(
                        label: '完了',
                        selected: tempSelectedStatus == 'completed',
                        onTap: () =>
                            setState(() => tempSelectedStatus = 'completed'),
                        icon: Icons.check_circle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('カテゴリ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.primaryTextColor)),
                  const SizedBox(height: 8),
                  FutureBuilder<List<CategoryModel>>(
                    future: CategoryService().getCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final categories = snapshot.data ?? [];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.15)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int?>(
                            value: tempSelectedCategoryId,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryTextColor),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Row(
                                  children: [
                                    Icon(Icons.circle_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withValues(alpha: 0.5),
                                        size: 18),
                                    const SizedBox(width: 8),
                                    const Text('すべて'),
                                  ],
                                ),
                              ),
                              ...categories.map((category) => DropdownMenuItem(
                                    value: category.id,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: TodoColor.getColorFromString(
                                                category.color),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Icon(
                                            Icons.category,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(category.title),
                                      ],
                                    ),
                                  )),
                            ],
                            onChanged: (value) =>
                                setState(() => tempSelectedCategoryId = value),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('キャンセル'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.of(context).pop({
                  'categoryId': tempSelectedCategoryId,
                  'status': tempSelectedStatus,
                }),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child:
                      Text('決定', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outline;
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                : Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: borderColor,
              width: selected ? 2 : 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: Offset(0, 2))
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// === Category Management Components ===

class CategorySelectionDialog {
  static Future<CategoryModel?> show(
    BuildContext context, {
    CategoryModel? initialCategory,
  }) async {
    return await showDialog<CategoryModel?>(
      context: context,
      builder: (context) => _CategorySelectionDialogContent(
        initialCategory: initialCategory,
      ),
    );
  }
}

class _CategorySelectionDialogContent extends StatefulWidget {
  final CategoryModel? initialCategory;

  const _CategorySelectionDialogContent({
    this.initialCategory,
  });

  @override
  State<_CategorySelectionDialogContent> createState() =>
      _CategorySelectionDialogContentState();
}

class _CategorySelectionDialogContentState
    extends State<_CategorySelectionDialogContent> {
  CategoryModel? selectedCategory;
  List<CategoryModel> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categoryService = CategoryService();
      final loadedCategories = await categoryService.getCategories();
      setState(() {
        categories = loadedCategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(
            Icons.category,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            'カテゴリを選択',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryTextColor,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Add new category option
                  _CategoryOption(
                    title: '新しいカテゴリを作成',
                    description: 'カスタムカテゴリを追加',
                    color: 'blue',
                    isSelected: false,
                    onTap: () async {
                      Navigator.of(context).pop();
                      final newCategory = await AddCategoryDialog.show(context);
                      if (newCategory != null && mounted) {
                        Navigator.of(context).pop(newCategory);
                      }
                    },
                    icon: Icons.add,
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  // Existing categories
                  ...categories.map((category) => _CategoryOption(
                        title: category.title,
                        description: category.description ?? '',
                        color: category.color,
                        isSelected: selectedCategory?.id == category.id,
                        onTap: () =>
                            setState(() => selectedCategory = category),
                      )),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: selectedCategory != null
              ? () => Navigator.of(context).pop(selectedCategory)
              : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '選択',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryOption extends StatelessWidget {
  final String title;
  final String description;
  final String color;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _CategoryOption({
    required this.title,
    required this.description,
    required this.color,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: isSelected ? 2 : 1,
              ),
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.surface,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TodoColor.getColorFromString(color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon ?? Icons.category,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primaryTextColor,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddCategoryDialog {
  static Future<CategoryModel?> show(BuildContext context) async {
    return await showDialog<CategoryModel?>(
      context: context,
      builder: (context) => _AddCategoryDialogContent(),
    );
  }
}

class _AddCategoryDialogContent extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final selectedColor = useState<String>('blue');

    final isTitleNotEmpty = useListenableSelector(
      titleController,
      () => titleController.text.trim().isNotEmpty,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(
            Icons.add_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            'カテゴリを追加',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryTextColor,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'カテゴリ名',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.05),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: '詳細 (オプション)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.05),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'カラー',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primaryTextColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TodoColor.values.map((todoColor) {
                final isSelected = todoColor.name == selectedColor.value;
                return GestureDetector(
                  onTap: () => selectedColor.value = todoColor.name,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: todoColor.color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryTextColor
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: todoColor.color.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: isTitleNotEmpty
              ? () async {
                  final categoryService = CategoryService();
                  final newCategory = await categoryService.createCategory(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim().isEmpty
                        ? null
                        : descriptionController.text.trim(),
                    color: selectedColor.value,
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop(newCategory);
                  }
                }
              : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '追加',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
