import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:solo/screen/states/timer_state.dart';
import 'package:solo/screen/widgets/timer/timer_mode_switch.dart';
import 'package:solo/screen/widgets/timer/timer_circle.dart';
import 'package:solo/screen/widgets/timer/timer_controls.dart';
import 'package:solo/screen/widgets/timer/todo_selection_dialog.dart';
import 'package:solo/services/todo_service.dart';

class TimerMainWidget extends HookConsumerWidget {
  final TimerSession timerSession;
  final TimerState timerController;
  final VoidCallback onOpenSettings;

  const TimerMainWidget({
    super.key,
    required this.timerSession,
    required this.timerController,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTodo = useState<TodoModel?>(null);
    final hasShownTargetDialog = useState<bool>(false);

    void applyTodoSettingsToTimer(TodoModel todo) {
      if (todo.timerType == TimerType.pomodoro &&
          todo.pomodoroWorkMinutes != null &&
          todo.pomodoroShortBreakMinutes != null &&
          todo.pomodoroLongBreakMinutes != null &&
          todo.pomodoroCycle != null) {
        // ポモドーロ設定をタイマーに適用
        timerController.applyTodoSettings(
          workMinutes: todo.pomodoroWorkMinutes!,
          shortBreakMinutes: todo.pomodoroShortBreakMinutes!,
          longBreakMinutes: todo.pomodoroLongBreakMinutes!,
          cyclesUntilLongBreak: todo.pomodoroCycle!,
        );
      }
      // カウントアップの場合は特に設定適用の必要なし（目標時間は表示のみ）
    }

    useEffect(() {
      void loadSelectedTodo() async {
        if (timerSession.selectedTodoId != null) {
          final todos = await TodoService().getTodo();
          final foundTodo = todos.firstWhere(
            (todo) => todo.id == timerSession.selectedTodoId,
            orElse: () => TodoModel(
              id: -1,
              title: '',
              dueDate: DateTime.now(),
              isCompleted: false,
              color: 'blue',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isRecurring: false,
            ),
          );

          if (foundTodo.id == -1) {
            selectedTodo.value = null;
          } else {
            selectedTodo.value = foundTodo;
            // Todoの設定をタイマーに反映
            applyTodoSettingsToTimer(foundTodo);
          }
        } else {
          selectedTodo.value = null;
        }
      }

      loadSelectedTodo();
      return null;
    }, [timerSession.selectedTodoId]);

    // Show completion dialog when count-up timer reaches target and stops
    useEffect(() {
      void checkTargetReached() async {
        if (timerSession.mode == TimerMode.countUp &&
            selectedTodo.value != null &&
            selectedTodo.value!.countupElapsedSeconds != null &&
            timerSession.elapsedSeconds >=
                selectedTodo.value!.countupElapsedSeconds! &&
            timerSession.state == TimerStatus.idle &&
            !hasShownTargetDialog.value) {
          hasShownTargetDialog.value = true;

          // Show completion dialog
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('目標時間達成！'),
              content: Text(
                  '${selectedTodo.value!.title} の目標時間に達しました。\nタスクを完了済みにしますか？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('キャンセル'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('完了'),
                ),
              ],
            ),
          );

          if (confirmed == true) {
            await timerController.completeTodoIfSelected();
          }
        }
      }

      checkTargetReached();
      return null;
    }, [timerSession.elapsedSeconds, timerSession.state, selectedTodo.value]);

    useEffect(() {
      hasShownTargetDialog.value = false;
      return null;
    }, [timerSession.selectedTodoId, timerSession.state]);

    Future<void> selectTodo() async {
      final selectedId = await showTodoSelectionDialog(
        context,
        currentTodoId: timerSession.selectedTodoId,
        currentTimerMode: timerSession.mode,
      );

      if (selectedId != timerSession.selectedTodoId) {
        await timerController.selectTodo(selectedId);
      }
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: TimerModeSwitch(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: selectTodo,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.1),
                    Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.checklist_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedTodo.value != null
                              ? selectedTodo.value!.title
                              : 'タスクを選択',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: selectedTodo.value != null
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedTodo.value != null
                              ? 'タイマー完了時に自動でタスクを完了にします'
                              : 'タスクを選択してタイマーを開始',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Timer display
        Expanded(
          child: Center(
            child: TimerCircle(
              timerSession: timerSession,
              onLongPress: timerSession.mode == TimerMode.pomodoro
                  ? onOpenSettings
                  : null,
            ),
          ),
        ),

        // Timer controls
        const Padding(
          padding: EdgeInsets.only(bottom: 16), // マージンを減らす
          child: TimerControls(),
        ),

        // Pomodoro cycle information (コンパクト版) / Count-up target time
        if (timerSession.mode == TimerMode.pomodoro)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.1),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCompactCycleInfo(
                    context,
                    Icons.loop,
                    '現在: ${timerSession.currentCycle + 1}/${timerSession.settings.cyclesUntilLongBreak}',
                  ),
                  Container(
                    height: 20,
                    width: 1,
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                  ),
                  _buildCompactCycleInfo(
                    context,
                    Icons.check_circle_outline,
                    '完了: ${timerSession.completedCycles}',
                  ),
                ],
              ),
            ),
          ),

        // Count-up target time (カウントアップ目標時間)
        if (timerSession.mode == TimerMode.countUp)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.1),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCompactCycleInfo(
                    context,
                    Icons.flag_outlined,
                    selectedTodo.value != null &&
                            selectedTodo.value!.countupElapsedSeconds != null
                        ? '目標時間: ${(selectedTodo.value!.countupElapsedSeconds! / 60).round()}分'
                        : '目標時間: 未設定',
                  ),
                  if (selectedTodo.value != null &&
                      selectedTodo.value!.countupElapsedSeconds != null &&
                      timerSession.elapsedSeconds >=
                          selectedTodo.value!.countupElapsedSeconds!) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.successColor,
                      ),
                      child: Text(
                        '達成!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCompactCycleInfo(
    BuildContext context,
    IconData icon,
    String text,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
