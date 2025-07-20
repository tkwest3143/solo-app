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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add parentTodoId column to todos table
          await m.addColumn(todos, todos.parentTodoId);
        }
        if (from < 3) {
          // Add isDeleted column to todos table for soft delete
          await m.addColumn(todos, todos.isDeleted);
        }
      },
    );
  }

  static Future<AppDatabase> getSingletonInstance() async {
    _instance ??= AppDatabase(LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase.createInBackground(file);
    }));
    return _instance!;
  }
}
