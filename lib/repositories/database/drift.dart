import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solo/repositories/database/table.dart';
import 'package:path/path.dart' as path;

part 'build/drift.g.dart';

@DriftDatabase(tables: [Todos, Categories, TodoCheckListItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  static AppDatabase? _instance;

  @override
  int get schemaVersion => 3; // Increment version for checklist schema change

  static Future<AppDatabase> getSingletonInstance() async {
    _instance ??= AppDatabase(LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase.createInBackground(file);
    }));
    return _instance!;
  }
}
