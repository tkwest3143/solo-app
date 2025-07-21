import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/widgets/todo/custom_time_picker.dart';
import 'package:solo/utilities/ad_mob_constant.dart';
import 'package:solo/screen/states/timer_state.dart';
import 'package:solo/models/timer_model.dart';

class BulderWidget extends StatelessWidget {
  const BulderWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: child,
    );
  }
}

class UserSelectedWidget extends ConsumerWidget {
  const UserSelectedWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BulderWidget(
      child: GlobalLayout(
        child: child,
      ),
    );
  }
}

class AppHeader extends HookConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onSettingsPressed;

  const AppHeader({
    super.key,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerAd = useState<BannerAd?>(null);
    final isAdLoaded = useState(false);

    useEffect(() {
      final ad = BannerAd(
        adUnitId: AdMobConstant.bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            isAdLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (kDebugMode) {
              debugPrint('バナー広告の読み込みに失敗しました: $error');
            }
          },
        ),
      );
      ad.load();
      bannerAd.value = ad;

      return () {
        ad.dispose();
      };
    }, []);

    return SizedBox(
        height: kToolbarHeight,
        child: isAdLoaded.value && bannerAd.value != null
            ? Container(
                alignment: Alignment.center,
                width: bannerAd.value!.size.width.toDouble(),
                height: bannerAd.value!.size.height.toDouble(),
                child: AdWidget(ad: bannerAd.value!),
              )
            : Container());
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class GlobalLayout extends HookConsumerWidget {
  final Widget child;

  const GlobalLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSession = ref.watch(timerStateProvider);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(onSettingsPressed: () async {
              // タイマー画面からの遷移でタイマーが実行中の場合警告を表示
              final location = GoRouterState.of(context).uri.path;
              final isTimerActive = timerSession.isActiveOrHasProgress;
              final isLeavingTimerPage = location == '/timer';
              
              if (isLeavingTimerPage && isTimerActive) {
                final shouldLeave = await _showTimerWarningDialog(context, timerMode: timerSession.mode);
                if (!shouldLeave || !context.mounted) return;
              }
              
              if (context.mounted) {
                nextRouting(context, RouterDefinition.settings);
              }
            }),
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: const FooterMenu(),
    );
  }
}

class FooterMenu extends HookConsumerWidget {
  const FooterMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final timerSession = ref.watch(timerStateProvider);

    // Get current route to set correct tab index
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/':
        selectedIndex.value = 0;
        break;
      case '/todo-list':
        selectedIndex.value = 1;
        break;
      case '/timer':
        selectedIndex.value = 2;
        break;
      case '/menu':
        selectedIndex.value = 3;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.headerFooterColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.mediumShadowColor,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Theme.of(context).colorScheme.headerFooterTextColor,
        unselectedItemColor: Theme.of(context)
            .colorScheme
            .headerFooterTextColor
            .withValues(alpha: 0.7),
        selectedFontSize: 12,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            activeIcon: Icon(Icons.home_rounded, size: 28),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            activeIcon: Icon(Icons.checklist_rounded, size: 28),
            label: 'Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_rounded),
            activeIcon: Icon(Icons.timer_rounded, size: 28),
            label: 'タイマー',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            activeIcon: Icon(Icons.menu, size: 28),
            label: 'メニュー',
          ),
        ],
        currentIndex: selectedIndex.value,
        onTap: (index) async {
          // 現在の画面がタイマー画面で、タイマーが実行中の場合警告を表示
          final currentIndex = selectedIndex.value;
          final isTimerActive = timerSession.isActiveOrHasProgress;
          final isLeavingTimerPage = currentIndex == 2 && index != 2;
          
          if (isLeavingTimerPage && isTimerActive) {
            final shouldLeave = await _showTimerWarningDialog(context, timerMode: timerSession.mode);
            if (!shouldLeave || !context.mounted) return;
          }
          
          if (!context.mounted) return;
          
          switch (index) {
            case 0:
              nextRouting(context, RouterDefinition.root);
              break;
            case 1:
              nextRouting(context, RouterDefinition.todoList);
              break;
            case 2:
              nextRouting(context, RouterDefinition.timer);
              break;
            case 3:
              nextRouting(context, RouterDefinition.menu);
              break;
          }
        },
      ),
    );
  }
}

/// タイマー実行中の画面遷移警告ダイアログ
Future<bool> _showTimerWarningDialog(BuildContext context, {TimerMode? timerMode}) async {
  final timerModeDisplayName = timerMode == TimerMode.pomodoro ? 'ポモドーロタイマー' : 'カウントアップタイマー';
  
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
        '$timerModeDisplayNameが実行中です。\n他の画面に移動すると、タイマーの進行状況がリセットされます。\n\n本当に移動しますか？',
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
            '移動する',
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

class TimeInputForm extends StatelessWidget {
  final TextEditingController controller;
  final String? label;

  const TimeInputForm({
    super.key,
    this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCustomTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      ).then((time) {
        if (time != null && context.mounted) {
          controller.text = time.format(context);
        }
      }),
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.lightShadowColor,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              suffixIcon: Icon(
                Icons.access_time_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            controller: controller,
            keyboardType: TextInputType.none,
            readOnly: true,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
