import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solo/database/tables/table.dart';
import 'package:path/path.dart' as path;

part 'drift.g.dart';

@DriftDatabase(tables: [Users, WorkSettings, WorkTimes, JapaneseHolidays])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  static AppDatabase? _instance;

  @override
  int get schemaVersion => 1;

  static Future<AppDatabase> getSingletonInstance() async {
    _instance ??= AppDatabase(LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase.createInBackground(file);
    }));
    return _instance!;
  }
}
