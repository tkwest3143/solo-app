import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/widgets/todo/add_todo_dialog.dart';
import 'package:solo/screen/widgets/todo/todo_card.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/services/category_service.dart';
import 'package:solo/models/category_model.dart';

enum TodoFilter { all, completed, incomplete }

class TodoListPage extends HookConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ValueNotifier<int?>(null);
    final filterNotifier =
        ValueNotifier<TodoFilter>(TodoFilter.incomplete); // 初期値を未完了に
    final refreshKey = ValueNotifier(0);

    void refreshTodos() {
      refreshKey.value++;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddTodoDialog.show(context, onSaved: refreshTodos);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, size: 32),
      ),
      body: Container(
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
              // Header with category filter, status filter, and calendar button
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // カテゴリフィルター＋カレンダーボタン横並び
                    Row(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<int?>(
                            valueListenable: selectedCategoryId,
                            builder: (context, selectedId, _) {
                              return FutureBuilder<List<CategoryModel>>(
                                future: CategoryService().getCategories(),
                                builder: (context, snapshot) {
                                  final categories = snapshot.data ?? [];
                                  final valueList = [
                                    null,
                                    ...categories.map((cat) => cat.id)
                                  ];
                                  final labelList = [
                                    'すべてのカテゴリ',
                                    ...categories.map((cat) => cat.title),
                                  ];
                                  return DropdownButton<int?>(
                                    value: selectedId,
                                    isExpanded: true,
                                    hint: const Text('カテゴリで絞り込む'),
                                    selectedItemBuilder: (context) {
                                      return labelList
                                          .map((label) => Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(label),
                                              ))
                                          .toList();
                                    },
                                    items: valueList.map((value) {
                                      return DropdownMenuItem<int?>(
                                        value: value,
                                        child: Text(
                                          value == null
                                              ? 'すべてのカテゴリ'
                                              : labelList[
                                                  valueList.indexOf(value)],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      selectedCategoryId.value = value;
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {
                            nextRouting(context, RouterDefinition.calendar);
                          },
                          icon: Icon(
                            Icons.calendar_today,
                            color:
                                Theme.of(context).colorScheme.primaryTextColor,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: 0.2),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 状態フィルター
                    ValueListenableBuilder<TodoFilter>(
                      valueListenable: filterNotifier,
                      builder: (context, filter, _) {
                        return SegmentedButton<TodoFilter>(
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            minimumSize:
                                WidgetStateProperty.all(const Size(100, 40)),
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8)),
                          ),
                          segments: const [
                            ButtonSegment(
                              value: TodoFilter.incomplete,
                              label: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('未完了'),
                              ),
                            ),
                            ButtonSegment(
                              value: TodoFilter.completed,
                              label: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('完了'),
                              ),
                            ),
                            ButtonSegment(
                              value: TodoFilter.all,
                              label: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('すべて'),
                              ),
                            ),
                          ],
                          selected: {filter},
                          onSelectionChanged: (Set<TodoFilter> newSelection) {
                            filterNotifier.value = newSelection.first;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Todo sections
              Expanded(
                child: ValueListenableBuilder<int?>(
                  valueListenable: selectedCategoryId,
                  builder: (context, categoryId, _) {
                    return ValueListenableBuilder<TodoFilter>(
                      valueListenable: filterNotifier,
                      builder: (context, filter, __) {
                        return ValueListenableBuilder<int>(
                          valueListenable: refreshKey,
                          builder: (context, _, ___) =>
                              FutureBuilder<Map<String, List<TodoModel>>>(
                            future: _getTodoSections(categoryId, filter),
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .errorColor,
                                    ),
                                  ),
                                );
                              }

                              final sections = snapshot.data ?? {};

                              return ListView(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                children: [
                                  if (sections['today']?.isNotEmpty ==
                                      true) ...[
                                    _buildSectionHeader(context, '今日が期限',
                                        sections['today']!.length),
                                    ...sections['today']!.map((todo) =>
                                        _buildTodoCard(
                                            context, todo, refreshTodos)),
                                    const SizedBox(height: 20),
                                  ],
                                  if (sections['upcoming']?.isNotEmpty ==
                                      true) ...[
                                    _buildSectionHeader(context, '期限が近い',
                                        sections['upcoming']!.length),
                                    ...sections['upcoming']!.map((todo) =>
                                        _buildTodoCard(
                                            context, todo, refreshTodos)),
                                    const SizedBox(height: 20),
                                  ],
                                  if (sections['all']?.isNotEmpty == true) ...[
                                    _buildSectionHeader(context, 'すべてのTodo',
                                        sections['all']!.length),
                                    ...sections['all']!.map((todo) =>
                                        _buildTodoCard(
                                            context, todo, refreshTodos)),
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
                    );
                  },
                ),
              ),
            ],
          ),
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
      int? categoryId, TodoFilter filter) async {
    final todoService = TodoService();
    final allTodos = await todoService.getTodo();
    
    // 繰り返しTodoの表示フィルタリングを適用
    final filteredTodosWithRecurringDisplay = 
        await todoService.getFilteredTodosWithRecurringDisplay(
      currentDate: DateTime.now(),
      todos: allTodos,
    );
    
    // カテゴリでフィルタ
    var filteredData = categoryId == null
        ? filteredTodosWithRecurringDisplay
        : filteredTodosWithRecurringDisplay.where((todo) => todo.categoryId == categoryId).toList();
    
    // 状態でフィルタ
    switch (filter) {
      case TodoFilter.completed:
        filteredData = filteredData.where((todo) => todo.isCompleted).toList();
        break;
      case TodoFilter.incomplete:
        filteredData = filteredData.where((todo) => !todo.isCompleted).toList();
        break;
      case TodoFilter.all:
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
