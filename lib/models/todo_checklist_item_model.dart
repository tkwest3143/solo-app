import 'package:freezed_annotation/freezed_annotation.dart';

part 'build/todo_checklist_item_model.freezed.dart';
part 'build/todo_checklist_item_model.g.dart';

@freezed
class TodoCheckListItemModel with _$TodoCheckListItemModel {
  const factory TodoCheckListItemModel({
    required int id,
    required int todoId,
    required String title,
    required bool isCompleted,
    required int order, // For ordering checklist items
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TodoCheckListItemModel;

  factory TodoCheckListItemModel.fromJson(Map<String, dynamic> json) =>
      _$TodoCheckListItemModelFromJson(json);
}