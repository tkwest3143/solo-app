import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solo/models/work_time.dart';
import 'package:solo/screen/states/global.dart';
import 'package:solo/services/work_time_service.dart';
import 'package:solo/utilities/date.dart';

part 'build/home.g.dart';

@riverpod
class HomeState extends _$HomeState {
  @override
  Future<WorkTime> build() async {
    final user = ref.read(globalStateProvider);
    if (user == null) {
      throw Exception('User is not selected');
    }
    final today = DateTime.now();
    final workTimeService = WorkTimeService();
    final workTimes = await workTimeService.getWorkTimesByDay(
        user.id, formatDate(today, format: 'yyyy-MM-dd'));
    if (workTimes.isEmpty) {
      final workTime = WorkTime(
        targetDay: formatDate(today, format: 'yyyy-MM-dd'),
        userId: user.id,
        id: -1,
      );
      final id = await workTimeService.saveWorkTime(workTime);

      return workTime.copyWith(id: id);
    }
    return workTimes.first;
  }

  Future<WorkTime> updateWorkTime(WorkTime updateWorkTime) async {
    return update((workTime) async {
      final workTimeService = WorkTimeService();
      final id = await workTimeService.saveWorkTime(updateWorkTime);
      return updateWorkTime.copyWith(id: id);
    });
  }
}
