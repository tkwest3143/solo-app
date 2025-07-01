import 'package:freezed_annotation/freezed_annotation.dart';

part 'build/work_setting.freezed.dart';
part 'build/work_setting.g.dart';

@freezed
class WorkSetting with _$WorkSetting {
  const factory WorkSetting({
    required int id,
    required String title,
    required DateTime start,
    required DateTime end,
    required DateTime restStart,
    required DateTime restEnd,
    String? memo,
    required int workingUnit,
    required int userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WorkSetting;

  factory WorkSetting.fromJson(Map<String, dynamic> json) =>
      _$WorkSettingFromJson(json);
}
