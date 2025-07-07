// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoModel _$TodoModelFromJson(Map<String, dynamic> json) => _TodoModel(
      id: (json['id'] as num).toInt(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      description: json['description'] as String?,
      color: json['color'] as String?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      icon: json['icon'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isRecurring: json['isRecurring'] as bool?,
      recurringType: json['recurringType'] as String?,
      recurringEndDate: json['recurringEndDate'] == null
          ? null
          : DateTime.parse(json['recurringEndDate'] as String),
      recurringDayOfWeek: (json['recurringDayOfWeek'] as num?)?.toInt(),
      recurringDayOfMonth: (json['recurringDayOfMonth'] as num?)?.toInt(),
      parentTodoId: (json['parentTodoId'] as num?)?.toInt(),
      checklistItem: (json['checklistItem'] as List<dynamic>?)
              ?.map((e) =>
                  TodoCheckListItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TodoModelToJson(_TodoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dueDate': instance.dueDate.toIso8601String(),
      'title': instance.title,
      'isCompleted': instance.isCompleted,
      'description': instance.description,
      'color': instance.color,
      'categoryId': instance.categoryId,
      'icon': instance.icon,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isRecurring': instance.isRecurring,
      'recurringType': instance.recurringType,
      'recurringEndDate': instance.recurringEndDate?.toIso8601String(),
      'recurringDayOfWeek': instance.recurringDayOfWeek,
      'recurringDayOfMonth': instance.recurringDayOfMonth,
      'parentTodoId': instance.parentTodoId,
      'checklistItem': instance.checklistItem,
    };
