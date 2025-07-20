// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../drift.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, updatedAt, title, description, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String title;
  final String? description;
  final String color;
  const Category(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.title,
      this.description,
      required this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['color'] = Variable<String>(color);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      color: Value(color),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      color: serializer.fromJson<String>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'color': serializer.toJson<String>(color),
    };
  }

  Category copyWith(
          {int? id,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          String? title,
          Value<String?> description = const Value.absent(),
          String? color}) =>
      Category(
        id: id ?? this.id,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        color: color ?? this.color,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, title, description, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.title == this.title &&
          other.description == this.description &&
          other.color == this.color);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> color;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String color,
  })  : title = Value(title),
        color = Value(color);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? color}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isRecurringMeta =
      const VerificationMeta('isRecurring');
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
      'is_recurring', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_recurring" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _recurringTypeMeta =
      const VerificationMeta('recurringType');
  @override
  late final GeneratedColumn<String> recurringType = GeneratedColumn<String>(
      'recurring_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recurringEndDateMeta =
      const VerificationMeta('recurringEndDate');
  @override
  late final GeneratedColumn<DateTime> recurringEndDate =
      GeneratedColumn<DateTime>('recurring_end_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _parentTodoIdMeta =
      const VerificationMeta('parentTodoId');
  @override
  late final GeneratedColumn<int> parentTodoId = GeneratedColumn<int>(
      'parent_todo_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES todos (id)'));
  static const VerificationMeta _timerTypeMeta =
      const VerificationMeta('timerType');
  @override
  late final GeneratedColumn<String> timerType = GeneratedColumn<String>(
      'timer_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('none'));
  static const VerificationMeta _countupElapsedSecondsMeta =
      const VerificationMeta('countupElapsedSeconds');
  @override
  late final GeneratedColumn<int> countupElapsedSeconds = GeneratedColumn<int>(
      'countup_elapsed_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pomodoroWorkMinutesMeta =
      const VerificationMeta('pomodoroWorkMinutes');
  @override
  late final GeneratedColumn<int> pomodoroWorkMinutes = GeneratedColumn<int>(
      'pomodoro_work_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pomodoroShortBreakMinutesMeta =
      const VerificationMeta('pomodoroShortBreakMinutes');
  @override
  late final GeneratedColumn<int> pomodoroShortBreakMinutes =
      GeneratedColumn<int>('pomodoro_short_break_minutes', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pomodoroLongBreakMinutesMeta =
      const VerificationMeta('pomodoroLongBreakMinutes');
  @override
  late final GeneratedColumn<int> pomodoroLongBreakMinutes =
      GeneratedColumn<int>('pomodoro_long_break_minutes', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pomodoroCycleMeta =
      const VerificationMeta('pomodoroCycle');
  @override
  late final GeneratedColumn<int> pomodoroCycle = GeneratedColumn<int>(
      'pomodoro_cycle', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pomodoroCompletedCycleMeta =
      const VerificationMeta('pomodoroCompletedCycle');
  @override
  late final GeneratedColumn<int> pomodoroCompletedCycle = GeneratedColumn<int>(
      'pomodoro_completed_cycle', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        title,
        dueDate,
        description,
        isCompleted,
        color,
        categoryId,
        icon,
        isRecurring,
        recurringType,
        recurringEndDate,
        parentTodoId,
        timerType,
        countupElapsedSeconds,
        pomodoroWorkMinutes,
        pomodoroShortBreakMinutes,
        pomodoroLongBreakMinutes,
        pomodoroCycle,
        pomodoroCompletedCycle,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(Insertable<Todo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
          _isRecurringMeta,
          isRecurring.isAcceptableOrUnknown(
              data['is_recurring']!, _isRecurringMeta));
    }
    if (data.containsKey('recurring_type')) {
      context.handle(
          _recurringTypeMeta,
          recurringType.isAcceptableOrUnknown(
              data['recurring_type']!, _recurringTypeMeta));
    }
    if (data.containsKey('recurring_end_date')) {
      context.handle(
          _recurringEndDateMeta,
          recurringEndDate.isAcceptableOrUnknown(
              data['recurring_end_date']!, _recurringEndDateMeta));
    }
    if (data.containsKey('parent_todo_id')) {
      context.handle(
          _parentTodoIdMeta,
          parentTodoId.isAcceptableOrUnknown(
              data['parent_todo_id']!, _parentTodoIdMeta));
    }
    if (data.containsKey('timer_type')) {
      context.handle(_timerTypeMeta,
          timerType.isAcceptableOrUnknown(data['timer_type']!, _timerTypeMeta));
    }
    if (data.containsKey('countup_elapsed_seconds')) {
      context.handle(
          _countupElapsedSecondsMeta,
          countupElapsedSeconds.isAcceptableOrUnknown(
              data['countup_elapsed_seconds']!, _countupElapsedSecondsMeta));
    }
    if (data.containsKey('pomodoro_work_minutes')) {
      context.handle(
          _pomodoroWorkMinutesMeta,
          pomodoroWorkMinutes.isAcceptableOrUnknown(
              data['pomodoro_work_minutes']!, _pomodoroWorkMinutesMeta));
    }
    if (data.containsKey('pomodoro_short_break_minutes')) {
      context.handle(
          _pomodoroShortBreakMinutesMeta,
          pomodoroShortBreakMinutes.isAcceptableOrUnknown(
              data['pomodoro_short_break_minutes']!,
              _pomodoroShortBreakMinutesMeta));
    }
    if (data.containsKey('pomodoro_long_break_minutes')) {
      context.handle(
          _pomodoroLongBreakMinutesMeta,
          pomodoroLongBreakMinutes.isAcceptableOrUnknown(
              data['pomodoro_long_break_minutes']!,
              _pomodoroLongBreakMinutesMeta));
    }
    if (data.containsKey('pomodoro_cycle')) {
      context.handle(
          _pomodoroCycleMeta,
          pomodoroCycle.isAcceptableOrUnknown(
              data['pomodoro_cycle']!, _pomodoroCycleMeta));
    }
    if (data.containsKey('pomodoro_completed_cycle')) {
      context.handle(
          _pomodoroCompletedCycleMeta,
          pomodoroCompletedCycle.isAcceptableOrUnknown(
              data['pomodoro_completed_cycle']!, _pomodoroCompletedCycleMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      isRecurring: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
      recurringType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurring_type']),
      recurringEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}recurring_end_date']),
      parentTodoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_todo_id']),
      timerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timer_type'])!,
      countupElapsedSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}countup_elapsed_seconds']),
      pomodoroWorkMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}pomodoro_work_minutes']),
      pomodoroShortBreakMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}pomodoro_short_break_minutes']),
      pomodoroLongBreakMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}pomodoro_long_break_minutes']),
      pomodoroCycle: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pomodoro_cycle']),
      pomodoroCompletedCycle: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}pomodoro_completed_cycle']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class Todo extends DataClass implements Insertable<Todo> {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String title;
  final DateTime dueDate;
  final String? description;
  final bool isCompleted;
  final String? color;
  final int? categoryId;
  final String? icon;
  final bool isRecurring;
  final String? recurringType;
  final DateTime? recurringEndDate;
  final int? parentTodoId;
  final String timerType;
  final int? countupElapsedSeconds;
  final int? pomodoroWorkMinutes;
  final int? pomodoroShortBreakMinutes;
  final int? pomodoroLongBreakMinutes;
  final int? pomodoroCycle;
  final int? pomodoroCompletedCycle;
  final bool isDeleted;
  const Todo(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.title,
      required this.dueDate,
      this.description,
      required this.isCompleted,
      this.color,
      this.categoryId,
      this.icon,
      required this.isRecurring,
      this.recurringType,
      this.recurringEndDate,
      this.parentTodoId,
      required this.timerType,
      this.countupElapsedSeconds,
      this.pomodoroWorkMinutes,
      this.pomodoroShortBreakMinutes,
      this.pomodoroLongBreakMinutes,
      this.pomodoroCycle,
      this.pomodoroCompletedCycle,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['title'] = Variable<String>(title);
    map['due_date'] = Variable<DateTime>(dueDate);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurringType != null) {
      map['recurring_type'] = Variable<String>(recurringType);
    }
    if (!nullToAbsent || recurringEndDate != null) {
      map['recurring_end_date'] = Variable<DateTime>(recurringEndDate);
    }
    if (!nullToAbsent || parentTodoId != null) {
      map['parent_todo_id'] = Variable<int>(parentTodoId);
    }
    map['timer_type'] = Variable<String>(timerType);
    if (!nullToAbsent || countupElapsedSeconds != null) {
      map['countup_elapsed_seconds'] = Variable<int>(countupElapsedSeconds);
    }
    if (!nullToAbsent || pomodoroWorkMinutes != null) {
      map['pomodoro_work_minutes'] = Variable<int>(pomodoroWorkMinutes);
    }
    if (!nullToAbsent || pomodoroShortBreakMinutes != null) {
      map['pomodoro_short_break_minutes'] =
          Variable<int>(pomodoroShortBreakMinutes);
    }
    if (!nullToAbsent || pomodoroLongBreakMinutes != null) {
      map['pomodoro_long_break_minutes'] =
          Variable<int>(pomodoroLongBreakMinutes);
    }
    if (!nullToAbsent || pomodoroCycle != null) {
      map['pomodoro_cycle'] = Variable<int>(pomodoroCycle);
    }
    if (!nullToAbsent || pomodoroCompletedCycle != null) {
      map['pomodoro_completed_cycle'] = Variable<int>(pomodoroCompletedCycle);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      title: Value(title),
      dueDate: Value(dueDate),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isCompleted: Value(isCompleted),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      isRecurring: Value(isRecurring),
      recurringType: recurringType == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringType),
      recurringEndDate: recurringEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringEndDate),
      parentTodoId: parentTodoId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentTodoId),
      timerType: Value(timerType),
      countupElapsedSeconds: countupElapsedSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(countupElapsedSeconds),
      pomodoroWorkMinutes: pomodoroWorkMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(pomodoroWorkMinutes),
      pomodoroShortBreakMinutes:
          pomodoroShortBreakMinutes == null && nullToAbsent
              ? const Value.absent()
              : Value(pomodoroShortBreakMinutes),
      pomodoroLongBreakMinutes: pomodoroLongBreakMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(pomodoroLongBreakMinutes),
      pomodoroCycle: pomodoroCycle == null && nullToAbsent
          ? const Value.absent()
          : Value(pomodoroCycle),
      pomodoroCompletedCycle: pomodoroCompletedCycle == null && nullToAbsent
          ? const Value.absent()
          : Value(pomodoroCompletedCycle),
      isDeleted: Value(isDeleted),
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      title: serializer.fromJson<String>(json['title']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      description: serializer.fromJson<String?>(json['description']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      color: serializer.fromJson<String?>(json['color']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      icon: serializer.fromJson<String?>(json['icon']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurringType: serializer.fromJson<String?>(json['recurringType']),
      recurringEndDate:
          serializer.fromJson<DateTime?>(json['recurringEndDate']),
      parentTodoId: serializer.fromJson<int?>(json['parentTodoId']),
      timerType: serializer.fromJson<String>(json['timerType']),
      countupElapsedSeconds:
          serializer.fromJson<int?>(json['countupElapsedSeconds']),
      pomodoroWorkMinutes:
          serializer.fromJson<int?>(json['pomodoroWorkMinutes']),
      pomodoroShortBreakMinutes:
          serializer.fromJson<int?>(json['pomodoroShortBreakMinutes']),
      pomodoroLongBreakMinutes:
          serializer.fromJson<int?>(json['pomodoroLongBreakMinutes']),
      pomodoroCycle: serializer.fromJson<int?>(json['pomodoroCycle']),
      pomodoroCompletedCycle:
          serializer.fromJson<int?>(json['pomodoroCompletedCycle']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'title': serializer.toJson<String>(title),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'description': serializer.toJson<String?>(description),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'color': serializer.toJson<String?>(color),
      'categoryId': serializer.toJson<int?>(categoryId),
      'icon': serializer.toJson<String?>(icon),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurringType': serializer.toJson<String?>(recurringType),
      'recurringEndDate': serializer.toJson<DateTime?>(recurringEndDate),
      'parentTodoId': serializer.toJson<int?>(parentTodoId),
      'timerType': serializer.toJson<String>(timerType),
      'countupElapsedSeconds': serializer.toJson<int?>(countupElapsedSeconds),
      'pomodoroWorkMinutes': serializer.toJson<int?>(pomodoroWorkMinutes),
      'pomodoroShortBreakMinutes':
          serializer.toJson<int?>(pomodoroShortBreakMinutes),
      'pomodoroLongBreakMinutes':
          serializer.toJson<int?>(pomodoroLongBreakMinutes),
      'pomodoroCycle': serializer.toJson<int?>(pomodoroCycle),
      'pomodoroCompletedCycle': serializer.toJson<int?>(pomodoroCompletedCycle),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Todo copyWith(
          {int? id,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          String? title,
          DateTime? dueDate,
          Value<String?> description = const Value.absent(),
          bool? isCompleted,
          Value<String?> color = const Value.absent(),
          Value<int?> categoryId = const Value.absent(),
          Value<String?> icon = const Value.absent(),
          bool? isRecurring,
          Value<String?> recurringType = const Value.absent(),
          Value<DateTime?> recurringEndDate = const Value.absent(),
          Value<int?> parentTodoId = const Value.absent(),
          String? timerType,
          Value<int?> countupElapsedSeconds = const Value.absent(),
          Value<int?> pomodoroWorkMinutes = const Value.absent(),
          Value<int?> pomodoroShortBreakMinutes = const Value.absent(),
          Value<int?> pomodoroLongBreakMinutes = const Value.absent(),
          Value<int?> pomodoroCycle = const Value.absent(),
          Value<int?> pomodoroCompletedCycle = const Value.absent(),
          bool? isDeleted}) =>
      Todo(
        id: id ?? this.id,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        title: title ?? this.title,
        dueDate: dueDate ?? this.dueDate,
        description: description.present ? description.value : this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        color: color.present ? color.value : this.color,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        icon: icon.present ? icon.value : this.icon,
        isRecurring: isRecurring ?? this.isRecurring,
        recurringType:
            recurringType.present ? recurringType.value : this.recurringType,
        recurringEndDate: recurringEndDate.present
            ? recurringEndDate.value
            : this.recurringEndDate,
        parentTodoId:
            parentTodoId.present ? parentTodoId.value : this.parentTodoId,
        timerType: timerType ?? this.timerType,
        countupElapsedSeconds: countupElapsedSeconds.present
            ? countupElapsedSeconds.value
            : this.countupElapsedSeconds,
        pomodoroWorkMinutes: pomodoroWorkMinutes.present
            ? pomodoroWorkMinutes.value
            : this.pomodoroWorkMinutes,
        pomodoroShortBreakMinutes: pomodoroShortBreakMinutes.present
            ? pomodoroShortBreakMinutes.value
            : this.pomodoroShortBreakMinutes,
        pomodoroLongBreakMinutes: pomodoroLongBreakMinutes.present
            ? pomodoroLongBreakMinutes.value
            : this.pomodoroLongBreakMinutes,
        pomodoroCycle:
            pomodoroCycle.present ? pomodoroCycle.value : this.pomodoroCycle,
        pomodoroCompletedCycle: pomodoroCompletedCycle.present
            ? pomodoroCompletedCycle.value
            : this.pomodoroCompletedCycle,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Todo copyWithCompanion(TodosCompanion data) {
    return Todo(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      title: data.title.present ? data.title.value : this.title,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      description:
          data.description.present ? data.description.value : this.description,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      color: data.color.present ? data.color.value : this.color,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      icon: data.icon.present ? data.icon.value : this.icon,
      isRecurring:
          data.isRecurring.present ? data.isRecurring.value : this.isRecurring,
      recurringType: data.recurringType.present
          ? data.recurringType.value
          : this.recurringType,
      recurringEndDate: data.recurringEndDate.present
          ? data.recurringEndDate.value
          : this.recurringEndDate,
      parentTodoId: data.parentTodoId.present
          ? data.parentTodoId.value
          : this.parentTodoId,
      timerType: data.timerType.present ? data.timerType.value : this.timerType,
      countupElapsedSeconds: data.countupElapsedSeconds.present
          ? data.countupElapsedSeconds.value
          : this.countupElapsedSeconds,
      pomodoroWorkMinutes: data.pomodoroWorkMinutes.present
          ? data.pomodoroWorkMinutes.value
          : this.pomodoroWorkMinutes,
      pomodoroShortBreakMinutes: data.pomodoroShortBreakMinutes.present
          ? data.pomodoroShortBreakMinutes.value
          : this.pomodoroShortBreakMinutes,
      pomodoroLongBreakMinutes: data.pomodoroLongBreakMinutes.present
          ? data.pomodoroLongBreakMinutes.value
          : this.pomodoroLongBreakMinutes,
      pomodoroCycle: data.pomodoroCycle.present
          ? data.pomodoroCycle.value
          : this.pomodoroCycle,
      pomodoroCompletedCycle: data.pomodoroCompletedCycle.present
          ? data.pomodoroCompletedCycle.value
          : this.pomodoroCompletedCycle,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('dueDate: $dueDate, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('color: $color, ')
          ..write('categoryId: $categoryId, ')
          ..write('icon: $icon, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringType: $recurringType, ')
          ..write('recurringEndDate: $recurringEndDate, ')
          ..write('parentTodoId: $parentTodoId, ')
          ..write('timerType: $timerType, ')
          ..write('countupElapsedSeconds: $countupElapsedSeconds, ')
          ..write('pomodoroWorkMinutes: $pomodoroWorkMinutes, ')
          ..write('pomodoroShortBreakMinutes: $pomodoroShortBreakMinutes, ')
          ..write('pomodoroLongBreakMinutes: $pomodoroLongBreakMinutes, ')
          ..write('pomodoroCycle: $pomodoroCycle, ')
          ..write('pomodoroCompletedCycle: $pomodoroCompletedCycle, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        createdAt,
        updatedAt,
        title,
        dueDate,
        description,
        isCompleted,
        color,
        categoryId,
        icon,
        isRecurring,
        recurringType,
        recurringEndDate,
        parentTodoId,
        timerType,
        countupElapsedSeconds,
        pomodoroWorkMinutes,
        pomodoroShortBreakMinutes,
        pomodoroLongBreakMinutes,
        pomodoroCycle,
        pomodoroCompletedCycle,
        isDeleted
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.title == this.title &&
          other.dueDate == this.dueDate &&
          other.description == this.description &&
          other.isCompleted == this.isCompleted &&
          other.color == this.color &&
          other.categoryId == this.categoryId &&
          other.icon == this.icon &&
          other.isRecurring == this.isRecurring &&
          other.recurringType == this.recurringType &&
          other.recurringEndDate == this.recurringEndDate &&
          other.parentTodoId == this.parentTodoId &&
          other.timerType == this.timerType &&
          other.countupElapsedSeconds == this.countupElapsedSeconds &&
          other.pomodoroWorkMinutes == this.pomodoroWorkMinutes &&
          other.pomodoroShortBreakMinutes == this.pomodoroShortBreakMinutes &&
          other.pomodoroLongBreakMinutes == this.pomodoroLongBreakMinutes &&
          other.pomodoroCycle == this.pomodoroCycle &&
          other.pomodoroCompletedCycle == this.pomodoroCompletedCycle &&
          other.isDeleted == this.isDeleted);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<int> id;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> title;
  final Value<DateTime> dueDate;
  final Value<String?> description;
  final Value<bool> isCompleted;
  final Value<String?> color;
  final Value<int?> categoryId;
  final Value<String?> icon;
  final Value<bool> isRecurring;
  final Value<String?> recurringType;
  final Value<DateTime?> recurringEndDate;
  final Value<int?> parentTodoId;
  final Value<String> timerType;
  final Value<int?> countupElapsedSeconds;
  final Value<int?> pomodoroWorkMinutes;
  final Value<int?> pomodoroShortBreakMinutes;
  final Value<int?> pomodoroLongBreakMinutes;
  final Value<int?> pomodoroCycle;
  final Value<int?> pomodoroCompletedCycle;
  final Value<bool> isDeleted;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.color = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.icon = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringType = const Value.absent(),
    this.recurringEndDate = const Value.absent(),
    this.parentTodoId = const Value.absent(),
    this.timerType = const Value.absent(),
    this.countupElapsedSeconds = const Value.absent(),
    this.pomodoroWorkMinutes = const Value.absent(),
    this.pomodoroShortBreakMinutes = const Value.absent(),
    this.pomodoroLongBreakMinutes = const Value.absent(),
    this.pomodoroCycle = const Value.absent(),
    this.pomodoroCompletedCycle = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  TodosCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String title,
    required DateTime dueDate,
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.color = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.icon = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringType = const Value.absent(),
    this.recurringEndDate = const Value.absent(),
    this.parentTodoId = const Value.absent(),
    this.timerType = const Value.absent(),
    this.countupElapsedSeconds = const Value.absent(),
    this.pomodoroWorkMinutes = const Value.absent(),
    this.pomodoroShortBreakMinutes = const Value.absent(),
    this.pomodoroLongBreakMinutes = const Value.absent(),
    this.pomodoroCycle = const Value.absent(),
    this.pomodoroCompletedCycle = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : title = Value(title),
        dueDate = Value(dueDate);
  static Insertable<Todo> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? title,
    Expression<DateTime>? dueDate,
    Expression<String>? description,
    Expression<bool>? isCompleted,
    Expression<String>? color,
    Expression<int>? categoryId,
    Expression<String>? icon,
    Expression<bool>? isRecurring,
    Expression<String>? recurringType,
    Expression<DateTime>? recurringEndDate,
    Expression<int>? parentTodoId,
    Expression<String>? timerType,
    Expression<int>? countupElapsedSeconds,
    Expression<int>? pomodoroWorkMinutes,
    Expression<int>? pomodoroShortBreakMinutes,
    Expression<int>? pomodoroLongBreakMinutes,
    Expression<int>? pomodoroCycle,
    Expression<int>? pomodoroCompletedCycle,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (title != null) 'title': title,
      if (dueDate != null) 'due_date': dueDate,
      if (description != null) 'description': description,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (color != null) 'color': color,
      if (categoryId != null) 'category_id': categoryId,
      if (icon != null) 'icon': icon,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurringType != null) 'recurring_type': recurringType,
      if (recurringEndDate != null) 'recurring_end_date': recurringEndDate,
      if (parentTodoId != null) 'parent_todo_id': parentTodoId,
      if (timerType != null) 'timer_type': timerType,
      if (countupElapsedSeconds != null)
        'countup_elapsed_seconds': countupElapsedSeconds,
      if (pomodoroWorkMinutes != null)
        'pomodoro_work_minutes': pomodoroWorkMinutes,
      if (pomodoroShortBreakMinutes != null)
        'pomodoro_short_break_minutes': pomodoroShortBreakMinutes,
      if (pomodoroLongBreakMinutes != null)
        'pomodoro_long_break_minutes': pomodoroLongBreakMinutes,
      if (pomodoroCycle != null) 'pomodoro_cycle': pomodoroCycle,
      if (pomodoroCompletedCycle != null)
        'pomodoro_completed_cycle': pomodoroCompletedCycle,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  TodosCompanion copyWith(
      {Value<int>? id,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String>? title,
      Value<DateTime>? dueDate,
      Value<String?>? description,
      Value<bool>? isCompleted,
      Value<String?>? color,
      Value<int?>? categoryId,
      Value<String?>? icon,
      Value<bool>? isRecurring,
      Value<String?>? recurringType,
      Value<DateTime?>? recurringEndDate,
      Value<int?>? parentTodoId,
      Value<String>? timerType,
      Value<int?>? countupElapsedSeconds,
      Value<int?>? pomodoroWorkMinutes,
      Value<int?>? pomodoroShortBreakMinutes,
      Value<int?>? pomodoroLongBreakMinutes,
      Value<int?>? pomodoroCycle,
      Value<int?>? pomodoroCompletedCycle,
      Value<bool>? isDeleted}) {
    return TodosCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
      categoryId: categoryId ?? this.categoryId,
      icon: icon ?? this.icon,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringType: recurringType ?? this.recurringType,
      recurringEndDate: recurringEndDate ?? this.recurringEndDate,
      parentTodoId: parentTodoId ?? this.parentTodoId,
      timerType: timerType ?? this.timerType,
      countupElapsedSeconds:
          countupElapsedSeconds ?? this.countupElapsedSeconds,
      pomodoroWorkMinutes: pomodoroWorkMinutes ?? this.pomodoroWorkMinutes,
      pomodoroShortBreakMinutes:
          pomodoroShortBreakMinutes ?? this.pomodoroShortBreakMinutes,
      pomodoroLongBreakMinutes:
          pomodoroLongBreakMinutes ?? this.pomodoroLongBreakMinutes,
      pomodoroCycle: pomodoroCycle ?? this.pomodoroCycle,
      pomodoroCompletedCycle:
          pomodoroCompletedCycle ?? this.pomodoroCompletedCycle,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurringType.present) {
      map['recurring_type'] = Variable<String>(recurringType.value);
    }
    if (recurringEndDate.present) {
      map['recurring_end_date'] = Variable<DateTime>(recurringEndDate.value);
    }
    if (parentTodoId.present) {
      map['parent_todo_id'] = Variable<int>(parentTodoId.value);
    }
    if (timerType.present) {
      map['timer_type'] = Variable<String>(timerType.value);
    }
    if (countupElapsedSeconds.present) {
      map['countup_elapsed_seconds'] =
          Variable<int>(countupElapsedSeconds.value);
    }
    if (pomodoroWorkMinutes.present) {
      map['pomodoro_work_minutes'] = Variable<int>(pomodoroWorkMinutes.value);
    }
    if (pomodoroShortBreakMinutes.present) {
      map['pomodoro_short_break_minutes'] =
          Variable<int>(pomodoroShortBreakMinutes.value);
    }
    if (pomodoroLongBreakMinutes.present) {
      map['pomodoro_long_break_minutes'] =
          Variable<int>(pomodoroLongBreakMinutes.value);
    }
    if (pomodoroCycle.present) {
      map['pomodoro_cycle'] = Variable<int>(pomodoroCycle.value);
    }
    if (pomodoroCompletedCycle.present) {
      map['pomodoro_completed_cycle'] =
          Variable<int>(pomodoroCompletedCycle.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('dueDate: $dueDate, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('color: $color, ')
          ..write('categoryId: $categoryId, ')
          ..write('icon: $icon, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringType: $recurringType, ')
          ..write('recurringEndDate: $recurringEndDate, ')
          ..write('parentTodoId: $parentTodoId, ')
          ..write('timerType: $timerType, ')
          ..write('countupElapsedSeconds: $countupElapsedSeconds, ')
          ..write('pomodoroWorkMinutes: $pomodoroWorkMinutes, ')
          ..write('pomodoroShortBreakMinutes: $pomodoroShortBreakMinutes, ')
          ..write('pomodoroLongBreakMinutes: $pomodoroLongBreakMinutes, ')
          ..write('pomodoroCycle: $pomodoroCycle, ')
          ..write('pomodoroCompletedCycle: $pomodoroCompletedCycle, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $TodoCheckListItemsTable extends TodoCheckListItems
    with TableInfo<$TodoCheckListItemsTable, TodoCheckListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoCheckListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _todoIdMeta = const VerificationMeta('todoId');
  @override
  late final GeneratedColumn<int> todoId = GeneratedColumn<int>(
      'todo_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES todos (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, updatedAt, todoId, title, isCompleted, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_check_list_items';
  @override
  VerificationContext validateIntegrity(Insertable<TodoCheckListItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('todo_id')) {
      context.handle(_todoIdMeta,
          todoId.isAcceptableOrUnknown(data['todo_id']!, _todoIdMeta));
    } else if (isInserting) {
      context.missing(_todoIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoCheckListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoCheckListItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      todoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}todo_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
    );
  }

  @override
  $TodoCheckListItemsTable createAlias(String alias) {
    return $TodoCheckListItemsTable(attachedDatabase, alias);
  }
}

class TodoCheckListItem extends DataClass
    implements Insertable<TodoCheckListItem> {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int todoId;
  final String title;
  final bool isCompleted;
  final int order;
  const TodoCheckListItem(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.todoId,
      required this.title,
      required this.isCompleted,
      required this.order});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['todo_id'] = Variable<int>(todoId);
    map['title'] = Variable<String>(title);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['order'] = Variable<int>(order);
    return map;
  }

  TodoCheckListItemsCompanion toCompanion(bool nullToAbsent) {
    return TodoCheckListItemsCompanion(
      id: Value(id),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      todoId: Value(todoId),
      title: Value(title),
      isCompleted: Value(isCompleted),
      order: Value(order),
    );
  }

  factory TodoCheckListItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoCheckListItem(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      todoId: serializer.fromJson<int>(json['todoId']),
      title: serializer.fromJson<String>(json['title']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'todoId': serializer.toJson<int>(todoId),
      'title': serializer.toJson<String>(title),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'order': serializer.toJson<int>(order),
    };
  }

  TodoCheckListItem copyWith(
          {int? id,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          int? todoId,
          String? title,
          bool? isCompleted,
          int? order}) =>
      TodoCheckListItem(
        id: id ?? this.id,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        todoId: todoId ?? this.todoId,
        title: title ?? this.title,
        isCompleted: isCompleted ?? this.isCompleted,
        order: order ?? this.order,
      );
  TodoCheckListItem copyWithCompanion(TodoCheckListItemsCompanion data) {
    return TodoCheckListItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      todoId: data.todoId.present ? data.todoId.value : this.todoId,
      title: data.title.present ? data.title.value : this.title,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoCheckListItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('todoId: $todoId, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, todoId, title, isCompleted, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoCheckListItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.todoId == this.todoId &&
          other.title == this.title &&
          other.isCompleted == this.isCompleted &&
          other.order == this.order);
}

class TodoCheckListItemsCompanion extends UpdateCompanion<TodoCheckListItem> {
  final Value<int> id;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> todoId;
  final Value<String> title;
  final Value<bool> isCompleted;
  final Value<int> order;
  const TodoCheckListItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.todoId = const Value.absent(),
    this.title = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.order = const Value.absent(),
  });
  TodoCheckListItemsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int todoId,
    required String title,
    this.isCompleted = const Value.absent(),
    required int order,
  })  : todoId = Value(todoId),
        title = Value(title),
        order = Value(order);
  static Insertable<TodoCheckListItem> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? todoId,
    Expression<String>? title,
    Expression<bool>? isCompleted,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (todoId != null) 'todo_id': todoId,
      if (title != null) 'title': title,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (order != null) 'order': order,
    });
  }

  TodoCheckListItemsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? todoId,
      Value<String>? title,
      Value<bool>? isCompleted,
      Value<int>? order}) {
    return TodoCheckListItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      todoId: todoId ?? this.todoId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (todoId.present) {
      map['todo_id'] = Variable<int>(todoId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoCheckListItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('todoId: $todoId, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $TodoCheckListItemsTable todoCheckListItems =
      $TodoCheckListItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [categories, todos, todoCheckListItems];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('todos',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('todo_check_list_items', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  required String title,
  Value<String?> description,
  required String color,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String> title,
  Value<String?> description,
  Value<String> color,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TodosTable, List<Todo>> _todosRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.todos,
          aliasName:
              $_aliasNameGenerator(db.categories.id, db.todos.categoryId));

  $$TodosTableProcessedTableManager get todosRefs {
    final manager = $$TodosTableTableManager($_db, $_db.todos)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_todosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  Expression<bool> todosRefs(
      Expression<bool> Function($$TodosTableFilterComposer f) f) {
    final $$TodosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableFilterComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> todosRefs<T extends Object>(
      Expression<T> Function($$TodosTableAnnotationComposer a) f) {
    final $$TodosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableAnnotationComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool todosRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> color = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            title: title,
            description: description,
            color: color,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            required String color,
          }) =>
              CategoriesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            title: title,
            description: description,
            color: color,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({todosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (todosRefs) db.todos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (todosRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable, Todo>(
                        currentTable: table,
                        referencedTable:
                            $$CategoriesTableReferences._todosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .todosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool todosRefs})>;
typedef $$TodosTableCreateCompanionBuilder = TodosCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  required String title,
  required DateTime dueDate,
  Value<String?> description,
  Value<bool> isCompleted,
  Value<String?> color,
  Value<int?> categoryId,
  Value<String?> icon,
  Value<bool> isRecurring,
  Value<String?> recurringType,
  Value<DateTime?> recurringEndDate,
  Value<int?> parentTodoId,
  Value<String> timerType,
  Value<int?> countupElapsedSeconds,
  Value<int?> pomodoroWorkMinutes,
  Value<int?> pomodoroShortBreakMinutes,
  Value<int?> pomodoroLongBreakMinutes,
  Value<int?> pomodoroCycle,
  Value<int?> pomodoroCompletedCycle,
  Value<bool> isDeleted,
});
typedef $$TodosTableUpdateCompanionBuilder = TodosCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String> title,
  Value<DateTime> dueDate,
  Value<String?> description,
  Value<bool> isCompleted,
  Value<String?> color,
  Value<int?> categoryId,
  Value<String?> icon,
  Value<bool> isRecurring,
  Value<String?> recurringType,
  Value<DateTime?> recurringEndDate,
  Value<int?> parentTodoId,
  Value<String> timerType,
  Value<int?> countupElapsedSeconds,
  Value<int?> pomodoroWorkMinutes,
  Value<int?> pomodoroShortBreakMinutes,
  Value<int?> pomodoroLongBreakMinutes,
  Value<int?> pomodoroCycle,
  Value<int?> pomodoroCompletedCycle,
  Value<bool> isDeleted,
});

final class $$TodosTableReferences
    extends BaseReferences<_$AppDatabase, $TodosTable, Todo> {
  $$TodosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) => db.categories
      .createAlias($_aliasNameGenerator(db.todos.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TodosTable _parentTodoIdTable(_$AppDatabase db) => db.todos
      .createAlias($_aliasNameGenerator(db.todos.parentTodoId, db.todos.id));

  $$TodosTableProcessedTableManager? get parentTodoId {
    final $_column = $_itemColumn<int>('parent_todo_id');
    if ($_column == null) return null;
    final manager = $$TodosTableTableManager($_db, $_db.todos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentTodoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TodoCheckListItemsTable, List<TodoCheckListItem>>
      _todoCheckListItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.todoCheckListItems,
              aliasName: $_aliasNameGenerator(
                  db.todos.id, db.todoCheckListItems.todoId));

  $$TodoCheckListItemsTableProcessedTableManager get todoCheckListItemsRefs {
    final manager =
        $$TodoCheckListItemsTableTableManager($_db, $_db.todoCheckListItems)
            .filter((f) => f.todoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_todoCheckListItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TodosTableFilterComposer extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurringType => $composableBuilder(
      column: $table.recurringType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recurringEndDate => $composableBuilder(
      column: $table.recurringEndDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timerType => $composableBuilder(
      column: $table.timerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get countupElapsedSeconds => $composableBuilder(
      column: $table.countupElapsedSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pomodoroWorkMinutes => $composableBuilder(
      column: $table.pomodoroWorkMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pomodoroShortBreakMinutes => $composableBuilder(
      column: $table.pomodoroShortBreakMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pomodoroLongBreakMinutes => $composableBuilder(
      column: $table.pomodoroLongBreakMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pomodoroCycle => $composableBuilder(
      column: $table.pomodoroCycle, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pomodoroCompletedCycle => $composableBuilder(
      column: $table.pomodoroCompletedCycle,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TodosTableFilterComposer get parentTodoId {
    final $$TodosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentTodoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableFilterComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> todoCheckListItemsRefs(
      Expression<bool> Function($$TodoCheckListItemsTableFilterComposer f) f) {
    final $$TodoCheckListItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.todoCheckListItems,
        getReferencedColumn: (t) => t.todoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodoCheckListItemsTableFilterComposer(
              $db: $db,
              $table: $db.todoCheckListItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TodosTableOrderingComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurringType => $composableBuilder(
      column: $table.recurringType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recurringEndDate => $composableBuilder(
      column: $table.recurringEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timerType => $composableBuilder(
      column: $table.timerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get countupElapsedSeconds => $composableBuilder(
      column: $table.countupElapsedSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pomodoroWorkMinutes => $composableBuilder(
      column: $table.pomodoroWorkMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pomodoroShortBreakMinutes => $composableBuilder(
      column: $table.pomodoroShortBreakMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pomodoroLongBreakMinutes => $composableBuilder(
      column: $table.pomodoroLongBreakMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pomodoroCycle => $composableBuilder(
      column: $table.pomodoroCycle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pomodoroCompletedCycle => $composableBuilder(
      column: $table.pomodoroCompletedCycle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TodosTableOrderingComposer get parentTodoId {
    final $$TodosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentTodoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableOrderingComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => column);

  GeneratedColumn<String> get recurringType => $composableBuilder(
      column: $table.recurringType, builder: (column) => column);

  GeneratedColumn<DateTime> get recurringEndDate => $composableBuilder(
      column: $table.recurringEndDate, builder: (column) => column);

  GeneratedColumn<String> get timerType =>
      $composableBuilder(column: $table.timerType, builder: (column) => column);

  GeneratedColumn<int> get countupElapsedSeconds => $composableBuilder(
      column: $table.countupElapsedSeconds, builder: (column) => column);

  GeneratedColumn<int> get pomodoroWorkMinutes => $composableBuilder(
      column: $table.pomodoroWorkMinutes, builder: (column) => column);

  GeneratedColumn<int> get pomodoroShortBreakMinutes => $composableBuilder(
      column: $table.pomodoroShortBreakMinutes, builder: (column) => column);

  GeneratedColumn<int> get pomodoroLongBreakMinutes => $composableBuilder(
      column: $table.pomodoroLongBreakMinutes, builder: (column) => column);

  GeneratedColumn<int> get pomodoroCycle => $composableBuilder(
      column: $table.pomodoroCycle, builder: (column) => column);

  GeneratedColumn<int> get pomodoroCompletedCycle => $composableBuilder(
      column: $table.pomodoroCompletedCycle, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TodosTableAnnotationComposer get parentTodoId {
    final $$TodosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentTodoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableAnnotationComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> todoCheckListItemsRefs<T extends Object>(
      Expression<T> Function($$TodoCheckListItemsTableAnnotationComposer a) f) {
    final $$TodoCheckListItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.todoCheckListItems,
            getReferencedColumn: (t) => t.todoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$TodoCheckListItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.todoCheckListItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$TodosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodosTable,
    Todo,
    $$TodosTableFilterComposer,
    $$TodosTableOrderingComposer,
    $$TodosTableAnnotationComposer,
    $$TodosTableCreateCompanionBuilder,
    $$TodosTableUpdateCompanionBuilder,
    (Todo, $$TodosTableReferences),
    Todo,
    PrefetchHooks Function(
        {bool categoryId, bool parentTodoId, bool todoCheckListItemsRefs})> {
  $$TodosTableTableManager(_$AppDatabase db, $TodosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurringType = const Value.absent(),
            Value<DateTime?> recurringEndDate = const Value.absent(),
            Value<int?> parentTodoId = const Value.absent(),
            Value<String> timerType = const Value.absent(),
            Value<int?> countupElapsedSeconds = const Value.absent(),
            Value<int?> pomodoroWorkMinutes = const Value.absent(),
            Value<int?> pomodoroShortBreakMinutes = const Value.absent(),
            Value<int?> pomodoroLongBreakMinutes = const Value.absent(),
            Value<int?> pomodoroCycle = const Value.absent(),
            Value<int?> pomodoroCompletedCycle = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              TodosCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            title: title,
            dueDate: dueDate,
            description: description,
            isCompleted: isCompleted,
            color: color,
            categoryId: categoryId,
            icon: icon,
            isRecurring: isRecurring,
            recurringType: recurringType,
            recurringEndDate: recurringEndDate,
            parentTodoId: parentTodoId,
            timerType: timerType,
            countupElapsedSeconds: countupElapsedSeconds,
            pomodoroWorkMinutes: pomodoroWorkMinutes,
            pomodoroShortBreakMinutes: pomodoroShortBreakMinutes,
            pomodoroLongBreakMinutes: pomodoroLongBreakMinutes,
            pomodoroCycle: pomodoroCycle,
            pomodoroCompletedCycle: pomodoroCompletedCycle,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            required String title,
            required DateTime dueDate,
            Value<String?> description = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurringType = const Value.absent(),
            Value<DateTime?> recurringEndDate = const Value.absent(),
            Value<int?> parentTodoId = const Value.absent(),
            Value<String> timerType = const Value.absent(),
            Value<int?> countupElapsedSeconds = const Value.absent(),
            Value<int?> pomodoroWorkMinutes = const Value.absent(),
            Value<int?> pomodoroShortBreakMinutes = const Value.absent(),
            Value<int?> pomodoroLongBreakMinutes = const Value.absent(),
            Value<int?> pomodoroCycle = const Value.absent(),
            Value<int?> pomodoroCompletedCycle = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              TodosCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            title: title,
            dueDate: dueDate,
            description: description,
            isCompleted: isCompleted,
            color: color,
            categoryId: categoryId,
            icon: icon,
            isRecurring: isRecurring,
            recurringType: recurringType,
            recurringEndDate: recurringEndDate,
            parentTodoId: parentTodoId,
            timerType: timerType,
            countupElapsedSeconds: countupElapsedSeconds,
            pomodoroWorkMinutes: pomodoroWorkMinutes,
            pomodoroShortBreakMinutes: pomodoroShortBreakMinutes,
            pomodoroLongBreakMinutes: pomodoroLongBreakMinutes,
            pomodoroCycle: pomodoroCycle,
            pomodoroCompletedCycle: pomodoroCompletedCycle,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TodosTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false,
              parentTodoId = false,
              todoCheckListItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (todoCheckListItemsRefs) db.todoCheckListItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$TodosTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$TodosTableReferences._categoryIdTable(db).id,
                  ) as T;
                }
                if (parentTodoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentTodoId,
                    referencedTable:
                        $$TodosTableReferences._parentTodoIdTable(db),
                    referencedColumn:
                        $$TodosTableReferences._parentTodoIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (todoCheckListItemsRefs)
                    await $_getPrefetchedData<Todo, $TodosTable,
                            TodoCheckListItem>(
                        currentTable: table,
                        referencedTable: $$TodosTableReferences
                            ._todoCheckListItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TodosTableReferences(db, table, p0)
                                .todoCheckListItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.todoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TodosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodosTable,
    Todo,
    $$TodosTableFilterComposer,
    $$TodosTableOrderingComposer,
    $$TodosTableAnnotationComposer,
    $$TodosTableCreateCompanionBuilder,
    $$TodosTableUpdateCompanionBuilder,
    (Todo, $$TodosTableReferences),
    Todo,
    PrefetchHooks Function(
        {bool categoryId, bool parentTodoId, bool todoCheckListItemsRefs})>;
typedef $$TodoCheckListItemsTableCreateCompanionBuilder
    = TodoCheckListItemsCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  required int todoId,
  required String title,
  Value<bool> isCompleted,
  required int order,
});
typedef $$TodoCheckListItemsTableUpdateCompanionBuilder
    = TodoCheckListItemsCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> todoId,
  Value<String> title,
  Value<bool> isCompleted,
  Value<int> order,
});

final class $$TodoCheckListItemsTableReferences extends BaseReferences<
    _$AppDatabase, $TodoCheckListItemsTable, TodoCheckListItem> {
  $$TodoCheckListItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TodosTable _todoIdTable(_$AppDatabase db) => db.todos.createAlias(
      $_aliasNameGenerator(db.todoCheckListItems.todoId, db.todos.id));

  $$TodosTableProcessedTableManager get todoId {
    final $_column = $_itemColumn<int>('todo_id')!;

    final manager = $$TodosTableTableManager($_db, $_db.todos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_todoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TodoCheckListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TodoCheckListItemsTable> {
  $$TodoCheckListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  $$TodosTableFilterComposer get todoId {
    final $$TodosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.todoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableFilterComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TodoCheckListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoCheckListItemsTable> {
  $$TodoCheckListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  $$TodosTableOrderingComposer get todoId {
    final $$TodosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.todoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableOrderingComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TodoCheckListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoCheckListItemsTable> {
  $$TodoCheckListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  $$TodosTableAnnotationComposer get todoId {
    final $$TodosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.todoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableAnnotationComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TodoCheckListItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodoCheckListItemsTable,
    TodoCheckListItem,
    $$TodoCheckListItemsTableFilterComposer,
    $$TodoCheckListItemsTableOrderingComposer,
    $$TodoCheckListItemsTableAnnotationComposer,
    $$TodoCheckListItemsTableCreateCompanionBuilder,
    $$TodoCheckListItemsTableUpdateCompanionBuilder,
    (TodoCheckListItem, $$TodoCheckListItemsTableReferences),
    TodoCheckListItem,
    PrefetchHooks Function({bool todoId})> {
  $$TodoCheckListItemsTableTableManager(
      _$AppDatabase db, $TodoCheckListItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoCheckListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoCheckListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoCheckListItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> todoId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> order = const Value.absent(),
          }) =>
              TodoCheckListItemsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            todoId: todoId,
            title: title,
            isCompleted: isCompleted,
            order: order,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            required int todoId,
            required String title,
            Value<bool> isCompleted = const Value.absent(),
            required int order,
          }) =>
              TodoCheckListItemsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            todoId: todoId,
            title: title,
            isCompleted: isCompleted,
            order: order,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TodoCheckListItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({todoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (todoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.todoId,
                    referencedTable:
                        $$TodoCheckListItemsTableReferences._todoIdTable(db),
                    referencedColumn:
                        $$TodoCheckListItemsTableReferences._todoIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TodoCheckListItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodoCheckListItemsTable,
    TodoCheckListItem,
    $$TodoCheckListItemsTableFilterComposer,
    $$TodoCheckListItemsTableOrderingComposer,
    $$TodoCheckListItemsTableAnnotationComposer,
    $$TodoCheckListItemsTableCreateCompanionBuilder,
    $$TodoCheckListItemsTableUpdateCompanionBuilder,
    (TodoCheckListItem, $$TodoCheckListItemsTableReferences),
    TodoCheckListItem,
    PrefetchHooks Function({bool todoId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
  $$TodoCheckListItemsTableTableManager get todoCheckListItems =>
      $$TodoCheckListItemsTableTableManager(_db, _db.todoCheckListItems);
}
