import 'package:freezed_annotation/freezed_annotation.dart';

part 'build/todo_model.freezed.dart';
part 'build/todo_model.g.dart';

@freezed
class TodoModel with _$TodoModel {
  const factory TodoModel({
    required int id,
    required DateTime dueDate,
    required String title,
    required bool isCompleted,
    String? description,
    String? color,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Recurring fields
    bool? isRecurring,
    String? recurringType,
    DateTime? recurringEndDate,
    int? recurringDayOfWeek, // 1-7 for weekly (Monday = 1)
    int? recurringDayOfMonth, // 1-31 for monthly
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}
