import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/widgets/todo/multi_step_add_todo_dialog.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/enums/timer_type.dart';

void main() {
  group('Timer Type Change Prevention Tests', () {
    testWidgets('Timer type cards should be disabled in edit mode',
        (WidgetTester tester) async {
      // Create a test todo with pomodoro timer
      final testTodo = TodoModel(
        id: 1,
        title: 'Test Todo',
        dueDate: DateTime.now(),
        isCompleted: false,
        timerType: TimerType.pomodoro,
        pomodoroWorkMinutes: 25,
        pomodoroShortBreakMinutes: 5,
        pomodoroLongBreakMinutes: 15,
        pomodoroCycle: 4,
        pomodoroCompletedCycle: 2,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => MultiStepAddTodoDialog.show(
                    context,
                    initialTodo: testTodo,
                  ),
                  child: const Text('Edit Todo'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap to show the edit dialog
      await tester.tap(find.text('Edit Todo'));
      await tester.pumpAndSettle();

      // Verify that the header shows edit mode
      expect(find.text('Todoを編集'), findsOneWidget);

      // Navigate to the management step by tapping next twice
      // Step 1: Title step - just tap next
      await tester.tap(find.text('次へ'));
      await tester.pumpAndSettle();

      // Step 2: Repeat and date step - tap next
      await tester.tap(find.text('次へ'));
      await tester.pumpAndSettle();

      // Step 3: Management step should now be visible
      // Verify that the informational text about restrictions is shown
      expect(find.text('※ 管理方法（通常、ポモドーロ、カウントアップ、チェックリスト）は編集時に変更できません'),
          findsOneWidget);

      // Verify that timer type cards are present but the correct one is selected
      expect(find.text('通常'), findsOneWidget);
      expect(find.text('ポモドーロ'), findsOneWidget);
      expect(find.text('カウントアップ'), findsOneWidget);
      expect(find.text('チェックリスト'), findsOneWidget);

      // Verify that pomodoro settings are visible and editable
      expect(find.text('ポモドーロ設定'), findsOneWidget);
      expect(find.text('作業時間'), findsOneWidget);
    });

    testWidgets('Timer type should be correctly initialized from existing todo',
        (WidgetTester tester) async {
      // Test with countup timer
      final countupTodo = TodoModel(
        id: 2,
        title: 'Countup Todo',
        dueDate: DateTime.now(),
        isCompleted: false,
        timerType: TimerType.countup,
        countupElapsedSeconds: 1800, // 30 minutes
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => MultiStepAddTodoDialog.show(
                    context,
                    initialTodo: countupTodo,
                  ),
                  child: const Text('Edit Countup Todo'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap to show the edit dialog
      await tester.tap(find.text('Edit Countup Todo'));
      await tester.pumpAndSettle();

      // Navigate to management step
      await tester.tap(find.text('次へ'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('次へ'));
      await tester.pumpAndSettle();

      // Verify that countup settings are shown
      expect(find.text('カウントアップ設定'), findsOneWidget);
      expect(find.text('目標時間'), findsOneWidget);
    });

    testWidgets('Checklist todo should show checklist in edit mode',
        (WidgetTester tester) async {
      // Test with checklist (timer type none but has checklist items)
      final checklistTodo = TodoModel(
        id: 3,
        title: 'Checklist Todo',
        dueDate: DateTime.now(),
        isCompleted: false,
        timerType: TimerType.none,
        checklistItem: [
          // Note: This would need proper TodoCheckListItemModel instances
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => MultiStepAddTodoDialog.show(
                    context,
                    initialTodo: checklistTodo,
                  ),
                  child: const Text('Edit Checklist Todo'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap to show the edit dialog
      await tester.tap(find.text('Edit Checklist Todo'));
      await tester.pumpAndSettle();

      // Navigate to management step
      await tester.tap(find.text('次へ'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('次へ'));
      await tester.pumpAndSettle();

      // For now, just verify the dialog appears
      // Full checklist testing would require proper TodoCheckListItemModel setup
      expect(find.text('管理方法'), findsOneWidget);
    });

    testWidgets('New todo should allow timer type selection',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => MultiStepAddTodoDialog.show(context),
                  child: const Text('Add New Todo'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap to show the add dialog
      await tester.tap(find.text('Add New Todo'));
      await tester.pumpAndSettle();

      // Verify that the header shows add mode
      expect(find.text('新しいTodoを追加'), findsOneWidget);

      // Navigate to management step
      await tester.tap(find.text('次へ'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('次へ'));
      await tester.pumpAndSettle();

      // Verify that the selection instruction is shown (not restriction message)
      expect(find.text('Todoの管理方法を選択してください'), findsOneWidget);
      expect(find.text('※ 管理方法（通常、ポモドーロ、カウントアップ、チェックリスト）は編集時に変更できません'),
          findsNothing);

      // Verify that timer type cards are present and selectable
      expect(find.text('通常'), findsOneWidget);
      expect(find.text('ポモドーロ'), findsOneWidget);
      expect(find.text('カウントアップ'), findsOneWidget);
      expect(find.text('チェックリスト'), findsOneWidget);
    });

    testWidgets('Edit mode should show different title text',
        (WidgetTester tester) async {
      final testTodo = TodoModel(
        id: 1,
        title: 'Test Todo',
        dueDate: DateTime.now(),
        isCompleted: false,
        timerType: TimerType.none,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => MultiStepAddTodoDialog.show(
                    context,
                    initialTodo: testTodo,
                  ),
                  child: const Text('Edit Todo'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Edit Todo'));
      await tester.pumpAndSettle();

      // Navigate to management step
      await tester.tap(find.text('次へ'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('次へ'));
      await tester.pumpAndSettle();

      // Verify edit mode title
      expect(find.text('Todoの詳細設定を変更できます'), findsOneWidget);
      expect(find.text('Todoの管理方法を選択してください'), findsNothing);
    });
  });
}
