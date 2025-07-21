import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/category_model.dart';
import 'package:solo/services/category_service.dart';
import 'package:solo/enums/todo_color.dart';
import 'package:solo/utilities/input_validation.dart';

class AddCategoryDialog {
  static Future<CategoryModel?> show(BuildContext context) async {
    return await showDialog<CategoryModel?>(
      context: context,
      builder: (context) => _AddCategoryDialogContent(),
    );
  }
}

class _AddCategoryDialogContent extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final selectedColor = useState<String>('blue');
    final isCreating = useState<bool>(false);

    // バリデーションエラー状態
    final titleError = useState<String?>(null);
    final descriptionError = useState<String?>(null);

    final isTitleValid = useListenableSelector(
      titleController,
      () => InputValidation.validateCategoryTitle(titleController.text) == null,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(
            Icons.add_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            'カテゴリを追加',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryTextColor,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: titleController,
                autofocus: true,
                maxLength: 30,
                onChanged: (value) {
                  titleError.value = InputValidation.validateCategoryTitle(value);
                },
                decoration: InputDecoration(
                  labelText: 'カテゴリ名',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18, // より大きい縦方向パディングでラベルとの衝突を防ぐ
                  ),
                  errorText: titleError.value,
                  counterText: '',
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLength: 200,
              onChanged: (value) {
                descriptionError.value = InputValidation.validateCategoryDescription(value);
              },
              decoration: InputDecoration(
                labelText: '詳細 (オプション)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.05),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18, // 一貫性のあるパディング
                ),
                errorText: descriptionError.value,
                counterText: '',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'カラー',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primaryTextColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TodoColor.values.map((todoColor) {
                final isSelected = todoColor.name == selectedColor.value;
                return GestureDetector(
                  onTap: () => selectedColor.value = todoColor.name,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: todoColor.color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryTextColor
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: todoColor.color.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: (isTitleValid && !isCreating.value)
              ? () async {
                  isCreating.value = true;
                  try {
                    final categoryService = CategoryService();
                    final newCategory = await categoryService.createCategory(
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                      color: selectedColor.value,
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop(newCategory);
                    }
                  } catch (e) {
                    isCreating.value = false;
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('カテゴリの作成に失敗しました: ${e.toString()}'),
                          backgroundColor: Theme.of(context).colorScheme.errorColor,
                        ),
                      );
                    }
                  }
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: isCreating.value
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '作成中...',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : const Text(
                    '追加',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }
}
