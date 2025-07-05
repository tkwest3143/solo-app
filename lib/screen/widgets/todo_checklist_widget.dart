import 'package:flutter/material.dart';
import 'package:solo/models/todo_checklist_item_model.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/services/todo_checklist_item_service.dart';

class TodoChecklistWidget extends StatefulWidget {
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
  State<TodoChecklistWidget> createState() => _TodoChecklistWidgetState();
}

class _TodoChecklistWidgetState extends State<TodoChecklistWidget> {
  List<TodoCheckListItemModel> _checklistItems = [];
  final TextEditingController _newItemController = TextEditingController();
  final TodoCheckListItemService _checklistService = TodoCheckListItemService();

  @override
  void initState() {
    super.initState();
    _checklistItems = List.from(widget.initialItems);
  }

  void _addNewItem() {
    if (_newItemController.text.trim().isEmpty) return;

    final newItem = TodoCheckListItemModel(
      id: DateTime.now().millisecondsSinceEpoch, // Temporary ID for new items
      todoId: widget.todoId ?? 0,
      title: _newItemController.text.trim(),
      isCompleted: false,
      order: _checklistItems.length,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() {
      _checklistItems.add(newItem);
      _newItemController.clear();
    });

    widget.onChecklistChanged(_checklistItems);
  }

  void _removeItem(int index) {
    setState(() {
      _checklistItems.removeAt(index);
    });
    widget.onChecklistChanged(_checklistItems);
  }

  void _toggleItem(int index) {
    setState(() {
      final item = _checklistItems[index];
      _checklistItems[index] = TodoCheckListItemModel(
        id: item.id,
        todoId: item.todoId,
        title: item.title,
        isCompleted: !item.isCompleted,
        order: item.order,
        createdAt: item.createdAt,
        updatedAt: DateTime.now(),
      );
    });
    widget.onChecklistChanged(_checklistItems);
  }

  void _editItem(int index, String newTitle) {
    if (newTitle.trim().isEmpty) return;

    setState(() {
      final item = _checklistItems[index];
      _checklistItems[index] = TodoCheckListItemModel(
        id: item.id,
        todoId: item.todoId,
        title: newTitle.trim(),
        isCompleted: item.isCompleted,
        order: item.order,
        createdAt: item.createdAt,
        updatedAt: DateTime.now(),
      );
    });
    widget.onChecklistChanged(_checklistItems);
  }

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
        const SizedBox(height: 8),
        if (_checklistItems.isNotEmpty) ...[
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
              children: _checklistItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return _buildChecklistItem(index, item);
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newItemController,
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
                onSubmitted: (_) => _addNewItem(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _addNewItem,
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChecklistItem(int index, TodoCheckListItemModel item) {
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
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleItem(index),
            child: Container(
              width: 20,
              height: 20,
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
              ),
              child: item.isCompleted
                  ? Icon(
                      Icons.check,
                      size: 12,
                      color: Theme.of(context).colorScheme.surface,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _showEditDialog(index, item),
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  color: item.isCompleted
                      ? Theme.of(context).colorScheme.outline
                      : Theme.of(context).colorScheme.onSurface,
                  decoration:
                      item.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _removeItem(index),
            icon: Icon(
              Icons.delete_outline,
              size: 18,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int index, TodoCheckListItemModel item) {
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
              _editItem(index, controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('更新'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newItemController.dispose();
    super.dispose();
  }
}
