import 'package:flutter/material.dart';
import 'package:solo/screen/colors.dart';

/// 再利用可能な確認ダイアログコンポーネント
class ConfirmationDialog {
  /// 確認ダイアログを表示する
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '削除',
    String cancelText = 'キャンセル',
    Color? confirmButtonColor,
    IconData? icon,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: confirmButtonColor ?? Theme.of(context).colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.secondaryTextColor,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.secondaryTextColor,
            ),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmButtonColor ?? 
                  Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              confirmText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  /// 削除確認用のプリセットダイアログ
  static Future<bool> showDeleteConfirmation(
    BuildContext context, {
    required String itemName,
    String? customMessage,
  }) async {
    return await show(
      context,
      title: '削除確認',
      message: customMessage ?? 
          '$itemNameを削除しますか？\n\nこの操作は元に戻せません。',
      confirmText: '削除',
      cancelText: 'キャンセル',
      confirmButtonColor: Theme.of(context).colorScheme.error,
      icon: Icons.warning_rounded,
    );
  }

  /// 繰り返しTodo全削除用のプリセットダイアログ
  static Future<bool> showDeleteAllRecurringConfirmation(
    BuildContext context, {
    required String todoTitle,
  }) async {
    return await show(
      context,
      title: '全削除確認',
      message: '「$todoTitle」に関連する全ての繰り返しTodoを完全に削除しますか？\n\nこの操作は元に戻せません。',
      confirmText: '全て削除',
      cancelText: 'キャンセル',
      confirmButtonColor: Theme.of(context).colorScheme.error,
      icon: Icons.delete_forever,
    );
  }
}