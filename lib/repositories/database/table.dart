import 'package:drift/drift.dart';

class DefaultTableColumns extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class Todos extends DefaultTableColumns {
  TextColumn get title => text()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get color => text().nullable()();
  TextColumn get icon => text().nullable()();
}
