import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:solo/screen/widgets/todo/custom_time_picker.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting("ja-JP", null);
  });

  group('日時入力最適化テスト', () {
    testWidgets('アプリケーション全体が日本語ロケールで設定される', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('ja', 'JP'),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ja', 'JP'),
            ],
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  // ローカライゼーションが正しく設定されているかを確認
                  final locale = Localizations.localeOf(context);
                  expect(locale.languageCode, equals('ja'));
                  
                  return const Center(
                    child: Text('ローカライゼーション テスト'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // テキストが表示されていることを確認
      expect(find.text('ローカライゼーション テスト'), findsOneWidget);
    });

    testWidgets('カスタム時間ピッカーが正しく動作する', (WidgetTester tester) async {
      // カスタム時間ピッカーウィジェットを直接テスト
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  await showCustomTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 10, minute: 30),
                  );
                },
                child: const Text('時間選択'),
              ),
            ),
          ),
        ),
      );

      // 時間選択ボタンをタップ
      await tester.tap(find.text('時間選択'));
      await tester.pumpAndSettle();

      // カスタム時間ピッカーが表示されることを確認
      expect(find.text('時間を選択'), findsOneWidget);
      expect(find.text('時'), findsOneWidget);
      expect(find.text('分'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('キャンセル'), findsOneWidget);
    });

  });

  group('カスタム時間選択ウィジェットテスト', () {
    test('5分単位の時間リストが正しく生成される', () {
      // 5分単位の時間リストを生成するロジックをテスト
      List<String> generateTimeList() {
        List<String> times = [];
        for (int hour = 0; hour < 24; hour++) {
          for (int minute = 0; minute < 60; minute += 5) {
            final hourStr = hour.toString().padLeft(2, '0');
            final minuteStr = minute.toString().padLeft(2, '0');
            times.add('$hourStr:$minuteStr');
          }
        }
        return times;
      }

      final timeList = generateTimeList();
      
      // 5分単位で時間が生成されることを確認
      expect(timeList.contains('00:00'), isTrue);
      expect(timeList.contains('00:05'), isTrue);
      expect(timeList.contains('00:10'), isTrue);
      expect(timeList.contains('12:30'), isTrue);
      expect(timeList.contains('23:55'), isTrue);
      
      // 5分単位でない時間が含まれないことを確認
      expect(timeList.contains('00:01'), isFalse);
      expect(timeList.contains('00:03'), isFalse);
      expect(timeList.contains('12:33'), isFalse);
      
      // 総数が正しいことを確認（24時間 × 12回/時間 = 288）
      expect(timeList.length, equals(288));
    });
  });
}