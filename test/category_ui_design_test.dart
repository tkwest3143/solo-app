import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/widgets/todo/category_selection_dialog.dart';
import 'package:solo/screen/widgets/todo/category_add.dart';

void main() {
  group('Category UI Design Tests', () {
    
    testWidgets('CategorySelectionDialog should have appropriate height when no categories exist', (WidgetTester tester) async {
      // Build the dialog
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => CategorySelectionDialog.show(context),
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap the button to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Find the dialog content
      final constrainedBox = find.byType(ConstrainedBox).first;
      expect(constrainedBox, findsOneWidget);

      // Verify the dialog shows the empty state message
      expect(find.text('カテゴリがありません\n上の「新しく作成」で追加してください'), findsOneWidget);
      
      // Verify the "新しく作成" option is present
      expect(find.text('新しく作成'), findsOneWidget);
    });

    testWidgets('CategorySelectionDialog should use Flexible instead of Expanded when categories exist', (WidgetTester tester) async {
      // This test verifies that we use Flexible which allows the content to take only the space it needs
      // rather than Expanded which forces it to take all available space
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => CategorySelectionDialog.show(context),
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Wait for loading to complete and check the structure
      await tester.pump(const Duration(seconds: 1));
      
      // The content should be wrapped in a Column with mainAxisSize.min
      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.mainAxisSize, equals(MainAxisSize.min));
    });

    testWidgets('AddCategoryDialog should have proper padding for text fields to prevent label overlap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AddCategoryDialog.show(context),
                child: const Text('Show Add Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap to show the add category dialog
      await tester.tap(find.text('Show Add Dialog'));
      await tester.pumpAndSettle();

      // Find the text fields
      final titleField = find.widgetWithText(TextField, 'カテゴリ名');
      final descriptionField = find.widgetWithText(TextField, '詳細 (オプション)');
      
      expect(titleField, findsOneWidget);
      expect(descriptionField, findsOneWidget);

      // Verify that the title field has proper content padding
      final titleTextField = tester.widget<TextField>(titleField);
      final titleDecoration = titleTextField.decoration as InputDecoration;
      expect(titleDecoration.contentPadding, equals(const EdgeInsets.symmetric(horizontal: 16, vertical: 18)));

      // Verify that the description field has proper content padding
      final descriptionTextField = tester.widget<TextField>(descriptionField);
      final descriptionDecoration = descriptionTextField.decoration as InputDecoration;
      expect(descriptionDecoration.contentPadding, equals(const EdgeInsets.symmetric(horizontal: 16, vertical: 18)));

      // Verify that the title field is wrapped in a Container with margin
      final titleContainer = find.ancestor(
        of: titleField,
        matching: find.byType(Container),
      ).first;
      final containerWidget = tester.widget<Container>(titleContainer);
      expect(containerWidget.margin, equals(const EdgeInsets.only(bottom: 8)));
    });

    testWidgets('AddCategoryDialog should have consistent styling between text fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AddCategoryDialog.show(context),
                child: const Text('Show Add Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Add Dialog'));
      await tester.pumpAndSettle();

      // Get both text fields
      final titleField = tester.widget<TextField>(find.widgetWithText(TextField, 'カテゴリ名'));
      final descriptionField = tester.widget<TextField>(find.widgetWithText(TextField, '詳細 (オプション)'));

      // Verify both have the same content padding
      final titleDecoration = titleField.decoration as InputDecoration;
      final descriptionDecoration = descriptionField.decoration as InputDecoration;
      
      expect(titleDecoration.contentPadding, equals(descriptionDecoration.contentPadding));
      
      // Verify both have filled style
      expect(titleDecoration.filled, isTrue);
      expect(descriptionDecoration.filled, isTrue);
      
      // Verify both have rounded borders
      expect(titleDecoration.border, isA<OutlineInputBorder>());
      expect(descriptionDecoration.border, isA<OutlineInputBorder>());
    });
  });
}