import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/utilities/date.dart';

enum TodoFilter { all, completed, incomplete }

class TodoListPage extends HookConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<TodoFilter> filterNotifier = ValueNotifier(TodoFilter.all);
    ValueNotifier<String?> categoryFilter = ValueNotifier(null);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Theme.of(context).colorScheme.backgroundGradient,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with filters and calendar button
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Todo追加画面への遷移やダイアログ表示など
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(28),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 24,
                                      offset: const Offset(0, -8),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.add_circle_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            size: 28),
                                        const SizedBox(width: 8),
                                        Text(
                                          '新しいTodoを追加',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'タイトルを入力',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withValues(alpha: 0.05),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Icon(Icons.schedule_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          '期限を選択',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryTextColor,
                                          ),
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                          onPressed: () {
                                            // 日付選択ダイアログ
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.08),
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            elevation: 0,
                                          ),
                                          child: const Text('日付を選択'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Todo追加処理
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text('Todoを追加しました')),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          '追加する',
                                          style: TextStyle(
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
                        },
                        icon: Icon(
                          Icons.add_circle_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        label: Text(
                          'Todoを追加',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.primaryTextColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.7),
                          foregroundColor:
                              Theme.of(context).colorScheme.primaryTextColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                      const Spacer(),
                      // Calendar navigation button
                      IconButton(
                        onPressed: () {
                          nextRouting(context, RouterDefinition.calendar);
                        },
                        icon: Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Filter controls
                  Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<TodoFilter>(
                          valueListenable: filterNotifier,
                          builder: (context, filter, _) {
                            return SegmentedButton<TodoFilter>(
                              segments: const [
                                ButtonSegment(
                                  value: TodoFilter.all,
                                  label: Text('すべて'),
                                ),
                                ButtonSegment(
                                  value: TodoFilter.incomplete,
                                  label: Text('未完了'),
                                ),
                                ButtonSegment(
                                  value: TodoFilter.completed,
                                  label: Text('完了'),
                                ),
                              ],
                              selected: {filter},
                              onSelectionChanged:
                                  (Set<TodoFilter> newSelection) {
                                filterNotifier.value = newSelection.first;
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Todo sections
            Expanded(
              child: ValueListenableBuilder<TodoFilter>(
                valueListenable: filterNotifier,
                builder: (context, filter, _) {
                  return FutureBuilder<Map<String, List<TodoModel>>>(
                    future: _getTodoSections(filter),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'エラーが発生しました',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.errorColor,
                            ),
                          ),
                        );
                      }

                      final sections = snapshot.data ?? {};

                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          if (sections['today']?.isNotEmpty == true) ...[
                            _buildSectionHeader(
                                context, '今日が期限', sections['today']!.length),
                            ...sections['today']!
                                .map((todo) => _buildTodoCard(context, todo)),
                            const SizedBox(height: 20),
                          ],
                          if (sections['upcoming']?.isNotEmpty == true) ...[
                            _buildSectionHeader(
                                context, '期限が近い', sections['upcoming']!.length),
                            ...sections['upcoming']!
                                .map((todo) => _buildTodoCard(context, todo)),
                            const SizedBox(height: 20),
                          ],
                          if (sections['all']?.isNotEmpty == true) ...[
                            _buildSectionHeader(
                                context, 'すべてのTodo', sections['all']!.length),
                            ...sections['all']!
                                .map((todo) => _buildTodoCard(context, todo)),
                          ],
                          if (sections.values
                              .every((list) => list.isEmpty)) ...[
                            const SizedBox(height: 60),
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.task_alt,
                                    size: 64,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .mutedTextColor,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Todoがありません',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .mutedTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 80), // Space for FAB
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryTextColor,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.todayTagBackgroundColor,
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.todayTagColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoCard(BuildContext context, TodoModel todo) {
    return TodoCard(
      todo: todo,
      onToggleComplete: () {
        // TODO: Implement toggle completion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${todo.title}の完了状態を切り替え')),
        );
      },
      onEdit: () {
        // TODO: Navigate to edit screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${todo.title}を編集')),
        );
      },
      onDelete: () {
        // TODO: Implement delete functionality
        _showDeleteConfirmation(context, todo);
      },
    );
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
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${todo.title}を削除しました')),
              );
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

  Future<Map<String, List<TodoModel>>> _getTodoSections(
      TodoFilter filter) async {
    final todoService = TodoService();

    // For prototype, use dummy data. In real implementation, these would come from the service
    final dummyData = [
      TodoModel(
        id: 1,
        title: '今日のミーティング準備',
        description: '資料を用意して会議室を予約する',
        dueDate: DateTime.now(),
        isCompleted: false,
        color: 'blue',
      ),
      TodoModel(
        id: 2,
        title: '完了済みタスク',
        description: '完了したタスクのサンプル',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        isCompleted: true,
        color: 'green',
      ),
      TodoModel(
        id: 3,
        title: '明日の企画書作成',
        description: '新しいプロジェクトの企画書を作成する',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        isCompleted: false,
        color: 'red',
      ),
      TodoModel(
        id: 4,
        title: '来週のプレゼン準備',
        description: 'スライドを作成してリハーサルを行う',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        isCompleted: false,
        color: 'purple',
      ),
      TodoModel(
        id: 5,
        title: '買い物リスト',
        description: '週末の買い物リスト作成',
        dueDate: DateTime.now().add(const Duration(days: 10)),
        isCompleted: false,
        color: 'orange',
      ),
    ];

    // Apply filter
    List<TodoModel> filteredData;
    switch (filter) {
      case TodoFilter.completed:
        filteredData = dummyData.where((todo) => todo.isCompleted).toList();
        break;
      case TodoFilter.incomplete:
        filteredData = dummyData.where((todo) => !todo.isCompleted).toList();
        break;
      case TodoFilter.all:
      default:
        filteredData = dummyData;
        break;
    }

    final today = DateTime.now();
    final todayTodos = <TodoModel>[];
    final upcomingTodos = <TodoModel>[];
    final allTodos = <TodoModel>[];

    for (final todo in filteredData) {
      final isToday = todo.dueDate.year == today.year &&
          todo.dueDate.month == today.month &&
          todo.dueDate.day == today.day;

      final isUpcoming = !isToday &&
          todo.dueDate.isAfter(today) &&
          todo.dueDate.isBefore(today.add(const Duration(days: 7)));

      if (isToday) {
        todayTodos.add(todo);
      } else if (isUpcoming) {
        upcomingTodos.add(todo);
      } else {
        allTodos.add(todo);
      }
    }

    return {
      'today': todayTodos,
      'upcoming': upcomingTodos,
      'all': allTodos,
    };
  }
}

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TodoCard({
    super.key,
    required this.todo,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
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
                  : Colors.transparent,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onToggleComplete,
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
                          : Theme.of(context).colorScheme.outline,
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
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit?.call();
                      break;
                    case 'delete':
                      onDelete?.call();
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
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
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
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
