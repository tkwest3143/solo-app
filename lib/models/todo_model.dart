import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solo/enums/recurring_type.dart';
import 'package:solo/enums/timer_type.dart';
import 'package:solo/models/todo_checklist_item_model.dart';
import 'package:solo/repositories/database/drift.dart';

part 'build/todo_model.freezed.dart';
part 'build/todo_model.g.dart';

@freezed
sealed class TodoModel with _$TodoModel {
  const factory TodoModel({
    required int id,
    required DateTime dueDate,
    required String title,
    required bool isCompleted,
    String? description,
    String? color, // Keep for backward compatibility
    int? categoryId, // New category reference
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Recurring fields
    bool? isRecurring,
    @Default(RecurringType.daily) RecurringType recurringType,
    DateTime? recurringEndDate,
    int? recurringDayOfWeek, // 1-7 for weekly (Monday = 1)
    int? recurringDayOfMonth, // 1-31 for monthly
    int? parentTodoId,
    @Default([])
    List<TodoCheckListItemModel> checklistItem, // Optional checklist item
    @Default(TimerType.none)
    TimerType timerType, // 'none', 'pomodoro', 'countup'
    int? countupElapsedSeconds, // For countup timer
    int? pomodoroWorkMinutes, // For pomodoro timer
    int? pomodoroShortBreakMinutes, // For short break
    int? pomodoroLongBreakMinutes, // For long break
    int? pomodoroCycle, // Number of pomodoro cycles
    int? pomodoroCompletedCycle, // Completed pomodoro cycles
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  /// TodoエンティティからTodoModelに変換するファクトリコンストラクタ
  /// オプショナルパラメータで特定のフィールドを上書き可能
  factory TodoModel.fromTodo(
    Todo todo, {
    int? id,
    DateTime? dueDate,
    String? title,
    bool? isCompleted,
    String? description,
    String? color,
    int? categoryId,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRecurring,
    RecurringType? recurringType,
    DateTime? recurringEndDate,
    int? recurringDayOfWeek,
    int? recurringDayOfMonth,
    int? parentTodoId,
    List<TodoCheckListItemModel>? checklistItem,
    TimerType? timerType,
    int? countupElapsedSeconds,
    int? pomodoroWorkMinutes,
    int? pomodoroShortBreakMinutes,
    int? pomodoroLongBreakMinutes,
    int? pomodoroCycle,
    int? pomodoroCompletedCycle,
  }) {
    return TodoModel(
      id: id ?? todo.id,
      dueDate: dueDate ?? todo.dueDate,
      title: title ?? todo.title,
      isCompleted: isCompleted ?? todo.isCompleted,
      description: description ?? todo.description,
      color: color ?? todo.color,
      categoryId: categoryId ?? todo.categoryId,
      icon: icon ?? todo.icon,
      createdAt: createdAt ?? todo.createdAt,
      updatedAt: updatedAt ?? todo.updatedAt,
      isRecurring: isRecurring ?? todo.isRecurring,
      recurringType: recurringType ??
          (RecurringType.fromString(
                  todo.recurringType ?? RecurringType.daily.name) ??
              RecurringType.daily),
      recurringEndDate: recurringEndDate ?? todo.recurringEndDate,
      recurringDayOfWeek: recurringDayOfWeek ?? todo.recurringDayOfWeek,
      recurringDayOfMonth: recurringDayOfMonth ?? todo.recurringDayOfMonth,
      parentTodoId: parentTodoId ?? todo.parentTodoId,
      checklistItem: checklistItem ?? [],
      timerType: timerType ?? TimerTypeExtension.fromString(todo.timerType),
      countupElapsedSeconds: countupElapsedSeconds ?? todo.countupElapsedSeconds,
      pomodoroWorkMinutes: pomodoroWorkMinutes ?? todo.pomodoroWorkMinutes,
      pomodoroShortBreakMinutes: pomodoroShortBreakMinutes ?? todo.pomodoroShortBreakMinutes,
      pomodoroLongBreakMinutes: pomodoroLongBreakMinutes ?? todo.pomodoroLongBreakMinutes,
      pomodoroCycle: pomodoroCycle ?? todo.pomodoroCycle,
      pomodoroCompletedCycle: pomodoroCompletedCycle ?? todo.pomodoroCompletedCycle,
    );
  }
}
