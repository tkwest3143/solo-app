import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/states/settings_state.dart';
import 'package:solo/screen/states/settings_integration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("ja-JP", null);
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize settings and timer integration on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load settings from storage
      await ref.read(settingsStateProvider.notifier).initialize();
      
      // Initialize timer system with loaded settings
      ref.read(settingsIntegrationProvider);
      ref.read(settingsIntegrationProvider.notifier).initializeTimerWithSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouter);
    final settings = ref.watch(settingsStateProvider);
    
    return PopScope(
        canPop: false,
        child: MaterialApp.router(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settings.themeMode,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        ));
  }
}
