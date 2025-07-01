// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../drift.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastLoginTimeMeta =
      const VerificationMeta('lastLoginTime');
  @override
  late final GeneratedColumn<DateTime> lastLoginTime =
      GeneratedColumn<DateTime>('last_login_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _defaultWorkSettingIdMeta =
      const VerificationMeta('defaultWorkSettingId');
  @override
  late final GeneratedColumn<int> defaultWorkSettingId = GeneratedColumn<int>(
      'default_work_setting_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        name,
        email,
        lastLoginTime,
        defaultWorkSettingId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
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
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('last_login_time')) {
      context.handle(
          _lastLoginTimeMeta,
          lastLoginTime.isAcceptableOrUnknown(
              data['last_login_time']!, _lastLoginTimeMeta));
    }
    if (data.containsKey('default_work_setting_id')) {
      context.handle(
          _defaultWorkSettingIdMeta,
          defaultWorkSettingId.isAcceptableOrUnknown(
              data['default_work_setting_id']!, _defaultWorkSettingIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      lastLoginTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_login_time']),
      defaultWorkSettingId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}default_work_setting_id']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String name;
  final String email;
  final DateTime? lastLoginTime;
  final int? defaultWorkSettingId;
  const User(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.name,
      required this.email,
      this.lastLoginTime,
      this.defaultWorkSettingId});
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
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || lastLoginTime != null) {
      map['last_login_time'] = Variable<DateTime>(lastLoginTime);
    }
    if (!nullToAbsent || defaultWorkSettingId != null) {
      map['default_work_setting_id'] = Variable<int>(defaultWorkSettingId);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      name: Value(name),
      email: Value(email),
      lastLoginTime: lastLoginTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginTime),
      defaultWorkSettingId: defaultWorkSettingId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultWorkSettingId),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      lastLoginTime: serializer.fromJson<DateTime?>(json['lastLoginTime']),
      defaultWorkSettingId:
          serializer.fromJson<int?>(json['defaultWorkSettingId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'lastLoginTime': serializer.toJson<DateTime?>(lastLoginTime),
      'defaultWorkSettingId': serializer.toJson<int?>(defaultWorkSettingId),
    };
  }

  User copyWith(
          {int? id,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          String? name,
          String? email,
          Value<DateTime?> lastLoginTime = const Value.absent(),
          Value<int?> defaultWorkSettingId = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        name: name ?? this.name,
        email: email ?? this.email,
        lastLoginTime:
            lastLoginTime.present ? lastLoginTime.value : this.lastLoginTime,
        defaultWorkSettingId: defaultWorkSettingId.present
            ? defaultWorkSettingId.value
            : this.defaultWorkSettingId,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      lastLoginTime: data.lastLoginTime.present
          ? data.lastLoginTime.value
          : this.lastLoginTime,
      defaultWorkSettingId: data.defaultWorkSettingId.present
          ? data.defaultWorkSettingId.value
          : this.defaultWorkSettingId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('lastLoginTime: $lastLoginTime, ')
          ..write('defaultWorkSettingId: $defaultWorkSettingId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, name, email,
      lastLoginTime, defaultWorkSettingId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.name == this.name &&
          other.email == this.email &&
          other.lastLoginTime == this.lastLoginTime &&
          other.defaultWorkSettingId == this.defaultWorkSettingId);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> name;
  final Value<String> email;
  final Value<DateTime?> lastLoginTime;
  final Value<int?> defaultWorkSettingId;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.lastLoginTime = const Value.absent(),
    this.defaultWorkSettingId = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String name,
    required String email,
    this.lastLoginTime = const Value.absent(),
    this.defaultWorkSettingId = const Value.absent(),
  })  : name = Value(name),
        email = Value(email);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? name,
    Expression<String>? email,
    Expression<DateTime>? lastLoginTime,
    Expression<int>? defaultWorkSettingId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (lastLoginTime != null) 'last_login_time': lastLoginTime,
      if (defaultWorkSettingId != null)
        'default_work_setting_id': defaultWorkSettingId,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String>? name,
      Value<String>? email,
      Value<DateTime?>? lastLoginTime,
      Value<int?>? defaultWorkSettingId}) {
    return UsersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      email: email ?? this.email,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
      defaultWorkSettingId: defaultWorkSettingId ?? this.defaultWorkSettingId,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (lastLoginTime.present) {
      map['last_login_time'] = Variable<DateTime>(lastLoginTime.value);
    }
    if (defaultWorkSettingId.present) {
      map['default_work_setting_id'] =
          Variable<int>(defaultWorkSettingId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('lastLoginTime: $lastLoginTime, ')
          ..write('defaultWorkSettingId: $defaultWorkSettingId')
          ..write(')'))
        .toString();
  }
}

class $WorkSettingsTable extends WorkSettings
    with TableInfo<$WorkSettingsTable, WorkSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkSettingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
      'start', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
      'end', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _restStartMeta =
      const VerificationMeta('restStart');
  @override
  late final GeneratedColumn<DateTime> restStart = GeneratedColumn<DateTime>(
      'rest_start', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _restEndMeta =
      const VerificationMeta('restEnd');
  @override
  late final GeneratedColumn<DateTime> restEnd = GeneratedColumn<DateTime>(
      'rest_end', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
      'memo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _workingUnitMeta =
      const VerificationMeta('workingUnit');
  @override
  late final GeneratedColumn<int> workingUnit = GeneratedColumn<int>(
      'working_unit', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        title,
        start,
        end,
        restStart,
        restEnd,
        memo,
        workingUnit,
        userId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_settings';
  @override
  VerificationContext validateIntegrity(Insertable<WorkSetting> instance,
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
    if (data.containsKey('start')) {
      context.handle(
          _startMeta, start.isAcceptableOrUnknown(data['start']!, _startMeta));
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
          _endMeta, end.isAcceptableOrUnknown(data['end']!, _endMeta));
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('rest_start')) {
      context.handle(_restStartMeta,
          restStart.isAcceptableOrUnknown(data['rest_start']!, _restStartMeta));
    } else if (isInserting) {
      context.missing(_restStartMeta);
    }
    if (data.containsKey('rest_end')) {
      context.handle(_restEndMeta,
          restEnd.isAcceptableOrUnknown(data['rest_end']!, _restEndMeta));
    } else if (isInserting) {
      context.missing(_restEndMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
          _memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    if (data.containsKey('working_unit')) {
      context.handle(
          _workingUnitMeta,
          workingUnit.isAcceptableOrUnknown(
              data['working_unit']!, _workingUnitMeta));
    } else if (isInserting) {
      context.missing(_workingUnitMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      start: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start'])!,
      end: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end'])!,
      restStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}rest_start'])!,
      restEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}rest_end'])!,
      memo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memo']),
      workingUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}working_unit'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
    );
  }

  @override
  $WorkSettingsTable createAlias(String alias) {
    return $WorkSettingsTable(attachedDatabase, alias);
  }
}

class WorkSetting extends DataClass implements Insertable<WorkSetting> {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String title;
  final DateTime start;
  final DateTime end;
  final DateTime restStart;
  final DateTime restEnd;
  final String? memo;
  final int workingUnit;
  final int userId;
  const WorkSetting(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.title,
      required this.start,
      required this.end,
      required this.restStart,
      required this.restEnd,
      this.memo,
      required this.workingUnit,
      required this.userId});
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
    map['start'] = Variable<DateTime>(start);
    map['end'] = Variable<DateTime>(end);
    map['rest_start'] = Variable<DateTime>(restStart);
    map['rest_end'] = Variable<DateTime>(restEnd);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['working_unit'] = Variable<int>(workingUnit);
    map['user_id'] = Variable<int>(userId);
    return map;
  }

  WorkSettingsCompanion toCompanion(bool nullToAbsent) {
    return WorkSettingsCompanion(
      id: Value(id),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      title: Value(title),
      start: Value(start),
      end: Value(end),
      restStart: Value(restStart),
      restEnd: Value(restEnd),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      workingUnit: Value(workingUnit),
      userId: Value(userId),
    );
  }

  factory WorkSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkSetting(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      title: serializer.fromJson<String>(json['title']),
      start: serializer.fromJson<DateTime>(json['start']),
      end: serializer.fromJson<DateTime>(json['end']),
      restStart: serializer.fromJson<DateTime>(json['restStart']),
      restEnd: serializer.fromJson<DateTime>(json['restEnd']),
      memo: serializer.fromJson<String?>(json['memo']),
      workingUnit: serializer.fromJson<int>(json['workingUnit']),
      userId: serializer.fromJson<int>(json['userId']),
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
      'start': serializer.toJson<DateTime>(start),
      'end': serializer.toJson<DateTime>(end),
      'restStart': serializer.toJson<DateTime>(restStart),
      'restEnd': serializer.toJson<DateTime>(restEnd),
      'memo': serializer.toJson<String?>(memo),
      'workingUnit': serializer.toJson<int>(workingUnit),
      'userId': serializer.toJson<int>(userId),
    };
  }

  WorkSetting copyWith(
          {int? id,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          String? title,
          DateTime? start,
          DateTime? end,
          DateTime? restStart,
          DateTime? restEnd,
          Value<String?> memo = const Value.absent(),
          int? workingUnit,
          int? userId}) =>
      WorkSetting(
        id: id ?? this.id,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        title: title ?? this.title,
        start: start ?? this.start,
        end: end ?? this.end,
        restStart: restStart ?? this.restStart,
        restEnd: restEnd ?? this.restEnd,
        memo: memo.present ? memo.value : this.memo,
        workingUnit: workingUnit ?? this.workingUnit,
        userId: userId ?? this.userId,
      );
  WorkSetting copyWithCompanion(WorkSettingsCompanion data) {
    return WorkSetting(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      title: data.title.present ? data.title.value : this.title,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      restStart: data.restStart.present ? data.restStart.value : this.restStart,
      restEnd: data.restEnd.present ? data.restEnd.value : this.restEnd,
      memo: data.memo.present ? data.memo.value : this.memo,
      workingUnit:
          data.workingUnit.present ? data.workingUnit.value : this.workingUnit,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkSetting(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('restStart: $restStart, ')
          ..write('restEnd: $restEnd, ')
          ..write('memo: $memo, ')
          ..write('workingUnit: $workingUnit, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, title, start, end,
      restStart, restEnd, memo, workingUnit, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkSetting &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.title == this.title &&
          other.start == this.start &&
          other.end == this.end &&
          other.restStart == this.restStart &&
          other.restEnd == this.restEnd &&
          other.memo == this.memo &&
          other.workingUnit == this.workingUnit &&
          other.userId == this.userId);
}

class WorkSettingsCompanion extends UpdateCompanion<WorkSetting> {
  final Value<int> id;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> title;
  final Value<DateTime> start;
  final Value<DateTime> end;
  final Value<DateTime> restStart;
  final Value<DateTime> restEnd;
  final Value<String?> memo;
  final Value<int> workingUnit;
  final Value<int> userId;
  const WorkSettingsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.restStart = const Value.absent(),
    this.restEnd = const Value.absent(),
    this.memo = const Value.absent(),
    this.workingUnit = const Value.absent(),
    this.userId = const Value.absent(),
  });
  WorkSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String title,
    required DateTime start,
    required DateTime end,
    required DateTime restStart,
    required DateTime restEnd,
    this.memo = const Value.absent(),
    required int workingUnit,
    required int userId,
  })  : title = Value(title),
        start = Value(start),
        end = Value(end),
        restStart = Value(restStart),
        restEnd = Value(restEnd),
        workingUnit = Value(workingUnit),
        userId = Value(userId);
  static Insertable<WorkSetting> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? title,
    Expression<DateTime>? start,
    Expression<DateTime>? end,
    Expression<DateTime>? restStart,
    Expression<DateTime>? restEnd,
    Expression<String>? memo,
    Expression<int>? workingUnit,
    Expression<int>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (title != null) 'title': title,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (restStart != null) 'rest_start': restStart,
      if (restEnd != null) 'rest_end': restEnd,
      if (memo != null) 'memo': memo,
      if (workingUnit != null) 'working_unit': workingUnit,
      if (userId != null) 'user_id': userId,
    });
  }

  WorkSettingsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String>? title,
      Value<DateTime>? start,
      Value<DateTime>? end,
      Value<DateTime>? restStart,
      Value<DateTime>? restEnd,
      Value<String?>? memo,
      Value<int>? workingUnit,
      Value<int>? userId}) {
    return WorkSettingsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      start: start ?? this.start,
      end: end ?? this.end,
      restStart: restStart ?? this.restStart,
      restEnd: restEnd ?? this.restEnd,
      memo: memo ?? this.memo,
      workingUnit: workingUnit ?? this.workingUnit,
      userId: userId ?? this.userId,
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
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (restStart.present) {
      map['rest_start'] = Variable<DateTime>(restStart.value);
    }
    if (restEnd.present) {
      map['rest_end'] = Variable<DateTime>(restEnd.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (workingUnit.present) {
      map['working_unit'] = Variable<int>(workingUnit.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkSettingsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('restStart: $restStart, ')
          ..write('restEnd: $restEnd, ')
          ..write('memo: $memo, ')
          ..write('workingUnit: $workingUnit, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

class $WorkTimesTable extends WorkTimes
    with TableInfo<$WorkTimesTable, WorkTime> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkTimesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _targetDayMeta =
      const VerificationMeta('targetDay');
  @override
  late final GeneratedColumn<String> targetDay = GeneratedColumn<String>(
      'target_day', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
      'start', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
      'end', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _restStartMeta =
      const VerificationMeta('restStart');
  @override
  late final GeneratedColumn<DateTime> restStart = GeneratedColumn<DateTime>(
      'rest_start', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _restEndMeta =
      const VerificationMeta('restEnd');
  @override
  late final GeneratedColumn<DateTime> restEnd = GeneratedColumn<DateTime>(
      'rest_end', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
      'memo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        targetDay,
        start,
        end,
        restStart,
        restEnd,
        memo,
        userId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_times';
  @override
  VerificationContext validateIntegrity(Insertable<WorkTime> instance,
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
    if (data.containsKey('target_day')) {
      context.handle(_targetDayMeta,
          targetDay.isAcceptableOrUnknown(data['target_day']!, _targetDayMeta));
    } else if (isInserting) {
      context.missing(_targetDayMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
          _startMeta, start.isAcceptableOrUnknown(data['start']!, _startMeta));
    }
    if (data.containsKey('end')) {
      context.handle(
          _endMeta, end.isAcceptableOrUnknown(data['end']!, _endMeta));
    }
    if (data.containsKey('rest_start')) {
      context.handle(_restStartMeta,
          restStart.isAcceptableOrUnknown(data['rest_start']!, _restStartMeta));
    }
    if (data.containsKey('rest_end')) {
      context.handle(_restEndMeta,
          restEnd.isAcceptableOrUnknown(data['rest_end']!, _restEndMeta));
    }
    if (data.containsKey('memo')) {
      context.handle(
          _memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkTime map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkTime(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      targetDay: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_day'])!,
      start: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start']),
      end: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end']),
      restStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}rest_start']),
      restEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}rest_end']),
      memo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memo']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
    );
  }

  @override
  $WorkTimesTable createAlias(String alias) {
    return $WorkTimesTable(attachedDatabase, alias);
  }
}

class WorkTime extends DataClass implements Insertable<WorkTime> {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String targetDay;
  final DateTime? start;
  final DateTime? end;
  final DateTime? restStart;
  final DateTime? restEnd;
  final String? memo;
  final int userId;
  const WorkTime(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.targetDay,
      this.start,
      this.end,
      this.restStart,
      this.restEnd,
      this.memo,
      required this.userId});
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
    map['target_day'] = Variable<String>(targetDay);
    if (!nullToAbsent || start != null) {
      map['start'] = Variable<DateTime>(start);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<DateTime>(end);
    }
    if (!nullToAbsent || restStart != null) {
      map['rest_start'] = Variable<DateTime>(restStart);
    }
    if (!nullToAbsent || restEnd != null) {
      map['rest_end'] = Variable<DateTime>(restEnd);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['user_id'] = Variable<int>(userId);
    return map;
  }

  WorkTimesCompanion toCompanion(bool nullToAbsent) {
    return WorkTimesCompanion(
      id: Value(id),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      targetDay: Value(targetDay),
      start:
          start == null && nullToAbsent ? const Value.absent() : Value(start),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      restStart: restStart == null && nullToAbsent
          ? const Value.absent()
          : Value(restStart),
      restEnd: restEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(restEnd),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      userId: Value(userId),
    );
  }

  factory WorkTime.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkTime(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      targetDay: serializer.fromJson<String>(json['targetDay']),
      start: serializer.fromJson<DateTime?>(json['start']),
      end: serializer.fromJson<DateTime?>(json['end']),
      restStart: serializer.fromJson<DateTime?>(json['restStart']),
      restEnd: serializer.fromJson<DateTime?>(json['restEnd']),
      memo: serializer.fromJson<String?>(json['memo']),
      userId: serializer.fromJson<int>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'targetDay': serializer.toJson<String>(targetDay),
      'start': serializer.toJson<DateTime?>(start),
      'end': serializer.toJson<DateTime?>(end),
      'restStart': serializer.toJson<DateTime?>(restStart),
      'restEnd': serializer.toJson<DateTime?>(restEnd),
      'memo': serializer.toJson<String?>(memo),
      'userId': serializer.toJson<int>(userId),
    };
  }

  WorkTime copyWith(
          {int? id,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          String? targetDay,
          Value<DateTime?> start = const Value.absent(),
          Value<DateTime?> end = const Value.absent(),
          Value<DateTime?> restStart = const Value.absent(),
          Value<DateTime?> restEnd = const Value.absent(),
          Value<String?> memo = const Value.absent(),
          int? userId}) =>
      WorkTime(
        id: id ?? this.id,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        targetDay: targetDay ?? this.targetDay,
        start: start.present ? start.value : this.start,
        end: end.present ? end.value : this.end,
        restStart: restStart.present ? restStart.value : this.restStart,
        restEnd: restEnd.present ? restEnd.value : this.restEnd,
        memo: memo.present ? memo.value : this.memo,
        userId: userId ?? this.userId,
      );
  WorkTime copyWithCompanion(WorkTimesCompanion data) {
    return WorkTime(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      targetDay: data.targetDay.present ? data.targetDay.value : this.targetDay,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      restStart: data.restStart.present ? data.restStart.value : this.restStart,
      restEnd: data.restEnd.present ? data.restEnd.value : this.restEnd,
      memo: data.memo.present ? data.memo.value : this.memo,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkTime(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('targetDay: $targetDay, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('restStart: $restStart, ')
          ..write('restEnd: $restEnd, ')
          ..write('memo: $memo, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, targetDay, start,
      end, restStart, restEnd, memo, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkTime &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.targetDay == this.targetDay &&
          other.start == this.start &&
          other.end == this.end &&
          other.restStart == this.restStart &&
          other.restEnd == this.restEnd &&
          other.memo == this.memo &&
          other.userId == this.userId);
}

class WorkTimesCompanion extends UpdateCompanion<WorkTime> {
  final Value<int> id;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> targetDay;
  final Value<DateTime?> start;
  final Value<DateTime?> end;
  final Value<DateTime?> restStart;
  final Value<DateTime?> restEnd;
  final Value<String?> memo;
  final Value<int> userId;
  const WorkTimesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.targetDay = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.restStart = const Value.absent(),
    this.restEnd = const Value.absent(),
    this.memo = const Value.absent(),
    this.userId = const Value.absent(),
  });
  WorkTimesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String targetDay,
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.restStart = const Value.absent(),
    this.restEnd = const Value.absent(),
    this.memo = const Value.absent(),
    required int userId,
  })  : targetDay = Value(targetDay),
        userId = Value(userId);
  static Insertable<WorkTime> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? targetDay,
    Expression<DateTime>? start,
    Expression<DateTime>? end,
    Expression<DateTime>? restStart,
    Expression<DateTime>? restEnd,
    Expression<String>? memo,
    Expression<int>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (targetDay != null) 'target_day': targetDay,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (restStart != null) 'rest_start': restStart,
      if (restEnd != null) 'rest_end': restEnd,
      if (memo != null) 'memo': memo,
      if (userId != null) 'user_id': userId,
    });
  }

  WorkTimesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String>? targetDay,
      Value<DateTime?>? start,
      Value<DateTime?>? end,
      Value<DateTime?>? restStart,
      Value<DateTime?>? restEnd,
      Value<String?>? memo,
      Value<int>? userId}) {
    return WorkTimesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      targetDay: targetDay ?? this.targetDay,
      start: start ?? this.start,
      end: end ?? this.end,
      restStart: restStart ?? this.restStart,
      restEnd: restEnd ?? this.restEnd,
      memo: memo ?? this.memo,
      userId: userId ?? this.userId,
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
    if (targetDay.present) {
      map['target_day'] = Variable<String>(targetDay.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (restStart.present) {
      map['rest_start'] = Variable<DateTime>(restStart.value);
    }
    if (restEnd.present) {
      map['rest_end'] = Variable<DateTime>(restEnd.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkTimesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('targetDay: $targetDay, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('restStart: $restStart, ')
          ..write('restEnd: $restEnd, ')
          ..write('memo: $memo, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

class $JapaneseHolidaysTable extends JapaneseHolidays
    with TableInfo<$JapaneseHolidaysTable, JapaneseHoliday> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JapaneseHolidaysTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _targetDayMeta =
      const VerificationMeta('targetDay');
  @override
  late final GeneratedColumn<String> targetDay = GeneratedColumn<String>(
      'target_day', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
      'memo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, updatedAt, targetDay, name, memo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'japanese_holidays';
  @override
  VerificationContext validateIntegrity(Insertable<JapaneseHoliday> instance,
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
    if (data.containsKey('target_day')) {
      context.handle(_targetDayMeta,
          targetDay.isAcceptableOrUnknown(data['target_day']!, _targetDayMeta));
    } else if (isInserting) {
      context.missing(_targetDayMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
          _memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JapaneseHoliday map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JapaneseHoliday(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      targetDay: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_day'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      memo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memo']),
    );
  }

  @override
  $JapaneseHolidaysTable createAlias(String alias) {
    return $JapaneseHolidaysTable(attachedDatabase, alias);
  }
}

class JapaneseHoliday extends DataClass implements Insertable<JapaneseHoliday> {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String targetDay;
  final String name;
  final String? memo;
  const JapaneseHoliday(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.targetDay,
      required this.name,
      this.memo});
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
    map['target_day'] = Variable<String>(targetDay);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    return map;
  }

  JapaneseHolidaysCompanion toCompanion(bool nullToAbsent) {
    return JapaneseHolidaysCompanion(
      id: Value(id),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      targetDay: Value(targetDay),
      name: Value(name),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
    );
  }

  factory JapaneseHoliday.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JapaneseHoliday(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      targetDay: serializer.fromJson<String>(json['targetDay']),
      name: serializer.fromJson<String>(json['name']),
      memo: serializer.fromJson<String?>(json['memo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'targetDay': serializer.toJson<String>(targetDay),
      'name': serializer.toJson<String>(name),
      'memo': serializer.toJson<String?>(memo),
    };
  }

  JapaneseHoliday copyWith(
          {int? id,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          String? targetDay,
          String? name,
          Value<String?> memo = const Value.absent()}) =>
      JapaneseHoliday(
        id: id ?? this.id,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        targetDay: targetDay ?? this.targetDay,
        name: name ?? this.name,
        memo: memo.present ? memo.value : this.memo,
      );
  JapaneseHoliday copyWithCompanion(JapaneseHolidaysCompanion data) {
    return JapaneseHoliday(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      targetDay: data.targetDay.present ? data.targetDay.value : this.targetDay,
      name: data.name.present ? data.name.value : this.name,
      memo: data.memo.present ? data.memo.value : this.memo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JapaneseHoliday(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('targetDay: $targetDay, ')
          ..write('name: $name, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, targetDay, name, memo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JapaneseHoliday &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.targetDay == this.targetDay &&
          other.name == this.name &&
          other.memo == this.memo);
}

class JapaneseHolidaysCompanion extends UpdateCompanion<JapaneseHoliday> {
  final Value<int> id;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> targetDay;
  final Value<String> name;
  final Value<String?> memo;
  const JapaneseHolidaysCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.targetDay = const Value.absent(),
    this.name = const Value.absent(),
    this.memo = const Value.absent(),
  });
  JapaneseHolidaysCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String targetDay,
    required String name,
    this.memo = const Value.absent(),
  })  : targetDay = Value(targetDay),
        name = Value(name);
  static Insertable<JapaneseHoliday> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? targetDay,
    Expression<String>? name,
    Expression<String>? memo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (targetDay != null) 'target_day': targetDay,
      if (name != null) 'name': name,
      if (memo != null) 'memo': memo,
    });
  }

  JapaneseHolidaysCompanion copyWith(
      {Value<int>? id,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String>? targetDay,
      Value<String>? name,
      Value<String?>? memo}) {
    return JapaneseHolidaysCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      targetDay: targetDay ?? this.targetDay,
      name: name ?? this.name,
      memo: memo ?? this.memo,
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
    if (targetDay.present) {
      map['target_day'] = Variable<String>(targetDay.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JapaneseHolidaysCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('targetDay: $targetDay, ')
          ..write('name: $name, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $WorkSettingsTable workSettings = $WorkSettingsTable(this);
  late final $WorkTimesTable workTimes = $WorkTimesTable(this);
  late final $JapaneseHolidaysTable japaneseHolidays =
      $JapaneseHolidaysTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, workSettings, workTimes, japaneseHolidays];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  required String name,
  required String email,
  Value<DateTime?> lastLoginTime,
  Value<int?> defaultWorkSettingId,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String> name,
  Value<String> email,
  Value<DateTime?> lastLoginTime,
  Value<int?> defaultWorkSettingId,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkSettingsTable, List<WorkSetting>>
      _workSettingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.workSettings,
          aliasName: $_aliasNameGenerator(db.users.id, db.workSettings.userId));

  $$WorkSettingsTableProcessedTableManager get workSettingsRefs {
    final manager = $$WorkSettingsTableTableManager($_db, $_db.workSettings)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workSettingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorkTimesTable, List<WorkTime>>
      _workTimesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.workTimes,
          aliasName: $_aliasNameGenerator(db.users.id, db.workTimes.userId));

  $$WorkTimesTableProcessedTableManager get workTimesRefs {
    final manager = $$WorkTimesTableTableManager($_db, $_db.workTimes)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workTimesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastLoginTime => $composableBuilder(
      column: $table.lastLoginTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultWorkSettingId => $composableBuilder(
      column: $table.defaultWorkSettingId,
      builder: (column) => ColumnFilters(column));

  Expression<bool> workSettingsRefs(
      Expression<bool> Function($$WorkSettingsTableFilterComposer f) f) {
    final $$WorkSettingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workSettings,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkSettingsTableFilterComposer(
              $db: $db,
              $table: $db.workSettings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> workTimesRefs(
      Expression<bool> Function($$WorkTimesTableFilterComposer f) f) {
    final $$WorkTimesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workTimes,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkTimesTableFilterComposer(
              $db: $db,
              $table: $db.workTimes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastLoginTime => $composableBuilder(
      column: $table.lastLoginTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultWorkSettingId => $composableBuilder(
      column: $table.defaultWorkSettingId,
      builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
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

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginTime => $composableBuilder(
      column: $table.lastLoginTime, builder: (column) => column);

  GeneratedColumn<int> get defaultWorkSettingId => $composableBuilder(
      column: $table.defaultWorkSettingId, builder: (column) => column);

  Expression<T> workSettingsRefs<T extends Object>(
      Expression<T> Function($$WorkSettingsTableAnnotationComposer a) f) {
    final $$WorkSettingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workSettings,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkSettingsTableAnnotationComposer(
              $db: $db,
              $table: $db.workSettings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> workTimesRefs<T extends Object>(
      Expression<T> Function($$WorkTimesTableAnnotationComposer a) f) {
    final $$WorkTimesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workTimes,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkTimesTableAnnotationComposer(
              $db: $db,
              $table: $db.workTimes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool workSettingsRefs, bool workTimesRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<DateTime?> lastLoginTime = const Value.absent(),
            Value<int?> defaultWorkSettingId = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            name: name,
            email: email,
            lastLoginTime: lastLoginTime,
            defaultWorkSettingId: defaultWorkSettingId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            required String name,
            required String email,
            Value<DateTime?> lastLoginTime = const Value.absent(),
            Value<int?> defaultWorkSettingId = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            name: name,
            email: email,
            lastLoginTime: lastLoginTime,
            defaultWorkSettingId: defaultWorkSettingId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {workSettingsRefs = false, workTimesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workSettingsRefs) db.workSettings,
                if (workTimesRefs) db.workTimes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workSettingsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._workSettingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .workSettingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (workTimesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._workTimesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).workTimesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool workSettingsRefs, bool workTimesRefs})>;
typedef $$WorkSettingsTableCreateCompanionBuilder = WorkSettingsCompanion
    Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  required String title,
  required DateTime start,
  required DateTime end,
  required DateTime restStart,
  required DateTime restEnd,
  Value<String?> memo,
  required int workingUnit,
  required int userId,
});
typedef $$WorkSettingsTableUpdateCompanionBuilder = WorkSettingsCompanion
    Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String> title,
  Value<DateTime> start,
  Value<DateTime> end,
  Value<DateTime> restStart,
  Value<DateTime> restEnd,
  Value<String?> memo,
  Value<int> workingUnit,
  Value<int> userId,
});

final class $$WorkSettingsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkSettingsTable, WorkSetting> {
  $$WorkSettingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.workSettings.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorkSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkSettingsTable> {
  $$WorkSettingsTableFilterComposer({
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

  ColumnFilters<DateTime> get start => $composableBuilder(
      column: $table.start, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get end => $composableBuilder(
      column: $table.end, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get restStart => $composableBuilder(
      column: $table.restStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get restEnd => $composableBuilder(
      column: $table.restEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get workingUnit => $composableBuilder(
      column: $table.workingUnit, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkSettingsTable> {
  $$WorkSettingsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get start => $composableBuilder(
      column: $table.start, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get end => $composableBuilder(
      column: $table.end, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get restStart => $composableBuilder(
      column: $table.restStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get restEnd => $composableBuilder(
      column: $table.restEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get workingUnit => $composableBuilder(
      column: $table.workingUnit, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkSettingsTable> {
  $$WorkSettingsTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<DateTime> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumn<DateTime> get restStart =>
      $composableBuilder(column: $table.restStart, builder: (column) => column);

  GeneratedColumn<DateTime> get restEnd =>
      $composableBuilder(column: $table.restEnd, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<int> get workingUnit => $composableBuilder(
      column: $table.workingUnit, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkSettingsTable,
    WorkSetting,
    $$WorkSettingsTableFilterComposer,
    $$WorkSettingsTableOrderingComposer,
    $$WorkSettingsTableAnnotationComposer,
    $$WorkSettingsTableCreateCompanionBuilder,
    $$WorkSettingsTableUpdateCompanionBuilder,
    (WorkSetting, $$WorkSettingsTableReferences),
    WorkSetting,
    PrefetchHooks Function({bool userId})> {
  $$WorkSettingsTableTableManager(_$AppDatabase db, $WorkSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> start = const Value.absent(),
            Value<DateTime> end = const Value.absent(),
            Value<DateTime> restStart = const Value.absent(),
            Value<DateTime> restEnd = const Value.absent(),
            Value<String?> memo = const Value.absent(),
            Value<int> workingUnit = const Value.absent(),
            Value<int> userId = const Value.absent(),
          }) =>
              WorkSettingsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            title: title,
            start: start,
            end: end,
            restStart: restStart,
            restEnd: restEnd,
            memo: memo,
            workingUnit: workingUnit,
            userId: userId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            required String title,
            required DateTime start,
            required DateTime end,
            required DateTime restStart,
            required DateTime restEnd,
            Value<String?> memo = const Value.absent(),
            required int workingUnit,
            required int userId,
          }) =>
              WorkSettingsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            title: title,
            start: start,
            end: end,
            restStart: restStart,
            restEnd: restEnd,
            memo: memo,
            workingUnit: workingUnit,
            userId: userId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkSettingsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$WorkSettingsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$WorkSettingsTableReferences._userIdTable(db).id,
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

typedef $$WorkSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkSettingsTable,
    WorkSetting,
    $$WorkSettingsTableFilterComposer,
    $$WorkSettingsTableOrderingComposer,
    $$WorkSettingsTableAnnotationComposer,
    $$WorkSettingsTableCreateCompanionBuilder,
    $$WorkSettingsTableUpdateCompanionBuilder,
    (WorkSetting, $$WorkSettingsTableReferences),
    WorkSetting,
    PrefetchHooks Function({bool userId})>;
typedef $$WorkTimesTableCreateCompanionBuilder = WorkTimesCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  required String targetDay,
  Value<DateTime?> start,
  Value<DateTime?> end,
  Value<DateTime?> restStart,
  Value<DateTime?> restEnd,
  Value<String?> memo,
  required int userId,
});
typedef $$WorkTimesTableUpdateCompanionBuilder = WorkTimesCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String> targetDay,
  Value<DateTime?> start,
  Value<DateTime?> end,
  Value<DateTime?> restStart,
  Value<DateTime?> restEnd,
  Value<String?> memo,
  Value<int> userId,
});

final class $$WorkTimesTableReferences
    extends BaseReferences<_$AppDatabase, $WorkTimesTable, WorkTime> {
  $$WorkTimesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.workTimes.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorkTimesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkTimesTable> {
  $$WorkTimesTableFilterComposer({
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

  ColumnFilters<String> get targetDay => $composableBuilder(
      column: $table.targetDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get start => $composableBuilder(
      column: $table.start, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get end => $composableBuilder(
      column: $table.end, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get restStart => $composableBuilder(
      column: $table.restStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get restEnd => $composableBuilder(
      column: $table.restEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkTimesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkTimesTable> {
  $$WorkTimesTableOrderingComposer({
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

  ColumnOrderings<String> get targetDay => $composableBuilder(
      column: $table.targetDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get start => $composableBuilder(
      column: $table.start, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get end => $composableBuilder(
      column: $table.end, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get restStart => $composableBuilder(
      column: $table.restStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get restEnd => $composableBuilder(
      column: $table.restEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkTimesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkTimesTable> {
  $$WorkTimesTableAnnotationComposer({
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

  GeneratedColumn<String> get targetDay =>
      $composableBuilder(column: $table.targetDay, builder: (column) => column);

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<DateTime> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumn<DateTime> get restStart =>
      $composableBuilder(column: $table.restStart, builder: (column) => column);

  GeneratedColumn<DateTime> get restEnd =>
      $composableBuilder(column: $table.restEnd, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkTimesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkTimesTable,
    WorkTime,
    $$WorkTimesTableFilterComposer,
    $$WorkTimesTableOrderingComposer,
    $$WorkTimesTableAnnotationComposer,
    $$WorkTimesTableCreateCompanionBuilder,
    $$WorkTimesTableUpdateCompanionBuilder,
    (WorkTime, $$WorkTimesTableReferences),
    WorkTime,
    PrefetchHooks Function({bool userId})> {
  $$WorkTimesTableTableManager(_$AppDatabase db, $WorkTimesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkTimesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkTimesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkTimesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String> targetDay = const Value.absent(),
            Value<DateTime?> start = const Value.absent(),
            Value<DateTime?> end = const Value.absent(),
            Value<DateTime?> restStart = const Value.absent(),
            Value<DateTime?> restEnd = const Value.absent(),
            Value<String?> memo = const Value.absent(),
            Value<int> userId = const Value.absent(),
          }) =>
              WorkTimesCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            targetDay: targetDay,
            start: start,
            end: end,
            restStart: restStart,
            restEnd: restEnd,
            memo: memo,
            userId: userId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            required String targetDay,
            Value<DateTime?> start = const Value.absent(),
            Value<DateTime?> end = const Value.absent(),
            Value<DateTime?> restStart = const Value.absent(),
            Value<DateTime?> restEnd = const Value.absent(),
            Value<String?> memo = const Value.absent(),
            required int userId,
          }) =>
              WorkTimesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            targetDay: targetDay,
            start: start,
            end: end,
            restStart: restStart,
            restEnd: restEnd,
            memo: memo,
            userId: userId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkTimesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$WorkTimesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$WorkTimesTableReferences._userIdTable(db).id,
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

typedef $$WorkTimesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkTimesTable,
    WorkTime,
    $$WorkTimesTableFilterComposer,
    $$WorkTimesTableOrderingComposer,
    $$WorkTimesTableAnnotationComposer,
    $$WorkTimesTableCreateCompanionBuilder,
    $$WorkTimesTableUpdateCompanionBuilder,
    (WorkTime, $$WorkTimesTableReferences),
    WorkTime,
    PrefetchHooks Function({bool userId})>;
typedef $$JapaneseHolidaysTableCreateCompanionBuilder
    = JapaneseHolidaysCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  required String targetDay,
  required String name,
  Value<String?> memo,
});
typedef $$JapaneseHolidaysTableUpdateCompanionBuilder
    = JapaneseHolidaysCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String> targetDay,
  Value<String> name,
  Value<String?> memo,
});

class $$JapaneseHolidaysTableFilterComposer
    extends Composer<_$AppDatabase, $JapaneseHolidaysTable> {
  $$JapaneseHolidaysTableFilterComposer({
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

  ColumnFilters<String> get targetDay => $composableBuilder(
      column: $table.targetDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnFilters(column));
}

class $$JapaneseHolidaysTableOrderingComposer
    extends Composer<_$AppDatabase, $JapaneseHolidaysTable> {
  $$JapaneseHolidaysTableOrderingComposer({
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

  ColumnOrderings<String> get targetDay => $composableBuilder(
      column: $table.targetDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnOrderings(column));
}

class $$JapaneseHolidaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $JapaneseHolidaysTable> {
  $$JapaneseHolidaysTableAnnotationComposer({
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

  GeneratedColumn<String> get targetDay =>
      $composableBuilder(column: $table.targetDay, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);
}

class $$JapaneseHolidaysTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JapaneseHolidaysTable,
    JapaneseHoliday,
    $$JapaneseHolidaysTableFilterComposer,
    $$JapaneseHolidaysTableOrderingComposer,
    $$JapaneseHolidaysTableAnnotationComposer,
    $$JapaneseHolidaysTableCreateCompanionBuilder,
    $$JapaneseHolidaysTableUpdateCompanionBuilder,
    (
      JapaneseHoliday,
      BaseReferences<_$AppDatabase, $JapaneseHolidaysTable, JapaneseHoliday>
    ),
    JapaneseHoliday,
    PrefetchHooks Function()> {
  $$JapaneseHolidaysTableTableManager(
      _$AppDatabase db, $JapaneseHolidaysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JapaneseHolidaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JapaneseHolidaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JapaneseHolidaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String> targetDay = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> memo = const Value.absent(),
          }) =>
              JapaneseHolidaysCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            targetDay: targetDay,
            name: name,
            memo: memo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            required String targetDay,
            required String name,
            Value<String?> memo = const Value.absent(),
          }) =>
              JapaneseHolidaysCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            targetDay: targetDay,
            name: name,
            memo: memo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JapaneseHolidaysTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JapaneseHolidaysTable,
    JapaneseHoliday,
    $$JapaneseHolidaysTableFilterComposer,
    $$JapaneseHolidaysTableOrderingComposer,
    $$JapaneseHolidaysTableAnnotationComposer,
    $$JapaneseHolidaysTableCreateCompanionBuilder,
    $$JapaneseHolidaysTableUpdateCompanionBuilder,
    (
      JapaneseHoliday,
      BaseReferences<_$AppDatabase, $JapaneseHolidaysTable, JapaneseHoliday>
    ),
    JapaneseHoliday,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$WorkSettingsTableTableManager get workSettings =>
      $$WorkSettingsTableTableManager(_db, _db.workSettings);
  $$WorkTimesTableTableManager get workTimes =>
      $$WorkTimesTableTableManager(_db, _db.workTimes);
  $$JapaneseHolidaysTableTableManager get japaneseHolidays =>
      $$JapaneseHolidaysTableTableManager(_db, _db.japaneseHolidays);
}
