// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../japanese_holiday.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JapaneseHolidayImpl _$$JapaneseHolidayImplFromJson(
        Map<String, dynamic> json) =>
    _$JapaneseHolidayImpl(
      id: (json['id'] as num).toInt(),
      targetDay: json['targetDay'] as String,
      name: json['name'] as String,
      memo: json['memo'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$JapaneseHolidayImplToJson(
        _$JapaneseHolidayImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'targetDay': instance.targetDay,
      'name': instance.name,
      'memo': instance.memo,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
