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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Theme.of(context).colorScheme.backgroundGradient,
        ),
      ),
      child: SafeArea(
        child: showSettings.value
            ? TimerSettingsWidget(
                timerController: timerController.value,
                onClose: () => showSettings.value = false,
              )
            : TimerMainWidget(
                timerController: timerController.value,
                onOpenSettings: () => showSettings.value = true,
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header with mode switch and settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Mode Switch
              TimerModeSwitch(timerController: timerController),
              // Settings Button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.1),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.settings_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: onOpenSettings,
                ),
              ),
            ],
          ),

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
                        // Phase indicator for Pomodoro
                        if (timerSession.mode == TimerMode.pomodoro) ...[
                          PomodoroPhaseIndicator(timerSession: timerSession),
                          const SizedBox(height: 20),
                        ],

                        // Main timer circle
                        TimerCircle(timerSession: timerSession),

                        const SizedBox(height: 40),

                        // Timer controls
                        TimerControls(timerController: timerController),

                        if (timerSession.mode == TimerMode.pomodoro) ...[
                          const SizedBox(height: 24),
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
