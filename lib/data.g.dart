// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// ignore_for_file: type=lint
class $ExerciseTable extends Exercise
    with TableInfo<$ExerciseTable, ExerciseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _minutesMeta =
      const VerificationMeta('minutes');
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
      'minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _secondsMeta =
      const VerificationMeta('seconds');
  @override
  late final GeneratedColumn<int> seconds = GeneratedColumn<int>(
      'seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, minutes, seconds];
  @override
  String get aliasedName => _alias ?? 'exercise';
  @override
  String get actualTableName => 'exercise';
  @override
  VerificationContext validateIntegrity(Insertable<ExerciseData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(_descriptionMeta,
          description.isAcceptableOrUnknown(data['body']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(_minutesMeta,
          minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta));
    }
    if (data.containsKey('seconds')) {
      context.handle(_secondsMeta,
          seconds.isAcceptableOrUnknown(data['seconds']!, _secondsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      minutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minutes'])!,
      seconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}seconds'])!,
    );
  }

  @override
  $ExerciseTable createAlias(String alias) {
    return $ExerciseTable(attachedDatabase, alias);
  }
}

class ExerciseData extends DataClass implements Insertable<ExerciseData> {
  final int id;
  final String title;
  final String description;
  final int minutes;
  final int seconds;
  const ExerciseData(
      {required this.id,
      required this.title,
      required this.description,
      required this.minutes,
      required this.seconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(description);
    map['minutes'] = Variable<int>(minutes);
    map['seconds'] = Variable<int>(seconds);
    return map;
  }

  ExerciseCompanion toCompanion(bool nullToAbsent) {
    return ExerciseCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      minutes: Value(minutes),
      seconds: Value(seconds),
    );
  }

  factory ExerciseData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      minutes: serializer.fromJson<int>(json['minutes']),
      seconds: serializer.fromJson<int>(json['seconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'minutes': serializer.toJson<int>(minutes),
      'seconds': serializer.toJson<int>(seconds),
    };
  }

  ExerciseData copyWith(
          {int? id,
          String? title,
          String? description,
          int? minutes,
          int? seconds}) =>
      ExerciseData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        minutes: minutes ?? this.minutes,
        seconds: seconds ?? this.seconds,
      );
  @override
  String toString() {
    return (StringBuffer('ExerciseData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('minutes: $minutes, ')
          ..write('seconds: $seconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, minutes, seconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.minutes == this.minutes &&
          other.seconds == this.seconds);
}

class ExerciseCompanion extends UpdateCompanion<ExerciseData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<int> minutes;
  final Value<int> seconds;
  const ExerciseCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.minutes = const Value.absent(),
    this.seconds = const Value.absent(),
  });
  ExerciseCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    this.minutes = const Value.absent(),
    this.seconds = const Value.absent(),
  })  : title = Value(title),
        description = Value(description);
  static Insertable<ExerciseData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? minutes,
    Expression<int>? seconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'body': description,
      if (minutes != null) 'minutes': minutes,
      if (seconds != null) 'seconds': seconds,
    });
  }

  ExerciseCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? description,
      Value<int>? minutes,
      Value<int>? seconds}) {
    return ExerciseCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['body'] = Variable<String>(description.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (seconds.present) {
      map['seconds'] = Variable<int>(seconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('minutes: $minutes, ')
          ..write('seconds: $seconds')
          ..write(')'))
        .toString();
  }
}

class $PlanExTable extends PlanEx with TableInfo<$PlanExTable, PlanExData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanExTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _planIDMeta = const VerificationMeta('planID');
  @override
  late final GeneratedColumn<int> planID = GeneratedColumn<int>(
      'plan_i_d', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _minutesMeta =
      const VerificationMeta('minutes');
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
      'minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _secondsMeta =
      const VerificationMeta('seconds');
  @override
  late final GeneratedColumn<int> seconds = GeneratedColumn<int>(
      'seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, planID, title, description, minutes, seconds];
  @override
  String get aliasedName => _alias ?? 'plan_ex';
  @override
  String get actualTableName => 'plan_ex';
  @override
  VerificationContext validateIntegrity(Insertable<PlanExData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_i_d')) {
      context.handle(_planIDMeta,
          planID.isAcceptableOrUnknown(data['plan_i_d']!, _planIDMeta));
    } else if (isInserting) {
      context.missing(_planIDMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(_descriptionMeta,
          description.isAcceptableOrUnknown(data['body']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(_minutesMeta,
          minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta));
    }
    if (data.containsKey('seconds')) {
      context.handle(_secondsMeta,
          seconds.isAcceptableOrUnknown(data['seconds']!, _secondsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanExData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanExData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      planID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_i_d'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      minutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minutes'])!,
      seconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}seconds'])!,
    );
  }

  @override
  $PlanExTable createAlias(String alias) {
    return $PlanExTable(attachedDatabase, alias);
  }
}

class PlanExData extends DataClass implements Insertable<PlanExData> {
  final int id;
  final int planID;
  final String title;
  final String description;
  final int minutes;
  final int seconds;
  const PlanExData(
      {required this.id,
      required this.planID,
      required this.title,
      required this.description,
      required this.minutes,
      required this.seconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_i_d'] = Variable<int>(planID);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(description);
    map['minutes'] = Variable<int>(minutes);
    map['seconds'] = Variable<int>(seconds);
    return map;
  }

  PlanExCompanion toCompanion(bool nullToAbsent) {
    return PlanExCompanion(
      id: Value(id),
      planID: Value(planID),
      title: Value(title),
      description: Value(description),
      minutes: Value(minutes),
      seconds: Value(seconds),
    );
  }

  factory PlanExData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanExData(
      id: serializer.fromJson<int>(json['id']),
      planID: serializer.fromJson<int>(json['planID']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      minutes: serializer.fromJson<int>(json['minutes']),
      seconds: serializer.fromJson<int>(json['seconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planID': serializer.toJson<int>(planID),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'minutes': serializer.toJson<int>(minutes),
      'seconds': serializer.toJson<int>(seconds),
    };
  }

  PlanExData copyWith(
          {int? id,
          int? planID,
          String? title,
          String? description,
          int? minutes,
          int? seconds}) =>
      PlanExData(
        id: id ?? this.id,
        planID: planID ?? this.planID,
        title: title ?? this.title,
        description: description ?? this.description,
        minutes: minutes ?? this.minutes,
        seconds: seconds ?? this.seconds,
      );
  @override
  String toString() {
    return (StringBuffer('PlanExData(')
          ..write('id: $id, ')
          ..write('planID: $planID, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('minutes: $minutes, ')
          ..write('seconds: $seconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, planID, title, description, minutes, seconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanExData &&
          other.id == this.id &&
          other.planID == this.planID &&
          other.title == this.title &&
          other.description == this.description &&
          other.minutes == this.minutes &&
          other.seconds == this.seconds);
}

class PlanExCompanion extends UpdateCompanion<PlanExData> {
  final Value<int> id;
  final Value<int> planID;
  final Value<String> title;
  final Value<String> description;
  final Value<int> minutes;
  final Value<int> seconds;
  const PlanExCompanion({
    this.id = const Value.absent(),
    this.planID = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.minutes = const Value.absent(),
    this.seconds = const Value.absent(),
  });
  PlanExCompanion.insert({
    this.id = const Value.absent(),
    required int planID,
    required String title,
    required String description,
    this.minutes = const Value.absent(),
    this.seconds = const Value.absent(),
  })  : planID = Value(planID),
        title = Value(title),
        description = Value(description);
  static Insertable<PlanExData> custom({
    Expression<int>? id,
    Expression<int>? planID,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? minutes,
    Expression<int>? seconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planID != null) 'plan_i_d': planID,
      if (title != null) 'title': title,
      if (description != null) 'body': description,
      if (minutes != null) 'minutes': minutes,
      if (seconds != null) 'seconds': seconds,
    });
  }

  PlanExCompanion copyWith(
      {Value<int>? id,
      Value<int>? planID,
      Value<String>? title,
      Value<String>? description,
      Value<int>? minutes,
      Value<int>? seconds}) {
    return PlanExCompanion(
      id: id ?? this.id,
      planID: planID ?? this.planID,
      title: title ?? this.title,
      description: description ?? this.description,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planID.present) {
      map['plan_i_d'] = Variable<int>(planID.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['body'] = Variable<String>(description.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (seconds.present) {
      map['seconds'] = Variable<int>(seconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanExCompanion(')
          ..write('id: $id, ')
          ..write('planID: $planID, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('minutes: $minutes, ')
          ..write('seconds: $seconds')
          ..write(')'))
        .toString();
  }
}

class $PlanNameTable extends PlanName
    with TableInfo<$PlanNameTable, PlanNameData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanNameTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _planIDMeta = const VerificationMeta('planID');
  @override
  late final GeneratedColumn<int> planID = GeneratedColumn<int>(
      'plan_i_d', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titlePlanMeta =
      const VerificationMeta('titlePlan');
  @override
  late final GeneratedColumn<String> titlePlan = GeneratedColumn<String>(
      'title_plan', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [planID, titlePlan];
  @override
  String get aliasedName => _alias ?? 'plan_name';
  @override
  String get actualTableName => 'plan_name';
  @override
  VerificationContext validateIntegrity(Insertable<PlanNameData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('plan_i_d')) {
      context.handle(_planIDMeta,
          planID.isAcceptableOrUnknown(data['plan_i_d']!, _planIDMeta));
    }
    if (data.containsKey('title_plan')) {
      context.handle(_titlePlanMeta,
          titlePlan.isAcceptableOrUnknown(data['title_plan']!, _titlePlanMeta));
    } else if (isInserting) {
      context.missing(_titlePlanMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {planID};
  @override
  PlanNameData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanNameData(
      planID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_i_d'])!,
      titlePlan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_plan'])!,
    );
  }

  @override
  $PlanNameTable createAlias(String alias) {
    return $PlanNameTable(attachedDatabase, alias);
  }
}

class PlanNameData extends DataClass implements Insertable<PlanNameData> {
  final int planID;
  final String titlePlan;
  const PlanNameData({required this.planID, required this.titlePlan});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['plan_i_d'] = Variable<int>(planID);
    map['title_plan'] = Variable<String>(titlePlan);
    return map;
  }

  PlanNameCompanion toCompanion(bool nullToAbsent) {
    return PlanNameCompanion(
      planID: Value(planID),
      titlePlan: Value(titlePlan),
    );
  }

  factory PlanNameData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanNameData(
      planID: serializer.fromJson<int>(json['planID']),
      titlePlan: serializer.fromJson<String>(json['titlePlan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'planID': serializer.toJson<int>(planID),
      'titlePlan': serializer.toJson<String>(titlePlan),
    };
  }

  PlanNameData copyWith({int? planID, String? titlePlan}) => PlanNameData(
        planID: planID ?? this.planID,
        titlePlan: titlePlan ?? this.titlePlan,
      );
  @override
  String toString() {
    return (StringBuffer('PlanNameData(')
          ..write('planID: $planID, ')
          ..write('titlePlan: $titlePlan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(planID, titlePlan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanNameData &&
          other.planID == this.planID &&
          other.titlePlan == this.titlePlan);
}

class PlanNameCompanion extends UpdateCompanion<PlanNameData> {
  final Value<int> planID;
  final Value<String> titlePlan;
  const PlanNameCompanion({
    this.planID = const Value.absent(),
    this.titlePlan = const Value.absent(),
  });
  PlanNameCompanion.insert({
    this.planID = const Value.absent(),
    required String titlePlan,
  }) : titlePlan = Value(titlePlan);
  static Insertable<PlanNameData> custom({
    Expression<int>? planID,
    Expression<String>? titlePlan,
  }) {
    return RawValuesInsertable({
      if (planID != null) 'plan_i_d': planID,
      if (titlePlan != null) 'title_plan': titlePlan,
    });
  }

  PlanNameCompanion copyWith({Value<int>? planID, Value<String>? titlePlan}) {
    return PlanNameCompanion(
      planID: planID ?? this.planID,
      titlePlan: titlePlan ?? this.titlePlan,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (planID.present) {
      map['plan_i_d'] = Variable<int>(planID.value);
    }
    if (titlePlan.present) {
      map['title_plan'] = Variable<String>(titlePlan.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanNameCompanion(')
          ..write('planID: $planID, ')
          ..write('titlePlan: $titlePlan')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final $ExerciseTable exercise = $ExerciseTable(this);
  late final $PlanExTable planEx = $PlanExTable(this);
  late final $PlanNameTable planName = $PlanNameTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [exercise, planEx, planName];
}
