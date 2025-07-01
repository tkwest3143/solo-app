import 'package:solo/models/work_time.dart';
import 'package:solo/repositories/database.dart';

class WorkTimeService {
  Future<List<WorkTime>> getWorkTimesByMonth(int userId, String month) async {
    final regex = RegExp(r'^\d{4}-\d{2}$');
    if (!regex.hasMatch(month)) {
      return [];
    }
    final workTimeTableRepository = WorkTimeTableRepository();
    final workTimes = await workTimeTableRepository
        .findByUserIdAndContainTargetDay(userId, month);
    return workTimes;
  }

  Future<List<WorkTime>> getWorkTimesByDay(int userId, String day) async {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(day)) {
      return [];
    }
    final workTimeTableRepository = WorkTimeTableRepository();
    final workTimes = await workTimeTableRepository
        .findByUserIdAndContainTargetDay(userId, day);
    return workTimes;
  }

  Future<int> saveWorkTime(WorkTime workTime) async {
    if (workTime.id == -1) {
      final workSettingForDB = WorkTime(
        targetDay: workTime.targetDay,
        userId: workTime.userId,
        id: workTime.id,
        start: workTime.start,
        end: workTime.end,
        restStart: workTime.restStart,
        restEnd: workTime.restEnd,
        memo: workTime.memo,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final workTimeTableRepository = WorkTimeTableRepository();
      return await workTimeTableRepository.createWorkTime(workSettingForDB);
    }
    final workSettingForDB = WorkTime(
      targetDay: workTime.targetDay,
      userId: workTime.userId,
      id: workTime.id,
      start: workTime.start,
      end: workTime.end,
      restStart: workTime.restStart,
      restEnd: workTime.restEnd,
      memo: workTime.memo,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final workTimeTableRepository = WorkTimeTableRepository();
    await workTimeTableRepository.updateWorkTime(workSettingForDB);
    return workTime.id;
  }
}
