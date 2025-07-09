import 'package:flutter/material.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/category_model.dart';
import 'package:solo/services/category_service.dart';
import 'package:solo/enums/todo_color.dart';

Future<Map<String, dynamic>?> showTodoFilterDialog({
  required BuildContext context,
  int? initialCategoryId,
  String? initialStatus,
}) {
  int? tempSelectedCategoryId = initialCategoryId;
  String? tempSelectedStatus = initialStatus;

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Row(
              children: [
                Icon(Icons.filter_alt,
                    color: Theme.of(context).colorScheme.primary, size: 28),
                const SizedBox(width: 8),
                const Text('絞り込み',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ステータス',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.primaryTextColor)),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatusChip(
                        label: 'すべて',
                        selected: tempSelectedStatus == null,
                        onTap: () => setState(() => tempSelectedStatus = null),
                        icon: Icons.all_inclusive,
                      ),
                      const SizedBox(height: 8),
                      _StatusChip(
                        label: '未完了',
                        selected: tempSelectedStatus == 'incomplete',
                        onTap: () =>
                            setState(() => tempSelectedStatus = 'incomplete'),
                        icon: Icons.radio_button_unchecked,
                      ),
                      const SizedBox(height: 8),
                      _StatusChip(
                        label: '完了',
                        selected: tempSelectedStatus == 'completed',
                        onTap: () =>
                            setState(() => tempSelectedStatus = 'completed'),
                        icon: Icons.check_circle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('カテゴリ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.primaryTextColor)),
                  const SizedBox(height: 8),
                  FutureBuilder<List<CategoryModel>>(
                    future: CategoryService().getCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final categories = snapshot.data ?? [];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.15)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int?>(
                            value: tempSelectedCategoryId,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryTextColor),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Row(
                                  children: [
                                    Icon(Icons.circle_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withValues(alpha: 0.5),
                                        size: 18),
                                    const SizedBox(width: 8),
                                    const Text('すべて'),
                                  ],
                                ),
                              ),
                              ...categories.map((category) => DropdownMenuItem(
                                    value: category.id,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: TodoColor.getColorFromString(
                                                category.color),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Icon(
                                            Icons.category,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(category.title),
                                      ],
                                    ),
                                  )),
                            ],
                            onChanged: (value) =>
                                setState(() => tempSelectedCategoryId = value),
                          ),
                        ),
                      );
                    },
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
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.of(context).pop({
                  'categoryId': tempSelectedCategoryId,
                  'status': tempSelectedStatus,
                }),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child:
                      Text('決定', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outline;
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                : Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: borderColor,
              width: selected ? 2 : 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: Offset(0, 2))
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
