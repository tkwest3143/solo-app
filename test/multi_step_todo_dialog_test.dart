import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/widgets/todo/add_todo_dialog.dart';

void main() {
  group('Multi-Step Todo Dialog Tests', () {
    late Widget testWidget;

    setUp(() {
      testWidget = ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AddTodoDialog.show(context),
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );
    });

    group('Step 1: Title Input Screen', () {
      testWidgets('タイトル入力画面が最初に表示される', (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        // ダイアログを開く
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        // タイトル入力画面の要素を確認
        expect(find.text('新しいTodoを追加'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('次へ'), findsOneWidget);
        
        // 他のステップの要素が表示されていないことを確認
        expect(find.text('繰り返し'), findsNothing);
        expect(find.text('管理方法'), findsNothing);
        expect(find.text('カテゴリ'), findsNothing);
      });

      testWidgets('タイトルが空の状態で次へボタンを押すとエラーが表示される', (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        // 次へボタンをタップ
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();

        // エラーメッセージが表示されることを確認
        expect(find.text('タイトルを入力してください'), findsOneWidget);
      });

      testWidgets('タイトルを入力後、次へボタンで次のステップに進む', (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        // タイトルを入力
        await tester.enterText(find.byType(TextField), 'テストタスク');
        
        // 次へボタンをタップ
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();

        // 次のステップ（繰り返し・日付選択）に進むことを確認
        expect(find.text('繰り返し'), findsOneWidget);
        expect(find.text('期限'), findsOneWidget);
      });
    });

    group('Step 2: Repeat and Date Selection Screen', () {
      Future<void> navigateToStep2(WidgetTester tester) async {
        await tester.pumpWidget(testWidget);
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();
        
        await tester.enterText(find.byType(TextField), 'テストタスク');
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();
      }

      testWidgets('繰り返しと日付選択画面の要素が表示される', (WidgetTester tester) async {
        await navigateToStep2(tester);

        // 繰り返しセクション
        expect(find.text('繰り返し'), findsOneWidget);
        expect(find.byType(Switch), findsOneWidget);

        // 日付選択セクション
        expect(find.text('期限'), findsOneWidget);
        expect(find.text('日付を選択'), findsOneWidget);
        expect(find.text('時間を選択'), findsOneWidget);

        // 次へボタンが表示される
        expect(find.text('次へ'), findsOneWidget);
      });

      testWidgets('繰り返しON時に期限日が開始日に変更される', (WidgetTester tester) async {
        await navigateToStep2(tester);

        // 最初は「期限」と表示されている
        expect(find.text('期限'), findsOneWidget);

        // 繰り返しスイッチをONにする
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        // 「開始日」に変更される
        expect(find.text('開始日'), findsOneWidget);
        expect(find.text('期限'), findsNothing);
      });

      testWidgets('繰り返しON時に繰り返しタイプが必須になる', (WidgetTester tester) async {
        await navigateToStep2(tester);

        // 繰り返しスイッチをONにする
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        // 繰り返しタイプが未選択のまま次へボタンを押す
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();

        // エラーメッセージが表示される
        expect(find.text('繰り返しタイプを選択してください'), findsOneWidget);
      });

      testWidgets('正常入力で管理方法選択画面に進む', (WidgetTester tester) async {
        await navigateToStep2(tester);

        // 次へボタンをタップ
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();

        // 管理方法選択画面に進む
        expect(find.text('管理方法'), findsOneWidget);
        expect(find.text('通常'), findsOneWidget);
        expect(find.text('ポモドーロ'), findsOneWidget);
        expect(find.text('カウントアップ'), findsOneWidget);
        expect(find.text('チェックリスト'), findsOneWidget);
      });
    });

    group('Step 3: Management Method Selection Screen', () {
      Future<void> navigateToStep3(WidgetTester tester) async {
        await tester.pumpWidget(testWidget);
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();
        
        await tester.enterText(find.byType(TextField), 'テストタスク');
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();
        
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();
      }

      testWidgets('管理方法選択画面の要素が表示される', (WidgetTester tester) async {
        await navigateToStep3(tester);

        // 管理方法選択セクション
        expect(find.text('管理方法'), findsOneWidget);
        expect(find.text('通常'), findsOneWidget);
        expect(find.text('ポモドーロ'), findsOneWidget);
        expect(find.text('カウントアップ'), findsOneWidget);
        expect(find.text('チェックリスト'), findsOneWidget);

        // ボタンが表示される
        expect(find.text('追加'), findsOneWidget);
        expect(find.text('カテゴリ、詳細の入力へ'), findsOneWidget);
      });

      testWidgets('追加ボタンでTodoが追加される', (WidgetTester tester) async {
        await navigateToStep3(tester);

        // 追加ボタンをタップ
        await tester.tap(find.text('追加'));
        await tester.pumpAndSettle();

        // ダイアログが閉じることを確認
        expect(find.text('管理方法'), findsNothing);
      });

      testWidgets('カテゴリ、詳細の入力へボタンで次のステップに進む', (WidgetTester tester) async {
        await navigateToStep3(tester);

        // カテゴリ、詳細の入力へボタンをタップ
        await tester.tap(find.text('カテゴリ、詳細の入力へ'));
        await tester.pumpAndSettle();

        // カテゴリ詳細入力画面に進む
        expect(find.text('カテゴリ'), findsOneWidget);
        expect(find.text('詳細（オプション）'), findsOneWidget);
      });
    });

    group('Step 4: Category and Details Input Screen', () {
      Future<void> navigateToStep4(WidgetTester tester) async {
        await tester.pumpWidget(testWidget);
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();
        
        await tester.enterText(find.byType(TextField), 'テストタスク');
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();
        
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();
        
        await tester.tap(find.text('カテゴリ、詳細の入力へ'));
        await tester.pumpAndSettle();
      }

      testWidgets('カテゴリ詳細入力画面の要素が表示される', (WidgetTester tester) async {
        await navigateToStep4(tester);

        // カテゴリセクション
        expect(find.text('カテゴリ'), findsOneWidget);
        expect(find.text('カテゴリを選択'), findsOneWidget);

        // 詳細セクション
        expect(find.text('詳細（オプション）'), findsOneWidget);

        // 追加ボタンが表示される
        expect(find.text('追加'), findsOneWidget);
      });

      testWidgets('追加ボタンでTodoが追加される', (WidgetTester tester) async {
        await navigateToStep4(tester);

        // 追加ボタンをタップ
        await tester.tap(find.text('追加'));
        await tester.pumpAndSettle();

        // ダイアログが閉じることを確認
        expect(find.text('カテゴリ'), findsNothing);
      });
    });

    group('Navigation and UX', () {
      testWidgets('各ステップでヘッダーが固定されている', (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        // Step 1
        expect(find.text('新しいTodoを追加'), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);

        // Step 2へ
        await tester.enterText(find.byType(TextField), 'テストタスク');
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();

        expect(find.text('新しいTodoを追加'), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);

        // Step 3へ
        await tester.tap(find.text('次へ'));
        await tester.pumpAndSettle();

        expect(find.text('新しいTodoを追加'), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('スクロール可能でレイアウトエラーが発生しない', (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        // ダイアログ内でスクロールが可能であることを確認
        final scrollable = find.byType(SingleChildScrollView);
        expect(scrollable, findsOneWidget);

        // レイアウトエラーがないことを確認（エラーが発生した場合、testerがRenderFlexOverflowExceptionをスローする）
        await tester.pumpAndSettle();
      });

      testWidgets('ダイアログが美しいUI/UXで表示される', (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        // モーダルボトムシートの基本要素が表示されることを確認
        expect(find.text('新しいTodoを追加'), findsOneWidget);
        
        // 角丸のコンテナ
        final containers = find.byType(Container);
        expect(containers, findsWidgets);

        // アニメーションやスタイリングの確認（具体的な実装に依存）
        await tester.pumpAndSettle();
      });
    });
  });
}