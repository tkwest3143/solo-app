import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/services/timer_service.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/screen/widgets/timer_widgets.dart';

class TimerPage extends HookConsumerWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSession = ref.watch(timerServiceProvider);
    final showSettings = useState(false);

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
                onClose: () => showSettings.value = false,
              )
            : TimerMainWidget(
                onOpenSettings: () => showSettings.value = true,
              ),
      ),
    );
  }
}

class TimerMainWidget extends HookConsumerWidget {
  final VoidCallback onOpenSettings;

  const TimerMainWidget({
    super.key,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSession = ref.watch(timerServiceProvider);
    final timerService = ref.read(timerServiceProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header with mode switch and settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Mode Switch
              TimerModeSwitch(),
              // Settings Button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                  ),
                  onPressed: onOpenSettings,
                ),
              ),
            ],
          ),

          // Timer Display Section
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Phase indicator for Pomodoro
                  if (timerSession.mode == TimerMode.pomodoro) ...[
                    PomodoroPhaseIndicator(),
                    const SizedBox(height: 20),
                  ],

                  // Main timer circle
                  TimerCircle(),

                  const SizedBox(height: 40),

                  // Timer controls
                  TimerControls(),

                  if (timerSession.mode == TimerMode.pomodoro) ...[
                    const SizedBox(height: 24),
                    PomodoroProgressInfo(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
