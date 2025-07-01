import 'package:solo/models/work_setting.dart';
import 'package:solo/repositories/database.dart';

class WorkSettingService {
  Future<void> saveWorkSetting(WorkSetting workSetting) async {
    final workSettingForDB = WorkSetting(
      userId: workSetting.userId,
      id: workSetting.id,
      title: workSetting.title,
      start: workSetting.start,
      end: workSetting.end,
      restStart: workSetting.restStart,
      restEnd: workSetting.restEnd,
      workingUnit: workSetting.workingUnit,
      memo: workSetting.memo,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final workSettingTableRepository = WorkSettingTableRepository();
    await workSettingTableRepository.createWorkSetting(workSettingForDB);
  }
}
