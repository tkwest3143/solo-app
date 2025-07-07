import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solo/models/todo_checklist_item_model.dart';

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
    String? recurringType,
    DateTime? recurringEndDate,
    int? recurringDayOfWeek, // 1-7 for weekly (Monday = 1)
    int? recurringDayOfMonth, // 1-31 for monthly
    int? parentTodoId,
    @Default([])
    List<TodoCheckListItemModel> checklistItem, // Optional checklist item
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}
