// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../drift.dart';

// ignore_for_file: type=lint
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
  static const VerificationMeta _recurringDayOfWeekMeta =
      const VerificationMeta('recurringDayOfWeek');
  @override
  late final GeneratedColumn<int> recurringDayOfWeek = GeneratedColumn<int>(
      'recurring_day_of_week', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _recurringDayOfMonthMeta =
      const VerificationMeta('recurringDayOfMonth');
  @override
  late final GeneratedColumn<int> recurringDayOfMonth = GeneratedColumn<int>(
      'recurring_day_of_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
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
        icon,
        isRecurring,
        recurringType,
        recurringEndDate,
        recurringDayOfWeek,
        recurringDayOfMonth
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
    if (data.containsKey('recurring_day_of_week')) {
      context.handle(
          _recurringDayOfWeekMeta,
          recurringDayOfWeek.isAcceptableOrUnknown(
              data['recurring_day_of_week']!, _recurringDayOfWeekMeta));
    }
    if (data.containsKey('recurring_day_of_month')) {
      context.handle(
          _recurringDayOfMonthMeta,
          recurringDayOfMonth.isAcceptableOrUnknown(
              data['recurring_day_of_month']!, _recurringDayOfMonthMeta));
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
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      isRecurring: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
      recurringType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurring_type']),
      recurringEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}recurring_end_date']),
      recurringDayOfWeek: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}recurring_day_of_week']),
      recurringDayOfMonth: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}recurring_day_of_month']),
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
  final String? icon;
  final bool isRecurring;
  final String? recurringType;
  final DateTime? recurringEndDate;
  final int? recurringDayOfWeek;
  final int? recurringDayOfMonth;
  const Todo(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.title,
      required this.dueDate,
      this.description,
      required this.isCompleted,
      this.color,
      this.icon,
      required this.isRecurring,
      this.recurringType,
      this.recurringEndDate,
      this.recurringDayOfWeek,
      this.recurringDayOfMonth});
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
    if (!nullToAbsent || recurringDayOfWeek != null) {
      map['recurring_day_of_week'] = Variable<int>(recurringDayOfWeek);
    }
    if (!nullToAbsent || recurringDayOfMonth != null) {
      map['recurring_day_of_month'] = Variable<int>(recurringDayOfMonth);
    }
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
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      isRecurring: Value(isRecurring),
      recurringType: recurringType == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringType),
      recurringEndDate: recurringEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringEndDate),
      recurringDayOfWeek: recurringDayOfWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringDayOfWeek),
      recurringDayOfMonth: recurringDayOfMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringDayOfMonth),
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
      icon: serializer.fromJson<String?>(json['icon']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurringType: serializer.fromJson<String?>(json['recurringType']),
      recurringEndDate:
          serializer.fromJson<DateTime?>(json['recurringEndDate']),
      recurringDayOfWeek: serializer.fromJson<int?>(json['recurringDayOfWeek']),
      recurringDayOfMonth:
          serializer.fromJson<int?>(json['recurringDayOfMonth']),
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
      'icon': serializer.toJson<String?>(icon),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurringType': serializer.toJson<String?>(recurringType),
      'recurringEndDate': serializer.toJson<DateTime?>(recurringEndDate),
      'recurringDayOfWeek': serializer.toJson<int?>(recurringDayOfWeek),
      'recurringDayOfMonth': serializer.toJson<int?>(recurringDayOfMonth),
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
          Value<String?> icon = const Value.absent(),
          bool? isRecurring,
          Value<String?> recurringType = const Value.absent(),
          Value<DateTime?> recurringEndDate = const Value.absent(),
          Value<int?> recurringDayOfWeek = const Value.absent(),
          Value<int?> recurringDayOfMonth = const Value.absent()}) =>
      Todo(
        id: id ?? this.id,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        title: title ?? this.title,
        dueDate: dueDate ?? this.dueDate,
        description: description.present ? description.value : this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        color: color.present ? color.value : this.color,
        icon: icon.present ? icon.value : this.icon,
        isRecurring: isRecurring ?? this.isRecurring,
        recurringType:
            recurringType.present ? recurringType.value : this.recurringType,
        recurringEndDate: recurringEndDate.present
            ? recurringEndDate.value
            : this.recurringEndDate,
        recurringDayOfWeek: recurringDayOfWeek.present
            ? recurringDayOfWeek.value
            : this.recurringDayOfWeek,
        recurringDayOfMonth: recurringDayOfMonth.present
            ? recurringDayOfMonth.value
            : this.recurringDayOfMonth,
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
      icon: data.icon.present ? data.icon.value : this.icon,
      isRecurring:
          data.isRecurring.present ? data.isRecurring.value : this.isRecurring,
      recurringType: data.recurringType.present
          ? data.recurringType.value
          : this.recurringType,
      recurringEndDate: data.recurringEndDate.present
          ? data.recurringEndDate.value
          : this.recurringEndDate,
      recurringDayOfWeek: data.recurringDayOfWeek.present
          ? data.recurringDayOfWeek.value
          : this.recurringDayOfWeek,
      recurringDayOfMonth: data.recurringDayOfMonth.present
          ? data.recurringDayOfMonth.value
          : this.recurringDayOfMonth,
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
          ..write('icon: $icon, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringType: $recurringType, ')
          ..write('recurringEndDate: $recurringEndDate, ')
          ..write('recurringDayOfWeek: $recurringDayOfWeek, ')
          ..write('recurringDayOfMonth: $recurringDayOfMonth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      title,
      dueDate,
      description,
      isCompleted,
      color,
      icon,
      isRecurring,
      recurringType,
      recurringEndDate,
      recurringDayOfWeek,
      recurringDayOfMonth);
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
          other.icon == this.icon &&
          other.isRecurring == this.isRecurring &&
          other.recurringType == this.recurringType &&
          other.recurringEndDate == this.recurringEndDate &&
          other.recurringDayOfWeek == this.recurringDayOfWeek &&
          other.recurringDayOfMonth == this.recurringDayOfMonth);
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
  final Value<String?> icon;
  final Value<bool> isRecurring;
  final Value<String?> recurringType;
  final Value<DateTime?> recurringEndDate;
  final Value<int?> recurringDayOfWeek;
  final Value<int?> recurringDayOfMonth;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringType = const Value.absent(),
    this.recurringEndDate = const Value.absent(),
    this.recurringDayOfWeek = const Value.absent(),
    this.recurringDayOfMonth = const Value.absent(),
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
    this.icon = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringType = const Value.absent(),
    this.recurringEndDate = const Value.absent(),
    this.recurringDayOfWeek = const Value.absent(),
    this.recurringDayOfMonth = const Value.absent(),
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
    Expression<String>? icon,
    Expression<bool>? isRecurring,
    Expression<String>? recurringType,
    Expression<DateTime>? recurringEndDate,
    Expression<int>? recurringDayOfWeek,
    Expression<int>? recurringDayOfMonth,
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
      if (icon != null) 'icon': icon,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurringType != null) 'recurring_type': recurringType,
      if (recurringEndDate != null) 'recurring_end_date': recurringEndDate,
      if (recurringDayOfWeek != null)
        'recurring_day_of_week': recurringDayOfWeek,
      if (recurringDayOfMonth != null)
        'recurring_day_of_month': recurringDayOfMonth,
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
      Value<String?>? icon,
      Value<bool>? isRecurring,
      Value<String?>? recurringType,
      Value<DateTime?>? recurringEndDate,
      Value<int?>? recurringDayOfWeek,
      Value<int?>? recurringDayOfMonth}) {
    return TodosCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringType: recurringType ?? this.recurringType,
      recurringEndDate: recurringEndDate ?? this.recurringEndDate,
      recurringDayOfWeek: recurringDayOfWeek ?? this.recurringDayOfWeek,
      recurringDayOfMonth: recurringDayOfMonth ?? this.recurringDayOfMonth,
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
    if (recurringDayOfWeek.present) {
      map['recurring_day_of_week'] = Variable<int>(recurringDayOfWeek.value);
    }
    if (recurringDayOfMonth.present) {
      map['recurring_day_of_month'] = Variable<int>(recurringDayOfMonth.value);
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
          ..write('icon: $icon, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringType: $recurringType, ')
          ..write('recurringEndDate: $recurringEndDate, ')
          ..write('recurringDayOfWeek: $recurringDayOfWeek, ')
          ..write('recurringDayOfMonth: $recurringDayOfMonth')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodosTable todos = $TodosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [todos];
}

typedef $$TodosTableCreateCompanionBuilder = TodosCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  required String title,
  required DateTime dueDate,
  Value<String?> description,
  Value<bool> isCompleted,
  Value<String?> color,
  Value<String?> icon,
  Value<bool> isRecurring,
  Value<String?> recurringType,
  Value<DateTime?> recurringEndDate,
  Value<int?> recurringDayOfWeek,
  Value<int?> recurringDayOfMonth,
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
  Value<String?> icon,
  Value<bool> isRecurring,
  Value<String?> recurringType,
  Value<DateTime?> recurringEndDate,
  Value<int?> recurringDayOfWeek,
  Value<int?> recurringDayOfMonth,
});

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

  ColumnFilters<int> get recurringDayOfWeek => $composableBuilder(
      column: $table.recurringDayOfWeek,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recurringDayOfMonth => $composableBuilder(
      column: $table.recurringDayOfMonth,
      builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<int> get recurringDayOfWeek => $composableBuilder(
      column: $table.recurringDayOfWeek,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recurringDayOfMonth => $composableBuilder(
      column: $table.recurringDayOfMonth,
      builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<int> get recurringDayOfWeek => $composableBuilder(
      column: $table.recurringDayOfWeek, builder: (column) => column);

  GeneratedColumn<int> get recurringDayOfMonth => $composableBuilder(
      column: $table.recurringDayOfMonth, builder: (column) => column);
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
    (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
    Todo,
    PrefetchHooks Function()> {
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
            Value<String?> icon = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurringType = const Value.absent(),
            Value<DateTime?> recurringEndDate = const Value.absent(),
            Value<int?> recurringDayOfWeek = const Value.absent(),
            Value<int?> recurringDayOfMonth = const Value.absent(),
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
            icon: icon,
            isRecurring: isRecurring,
            recurringType: recurringType,
            recurringEndDate: recurringEndDate,
            recurringDayOfWeek: recurringDayOfWeek,
            recurringDayOfMonth: recurringDayOfMonth,
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
            Value<String?> icon = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurringType = const Value.absent(),
            Value<DateTime?> recurringEndDate = const Value.absent(),
            Value<int?> recurringDayOfWeek = const Value.absent(),
            Value<int?> recurringDayOfMonth = const Value.absent(),
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
            icon: icon,
            isRecurring: isRecurring,
            recurringType: recurringType,
            recurringEndDate: recurringEndDate,
            recurringDayOfWeek: recurringDayOfWeek,
            recurringDayOfMonth: recurringDayOfMonth,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
    (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
    Todo,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
}
