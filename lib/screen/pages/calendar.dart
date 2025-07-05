import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).colorScheme.lightShadowColor,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: selectedCategory.value,
                          hint: Text(
                            'カテゴリで絞り込み',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('すべて'),
                            ),
                            const DropdownMenuItem<String>(
                              value: 'blue',
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      radius: 8, backgroundColor: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('ブルー'),
                                ],
                              ),
                            ),
                            const DropdownMenuItem<String>(
                              value: 'orange',
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.orange),
                                  SizedBox(width: 8),
                                  Text('オレンジ'),
                                ],
                              ),
                            ),
                            const DropdownMenuItem<String>(
                              value: 'green',
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      radius: 8, backgroundColor: Colors.green),
                                  SizedBox(width: 8),
                                  Text('グリーン'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            selectedCategory.value = value;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Add Todo Button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: Theme.of(context).colorScheme.primaryGradient,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).colorScheme.mediumShadowColor,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => AddTodoDialog.show(
                        context,
                        initialDate: selectedDay.value,
                        onSaved: refreshTodos,
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Calendar
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.lightShadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Calendar widget
                    ValueListenableBuilder<int>(
                      valueListenable: refreshKey,
                      builder: (context, _, __) => FutureBuilder<Map<DateTime, List<TodoModel>>>(
                        future: todoService.getTodosForMonth(focusedDay.value),
                        builder: (context, snapshot) {
                          final todosByDate = snapshot.data ?? {};

                          return TableCalendar<TodoModel>(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: focusedDay.value,
                            selectedDayPredicate: (day) =>
                                isSameDay(selectedDay.value, day),
                            eventLoader: (day) {
                              final dateKey =
                                  DateTime(day.year, day.month, day.day);
                              final todos = todosByDate[dateKey] ?? [];
                              if (selectedCategory.value != null) {
                                return todos
                                    .where((todo) =>
                                        todo.color == selectedCategory.value)
                                    .toList();
                              }
                              return todos;
                            },
                            calendarStyle: CalendarStyle(
                              outsideDaysVisible: false,
                              weekendTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.errorColor,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryGradient
                                    .first
                                    .withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: Theme.of(context)
                                      .colorScheme
                                      .primaryGradient,
                                ),
                                shape: BoxShape.circle,
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
                    Expanded(
                      child: ValueListenableBuilder<int>(
                        valueListenable: refreshKey,
                        builder: (context, _, __) => _buildSelectedDayTodos(
                            context, selectedDay.value, selectedCategory.value, refreshTodos),
                      ),
                    ),
                  ],
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

    return Positioned(
      bottom: 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < (todos.length > 3 ? 3 : todos.length); i++)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _getColorFromString(todos[i].color),
                shape: BoxShape.circle,
              ),
            ),
          if (todos.length > 3)
            Container(
              margin: const EdgeInsets.only(left: 2),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryGradient.first,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${todos.length - 3}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayTodos(
      BuildContext context, DateTime selectedDay, String? categoryFilter, VoidCallback onRefresh) {
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
              child: Text(
                '${formatDate(selectedDay, format: 'M月d日(EEE)')}のTodo (${todos.length}件)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primaryTextColor,
                ),
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
}
