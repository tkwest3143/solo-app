import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/states/timer_state.dart';
import 'package:solo/models/timer_model.dart';

class TimerModeSwitch extends ConsumerWidget {
  const TimerModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSession = ref.watch(timerStateProvider);
    final timerController = ref.read(timerStateProvider.notifier);
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
            onTap: () async {
              // 既に選択されている場合は何もしない
              if (timerSession.mode == TimerMode.pomodoro) return;
              
              // タイマーが実行中または進行中の場合は警告を表示
              if (timerSession.isActiveOrHasProgress) {
                final shouldSwitch = await _showModeChangeWarningDialog(context, TimerMode.pomodoro, timerSession.mode);
                if (!shouldSwitch || !context.mounted) return;
              }
              
              await timerController.switchMode(TimerMode.pomodoro);
            },
          ),
          const SizedBox(width: 6),
          _ModeButton(
            title: 'カウントアップ',
            isSelected: timerSession.mode == TimerMode.countUp,
            onTap: () async {
              // 既に選択されている場合は何もしない
              if (timerSession.mode == TimerMode.countUp) return;
              
              // タイマーが実行中または進行中の場合は警告を表示
              if (timerSession.isActiveOrHasProgress) {
                final shouldSwitch = await _showModeChangeWarningDialog(context, TimerMode.countUp, timerSession.mode);
                if (!shouldSwitch || !context.mounted) return;
              }
              
              await timerController.switchMode(TimerMode.countUp);
            },
          ),
        ],
      ),
    );
  }
}

/// タイマーモード変更時の警告ダイアログ
Future<bool> _showModeChangeWarningDialog(BuildContext context, TimerMode newMode, TimerMode currentMode) async {
  final currentModeDisplayName = currentMode == TimerMode.pomodoro ? 'ポモドーロタイマー' : 'カウントアップタイマー';
  final newModeDisplayName = newMode == TimerMode.pomodoro ? 'ポモドーロタイマー' : 'カウントアップタイマー';
  
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Theme.of(context).colorScheme.error,
            size: 28,
          ),
          const SizedBox(width: 8),
          const Text('タイマー実行中'),
        ],
      ),
      content: Text(
        '$currentModeDisplayNameが実行中です。\n$newModeDisplayNameに切り替えると、現在の進行状況がリセットされます。\n\n本当に切り替えますか？',
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'キャンセル',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
          ),
          child: Text(
            '切り替える',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  ) ?? false;
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
                    Theme.of(context)
                        .colorScheme
                        .accentColor
                        .withValues(alpha: 0.8),
                    Theme.of(context)
                        .colorScheme
                        .accentColor
                        .withValues(alpha: 0.6),
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
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}