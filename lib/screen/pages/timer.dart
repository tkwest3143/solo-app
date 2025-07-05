import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/screen/states/timer_state.dart';
import 'package:solo/screen/widgets/timer_widgets.dart';

class TimerPage extends HookWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final timerController = useState(TimerStateController());
    final showSettings = useState(false);

    useEffect(() {
      return timerController.value.dispose;
    }, []);

    // Only allow settings for Pomodoro mode
    void openSettings() {
      if (timerController.value.session.mode == TimerMode.pomodoro) {
        showSettings.value = true;
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Theme.of(context).colorScheme.backgroundGradient,
        ),
      ),
      child: SafeArea(
        child: showSettings.value && 
               timerController.value.session.mode == TimerMode.pomodoro
            ? TimerSettingsWidget(
                timerController: timerController.value,
                onClose: () => showSettings.value = false,
              )
            : TimerMainWidget(
                timerController: timerController.value,
                onOpenSettings: openSettings,
              ),
      ),
    );
  }
}

class TimerMainWidget extends HookWidget {
  final TimerStateController timerController;
  final VoidCallback onOpenSettings;

  const TimerMainWidget({
    super.key,
    required this.timerController,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    useListenable(timerController);
    final timerSession = timerController.session;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // Elegant header with centered mode switch
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: TimerModeSwitch(timerController: timerController),
            ),
          ),

          const SizedBox(height: 32),

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
                        // Phase indicator for Pomodoro with enhanced styling
                        if (timerSession.mode == TimerMode.pomodoro) ...[
                          PomodoroPhaseIndicator(timerSession: timerSession),
                          const SizedBox(height: 32),
                        ],

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

                        const SizedBox(height: 48),

                        // Timer controls
                        TimerControls(timerController: timerController),

                        if (timerSession.mode == TimerMode.pomodoro) ...[
                          const SizedBox(height: 32),
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
