import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/states/settings_state.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);
    final settingsController = ref.read(settingsStateProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Theme.of(context).colorScheme.backgroundGradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                '設定',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primaryTextColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),

              // Settings content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Theme Settings Section
                      _SettingsSection(
                        title: 'テーマ設定',
                        icon: Icons.palette_rounded,
                        children: [
                          _ThemeSelector(
                            currentTheme: settings.themeMode,
                            onThemeChanged: settingsController.updateThemeMode,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Pomodoro Settings Section
                      _SettingsSection(
                        title: 'ポモドーロ初期設定',
                        icon: Icons.timer_rounded,
                        children: [
                          _SettingItem(
                            title: '作業時間',
                            subtitle: '集中して作業する時間',
                            value: settings.defaultWorkMinutes,
                            unit: '分',
                            min: 1,
                            max: 90,
                            onChanged:
                                settingsController.updateDefaultWorkMinutes,
                            color: Theme.of(context).colorScheme.accentColor,
                          ),
                          _SettingItem(
                            title: '短い休憩',
                            subtitle: '短めの休憩時間',
                            value: settings.defaultShortBreakMinutes,
                            unit: '分',
                            min: 1,
                            max: 30,
                            onChanged: settingsController
                                .updateDefaultShortBreakMinutes,
                            color: Theme.of(context).colorScheme.infoColor,
                          ),
                          _SettingItem(
                            title: '長い休憩',
                            subtitle: '長めの休憩時間',
                            value: settings.defaultLongBreakMinutes,
                            unit: '分',
                            min: 5,
                            max: 60,
                            onChanged: settingsController
                                .updateDefaultLongBreakMinutes,
                            color: Theme.of(context).colorScheme.purpleColor,
                          ),
                          _SettingItem(
                            title: '長い休憩までのサイクル',
                            subtitle: '何回で長い休憩に入るか',
                            value: settings.defaultCyclesUntilLongBreak,
                            unit: '回',
                            min: 1,
                            max: 10,
                            onChanged: settingsController
                                .updateDefaultCyclesUntilLongBreak,
                            color: Theme.of(context).colorScheme.successColor,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Notification Permission Settings Section
                      _SettingsSection(
                        title: '通知許可設定',
                        icon: Icons.notifications_active_rounded,
                        children: [
                          _SwitchSettingItem(
                            title: 'Todo期限日通知',
                            subtitle: 'Todoの期限が近づいた時の通知',
                            value: settings.todoDueDateNotificationsEnabled,
                            onChanged: settingsController
                                .toggleTodoDueDateNotifications,
                          ),
                          _SwitchSettingItem(
                            title: 'ポモドーロ完了通知',
                            subtitle: 'タイマーが0になった時の通知',
                            value:
                                settings.pomodoroCompletionNotificationsEnabled,
                            onChanged: settingsController
                                .togglePomodoroCompletionNotifications,
                          ),
                          _SwitchSettingItem(
                            title: 'カウントアップタイマー通知',
                            subtitle: '指定時間でのお知らせ通知',
                            value: settings.countUpTimerNotificationsEnabled,
                            onChanged: settingsController
                                .toggleCountUpTimerNotifications,
                          ),
                          if (settings.countUpTimerNotificationsEnabled)
                            _SettingItem(
                              title: '通知する時間',
                              subtitle: 'カウントアップ通知のタイミング',
                              value: settings.countUpNotificationMinutes,
                              unit: '分',
                              min: 5,
                              max: 300,
                              onChanged: settingsController
                                  .updateCountUpNotificationMinutes,
                              color: Theme.of(context).colorScheme.accentColor,
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Reset button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              _showResetDialog(context, settingsController),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.8), // 半透明にして視認性UP
                            foregroundColor:
                                Theme.of(context).colorScheme.primaryTextColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '設定をリセット',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, SettingsState controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('設定をリセット',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('すべての設定を初期値に戻しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('キャンセル',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondaryTextColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                )),
          ),
          ElevatedButton(
            onPressed: () {
              controller.resetToDefaults();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.8),
              foregroundColor: Theme.of(context).colorScheme.primaryTextColor,
            ),
            child: const Text('リセット',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                )),
          ),
        ],
      ),
    );
  }
}

// Settings Section Widget
class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.lightShadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: Theme.of(context).colorScheme.primaryGradient,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.surface,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          ...children.map((child) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: child,
              )),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// Theme Selector Widget
class _ThemeSelector extends StatelessWidget {
  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onThemeChanged;

  const _ThemeSelector({
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ThemeOption(
          title: 'ライトテーマ',
          subtitle: '明るい色合いのテーマ',
          themeMode: ThemeMode.light,
          currentTheme: currentTheme,
          onChanged: onThemeChanged,
          icon: Icons.light_mode_rounded,
        ),
        const SizedBox(height: 8),
        _ThemeOption(
          title: 'ダークテーマ',
          subtitle: '暗い色合いのテーマ',
          themeMode: ThemeMode.dark,
          currentTheme: currentTheme,
          onChanged: onThemeChanged,
          icon: Icons.dark_mode_rounded,
        ),
        const SizedBox(height: 8),
        _ThemeOption(
          title: 'システム設定に従う',
          subtitle: 'デバイスの設定に合わせて自動切替',
          themeMode: ThemeMode.system,
          currentTheme: currentTheme,
          onChanged: onThemeChanged,
          icon: Icons.auto_mode_rounded,
        ),
      ],
    );
  }
}

// Theme Option Widget
class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final ThemeMode themeMode;
  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onChanged;
  final IconData icon;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.themeMode,
    required this.currentTheme,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentTheme == themeMode;

    return InkWell(
      onTap: () => onChanged(themeMode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.accentColor
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? Theme.of(context).colorScheme.accentColor.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondaryTextColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Theme.of(context).colorScheme.accentColor
                          : Theme.of(context).colorScheme.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).colorScheme.accentColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// Setting Item Widget (for numeric values)
class _SettingItem extends HookWidget {
  final String title;
  final String subtitle;
  final int value;
  final String unit;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final Color color;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.1), // 透明度を下げて視認性UP
        border: Border.all(
          color: color.withValues(alpha: 0.15), // ボーダーも薄く
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showValueDialog(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: color,
                  ),
                  child: Text(
                    '$value $unit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.surface,
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

  void _showValueDialog(BuildContext context) {
    final controller = TextEditingController(text: value.toString());

    void submitValue(String inputValue) {
      final intValue = int.tryParse(inputValue);
      if (intValue != null && intValue >= min && intValue <= max) {
        onChanged(intValue);
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '値を入力',
                suffixText: unit,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color, width: 2),
                ),
              ),
              autofocus: true,
              onSubmitted: (inputValue) {
                submitValue(inputValue);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 12),
            Text(
              '範囲: $min〜$max $unit',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondaryTextColor,
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
              submitValue(controller.text);
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
}

// Switch Setting Item Widget
class _SwitchSettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSettingItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: value
            ? Theme.of(context).colorScheme.accentColor.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: value
              ? Theme.of(context).colorScheme.accentColor.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.accentColor,
            inactiveThumbColor: Theme.of(context).colorScheme.onSurfaceVariant,
            inactiveTrackColor: Theme.of(context)
                .colorScheme
                .mutedTextColor
                .withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}
