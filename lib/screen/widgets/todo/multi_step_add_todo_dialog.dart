import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/models/category_model.dart';
import 'package:solo/models/todo_checklist_item_model.dart';
import 'package:solo/screen/widgets/todo/category_selection_dialog.dart';
import 'package:solo/screen/widgets/todo/custom_time_picker.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/services/todo_checklist_item_service.dart';
import 'package:solo/utilities/date.dart';
import 'package:solo/enums/todo_color.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:solo/screen/states/notification_state.dart';
import 'package:solo/utilities/input_validation.dart';

enum ManageType { normal, pomodoro, countup, checklist }

enum DialogStep { title, repeatAndDate, management, categoryAndDetails }

// ポモドーロタイマーのデフォルト値定数
class _PomodoroDefaults {
  static const int workMinutes = 25;
  static const int shortBreakMinutes = 5;
  static const int longBreakMinutes = 15;
  static const int cycles = 4;
  static const int completedCycles = 2;
}

// UI関連の定数
class _UIConstants {
  static const double managementGridHeight = 140.0;
  static const double gridCrossAxisSpacing = 8.0;
  static const double gridMainAxisSpacing = 4.0;
  static const double gridAspectRatio = 2.5;
  static const int gridCrossAxisCount = 2;
}

class MultiStepAddTodoDialog {
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
      builder: (context) => _MultiStepAddTodoDialogContent(
        initialDate: initialDate,
        initialTodo: initialTodo,
        onSaved: onSaved,
      ),
    );
  }
}

class _MultiStepAddTodoDialogContent extends HookConsumerWidget {
  final DateTime? initialDate;
  final TodoModel? initialTodo;
  final VoidCallback? onSaved;

  const _MultiStepAddTodoDialogContent({
    this.initialDate,
    this.initialTodo,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State management for dialog steps
    final currentStep = useState<DialogStep>(DialogStep.title);

    // Form data state
    final titleController =
        useTextEditingController(text: initialTodo?.title ?? '');
    final descriptionController =
        useTextEditingController(text: initialTodo?.description ?? '');

    final selectedDate = useState<DateTime>(
      initialDate ?? initialTodo?.dueDate ?? DateTime.now(),
    );
    final selectedTime = useState<TimeOfDay>(
      // 30分単位で切り上げ
      (() {
        final date = initialTodo?.dueDate ?? DateTime.now();
        if (initialTodo?.dueDate != null) {
          // 既存のdueDateがある場合はそのまま
          return TimeOfDay(hour: date.hour, minute: date.minute);
        }
        int hour = date.hour;
        int minute = date.minute;
        if (minute == 0) {
          // ちょうど00分ならそのまま
          return TimeOfDay(hour: hour, minute: 0);
        } else if (minute <= 30) {
          // 1〜30分なら30分に
          return TimeOfDay(hour: hour, minute: 30);
        } else {
          // 31分以降は次の時間の00分
          hour = (hour + 1) % 24;
          return TimeOfDay(hour: hour, minute: 0);
        }
      })(),
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
    final pomodoroWorkMinutes = useState<int>(_PomodoroDefaults.workMinutes);
    final pomodoroShortBreakMinutes =
        useState<int>(_PomodoroDefaults.shortBreakMinutes);
    final pomodoroLongBreakMinutes =
        useState<int>(_PomodoroDefaults.longBreakMinutes);
    final pomodoroCycle = useState<int>(_PomodoroDefaults.cycles);
    final pomodoroCompletionCycles =
        useState<int>(_PomodoroDefaults.completedCycles);

    // カウントアップタイマー設定
    final countupTargetMinutes = useState<int?>(null);

    // 管理方法の選択肢
    final manageType = useState<ManageType>(ManageType.normal);

    // 初期値設定（編集モードの場合は既存のtimerTypeから設定）
    useEffect(() {
      if (initialTodo != null) {
        // 編集モードの場合、既存のtimerTypeに基づいてmanageTypeを設定
        switch (initialTodo?.timerType) {
          case TimerType.none:
            // チェックリストアイテムの存在確認（null安全性を考慮）
            final hasChecklistItems = initialTodo?.checklistItem != null &&
                initialTodo!.checklistItem.isNotEmpty;
            if (hasChecklistItems) {
              manageType.value = ManageType.checklist;
              checklistItems.value = initialTodo?.checklistItem ?? [];
              checklistEnabled.value = true;
            } else {
              manageType.value = ManageType.normal;
            }
            break;
          case TimerType.pomodoro:
            manageType.value = ManageType.pomodoro;
            isPomodoro.value = true;
            // ポモドーロ設定を復元
            pomodoroWorkMinutes.value = initialTodo?.pomodoroWorkMinutes ??
                _PomodoroDefaults.workMinutes;
            pomodoroShortBreakMinutes.value =
                initialTodo?.pomodoroShortBreakMinutes ??
                    _PomodoroDefaults.shortBreakMinutes;
            pomodoroLongBreakMinutes.value =
                initialTodo?.pomodoroLongBreakMinutes ??
                    _PomodoroDefaults.longBreakMinutes;
            pomodoroCycle.value =
                initialTodo?.pomodoroCycle ?? _PomodoroDefaults.cycles;
            pomodoroCompletionCycles.value =
                initialTodo?.pomodoroCompletedCycle ??
                    _PomodoroDefaults.completedCycles;
            break;
          case TimerType.countup:
            manageType.value = ManageType.countup;
            // カウントアップ設定を復元（秒を分に変換）
            final countupTargetSeconds = initialTodo?.countupElapsedSeconds;
            if (countupTargetSeconds != null) {
              countupTargetMinutes.value = (countupTargetSeconds / 60).round();
            }
            break;
          default:
            manageType.value = ManageType.normal;
        }
      }
      return null;
    }, [initialTodo?.id, initialTodo?.timerType, initialTodo?.checklistItem]);
    // バリデーションエラー状態
    final titleError = useState<String?>(null);
    final descriptionError = useState<String?>(null);
    final checklistItemError = useState<String?>(null);

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
            _buildHeader(context, currentStep.value),

            // 動的コンテンツ
            Expanded(
              child: _buildStepContent(
                context,
                ref,
                currentStep,
                titleController,
                descriptionController,
                selectedDate,
                selectedTime,
                selectedColor,
                selectedCategory,
                isRecurring,
                recurringType,
                recurringEndDate,
                checklistItems,
                checklistEnabled,
                checklistInputController,
                isPomodoro,
                pomodoroWorkMinutes,
                pomodoroShortBreakMinutes,
                pomodoroLongBreakMinutes,
                pomodoroCycle,
                pomodoroCompletionCycles,
                countupTargetMinutes,
                manageType,
                titleError,
                descriptionError,
                checklistItemError,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DialogStep step) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            initialTodo != null ? Icons.edit : Icons.add_circle_rounded,
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
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<DialogStep> currentStep,
    TextEditingController titleController,
    TextEditingController descriptionController,
    ValueNotifier<DateTime> selectedDate,
    ValueNotifier<TimeOfDay> selectedTime,
    ValueNotifier<String> selectedColor,
    ValueNotifier<CategoryModel?> selectedCategory,
    ValueNotifier<bool> isRecurring,
    ValueNotifier<RecurringType?> recurringType,
    ValueNotifier<DateTime?> recurringEndDate,
    ValueNotifier<List<TodoCheckListItemModel>> checklistItems,
    ValueNotifier<bool> checklistEnabled,
    TextEditingController checklistInputController,
    ValueNotifier<bool> isPomodoro,
    ValueNotifier<int> pomodoroWorkMinutes,
    ValueNotifier<int> pomodoroShortBreakMinutes,
    ValueNotifier<int> pomodoroLongBreakMinutes,
    ValueNotifier<int> pomodoroCycle,
    ValueNotifier<int> pomodoroCompletionCycles,
    ValueNotifier<int?> countupTargetMinutes,
    ValueNotifier<ManageType> manageType,
    ValueNotifier<String?> titleError,
    ValueNotifier<String?> descriptionError,
    ValueNotifier<String?> checklistItemError,
  ) {
    switch (currentStep.value) {
      case DialogStep.title:
        return _buildTitleStep(
          context,
          titleController,
          titleError,
          () => _nextStep(context, currentStep, titleController),
        );
      case DialogStep.repeatAndDate:
        return _buildRepeatAndDateStep(
          context,
          selectedDate,
          selectedTime,
          isRecurring,
          recurringType,
          recurringEndDate,
          () => _nextStep(context, currentStep, titleController,
              isRecurring: isRecurring, recurringType: recurringType),
        );
      case DialogStep.management:
        return _buildManagementStep(
          context,
          ref,
          manageType,
          pomodoroWorkMinutes,
          pomodoroShortBreakMinutes,
          pomodoroLongBreakMinutes,
          pomodoroCycle,
          pomodoroCompletionCycles,
          countupTargetMinutes,
          checklistItems,
          checklistInputController,
          checklistItemError,
          () => _saveTodo(
              context,
              ref,
              titleController,
              descriptionController,
              selectedDate,
              selectedTime,
              selectedCategory,
              isRecurring,
              recurringType,
              recurringEndDate,
              manageType,
              pomodoroWorkMinutes,
              pomodoroShortBreakMinutes,
              pomodoroLongBreakMinutes,
              pomodoroCycle,
              pomodoroCompletionCycles,
              countupTargetMinutes,
              checklistItems),
          () => _nextStep(context, currentStep, titleController),
        );
      case DialogStep.categoryAndDetails:
        return _buildCategoryAndDetailsStep(
          context,
          ref,
          selectedCategory,
          descriptionController,
          descriptionError,
          () => _saveTodo(
              context,
              ref,
              titleController,
              descriptionController,
              selectedDate,
              selectedTime,
              selectedCategory,
              isRecurring,
              recurringType,
              recurringEndDate,
              manageType,
              pomodoroWorkMinutes,
              pomodoroShortBreakMinutes,
              pomodoroLongBreakMinutes,
              pomodoroCycle,
              pomodoroCompletionCycles,
              countupTargetMinutes,
              checklistItems),
        );
    }
  }

  Widget _buildTitleStep(
    BuildContext context,
    TextEditingController titleController,
    ValueNotifier<String?> titleError,
    VoidCallback onNext,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  'まずはタスクのタイトルを入力してください',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 24),
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleController,
                        autofocus: true,
                        style: const TextStyle(fontSize: 18),
                        maxLength: 30,
                        onChanged: (value) {
                          titleError.value =
                              InputValidation.validateTodoTitle(value);
                        },
                        decoration: InputDecoration(
                          labelText: 'タイトル *',
                          hintText: '例：プレゼン資料を作成する',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.05),
                          errorText: titleError.value,
                          counterText: '',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildBottomButton(
          context,
          '次へ',
          onNext,
          Icons.arrow_forward,
        ),
      ],
    );
  }

  Widget _buildRepeatAndDateStep(
    BuildContext context,
    ValueNotifier<DateTime> selectedDate,
    ValueNotifier<TimeOfDay> selectedTime,
    ValueNotifier<bool> isRecurring,
    ValueNotifier<RecurringType?> recurringType,
    ValueNotifier<DateTime?> recurringEndDate,
    VoidCallback onNext,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '繰り返しと日時を設定してください',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 24),

                // 繰り返し設定
                _buildSectionTitle(context, '繰り返し'),
                _SectionCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.repeat,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
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
                            onChanged: (initialTodo != null &&
                                    initialTodo!.isRecurring == true)
                                ? null // 繰り返しTodoの編集時は無効化
                                : (value) => isRecurring.value = value,
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                      if (isRecurring.value) ...[
                        const SizedBox(height: 16),
                        _buildRecurringTypeSelector(
                            context, recurringType, selectedDate,
                            isEditMode: initialTodo != null),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 日時設定
                _buildSectionTitle(context, isRecurring.value ? '開始日' : '期限'),
                _SectionCard(
                  child: Column(
                    children: [
                      _buildDateSelector(context, selectedDate,
                          isRecurring.value, recurringType,
                          isEditMode: initialTodo != null),
                      const SizedBox(height: 12),
                      _buildTimeSelector(context, selectedTime),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildBottomButton(
          context,
          '次へ',
          onNext,
          Icons.arrow_forward,
        ),
      ],
    );
  }

  Widget _buildManagementStep(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<ManageType> manageType,
    ValueNotifier<int> pomodoroWorkMinutes,
    ValueNotifier<int> pomodoroShortBreakMinutes,
    ValueNotifier<int> pomodoroLongBreakMinutes,
    ValueNotifier<int> pomodoroCycle,
    ValueNotifier<int> pomodoroCompletionCycles,
    ValueNotifier<int?> countupTargetMinutes,
    ValueNotifier<List<TodoCheckListItemModel>> checklistItems,
    TextEditingController checklistInputController,
    ValueNotifier<String?> checklistItemError,
    VoidCallback onAdd,
    VoidCallback onNext,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  initialTodo != null ? 'タスクの詳細設定を変更できます' : 'タスクの管理方法を選択してください',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                ),
                if (initialTodo != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '※ 管理方法（通常、ポモドーロ、カウントアップ、チェックリスト）は編集時に変更できません',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondaryTextColor,
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                _buildSectionTitle(context, '管理方法'),
                _SectionCard(
                  padding: 16,
                  child: SizedBox(
                    height: _UIConstants.managementGridHeight,
                    child: GridView.count(
                      crossAxisCount: _UIConstants.gridCrossAxisCount,
                      crossAxisSpacing: _UIConstants.gridCrossAxisSpacing,
                      mainAxisSpacing: _UIConstants.gridMainAxisSpacing,
                      childAspectRatio: _UIConstants.gridAspectRatio,
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
                          isEditMode: initialTodo != null,
                        ),
                        _buildManageTypeCard(
                          context,
                          ManageType.pomodoro,
                          'ポモドーロ',
                          Icons.timer,
                          Theme.of(context).colorScheme.accentColor,
                          manageType.value,
                          (type) => manageType.value = type,
                          isEditMode: initialTodo != null,
                        ),
                        _buildManageTypeCard(
                          context,
                          ManageType.countup,
                          'カウントアップ',
                          Icons.timer_outlined,
                          Theme.of(context).colorScheme.warningColor,
                          manageType.value,
                          (type) => manageType.value = type,
                          isEditMode: initialTodo != null,
                        ),
                        _buildManageTypeCard(
                          context,
                          ManageType.checklist,
                          'チェックリスト',
                          Icons.checklist,
                          Theme.of(context).colorScheme.successColor,
                          manageType.value,
                          (type) => manageType.value = type,
                          isEditMode: initialTodo != null,
                        ),
                      ],
                    ),
                  ),
                ),

                // 管理方法固有の設定UI
                if (manageType.value == ManageType.pomodoro) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'ポモドーロ設定'),
                  _SectionCard(
                    child: Column(
                      children: [
                        _buildTimerSettingRow(
                          context,
                          '作業時間',
                          pomodoroWorkMinutes.value,
                          (value) => pomodoroWorkMinutes.value = value,
                          min: 1,
                          max: 60,
                        ),
                        const SizedBox(height: 12),
                        _buildTimerSettingRow(
                          context,
                          '短い休憩',
                          pomodoroShortBreakMinutes.value,
                          (value) => pomodoroShortBreakMinutes.value = value,
                          min: 1,
                          max: 30,
                        ),
                        const SizedBox(height: 12),
                        _buildTimerSettingRow(
                          context,
                          '長い休憩',
                          pomodoroLongBreakMinutes.value,
                          (value) => pomodoroLongBreakMinutes.value = value,
                          min: 5,
                          max: 60,
                        ),
                        const SizedBox(height: 12),
                        _buildTimerSettingRow(
                          context,
                          'サイクル数',
                          pomodoroCycle.value,
                          (value) => pomodoroCycle.value = value,
                          min: 2,
                          max: 8,
                          suffix: '回',
                        ),
                        const SizedBox(height: 12),
                        _buildTimerSettingRow(
                          context,
                          '完了サイクル',
                          pomodoroCompletionCycles.value,
                          (value) => pomodoroCompletionCycles.value = value,
                          min: 1,
                          max: 10,
                          suffix: '回',
                        ),
                      ],
                    ),
                  ),
                ] else if (manageType.value == ManageType.countup) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'カウントアップ設定'),
                  _SectionCard(
                    child: Column(
                      children: [
                        _buildTimerSettingRow(
                          context,
                          '目標時間',
                          countupTargetMinutes.value ?? 0,
                          (value) => countupTargetMinutes.value =
                              value > 0 ? value : null,
                          min: 0,
                          max: 180,
                        ),
                        if (countupTargetMinutes.value != null &&
                            countupTargetMinutes.value! > 0) ...[
                          const SizedBox(height: 8),
                          Text(
                            '目標時間に達したら通知します',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryTextColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ] else if (manageType.value == ManageType.checklist) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'チェックリスト'),
                  _SectionCard(
                    child: Column(
                      children: [
                        // チェックリストアイテムの表示
                        if (checklistItems.value.isNotEmpty) ...[
                          ...checklistItems.value.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_box_outline_blank,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryTextColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .errorColor,
                                    ),
                                    onPressed: () {
                                      checklistItems.value =
                                          List.from(checklistItems.value)
                                            ..removeAt(index);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                          const Divider(),
                        ],
                        // 新しいアイテム追加フィールド
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: checklistInputController,
                                maxLength: 30,
                                onChanged: (value) {
                                  checklistItemError.value =
                                      InputValidation.validateChecklistItem(
                                          value);
                                },
                                decoration: InputDecoration(
                                  hintText: '新しいアイテムを追加',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  errorText: checklistItemError.value,
                                  counterText: '',
                                ),
                                onSubmitted: (value) {
                                  if (InputValidation.validateChecklistItem(
                                          value) ==
                                      null) {
                                    checklistItems.value = [
                                      ...checklistItems.value,
                                      TodoCheckListItemModel(
                                        id: 0,
                                        todoId: 0,
                                        title: value.trim(),
                                        isCompleted: false,
                                        order: checklistItems.value.length,
                                      ),
                                    ];
                                    checklistInputController.clear();
                                    checklistItemError.value = null;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                final value = checklistInputController.text;
                                if (InputValidation.validateChecklistItem(
                                        value) ==
                                    null) {
                                  checklistItems.value = [
                                    ...checklistItems.value,
                                    TodoCheckListItemModel(
                                      id: 0,
                                      todoId: 0,
                                      title: value.trim(),
                                      isCompleted: false,
                                      order: checklistItems.value.length,
                                    ),
                                  ];
                                  checklistInputController.clear();
                                  checklistItemError.value = null;
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        _buildDualBottomButtons(
          context,
          '追加',
          'カテゴリ、詳細の入力へ',
          onAdd,
          onNext,
        ),
      ],
    );
  }

  Widget _buildCategoryAndDetailsStep(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<CategoryModel?> selectedCategory,
    TextEditingController descriptionController,
    ValueNotifier<String?> descriptionError,
    VoidCallback onAdd,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'カテゴリと詳細を設定してください',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 24),

                // カテゴリ
                _buildSectionTitle(context, 'カテゴリ'),
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
                    child:
                        _buildCategorySelector(context, selectedCategory.value),
                  ),
                ),
                const SizedBox(height: 16),

                // 詳細
                _buildSectionTitle(context, '詳細'),
                _SectionCard(
                  child: TextField(
                    controller: descriptionController,
                    maxLength: 200,
                    onChanged: (value) {
                      descriptionError.value =
                          InputValidation.validateTodoDescription(value);
                    },
                    decoration: InputDecoration(
                      labelText: '詳細（オプション）',
                      hintText: '追加の説明やメモを入力...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.05),
                      errorText: descriptionError.value,
                      counterText: '',
                    ),
                    maxLines: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildBottomButton(
          context,
          '追加',
          onAdd,
          Icons.check,
        ),
      ],
    );
  }

  // ヘルパーメソッド
  void _nextStep(
    BuildContext context,
    ValueNotifier<DialogStep> currentStep,
    TextEditingController titleController, {
    ValueNotifier<bool>? isRecurring,
    ValueNotifier<RecurringType?>? recurringType,
  }) {
    switch (currentStep.value) {
      case DialogStep.title:
        if (titleController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('タイトルを入力してください')),
          );
          return;
        }
        currentStep.value = DialogStep.repeatAndDate;
        break;
      case DialogStep.repeatAndDate:
        if (isRecurring?.value == true && recurringType?.value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('繰り返しタイプを選択してください')),
          );
          return;
        }
        currentStep.value = DialogStep.management;
        break;
      case DialogStep.management:
        currentStep.value = DialogStep.categoryAndDetails;
        break;
      case DialogStep.categoryAndDetails:
        // Final step, should not happen
        break;
    }
  }

  Future<void> _saveTodo(
    BuildContext context,
    WidgetRef ref,
    TextEditingController titleController,
    TextEditingController descriptionController,
    ValueNotifier<DateTime> selectedDate,
    ValueNotifier<TimeOfDay> selectedTime,
    ValueNotifier<CategoryModel?> selectedCategory,
    ValueNotifier<bool> isRecurring,
    ValueNotifier<RecurringType?> recurringType,
    ValueNotifier<DateTime?> recurringEndDate,
    ValueNotifier<ManageType> manageType,
    ValueNotifier<int> pomodoroWorkMinutes,
    ValueNotifier<int> pomodoroShortBreakMinutes,
    ValueNotifier<int> pomodoroLongBreakMinutes,
    ValueNotifier<int> pomodoroCycle,
    ValueNotifier<int> pomodoroCompletionCycles,
    ValueNotifier<int?> countupTargetMinutes,
    ValueNotifier<List<TodoCheckListItemModel>> checklistItems,
  ) async {
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

    final descriptionText = descriptionController.text.trim();

    // Create new todo
    final newTodo = await TodoService().createTodo(
      title: titleController.text.trim(),
      description: descriptionText.isEmpty ? null : descriptionText,
      dueDate: dueDate,
      color: selectedCategory.value?.color ?? 'blue',
      categoryId: selectedCategory.value?.id,
      isRecurring: isRecurring.value,
      recurringType: isRecurring.value ? recurringType.value : null,
      recurringEndDate: isRecurring.value ? recurringEndDate.value : null,
      timerType: selectedTimerType,
      // ポモドーロ設定を保存
      pomodoroWorkMinutes: selectedTimerType == TimerType.pomodoro
          ? pomodoroWorkMinutes.value
          : null,
      pomodoroShortBreakMinutes: selectedTimerType == TimerType.pomodoro
          ? pomodoroShortBreakMinutes.value
          : null,
      pomodoroLongBreakMinutes: selectedTimerType == TimerType.pomodoro
          ? pomodoroLongBreakMinutes.value
          : null,
      pomodoroCycle:
          selectedTimerType == TimerType.pomodoro ? pomodoroCycle.value : null,
      pomodoroCompletedCycle: selectedTimerType == TimerType.pomodoro
          ? pomodoroCompletionCycles.value
          : null,
      // カウントアップ設定を保存
      countupElapsedSeconds: selectedTimerType == TimerType.countup &&
              countupTargetMinutes.value != null
          ? countupTargetMinutes.value! * 60
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

    // スケジュール通知を設定
    await ref
        .read(notificationStateProvider.notifier)
        .handleTodoCreated(newTodo);

    if (context.mounted) {
      Navigator.of(context).pop();
      onSaved?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todoを追加しました')),
      );
    }
  }

  // UI Helper Widgets
  Widget _buildBottomButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildDualBottomButtons(
    BuildContext context,
    String leftText,
    String rightText,
    VoidCallback onLeftPressed,
    VoidCallback onRightPressed,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onLeftPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                leftText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: onRightPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                rightText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Implementation for helper widgets
  Widget _buildRecurringTypeSelector(
      BuildContext context,
      ValueNotifier<RecurringType?> recurringType,
      ValueNotifier<DateTime> selectedDate,
      {bool isEditMode = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '繰り返しタイプ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.secondaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RecurringType?>(
              value: recurringType.value,
              isExpanded: true,
              hint: const Text('タイプを選択'),
              items: RecurringType.values.map((type) {
                return DropdownMenuItem<RecurringType>(
                  value: type,
                  child: Text(type.label),
                );
              }).toList(),
              onChanged: isEditMode
                  ? null // 繰り返しTodoの編集時は繰り返しタイプ変更を無効化
                  : (value) {
                      recurringType.value = value;

                      // 「毎月最終日」が選択された場合、現在の日付を最終日に変更
                      if (value == RecurringType.monthlyLast) {
                        final currentDate = selectedDate.value;
                        // 翌月の1日から1日引いて最終日を取得
                        final lastDayOfMonth = DateTime(
                            currentDate.year, currentDate.month + 1, 0);
                        selectedDate.value = lastDayOfMonth;
                      }
                    },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(
      BuildContext context,
      ValueNotifier<DateTime> selectedDate,
      bool isRecurring,
      ValueNotifier<RecurringType?> recurringType,
      {bool isEditMode = false}) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          color: Theme.of(context).colorScheme.primary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          '${isRecurring ? '開始日' : '期限'}: ${formatDate(selectedDate.value, format: 'yyyy/MM/dd (EEE)')}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondaryTextColor,
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: (isEditMode && isRecurring)
              ? null // 繰り返しTodoの編集時は日付変更を無効化
              : () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    selectableDayPredicate: recurringType.value ==
                            RecurringType.monthlyLast
                        ? (DateTime date) {
                            // 翌日の月が異なる場合、その日は月末日
                            final nextDay = date.add(const Duration(days: 1));
                            return date.month != nextDay.month;
                          }
                        : null,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
          ),
          child: const Text('日付を選択',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              )),
        ),
      ],
    );
  }

  Widget _buildTimeSelector(
      BuildContext context, ValueNotifier<TimeOfDay> selectedTime) {
    return Row(
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
            final pickedTime = await showCustomTimePicker(
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
          ),
          child: const Text(
            '時間を選択',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerSettingRow(
    BuildContext context,
    String label,
    int value,
    Function(int) onChanged, {
    int min = 1,
    int max = 60,
    String suffix = '分',
    int step = 5,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondaryTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$value$suffix',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .mediumShadowColor
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: value > min
                        ? () {
                            final newValue = value - step;
                            onChanged(newValue < min ? min : newValue);
                          }
                        : null,
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12)),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.remove,
                        size: 20,
                        color: value > min
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showTimeInputDialog(
                    context,
                    label,
                    value,
                    min,
                    max,
                    suffix,
                    onChanged,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      '$value',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: value < max
                        ? () {
                            final newValue = value + step;
                            onChanged(newValue > max ? max : newValue);
                          }
                        : null,
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(12)),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: value < max
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTimeInputDialog(
    BuildContext context,
    String label,
    int currentValue,
    int min,
    int max,
    String suffix,
    Function(int) onChanged,
  ) async {
    final textController = TextEditingController(text: currentValue.toString());

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                '$labelを設定',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$min〜$max$suffixの範囲で入力してください',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: textController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          autofocus: true,
                        ),
                      ),
                      Text(
                        suffix,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).colorScheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('キャンセル'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      final inputValue = int.tryParse(textController.text);
                      if (inputValue != null &&
                          inputValue >= min &&
                          inputValue <= max) {
                        onChanged(inputValue);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$min〜$max$suffixの範囲で入力してください'),
                            backgroundColor:
                                Theme.of(context).colorScheme.errorColor,
                          ),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('設定'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(
      BuildContext context, CategoryModel? selectedCategory) {
    return Container(
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
              color: selectedCategory != null
                  ? TodoColor.getColorFromString(selectedCategory.color)
                  : Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
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
                  selectedCategory?.title ?? 'カテゴリを選択',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: selectedCategory != null
                        ? Theme.of(context).colorScheme.primaryTextColor
                        : Theme.of(context).colorScheme.secondaryTextColor,
                  ),
                ),
                if (selectedCategory?.description?.isNotEmpty == true)
                  Text(
                    selectedCategory!.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondaryTextColor,
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Theme.of(context).colorScheme.secondaryTextColor,
          ),
        ],
      ),
    );
  }
}

// Helper widgets (borrowed from original implementation)
Widget _buildManageTypeCard(
  BuildContext context,
  ManageType type,
  String title,
  IconData icon,
  Color color,
  ManageType selectedType,
  Function(ManageType) onTap, {
  bool isEditMode = false,
}) {
  final isSelected = selectedType == type;
  // 編集モード時はタイマータイプの変更を無効化
  final isDisabled = isEditMode;

  final cardWidget = GestureDetector(
    onTap: isDisabled ? null : () => onTap(type),
    child: Container(
      decoration: BoxDecoration(
        color: isSelected
            ? color.withValues(alpha: 0.1)
            : isDisabled
                ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.3)
                : Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? color
              : isDisabled
                  ? Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)
                  : Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
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
                : isDisabled
                    ? Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.5)
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
                  : isDisabled
                      ? Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.5)
                      : Theme.of(context).colorScheme.secondaryTextColor,
            ),
          ),
        ],
      ),
    ),
  );

  // 編集モード時は説明用のツールチップを表示
  return isDisabled
      ? Tooltip(
          message: '編集モードでは管理方法を変更できません',
          child: cardWidget,
        )
      : cardWidget;
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
