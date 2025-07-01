import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solo/models/work_time.dart';
import 'package:solo/services/work_time_service.dart';
import 'package:solo/utilities/date.dart';

part 'build/work_time_list.g.dart';

@riverpod
class WorkTimeListState extends _$WorkTimeListState {
  @override
  Future<List<WorkTime>> build(int userId) async {
    final today = DateTime.now();
    return await fetchWorkTimesByMonth(userId, today);
  }

  Future<List<WorkTime>> fetchWorkTimesByMonth(
      int userId, DateTime month) async {
    final workTimeService = WorkTimeService();
    final workTimes = await workTimeService.getWorkTimesByMonth(
        userId, formatDate(month, format: 'yyyy-MM'));
    print(workTimes);
    final allWorkTimes = List<WorkTime>.generate(
      DateTime(month.year, month.month + 1, 0).day,
      (index) => workTimes.firstWhere(
        (workTime) =>
            workTime.targetDay ==
            formatDate(month, format: 'yyyy-MM-dd')
                .replaceRange(8, 10, (index + 1).toString().padLeft(2, '0')),
        orElse: () => WorkTime(
            targetDay: formatDate(month, format: 'yyyy-MM-dd')
                .replaceRange(8, 10, (index + 1).toString().padLeft(2, '0')),
            userId: userId,
            id: -1),
      ),
    );
    return allWorkTimes;
  }

  changeMonth(int userId, DateTime month) async {
    return update((state) async {
      final workTimes = await fetchWorkTimesByMonth(userId, month);
      return workTimes;
    });
  }

  updateWorkTime(WorkTime updateWorkTime) async {
    return update((state) async {
      final workTimeService = WorkTimeService();
      final id = await workTimeService.saveWorkTime(updateWorkTime);

      return state
          .map((workTime) => workTime.targetDay == updateWorkTime.targetDay
              ? updateWorkTime.copyWith(id: id)
              : workTime)
          .toList();
    });
  }
}
