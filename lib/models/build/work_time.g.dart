// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../work_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkTimeImpl _$$WorkTimeImplFromJson(Map<String, dynamic> json) =>
    _$WorkTimeImpl(
      id: (json['id'] as num).toInt(),
      targetDay: json['targetDay'] as String,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      restStart: json['restStart'] == null
          ? null
          : DateTime.parse(json['restStart'] as String),
      restEnd: json['restEnd'] == null
          ? null
          : DateTime.parse(json['restEnd'] as String),
      memo: json['memo'] as String?,
      userId: (json['userId'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WorkTimeImplToJson(_$WorkTimeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'targetDay': instance.targetDay,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'restStart': instance.restStart?.toIso8601String(),
      'restEnd': instance.restEnd?.toIso8601String(),
      'memo': instance.memo,
      'userId': instance.userId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
