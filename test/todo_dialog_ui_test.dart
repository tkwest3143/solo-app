import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/widgets/todo/add_todo_dialog.dart';

void main() {
  group('Todo Dialog UI Tests', () {
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

    testWidgets('ヘッダーが固定されていることを確認', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      // ダイアログを開く
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();
      
      // ヘッダーが存在することを確認
      expect(find.text('新しいTodoを追加'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      
      // TODO: スクロール時もヘッダーが固定されていることを確認
      // これは実装後にテストを追加
    });

    testWidgets('タイトルフィールドが必須であることが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      // ダイアログを開く
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();
      
      // タイトルフィールドに必須マークがあることを確認
      final titleField = find.byType(TextField).first;
      expect(titleField, findsOneWidget);
      
      // 必須マークまたは必須を示すラベルがあることを確認
      // 実装によって「タイトル *」または「タイトル（必須）」のような表示を想定
      expect(find.textContaining('*'), findsOneWidget, 
        reason: 'タイトルフィールドに必須マークが表示されているべき');
    });

    testWidgets('管理方法が2x2グリッドレイアウトで表示される', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      // ダイアログを開く
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();
      
      // 管理方法の4つの選択肢が表示されることを確認
      expect(find.text('通常'), findsOneWidget);
      expect(find.text('ポモドーロ'), findsOneWidget);
      expect(find.text('カウントアップ'), findsOneWidget);
      expect(find.text('チェックリスト'), findsOneWidget);
      
      // TODO: 2x2グリッドレイアウトになっていることを確認
      // GridViewまたは適切なレイアウトが使用されていることを確認
    });

    testWidgets('繰り返しON時に期限日が開始日に変更される', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      // ダイアログを開く
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();
      
      // 最初は「期限」と表示されている
      expect(find.text('期限'), findsOneWidget);
      
      // 繰り返しスイッチを見つけてONにする
      final switchWidget = find.byType(Switch);
      expect(switchWidget, findsOneWidget);
      
      await tester.tap(switchWidget);
      await tester.pumpAndSettle();
      
      // 繰り返しがONになったら「開始日」に変更される
      expect(find.text('開始日'), findsOneWidget);
      expect(find.text('期限'), findsNothing);
    });

    testWidgets('ダイアログのUIが美しく表示される', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      // ダイアログを開く
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();
      
      // 基本的な要素の存在を確認
      expect(find.text('新しいTodoを追加'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('追加'), findsOneWidget);
      
      // 各セクションが表示されることを確認
      expect(find.text('管理方法'), findsOneWidget);
      expect(find.text('繰り返し'), findsOneWidget);
      expect(find.text('カテゴリ'), findsOneWidget);
    });
  });
}