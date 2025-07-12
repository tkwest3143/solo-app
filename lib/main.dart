import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
        ref.read(settingsIntegrationProvider.notifier).initializeTimerWithSettings();
      });
      return null;
    }, []);
    
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
