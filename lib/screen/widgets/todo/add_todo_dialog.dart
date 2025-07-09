import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/models/category_model.dart';
import 'package:solo/models/todo_checklist_item_model.dart';
import 'package:solo/screen/widgets/todo/category_selection_dialog.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/services/category_service.dart';
import 'package:solo/services/todo_checklist_item_service.dart';
import 'package:solo/utilities/date.dart';
import 'package:solo/enums/todo_color.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:solo/screen/widgets/todo_checklist_widget.dart';

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
        top: 32,
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
                                  if (value == RecurringType.monthly) {
                                    recurringDayOfMonth.value =
                                        selectedDate.value.day;
                                  }
                                  // weeklyの場合は曜日選択不要なので何もしない
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
                    if (recurringType.value == RecurringType.monthly)
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
                              ? selectedDate.value.weekday
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
                              ? selectedDate.value.weekday
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
