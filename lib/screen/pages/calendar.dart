import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/widgets/todo/add_todo_dialog.dart';
import 'package:solo/screen/widgets/todo/todo_card.dart';
import 'package:solo/screen/widgets/todo/todo_filter_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/utilities/date.dart';

class CalendarPage extends HookConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = useState<DateTime>(DateTime.now());
    final focusedDay = useState<DateTime>(DateTime.now());
    final selectedCategory = useState<int?>(null);
    final selectedStatus = useState<String?>(null);
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
              padding: const EdgeInsets.all(5),
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
                            initialCategoryId: selectedCategory.value,
                            initialStatus: selectedStatus.value,
                          );
                          if (selected != null) {
                            selectedCategory.value = selected['categoryId'];
                            selectedStatus.value = selected['status'];
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Theme.of(context).colorScheme.surface,
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
                                (selectedCategory.value != null ||
                                        selectedStatus.value != null)
                                    ? '絞り込みあり'
                                    : '絞り込みなし',
                                style: TextStyle(
                                  color: (selectedCategory.value != null ||
                                          selectedStatus.value != null)
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondaryTextColor,
                                  fontSize: 14,
                                  fontWeight: (selectedCategory.value != null ||
                                          selectedStatus.value != null)
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              Icon(
                                (selectedCategory.value != null ||
                                        selectedStatus.value != null)
                                    ? Icons.filter_alt
                                    : Icons.filter_alt_outlined,
                                color: (selectedCategory.value != null ||
                                        selectedStatus.value != null)
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondaryTextColor,
                              ),
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
                              .withValues(alpha: 0.2),
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
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.surface,
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
                                final dateKey =
                                    DateTime(day.year, day.month, day.day);
                                List<TodoModel> events =
                                    todosByDate[dateKey] ?? [];
                                // カレンダーのフィルター条件をここでも適用
                                if (selectedCategory.value != null) {
                                  events = events
                                      .where((todo) =>
                                          todo.categoryId ==
                                          selectedCategory.value)
                                      .toList();
                                }
                                if (selectedStatus.value != null) {
                                  if (selectedStatus.value == 'completed') {
                                    events = events
                                        .where(
                                            (todo) => todo.isCompleted == true)
                                        .toList();
                                  } else if (selectedStatus.value ==
                                      'incomplete') {
                                    events = events
                                        .where(
                                            (todo) => todo.isCompleted != true)
                                        .toList();
                                  }
                                }
                                return events;
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
                                markerMargin: const EdgeInsets.only(bottom: 4),
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
                                  final now = DateTime.now();
                                  final isSelected =
                                      isSameDay(selectedDay.value, day);
                                  final isToday = day.year == now.year &&
                                      day.month == now.month &&
                                      day.day == now.day;
                                  final isFiltered =
                                      selectedCategory.value != null ||
                                          selectedStatus.value != null;
                                  // events からフィルター条件に合致したTodoのみ抽出（dueDateフィルタは不要）
                                  List<TodoModel> filteredEvents =
                                      events.cast<TodoModel>();
                                  if (isFiltered) {
                                    if (selectedCategory.value != null) {
                                      filteredEvents = filteredEvents
                                          .where((todo) =>
                                              todo.categoryId ==
                                              selectedCategory.value)
                                          .toList();
                                    }
                                    if (selectedStatus.value != null) {
                                      if (selectedStatus.value == 'completed') {
                                        filteredEvents = filteredEvents
                                            .where((todo) =>
                                                todo.isCompleted == true)
                                            .toList();
                                      } else if (selectedStatus.value ==
                                          'incomplete') {
                                        filteredEvents = filteredEvents
                                            .where((todo) =>
                                                todo.isCompleted != true)
                                            .toList();
                                      }
                                    }
                                  }
                                  if (isSelected || isToday) {
                                    return const SizedBox
                                        .shrink(); // 枠線と重なる日付にはマーカーを表示しない
                                  }
                                  // フィルター後のTodoがなければマーカーを表示しない
                                  if (filteredEvents.isEmpty) {
                                    return null;
                                  }
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(bottom: 2),
                                      decoration: BoxDecoration(
                                        color: _getMarkerColor(
                                            context, filteredEvents),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              onDaySelected: (selected, focused) {
                                selectedDay.value = selected;
                                focusedDay.value = focused;
                                // 日付タップ時にその日のTodoリストをBottomSheetで表示（高さ: 画面1/3、内部スクロール）
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    final height =
                                        MediaQuery.of(context).size.height *
                                            0.4;
                                    return Container(
                                      height: height,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(28)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .mediumShadowColor,
                                            blurRadius: 24,
                                            offset: const Offset(0, -8),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.only(
                                          top: 4, left: 0, right: 0, bottom: 4),
                                      child: SafeArea(
                                        child: _buildSelectedDayTodosSheet(
                                          context,
                                          selected,
                                          selectedCategory.value,
                                          selectedStatus.value,
                                          refreshTodos,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              onPageChanged: (focused) {
                                focusedDay.value = focused;
                              },
                            );
                          },
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

  Color? _getMarkerColor(BuildContext context, List<TodoModel> todos) {
    if (todos.isEmpty) return null;
    final hasIncomplete = todos.any((todo) => !todo.isCompleted);
    final allCompleted =
        todos.isNotEmpty && todos.every((todo) => todo.isCompleted);
    if (hasIncomplete) {
      return Theme.of(context).colorScheme.primary;
    } else if (allCompleted) {
      return Colors.grey;
    }
    return null;
  }

  Widget _buildSelectedDayTodosSheet(BuildContext context, DateTime selectedDay,
      int? categoryFilter, String? statusFilter, VoidCallback onRefresh) {
    return FutureBuilder<List<TodoModel>>(
      future: TodoService().getTodosForDate(selectedDay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        var todos = snapshot.data ?? [];
        if (categoryFilter != null) {
          todos =
              todos.where((todo) => todo.categoryId == categoryFilter).toList();
        }
        if (statusFilter != null) {
          if (statusFilter == 'completed') {
            todos = todos.where((todo) => todo.isCompleted == true).toList();
          } else if (statusFilter == 'incomplete') {
            todos = todos.where((todo) => todo.isCompleted != true).toList();
          }
        }
        if (todos.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Center(
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
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await AddTodoDialog.show(context,
                          initialDate: selectedDay, onSaved: onRefresh);
                    },
                    icon: Icon(Icons.add_circle_rounded,
                        color: Theme.of(context).colorScheme.primary, size: 28),
                    label: const Text('追加する',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor:
                          Theme.of(context).colorScheme.primaryTextColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                      backgroundColor: Theme.of(context).colorScheme.surface,
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
            const Divider(height: 1),
            SizedBox(height: 8),
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
