import 'package:drift/drift.dart';

class DefaultTableColumns extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class Categories extends DefaultTableColumns {
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get color => text()(); // Color name from TodoColor enum
}

class Todos extends DefaultTableColumns {
  TextColumn get title => text()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get color =>
      text().nullable()(); // Keep for backward compatibility
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  TextColumn get icon => text().nullable()();
  // Recurring fields
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurringType => text().nullable()();
  DateTimeColumn get recurringEndDate => dateTime().nullable()();
  IntColumn get recurringDayOfWeek => integer().nullable()();
  IntColumn get recurringDayOfMonth => integer().nullable()();
  IntColumn get parentTodoId => integer().nullable().references(Todos, #id)();

  // --- Timer fields ---
  TextColumn get timerType => text()
      .withDefault(const Constant('none'))(); // 'none', 'pomodoro', 'countup'
  IntColumn get countupElapsedSeconds => integer().nullable()();
  IntColumn get pomodoroWorkMinutes => integer().nullable()();
  IntColumn get pomodoroShortBreakMinutes => integer().nullable()();
  IntColumn get pomodoroLongBreakMinutes => integer().nullable()();
  IntColumn get pomodoroCycle => integer().nullable()();
  IntColumn get pomodoroCompletedCycle => integer().nullable()();
}

class TodoCheckListItems extends DefaultTableColumns {
  IntColumn get todoId =>
      integer().references(Todos, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get order => integer()(); // For ordering checklist items
}
