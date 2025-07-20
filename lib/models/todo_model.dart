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
    @Default(false) bool isDeleted, // 論理削除フラグ
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  /// TodoエンティティからTodoModelに変換するファクトリコンストラクタ
  /// オプショナルパラメータで特定のフィールドを上書き可能
  factory TodoModel.fromTodo(Todo todo) {
    return TodoModel(
      id: todo.id,
      dueDate: todo.dueDate,
      title: todo.title,
      isCompleted: todo.isCompleted,
      description: todo.description,
      color: todo.color,
      categoryId: todo.categoryId,
      icon: todo.icon,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
      isRecurring: todo.isRecurring,
      recurringType: (RecurringType.fromString(
              todo.recurringType ?? RecurringType.daily.name) ??
          RecurringType.daily),
      recurringEndDate: todo.recurringEndDate,
      parentTodoId: todo.parentTodoId,
      timerType: TimerTypeExtension.fromString(todo.timerType),
      countupElapsedSeconds: todo.countupElapsedSeconds,
      pomodoroWorkMinutes: todo.pomodoroWorkMinutes,
      pomodoroShortBreakMinutes: todo.pomodoroShortBreakMinutes,
      pomodoroLongBreakMinutes: todo.pomodoroLongBreakMinutes,
      pomodoroCycle: todo.pomodoroCycle,
      pomodoroCompletedCycle: todo.pomodoroCompletedCycle,
      // isDeleted: todo.isDeleted ?? false, // Driftコード生成前のため一時的にコメントアウト
    );
  }
}
