import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solo/utilities/date.dart';

part 'build/work_time.freezed.dart';
part 'build/work_time.g.dart';

@freezed
class WorkTime with _$WorkTime {
  const factory WorkTime({
    required int id,
    required String targetDay,
    DateTime? start,
    DateTime? end,
    DateTime? restStart,
    DateTime? restEnd,
    String? memo,
    required int userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WorkTime;

  factory WorkTime.fromJson(Map<String, dynamic> json) =>
      _$WorkTimeFromJson(json);
}

extension WorkTimeExtension on WorkTime {
  String get breakTime {
    if (restStart == null || restEnd == null) {
      return '';
    }
    final diff = restEnd!.difference(restStart!);
    final hour = diff.inHours;
    final minute = diff.inMinutes.remainder(60);
    return '$hour時間$minute分';
  }

  int get workingTime {
    if (start == null || end == null) {
      return 0;
    }
    final diff = end!.difference(start!);
    return diff.inMinutes;
  }

  DateTime get targetDayToDateTime {
    return parseDate(targetDay, format: "yyyy-MM-dd");
  }
}
