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
import 'package:flutter/cupertino.dart';

enum ManageType { normal, pomodoro, checklist }

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
    final checklistEnabled = useState<bool>(checklistItems.value.isNotEmpty);
    final checklistInputController = useTextEditingController();

    // Pomodoro state
    final isPomodoro = useState<bool>(false);

    // 管理方法の選択肢
    final manageType = useState<ManageType>(ManageType.normal);
    // スイッチング時の状態同期
    useEffect(() {
      if (manageType.value == ManageType.pomodoro) {
        isPomodoro.value = true;
        checklistEnabled.value = false;
      } else if (manageType.value == ManageType.checklist) {
        isPomodoro.value = false;
        checklistEnabled.value = true;
      } else {
        isPomodoro.value = false;
        checklistEnabled.value = false;
      }
      return null;
    }, [manageType.value]);

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
          checklistEnabled.value = items.isNotEmpty;
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
                // ヘッダー
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
                const SizedBox(height: 10),
                _SectionCard(
                  child: Column(
                    children: [
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 期限
                _SectionTitle('期限'),
                _SectionCard(
                  child: Column(
                    children: [
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
                                initialDate: selectedDate.value,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (pickedDate != null) {
                                selectedDate.value = pickedDate;
                              }
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
                                  horizontal: 16, vertical: 8),
                              elevation: 0,
                            ),
                            child: const Text('日付を選択'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryTextColor,
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.surface,
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 繰り返し
                _SectionTitle('繰り返し'),
                _SectionCard(
                  child: Column(
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
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
                        if (recurringType.value == RecurringType.monthly)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Column(
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
                          ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 管理方法セクション
                _SectionTitle('管理方法'),
                _SectionCard(
                  padding: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: CupertinoSegmentedControl<ManageType>(
                      groupValue: manageType.value,
                      onValueChanged: (ManageType val) {
                        manageType.value = val;
                      },
                      children: {
                        ManageType.normal: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 4),
                          child: Text('通常',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: manageType.value == ManageType.normal
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondaryTextColor)),
                        ),
                        ManageType.pomodoro: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 4),
                          child: Text('タイマー',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: manageType.value == ManageType.pomodoro
                                      ? Theme.of(context)
                                          .colorScheme
                                          .accentColor
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondaryTextColor)),
                        ),
                        ManageType.checklist: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 4),
                          child: Text('チェックリスト',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color:
                                      manageType.value == ManageType.checklist
                                          ? Theme.of(context)
                                              .colorScheme
                                              .successColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondaryTextColor)),
                        ),
                      },
                      borderColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                      selectedColor: Theme.of(context).colorScheme.surface,
                      unselectedColor: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.7),
                      pressedColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.08),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // ポモドーロUI
                if (manageType.value == ManageType.pomodoro) ...[
                  _SectionTitle('ポモドーロ管理'),
                  _SectionCard(
                    child: Row(
                      children: [
                        Icon(Icons.timer,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'ポモドーロで管理します',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // チェックリストUI
                if (manageType.value == ManageType.checklist) ...[
                  _SectionTitle('チェックリスト'),
                  _SectionCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.checklist,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'チェックリスト',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: checklistInputController,
                                decoration: const InputDecoration(
                                  hintText: '項目を追加',
                                ),
                                onSubmitted: (value) {
                                  if (value.trim().isNotEmpty) {
                                    checklistItems.value = [
                                      ...checklistItems.value,
                                      TodoCheckListItemModel(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch,
                                        todoId: initialTodo?.id ?? -1,
                                        title: value.trim(),
                                        isCompleted: false,
                                        order: checklistItems.value.length,
                                      ),
                                    ];
                                    checklistInputController.clear();
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                final value =
                                    checklistInputController.text.trim();
                                if (value.isNotEmpty) {
                                  checklistItems.value = [
                                    ...checklistItems.value,
                                    TodoCheckListItemModel(
                                      id: DateTime.now().millisecondsSinceEpoch,
                                      todoId: initialTodo?.id ?? -1,
                                      title: value,
                                      isCompleted: false,
                                      order: checklistItems.value.length,
                                    ),
                                  ];
                                  checklistInputController.clear();
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...checklistItems.value.map((item) => ListTile(
                              title: Text(item.title),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  checklistItems.value = checklistItems.value
                                      .where((e) => e.id != item.id)
                                      .toList();
                                },
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // カテゴリ
                _SectionTitle('カテゴリ'),
                _SectionCard(
                  child: GestureDetector(
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
                                if (selectedCategory.value?.description !=
                                        null &&
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
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  child: TextField(
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
                ),
                const SizedBox(height: 24),

                // 追加・更新ボタン
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
                      // --- ポモドーロ用の値も保存 ---
                      // TodoModelにisPomodoroプロパティがなければdescription等にタグを付与するなどで仮対応
                      final descriptionText = descriptionController.text.trim();
                      final pomodoroTag = isPomodoro.value ? '[pomodoro]' : '';
                      final fullDescription = pomodoroTag.isNotEmpty
                          ? (descriptionText.isEmpty
                              ? pomodoroTag
                              : '$pomodoroTag $descriptionText')
                          : descriptionText;
                      if (initialTodo != null) {
                        // Update existing todo
                        await TodoService().updateTodo(
                          initialTodo!.id,
                          title: titleController.text.trim(),
                          description:
                              fullDescription.isEmpty ? null : fullDescription,
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
                          description:
                              fullDescription.isEmpty ? null : fullDescription,
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

// --- セクションタイトルとカードのWidgetを追加 ---
Widget _SectionTitle(String title) => Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );

class _SectionCard extends StatelessWidget {
  final Widget child;
  final int padding;
  const _SectionCard({required this.child, this.padding = 14});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: EdgeInsets.all(padding.toDouble()),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .colorScheme
                .mediumShadowColor
                .withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
