import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo/models/settings_model.dart';
import 'package:solo/screen/pages/tutorial.dart';
import 'package:solo/screen/states/settings_state.dart';
import 'package:solo/services/settings_service.dart';

void main() {
  group('Tutorial Functionality Tests', () {
    setUp(() async {
      // Clear any existing preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    group('Settings Model', () {
      test('should have hasCompletedTutorial field default to false', () {
        const settings = AppSettings();
        expect(settings.hasCompletedTutorial, false);
      });

      test('should update hasCompletedTutorial field correctly', () {
        const settings = AppSettings();
        final updatedSettings = settings.copyWith(hasCompletedTutorial: true);
        expect(updatedSettings.hasCompletedTutorial, true);
      });
    });

    group('Settings Service', () {
      test('should save and load hasCompletedTutorial correctly', () async {
        // Create test settings with tutorial completed
        const testSettings = AppSettings(hasCompletedTutorial: true);

        // Save settings
        final saveResult = await SettingsService.saveSettings(testSettings);
        expect(saveResult, true);

        // Load settings
        final loadedSettings = await SettingsService.loadSettings();
        expect(loadedSettings.hasCompletedTutorial, true);
      });

      test('should default to false for hasCompletedTutorial when no saved settings', () async {
        final loadedSettings = await SettingsService.loadSettings();
        expect(loadedSettings.hasCompletedTutorial, false);
      });
    });

    group('Tutorial Page Widget Tests', () {
      testWidgets('should display tutorial page with correct structure', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: const TutorialPage(),
              theme: ThemeData.light(),
            ),
          ),
        );

        // Verify skip button exists
        expect(find.text('スキップ'), findsOneWidget);

        // Verify first tutorial step is displayed
        expect(find.text('Soloへようこそ！'), findsOneWidget);
        expect(find.text('このアプリは、あなたの生産性を向上させるための\nTodo管理とタイマー機能を提供します。'), findsOneWidget);

        // Verify navigation buttons
        expect(find.text('次へ'), findsOneWidget);
      });

      testWidgets('should navigate through tutorial steps', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: const TutorialPage(),
              theme: ThemeData.light(),
            ),
          ),
        );

        // Verify first step
        expect(find.text('Soloへようこそ！'), findsOneWidget);

        // Tap next button
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();

        // Verify second step
        expect(find.text('Todoの追加'), findsOneWidget);
        expect(find.text('ホーム画面右下の＋ボタンをタップして\n新しいTodoを追加できます。'), findsOneWidget);

        // Verify back button appears
        expect(find.text('戻る'), findsOneWidget);
      });

      testWidgets('should show 始める button on last step', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: const TutorialPage(),
              theme: ThemeData.light(),
            ),
          ),
        );

        // Navigate to last step
        for (int i = 0; i < 4; i++) {
          await tester.tap(find.text(i < 3 ? '次へ' : '次へ'));
          await tester.pumpAndSettle();
        }

        // Verify last step content
        expect(find.text('カウントアップタイマー'), findsOneWidget);
        expect(find.text('始める'), findsOneWidget);
      });

      testWidgets('should navigate back when 戻る button is tapped', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: const TutorialPage(),
              theme: ThemeData.light(),
            ),
          ),
        );

        // Navigate to second step
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();

        // Verify on second step
        expect(find.text('Todoの追加'), findsOneWidget);

        // Tap back button
        await tester.tap(find.text('戻る'));
        await tester.pumpAndSettle();

        // Verify back on first step
        expect(find.text('Soloへようこそ！'), findsOneWidget);
      });

      testWidgets('should have correct number of page indicators', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: const TutorialPage(),
              theme: ThemeData.light(),
            ),
          ),
        );

        // Find page indicators (containers with specific dimensions)
        final indicators = find.byWidgetPredicate(
          (widget) => widget is Container && 
                       widget.decoration is BoxDecoration &&
                       (widget.decoration as BoxDecoration).borderRadius == BorderRadius.circular(4)
        );

        // Should have 5 indicators for 5 tutorial steps
        expect(indicators, findsNWidgets(5));
      });
    });

    group('Settings State Tests', () {
      test('should update hasCompletedTutorial through SettingsState', () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Initialize settings
        await container.read(settingsStateProvider.notifier).initialize();

        // Update tutorial completion status
        container.read(settingsStateProvider.notifier).updateHasCompletedTutorial(true);

        // Verify state is updated
        final settings = container.read(settingsStateProvider);
        expect(settings.hasCompletedTutorial, true);
      });
    });
  });
}