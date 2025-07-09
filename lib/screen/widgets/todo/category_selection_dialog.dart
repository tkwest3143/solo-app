import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/category_model.dart';
import 'package:solo/screen/widgets/todo/category_add.dart';
import 'package:solo/services/category_service.dart';
import 'package:solo/enums/todo_color.dart';
import 'package:flutter/material.dart';

class CategorySelectionDialog {
  static Future<CategoryModel?> show(
    BuildContext context, {
    CategoryModel? initialCategory,
  }) async {
    return await showDialog<CategoryModel?>(
      context: context,
      builder: (context) => _CategorySelectionDialogContent(
        initialCategory: initialCategory,
      ),
    );
  }
}

class _CategorySelectionDialogContent extends HookWidget {
  final CategoryModel? initialCategory;

  const _CategorySelectionDialogContent({
    this.initialCategory,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCategory = useState<CategoryModel?>(initialCategory);
    final categories = useState<List<CategoryModel>>([]);
    final isLoading = useState<bool>(true);

    useEffect(() {
      Future<void> loadCategories() async {
        try {
          final categoryService = CategoryService();
          final loadedCategories = await categoryService.getCategories();
          categories.value = loadedCategories;
        } finally {
          isLoading.value = false;
        }
      }

      loadCategories();
      return null;
    }, []);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(
            Icons.category,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            'カテゴリを選択',
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
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          minWidth: MediaQuery.of(context).size.width * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.95,
        ),
        child: isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CategoryOption(
                    title: '新しく作成',
                    description: 'カテゴリを追加',
                    color: 'blue',
                    isSelected: false,
                    onTap: () async {
                      final newCategory = await AddCategoryDialog.show(context);
                      if (newCategory != null && context.mounted) {
                        categories.value = [...categories.value, newCategory];
                        selectedCategory.value = newCategory;
                      }
                    },
                    icon: Icons.add,
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final category in categories.value)
                            _CategoryOption(
                              title: category.title,
                              description: category.description ?? '',
                              color: category.color,
                              isSelected:
                                  selectedCategory.value?.id == category.id,
                              onTap: () => selectedCategory.value = category,
                            ),
                        ],
                      ),
                    ),
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
          onPressed: selectedCategory.value != null
              ? () => Navigator.of(context).pop(selectedCategory.value)
              : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '選択',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryOption extends StatelessWidget {
  final String title;
  final String description;
  final String color;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _CategoryOption({
    required this.title,
    required this.description,
    required this.color,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: isSelected ? 2 : 1,
              ),
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.surface,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TodoColor.getColorFromString(color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon ?? Icons.category,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primaryTextColor,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
