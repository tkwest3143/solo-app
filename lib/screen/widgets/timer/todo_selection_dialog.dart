import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/models/category_model.dart';
import 'package:solo/models/timer_model.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/services/category_service.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:solo/enums/todo_color.dart';
import 'package:solo/utilities/date.dart';
import 'package:solo/screen/colors.dart';

class TodoSelectionDialog extends HookConsumerWidget {
  final int? currentTodoId;
  final TimerMode currentTimerMode;
  
  const TodoSelectionDialog({
    super.key,
    this.currentTodoId,
    required this.currentTimerMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = useState<List<TodoModel>>([]);
    final categories = useState<Map<int, CategoryModel>>({});
    final isLoading = useState<bool>(true);

    Future<void> loadData() async {
      isLoading.value = true;
      
      try {
        // Load todos
        final todoList = await TodoService().getTodo();
        // Filter todos based on current timer mode
        final timerTodos = todoList
            .where((todo) {
              if (todo.isCompleted) return false;
              
              // ポモドーロモードの場合はポモドーロタイマーのTodoのみ表示
              if (currentTimerMode == TimerMode.pomodoro) {
                return todo.timerType == TimerType.pomodoro;
              }
              // カウントアップモードの場合はカウントアップタイマーのTodoのみ表示
              else if (currentTimerMode == TimerMode.countUp) {
                return todo.timerType == TimerType.countup;
              }
              
              return false;
            })
            .toList();
        
        // Sort by due date
        timerTodos.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        
        // Load categories for todos
        final categoryService = CategoryService();
        final categoryMap = <int, CategoryModel>{};
        for (final todo in timerTodos) {
          if (todo.categoryId != null && !categoryMap.containsKey(todo.categoryId)) {
            final category = await categoryService.getCategoryById(todo.categoryId!);
            if (category != null) {
              categoryMap[todo.categoryId!] = category;
            }
          }
        }
        
        todos.value = timerTodos;
        categories.value = categoryMap;
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
      }
    }

    useEffect(() {
      loadData();
      return null;
    }, []);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.checklist_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'タスクを選択',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoading.value)
              const Center(child: CircularProgressIndicator())
            else if (todos.value.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'タイマー設定されたタスクがありません',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: todos.value.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // 「選択しない」オプション
                      return _buildTodoItem(
                        context,
                        null,
                        isSelected: currentTodoId == null,
                      );
                    }
                    
                    final todo = todos.value[index - 1];
                    final category = categories.value[todo.categoryId];
                    return _buildTodoItem(
                      context,
                      todo,
                      category: category,
                      isSelected: currentTodoId == todo.id,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoItem(
    BuildContext context,
    TodoModel? todo, {
    CategoryModel? category,
    required bool isSelected,
  }) {
    if (todo == null) {
      // 「選択しない」オプション
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        color: isSelected 
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : null,
        child: ListTile(
          onTap: () => Navigator.of(context).pop(null),
          leading: Icon(
            Icons.clear,
            color: Theme.of(context).colorScheme.outline,
          ),
          title: const Text('タスクを選択しない'),
          subtitle: const Text('タイマーのみ使用'),
          trailing: isSelected
              ? Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
        ),
      );
    }

    final color = category != null
        ? TodoColor.getColorFromString(category.color)
        : TodoColor.getColorFromString(todo.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected 
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
          : null,
      child: ListTile(
        onTap: () => Navigator.of(context).pop(todo.id),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            todo.timerType == TimerType.pomodoro 
                ? Icons.timer 
                : Icons.timer_outlined,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          todo.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (category != null)
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
              ),
            Text(
              todo.timerType == TimerType.pomodoro ? 'ポモドーロタイマー' : 'カウントアップタイマー',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              formatDate(todo.dueDate),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondaryTextColor,
              ),
            ),
          ],
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : Icon(
                Icons.circle_outlined,
                color: Theme.of(context).colorScheme.outline,
              ),
      ),
    );
  }
}

// Helper function to show the dialog
Future<int?> showTodoSelectionDialog(
  BuildContext context, {
  int? currentTodoId,
  required TimerMode currentTimerMode,
}) {
  return showDialog<int?>(
    context: context,
    builder: (context) => TodoSelectionDialog(
      currentTodoId: currentTodoId,
      currentTimerMode: currentTimerMode,
    ),
  );
}