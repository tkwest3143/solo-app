import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/states/timer_state.dart';
import 'package:solo/models/timer_model.dart';

class TimerSettingsWidget extends HookConsumerWidget {
  final VoidCallback onClose;
  const TimerSettingsWidget({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSession = ref.watch(timerStateProvider);
    final timerSettings = timerSession.settings;
    
    final workMinutes = useState<int>(timerSettings.workMinutes);
    final shortBreakMinutes = useState<int>(timerSettings.shortBreakMinutes);
    final longBreakMinutes = useState<int>(timerSettings.longBreakMinutes);
    final cyclesUntilLongBreak = useState<int>(timerSettings.cyclesUntilLongBreak);

    void saveSettings() {
      final timerController = ref.read(timerStateProvider.notifier);
      final newSettings = TimerSettings(
        workMinutes: workMinutes.value,
        shortBreakMinutes: shortBreakMinutes.value,
        longBreakMinutes: longBreakMinutes.value,
        cyclesUntilLongBreak: cyclesUntilLongBreak.value,
      );
      timerController.updateSettings(newSettings);
      timerController.resetTimer();
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
                      onChanged: (value) {
                        workMinutes.value = value;
                      },
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
                      onChanged: (value) {
                        shortBreakMinutes.value = value;
                      },
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
                      onChanged: (value) {
                        longBreakMinutes.value = value;
                      },
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
                      onChanged: (value) {
                        cyclesUntilLongBreak.value = value;
                      },
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
                  foregroundColor: Theme.of(context).colorScheme.surface,
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

class _SettingItem extends HookWidget {
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
    final isTimeUnit = unit == '分';
    final valueState = useState<int>(value);
    final textController = useTextEditingController(text: value.toString());

    useEffect(() {
      textController.text = value.toString();
      valueState.value = value;
      return null;
    }, [value]);

    void handleTextInput(String text) {
      final newValue = int.tryParse(text);
      if (newValue != null && newValue >= min && newValue <= max) {
        onChanged(newValue);
        valueState.value = newValue;
        textController.text = newValue.toString();
      }
    }

    void incrementByStep() {
      final step = isTimeUnit ? 5 : 1;
      final newValue = valueState.value + step;
      if (newValue <= max) {
        onChanged(newValue);
        valueState.value = newValue;
        textController.text = newValue.toString();
      }
    }

    void decrementByStep() {
      final step = isTimeUnit ? 5 : 1;
      final newValue = valueState.value - step;
      if (newValue >= min) {
        onChanged(newValue);
        valueState.value = newValue;
        textController.text = newValue.toString();
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: 0.06),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
        ),
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
                  color: color.withValues(alpha: 0.15),
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
                onPressed: (isTimeUnit
                        ? valueState.value > min + 4
                        : valueState.value > min)
                    ? decrementByStep
                    : null,
                color: color,
                isTimeUnit: isTimeUnit,
              ),
              // タップで入力可能なテキストフィールド
              GestureDetector(
                onTap: () => _showInputDialog(context, textController,
                    handleTextInput, min, max, unit, color),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: color.withValues(alpha: 0.15),
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${valueState.value} $unit',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface, // コントラスト高い色
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.edit_rounded,
                        color: Theme.of(context)
                            .colorScheme
                            .primaryTextColor, // 明確な色
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              _ControlButton(
                icon: Icons.add_rounded,
                onPressed: (isTimeUnit
                        ? valueState.value < max - 4
                        : valueState.value < max)
                    ? incrementByStep
                    : null,
                color: color,
                isTimeUnit: isTimeUnit,
              ),
            ],
          ),
          if (isTimeUnit)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '±ボタンで5分刻み、タップで直接入力',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  void _showInputDialog(
    BuildContext context,
    TextEditingController controller,
    Function(String) onSubmit,
    int min,
    int max,
    String unit,
    Color color,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$title を設定'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: '$min〜$max $unit',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color, width: 2),
                ),
              ),
              autofocus: true,
              onSubmitted: (value) {
                onSubmit(value);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 12),
            Text(
              '範囲: $min〜$max $unit',
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
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              onSubmit(controller.text);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Theme.of(context).colorScheme.surface,
            ),
            child: const Text('設定'),
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
  final bool isTimeUnit;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    this.isTimeUnit = false,
  });

  @override
  Widget build(BuildContext context) {
    final tooltip = isTimeUnit
        ? (icon == Icons.add_rounded ? '+5分' : '-5分')
        : (icon == Icons.add_rounded ? '+1' : '-1');

    return Tooltip(
      message: tooltip,
      child: Container(
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
          icon: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                color: onPressed != null
                    ? color
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3),
              ),
              if (isTimeUnit && onPressed != null)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '5',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}