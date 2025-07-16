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
import 'package:solo/enums/timer_type.dart';
import 'package:solo/screen/states/notification_state.dart';

enum ManageType { normal, pomodoro, countup, checklist }

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
    final recurringType = useState<RecurringType?>(initialTodo?.recurringType);
    final recurringEndDate = useState<DateTime?>(initialTodo?.recurringEndDate);

    // Checklist state
    final checklistItems = useState<List<TodoCheckListItemModel>>([]);
    final checklistEnabled = useState<bool>(checklistItems.value.isNotEmpty);
    final checklistInputController = useTextEditingController();

    // Pomodoro state
    final isPomodoro = useState<bool>(false);

    // ポモドーロタイマー設定
    final pomodoroWorkMinutes = useState<int>(25);
    final pomodoroShortBreakMinutes = useState<int>(5);
    final pomodoroLongBreakMinutes = useState<int>(15);
    final pomodoroCycle = useState<int>(4);
    final pomodoroCompletionCycles = useState<int>(2); // Todo完了に必要なセット数

    // カウントアップタイマー設定
    final countupTargetMinutes = useState<int?>(null);

    // 管理方法の選択肢
    final manageType = useState<ManageType>(ManageType.normal);

    // 既存のTodoの場合、タイマータイプから管理方法を初期化
    useEffect(() {
      if (initialTodo != null) {
        if (initialTodo!.timerType == TimerType.pomodoro) {
          manageType.value = ManageType.pomodoro;
          // ポモドーロ設定を読み込み
          if (initialTodo!.pomodoroWorkMinutes != null) {
            pomodoroWorkMinutes.value = initialTodo!.pomodoroWorkMinutes!;
          }
          if (initialTodo!.pomodoroShortBreakMinutes != null) {
            pomodoroShortBreakMinutes.value =
                initialTodo!.pomodoroShortBreakMinutes!;
          }
          if (initialTodo!.pomodoroLongBreakMinutes != null) {
            pomodoroLongBreakMinutes.value =
                initialTodo!.pomodoroLongBreakMinutes!;
          }
          if (initialTodo!.pomodoroCycle != null) {
            pomodoroCycle.value = initialTodo!.pomodoroCycle!;
          }
          // 完了セット数も読み込み（現在はpomodoroCycleと同じ値を使用）
          if (initialTodo!.pomodoroCompletedCycle != null) {
            pomodoroCompletionCycles.value =
                initialTodo!.pomodoroCompletedCycle!;
          }
        } else if (initialTodo!.timerType == TimerType.countup) {
          manageType.value = ManageType.countup;
          // カウントアップ設定を読み込み（仮想的な目標時間として経過時間を使用）
          if (initialTodo!.countupElapsedSeconds != null &&
              initialTodo!.countupElapsedSeconds! > 0) {
            countupTargetMinutes.value =
                (initialTodo!.countupElapsedSeconds! / 60).round();
          }
        }
      }
      return null;
    }, [initialTodo]);
    // スイッチング時の状態同期
    useEffect(() {
      if (manageType.value == ManageType.pomodoro) {
        isPomodoro.value = true;
        checklistEnabled.value = false;
      } else if (manageType.value == ManageType.countup) {
        isPomodoro.value = false;
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
          child: Column(
            children: [
              // 固定ヘッダー
              Container(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
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
              ),
              // スクロール可能なコンテンツとボタン
              Expanded(
                child: Column(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionCard(
                            child: Column(
                              children: [
                                TextField(
                                  controller: titleController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    labelText: 'タイトル *',
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
                          _buildSectionTitle(
                              context, isRecurring.value ? '開始日' : '期限'),
                          _SectionCard(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${isRecurring.value ? '開始日' : '期限'}: ${formatDate(selectedDate.value, format: 'yyyy/MM/dd (EEE)')}',
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
                                          selectableDayPredicate: (date) {
                                            // 毎月最終日の場合は月末のみ選択可能
                                            if (recurringType.value ==
                                                RecurringType.monthlyLast) {
                                              final lastDay = DateTime(
                                                      date.year,
                                                      date.month + 1,
                                                      0)
                                                  .day;
                                              return date.day == lastDay;
                                            }
                                            return true;
                                          },
                                        );
                                        if (pickedDate != null) {
                                          selectedDate.value = pickedDate;
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                          _buildSectionTitle(context, '繰り返し'),
                          _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.repeat,
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                                      onChanged: (value) =>
                                          isRecurring.value = value,
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ],
                                ),
                                if (isRecurring.value) ...[
                                  const SizedBox(height: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<RecurringType?>(
                                            value: recurringType.value,
                                            isExpanded: true,
                                            hint: const Text('タイプを選択'),
                                            items: RecurringType.values
                                                .map((recurringType) {
                                              return DropdownMenuItem<
                                                  RecurringType>(
                                                value: recurringType,
                                                child:
                                                    Text(recurringType.label),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              recurringType.value = value;
                                              // Reset specific day/month when type changes
                                              if (value ==
                                                  RecurringType.monthly) {
                                                // 毎月の場合、開始日の日付を使用
                                              } else if (value ==
                                                  RecurringType.monthlyLast) {
                                                // 毎月最終日の場合、現在の月の最終日に自動設定
                                                final currentDate =
                                                    selectedDate.value;
                                                final lastDay = DateTime(
                                                    currentDate.year,
                                                    currentDate.month + 1,
                                                    0);
                                                selectedDate.value = DateTime(
                                                  lastDay.year,
                                                  lastDay.month,
                                                  lastDay.day,
                                                  currentDate.hour,
                                                  currentDate.minute,
                                                );
                                              }
                                              // weeklyの場合は曜日選択不要なので何もしない
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (recurringType.value !=
                                      RecurringType.monthly) ...[
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.event_busy,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                            final pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: recurringEndDate
                                                      .value ??
                                                  DateTime.now().add(
                                                      const Duration(days: 30)),
                                              firstDate: selectedDate.value,
                                              lastDate: DateTime(2030),
                                            );
                                            recurringEndDate.value = pickedDate;
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            elevation: 0,
                                          ),
                                          child: Text(
                                              recurringEndDate.value != null
                                                  ? '変更'
                                                  : '設定'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 管理方法セクション
                          _buildSectionTitle(context, '管理方法'),
                          _SectionCard(
                            padding: 16,
                            child: SizedBox(
                              height: 120,
                              child: GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 4,
                                childAspectRatio: 2.5,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildManageTypeCard(
                                    context,
                                    ManageType.normal,
                                    '通常',
                                    Icons.task_alt,
                                    Theme.of(context).colorScheme.primary,
                                    manageType.value,
                                    (type) => manageType.value = type,
                                  ),
                                  _buildManageTypeCard(
                                    context,
                                    ManageType.pomodoro,
                                    'ポモドーロ',
                                    Icons.timer,
                                    Theme.of(context).colorScheme.accentColor,
                                    manageType.value,
                                    (type) => manageType.value = type,
                                  ),
                                  _buildManageTypeCard(
                                    context,
                                    ManageType.countup,
                                    'カウントアップ',
                                    Icons.timer_outlined,
                                    Theme.of(context).colorScheme.warningColor,
                                    manageType.value,
                                    (type) => manageType.value = type,
                                  ),
                                  _buildManageTypeCard(
                                    context,
                                    ManageType.checklist,
                                    'チェックリスト',
                                    Icons.checklist,
                                    Theme.of(context).colorScheme.successColor,
                                    manageType.value,
                                    (type) => manageType.value = type,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // ポモドーロタイマーUI
                          if (manageType.value == ManageType.pomodoro) ...[
                            _buildSectionTitle(context, 'ポモドーロタイマー'),
                            _SectionCard(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.timer,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .accentColor,
                                          size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'ポモドーロタイマーで管理します',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryTextColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // 詳細設定
                                  _buildPomodoroSetting(
                                    context,
                                    '作業時間(min)',
                                    pomodoroWorkMinutes,
                                    Icons.work_rounded,
                                    Theme.of(context).colorScheme.accentColor,
                                    '',
                                    1,
                                    60,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPomodoroSetting(
                                    context,
                                    '短い休憩(min)',
                                    pomodoroShortBreakMinutes,
                                    Icons.coffee_rounded,
                                    Theme.of(context).colorScheme.infoColor,
                                    '',
                                    1,
                                    30,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPomodoroSetting(
                                    context,
                                    '長い休憩(min)',
                                    pomodoroLongBreakMinutes,
                                    Icons.spa_rounded,
                                    Theme.of(context).colorScheme.purpleColor,
                                    '',
                                    1,
                                    60,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPomodoroSetting(
                                    context,
                                    '長い休憩までのサイクル',
                                    pomodoroCycle,
                                    Icons.repeat_rounded,
                                    Theme.of(context).colorScheme.successColor,
                                    '',
                                    2,
                                    10,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPomodoroSetting(
                                    context,
                                    '完了セット数',
                                    pomodoroCompletionCycles,
                                    Icons.flag_rounded,
                                    Theme.of(context).colorScheme.primary,
                                    '',
                                    1,
                                    20,
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .accentColor
                                          .withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.info_outline,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .accentColor,
                                                size: 16),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '設定したセット数に達するとタスクが自動完了になります',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondaryTextColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // カウントアップタイマーUI
                          if (manageType.value == ManageType.countup) ...[
                            _buildSectionTitle(context, 'カウントアップタイマー'),
                            _SectionCard(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.timer_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .warningColor,
                                          size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'カウントアップタイマーで管理します',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryTextColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // 目標時間設定
                                  _buildCountupSetting(
                                    context,
                                    '目標時間（任意）',
                                    countupTargetMinutes,
                                    Icons.flag_rounded,
                                    Theme.of(context).colorScheme.warningColor,
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .warningColor
                                          .withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.info_outline,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .warningColor,
                                                size: 16),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '開始から経過時間を計測します\nタイマー停止時に自動でタスクが完了になります',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondaryTextColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          // チェックリストUI
                          if (manageType.value == ManageType.checklist) ...[
                            _buildSectionTitle(context, 'チェックリスト'),
                            _SectionCard(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.checklist,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                                  order: checklistItems
                                                      .value.length,
                                                ),
                                              ];
                                              checklistInputController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.add_circle_outline),
                                        onPressed: () {
                                          final value = checklistInputController
                                              .text
                                              .trim();
                                          if (value.isNotEmpty) {
                                            checklistItems.value = [
                                              ...checklistItems.value,
                                              TodoCheckListItemModel(
                                                id: DateTime.now()
                                                    .millisecondsSinceEpoch,
                                                todoId: initialTodo?.id ?? -1,
                                                title: value,
                                                isCompleted: false,
                                                order:
                                                    checklistItems.value.length,
                                              ),
                                            ];
                                            checklistInputController.clear();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...checklistItems.value.map((item) =>
                                      ListTile(
                                        title: Text(item.title),
                                        trailing: IconButton(
                                          icon:
                                              const Icon(Icons.delete_outline),
                                          onPressed: () {
                                            checklistItems.value =
                                                checklistItems.value
                                                    .where(
                                                        (e) => e.id != item.id)
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
                          _buildSectionTitle(context, 'カテゴリ'),
                          _SectionCard(
                            child: GestureDetector(
                              onTap: () async {
                                final result =
                                    await CategorySelectionDialog.show(
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
                                    color:
                                        Theme.of(context).colorScheme.outline,
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
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            selectedCategory.value?.title ??
                                                'カテゴリを選択',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  selectedCategory.value != null
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primaryTextColor
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .secondaryTextColor,
                                            ),
                                          ),
                                          if (selectedCategory
                                                      .value?.description !=
                                                  null &&
                                              selectedCategory.value!
                                                  .description!.isNotEmpty)
                                            Text(
                                              selectedCategory
                                                  .value!.description!,
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
                        ],
                      ),
                    ),
                  ),
                  // 固定ボタンエリア
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: SizedBox(
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
                          // タイマータイプを設定
                          final TimerType selectedTimerType;
                          if (manageType.value == ManageType.pomodoro) {
                            selectedTimerType = TimerType.pomodoro;
                          } else if (manageType.value == ManageType.countup) {
                            selectedTimerType = TimerType.countup;
                          } else {
                            selectedTimerType = TimerType.none;
                          }

                          final descriptionText =
                              descriptionController.text.trim();
                          if (initialTodo != null) {
                            // Update existing todo
                            await TodoService().updateTodo(
                              initialTodo!.id,
                              title: titleController.text.trim(),
                              description: descriptionText.isEmpty
                                  ? null
                                  : descriptionText,
                              dueDate: dueDate,
                              color: selectedCategory.value?.color ??
                                  selectedColor.value,
                              categoryId: selectedCategory.value?.id,
                              isRecurring: isRecurring.value,
                              recurringType: isRecurring.value
                                  ? recurringType.value
                                  : null,
                              recurringEndDate: isRecurring.value
                                  ? recurringEndDate.value
                                  : null,
                              timerType: selectedTimerType,
                              // ポモドーロ設定を保存
                              pomodoroWorkMinutes:
                                  selectedTimerType == TimerType.pomodoro
                                      ? pomodoroWorkMinutes.value
                                      : null,
                              pomodoroShortBreakMinutes:
                                  selectedTimerType == TimerType.pomodoro
                                      ? pomodoroShortBreakMinutes.value
                                      : null,
                              pomodoroLongBreakMinutes:
                                  selectedTimerType == TimerType.pomodoro
                                      ? pomodoroLongBreakMinutes.value
                                      : null,
                              pomodoroCycle:
                                  selectedTimerType == TimerType.pomodoro
                                      ? pomodoroCycle.value
                                      : null,
                              pomodoroCompletedCycle:
                                  selectedTimerType == TimerType.pomodoro
                                      ? pomodoroCompletionCycles.value
                                      : null,
                              // カウントアップ設定を保存（目標時間を秒で保存）
                              countupElapsedSeconds:
                                  selectedTimerType == TimerType.countup &&
                                          countupTargetMinutes.value != null
                                      ? countupTargetMinutes.value! * 60
                                      : null,
                            );
                            // Update checklist items for existing todo
                            final checklistService = TodoCheckListItemService();
                            await checklistService
                                .deleteAllCheckListItemsForTodo(
                                    initialTodo!.id);
                            for (int i = 0;
                                i < checklistItems.value.length;
                                i++) {
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
                              description: descriptionText.isEmpty
                                  ? null
                                  : descriptionText,
                              dueDate: dueDate,
                              color: selectedCategory.value?.color ??
                                  selectedColor.value,
                              categoryId: selectedCategory.value?.id,
                              isRecurring: isRecurring.value,
                              recurringType: isRecurring.value
                                  ? recurringType.value
                                  : null,
                              recurringEndDate: isRecurring.value
                                  ? recurringEndDate.value
                                  : null,
                              timerType: selectedTimerType,
                              // ポモドーロ設定を保存
                              pomodoroWorkMinutes:
                                  selectedTimerType == TimerType.pomodoro
                                      ? pomodoroWorkMinutes.value
                                      : null,
                              pomodoroShortBreakMinutes:
                                  selectedTimerType == TimerType.pomodoro
                                      ? pomodoroShortBreakMinutes.value
                                      : null,
                              pomodoroLongBreakMinutes:
                                  selectedTimerType == TimerType.pomodoro
                                      ? pomodoroLongBreakMinutes.value
                                      : null,
                              pomodoroCycle:
                                  selectedTimerType == TimerType.pomodoro
                                      ? pomodoroCycle.value
                                      : null,
                              pomodoroCompletedCycle:
                                  selectedTimerType == TimerType.pomodoro
                                      ? pomodoroCompletionCycles.value
                                      : null,
                              // カウントアップ設定を保存（目標時間を秒で保存）
                              countupElapsedSeconds:
                                  selectedTimerType == TimerType.countup &&
                                          countupTargetMinutes.value != null
                                      ? countupTargetMinutes.value! * 60
                                      : null,
                            );
                            // Create checklist items for new todo
                            final checklistService = TodoCheckListItemService();
                            for (int i = 0;
                                i < checklistItems.value.length;
                                i++) {
                              final item = checklistItems.value[i];
                              await checklistService.createCheckListItem(
                                todoId: newTodo.id,
                                title: item.title,
                                order: i,
                              );
                            }

                            // スケジュール通知を設定
                            await ref
                                .read(notificationStateProvider.notifier)
                                .handleTodoCreated(newTodo);
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
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.surface,
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
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}

Widget _buildPomodoroSetting(
  BuildContext context,
  String title,
  ValueNotifier<int> valueNotifier,
  IconData icon,
  Color color,
  String unit,
  int min,
  int max,
) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
        Row(
          children: [
            _buildCounterButton(
              context,
              Icons.remove,
              () {
                if (valueNotifier.value > min) {
                  valueNotifier.value =
                      valueNotifier.value - (title.contains('min') ? 5 : 1);
                  if (valueNotifier.value < min) valueNotifier.value = min;
                }
              },
              color,
              valueNotifier.value > min,
            ),
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                '${valueNotifier.value}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _buildCounterButton(
              context,
              Icons.add,
              () {
                if (valueNotifier.value < max) {
                  valueNotifier.value =
                      valueNotifier.value + (title.contains('min') ? 5 : 1);
                  if (valueNotifier.value > max) valueNotifier.value = max;
                }
              },
              color,
              valueNotifier.value < max,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildCountupSetting(
  BuildContext context,
  String title,
  ValueNotifier<int?> valueNotifier,
  IconData icon,
  Color color,
) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Switch(
              value: valueNotifier.value != null,
              onChanged: (value) {
                if (value) {
                  valueNotifier.value = 30; // デフォルト30分
                } else {
                  valueNotifier.value = null;
                }
              },
              activeColor: color,
            ),
          ],
        ),
        if (valueNotifier.value != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Row(
                  children: [
                    _buildCounterButton(
                      context,
                      Icons.remove,
                      () {
                        if (valueNotifier.value! > 5) {
                          valueNotifier.value = valueNotifier.value! - 5;
                        }
                      },
                      color,
                      valueNotifier.value! > 5,
                    ),
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        '${valueNotifier.value}分',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _buildCounterButton(
                      context,
                      Icons.add,
                      () {
                        if (valueNotifier.value! < 300) {
                          valueNotifier.value = valueNotifier.value! + 5;
                        }
                      },
                      color,
                      valueNotifier.value! < 300,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

Widget _buildCounterButton(
  BuildContext context,
  IconData icon,
  VoidCallback onPressed,
  Color color,
  bool enabled,
) {
  return Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: enabled
          ? color.withValues(alpha: 0.1)
          : Colors.grey.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: enabled
            ? color.withValues(alpha: 0.3)
            : Colors.grey.withValues(alpha: 0.3),
      ),
    ),
    child: IconButton(
      onPressed: enabled ? onPressed : null,
      padding: EdgeInsets.zero,
      icon: Icon(
        icon,
        color: enabled ? color : Colors.grey,
        size: 16,
      ),
    ),
  );
}

Widget _buildManageTypeCard(
  BuildContext context,
  ManageType type,
  String title,
  IconData icon,
  Color color,
  ManageType selectedType,
  Function(ManageType) onTap,
) {
  final isSelected = selectedType == type;
  return GestureDetector(
    onTap: () => onTap(type),
    child: Container(
      decoration: BoxDecoration(
        color: isSelected
            ? color.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? color
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? color
                : Theme.of(context).colorScheme.secondaryTextColor,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? color
                  : Theme.of(context).colorScheme.secondaryTextColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSectionTitle(BuildContext context, String title) => Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
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
