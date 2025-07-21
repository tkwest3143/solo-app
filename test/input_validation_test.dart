import 'package:flutter_test/flutter_test.dart';
import 'package:solo/utilities/input_validation.dart';

void main() {
  group('Input Validation Tests', () {
    group('Common Security Validation', () {
      test('should allow normal text', () {
        expect(InputValidation.isSecureText('普通のテキストです'), true);
        expect(InputValidation.isSecureText('Normal text'), true);
        expect(InputValidation.isSecureText('数字123'), true);
        expect(InputValidation.isSecureText('記号!@#'), true);
      });

      test('should reject dangerous characters', () {
        expect(InputValidation.isSecureText('<script>'), false);
        expect(InputValidation.isSecureText('SELECT * FROM'), false);
        expect(InputValidation.isSecureText('javascript:'), false);
        expect(InputValidation.isSecureText('${"\$"}{command}'), false);
        expect(InputValidation.isSecureText('eval('), false);
      });
    });

    group('Todo Title Validation', () {
      test('should accept valid todo titles', () {
        final result = InputValidation.validateTodoTitle('有効なタイトル');
        expect(result, isNull);
      });

      test('should reject empty title', () {
        final result = InputValidation.validateTodoTitle('');
        expect(result, isNotNull);
        expect(result, contains('タイトルを入力してください'));
      });

      test('should reject title over 30 characters', () {
        final longTitle = 'a' * 31;
        final result = InputValidation.validateTodoTitle(longTitle);
        expect(result, isNotNull);
        expect(result, contains('30文字以内'));
      });

      test('should reject title with dangerous characters', () {
        final result = InputValidation.validateTodoTitle('<script>alert()</script>');
        expect(result, isNotNull);
        expect(result, contains('使用できない文字'));
      });

      test('should accept title with exactly 30 characters', () {
        final title = 'a' * 30;
        final result = InputValidation.validateTodoTitle(title);
        expect(result, isNull);
      });
    });

    group('Todo Description Validation', () {
      test('should accept valid description', () {
        final result = InputValidation.validateTodoDescription('有効な詳細説明です');
        expect(result, isNull);
      });

      test('should accept empty description', () {
        final result = InputValidation.validateTodoDescription('');
        expect(result, isNull);
      });

      test('should reject description over 200 characters', () {
        final longDescription = 'a' * 201;
        final result = InputValidation.validateTodoDescription(longDescription);
        expect(result, isNotNull);
        expect(result, contains('200文字以内'));
      });

      test('should reject description with dangerous characters', () {
        final result = InputValidation.validateTodoDescription('SELECT * FROM users');
        expect(result, isNotNull);
        expect(result, contains('使用できない文字'));
      });

      test('should accept description with exactly 200 characters', () {
        final description = 'a' * 200;
        final result = InputValidation.validateTodoDescription(description);
        expect(result, isNull);
      });
    });

    group('Checklist Item Validation', () {
      test('should accept valid checklist item', () {
        final result = InputValidation.validateChecklistItem('チェック項目');
        expect(result, isNull);
      });

      test('should reject empty checklist item', () {
        final result = InputValidation.validateChecklistItem('');
        expect(result, isNotNull);
        expect(result, contains('チェック項目を入力してください'));
      });

      test('should reject checklist item over 30 characters', () {
        final longItem = 'a' * 31;
        final result = InputValidation.validateChecklistItem(longItem);
        expect(result, isNotNull);
        expect(result, contains('30文字以内'));
      });

      test('should reject checklist item with dangerous characters', () {
        final result = InputValidation.validateChecklistItem('javascript:alert()');
        expect(result, isNotNull);
        expect(result, contains('使用できない文字'));
      });
    });

    group('Category Title Validation', () {
      test('should accept valid category title', () {
        final result = InputValidation.validateCategoryTitle('カテゴリ名');
        expect(result, isNull);
      });

      test('should reject empty category title', () {
        final result = InputValidation.validateCategoryTitle('');
        expect(result, isNotNull);
        expect(result, contains('カテゴリ名を入力してください'));
      });

      test('should reject category title over 30 characters', () {
        final longTitle = 'a' * 31;
        final result = InputValidation.validateCategoryTitle(longTitle);
        expect(result, isNotNull);
        expect(result, contains('30文字以内'));
      });

      test('should reject category title with dangerous characters', () {
        final result = InputValidation.validateCategoryTitle('eval(maliciousCode)');
        expect(result, isNotNull);
        expect(result, contains('使用できない文字'));
      });
    });

    group('Category Description Validation', () {
      test('should accept valid category description', () {
        final result = InputValidation.validateCategoryDescription('カテゴリの説明');
        expect(result, isNull);
      });

      test('should accept empty category description', () {
        final result = InputValidation.validateCategoryDescription('');
        expect(result, isNull);
      });

      test('should reject category description over 200 characters', () {
        final longDescription = 'a' * 201;
        final result = InputValidation.validateCategoryDescription(longDescription);
        expect(result, isNotNull);
        expect(result, contains('200文字以内'));
      });

      test('should reject category description with dangerous characters', () {
        final result = InputValidation.validateCategoryDescription('\${malicious}');
        expect(result, isNotNull);
        expect(result, contains('使用できない文字'));
      });
    });
  });
}