/// 入力値のバリデーションを行うユーティリティクラス
class InputValidation {
  // セキュリティリスクのある文字パターン
  static final List<RegExp> _dangerousPatterns = [
    RegExp(r'<script.*?>', caseSensitive: false),
    RegExp(r'javascript:', caseSensitive: false),
    RegExp(r'on\w+\s*=', caseSensitive: false), // onclick=, onload=等
    RegExp(r'SELECT\s+.*\s+FROM', caseSensitive: false),
    RegExp(r'INSERT\s+INTO', caseSensitive: false),
    RegExp(r'UPDATE\s+.*\s+SET', caseSensitive: false),
    RegExp(r'DELETE\s+FROM', caseSensitive: false),
    RegExp(r'DROP\s+TABLE', caseSensitive: false),
    RegExp(r'eval\s*\(', caseSensitive: false),
    RegExp(r'function\s*\(', caseSensitive: false),
    RegExp(r'\$\{.*\}'), // Template literal injection
    RegExp(r'<!--.*-->', caseSensitive: false), // HTML comments
    RegExp(r'<%.*%>', caseSensitive: false), // Server-side includes
  ];

  /// テキストがセキュリティ上安全かどうかチェック
  static bool isSecureText(String text) {
    if (text.isEmpty) return true;
    
    // 危険なパターンが含まれていないかチェック
    for (final pattern in _dangerousPatterns) {
      if (pattern.hasMatch(text)) {
        return false;
      }
    }
    
    return true;
  }

  /// Todoタイトルのバリデーション
  static String? validateTodoTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'タイトルを入力してください';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > 30) {
      return 'タイトルは30文字以内で入力してください';
    }

    if (!isSecureText(trimmedValue)) {
      return '使用できない文字が含まれています';
    }

    return null;
  }

  /// Todo詳細のバリデーション
  static String? validateTodoDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // 詳細は任意入力
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > 200) {
      return '詳細は200文字以内で入力してください';
    }

    if (!isSecureText(trimmedValue)) {
      return '使用できない文字が含まれています';
    }

    return null;
  }

  /// チェックリスト項目のバリデーション
  static String? validateChecklistItem(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'チェック項目を入力してください';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > 30) {
      return 'チェック項目は30文字以内で入力してください';
    }

    if (!isSecureText(trimmedValue)) {
      return '使用できない文字が含まれています';
    }

    return null;
  }

  /// カテゴリタイトルのバリデーション
  static String? validateCategoryTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'カテゴリ名を入力してください';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > 30) {
      return 'カテゴリ名は30文字以内で入力してください';
    }

    if (!isSecureText(trimmedValue)) {
      return '使用できない文字が含まれています';
    }

    return null;
  }

  /// カテゴリ詳細のバリデーション
  static String? validateCategoryDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // 詳細は任意入力
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > 200) {
      return '詳細は200文字以内で入力してください';
    }

    if (!isSecureText(trimmedValue)) {
      return '使用できない文字が含まれています';
    }

    return null;
  }
}