import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/states/settings_state.dart';
import 'package:solo/screen/states/settings_integration.dart';
import 'package:solo/screen/states/notification_state.dart';
import 'package:solo/utilities/ad_mob_constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("ja-JP", null);

  // 画面回転を縦向きのみに固定
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Google Mobile Ads SDKの初期化
  await MobileAds.instance.initialize();
  await initATT();
  FlutterNativeSplash.remove();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouter);
    final settings = ref.watch(settingsStateProvider);

    // Initialize settings and timer integration on app startup
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Load settings from storage
        await ref.read(settingsStateProvider.notifier).initialize();

        // Initialize timer system with loaded settings
        ref.read(settingsIntegrationProvider);
        ref
            .read(settingsIntegrationProvider.notifier)
            .initializeTimerWithSettings();

        // Initialize notification system
        await ref.read(notificationStateProvider.notifier).initialize();

        // Schedule notifications for today's todos
        await ref
            .read(notificationStateProvider.notifier)
            .scheduleTodayNotifications();

        // Check and update recurring notifications (for month change)
        await ref
            .read(notificationStateProvider.notifier)
            .checkAndUpdateRecurringNotifications();

        // Check if tutorial should be shown
        final settings = ref.read(settingsStateProvider);
        if (!settings.hasCompletedTutorial) {
          // Navigate to tutorial page
          router.go(RouterDefinition.tutorial.path);
        }
      });
      return null;
    }, []);

    return PopScope(
        canPop: false,
        child: MaterialApp.router(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settings.themeMode,
          locale: const Locale('ja', 'JP'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ja', 'JP'),
          ],
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        ));
  }
}
