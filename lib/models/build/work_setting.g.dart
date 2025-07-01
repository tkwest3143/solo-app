// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../work_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkSettingImpl _$$WorkSettingImplFromJson(Map<String, dynamic> json) =>
    _$WorkSettingImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      restStart: DateTime.parse(json['restStart'] as String),
      restEnd: DateTime.parse(json['restEnd'] as String),
      memo: json['memo'] as String?,
      workingUnit: (json['workingUnit'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WorkSettingImplToJson(_$WorkSettingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'restStart': instance.restStart.toIso8601String(),
      'restEnd': instance.restEnd.toIso8601String(),
      'memo': instance.memo,
      'workingUnit': instance.workingUnit,
      'userId': instance.userId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
