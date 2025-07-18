import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/widgets/todo/add_todo_dialog.dart';
import 'package:solo/screen/widgets/todo/todo_card.dart';
import 'package:solo/screen/widgets/todo/todo_filter_dialog.dart';
import 'package:solo/screen/widgets/todo/date_list_widget.dart';
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

    // 新しいUI状態管理
    final isDateListView =
        useState<bool>(false); // false: カレンダー表示, true: 日付リスト表示

    void refreshTodos() {
      refreshKey.value++;
    }

    void toggleToDateListView(DateTime selectedDate) {
      selectedDay.value = selectedDate;
      isDateListView.value = true;
    }

    void toggleToCalendarView() {
      isDateListView.value = false;
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
                    ],
                  ),
                ],
              ),
            ),

            // Calendar or Date List View
            Expanded(
              child: isDateListView.value
                  ? _buildDateListView(
                      context,
                      selectedDay.value,
                      focusedDay.value,
                      selectedCategory.value,
                      selectedStatus.value,
                      refreshTodos,
                      toggleToCalendarView,
                      (date) {
                        selectedDay.value = date;
                        // 選択された日付の月をfocusedDayに設定
                        focusedDay.value = DateTime(date.year, date.month, 1);
                        refreshTodos();
                      },
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).colorScheme.lightShadowColor,
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
                                future: todoService
                                    .getTodosForMonth(focusedDay.value),
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
                                      final dateKey = DateTime(
                                          day.year, day.month, day.day);
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
                                        if (selectedStatus.value ==
                                            'completed') {
                                          events = events
                                              .where((todo) =>
                                                  todo.isCompleted == true)
                                              .toList();
                                        } else if (selectedStatus.value ==
                                            'incomplete') {
                                          events = events
                                              .where((todo) =>
                                                  todo.isCompleted != true)
                                              .toList();
                                        }
                                      }
                                      return events;
                                    },
                                    calendarStyle: CalendarStyle(
                                      defaultDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      weekendDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      todayDecoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.7),
                                            Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.4),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.18),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      selectedDecoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.18),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 2,
                                        ),
                                      ),
                                      selectedTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      todayTextStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      weekendTextStyle: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      outsideDaysVisible: false,
                                      markerDecoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.18),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      markersMaxCount: 2,
                                      markerMargin:
                                          const EdgeInsets.only(bottom: 4),
                                    ),
                                    daysOfWeekStyle: DaysOfWeekStyle(
                                      weekdayStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      weekendStyle: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                      dowTextFormatter: (date, locale) {
                                        switch (date.weekday) {
                                          case DateTime.sunday:
                                            return '日';
                                          case DateTime.monday:
                                            return '月';
                                          case DateTime.tuesday:
                                            return '火';
                                          case DateTime.wednesday:
                                            return '水';
                                          case DateTime.thursday:
                                            return '木';
                                          case DateTime.friday:
                                            return '金';
                                          case DateTime.saturday:
                                            return '土';
                                          default:
                                            return '';
                                        }
                                      },
                                    ),
                                    headerStyle: HeaderStyle(
                                      formatButtonVisible: false,
                                      titleCentered: true,
                                      titleTextStyle: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor,
                                        letterSpacing: 1.2,
                                      ),
                                      leftChevronIcon: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.08),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.chevron_left,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 28,
                                        ),
                                      ),
                                      rightChevronIcon: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.08),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 28,
                                        ),
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
                                            if (selectedStatus.value ==
                                                'completed') {
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
                                          return const SizedBox.shrink();
                                        }
                                        if (filteredEvents.isEmpty) {
                                          return null;
                                        }
                                        // 未完了はprimary、完了はグレーで複数マーカー
                                        final hasIncomplete = filteredEvents
                                            .any((todo) => !todo.isCompleted);
                                        final hasCompleted = filteredEvents
                                            .any((todo) => todo.isCompleted);
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (hasIncomplete)
                                              Container(
                                                width: 9,
                                                height: 9,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 1),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withValues(
                                                              alpha: 0.18),
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (hasCompleted)
                                              Container(
                                                width: 9,
                                                height: 9,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 1),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withValues(
                                                              alpha: 0.18),
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                    onDaySelected: (selected, focused) {
                                      toggleToDateListView(selected);
                                      focusedDay.value = focused;
                                    },
                                    onPageChanged: (focused) {
                                      focusedDay.value = focused;
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              child: _buildFancyAddTodoButton(
                                  context, selectedDay.value, refreshTodos),
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

  /// おしゃれなTodo追加ボタン
  Widget _buildFancyAddTodoButton(
      BuildContext context, DateTime selectedDate, VoidCallback onRefresh) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () async {
                  // ボタンタップ時のアニメーション
                  HapticFeedback.lightImpact();
                  await AddTodoDialog.show(
                    context,
                    initialDate: selectedDate,
                    onSaved: onRefresh,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // プラスアイコンのアニメーション
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        builder: (context, iconValue, _) {
                          return Transform.rotate(
                            angle: iconValue * 2 * 3.14159,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      // テキスト
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDate(selectedDate, format: 'M月d日'),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            '新しいTodoを追加',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // 矢印アイコン
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 日付リスト表示のビューを構築
  Widget _buildDateListView(
    BuildContext context,
    DateTime selectedDate,
    DateTime focusedMonth,
    int? categoryFilter,
    String? statusFilter,
    VoidCallback onRefresh,
    VoidCallback onBackToCalendar,
    Function(DateTime) onDateSelected,
  ) {
    return Column(
      children: [
        // 日付リスト
        DateListWidget(
          focusedMonth: focusedMonth,
          selectedDate: selectedDate,
          onDateSelected: onDateSelected,
          onBackToCalendar: onBackToCalendar,
        ),

        // Todo一覧
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
            child: Column(
              children: [
                // ヘッダー
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        '${formatDate(selectedDate, format: 'M月d日(EEE)')}のTodo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await AddTodoDialog.show(
                            context,
                            initialDate: selectedDate,
                            onSaved: onRefresh,
                          );
                        },
                        icon: Icon(
                          Icons.add_circle_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        label: const Text(
                          '追加',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          foregroundColor:
                              Theme.of(context).colorScheme.primaryTextColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Todo一覧
                Expanded(
                  child: FutureBuilder<List<TodoModel>>(
                    key: ValueKey(
                        'todo-list-${selectedDate.year}-${selectedDate.month}-${selectedDate.day}'), // キーを追加
                    future: TodoService().getTodosForDate(selectedDate),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var todos = snapshot.data ?? [];

                      // フィルター適用
                      if (categoryFilter != null) {
                        todos = todos
                            .where((todo) => todo.categoryId == categoryFilter)
                            .toList();
                      }
                      if (statusFilter != null) {
                        if (statusFilter == 'completed') {
                          todos = todos
                              .where((todo) => todo.isCompleted == true)
                              .toList();
                        } else if (statusFilter == 'incomplete') {
                          todos = todos
                              .where((todo) => todo.isCompleted != true)
                              .toList();
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .mutedTextColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'この日のTodoはありません',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .mutedTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return TodoCard(
                            todo: todo,
                            onRefresh: onRefresh,
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
      ],
    );
  }
}
