import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/utilities/date.dart';

/// 横スクロール可能な日付リスト表示ウィジェット
class DateListWidget extends HookConsumerWidget {
  const DateListWidget({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onBackToCalendar,
  });

  /// 表示中の月
  final DateTime focusedMonth;

  /// 選択中の日付
  final DateTime selectedDate;

  /// 日付選択時のコールバック
  final Function(DateTime) onDateSelected;

  /// カレンダー表示に戻るコールバック
  final VoidCallback onBackToCalendar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final todoService = useMemoized(() => TodoService());

    // 前月、当月、次月の日付リストを作成
    final dateList =
        useMemoized(() => _createDateList(focusedMonth), [focusedMonth]);

    // 中央に表示されている日付を監視
    final centerDate = useState<DateTime>(selectedDate);

    // focusedMonthが変更された時にcenterDateを更新
    useEffect(() {
      centerDate.value = selectedDate;
      return null;
    }, [focusedMonth, selectedDate]);

    // 初期表示時に選択日を中央に配置
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          _scrollToDateInList(
              scrollController, selectedDate, dateList, context);
        }
      });
      return null;
    }, [selectedDate, focusedMonth]); // focusedMonthも依存関係に追加

    // スクロール監視して中央の日付を更新
    useEffect(() {
      void updateCenterDate() {
        if (scrollController.hasClients) {
          final viewportWidth = MediaQuery.of(context).size.width;
          final itemWidth = 60.0; // 各日付アイテムの幅
          final itemMargin = 8.0; // 左右のマージン（4 * 2）
          final totalItemWidth = itemWidth + itemMargin;

          // 実際の中央位置を計算（パディングを考慮）
          final centerOffset = scrollController.offset + (viewportWidth / 2);
          final adjustedCenterOffset = centerOffset - 8.0; // パディングを調整
          final centerIndex = (adjustedCenterOffset / totalItemWidth).round();

          // インデックスが有効範囲内で、実際に画面に表示されている場合のみ更新
          if (centerIndex >= 0 && centerIndex < dateList.length) {
            // 現在の中央に表示されているアイテムの位置を計算
            final itemPosition =
                centerIndex * totalItemWidth + (totalItemWidth / 2);
            final leftBound = scrollController.offset;
            final rightBound = scrollController.offset + viewportWidth;

            // アイテムが実際に画面に表示されているか確認
            if (itemPosition >= leftBound && itemPosition <= rightBound) {
              final newCenterDate = dateList[centerIndex];
              if (newCenterDate != centerDate.value) {
                centerDate.value = newCenterDate;
              }
            }
          }
        }
      }

      scrollController.addListener(updateCenterDate);
      return () => scrollController.removeListener(updateCenterDate);
    }, [scrollController, focusedMonth]);

    return Column(
      children: [
        // 月表示ヘッダー
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // カレンダー表示に戻るボタン
              IconButton(
                onPressed: onBackToCalendar,
                icon: Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.all(4),
                  minimumSize: const Size(32, 32),
                ),
              ),

              // 月表示（中央寄せ）
              Expanded(
                child: Text(
                  formatDate(centerDate.value, format: 'yyyy年MM月'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                ),
              ),

              // 右側のスペース（バランス調整用）
              const SizedBox(width: 40),
            ],
          ),
        ),

        // 日付リスト
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.lightShadowColor,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: FutureBuilder<Map<DateTime, List<TodoModel>>>(
            key: ValueKey(
                'todos-${focusedMonth.year}-${focusedMonth.month}'), // キーを追加してリビルドを強制
            future: _getTodosForDateRange(todoService, dateList),
            builder: (context, snapshot) {
              final todosByDate = snapshot.data ?? {};

              return ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: dateList.length,
                itemBuilder: (context, index) {
                  final date = dateList[index];
                  final isSelected = date.day == selectedDate.day &&
                      date.month == selectedDate.month &&
                      date.year == selectedDate.year;
                  final isToday = _isToday(date);

                  // その日のTodoを取得
                  final dateKey = DateTime(date.year, date.month, date.day);
                  final todosForDate = todosByDate[dateKey] ?? [];

                  return _buildDateItem(
                    context,
                    date,
                    date.day,
                    isSelected,
                    isToday,
                    todosForDate,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// 前月、当月、次月の日付リストを作成
  List<DateTime> _createDateList(DateTime focusedMonth) {
    final List<DateTime> dateList = [];

    // 前月の最後の15日
    final prevMonth = DateTime(focusedMonth.year, focusedMonth.month - 1);
    final prevMonthDays = DateTime(prevMonth.year, prevMonth.month + 1, 0).day;
    for (int i = prevMonthDays - 14; i <= prevMonthDays; i++) {
      dateList.add(DateTime(prevMonth.year, prevMonth.month, i));
    }

    // 当月の全日
    final currentMonthDays =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    for (int i = 1; i <= currentMonthDays; i++) {
      dateList.add(DateTime(focusedMonth.year, focusedMonth.month, i));
    }

    // 次月の最初の15日
    final nextMonth = DateTime(focusedMonth.year, focusedMonth.month + 1);
    for (int i = 1; i <= 15; i++) {
      dateList.add(DateTime(nextMonth.year, nextMonth.month, i));
    }

    return dateList;
  }

  /// 日付範囲のTodoを取得
  Future<Map<DateTime, List<TodoModel>>> _getTodosForDateRange(
    TodoService todoService,
    List<DateTime> dateList,
  ) async {
    final Map<DateTime, List<TodoModel>> result = {};

    // 月ごとにグループ化
    final monthGroups = <String, List<DateTime>>{};
    for (final date in dateList) {
      final monthKey = '${date.year}-${date.month}';
      monthGroups[monthKey] ??= [];
      monthGroups[monthKey]!.add(date);
    }

    // 各月のTodoを取得
    for (final monthKey in monthGroups.keys) {
      final dates = monthGroups[monthKey]!;
      final monthDate = dates.first;
      final monthTodos = await todoService.getTodosForMonth(monthDate);
      result.addAll(monthTodos);
    }

    return result;
  }

  /// 指定した日付を中央に配置するようにスクロール（日付リスト用）
  void _scrollToDateInList(
    ScrollController controller,
    DateTime date,
    List<DateTime> dateList,
    BuildContext context,
  ) {
    if (controller.hasClients) {
      final index = dateList.indexWhere((d) =>
          d.year == date.year && d.month == date.month && d.day == date.day);

      if (index >= 0) {
        final itemWidth = 60.0; // 各日付アイテムの幅
        final itemMargin = 8.0; // 左右のマージン（4 * 2）
        final totalItemWidth = itemWidth + itemMargin;
        final viewportWidth = MediaQuery.of(context).size.width;
        final targetOffset =
            index * totalItemWidth - (viewportWidth / 2) + (totalItemWidth / 2);

        controller.animateTo(
          targetOffset.clamp(0.0, controller.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  Widget _buildDateItem(
    BuildContext context,
    DateTime date,
    int day,
    bool isSelected,
    bool isToday,
    List<TodoModel> todosForDate,
  ) {
    final weekday = date.weekday;
    final isSameMonth =
        date.month == focusedMonth.month && date.year == focusedMonth.year;

    Color textColor;

    // 土曜日は青色、日曜は赤色、それ以外は黒
    if (weekday == DateTime.saturday) {
      textColor = Colors.blue;
    } else if (weekday == DateTime.sunday) {
      textColor = Colors.red;
    } else {
      textColor = Theme.of(context).colorScheme.primaryTextColor;
    }

    // 他の月の日付は薄く表示
    if (!isSameMonth) {
      textColor = textColor.withValues(alpha: 0.4);
    }

    return Container(
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: GestureDetector(
        onTap: () => onDateSelected(date),
        child: Container(
          width: 60, // 明示的に幅を設定
          height: 64, // 明示的に高さを設定
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : isToday
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isToday && !isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  )
                : null,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // 水平方向の中央寄せ
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      _getWeekdayText(weekday),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : textColor.withValues(alpha: 0.7),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 60,
                    child: Text(
                      day.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : textColor,
                        fontSize: 16,
                        fontWeight: isSelected || isToday
                            ? FontWeight.bold
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              // Todoマーカー
              if (todosForDate.isNotEmpty)
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: _buildTodoMarkers(context, todosForDate, isSelected),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Todoマーカーを構築
  Widget _buildTodoMarkers(
      BuildContext context, List<TodoModel> todos, bool isSelected) {
    // 未完了と完了のTodoを分ける
    final hasIncomplete = todos.any((todo) => !todo.isCompleted);
    final hasCompleted =
        todos.isNotEmpty && todos.every((todo) => todo.isCompleted);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasIncomplete)
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        if (hasCompleted)
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  String _getWeekdayText(int weekday) {
    switch (weekday) {
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
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
