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
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.2),
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeButton(
            title: 'ポモドーロ',
            isSelected: timerSession.mode == TimerMode.pomodoro,
            onTap: () => timerController.switchMode(TimerMode.pomodoro),
          ),
          const SizedBox(width: 6),
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.accentColor.withValues(alpha: 0.8),
                    Theme.of(context).colorScheme.accentColor.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .accentColor
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
    final phaseColor = timerSession.isWorkPhase
        ? Theme.of(context).colorScheme.accentColor
        : Theme.of(context).colorScheme.infoColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            phaseColor.withValues(alpha: 0.15),
            phaseColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: phaseColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: phaseColor.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: phaseColor.withValues(alpha: 0.2),
            ),
            child: Icon(
              timerSession.isWorkPhase
                  ? Icons.work_rounded
                  : Icons.coffee_rounded,
              color: phaseColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            timerSession.currentPhaseDisplayName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class TimerCircle extends StatelessWidget {
  final TimerSession timerSession;
  final VoidCallback? onLongPress;

  const TimerCircle({
    super.key,
    required this.timerSession,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 48,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle with elegant gradient
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
                ],
                stops: const [0.0, 1.0],
              ),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),

          // Inner circle for better depth
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context)
                  .colorScheme
                  .surface
                  .withValues(alpha: 0.3),
            ),
          ),

          // Progress indicator for Pomodoro
          if (timerSession.mode == TimerMode.pomodoro)
            SizedBox(
              width: 300,
              height: 300,
              child: CircularProgressIndicator(
                value: timerSession.progress,
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  timerSession.isWorkPhase
                      ? Theme.of(context).colorScheme.accentColor
                      : Theme.of(context).colorScheme.infoColor,
                ),
              ),
            ),

          // Timer display with enhanced typography
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timerSession.displayTime,
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  letterSpacing: -2,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              if (timerSession.mode == TimerMode.countUp)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.2),
                  ),
                  child: Text(
                    '経過時間',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (onLongPress != null && timerSession.mode == TimerMode.pomodoro)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context)
                        .colorScheme
                        .accentColor
                        .withValues(alpha: 0.1),
                  ),
                  child: Text(
                    '長押しで設定',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context)
                          .colorScheme
                          .accentColor
                          .withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          // Long press detection overlay
          if (onLongPress != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(160),
                  onLongPress: onLongPress,
                  child: Container(),
                ),
              ),
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

    final canStart = timerSession.state == TimerState.idle ||
        timerSession.state == TimerState.paused;
    final canPause = timerSession.state == TimerState.running;
    final showSkip = timerSession.mode == TimerMode.pomodoro &&
        (timerSession.state == TimerState.running ||
            timerSession.state == TimerState.paused);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset button
          _ControlButton(
            icon: Icons.refresh_rounded,
            onTap: timerController.resetTimer,
            backgroundColor:
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
            size: 64,
            iconSize: 28,
          ),

          const SizedBox(width: 32),

          // Play/Pause button - larger and more prominent
          _ControlButton(
            icon: canStart ? Icons.play_arrow_rounded : Icons.pause_rounded,
            onTap: canStart
                ? timerController.startTimer
                : timerController.pauseTimer,
            backgroundColor: Theme.of(context).colorScheme.accentColor,
            size: 80,
            iconSize: 40,
            isPrimary: true,
          ),

          const SizedBox(width: 32),

          // Skip button (only for Pomodoro)
          if (showSkip)
            _ControlButton(
              icon: Icons.skip_next_rounded,
              onTap: timerController.skipPhase,
              backgroundColor:
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
              size: 64,
              iconSize: 28,
            )
          else
            const SizedBox(width: 64), // Maintain spacing
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double size;
  final double iconSize;
  final bool isPrimary;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    this.size = 56,
    this.iconSize = 24,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    backgroundColor,
                    backgroundColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isPrimary ? null : backgroundColor,
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? backgroundColor.withValues(alpha: 0.4)
                  : Theme.of(context).shadowColor.withValues(alpha: 0.2),
              blurRadius: isPrimary ? 16 : 8,
              offset: Offset(0, isPrimary ? 6 : 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isPrimary
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'セッション進捗',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ProgressItem(
                label: '現在サイクル',
                value:
                    '${timerSession.currentCycle + 1}/${timerSession.settings.cyclesUntilLongBreak}',
                accentColor: Theme.of(context).colorScheme.accentColor,
              ),
              Container(
                width: 1,
                height: 40,
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2),
              ),
              _ProgressItem(
                label: '完了サイクル',
                value: '${timerSession.completedCycles}',
                accentColor: Theme.of(context).colorScheme.infoColor,
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
  final Color accentColor;

  const _ProgressItem({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: accentColor.withValues(alpha: 0.1),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.05),
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ポモドーロ設定',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.2),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: onClose,
                    ),
                  ),
                ],
              ),
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
                      color: Theme.of(context).colorScheme.accentColor,
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
                      color: Theme.of(context).colorScheme.infoColor,
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
                      color: Theme.of(context).colorScheme.purpleColor,
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
                      color: Theme.of(context).colorScheme.successColor,
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
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: Theme.of(context)
                      .colorScheme
                      .accentColor
                      .withValues(alpha: 0.3),
                ),
                child: const Text(
                  '設定を保存',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
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
  final Color color;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.2),
                ),
                child: Icon(
                  _getIconForTitle(title),
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ControlButton(
                icon: Icons.remove_rounded,
                onPressed: value > min ? () => onChanged(value - 1) : null,
                color: color,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: color.withValues(alpha: 0.15),
                ),
                child: Text(
                  '$value $unit',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              _ControlButton(
                icon: Icons.add_rounded,
                onPressed: value < max ? () => onChanged(value + 1) : null,
                color: color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case '作業時間':
        return Icons.work_rounded;
      case '短い休憩':
        return Icons.coffee_rounded;
      case '長い休憩':
        return Icons.spa_rounded;
      case '長い休憩までのサイクル数':
        return Icons.repeat_rounded;
      default:
        return Icons.timer_rounded;
    }
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onPressed != null
            ? color.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
        border: Border.all(
          color: onPressed != null
              ? color.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: onPressed != null
              ? color
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
