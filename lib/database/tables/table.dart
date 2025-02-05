import 'package:drift/drift.dart';

class DefaultTableColumns extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
class Users extends DefaultTableColumns {
  TextColumn get name => text()();
  TextColumn get email => text()();
  DateTimeColumn get lastLoginTime => dateTime().nullable()();
  IntColumn get defaultWorkSettingId =>
      integer()();
}

class WorkSettings extends DefaultTableColumns {
  TextColumn get title => text()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  DateTimeColumn get restStart => dateTime()();
  DateTimeColumn get restEnd => dateTime()();
  TextColumn get memo => text().nullable()();
  IntColumn get workingUnit => integer()();
  IntColumn get userId => integer().references(Users, #id)();
}

class WorkTimes extends DefaultTableColumns {
  TextColumn get targetDay => text()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  DateTimeColumn get restStart => dateTime()();
  DateTimeColumn get restEnd => dateTime()();
  TextColumn get memo => text().nullable()();
  IntColumn get userId => integer().references(Users, #id)();
}

class JapaneseHolidays extends DefaultTableColumns {
  TextColumn get targetDay => text()();
  TextColumn get name => text()();
  TextColumn get memo => text().nullable()();
}