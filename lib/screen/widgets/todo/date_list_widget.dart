import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';

/// 横スクロール可能な日付リスト表示ウィジェット
class DateListWidget extends HookConsumerWidget {
  const DateListWidget({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onDateSelected,
  });

  /// 表示中の月
  final DateTime focusedMonth;
  
  /// 選択中の日付
  final DateTime selectedDate;
  
  /// 日付選択時のコールバック
  final Function(DateTime) onDateSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    
    // 月の日数を取得
    final daysInMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    
    // 初期表示時に選択日を中央に配置
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          final selectedDay = selectedDate.day;
          final itemWidth = 60.0; // 各日付アイテムの幅
          final viewportWidth = MediaQuery.of(context).size.width;
          final targetOffset = (selectedDay - 1) * itemWidth - (viewportWidth / 2) + (itemWidth / 2);
          
          scrollController.animateTo(
            targetOffset.clamp(0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
      return null;
    }, [selectedDate]);

    return Container(
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
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: daysInMonth,
        itemBuilder: (context, index) {
          final day = index + 1;
          final date = DateTime(focusedMonth.year, focusedMonth.month, day);
          final isSelected = date.day == selectedDate.day && 
                           date.month == selectedDate.month && 
                           date.year == selectedDate.year;
          final isToday = _isToday(date);
          
          return _buildDateItem(
            context,
            date,
            day,
            isSelected,
            isToday,
          );
        },
      ),
    );
  }

  Widget _buildDateItem(
    BuildContext context,
    DateTime date,
    int day,
    bool isSelected,
    bool isToday,
  ) {
    final weekday = date.weekday;
    Color textColor;
    
    // 土曜日は青色、日曜は赤色、それ以外は黒
    if (weekday == DateTime.saturday) {
      textColor = Colors.blue;
    } else if (weekday == DateTime.sunday) {
      textColor = Colors.red;
    } else {
      textColor = Theme.of(context).colorScheme.primaryTextColor;
    }

    return Container(
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: GestureDetector(
        onTap: () => onDateSelected(date),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : isToday 
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isToday && !isSelected 
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getWeekdayText(weekday),
                style: TextStyle(
                  color: isSelected 
                      ? Colors.white 
                      : textColor.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                day.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : textColor,
                  fontSize: 16,
                  fontWeight: isSelected || isToday 
                      ? FontWeight.bold 
                      : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
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