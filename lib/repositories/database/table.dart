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
  // Recurring fields
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurringType => text().nullable()();
  DateTimeColumn get recurringEndDate => dateTime().nullable()();
  IntColumn get recurringDayOfWeek => integer().nullable()();
  IntColumn get recurringDayOfMonth => integer().nullable()();
}
