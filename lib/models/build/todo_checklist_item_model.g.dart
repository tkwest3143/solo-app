// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../todo_checklist_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoCheckListItemModel _$TodoCheckListItemModelFromJson(
        Map<String, dynamic> json) =>
    _TodoCheckListItemModel(
      id: (json['id'] as num).toInt(),
      todoId: (json['todoId'] as num).toInt(),
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      order: (json['order'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TodoCheckListItemModelToJson(
        _TodoCheckListItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'todoId': instance.todoId,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
      'order': instance.order,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
