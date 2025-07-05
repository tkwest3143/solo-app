import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/states/timer_state.dart';
import 'package:solo/models/timer_model.dart';

class TimerModeSwitch extends HookWidget {
  final TimerStateController timerController;

  const TimerModeSwitch({
    super.key,
    required this.timerController,
  });

  @override
  Widget build(BuildContext context) {
    useListenable(timerController);
    final timerSession = timerController.session;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeButton(
            title: 'ポモドーロ',
            isSelected: timerSession.mode == TimerMode.pomodoro,
            onTap: () => timerController.switchMode(TimerMode.pomodoro),
          ),
          const SizedBox(width: 4),
          _ModeButton(
            title: 'カウントアップ',
            isSelected: timerSession.mode == TimerMode.countUp,
            onTap: () => timerController.switchMode(TimerMode.countUp),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? Theme.of(context).colorScheme.surface.withOpacity(0.3)
              : Colors.transparent,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class PomodoroPhaseIndicator extends StatelessWidget {
  final TimerSession timerSession;

  const PomodoroPhaseIndicator({
    super.key,
    required this.timerSession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: timerSession.isWorkPhase
            ? Theme.of(context).colorScheme.accentColor.withOpacity(0.2)
            : Theme.of(context).colorScheme.infoColor.withOpacity(0.2),
        border: Border.all(
          color: timerSession.isWorkPhase
              ? Theme.of(context).colorScheme.accentColor.withOpacity(0.5)
              : Theme.of(context).colorScheme.infoColor.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            timerSession.isWorkPhase
                ? Icons.work_rounded
                : Icons.coffee_rounded,
            color: Theme.of(context).colorScheme.onSurface,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            timerSession.currentPhaseDisplayName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class TimerCircle extends StatelessWidget {
  final TimerSession timerSession;

  const TimerCircle({
    super.key,
    required this.timerSession,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 2,
              ),
            ),
          ),

          // Progress indicator for Pomodoro
          if (timerSession.mode == TimerMode.pomodoro)
            SizedBox(
              width: 280,
              height: 280,
              child: CircularProgressIndicator(
                value: timerSession.progress,
                strokeWidth: 8,
                backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  timerSession.isWorkPhase
                      ? Theme.of(context).colorScheme.accentColor
                      : Theme.of(context).colorScheme.infoColor,
                ),
              ),
            ),

          // Timer display
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timerSession.displayTime,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              if (timerSession.mode == TimerMode.countUp)
                Text(
                  '経過時間',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerControls extends HookWidget {
  final TimerStateController timerController;

  const TimerControls({
    super.key,
    required this.timerController,
  });

  @override
  Widget build(BuildContext context) {
    useListenable(timerController);
    final timerSession = timerController.session;
    
    final canStart = timerSession.state == TimerState.idle || timerSession.state == TimerState.paused;
    final canPause = timerSession.state == TimerState.running;
    final showSkip = timerSession.mode == TimerMode.pomodoro && 
                    (timerSession.state == TimerState.running || timerSession.state == TimerState.paused);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset button
        _ControlButton(
          icon: Icons.refresh_rounded,
          onTap: timerController.resetTimer,
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
        ),

        const SizedBox(width: 24),

        // Play/Pause button
        _ControlButton(
          icon: canStart ? Icons.play_arrow_rounded : Icons.pause_rounded,
          onTap: canStart ? timerController.startTimer : timerController.pauseTimer,
          backgroundColor: Theme.of(context).colorScheme.accentColor,
          size: 72,
          iconSize: 36,
        ),

        const SizedBox(width: 24),

        // Skip button (only for Pomodoro)
        if (showSkip)
          _ControlButton(
            icon: Icons.skip_next_rounded,
            onTap: timerController.skipPhase,
            backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
          )
        else
          const SizedBox(width: 56), // Maintain spacing
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double size;
  final double iconSize;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    this.size = 56,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurface,
          size: iconSize,
        ),
      ),
    );
  }
}

class PomodoroProgressInfo extends StatelessWidget {
  final TimerSession timerSession;

  const PomodoroProgressInfo({
    super.key,
    required this.timerSession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'セッション進捗',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ProgressItem(
                label: '現在サイクル',
                value:
                    '${timerSession.currentCycle + 1}/${timerSession.settings.cyclesUntilLongBreak}',
              ),
              _ProgressItem(
                label: '完了サイクル',
                value: '${timerSession.completedCycles}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProgressItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class TimerSettingsWidget extends HookWidget {
  final TimerStateController timerController;
  final VoidCallback onClose;

  const TimerSettingsWidget({
    super.key,
    required this.timerController,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    useListenable(timerController);
    final timerSettings = timerController.session.settings;

    final workMinutes = useState(timerSettings.workMinutes);
    final shortBreakMinutes = useState(timerSettings.shortBreakMinutes);
    final longBreakMinutes = useState(timerSettings.longBreakMinutes);
    final cyclesUntilLongBreak = useState(timerSettings.cyclesUntilLongBreak);

    void saveSettings() {
      final newSettings = TimerSettings(
        workMinutes: workMinutes.value,
        shortBreakMinutes: shortBreakMinutes.value,
        longBreakMinutes: longBreakMinutes.value,
        cyclesUntilLongBreak: cyclesUntilLongBreak.value,
      );
      timerController.updateSettings(newSettings);
      onClose();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'タイマー設定',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded, 
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: onClose,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Settings
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _SettingItem(
                    title: '作業時間',
                    subtitle: '集中して作業する時間',
                    value: workMinutes.value,
                    unit: '分',
                    onChanged: (value) => workMinutes.value = value,
                    min: 1,
                    max: 60,
                  ),
                  const SizedBox(height: 24),
                  _SettingItem(
                    title: '短い休憩',
                    subtitle: '作業の間の短い休憩時間',
                    value: shortBreakMinutes.value,
                    unit: '分',
                    onChanged: (value) => shortBreakMinutes.value = value,
                    min: 1,
                    max: 30,
                  ),
                  const SizedBox(height: 24),
                  _SettingItem(
                    title: '長い休憩',
                    subtitle: '複数サイクル後の長い休憩時間',
                    value: longBreakMinutes.value,
                    unit: '分',
                    onChanged: (value) => longBreakMinutes.value = value,
                    min: 1,
                    max: 60,
                  ),
                  const SizedBox(height: 24),
                  _SettingItem(
                    title: '長い休憩までのサイクル数',
                    subtitle: '何回の作業サイクル後に長い休憩をとるか',
                    value: cyclesUntilLongBreak.value,
                    unit: 'サイクル',
                    onChanged: (value) => cyclesUntilLongBreak.value = value,
                    min: 2,
                    max: 10,
                  ),
                ],
              ),
            ),
          ),

          // Save button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 24),
            child: ElevatedButton(
              onPressed: saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.accentColor,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '設定を保存',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final String unit;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: value > min ? () => onChanged(value - 1) : null,
                icon: Icon(
                  Icons.remove_rounded, 
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                ),
              ),
              Text(
                '$value $unit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                onPressed: value < max ? () => onChanged(value + 1) : null,
                icon: Icon(
                  Icons.add_rounded, 
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            timerSession.isWorkPhase
                ? Icons.work_rounded
                : Icons.coffee_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            timerSession.currentPhaseDisplayName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class TimerCircle extends HookConsumerWidget {
  const TimerCircle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSession = ref.watch(timerServiceProvider);

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
          ),

          // Progress indicator for Pomodoro
          if (timerSession.mode == TimerMode.pomodoro)
            SizedBox(
              width: 280,
              height: 280,
              child: CircularProgressIndicator(
                value: timerSession.progress,
                strokeWidth: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  timerSession.isWorkPhase
                      ? Theme.of(context).colorScheme.accentColor
                      : Theme.of(context).colorScheme.infoColor,
                ),
              ),
            ),

          // Timer display
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timerSession.displayTime,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              if (timerSession.mode == TimerMode.countUp)
                const Text(
                  '経過時間',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerControls extends HookConsumerWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canStart = ref.watch(canStartTimerProvider);
    final canPause = ref.watch(canPauseTimerProvider);
    final showSkip = ref.watch(showSkipButtonProvider);
    final timerService = ref.read(timerServiceProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset button
        _ControlButton(
          icon: Icons.refresh_rounded,
          onTap: timerService.resetTimer,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
        ),

        const SizedBox(width: 24),

        // Play/Pause button
        _ControlButton(
          icon: canStart ? Icons.play_arrow_rounded : Icons.pause_rounded,
          onTap: canStart ? timerService.startTimer : timerService.pauseTimer,
          backgroundColor: Theme.of(context).colorScheme.accentColor,
          size: 72,
          iconSize: 36,
        ),

        const SizedBox(width: 24),

        // Skip button (only for Pomodoro)
        if (showSkip)
          _ControlButton(
            icon: Icons.skip_next_rounded,
            onTap: timerService.skipPhase,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
          )
        else
          const SizedBox(width: 56), // Maintain spacing
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double size;
  final double iconSize;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    this.size = 56,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}

class PomodoroProgressInfo extends HookConsumerWidget {
  const PomodoroProgressInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSession = ref.watch(timerServiceProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'セッション進捗',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ProgressItem(
                label: '現在サイクル',
                value:
                    '${timerSession.currentCycle + 1}/${timerSession.settings.cyclesUntilLongBreak}',
              ),
              _ProgressItem(
                label: '完了サイクル',
                value: '${timerSession.completedCycles}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProgressItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class TimerSettingsWidget extends HookConsumerWidget {
  final VoidCallback onClose;

  const TimerSettingsWidget({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSettings = ref.watch(timerSettingsProvider);
    final timerService = ref.read(timerServiceProvider.notifier);

    final workMinutes = useState(timerSettings.workMinutes);
    final shortBreakMinutes = useState(timerSettings.shortBreakMinutes);
    final longBreakMinutes = useState(timerSettings.longBreakMinutes);
    final cyclesUntilLongBreak = useState(timerSettings.cyclesUntilLongBreak);

    void saveSettings() {
      final newSettings = TimerSettings(
        workMinutes: workMinutes.value,
        shortBreakMinutes: shortBreakMinutes.value,
        longBreakMinutes: longBreakMinutes.value,
        cyclesUntilLongBreak: cyclesUntilLongBreak.value,
      );
      timerService.updateSettings(newSettings);
      onClose();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'タイマー設定',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: onClose,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Settings
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _SettingItem(
                    title: '作業時間',
                    subtitle: '集中して作業する時間',
                    value: workMinutes.value,
                    unit: '分',
                    onChanged: (value) => workMinutes.value = value,
                    min: 1,
                    max: 60,
                  ),
                  const SizedBox(height: 24),
                  _SettingItem(
                    title: '短い休憩',
                    subtitle: '作業の間の短い休憩時間',
                    value: shortBreakMinutes.value,
                    unit: '分',
                    onChanged: (value) => shortBreakMinutes.value = value,
                    min: 1,
                    max: 30,
                  ),
                  const SizedBox(height: 24),
                  _SettingItem(
                    title: '長い休憩',
                    subtitle: '複数サイクル後の長い休憩時間',
                    value: longBreakMinutes.value,
                    unit: '分',
                    onChanged: (value) => longBreakMinutes.value = value,
                    min: 1,
                    max: 60,
                  ),
                  const SizedBox(height: 24),
                  _SettingItem(
                    title: '長い休憩までのサイクル数',
                    subtitle: '何回の作業サイクル後に長い休憩をとるか',
                    value: cyclesUntilLongBreak.value,
                    unit: 'サイクル',
                    onChanged: (value) => cyclesUntilLongBreak.value = value,
                    min: 2,
                    max: 10,
                  ),
                ],
              ),
            ),
          ),

          // Save button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 24),
            child: ElevatedButton(
              onPressed: saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '設定を保存',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final String unit;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: value > min ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove_rounded, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              Text(
                '$value $unit',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                onPressed: value < max ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
