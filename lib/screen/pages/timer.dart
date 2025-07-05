import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/screen/states/timer_state.dart';
import 'package:solo/screen/widgets/timer_widgets.dart';

class TimerPage extends ConsumerWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSession = ref.watch(timerStateProvider);
    final timerController = ref.read(timerStateProvider.notifier);
    final showSettings = ValueNotifier(false);

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
                    timerController: timerController,
                    timerSession: timerSession,
                    onOpenSettings: openSettings,
                  ),
          ),
        );
      },
    );
  }
}

class TimerMainWidget extends StatelessWidget {
  final TimerState timerController;
  final TimerSession timerSession;
  final VoidCallback onOpenSettings;

  const TimerMainWidget({
    super.key,
    required this.timerController,
    required this.timerSession,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        children: [
          // Elegant header with centered mode switch
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: TimerModeSwitch(),
            ),
          ),

          const SizedBox(height: 12),

          // Timer Display Section
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Main timer circle with long press for settings
                        GestureDetector(
                          onLongPress: timerSession.mode == TimerMode.pomodoro
                              ? onOpenSettings
                              : null,
                          child: TimerCircle(
                            timerSession: timerSession,
                            onLongPress: timerSession.mode == TimerMode.pomodoro
                                ? onOpenSettings
                                : null,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Timer controls
                        TimerControls(),

                        if (timerSession.mode == TimerMode.pomodoro) ...[
                          const SizedBox(height: 12),
                          PomodoroProgressInfo(timerSession: timerSession),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
