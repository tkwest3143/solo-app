import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/states/timer_state.dart';
import 'package:solo/models/timer_model.dart';

class TimerControls extends ConsumerWidget {
  const TimerControls({super.key});

  Future<void> _showCompletionDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスク完了'),
        content: const Text('選択中のタスクを完了済みにしますか？'),
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
      final timerController = ref.read(timerStateProvider.notifier);
      await timerController.completeTodoIfSelected();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSession = ref.watch(timerStateProvider);
    final timerController = ref.read(timerStateProvider.notifier);
    final canStart = timerSession.state == TimerStatus.idle ||
        timerSession.state == TimerStatus.paused;
    final showSkip = timerSession.mode == TimerMode.pomodoro &&
        (timerSession.state == TimerStatus.running ||
            timerSession.state == TimerStatus.paused);
    final showComplete = timerSession.selectedTodoId != null &&
        ((timerSession.mode == TimerMode.pomodoro &&
                (timerSession.state == TimerStatus.idle ||
                    timerSession.state == TimerStatus.paused)) ||
            (timerSession.mode == TimerMode.countUp &&
                timerSession.elapsedSeconds > 0 &&
                timerSession.state == TimerStatus.idle));
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
          _TimerControlButton(
            icon: Icons.refresh_rounded,
            onTap: timerController.resetTimer,
            backgroundColor:
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
            size: 64,
            iconSize: 28,
          ),

          const SizedBox(width: 32),

          // Play/Pause button - larger and more prominent
          _TimerControlButton(
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

          // Skip button (only for Pomodoro) or Complete button
          if (showSkip)
            _TimerControlButton(
              icon: Icons.skip_next_rounded,
              onTap: timerController.skipPhase,
              backgroundColor:
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
              size: 64,
              iconSize: 28,
            )
          else if (showComplete)
            _TimerControlButton(
              icon: Icons.check_rounded,
              onTap: () => _showCompletionDialog(context, ref),
              backgroundColor: Theme.of(context).colorScheme.successColor,
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

class _TimerControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double size;
  final double iconSize;
  final bool isPrimary;

  const _TimerControlButton({
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
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.onSurface,
          size: iconSize,
        ),
      ),
    );
  }
}