import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/screen/states/timer_state.dart';
import 'package:solo/screen/widgets/timer/timer_main.dart';
import 'package:solo/screen/widgets/timer/timer_settings.dart';

class TimerPage extends HookConsumerWidget {
  final String? todoId;
  final String? mode;
  
  const TimerPage({
    super.key,
    this.todoId,
    this.mode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSession = ref.watch(timerStateProvider);
    final timerController = ref.read(timerStateProvider.notifier);
    final showSettings = ValueNotifier(false);

    // Handle URL parameters when page loads
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Todo IDが指定されている場合は優先的に処理（設定も自動適用される）
        if (todoId != null) {
          final todoIdInt = int.tryParse(todoId!);
          if (todoIdInt != null) {
            timerController.selectTodo(todoIdInt);
            return; // Todo設定が自動適用されるので、mode設定はスキップ
          }
        }
        
        // Todo IDが指定されていない場合のみ、手動でモード設定
        if (mode != null) {
          final timerMode = mode == 'pomodoro' ? TimerMode.pomodoro : TimerMode.countUp;
          if (timerSession.mode != timerMode) {
            timerController.switchMode(timerMode);
          }
        }
      });
      return null;
    }, [todoId, mode]);

    // Only allow settings for Pomodoro mode
    void openSettings() {
      if (timerSession.mode == TimerMode.pomodoro) {
        showSettings.value = true;
      }
    }

    return ValueListenableBuilder<bool>(
      valueListenable: showSettings,
      builder: (context, show, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: Theme.of(context).colorScheme.backgroundGradient,
            ),
          ),
          child: SafeArea(
            child: show && timerSession.mode == TimerMode.pomodoro
                ? TimerSettingsWidget(
                    onClose: () => showSettings.value = false,
                  )
                : TimerMainWidget(
                    timerSession: timerSession,
                    timerController: timerController,
                    onOpenSettings: openSettings,
                  ),
          ),
        );
      },
    );
  }
}

