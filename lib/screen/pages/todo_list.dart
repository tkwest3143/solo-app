import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/screen/widgets/todo.dart';

enum TodoFilter { all, completed, incomplete }

class TodoListPage extends HookConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterNotifier = ValueNotifier(TodoFilter.all);
    final refreshKey = ValueNotifier(0);

    void refreshTodos() {
      refreshKey.value++;
    }

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
                          AddTodoDialog.show(context, onSaved: refreshTodos);
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
                  return ValueListenableBuilder<int>(
                    valueListenable: refreshKey,
                    builder: (context, _, __) =>
                        FutureBuilder<Map<String, List<TodoModel>>>(
                      future: _getTodoSections(filter),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                              ...sections['today']!.map((todo) =>
                                  _buildTodoCard(context, todo, refreshTodos)),
                              const SizedBox(height: 20),
                            ],
                            if (sections['upcoming']?.isNotEmpty == true) ...[
                              _buildSectionHeader(context, '期限が近い',
                                  sections['upcoming']!.length),
                              ...sections['upcoming']!.map((todo) =>
                                  _buildTodoCard(context, todo, refreshTodos)),
                              const SizedBox(height: 20),
                            ],
                            if (sections['all']?.isNotEmpty == true) ...[
                              _buildSectionHeader(
                                  context, 'すべてのTodo', sections['all']!.length),
                              ...sections['all']!.map((todo) =>
                                  _buildTodoCard(context, todo, refreshTodos)),
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
                            const SizedBox(height: 80),
                          ],
                        );
                      },
                    ),
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

  Widget _buildTodoCard(
      BuildContext context, TodoModel todo, VoidCallback onRefresh) {
    return TodoCard(
      todo: todo,
      onRefresh: onRefresh,
    );
  }

  Future<Map<String, List<TodoModel>>> _getTodoSections(
      TodoFilter filter) async {
    // ダミーデータを返す
    final now = DateTime.now();
    final dummyTodos = [
      TodoModel(
        id: 1,
        title: 'ダミーTodo 1',
        description: 'ダミー詳細 1',
        dueDate: now,
        isCompleted: false,
        color: 'blue',
      ),
      TodoModel(
        id: 2,
        title: 'ダミーTodo 2',
        description: 'ダミー詳細 2',
        dueDate: now.add(const Duration(days: 1)),
        isCompleted: true,
        color: 'orange',
      ),
      TodoModel(
        id: 3,
        title: 'ダミーTodo 3',
        description: 'ダミー詳細 3',
        dueDate: now.add(const Duration(days: 3)),
        isCompleted: false,
        color: 'green',
      ),
    ];

    // フィルタ適用
    List<TodoModel> filteredData;
    switch (filter) {
      case TodoFilter.completed:
        filteredData = dummyTodos.where((todo) => todo.isCompleted).toList();
        break;
      case TodoFilter.incomplete:
        filteredData = dummyTodos.where((todo) => !todo.isCompleted).toList();
        break;
      case TodoFilter.all:
      default:
        filteredData = dummyTodos;
        break;
    }

    final today = DateTime.now();
    final todayTodos = <TodoModel>[];
    final upcomingTodos = <TodoModel>[];
    final allFilteredTodos = <TodoModel>[];

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
        allFilteredTodos.add(todo);
      }
    }

    return {
      'today': todayTodos,
      'upcoming': upcomingTodos,
      'all': allFilteredTodos,
    };
  }
}
