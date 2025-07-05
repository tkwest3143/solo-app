import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/models/todo_checklist_item_model.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/services/todo_checklist_item_service.dart';

class TodoChecklistWidget extends HookConsumerWidget {
  final int? todoId; // null for new todos
  final List<TodoCheckListItemModel> initialItems;
  final Function(List<TodoCheckListItemModel>) onChecklistChanged;

  const TodoChecklistWidget({
    super.key,
    this.todoId,
    required this.initialItems,
    required this.onChecklistChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistItems = useState<List<TodoCheckListItemModel>>(List.from(initialItems));
    final newItemController = useTextEditingController();
    final checklistService = TodoCheckListItemService();

    // Update when initialItems change
    useEffect(() {
      checklistItems.value = List.from(initialItems);
      return null;
    }, [initialItems]);

    void addNewItem() {
      if (newItemController.text.trim().isEmpty) return;

      final newItem = TodoCheckListItemModel(
        id: DateTime.now().millisecondsSinceEpoch, // Temporary ID for new items
        todoId: todoId ?? 0,
        title: newItemController.text.trim(),
        isCompleted: false,
        order: checklistItems.value.length,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      checklistItems.value = [...checklistItems.value, newItem];
      newItemController.clear();
      onChecklistChanged(checklistItems.value);
    }

    void removeItem(int index) {
      final updatedItems = List<TodoCheckListItemModel>.from(checklistItems.value);
      updatedItems.removeAt(index);
      checklistItems.value = updatedItems;
      onChecklistChanged(checklistItems.value);
    }

    void toggleItem(int index) {
      final updatedItems = List<TodoCheckListItemModel>.from(checklistItems.value);
      final item = updatedItems[index];
      updatedItems[index] = TodoCheckListItemModel(
        id: item.id,
        todoId: item.todoId,
        title: item.title,
        isCompleted: !item.isCompleted,
        order: item.order,
        createdAt: item.createdAt,
        updatedAt: DateTime.now(),
      );
      checklistItems.value = updatedItems;
      onChecklistChanged(checklistItems.value);
    }

    void editItem(int index, String newTitle) {
      if (newTitle.trim().isEmpty) return;

      final updatedItems = List<TodoCheckListItemModel>.from(checklistItems.value);
      final item = updatedItems[index];
      updatedItems[index] = TodoCheckListItemModel(
        id: item.id,
        todoId: item.todoId,
        title: newTitle.trim(),
        isCompleted: item.isCompleted,
        order: item.order,
        createdAt: item.createdAt,
        updatedAt: DateTime.now(),
      );
      checklistItems.value = updatedItems;
      onChecklistChanged(checklistItems.value);
    }

    Widget buildChecklistItem(int index, TodoCheckListItemModel item) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: index > 0
              ? Border(
                  top: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                  ),
                )
              : null,
          // Add subtle background color change when completed
          color: item.isCompleted 
              ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
              : null,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => toggleItem(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: item.isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                  // Add shadow when completed for better visual feedback
                  boxShadow: item.isCompleted ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: item.isCompleted
                    ? Icon(
                        Icons.check,
                        size: 14,
                        color: Theme.of(context).colorScheme.surface,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => showEditDialog(context, index, item, editItem),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 14,
                    color: item.isCompleted
                        ? Theme.of(context).colorScheme.outline
                        : Theme.of(context).colorScheme.onSurface,
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: Theme.of(context).colorScheme.outline,
                  ),
                  child: Text(item.title),
                ),
              ),
            ),
            IconButton(
              onPressed: () => removeItem(index),
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: Theme.of(context).colorScheme.error,
              ),
              tooltip: '削除',
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.checklist,
              color: Theme.of(context).colorScheme.primary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'チェックリスト',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primaryTextColor,
              ),
            ),
            if (checklistItems.value.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${checklistItems.value.where((item) => item.isCompleted).length}/${checklistItems.value.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        if (checklistItems.value.isNotEmpty) ...[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: checklistItems.value.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return buildChecklistItem(index, item);
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: newItemController,
                decoration: InputDecoration(
                  hintText: 'チェックリスト項目を追加',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onSubmitted: (_) => addNewItem(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: addNewItem,
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: '追加',
            ),
          ],
        ),
      ],
    );
  }
}

void showEditDialog(
  BuildContext context,
  int index,
  TodoCheckListItemModel item,
  Function(int, String) editItem,
) {
  final controller = TextEditingController(text: item.title);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('チェックリスト項目を編集'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: '項目名を入力',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: () {
            editItem(index, controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('更新'),
        ),
      ],
    ),
  );
}
