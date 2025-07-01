import 'package:freezed_annotation/freezed_annotation.dart';

part 'build/japanese_holiday.freezed.dart';
part 'build/japanese_holiday.g.dart';

@freezed
class JapaneseHoliday with _$JapaneseHoliday {
  const factory JapaneseHoliday({
    required int id,
    required String targetDay,
    required String name,
    String? memo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _JapaneseHoliday;

  factory JapaneseHoliday.fromJson(Map<String, dynamic> json) =>
      _$JapaneseHolidayFromJson(json);
}
