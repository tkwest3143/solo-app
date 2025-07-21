import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomTimePicker extends HookWidget {
  final TimeOfDay initialTime;
  final void Function(TimeOfDay) onTimeChanged;

  const CustomTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
  });

  List<int> get hoursList => List.generate(24, (index) => index);
  List<int> get minutesList => List.generate(12, (index) => index * 5);

  @override
  Widget build(BuildContext context) {
    final selectedHour = useState(initialTime.hour);
    final selectedMinute = useState((initialTime.minute ~/ 5) * 5);
    final hourScrollController = useScrollController();
    final minuteScrollController = useScrollController();

    // Auto-scroll to selected values on initial load
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final hourIndex = selectedHour.value;
        final minuteIndex = selectedMinute.value ~/ 5;
        
        if (hourScrollController.hasClients) {
          hourScrollController.animateTo(
            hourIndex * 56.0, // Approximate item height
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        
        if (minuteScrollController.hasClients) {
          minuteScrollController.animateTo(
            minuteIndex * 56.0, // Approximate item height
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
      return null;
    }, []);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '時間を選択',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 時間選択
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '時',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: ListView.builder(
                        controller: hourScrollController,
                        itemCount: hoursList.length,
                        itemBuilder: (context, index) {
                          final hour = hoursList[index];
                          final isSelected = hour == selectedHour.value;
                          return GestureDetector(
                            onTap: () {
                              selectedHour.value = hour;
                              onTimeChanged(TimeOfDay(
                                hour: selectedHour.value,
                                minute: selectedMinute.value,
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  hour.toString().padLeft(2, '0'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: isSelected
                                            ? Theme.of(context).colorScheme.onPrimary
                                            : Theme.of(context).colorScheme.onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // 分選択
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '分',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: ListView.builder(
                        controller: minuteScrollController,
                        itemCount: minutesList.length,
                        itemBuilder: (context, index) {
                          final minute = minutesList[index];
                          final isSelected = minute == selectedMinute.value;
                          return GestureDetector(
                            onTap: () {
                              selectedMinute.value = minute;
                              onTimeChanged(TimeOfDay(
                                hour: selectedHour.value,
                                minute: selectedMinute.value,
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  minute.toString().padLeft(2, '0'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: isSelected
                                            ? Theme.of(context).colorScheme.onPrimary
                                            : Theme.of(context).colorScheme.onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 選択された時間の表示
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '選択された時間: ${selectedHour.value.toString().padLeft(2, '0')}:${selectedMinute.value.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // アクションボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    'キャンセル',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(TimeOfDay(
                      hour: selectedHour.value,
                      minute: selectedMinute.value,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// カスタム時間ピッカーを表示するヘルパー関数
Future<TimeOfDay?> showCustomTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) async {
  return await showModalBottomSheet<TimeOfDay>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CustomTimePicker(
        initialTime: initialTime,
        onTimeChanged: (time) {
          // リアルタイムで時間の変更を反映
        },
      ),
    ),
  );
}