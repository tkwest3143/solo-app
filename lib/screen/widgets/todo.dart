import 'package:flutter/material.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/utilities/date.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRefresh;

  const TodoCard({
    super.key,
    required this.todo,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(todo.dueDate);
    final isOverdue =
        todo.dueDate.isBefore(DateTime.now()) && !todo.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
          color: isOverdue
              ? Theme.of(context).colorScheme.errorColor.withValues(alpha: 0.3)
              : isToday
                  ? Theme.of(context)
                      .colorScheme
                      .todayTagColor
                      .withValues(alpha: 0.3)
                  : _getColorFromString(todo.color).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.lightShadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => TodoDetailDialog.show(
          context,
          todo,
          onRefresh: onRefresh,
        ),
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await TodoService().toggleTodoComplete(todo.id);
                    onRefresh?.call();
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: todo.isCompleted
                          ? Theme.of(context).colorScheme.successColor
                          : Colors.transparent,
                      border: Border.all(
                        color: todo.isCompleted
                            ? Theme.of(context).colorScheme.successColor
                            : _getColorFromString(todo.color),
                        width: 2,
                      ),
                    ),
                    child: todo.isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: todo.isCompleted
                          ? Theme.of(context).colorScheme.mutedTextColor
                          : Theme.of(context).colorScheme.primaryTextColor,
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                if (isOverdue && !todo.isCompleted) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.errorBackgroundColor,
                    ),
                    child: Text(
                      '期限切れ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.errorColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ] else if (isToday && !todo.isCompleted) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:
                          Theme.of(context).colorScheme.todayTagBackgroundColor,
                    ),
                    child: Text(
                      '今日',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.todayTagColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case 'edit':
                        await AddTodoDialog.show(
                          context,
                          initialTodo: todo,
                          onSaved: onRefresh,
                        );
                        break;
                      case 'delete':
                        _showDeleteConfirmation(context, todo);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('編集'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('削除', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.mutedTextColor,
                  ),
                ),
              ],
            ),
            if (todo.description != null && todo.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                todo.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: todo.isCompleted
                      ? Theme.of(context).colorScheme.mutedTextColor
                      : Theme.of(context).colorScheme.secondaryTextColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getColorFromString(todo.color),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: isOverdue && !todo.isCompleted
                      ? Theme.of(context).colorScheme.errorColor
                      : Theme.of(context).colorScheme.mutedTextColor,
                ),
                const SizedBox(width: 4),
                Text(
                  formatDate(todo.dueDate, format: 'yyyy/MM/dd (EEE) HH:mm'),
                  style: TextStyle(
                    fontSize: 12,
                    color: isOverdue && !todo.isCompleted
                        ? Theme.of(context).colorScheme.errorColor
                        : Theme.of(context).colorScheme.mutedTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Color _getColorFromString(String? colorString) {
    switch (colorString) {
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteConfirmation(BuildContext context, TodoModel todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除確認'),
        content: Text('「${todo.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await TodoService().deleteTodo(todo.id);
              onRefresh?.call();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${todo.title}を削除しました')),
                );
              }
            },
            child: const Text(
              '削除',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class AddTodoDialog {
  static Future<void> show(
    BuildContext context, {
    DateTime? initialDate,
    TodoModel? initialTodo,
    VoidCallback? onSaved,
  }) async {
    final titleController = TextEditingController(text: initialTodo?.title ?? '');
    final descriptionController = TextEditingController(text: initialTodo?.description ?? '');
    final selectedDate = ValueNotifier<DateTime>(
      initialDate ?? initialTodo?.dueDate ?? DateTime.now(),
    );
    final selectedTime = ValueNotifier<TimeOfDay>(
      TimeOfDay.fromDateTime(initialTodo?.dueDate ?? DateTime.now()),
    );
    final selectedColor = ValueNotifier<String>(initialTodo?.color ?? 'blue');

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    initialTodo != null ? Icons.edit : Icons.add_circle_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    initialTodo != null ? 'Todoを編集' : '新しいTodoを追加',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'タイトル',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.05),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: '詳細（オプション）',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.05),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<DateTime>(
                valueListenable: selectedDate,
                builder: (context, date, _) => Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '期限: ${formatDate(date, format: 'yyyy/MM/dd (EEE)')}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryTextColor,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (pickedDate != null) {
                          selectedDate.value = pickedDate;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.08),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 0,
                      ),
                      child: const Text('日付を選択'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<TimeOfDay>(
                valueListenable: selectedTime,
                builder: (context, time, _) => Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '時間: ${time.format(context)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryTextColor,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: time,
                        );
                        if (pickedTime != null) {
                          selectedTime.value = pickedTime;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.08),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 0,
                      ),
                      child: const Text('時間を選択'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'カテゴリ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<String>(
                valueListenable: selectedColor,
                builder: (context, color, _) => Row(
                  children: [
                    _buildColorOption('blue', Colors.blue, color, selectedColor),
                    _buildColorOption('orange', Colors.orange, color, selectedColor),
                    _buildColorOption('green', Colors.green, color, selectedColor),
                    _buildColorOption('red', Colors.red, color, selectedColor),
                    _buildColorOption('purple', Colors.purple, color, selectedColor),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('タイトルを入力してください')),
                      );
                      return;
                    }

                    final dueDate = DateTime(
                      selectedDate.value.year,
                      selectedDate.value.month,
                      selectedDate.value.day,
                      selectedTime.value.hour,
                      selectedTime.value.minute,
                    );

                    if (initialTodo != null) {
                      // Update existing todo
                      await TodoService().updateTodo(
                        initialTodo.id,
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim().isEmpty
                            ? null
                            : descriptionController.text.trim(),
                        dueDate: dueDate,
                        color: selectedColor.value,
                      );
                    } else {
                      // Create new todo
                      await TodoService().createTodo(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim().isEmpty
                            ? null
                            : descriptionController.text.trim(),
                        dueDate: dueDate,
                        color: selectedColor.value,
                      );
                    }

                    Navigator.of(context).pop();
                    onSaved?.call();
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            initialTodo != null
                                ? 'Todoを更新しました'
                                : 'Todoを追加しました',
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: Text(
                    initialTodo != null ? '更新' : '追加',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildColorOption(
    String value,
    Color color,
    String selectedColor,
    ValueNotifier<String> selectedColorNotifier,
  ) {
    final isSelected = value == selectedColor;
    return Expanded(
      child: GestureDetector(
        onTap: () => selectedColorNotifier.value = value,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                _getColorName(value),
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? color : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _getColorName(String color) {
    switch (color) {
      case 'blue':
        return 'ブルー';
      case 'orange':
        return 'オレンジ';
      case 'green':
        return 'グリーン';
      case 'red':
        return 'レッド';
      case 'purple':
        return 'パープル';
      default:
        return color;
    }
  }
}

class TodoDetailDialog {
  static void show(
    BuildContext context,
    TodoModel todo, {
    VoidCallback? onRefresh,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getColorFromString(todo.color),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                todo.title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description != null && todo.description!.isNotEmpty) ...[
              Text(
                '詳細',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                todo.description!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              '期限',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatDate(todo.dueDate, format: 'yyyy/MM/dd (EEE) HH:mm'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  todo.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: todo.isCompleted
                      ? Theme.of(context).colorScheme.successColor
                      : Theme.of(context).colorScheme.mutedTextColor,
                ),
                const SizedBox(width: 8),
                Text(
                  todo.isCompleted ? '完了済み' : '未完了',
                  style: TextStyle(
                    color: todo.isCompleted
                        ? Theme.of(context).colorScheme.successColor
                        : Theme.of(context).colorScheme.mutedTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
          if (!todo.isCompleted)
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await TodoService().toggleTodoComplete(todo.id);
                onRefresh?.call();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${todo.title}を完了にしました')),
                  );
                }
              },
              child: const Text('完了'),
            ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await AddTodoDialog.show(
                context,
                initialTodo: todo,
                onSaved: onRefresh,
              );
            },
            child: const Text('編集'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await TodoService().deleteTodo(todo.id);
              onRefresh?.call();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${todo.title}を削除しました')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  static Color _getColorFromString(String? colorString) {
    switch (colorString) {
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}