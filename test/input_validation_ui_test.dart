import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/widgets/todo/multi_step_add_todo_dialog.dart';
import 'package:solo/screen/widgets/todo/category_add.dart';
import 'package:solo/screen/widgets/todo/todo_card.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/enums/timer_type.dart';

void main() {
  group('Input Validation UI Tests', () {
    
    testWidgets('Todo title validation should show error for empty input', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => MultiStepAddTodoDialog.show(context),
                  child: const Text('Add Todo'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap to show the dialog
      await tester.tap(find.text('Add Todo'));
      await tester.pumpAndSettle();

      // Find the title input field
      final titleField = find.byType(TextField);
      expect(titleField, findsWidgets);

      // Clear the field and trigger validation
      await tester.enterText(titleField.first, '');
      await tester.pump();

      // Should show error message
      expect(find.text('タイトルを入力してください'), findsOneWidget);
    });

    testWidgets('Todo title validation should show error for text over 30 characters', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => MultiStepAddTodoDialog.show(context),
                  child: const Text('Add Todo'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add Todo'));
      await tester.pumpAndSettle();

      final titleField = find.byType(TextField);
      
      // Enter text longer than 30 characters
      final longText = 'a' * 31;
      await tester.enterText(titleField.first, longText);
      await tester.pump();

      // Should show error message
      expect(find.text('タイトルは30文字以内で入力してください'), findsOneWidget);
    });

    testWidgets('Todo title validation should show error for dangerous characters', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => MultiStepAddTodoDialog.show(context),
                  child: const Text('Add Todo'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add Todo'));
      await tester.pumpAndSettle();

      final titleField = find.byType(TextField);
      
      // Enter dangerous script
      await tester.enterText(titleField.first, '<script>alert()</script>');
      await tester.pump();

      // Should show error message
      expect(find.text('使用できない文字が含まれています'), findsOneWidget);
    });

    testWidgets('Category name validation should work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AddCategoryDialog.show(context),
                child: const Text('Add Category'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add Category'));
      await tester.pumpAndSettle();

      // Find the category name field
      final nameField = find.widgetWithText(TextField, 'カテゴリ名');
      expect(nameField, findsOneWidget);

      // Test empty input
      await tester.enterText(nameField, '');
      await tester.pump();
      expect(find.text('カテゴリ名を入力してください'), findsOneWidget);

      // Test long input
      final longText = 'a' * 31;
      await tester.enterText(nameField, longText);
      await tester.pump();
      expect(find.text('カテゴリ名は30文字以内で入力してください'), findsOneWidget);

      // Test valid input
      await tester.enterText(nameField, 'Valid Category');
      await tester.pump();
      expect(find.text('カテゴリ名を入力してください'), findsNothing);
      expect(find.text('カテゴリ名は30文字以内で入力してください'), findsNothing);
    });

    testWidgets('Category description validation should work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AddCategoryDialog.show(context),
                child: const Text('Add Category'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add Category'));
      await tester.pumpAndSettle();

      // Find the description field
      final descField = find.widgetWithText(TextField, '詳細 (オプション)');
      expect(descField, findsOneWidget);

      // Test long input
      final longText = 'a' * 201;
      await tester.enterText(descField, longText);
      await tester.pump();
      expect(find.text('詳細は200文字以内で入力してください'), findsOneWidget);

      // Test dangerous characters
      await tester.enterText(descField, 'SELECT * FROM users');
      await tester.pump();
      expect(find.text('使用できない文字が含まれています'), findsOneWidget);

      // Test valid input
      await tester.enterText(descField, 'Valid description');
      await tester.pump();
      expect(find.text('詳細は200文字以内で入力してください'), findsNothing);
      expect(find.text('使用できない文字が含まれています'), findsNothing);
    });

    testWidgets('Todo card should handle long text with overflow', (WidgetTester tester) async {
      final longTitleTodo = TodoModel(
        id: 1,
        title: 'This is a very long title that should be truncated with ellipsis to prevent layout overflow issues',
        dueDate: DateTime.now(),
        isCompleted: false,
        timerType: TimerType.none,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TodoCard(todo: longTitleTodo),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the TodoCard is rendered without overflow
      expect(find.byType(TodoCard), findsOneWidget);
      
      // Find the title text widget
      final titleWidget = tester.widget<Text>(find.text(longTitleTodo.title));
      
      // Verify overflow and maxLines properties
      expect(titleWidget.overflow, TextOverflow.ellipsis);
      expect(titleWidget.maxLines, 2);
    });

    testWidgets('Add button should be disabled when validation fails', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AddCategoryDialog.show(context),
                child: const Text('Add Category'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add Category'));
      await tester.pumpAndSettle();

      // Initially the add button should be disabled
      final addButton = find.widgetWithText(ElevatedButton, '追加');
      expect(addButton, findsOneWidget);
      
      final buttonWidget = tester.widget<ElevatedButton>(addButton);
      expect(buttonWidget.onPressed, isNull); // Should be disabled
      
      // Enter valid category name
      final nameField = find.widgetWithText(TextField, 'カテゴリ名');
      await tester.enterText(nameField, 'Valid Category Name');
      await tester.pump();
      
      // Now the button should be enabled
      final enabledButtonWidget = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, '追加')
      );
      expect(enabledButtonWidget.onPressed, isNotNull); // Should be enabled
    });

    testWidgets('Character counter should be hidden but maxLength enforced', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => MultiStepAddTodoDialog.show(context),
                  child: const Text('Add Todo'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add Todo'));
      await tester.pumpAndSettle();

      final titleField = find.byType(TextField).first;
      
      // Try to enter more than 30 characters
      final longText = 'a' * 35;
      await tester.enterText(titleField, longText);
      await tester.pump();
      
      final textFieldWidget = tester.widget<TextField>(titleField);
      final controller = textFieldWidget.controller!;
      
      // Should be limited to 30 characters
      expect(controller.text.length, 30);
      
      // Counter text should be hidden
      expect(find.text('30/30'), findsNothing);
      expect(find.text('35/30'), findsNothing);
    });
  });
}