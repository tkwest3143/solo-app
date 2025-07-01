import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solo/models/work_setting.dart';
import 'package:solo/services/work_setting_service.dart';

part 'build/work_setting_add.g.dart';

class WorkSettingAddStateData {
  int? userId;
  String? title;
  DateTime? start;
  DateTime? end;
  DateTime? restStart;
  DateTime? restEnd;
  int? workingUnit;
  String? memo;
}

@riverpod
class WorkSettingAddState extends _$WorkSettingAddState {
  @override
  WorkSettingAddStateData build() => WorkSettingAddStateData();
  clear() {
    state = WorkSettingAddStateData();
  }

  update({
    int? userId,
    String? title,
    DateTime? start,
    DateTime? end,
    DateTime? restStart,
    DateTime? restEnd,
    int? workingUnit,
    String? memo,
  }) {
    state = WorkSettingAddStateData()
      ..userId = userId ?? state.userId
      ..title = title ?? state.title
      ..start = start ?? state.start
      ..end = end ?? state.end
      ..restStart = restStart ?? state.restStart
      ..restEnd = restEnd ?? state.restEnd
      ..workingUnit = workingUnit ?? state.workingUnit
      ..memo = memo ?? state.memo;
  }

  onSave() async {
    if (state.title == null || state.title!.isEmpty) {
      Exception('Title is null');
    }
    if (state.start == null) {
      Exception('Start is null');
    }
    if (state.end == null) {
      Exception('End is null');
    }
    if (state.restStart == null) {
      Exception('RestStart is null');
    }
    if (state.restEnd == null) {
      Exception('RestEnd is null');
    }
    if (state.workingUnit == null) {
      Exception('WorkingUnit is null');
    }
    if (state.userId == null) {
      Exception('UserId is null');
    }

    final service = WorkSettingService();
    await service.saveWorkSetting(WorkSetting(
      id: -1,
      userId: state.userId!,
      title: state.title!,
      start: state.start!,
      end: state.end!,
      restStart: state.restStart!,
      restEnd: state.restEnd!,
      workingUnit: state.workingUnit!,
      memo: state.memo,
    ));
  }
}
