import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/utilities/date.dart';
import 'package:solo/screen/widgets/todo.dart';

class CalendarPage extends HookConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = useState<DateTime>(DateTime.now());
    final focusedDay = useState<DateTime>(DateTime.now());
    final selectedCategory = useState<String?>(null);
    final selectedStatus = useState<String?>(null); // ステータスフィルタ用
    final todoService = useMemoized(() => TodoService());
    final refreshKey = useState<int>(0);

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
            // Header with category filter and add button
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1行目：リストに戻るボタンとTodo追加ボタン
                  Row(
                    children: [
                      // 2行目：絞り込み
                      GestureDetector(
                        onTap: () async {
                          final selected = await showTodoFilterDialog(
                            context: context,
                            initialColor: selectedCategory.value,
                            initialStatus: selectedStatus.value,
                          );
                          if (selected != null) {
                            selectedCategory.value = selected['color'];
                            selectedStatus.value = selected['status'];
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Theme.of(context).colorScheme.surface, // ←修正
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .lightShadowColor,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '絞り込み',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryTextColor,
                                  fontSize: 14,
                                ),
                              ),
                              const Icon(Icons.filter_alt),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          nextRouting(context, RouterDefinition.todoList);
                        },
                        icon: Icon(
                          Icons.list_alt_rounded,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.2), // ←修正
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Calendar
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.surface, // ←修正
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.lightShadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Calendar widget
                      ValueListenableBuilder<int>(
                        valueListenable: refreshKey,
                        builder: (context, _, __) =>
                            FutureBuilder<Map<DateTime, List<TodoModel>>>(
                          future:
                              todoService.getTodosForMonth(focusedDay.value),
                          builder: (context, snapshot) {
                            final todosByDate = snapshot.data ?? {};

                            return TableCalendar<TodoModel>(
                              locale: 'ja',
                              firstDay: DateTime.utc(2020, 1, 1),
                              lastDay: DateTime.utc(2030, 12, 31),
                              focusedDay: focusedDay.value,
                              selectedDayPredicate: (day) =>
                                  isSameDay(selectedDay.value, day),
                              eventLoader: (day) {
                                // 日付に紐づくTodoを取得
                                return todosByDate[day] ?? [];
                              },
                              calendarStyle: CalendarStyle(
                                defaultDecoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.rectangle,
                                ),
                                weekendDecoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.rectangle,
                                ),
                                outsideDaysVisible: false,
                                weekendTextStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.errorColor,
                                ),
                                todayDecoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryGradient
                                      .first
                                      .withValues(alpha: 0.3),
                                  shape: BoxShape.rectangle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .calendarSelectedDayColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                ),
                                selectedTextStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                markerDecoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryGradient
                                      .last,
                                  shape: BoxShape.circle,
                                ),
                                markersMaxCount: 1,
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                leftChevronIcon: Icon(
                                  Icons.chevron_left,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryGradient
                                      .first,
                                ),
                                rightChevronIcon: Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryGradient
                                      .first,
                                ),
                                titleTextStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor,
                                ),
                              ),
                              calendarBuilders: CalendarBuilders(
                                markerBuilder: (context, day, events) {
                                  if (events.isNotEmpty) {
                                    return _buildTodoMarkers(
                                        context, events.cast<TodoModel>());
                                  }
                                  return null;
                                },
                              ),
                              onDaySelected: (selected, focused) {
                                selectedDay.value = selected;
                                focusedDay.value = focused;
                              },
                              onPageChanged: (focused) {
                                focusedDay.value = focused;
                              },
                            );
                          },
                        ),
                      ),

                      // Selected day's todos
                      SizedBox(
                        height: 320,
                        child: ValueListenableBuilder<int>(
                          valueListenable: refreshKey,
                          builder: (context, _, __) => _buildSelectedDayTodos(
                              context,
                              selectedDay.value,
                              selectedCategory.value,
                              selectedStatus.value, // ステータスも渡す
                              refreshTodos),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoMarkers(BuildContext context, List<TodoModel> todos) {
    if (todos.isEmpty) return const SizedBox.shrink();

    final hasIncomplete = todos.any((todo) => !todo.isCompleted);
    final allCompleted =
        todos.isNotEmpty && todos.every((todo) => todo.isCompleted);

    Color markerColor;
    if (hasIncomplete) {
      markerColor = Theme.of(context).colorScheme.primary; // 未完了があれば青系
    } else if (allCompleted) {
      markerColor = Colors.grey; // 全て完了ならグレー
    } else {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 2,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDayTodos(BuildContext context, DateTime selectedDay,
      String? categoryFilter, String? statusFilter, VoidCallback onRefresh) {
    return FutureBuilder<List<TodoModel>>(
      future: TodoService().getTodosForDate(selectedDay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var todos = snapshot.data ?? [];
        if (categoryFilter != null) {
          todos = todos.where((todo) => todo.color == categoryFilter).toList();
        }
        if (statusFilter != null) {
          if (statusFilter == 'completed') {
            todos = todos.where((todo) => todo.isCompleted == true).toList();
          } else if (statusFilter == 'incomplete') {
            todos = todos.where((todo) => todo.isCompleted != true).toList();
          }
        }

        if (todos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_available,
                  size: 48,
                  color: Theme.of(context).colorScheme.mutedTextColor,
                ),
                const SizedBox(height: 8),
                Text(
                  '${formatDate(selectedDay, format: 'M月d日(EEE)')}のTodoはありません',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.mutedTextColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    '${formatDate(selectedDay, format: 'M月d日(EEE)')}のTodo (${todos.length}件)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await AddTodoDialog.show(context,
                          initialDate: selectedDay, onSaved: onRefresh);
                    },
                    icon: Icon(Icons.add_circle_rounded,
                        color: Theme.of(context).colorScheme.primary, size: 20),
                    label: const Text('追加',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.surface, // ←修正
                      foregroundColor:
                          Theme.of(context).colorScheme.primaryTextColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return TodoCard(
                    todo: todo,
                    onRefresh: onRefresh,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
