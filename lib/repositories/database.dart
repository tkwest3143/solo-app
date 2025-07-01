import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:solo/repositories/database/drift.dart';
import 'package:solo/models/user.dart' as user;
import 'package:solo/models/work_setting.dart' as work_setting;
import 'package:solo/models/work_time.dart' as work_time;

class UserTableRepository {
  Future<List<user.User>> findAll() async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await database.users.select().get();
    return data
        .map((e) => user.User(
              id: e.id,
              name: e.name,
              email: e.email,
              lastLoginTime: e.lastLoginTime,
              defaultWorkSettingId: e.defaultWorkSettingId,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
            ))
        .toList();
  }

  Future<int> createUser(user.User newUser) async {
    final database = await AppDatabase.getSingletonInstance();
    return await database.into(database.users).insert(
          UsersCompanion(
            name: Value(newUser.name),
            email: Value(newUser.email),
            lastLoginTime: Value(newUser.lastLoginTime),
            defaultWorkSettingId: newUser.defaultWorkSettingId != null
                ? Value(newUser.defaultWorkSettingId!)
                : Value.absent(),
            createdAt: Value(newUser.createdAt),
            updatedAt: Value(newUser.updatedAt),
          ),
        );
  }

  Future<void> updateUser(user.User updatedUser) async {
    final database = await AppDatabase.getSingletonInstance();
    await database.update(database.users).replace(
          UsersCompanion(
            id: Value(updatedUser.id),
            name: Value(updatedUser.name),
            email: Value(updatedUser.email),
            lastLoginTime: Value(updatedUser.lastLoginTime),
            defaultWorkSettingId: updatedUser.defaultWorkSettingId != null
                ? Value(updatedUser.defaultWorkSettingId!)
                : Value.absent(),
            createdAt: Value(updatedUser.createdAt),
            updatedAt: Value(updatedUser.updatedAt),
          ),
        );
  }

  Future<void> deleteUser(int id) async {
    final database = await AppDatabase.getSingletonInstance();
    await (database.delete(database.users)..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}

class WorkSettingTableRepository {
  Future<List<work_setting.WorkSetting>> findAll() async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await database.workSettings.select().get();
    return data
        .map((e) => work_setting.WorkSetting(
              id: e.id,
              title: e.title,
              start: e.start,
              end: e.end,
              restStart: e.restStart,
              restEnd: e.restEnd,
              memo: e.memo,
              workingUnit: e.workingUnit,
              userId: e.userId,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
            ))
        .toList();
  }

  Future<int> createWorkSetting(work_setting.WorkSetting newWorkSetting) async {
    final database = await AppDatabase.getSingletonInstance();
    return await database.into(database.workSettings).insert(
          WorkSettingsCompanion(
            title: Value(newWorkSetting.title),
            start: Value(newWorkSetting.start),
            end: Value(newWorkSetting.end),
            restStart: Value(newWorkSetting.restStart),
            restEnd: Value(newWorkSetting.restEnd),
            memo: Value(newWorkSetting.memo),
            workingUnit: Value(newWorkSetting.workingUnit),
            userId: Value(newWorkSetting.userId),
            createdAt: Value(newWorkSetting.createdAt),
            updatedAt: Value(newWorkSetting.updatedAt),
          ),
        );
  }

  Future<void> updateWorkSetting(
      work_setting.WorkSetting updatedWorkSetting) async {
    final database = await AppDatabase.getSingletonInstance();
    await database.update(database.workSettings).replace(
          WorkSettingsCompanion(
            id: Value(updatedWorkSetting.id),
            title: Value(updatedWorkSetting.title),
            start: Value(updatedWorkSetting.start),
            end: Value(updatedWorkSetting.end),
            restStart: Value(updatedWorkSetting.restStart),
            restEnd: Value(updatedWorkSetting.restEnd),
            memo: Value(updatedWorkSetting.memo),
            workingUnit: Value(updatedWorkSetting.workingUnit),
            userId: Value(updatedWorkSetting.userId),
            createdAt: Value(updatedWorkSetting.createdAt),
            updatedAt: Value(updatedWorkSetting.updatedAt),
          ),
        );
  }

  Future<void> deleteWorkSetting(int id) async {
    final database = await AppDatabase.getSingletonInstance();
    await (database.delete(database.workSettings)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}

class WorkTimeTableRepository {
  Future<List<work_time.WorkTime>> findByUserIdAndContainTargetDay(
      int userId, String month) async {
    final database = await AppDatabase.getSingletonInstance();
    final data = await (database.workTimes.select()
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.targetDay.contains(month)))
        .get();
    return data
        .map((e) => work_time.WorkTime(
              id: e.id,
              targetDay: e.targetDay,
              start: e.start,
              end: e.end,
              restStart: e.restStart,
              restEnd: e.restEnd,
              memo: e.memo,
              userId: e.userId,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
            ))
        .toList();
  }

  Future<int> createWorkTime(work_time.WorkTime newWorkTime) async {
    final database = await AppDatabase.getSingletonInstance();
    if (kDebugMode) {
      print('Inserting new work time: ${newWorkTime.toString()}');
    }
    return await database.into(database.workTimes).insert(
          WorkTimesCompanion(
            targetDay: Value(newWorkTime.targetDay),
            start: Value(newWorkTime.start),
            end: Value(newWorkTime.end),
            restStart: Value(newWorkTime.restStart),
            restEnd: Value(newWorkTime.restEnd),
            memo: Value(newWorkTime.memo),
            userId: Value(newWorkTime.userId),
            createdAt: Value(newWorkTime.createdAt),
            updatedAt: Value(newWorkTime.updatedAt),
          ),
        );
  }

  Future<void> updateWorkTime(work_time.WorkTime updatedWorkTime) async {
    final database = await AppDatabase.getSingletonInstance();
    await database.update(database.workTimes).replace(
          WorkTimesCompanion(
            id: Value(updatedWorkTime.id),
            targetDay: Value(updatedWorkTime.targetDay),
            start: Value(updatedWorkTime.start),
            end: Value(updatedWorkTime.end),
            restStart: Value(updatedWorkTime.restStart),
            restEnd: Value(updatedWorkTime.restEnd),
            memo: Value(updatedWorkTime.memo),
            userId: Value(updatedWorkTime.userId),
            createdAt: Value(updatedWorkTime.createdAt),
            updatedAt: Value(updatedWorkTime.updatedAt),
          ),
        );
  }

  Future<void> deleteWorkTime(int id) async {
    final database = await AppDatabase.getSingletonInstance();
    await (database.delete(database.workTimes)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
