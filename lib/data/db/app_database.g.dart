// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients with TableInfo<$PatientsTable, Patient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthYearMeta = const VerificationMeta(
    'birthYear',
  );
  @override
  late final GeneratedColumn<int> birthYear = GeneratedColumn<int>(
    'birth_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _softFoodMeta = const VerificationMeta(
    'softFood',
  );
  @override
  late final GeneratedColumn<bool> softFood = GeneratedColumn<bool>(
    'soft_food',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("soft_food" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    birthYear,
    notes,
    allergies,
    softFood,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Patient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('birth_year')) {
      context.handle(
        _birthYearMeta,
        birthYear.isAcceptableOrUnknown(data['birth_year']!, _birthYearMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    }
    if (data.containsKey('soft_food')) {
      context.handle(
        _softFoodMeta,
        softFood.isAcceptableOrUnknown(data['soft_food']!, _softFoodMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Patient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Patient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      birthYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birth_year'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      ),
      softFood: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}soft_food'],
      )!,
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class Patient extends DataClass implements Insertable<Patient> {
  final int id;
  final String name;
  final int? birthYear;
  final String? notes;

  /// Free text allergies / food restrictions entered by the family.
  final String? allergies;

  /// "Soft food" profile flag (chewing difficulty).
  final bool softFood;
  const Patient({
    required this.id,
    required this.name,
    this.birthYear,
    this.notes,
    this.allergies,
    required this.softFood,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || birthYear != null) {
      map['birth_year'] = Variable<int>(birthYear);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || allergies != null) {
      map['allergies'] = Variable<String>(allergies);
    }
    map['soft_food'] = Variable<bool>(softFood);
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      id: Value(id),
      name: Value(name),
      birthYear: birthYear == null && nullToAbsent
          ? const Value.absent()
          : Value(birthYear),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      allergies: allergies == null && nullToAbsent
          ? const Value.absent()
          : Value(allergies),
      softFood: Value(softFood),
    );
  }

  factory Patient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Patient(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      birthYear: serializer.fromJson<int?>(json['birthYear']),
      notes: serializer.fromJson<String?>(json['notes']),
      allergies: serializer.fromJson<String?>(json['allergies']),
      softFood: serializer.fromJson<bool>(json['softFood']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'birthYear': serializer.toJson<int?>(birthYear),
      'notes': serializer.toJson<String?>(notes),
      'allergies': serializer.toJson<String?>(allergies),
      'softFood': serializer.toJson<bool>(softFood),
    };
  }

  Patient copyWith({
    int? id,
    String? name,
    Value<int?> birthYear = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> allergies = const Value.absent(),
    bool? softFood,
  }) => Patient(
    id: id ?? this.id,
    name: name ?? this.name,
    birthYear: birthYear.present ? birthYear.value : this.birthYear,
    notes: notes.present ? notes.value : this.notes,
    allergies: allergies.present ? allergies.value : this.allergies,
    softFood: softFood ?? this.softFood,
  );
  Patient copyWithCompanion(PatientsCompanion data) {
    return Patient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      birthYear: data.birthYear.present ? data.birthYear.value : this.birthYear,
      notes: data.notes.present ? data.notes.value : this.notes,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      softFood: data.softFood.present ? data.softFood.value : this.softFood,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Patient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthYear: $birthYear, ')
          ..write('notes: $notes, ')
          ..write('allergies: $allergies, ')
          ..write('softFood: $softFood')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, birthYear, notes, allergies, softFood);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Patient &&
          other.id == this.id &&
          other.name == this.name &&
          other.birthYear == this.birthYear &&
          other.notes == this.notes &&
          other.allergies == this.allergies &&
          other.softFood == this.softFood);
}

class PatientsCompanion extends UpdateCompanion<Patient> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> birthYear;
  final Value<String?> notes;
  final Value<String?> allergies;
  final Value<bool> softFood;
  const PatientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.notes = const Value.absent(),
    this.allergies = const Value.absent(),
    this.softFood = const Value.absent(),
  });
  PatientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.birthYear = const Value.absent(),
    this.notes = const Value.absent(),
    this.allergies = const Value.absent(),
    this.softFood = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Patient> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? birthYear,
    Expression<String>? notes,
    Expression<String>? allergies,
    Expression<bool>? softFood,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (birthYear != null) 'birth_year': birthYear,
      if (notes != null) 'notes': notes,
      if (allergies != null) 'allergies': allergies,
      if (softFood != null) 'soft_food': softFood,
    });
  }

  PatientsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? birthYear,
    Value<String?>? notes,
    Value<String?>? allergies,
    Value<bool>? softFood,
  }) {
    return PatientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      birthYear: birthYear ?? this.birthYear,
      notes: notes ?? this.notes,
      allergies: allergies ?? this.allergies,
      softFood: softFood ?? this.softFood,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (birthYear.present) {
      map['birth_year'] = Variable<int>(birthYear.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (softFood.present) {
      map['soft_food'] = Variable<bool>(softFood.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthYear: $birthYear, ')
          ..write('notes: $notes, ')
          ..write('allergies: $allergies, ')
          ..write('softFood: $softFood')
          ..write(')'))
        .toString();
  }
}

class $ConditionsTable extends Conditions
    with TableInfo<$ConditionsTable, PatientCondition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id)',
    ),
  );
  static const VerificationMeta _conditionKeyMeta = const VerificationMeta(
    'conditionKey',
  );
  @override
  late final GeneratedColumn<String> conditionKey = GeneratedColumn<String>(
    'condition_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, patientId, conditionKey, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conditions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatientCondition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('condition_key')) {
      context.handle(
        _conditionKeyMeta,
        conditionKey.isAcceptableOrUnknown(
          data['condition_key']!,
          _conditionKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conditionKeyMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {patientId, conditionKey},
  ];
  @override
  PatientCondition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientCondition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}patient_id'],
      )!,
      conditionKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_key'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $ConditionsTable createAlias(String alias) {
    return $ConditionsTable(attachedDatabase, alias);
  }
}

class PatientCondition extends DataClass
    implements Insertable<PatientCondition> {
  final int id;
  final int patientId;
  final String conditionKey;
  final bool enabled;
  const PatientCondition({
    required this.id,
    required this.patientId,
    required this.conditionKey,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    map['condition_key'] = Variable<String>(conditionKey);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  ConditionsCompanion toCompanion(bool nullToAbsent) {
    return ConditionsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      conditionKey: Value(conditionKey),
      enabled: Value(enabled),
    );
  }

  factory PatientCondition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientCondition(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      conditionKey: serializer.fromJson<String>(json['conditionKey']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'conditionKey': serializer.toJson<String>(conditionKey),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  PatientCondition copyWith({
    int? id,
    int? patientId,
    String? conditionKey,
    bool? enabled,
  }) => PatientCondition(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    conditionKey: conditionKey ?? this.conditionKey,
    enabled: enabled ?? this.enabled,
  );
  PatientCondition copyWithCompanion(ConditionsCompanion data) {
    return PatientCondition(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      conditionKey: data.conditionKey.present
          ? data.conditionKey.value
          : this.conditionKey,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientCondition(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('conditionKey: $conditionKey, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, conditionKey, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientCondition &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.conditionKey == this.conditionKey &&
          other.enabled == this.enabled);
}

class ConditionsCompanion extends UpdateCompanion<PatientCondition> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<String> conditionKey;
  final Value<bool> enabled;
  const ConditionsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.conditionKey = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  ConditionsCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    required String conditionKey,
    this.enabled = const Value.absent(),
  }) : patientId = Value(patientId),
       conditionKey = Value(conditionKey);
  static Insertable<PatientCondition> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<String>? conditionKey,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (conditionKey != null) 'condition_key': conditionKey,
      if (enabled != null) 'enabled': enabled,
    });
  }

  ConditionsCompanion copyWith({
    Value<int>? id,
    Value<int>? patientId,
    Value<String>? conditionKey,
    Value<bool>? enabled,
  }) {
    return ConditionsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      conditionKey: conditionKey ?? this.conditionKey,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (conditionKey.present) {
      map['condition_key'] = Variable<String>(conditionKey.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConditionsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('conditionKey: $conditionKey, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

class $MetricsTable extends Metrics with TableInfo<$MetricsTable, Metric> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetricsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitOptionsMeta = const VerificationMeta(
    'unitOptions',
  );
  @override
  late final GeneratedColumn<String> unitOptions = GeneratedColumn<String>(
    'unit_options',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagOptionsMeta = const VerificationMeta(
    'tagOptions',
  );
  @override
  late final GeneratedColumn<String> tagOptions = GeneratedColumn<String>(
    'tag_options',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionKeyMeta = const VerificationMeta(
    'conditionKey',
  );
  @override
  late final GeneratedColumn<String> conditionKey = GeneratedColumn<String>(
    'condition_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readingKeyMeta = const VerificationMeta(
    'readingKey',
  );
  @override
  late final GeneratedColumn<String> readingKey = GeneratedColumn<String>(
    'reading_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    nameKey,
    unitOptions,
    tagOptions,
    conditionKey,
    readingKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metrics';
  @override
  VerificationContext validateIntegrity(
    Insertable<Metric> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    if (data.containsKey('unit_options')) {
      context.handle(
        _unitOptionsMeta,
        unitOptions.isAcceptableOrUnknown(
          data['unit_options']!,
          _unitOptionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitOptionsMeta);
    }
    if (data.containsKey('tag_options')) {
      context.handle(
        _tagOptionsMeta,
        tagOptions.isAcceptableOrUnknown(data['tag_options']!, _tagOptionsMeta),
      );
    } else if (isInserting) {
      context.missing(_tagOptionsMeta);
    }
    if (data.containsKey('condition_key')) {
      context.handle(
        _conditionKeyMeta,
        conditionKey.isAcceptableOrUnknown(
          data['condition_key']!,
          _conditionKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conditionKeyMeta);
    }
    if (data.containsKey('reading_key')) {
      context.handle(
        _readingKeyMeta,
        readingKey.isAcceptableOrUnknown(data['reading_key']!, _readingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_readingKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Metric map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Metric(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      )!,
      unitOptions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_options'],
      )!,
      tagOptions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_options'],
      )!,
      conditionKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_key'],
      )!,
      readingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_key'],
      )!,
    );
  }

  @override
  $MetricsTable createAlias(String alias) {
    return $MetricsTable(attachedDatabase, alias);
  }
}

class Metric extends DataClass implements Insertable<Metric> {
  final String key;
  final String nameKey;
  final String unitOptions;
  final String tagOptions;
  final String conditionKey;
  final String readingKey;
  const Metric({
    required this.key,
    required this.nameKey,
    required this.unitOptions,
    required this.tagOptions,
    required this.conditionKey,
    required this.readingKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['name_key'] = Variable<String>(nameKey);
    map['unit_options'] = Variable<String>(unitOptions);
    map['tag_options'] = Variable<String>(tagOptions);
    map['condition_key'] = Variable<String>(conditionKey);
    map['reading_key'] = Variable<String>(readingKey);
    return map;
  }

  MetricsCompanion toCompanion(bool nullToAbsent) {
    return MetricsCompanion(
      key: Value(key),
      nameKey: Value(nameKey),
      unitOptions: Value(unitOptions),
      tagOptions: Value(tagOptions),
      conditionKey: Value(conditionKey),
      readingKey: Value(readingKey),
    );
  }

  factory Metric.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Metric(
      key: serializer.fromJson<String>(json['key']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
      unitOptions: serializer.fromJson<String>(json['unitOptions']),
      tagOptions: serializer.fromJson<String>(json['tagOptions']),
      conditionKey: serializer.fromJson<String>(json['conditionKey']),
      readingKey: serializer.fromJson<String>(json['readingKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'nameKey': serializer.toJson<String>(nameKey),
      'unitOptions': serializer.toJson<String>(unitOptions),
      'tagOptions': serializer.toJson<String>(tagOptions),
      'conditionKey': serializer.toJson<String>(conditionKey),
      'readingKey': serializer.toJson<String>(readingKey),
    };
  }

  Metric copyWith({
    String? key,
    String? nameKey,
    String? unitOptions,
    String? tagOptions,
    String? conditionKey,
    String? readingKey,
  }) => Metric(
    key: key ?? this.key,
    nameKey: nameKey ?? this.nameKey,
    unitOptions: unitOptions ?? this.unitOptions,
    tagOptions: tagOptions ?? this.tagOptions,
    conditionKey: conditionKey ?? this.conditionKey,
    readingKey: readingKey ?? this.readingKey,
  );
  Metric copyWithCompanion(MetricsCompanion data) {
    return Metric(
      key: data.key.present ? data.key.value : this.key,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      unitOptions: data.unitOptions.present
          ? data.unitOptions.value
          : this.unitOptions,
      tagOptions: data.tagOptions.present
          ? data.tagOptions.value
          : this.tagOptions,
      conditionKey: data.conditionKey.present
          ? data.conditionKey.value
          : this.conditionKey,
      readingKey: data.readingKey.present
          ? data.readingKey.value
          : this.readingKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Metric(')
          ..write('key: $key, ')
          ..write('nameKey: $nameKey, ')
          ..write('unitOptions: $unitOptions, ')
          ..write('tagOptions: $tagOptions, ')
          ..write('conditionKey: $conditionKey, ')
          ..write('readingKey: $readingKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    key,
    nameKey,
    unitOptions,
    tagOptions,
    conditionKey,
    readingKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Metric &&
          other.key == this.key &&
          other.nameKey == this.nameKey &&
          other.unitOptions == this.unitOptions &&
          other.tagOptions == this.tagOptions &&
          other.conditionKey == this.conditionKey &&
          other.readingKey == this.readingKey);
}

class MetricsCompanion extends UpdateCompanion<Metric> {
  final Value<String> key;
  final Value<String> nameKey;
  final Value<String> unitOptions;
  final Value<String> tagOptions;
  final Value<String> conditionKey;
  final Value<String> readingKey;
  final Value<int> rowid;
  const MetricsCompanion({
    this.key = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.unitOptions = const Value.absent(),
    this.tagOptions = const Value.absent(),
    this.conditionKey = const Value.absent(),
    this.readingKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetricsCompanion.insert({
    required String key,
    required String nameKey,
    required String unitOptions,
    required String tagOptions,
    required String conditionKey,
    required String readingKey,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       nameKey = Value(nameKey),
       unitOptions = Value(unitOptions),
       tagOptions = Value(tagOptions),
       conditionKey = Value(conditionKey),
       readingKey = Value(readingKey);
  static Insertable<Metric> custom({
    Expression<String>? key,
    Expression<String>? nameKey,
    Expression<String>? unitOptions,
    Expression<String>? tagOptions,
    Expression<String>? conditionKey,
    Expression<String>? readingKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (nameKey != null) 'name_key': nameKey,
      if (unitOptions != null) 'unit_options': unitOptions,
      if (tagOptions != null) 'tag_options': tagOptions,
      if (conditionKey != null) 'condition_key': conditionKey,
      if (readingKey != null) 'reading_key': readingKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetricsCompanion copyWith({
    Value<String>? key,
    Value<String>? nameKey,
    Value<String>? unitOptions,
    Value<String>? tagOptions,
    Value<String>? conditionKey,
    Value<String>? readingKey,
    Value<int>? rowid,
  }) {
    return MetricsCompanion(
      key: key ?? this.key,
      nameKey: nameKey ?? this.nameKey,
      unitOptions: unitOptions ?? this.unitOptions,
      tagOptions: tagOptions ?? this.tagOptions,
      conditionKey: conditionKey ?? this.conditionKey,
      readingKey: readingKey ?? this.readingKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (unitOptions.present) {
      map['unit_options'] = Variable<String>(unitOptions.value);
    }
    if (tagOptions.present) {
      map['tag_options'] = Variable<String>(tagOptions.value);
    }
    if (conditionKey.present) {
      map['condition_key'] = Variable<String>(conditionKey.value);
    }
    if (readingKey.present) {
      map['reading_key'] = Variable<String>(readingKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetricsCompanion(')
          ..write('key: $key, ')
          ..write('nameKey: $nameKey, ')
          ..write('unitOptions: $unitOptions, ')
          ..write('tagOptions: $tagOptions, ')
          ..write('conditionKey: $conditionKey, ')
          ..write('readingKey: $readingKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TargetRangesTable extends TargetRanges
    with TableInfo<$TargetRangesTable, TargetRange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TargetRangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id)',
    ),
  );
  static const VerificationMeta _metricKeyMeta = const VerificationMeta(
    'metricKey',
  );
  @override
  late final GeneratedColumn<String> metricKey = GeneratedColumn<String>(
    'metric_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES metrics ("key")',
    ),
  );
  static const VerificationMeta _tagContextMeta = const VerificationMeta(
    'tagContext',
  );
  @override
  late final GeneratedColumn<String> tagContext = GeneratedColumn<String>(
    'tag_context',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urgentLowMeta = const VerificationMeta(
    'urgentLow',
  );
  @override
  late final GeneratedColumn<double> urgentLow = GeneratedColumn<double>(
    'urgent_low',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cautionLowMeta = const VerificationMeta(
    'cautionLow',
  );
  @override
  late final GeneratedColumn<double> cautionLow = GeneratedColumn<double>(
    'caution_low',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cautionHighMeta = const VerificationMeta(
    'cautionHigh',
  );
  @override
  late final GeneratedColumn<double> cautionHigh = GeneratedColumn<double>(
    'caution_high',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urgentHighMeta = const VerificationMeta(
    'urgentHigh',
  );
  @override
  late final GeneratedColumn<double> urgentHigh = GeneratedColumn<double>(
    'urgent_high',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doctorPlanTextMeta = const VerificationMeta(
    'doctorPlanText',
  );
  @override
  late final GeneratedColumn<String> doctorPlanText = GeneratedColumn<String>(
    'doctor_plan_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warningSignsTextMeta = const VerificationMeta(
    'warningSignsText',
  );
  @override
  late final GeneratedColumn<String> warningSignsText = GeneratedColumn<String>(
    'warning_signs_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    metricKey,
    tagContext,
    unit,
    urgentLow,
    cautionLow,
    cautionHigh,
    urgentHigh,
    doctorPlanText,
    warningSignsText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'target_ranges';
  @override
  VerificationContext validateIntegrity(
    Insertable<TargetRange> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('metric_key')) {
      context.handle(
        _metricKeyMeta,
        metricKey.isAcceptableOrUnknown(data['metric_key']!, _metricKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_metricKeyMeta);
    }
    if (data.containsKey('tag_context')) {
      context.handle(
        _tagContextMeta,
        tagContext.isAcceptableOrUnknown(data['tag_context']!, _tagContextMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('urgent_low')) {
      context.handle(
        _urgentLowMeta,
        urgentLow.isAcceptableOrUnknown(data['urgent_low']!, _urgentLowMeta),
      );
    }
    if (data.containsKey('caution_low')) {
      context.handle(
        _cautionLowMeta,
        cautionLow.isAcceptableOrUnknown(data['caution_low']!, _cautionLowMeta),
      );
    }
    if (data.containsKey('caution_high')) {
      context.handle(
        _cautionHighMeta,
        cautionHigh.isAcceptableOrUnknown(
          data['caution_high']!,
          _cautionHighMeta,
        ),
      );
    }
    if (data.containsKey('urgent_high')) {
      context.handle(
        _urgentHighMeta,
        urgentHigh.isAcceptableOrUnknown(data['urgent_high']!, _urgentHighMeta),
      );
    }
    if (data.containsKey('doctor_plan_text')) {
      context.handle(
        _doctorPlanTextMeta,
        doctorPlanText.isAcceptableOrUnknown(
          data['doctor_plan_text']!,
          _doctorPlanTextMeta,
        ),
      );
    }
    if (data.containsKey('warning_signs_text')) {
      context.handle(
        _warningSignsTextMeta,
        warningSignsText.isAcceptableOrUnknown(
          data['warning_signs_text']!,
          _warningSignsTextMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TargetRange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TargetRange(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}patient_id'],
      )!,
      metricKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric_key'],
      )!,
      tagContext: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_context'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      urgentLow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}urgent_low'],
      ),
      cautionLow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}caution_low'],
      ),
      cautionHigh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}caution_high'],
      ),
      urgentHigh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}urgent_high'],
      ),
      doctorPlanText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_plan_text'],
      ),
      warningSignsText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}warning_signs_text'],
      ),
    );
  }

  @override
  $TargetRangesTable createAlias(String alias) {
    return $TargetRangesTable(attachedDatabase, alias);
  }
}

class TargetRange extends DataClass implements Insertable<TargetRange> {
  final int id;
  final int patientId;
  final String metricKey;

  /// null = applies to every context; else a tag key (fasting, bedtime...).
  final String? tagContext;

  /// Unit the thresholds were entered in (needed for mg/dL <-> mmol/L).
  final String? unit;
  final double? urgentLow;
  final double? cautionLow;
  final double? cautionHigh;
  final double? urgentHigh;
  final String? doctorPlanText;
  final String? warningSignsText;
  const TargetRange({
    required this.id,
    required this.patientId,
    required this.metricKey,
    this.tagContext,
    this.unit,
    this.urgentLow,
    this.cautionLow,
    this.cautionHigh,
    this.urgentHigh,
    this.doctorPlanText,
    this.warningSignsText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    map['metric_key'] = Variable<String>(metricKey);
    if (!nullToAbsent || tagContext != null) {
      map['tag_context'] = Variable<String>(tagContext);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || urgentLow != null) {
      map['urgent_low'] = Variable<double>(urgentLow);
    }
    if (!nullToAbsent || cautionLow != null) {
      map['caution_low'] = Variable<double>(cautionLow);
    }
    if (!nullToAbsent || cautionHigh != null) {
      map['caution_high'] = Variable<double>(cautionHigh);
    }
    if (!nullToAbsent || urgentHigh != null) {
      map['urgent_high'] = Variable<double>(urgentHigh);
    }
    if (!nullToAbsent || doctorPlanText != null) {
      map['doctor_plan_text'] = Variable<String>(doctorPlanText);
    }
    if (!nullToAbsent || warningSignsText != null) {
      map['warning_signs_text'] = Variable<String>(warningSignsText);
    }
    return map;
  }

  TargetRangesCompanion toCompanion(bool nullToAbsent) {
    return TargetRangesCompanion(
      id: Value(id),
      patientId: Value(patientId),
      metricKey: Value(metricKey),
      tagContext: tagContext == null && nullToAbsent
          ? const Value.absent()
          : Value(tagContext),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      urgentLow: urgentLow == null && nullToAbsent
          ? const Value.absent()
          : Value(urgentLow),
      cautionLow: cautionLow == null && nullToAbsent
          ? const Value.absent()
          : Value(cautionLow),
      cautionHigh: cautionHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(cautionHigh),
      urgentHigh: urgentHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(urgentHigh),
      doctorPlanText: doctorPlanText == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorPlanText),
      warningSignsText: warningSignsText == null && nullToAbsent
          ? const Value.absent()
          : Value(warningSignsText),
    );
  }

  factory TargetRange.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TargetRange(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      metricKey: serializer.fromJson<String>(json['metricKey']),
      tagContext: serializer.fromJson<String?>(json['tagContext']),
      unit: serializer.fromJson<String?>(json['unit']),
      urgentLow: serializer.fromJson<double?>(json['urgentLow']),
      cautionLow: serializer.fromJson<double?>(json['cautionLow']),
      cautionHigh: serializer.fromJson<double?>(json['cautionHigh']),
      urgentHigh: serializer.fromJson<double?>(json['urgentHigh']),
      doctorPlanText: serializer.fromJson<String?>(json['doctorPlanText']),
      warningSignsText: serializer.fromJson<String?>(json['warningSignsText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'metricKey': serializer.toJson<String>(metricKey),
      'tagContext': serializer.toJson<String?>(tagContext),
      'unit': serializer.toJson<String?>(unit),
      'urgentLow': serializer.toJson<double?>(urgentLow),
      'cautionLow': serializer.toJson<double?>(cautionLow),
      'cautionHigh': serializer.toJson<double?>(cautionHigh),
      'urgentHigh': serializer.toJson<double?>(urgentHigh),
      'doctorPlanText': serializer.toJson<String?>(doctorPlanText),
      'warningSignsText': serializer.toJson<String?>(warningSignsText),
    };
  }

  TargetRange copyWith({
    int? id,
    int? patientId,
    String? metricKey,
    Value<String?> tagContext = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<double?> urgentLow = const Value.absent(),
    Value<double?> cautionLow = const Value.absent(),
    Value<double?> cautionHigh = const Value.absent(),
    Value<double?> urgentHigh = const Value.absent(),
    Value<String?> doctorPlanText = const Value.absent(),
    Value<String?> warningSignsText = const Value.absent(),
  }) => TargetRange(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    metricKey: metricKey ?? this.metricKey,
    tagContext: tagContext.present ? tagContext.value : this.tagContext,
    unit: unit.present ? unit.value : this.unit,
    urgentLow: urgentLow.present ? urgentLow.value : this.urgentLow,
    cautionLow: cautionLow.present ? cautionLow.value : this.cautionLow,
    cautionHigh: cautionHigh.present ? cautionHigh.value : this.cautionHigh,
    urgentHigh: urgentHigh.present ? urgentHigh.value : this.urgentHigh,
    doctorPlanText: doctorPlanText.present
        ? doctorPlanText.value
        : this.doctorPlanText,
    warningSignsText: warningSignsText.present
        ? warningSignsText.value
        : this.warningSignsText,
  );
  TargetRange copyWithCompanion(TargetRangesCompanion data) {
    return TargetRange(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      metricKey: data.metricKey.present ? data.metricKey.value : this.metricKey,
      tagContext: data.tagContext.present
          ? data.tagContext.value
          : this.tagContext,
      unit: data.unit.present ? data.unit.value : this.unit,
      urgentLow: data.urgentLow.present ? data.urgentLow.value : this.urgentLow,
      cautionLow: data.cautionLow.present
          ? data.cautionLow.value
          : this.cautionLow,
      cautionHigh: data.cautionHigh.present
          ? data.cautionHigh.value
          : this.cautionHigh,
      urgentHigh: data.urgentHigh.present
          ? data.urgentHigh.value
          : this.urgentHigh,
      doctorPlanText: data.doctorPlanText.present
          ? data.doctorPlanText.value
          : this.doctorPlanText,
      warningSignsText: data.warningSignsText.present
          ? data.warningSignsText.value
          : this.warningSignsText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TargetRange(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('metricKey: $metricKey, ')
          ..write('tagContext: $tagContext, ')
          ..write('unit: $unit, ')
          ..write('urgentLow: $urgentLow, ')
          ..write('cautionLow: $cautionLow, ')
          ..write('cautionHigh: $cautionHigh, ')
          ..write('urgentHigh: $urgentHigh, ')
          ..write('doctorPlanText: $doctorPlanText, ')
          ..write('warningSignsText: $warningSignsText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    metricKey,
    tagContext,
    unit,
    urgentLow,
    cautionLow,
    cautionHigh,
    urgentHigh,
    doctorPlanText,
    warningSignsText,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TargetRange &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.metricKey == this.metricKey &&
          other.tagContext == this.tagContext &&
          other.unit == this.unit &&
          other.urgentLow == this.urgentLow &&
          other.cautionLow == this.cautionLow &&
          other.cautionHigh == this.cautionHigh &&
          other.urgentHigh == this.urgentHigh &&
          other.doctorPlanText == this.doctorPlanText &&
          other.warningSignsText == this.warningSignsText);
}

class TargetRangesCompanion extends UpdateCompanion<TargetRange> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<String> metricKey;
  final Value<String?> tagContext;
  final Value<String?> unit;
  final Value<double?> urgentLow;
  final Value<double?> cautionLow;
  final Value<double?> cautionHigh;
  final Value<double?> urgentHigh;
  final Value<String?> doctorPlanText;
  final Value<String?> warningSignsText;
  const TargetRangesCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.metricKey = const Value.absent(),
    this.tagContext = const Value.absent(),
    this.unit = const Value.absent(),
    this.urgentLow = const Value.absent(),
    this.cautionLow = const Value.absent(),
    this.cautionHigh = const Value.absent(),
    this.urgentHigh = const Value.absent(),
    this.doctorPlanText = const Value.absent(),
    this.warningSignsText = const Value.absent(),
  });
  TargetRangesCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    required String metricKey,
    this.tagContext = const Value.absent(),
    this.unit = const Value.absent(),
    this.urgentLow = const Value.absent(),
    this.cautionLow = const Value.absent(),
    this.cautionHigh = const Value.absent(),
    this.urgentHigh = const Value.absent(),
    this.doctorPlanText = const Value.absent(),
    this.warningSignsText = const Value.absent(),
  }) : patientId = Value(patientId),
       metricKey = Value(metricKey);
  static Insertable<TargetRange> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<String>? metricKey,
    Expression<String>? tagContext,
    Expression<String>? unit,
    Expression<double>? urgentLow,
    Expression<double>? cautionLow,
    Expression<double>? cautionHigh,
    Expression<double>? urgentHigh,
    Expression<String>? doctorPlanText,
    Expression<String>? warningSignsText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (metricKey != null) 'metric_key': metricKey,
      if (tagContext != null) 'tag_context': tagContext,
      if (unit != null) 'unit': unit,
      if (urgentLow != null) 'urgent_low': urgentLow,
      if (cautionLow != null) 'caution_low': cautionLow,
      if (cautionHigh != null) 'caution_high': cautionHigh,
      if (urgentHigh != null) 'urgent_high': urgentHigh,
      if (doctorPlanText != null) 'doctor_plan_text': doctorPlanText,
      if (warningSignsText != null) 'warning_signs_text': warningSignsText,
    });
  }

  TargetRangesCompanion copyWith({
    Value<int>? id,
    Value<int>? patientId,
    Value<String>? metricKey,
    Value<String?>? tagContext,
    Value<String?>? unit,
    Value<double?>? urgentLow,
    Value<double?>? cautionLow,
    Value<double?>? cautionHigh,
    Value<double?>? urgentHigh,
    Value<String?>? doctorPlanText,
    Value<String?>? warningSignsText,
  }) {
    return TargetRangesCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      metricKey: metricKey ?? this.metricKey,
      tagContext: tagContext ?? this.tagContext,
      unit: unit ?? this.unit,
      urgentLow: urgentLow ?? this.urgentLow,
      cautionLow: cautionLow ?? this.cautionLow,
      cautionHigh: cautionHigh ?? this.cautionHigh,
      urgentHigh: urgentHigh ?? this.urgentHigh,
      doctorPlanText: doctorPlanText ?? this.doctorPlanText,
      warningSignsText: warningSignsText ?? this.warningSignsText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (metricKey.present) {
      map['metric_key'] = Variable<String>(metricKey.value);
    }
    if (tagContext.present) {
      map['tag_context'] = Variable<String>(tagContext.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (urgentLow.present) {
      map['urgent_low'] = Variable<double>(urgentLow.value);
    }
    if (cautionLow.present) {
      map['caution_low'] = Variable<double>(cautionLow.value);
    }
    if (cautionHigh.present) {
      map['caution_high'] = Variable<double>(cautionHigh.value);
    }
    if (urgentHigh.present) {
      map['urgent_high'] = Variable<double>(urgentHigh.value);
    }
    if (doctorPlanText.present) {
      map['doctor_plan_text'] = Variable<String>(doctorPlanText.value);
    }
    if (warningSignsText.present) {
      map['warning_signs_text'] = Variable<String>(warningSignsText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TargetRangesCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('metricKey: $metricKey, ')
          ..write('tagContext: $tagContext, ')
          ..write('unit: $unit, ')
          ..write('urgentLow: $urgentLow, ')
          ..write('cautionLow: $cautionLow, ')
          ..write('cautionHigh: $cautionHigh, ')
          ..write('urgentHigh: $urgentHigh, ')
          ..write('doctorPlanText: $doctorPlanText, ')
          ..write('warningSignsText: $warningSignsText')
          ..write(')'))
        .toString();
  }
}

class $ReadingsTable extends Readings with TableInfo<$ReadingsTable, Reading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id)',
    ),
  );
  static const VerificationMeta _metricKeyMeta = const VerificationMeta(
    'metricKey',
  );
  @override
  late final GeneratedColumn<String> metricKey = GeneratedColumn<String>(
    'metric_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _systolicMeta = const VerificationMeta(
    'systolic',
  );
  @override
  late final GeneratedColumn<int> systolic = GeneratedColumn<int>(
    'systolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diastolicMeta = const VerificationMeta(
    'diastolic',
  );
  @override
  late final GeneratedColumn<int> diastolic = GeneratedColumn<int>(
    'diastolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pulseMeta = const VerificationMeta('pulse');
  @override
  late final GeneratedColumn<int> pulse = GeneratedColumn<int>(
    'pulse',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measuredAtMeta = const VerificationMeta(
    'measuredAt',
  );
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
    'measured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    metricKey,
    value,
    systolic,
    diastolic,
    pulse,
    unit,
    tag,
    measuredAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('metric_key')) {
      context.handle(
        _metricKeyMeta,
        metricKey.isAcceptableOrUnknown(data['metric_key']!, _metricKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_metricKeyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('systolic')) {
      context.handle(
        _systolicMeta,
        systolic.isAcceptableOrUnknown(data['systolic']!, _systolicMeta),
      );
    }
    if (data.containsKey('diastolic')) {
      context.handle(
        _diastolicMeta,
        diastolic.isAcceptableOrUnknown(data['diastolic']!, _diastolicMeta),
      );
    }
    if (data.containsKey('pulse')) {
      context.handle(
        _pulseMeta,
        pulse.isAcceptableOrUnknown(data['pulse']!, _pulseMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    }
    if (data.containsKey('measured_at')) {
      context.handle(
        _measuredAtMeta,
        measuredAt.isAcceptableOrUnknown(data['measured_at']!, _measuredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reading(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}patient_id'],
      )!,
      metricKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric_key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      ),
      systolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}systolic'],
      ),
      diastolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diastolic'],
      ),
      pulse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pulse'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      ),
      measuredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}measured_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ReadingsTable createAlias(String alias) {
    return $ReadingsTable(attachedDatabase, alias);
  }
}

class Reading extends DataClass implements Insertable<Reading> {
  final int id;
  final int patientId;
  final String metricKey;
  final double? value;
  final int? systolic;
  final int? diastolic;
  final int? pulse;
  final String unit;
  final String? tag;
  final DateTime measuredAt;
  final String? note;
  const Reading({
    required this.id,
    required this.patientId,
    required this.metricKey,
    this.value,
    this.systolic,
    this.diastolic,
    this.pulse,
    required this.unit,
    this.tag,
    required this.measuredAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    map['metric_key'] = Variable<String>(metricKey);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    if (!nullToAbsent || systolic != null) {
      map['systolic'] = Variable<int>(systolic);
    }
    if (!nullToAbsent || diastolic != null) {
      map['diastolic'] = Variable<int>(diastolic);
    }
    if (!nullToAbsent || pulse != null) {
      map['pulse'] = Variable<int>(pulse);
    }
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || tag != null) {
      map['tag'] = Variable<String>(tag);
    }
    map['measured_at'] = Variable<DateTime>(measuredAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ReadingsCompanion toCompanion(bool nullToAbsent) {
    return ReadingsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      metricKey: Value(metricKey),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      systolic: systolic == null && nullToAbsent
          ? const Value.absent()
          : Value(systolic),
      diastolic: diastolic == null && nullToAbsent
          ? const Value.absent()
          : Value(diastolic),
      pulse: pulse == null && nullToAbsent
          ? const Value.absent()
          : Value(pulse),
      unit: Value(unit),
      tag: tag == null && nullToAbsent ? const Value.absent() : Value(tag),
      measuredAt: Value(measuredAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Reading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reading(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      metricKey: serializer.fromJson<String>(json['metricKey']),
      value: serializer.fromJson<double?>(json['value']),
      systolic: serializer.fromJson<int?>(json['systolic']),
      diastolic: serializer.fromJson<int?>(json['diastolic']),
      pulse: serializer.fromJson<int?>(json['pulse']),
      unit: serializer.fromJson<String>(json['unit']),
      tag: serializer.fromJson<String?>(json['tag']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'metricKey': serializer.toJson<String>(metricKey),
      'value': serializer.toJson<double?>(value),
      'systolic': serializer.toJson<int?>(systolic),
      'diastolic': serializer.toJson<int?>(diastolic),
      'pulse': serializer.toJson<int?>(pulse),
      'unit': serializer.toJson<String>(unit),
      'tag': serializer.toJson<String?>(tag),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  Reading copyWith({
    int? id,
    int? patientId,
    String? metricKey,
    Value<double?> value = const Value.absent(),
    Value<int?> systolic = const Value.absent(),
    Value<int?> diastolic = const Value.absent(),
    Value<int?> pulse = const Value.absent(),
    String? unit,
    Value<String?> tag = const Value.absent(),
    DateTime? measuredAt,
    Value<String?> note = const Value.absent(),
  }) => Reading(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    metricKey: metricKey ?? this.metricKey,
    value: value.present ? value.value : this.value,
    systolic: systolic.present ? systolic.value : this.systolic,
    diastolic: diastolic.present ? diastolic.value : this.diastolic,
    pulse: pulse.present ? pulse.value : this.pulse,
    unit: unit ?? this.unit,
    tag: tag.present ? tag.value : this.tag,
    measuredAt: measuredAt ?? this.measuredAt,
    note: note.present ? note.value : this.note,
  );
  Reading copyWithCompanion(ReadingsCompanion data) {
    return Reading(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      metricKey: data.metricKey.present ? data.metricKey.value : this.metricKey,
      value: data.value.present ? data.value.value : this.value,
      systolic: data.systolic.present ? data.systolic.value : this.systolic,
      diastolic: data.diastolic.present ? data.diastolic.value : this.diastolic,
      pulse: data.pulse.present ? data.pulse.value : this.pulse,
      unit: data.unit.present ? data.unit.value : this.unit,
      tag: data.tag.present ? data.tag.value : this.tag,
      measuredAt: data.measuredAt.present
          ? data.measuredAt.value
          : this.measuredAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reading(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('metricKey: $metricKey, ')
          ..write('value: $value, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('pulse: $pulse, ')
          ..write('unit: $unit, ')
          ..write('tag: $tag, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    metricKey,
    value,
    systolic,
    diastolic,
    pulse,
    unit,
    tag,
    measuredAt,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reading &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.metricKey == this.metricKey &&
          other.value == this.value &&
          other.systolic == this.systolic &&
          other.diastolic == this.diastolic &&
          other.pulse == this.pulse &&
          other.unit == this.unit &&
          other.tag == this.tag &&
          other.measuredAt == this.measuredAt &&
          other.note == this.note);
}

class ReadingsCompanion extends UpdateCompanion<Reading> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<String> metricKey;
  final Value<double?> value;
  final Value<int?> systolic;
  final Value<int?> diastolic;
  final Value<int?> pulse;
  final Value<String> unit;
  final Value<String?> tag;
  final Value<DateTime> measuredAt;
  final Value<String?> note;
  const ReadingsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.metricKey = const Value.absent(),
    this.value = const Value.absent(),
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.pulse = const Value.absent(),
    this.unit = const Value.absent(),
    this.tag = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.note = const Value.absent(),
  });
  ReadingsCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    required String metricKey,
    this.value = const Value.absent(),
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.pulse = const Value.absent(),
    required String unit,
    this.tag = const Value.absent(),
    required DateTime measuredAt,
    this.note = const Value.absent(),
  }) : patientId = Value(patientId),
       metricKey = Value(metricKey),
       unit = Value(unit),
       measuredAt = Value(measuredAt);
  static Insertable<Reading> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<String>? metricKey,
    Expression<double>? value,
    Expression<int>? systolic,
    Expression<int>? diastolic,
    Expression<int>? pulse,
    Expression<String>? unit,
    Expression<String>? tag,
    Expression<DateTime>? measuredAt,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (metricKey != null) 'metric_key': metricKey,
      if (value != null) 'value': value,
      if (systolic != null) 'systolic': systolic,
      if (diastolic != null) 'diastolic': diastolic,
      if (pulse != null) 'pulse': pulse,
      if (unit != null) 'unit': unit,
      if (tag != null) 'tag': tag,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (note != null) 'note': note,
    });
  }

  ReadingsCompanion copyWith({
    Value<int>? id,
    Value<int>? patientId,
    Value<String>? metricKey,
    Value<double?>? value,
    Value<int?>? systolic,
    Value<int?>? diastolic,
    Value<int?>? pulse,
    Value<String>? unit,
    Value<String?>? tag,
    Value<DateTime>? measuredAt,
    Value<String?>? note,
  }) {
    return ReadingsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      metricKey: metricKey ?? this.metricKey,
      value: value ?? this.value,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      pulse: pulse ?? this.pulse,
      unit: unit ?? this.unit,
      tag: tag ?? this.tag,
      measuredAt: measuredAt ?? this.measuredAt,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (metricKey.present) {
      map['metric_key'] = Variable<String>(metricKey.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (systolic.present) {
      map['systolic'] = Variable<int>(systolic.value);
    }
    if (diastolic.present) {
      map['diastolic'] = Variable<int>(diastolic.value);
    }
    if (pulse.present) {
      map['pulse'] = Variable<int>(pulse.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('metricKey: $metricKey, ')
          ..write('value: $value, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('pulse: $pulse, ')
          ..write('unit: $unit, ')
          ..write('tag: $tag, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, patientId, name, notes, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medication> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}patient_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final int id;
  final int patientId;
  final String name;
  final String? notes;
  final bool active;
  const Medication({
    required this.id,
    required this.patientId,
    required this.name,
    this.notes,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      name: Value(name),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      active: Value(active),
    );
  }

  factory Medication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'active': serializer.toJson<bool>(active),
    };
  }

  Medication copyWith({
    int? id,
    int? patientId,
    String? name,
    Value<String?> notes = const Value.absent(),
    bool? active,
  }) => Medication(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    name: name ?? this.name,
    notes: notes.present ? notes.value : this.notes,
    active: active ?? this.active,
  );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, name, notes, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.active == this.active);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<String> name;
  final Value<String?> notes;
  final Value<bool> active;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.active = const Value.absent(),
  });
  MedicationsCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    required String name,
    this.notes = const Value.absent(),
    this.active = const Value.absent(),
  }) : patientId = Value(patientId),
       name = Value(name);
  static Insertable<Medication> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (active != null) 'active': active,
    });
  }

  MedicationsCompanion copyWith({
    Value<int>? id,
    Value<int>? patientId,
    Value<String>? name,
    Value<String?>? notes,
    Value<bool>? active,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $MedicationSlotsTable extends MedicationSlots
    with TableInfo<$MedicationSlotsTable, MedicationSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<int> medicationId = GeneratedColumn<int>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DoseSlot, String> slot =
      GeneratedColumn<String>(
        'slot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DoseSlot>($MedicationSlotsTable.$converterslot);
  static const VerificationMeta _startedOnMeta = const VerificationMeta(
    'startedOn',
  );
  @override
  late final GeneratedColumn<String> startedOn = GeneratedColumn<String>(
    'started_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endedOnMeta = const VerificationMeta(
    'endedOn',
  );
  @override
  late final GeneratedColumn<String> endedOn = GeneratedColumn<String>(
    'ended_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    medicationId,
    slot,
    startedOn,
    endedOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('started_on')) {
      context.handle(
        _startedOnMeta,
        startedOn.isAcceptableOrUnknown(data['started_on']!, _startedOnMeta),
      );
    }
    if (data.containsKey('ended_on')) {
      context.handle(
        _endedOnMeta,
        endedOn.isAcceptableOrUnknown(data['ended_on']!, _endedOnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {medicationId, slot};
  @override
  MedicationSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationSlot(
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medication_id'],
      )!,
      slot: $MedicationSlotsTable.$converterslot.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}slot'],
        )!,
      ),
      startedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}started_on'],
      ),
      endedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ended_on'],
      ),
    );
  }

  @override
  $MedicationSlotsTable createAlias(String alias) {
    return $MedicationSlotsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DoseSlot, String, String> $converterslot =
      const EnumNameConverter<DoseSlot>(DoseSlot.values);
}

class MedicationSlot extends DataClass implements Insertable<MedicationSlot> {
  final int medicationId;
  final DoseSlot slot;

  /// First day this slot counted (`yyyy-MM-dd`, AD). Adherence only expects a
  /// dose from this day on, so adding "night" to an old medicine does not turn
  /// every past night into a miss. Null = counted from the beginning.
  final String? startedOn;

  /// Day after the last day this slot counted (exclusive). Null = still in use.
  /// Removing a slot or medicine only sets this; history is never deleted.
  final String? endedOn;
  const MedicationSlot({
    required this.medicationId,
    required this.slot,
    this.startedOn,
    this.endedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['medication_id'] = Variable<int>(medicationId);
    {
      map['slot'] = Variable<String>(
        $MedicationSlotsTable.$converterslot.toSql(slot),
      );
    }
    if (!nullToAbsent || startedOn != null) {
      map['started_on'] = Variable<String>(startedOn);
    }
    if (!nullToAbsent || endedOn != null) {
      map['ended_on'] = Variable<String>(endedOn);
    }
    return map;
  }

  MedicationSlotsCompanion toCompanion(bool nullToAbsent) {
    return MedicationSlotsCompanion(
      medicationId: Value(medicationId),
      slot: Value(slot),
      startedOn: startedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(startedOn),
      endedOn: endedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(endedOn),
    );
  }

  factory MedicationSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationSlot(
      medicationId: serializer.fromJson<int>(json['medicationId']),
      slot: $MedicationSlotsTable.$converterslot.fromJson(
        serializer.fromJson<String>(json['slot']),
      ),
      startedOn: serializer.fromJson<String?>(json['startedOn']),
      endedOn: serializer.fromJson<String?>(json['endedOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'medicationId': serializer.toJson<int>(medicationId),
      'slot': serializer.toJson<String>(
        $MedicationSlotsTable.$converterslot.toJson(slot),
      ),
      'startedOn': serializer.toJson<String?>(startedOn),
      'endedOn': serializer.toJson<String?>(endedOn),
    };
  }

  MedicationSlot copyWith({
    int? medicationId,
    DoseSlot? slot,
    Value<String?> startedOn = const Value.absent(),
    Value<String?> endedOn = const Value.absent(),
  }) => MedicationSlot(
    medicationId: medicationId ?? this.medicationId,
    slot: slot ?? this.slot,
    startedOn: startedOn.present ? startedOn.value : this.startedOn,
    endedOn: endedOn.present ? endedOn.value : this.endedOn,
  );
  MedicationSlot copyWithCompanion(MedicationSlotsCompanion data) {
    return MedicationSlot(
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      slot: data.slot.present ? data.slot.value : this.slot,
      startedOn: data.startedOn.present ? data.startedOn.value : this.startedOn,
      endedOn: data.endedOn.present ? data.endedOn.value : this.endedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationSlot(')
          ..write('medicationId: $medicationId, ')
          ..write('slot: $slot, ')
          ..write('startedOn: $startedOn, ')
          ..write('endedOn: $endedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(medicationId, slot, startedOn, endedOn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationSlot &&
          other.medicationId == this.medicationId &&
          other.slot == this.slot &&
          other.startedOn == this.startedOn &&
          other.endedOn == this.endedOn);
}

class MedicationSlotsCompanion extends UpdateCompanion<MedicationSlot> {
  final Value<int> medicationId;
  final Value<DoseSlot> slot;
  final Value<String?> startedOn;
  final Value<String?> endedOn;
  final Value<int> rowid;
  const MedicationSlotsCompanion({
    this.medicationId = const Value.absent(),
    this.slot = const Value.absent(),
    this.startedOn = const Value.absent(),
    this.endedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationSlotsCompanion.insert({
    required int medicationId,
    required DoseSlot slot,
    this.startedOn = const Value.absent(),
    this.endedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : medicationId = Value(medicationId),
       slot = Value(slot);
  static Insertable<MedicationSlot> custom({
    Expression<int>? medicationId,
    Expression<String>? slot,
    Expression<String>? startedOn,
    Expression<String>? endedOn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (medicationId != null) 'medication_id': medicationId,
      if (slot != null) 'slot': slot,
      if (startedOn != null) 'started_on': startedOn,
      if (endedOn != null) 'ended_on': endedOn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationSlotsCompanion copyWith({
    Value<int>? medicationId,
    Value<DoseSlot>? slot,
    Value<String?>? startedOn,
    Value<String?>? endedOn,
    Value<int>? rowid,
  }) {
    return MedicationSlotsCompanion(
      medicationId: medicationId ?? this.medicationId,
      slot: slot ?? this.slot,
      startedOn: startedOn ?? this.startedOn,
      endedOn: endedOn ?? this.endedOn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (medicationId.present) {
      map['medication_id'] = Variable<int>(medicationId.value);
    }
    if (slot.present) {
      map['slot'] = Variable<String>(
        $MedicationSlotsTable.$converterslot.toSql(slot.value),
      );
    }
    if (startedOn.present) {
      map['started_on'] = Variable<String>(startedOn.value);
    }
    if (endedOn.present) {
      map['ended_on'] = Variable<String>(endedOn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationSlotsCompanion(')
          ..write('medicationId: $medicationId, ')
          ..write('slot: $slot, ')
          ..write('startedOn: $startedOn, ')
          ..write('endedOn: $endedOn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoseLogsTable extends DoseLogs with TableInfo<$DoseLogsTable, DoseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<int> medicationId = GeneratedColumn<int>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DoseSlot, String> slot =
      GeneratedColumn<String>(
        'slot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DoseSlot>($DoseLogsTable.$converterslot);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenMeta = const VerificationMeta('taken');
  @override
  late final GeneratedColumn<bool> taken = GeneratedColumn<bool>(
    'taken',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("taken" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _givenByMeta = const VerificationMeta(
    'givenBy',
  );
  @override
  late final GeneratedColumn<String> givenBy = GeneratedColumn<String>(
    'given_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    slot,
    date,
    taken,
    takenAt,
    givenBy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoseLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('taken')) {
      context.handle(
        _takenMeta,
        taken.isAcceptableOrUnknown(data['taken']!, _takenMeta),
      );
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    }
    if (data.containsKey('given_by')) {
      context.handle(
        _givenByMeta,
        givenBy.isAcceptableOrUnknown(data['given_by']!, _givenByMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {medicationId, slot, date},
  ];
  @override
  DoseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medication_id'],
      )!,
      slot: $DoseLogsTable.$converterslot.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}slot'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      taken: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}taken'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      ),
      givenBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}given_by'],
      ),
    );
  }

  @override
  $DoseLogsTable createAlias(String alias) {
    return $DoseLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DoseSlot, String, String> $converterslot =
      const EnumNameConverter<DoseSlot>(DoseSlot.values);
}

class DoseLog extends DataClass implements Insertable<DoseLog> {
  final int id;
  final int medicationId;
  final DoseSlot slot;

  /// AD calendar day as `yyyy-MM-dd` (see dateKey).
  final String date;
  final bool taken;
  final DateTime? takenAt;
  final String? givenBy;
  const DoseLog({
    required this.id,
    required this.medicationId,
    required this.slot,
    required this.date,
    required this.taken,
    this.takenAt,
    this.givenBy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medication_id'] = Variable<int>(medicationId);
    {
      map['slot'] = Variable<String>($DoseLogsTable.$converterslot.toSql(slot));
    }
    map['date'] = Variable<String>(date);
    map['taken'] = Variable<bool>(taken);
    if (!nullToAbsent || takenAt != null) {
      map['taken_at'] = Variable<DateTime>(takenAt);
    }
    if (!nullToAbsent || givenBy != null) {
      map['given_by'] = Variable<String>(givenBy);
    }
    return map;
  }

  DoseLogsCompanion toCompanion(bool nullToAbsent) {
    return DoseLogsCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      slot: Value(slot),
      date: Value(date),
      taken: Value(taken),
      takenAt: takenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(takenAt),
      givenBy: givenBy == null && nullToAbsent
          ? const Value.absent()
          : Value(givenBy),
    );
  }

  factory DoseLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseLog(
      id: serializer.fromJson<int>(json['id']),
      medicationId: serializer.fromJson<int>(json['medicationId']),
      slot: $DoseLogsTable.$converterslot.fromJson(
        serializer.fromJson<String>(json['slot']),
      ),
      date: serializer.fromJson<String>(json['date']),
      taken: serializer.fromJson<bool>(json['taken']),
      takenAt: serializer.fromJson<DateTime?>(json['takenAt']),
      givenBy: serializer.fromJson<String?>(json['givenBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicationId': serializer.toJson<int>(medicationId),
      'slot': serializer.toJson<String>(
        $DoseLogsTable.$converterslot.toJson(slot),
      ),
      'date': serializer.toJson<String>(date),
      'taken': serializer.toJson<bool>(taken),
      'takenAt': serializer.toJson<DateTime?>(takenAt),
      'givenBy': serializer.toJson<String?>(givenBy),
    };
  }

  DoseLog copyWith({
    int? id,
    int? medicationId,
    DoseSlot? slot,
    String? date,
    bool? taken,
    Value<DateTime?> takenAt = const Value.absent(),
    Value<String?> givenBy = const Value.absent(),
  }) => DoseLog(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    slot: slot ?? this.slot,
    date: date ?? this.date,
    taken: taken ?? this.taken,
    takenAt: takenAt.present ? takenAt.value : this.takenAt,
    givenBy: givenBy.present ? givenBy.value : this.givenBy,
  );
  DoseLog copyWithCompanion(DoseLogsCompanion data) {
    return DoseLog(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      slot: data.slot.present ? data.slot.value : this.slot,
      date: data.date.present ? data.date.value : this.date,
      taken: data.taken.present ? data.taken.value : this.taken,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      givenBy: data.givenBy.present ? data.givenBy.value : this.givenBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseLog(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('slot: $slot, ')
          ..write('date: $date, ')
          ..write('taken: $taken, ')
          ..write('takenAt: $takenAt, ')
          ..write('givenBy: $givenBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, medicationId, slot, date, taken, takenAt, givenBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseLog &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.slot == this.slot &&
          other.date == this.date &&
          other.taken == this.taken &&
          other.takenAt == this.takenAt &&
          other.givenBy == this.givenBy);
}

class DoseLogsCompanion extends UpdateCompanion<DoseLog> {
  final Value<int> id;
  final Value<int> medicationId;
  final Value<DoseSlot> slot;
  final Value<String> date;
  final Value<bool> taken;
  final Value<DateTime?> takenAt;
  final Value<String?> givenBy;
  const DoseLogsCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.slot = const Value.absent(),
    this.date = const Value.absent(),
    this.taken = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.givenBy = const Value.absent(),
  });
  DoseLogsCompanion.insert({
    this.id = const Value.absent(),
    required int medicationId,
    required DoseSlot slot,
    required String date,
    this.taken = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.givenBy = const Value.absent(),
  }) : medicationId = Value(medicationId),
       slot = Value(slot),
       date = Value(date);
  static Insertable<DoseLog> custom({
    Expression<int>? id,
    Expression<int>? medicationId,
    Expression<String>? slot,
    Expression<String>? date,
    Expression<bool>? taken,
    Expression<DateTime>? takenAt,
    Expression<String>? givenBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (slot != null) 'slot': slot,
      if (date != null) 'date': date,
      if (taken != null) 'taken': taken,
      if (takenAt != null) 'taken_at': takenAt,
      if (givenBy != null) 'given_by': givenBy,
    });
  }

  DoseLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? medicationId,
    Value<DoseSlot>? slot,
    Value<String>? date,
    Value<bool>? taken,
    Value<DateTime?>? takenAt,
    Value<String?>? givenBy,
  }) {
    return DoseLogsCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      slot: slot ?? this.slot,
      date: date ?? this.date,
      taken: taken ?? this.taken,
      takenAt: takenAt ?? this.takenAt,
      givenBy: givenBy ?? this.givenBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<int>(medicationId.value);
    }
    if (slot.present) {
      map['slot'] = Variable<String>(
        $DoseLogsTable.$converterslot.toSql(slot.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (taken.present) {
      map['taken'] = Variable<bool>(taken.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (givenBy.present) {
      map['given_by'] = Variable<String>(givenBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoseLogsCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('slot: $slot, ')
          ..write('date: $date, ')
          ..write('taken: $taken, ')
          ..write('takenAt: $takenAt, ')
          ..write('givenBy: $givenBy')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReminderType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReminderType>($RemindersTable.$convertertype);
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatRuleMeta = const VerificationMeta(
    'repeatRule',
  );
  @override
  late final GeneratedColumn<String> repeatRule = GeneratedColumn<String>(
    'repeat_rule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('daily'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    hour,
    minute,
    repeatRule,
    enabled,
    label,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('repeat_rule')) {
      context.handle(
        _repeatRuleMeta,
        repeatRule.isAcceptableOrUnknown(data['repeat_rule']!, _repeatRuleMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $RemindersTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
      repeatRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_rule'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReminderType, String, String> $convertertype =
      const EnumNameConverter<ReminderType>(ReminderType.values);
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final ReminderType type;
  final int hour;
  final int minute;

  /// `daily`, `weekly:<1-7>` (Mon=1) or `monthly:<1-28>`.
  final String repeatRule;
  final bool enabled;
  final String? label;
  const Reminder({
    required this.id,
    required this.type,
    required this.hour,
    required this.minute,
    required this.repeatRule,
    required this.enabled,
    this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<String>(
        $RemindersTable.$convertertype.toSql(type),
      );
    }
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['repeat_rule'] = Variable<String>(repeatRule);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      type: Value(type),
      hour: Value(hour),
      minute: Value(minute),
      repeatRule: Value(repeatRule),
      enabled: Value(enabled),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      type: $RemindersTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      repeatRule: serializer.fromJson<String>(json['repeatRule']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      label: serializer.fromJson<String?>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(
        $RemindersTable.$convertertype.toJson(type),
      ),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'repeatRule': serializer.toJson<String>(repeatRule),
      'enabled': serializer.toJson<bool>(enabled),
      'label': serializer.toJson<String?>(label),
    };
  }

  Reminder copyWith({
    int? id,
    ReminderType? type,
    int? hour,
    int? minute,
    String? repeatRule,
    bool? enabled,
    Value<String?> label = const Value.absent(),
  }) => Reminder(
    id: id ?? this.id,
    type: type ?? this.type,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    repeatRule: repeatRule ?? this.repeatRule,
    enabled: enabled ?? this.enabled,
    label: label.present ? label.value : this.label,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      repeatRule: data.repeatRule.present
          ? data.repeatRule.value
          : this.repeatRule,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('enabled: $enabled, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, hour, minute, repeatRule, enabled, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.type == this.type &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.repeatRule == this.repeatRule &&
          other.enabled == this.enabled &&
          other.label == this.label);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<ReminderType> type;
  final Value<int> hour;
  final Value<int> minute;
  final Value<String> repeatRule;
  final Value<bool> enabled;
  final Value<String?> label;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.enabled = const Value.absent(),
    this.label = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required ReminderType type,
    required int hour,
    required int minute,
    this.repeatRule = const Value.absent(),
    this.enabled = const Value.absent(),
    this.label = const Value.absent(),
  }) : type = Value(type),
       hour = Value(hour),
       minute = Value(minute);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<String>? repeatRule,
    Expression<bool>? enabled,
    Expression<String>? label,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (repeatRule != null) 'repeat_rule': repeatRule,
      if (enabled != null) 'enabled': enabled,
      if (label != null) 'label': label,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<ReminderType>? type,
    Value<int>? hour,
    Value<int>? minute,
    Value<String>? repeatRule,
    Value<bool>? enabled,
    Value<String?>? label,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      repeatRule: repeatRule ?? this.repeatRule,
      enabled: enabled ?? this.enabled,
      label: label ?? this.label,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $RemindersTable.$convertertype.toSql(type.value),
      );
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (repeatRule.present) {
      map['repeat_rule'] = Variable<String>(repeatRule.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('enabled: $enabled, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

class $FoodItemsTable extends FoodItems
    with TableInfo<$FoodItemsTable, FoodItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameNeMeta = const VerificationMeta('nameNe');
  @override
  late final GeneratedColumn<String> nameNe = GeneratedColumn<String>(
    'name_ne',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameEn,
    nameNe,
    category,
    tags,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ne')) {
      context.handle(
        _nameNeMeta,
        nameNe.isAcceptableOrUnknown(data['name_ne']!, _nameNeMeta),
      );
    } else if (isInserting) {
      context.missing(_nameNeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameNe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ne'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $FoodItemsTable createAlias(String alias) {
    return $FoodItemsTable(attachedDatabase, alias);
  }
}

class FoodItem extends DataClass implements Insertable<FoodItem> {
  final int id;
  final String nameEn;
  final String nameNe;
  final String category;
  final String tags;
  final String? notes;
  const FoodItem({
    required this.id,
    required this.nameEn,
    required this.nameNe,
    required this.category,
    required this.tags,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_en'] = Variable<String>(nameEn);
    map['name_ne'] = Variable<String>(nameNe);
    map['category'] = Variable<String>(category);
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  FoodItemsCompanion toCompanion(bool nullToAbsent) {
    return FoodItemsCompanion(
      id: Value(id),
      nameEn: Value(nameEn),
      nameNe: Value(nameNe),
      category: Value(category),
      tags: Value(tags),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory FoodItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodItem(
      id: serializer.fromJson<int>(json['id']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameNe: serializer.fromJson<String>(json['nameNe']),
      category: serializer.fromJson<String>(json['category']),
      tags: serializer.fromJson<String>(json['tags']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameNe': serializer.toJson<String>(nameNe),
      'category': serializer.toJson<String>(category),
      'tags': serializer.toJson<String>(tags),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  FoodItem copyWith({
    int? id,
    String? nameEn,
    String? nameNe,
    String? category,
    String? tags,
    Value<String?> notes = const Value.absent(),
  }) => FoodItem(
    id: id ?? this.id,
    nameEn: nameEn ?? this.nameEn,
    nameNe: nameNe ?? this.nameNe,
    category: category ?? this.category,
    tags: tags ?? this.tags,
    notes: notes.present ? notes.value : this.notes,
  );
  FoodItem copyWithCompanion(FoodItemsCompanion data) {
    return FoodItem(
      id: data.id.present ? data.id.value : this.id,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameNe: data.nameNe.present ? data.nameNe.value : this.nameNe,
      category: data.category.present ? data.category.value : this.category,
      tags: data.tags.present ? data.tags.value : this.tags,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodItem(')
          ..write('id: $id, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameNe: $nameNe, ')
          ..write('category: $category, ')
          ..write('tags: $tags, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameEn, nameNe, category, tags, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodItem &&
          other.id == this.id &&
          other.nameEn == this.nameEn &&
          other.nameNe == this.nameNe &&
          other.category == this.category &&
          other.tags == this.tags &&
          other.notes == this.notes);
}

class FoodItemsCompanion extends UpdateCompanion<FoodItem> {
  final Value<int> id;
  final Value<String> nameEn;
  final Value<String> nameNe;
  final Value<String> category;
  final Value<String> tags;
  final Value<String?> notes;
  const FoodItemsCompanion({
    this.id = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameNe = const Value.absent(),
    this.category = const Value.absent(),
    this.tags = const Value.absent(),
    this.notes = const Value.absent(),
  });
  FoodItemsCompanion.insert({
    this.id = const Value.absent(),
    required String nameEn,
    required String nameNe,
    required String category,
    this.tags = const Value.absent(),
    this.notes = const Value.absent(),
  }) : nameEn = Value(nameEn),
       nameNe = Value(nameNe),
       category = Value(category);
  static Insertable<FoodItem> custom({
    Expression<int>? id,
    Expression<String>? nameEn,
    Expression<String>? nameNe,
    Expression<String>? category,
    Expression<String>? tags,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameEn != null) 'name_en': nameEn,
      if (nameNe != null) 'name_ne': nameNe,
      if (category != null) 'category': category,
      if (tags != null) 'tags': tags,
      if (notes != null) 'notes': notes,
    });
  }

  FoodItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? nameEn,
    Value<String>? nameNe,
    Value<String>? category,
    Value<String>? tags,
    Value<String?>? notes,
  }) {
    return FoodItemsCompanion(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameNe: nameNe ?? this.nameNe,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameNe.present) {
      map['name_ne'] = Variable<String>(nameNe.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemsCompanion(')
          ..write('id: $id, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameNe: $nameNe, ')
          ..write('category: $category, ')
          ..write('tags: $tags, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $EmergencyContactsTable extends EmergencyContacts
    with TableInfo<$EmergencyContactsTable, EmergencyContact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmergencyContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ContactRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ContactRole>($EmergencyContactsTable.$converterrole);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, role, phone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emergency_contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmergencyContact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmergencyContact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmergencyContact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: $EmergencyContactsTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
    );
  }

  @override
  $EmergencyContactsTable createAlias(String alias) {
    return $EmergencyContactsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ContactRole, String, String> $converterrole =
      const EnumNameConverter<ContactRole>(ContactRole.values);
}

class EmergencyContact extends DataClass
    implements Insertable<EmergencyContact> {
  final int id;
  final String name;
  final ContactRole role;
  final String phone;
  const EmergencyContact({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['role'] = Variable<String>(
        $EmergencyContactsTable.$converterrole.toSql(role),
      );
    }
    map['phone'] = Variable<String>(phone);
    return map;
  }

  EmergencyContactsCompanion toCompanion(bool nullToAbsent) {
    return EmergencyContactsCompanion(
      id: Value(id),
      name: Value(name),
      role: Value(role),
      phone: Value(phone),
    );
  }

  factory EmergencyContact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmergencyContact(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: $EmergencyContactsTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      phone: serializer.fromJson<String>(json['phone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(
        $EmergencyContactsTable.$converterrole.toJson(role),
      ),
      'phone': serializer.toJson<String>(phone),
    };
  }

  EmergencyContact copyWith({
    int? id,
    String? name,
    ContactRole? role,
    String? phone,
  }) => EmergencyContact(
    id: id ?? this.id,
    name: name ?? this.name,
    role: role ?? this.role,
    phone: phone ?? this.phone,
  );
  EmergencyContact copyWithCompanion(EmergencyContactsCompanion data) {
    return EmergencyContact(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      phone: data.phone.present ? data.phone.value : this.phone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyContact(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, role, phone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmergencyContact &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.phone == this.phone);
}

class EmergencyContactsCompanion extends UpdateCompanion<EmergencyContact> {
  final Value<int> id;
  final Value<String> name;
  final Value<ContactRole> role;
  final Value<String> phone;
  const EmergencyContactsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
  });
  EmergencyContactsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required ContactRole role,
    required String phone,
  }) : name = Value(name),
       role = Value(role),
       phone = Value(phone);
  static Insertable<EmergencyContact> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? phone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone,
    });
  }

  EmergencyContactsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<ContactRole>? role,
    Value<String>? phone,
  }) {
    return EmergencyContactsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $EmergencyContactsTable.$converterrole.toSql(role.value),
      );
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyContactsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppLanguage, String> language =
      GeneratedColumn<String>(
        'language',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('en'),
      ).withConverter<AppLanguage>($AppSettingsTableTable.$converterlanguage);
  @override
  late final GeneratedColumnWithTypeConverter<DateStyle, String> dateStyle =
      GeneratedColumn<String>(
        'date_style',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('ad'),
      ).withConverter<DateStyle>($AppSettingsTableTable.$converterdateStyle);
  @override
  late final GeneratedColumnWithTypeConverter<GlucoseUnit, String> glucoseUnit =
      GeneratedColumn<String>(
        'glucose_unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('mgDl'),
      ).withConverter<GlucoseUnit>(
        $AppSettingsTableTable.$converterglucoseUnit,
      );
  @override
  late final GeneratedColumnWithTypeConverter<DigitStyle, String> digitStyle =
      GeneratedColumn<String>(
        'digit_style',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('latin'),
      ).withConverter<DigitStyle>($AppSettingsTableTable.$converterdigitStyle);
  static const VerificationMeta _fastingOnDateMeta = const VerificationMeta(
    'fastingOnDate',
  );
  @override
  late final GeneratedColumn<String> fastingOnDate = GeneratedColumn<String>(
    'fasting_on_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSugarTagMeta = const VerificationMeta(
    'lastSugarTag',
  );
  @override
  late final GeneratedColumn<String> lastSugarTag = GeneratedColumn<String>(
    'last_sugar_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastBpTagMeta = const VerificationMeta(
    'lastBpTag',
  );
  @override
  late final GeneratedColumn<String> lastBpTag = GeneratedColumn<String>(
    'last_bp_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _disclaimerAcceptedMeta =
      const VerificationMeta('disclaimerAccepted');
  @override
  late final GeneratedColumn<bool> disclaimerAccepted = GeneratedColumn<bool>(
    'disclaimer_accepted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("disclaimer_accepted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _remindersSeededMeta = const VerificationMeta(
    'remindersSeeded',
  );
  @override
  late final GeneratedColumn<bool> remindersSeeded = GeneratedColumn<bool>(
    'reminders_seeded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminders_seeded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    language,
    dateStyle,
    glucoseUnit,
    digitStyle,
    fastingOnDate,
    lastSugarTag,
    lastBpTag,
    disclaimerAccepted,
    remindersSeeded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fasting_on_date')) {
      context.handle(
        _fastingOnDateMeta,
        fastingOnDate.isAcceptableOrUnknown(
          data['fasting_on_date']!,
          _fastingOnDateMeta,
        ),
      );
    }
    if (data.containsKey('last_sugar_tag')) {
      context.handle(
        _lastSugarTagMeta,
        lastSugarTag.isAcceptableOrUnknown(
          data['last_sugar_tag']!,
          _lastSugarTagMeta,
        ),
      );
    }
    if (data.containsKey('last_bp_tag')) {
      context.handle(
        _lastBpTagMeta,
        lastBpTag.isAcceptableOrUnknown(data['last_bp_tag']!, _lastBpTagMeta),
      );
    }
    if (data.containsKey('disclaimer_accepted')) {
      context.handle(
        _disclaimerAcceptedMeta,
        disclaimerAccepted.isAcceptableOrUnknown(
          data['disclaimer_accepted']!,
          _disclaimerAcceptedMeta,
        ),
      );
    }
    if (data.containsKey('reminders_seeded')) {
      context.handle(
        _remindersSeededMeta,
        remindersSeeded.isAcceptableOrUnknown(
          data['reminders_seeded']!,
          _remindersSeededMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      language: $AppSettingsTableTable.$converterlanguage.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}language'],
        )!,
      ),
      dateStyle: $AppSettingsTableTable.$converterdateStyle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date_style'],
        )!,
      ),
      glucoseUnit: $AppSettingsTableTable.$converterglucoseUnit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}glucose_unit'],
        )!,
      ),
      digitStyle: $AppSettingsTableTable.$converterdigitStyle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}digit_style'],
        )!,
      ),
      fastingOnDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fasting_on_date'],
      ),
      lastSugarTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sugar_tag'],
      ),
      lastBpTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_bp_tag'],
      ),
      disclaimerAccepted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}disclaimer_accepted'],
      )!,
      remindersSeeded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminders_seeded'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppLanguage, String, String> $converterlanguage =
      const EnumNameConverter<AppLanguage>(AppLanguage.values);
  static JsonTypeConverter2<DateStyle, String, String> $converterdateStyle =
      const EnumNameConverter<DateStyle>(DateStyle.values);
  static JsonTypeConverter2<GlucoseUnit, String, String> $converterglucoseUnit =
      const EnumNameConverter<GlucoseUnit>(GlucoseUnit.values);
  static JsonTypeConverter2<DigitStyle, String, String> $converterdigitStyle =
      const EnumNameConverter<DigitStyle>(DigitStyle.values);
}

class AppSettingsRow extends DataClass implements Insertable<AppSettingsRow> {
  final int id;
  final AppLanguage language;
  final DateStyle dateStyle;
  final GlucoseUnit glucoseUnit;
  final DigitStyle digitStyle;

  /// "Fasting today (upabas)": holds the AD day it was switched on, so it
  /// switches itself off the next day. Use `fastingToday(now)` to read it.
  final String? fastingOnDate;

  /// Remembered last-used choices, so logging needs fewer taps.
  final String? lastSugarTag;
  final String? lastBpTag;
  final bool disclaimerAccepted;

  /// The default reminders are created once, so deleting them stays deleted.
  final bool remindersSeeded;
  const AppSettingsRow({
    required this.id,
    required this.language,
    required this.dateStyle,
    required this.glucoseUnit,
    required this.digitStyle,
    this.fastingOnDate,
    this.lastSugarTag,
    this.lastBpTag,
    required this.disclaimerAccepted,
    required this.remindersSeeded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['language'] = Variable<String>(
        $AppSettingsTableTable.$converterlanguage.toSql(language),
      );
    }
    {
      map['date_style'] = Variable<String>(
        $AppSettingsTableTable.$converterdateStyle.toSql(dateStyle),
      );
    }
    {
      map['glucose_unit'] = Variable<String>(
        $AppSettingsTableTable.$converterglucoseUnit.toSql(glucoseUnit),
      );
    }
    {
      map['digit_style'] = Variable<String>(
        $AppSettingsTableTable.$converterdigitStyle.toSql(digitStyle),
      );
    }
    if (!nullToAbsent || fastingOnDate != null) {
      map['fasting_on_date'] = Variable<String>(fastingOnDate);
    }
    if (!nullToAbsent || lastSugarTag != null) {
      map['last_sugar_tag'] = Variable<String>(lastSugarTag);
    }
    if (!nullToAbsent || lastBpTag != null) {
      map['last_bp_tag'] = Variable<String>(lastBpTag);
    }
    map['disclaimer_accepted'] = Variable<bool>(disclaimerAccepted);
    map['reminders_seeded'] = Variable<bool>(remindersSeeded);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      language: Value(language),
      dateStyle: Value(dateStyle),
      glucoseUnit: Value(glucoseUnit),
      digitStyle: Value(digitStyle),
      fastingOnDate: fastingOnDate == null && nullToAbsent
          ? const Value.absent()
          : Value(fastingOnDate),
      lastSugarTag: lastSugarTag == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSugarTag),
      lastBpTag: lastBpTag == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBpTag),
      disclaimerAccepted: Value(disclaimerAccepted),
      remindersSeeded: Value(remindersSeeded),
    );
  }

  factory AppSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      language: $AppSettingsTableTable.$converterlanguage.fromJson(
        serializer.fromJson<String>(json['language']),
      ),
      dateStyle: $AppSettingsTableTable.$converterdateStyle.fromJson(
        serializer.fromJson<String>(json['dateStyle']),
      ),
      glucoseUnit: $AppSettingsTableTable.$converterglucoseUnit.fromJson(
        serializer.fromJson<String>(json['glucoseUnit']),
      ),
      digitStyle: $AppSettingsTableTable.$converterdigitStyle.fromJson(
        serializer.fromJson<String>(json['digitStyle']),
      ),
      fastingOnDate: serializer.fromJson<String?>(json['fastingOnDate']),
      lastSugarTag: serializer.fromJson<String?>(json['lastSugarTag']),
      lastBpTag: serializer.fromJson<String?>(json['lastBpTag']),
      disclaimerAccepted: serializer.fromJson<bool>(json['disclaimerAccepted']),
      remindersSeeded: serializer.fromJson<bool>(json['remindersSeeded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'language': serializer.toJson<String>(
        $AppSettingsTableTable.$converterlanguage.toJson(language),
      ),
      'dateStyle': serializer.toJson<String>(
        $AppSettingsTableTable.$converterdateStyle.toJson(dateStyle),
      ),
      'glucoseUnit': serializer.toJson<String>(
        $AppSettingsTableTable.$converterglucoseUnit.toJson(glucoseUnit),
      ),
      'digitStyle': serializer.toJson<String>(
        $AppSettingsTableTable.$converterdigitStyle.toJson(digitStyle),
      ),
      'fastingOnDate': serializer.toJson<String?>(fastingOnDate),
      'lastSugarTag': serializer.toJson<String?>(lastSugarTag),
      'lastBpTag': serializer.toJson<String?>(lastBpTag),
      'disclaimerAccepted': serializer.toJson<bool>(disclaimerAccepted),
      'remindersSeeded': serializer.toJson<bool>(remindersSeeded),
    };
  }

  AppSettingsRow copyWith({
    int? id,
    AppLanguage? language,
    DateStyle? dateStyle,
    GlucoseUnit? glucoseUnit,
    DigitStyle? digitStyle,
    Value<String?> fastingOnDate = const Value.absent(),
    Value<String?> lastSugarTag = const Value.absent(),
    Value<String?> lastBpTag = const Value.absent(),
    bool? disclaimerAccepted,
    bool? remindersSeeded,
  }) => AppSettingsRow(
    id: id ?? this.id,
    language: language ?? this.language,
    dateStyle: dateStyle ?? this.dateStyle,
    glucoseUnit: glucoseUnit ?? this.glucoseUnit,
    digitStyle: digitStyle ?? this.digitStyle,
    fastingOnDate: fastingOnDate.present
        ? fastingOnDate.value
        : this.fastingOnDate,
    lastSugarTag: lastSugarTag.present ? lastSugarTag.value : this.lastSugarTag,
    lastBpTag: lastBpTag.present ? lastBpTag.value : this.lastBpTag,
    disclaimerAccepted: disclaimerAccepted ?? this.disclaimerAccepted,
    remindersSeeded: remindersSeeded ?? this.remindersSeeded,
  );
  AppSettingsRow copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      language: data.language.present ? data.language.value : this.language,
      dateStyle: data.dateStyle.present ? data.dateStyle.value : this.dateStyle,
      glucoseUnit: data.glucoseUnit.present
          ? data.glucoseUnit.value
          : this.glucoseUnit,
      digitStyle: data.digitStyle.present
          ? data.digitStyle.value
          : this.digitStyle,
      fastingOnDate: data.fastingOnDate.present
          ? data.fastingOnDate.value
          : this.fastingOnDate,
      lastSugarTag: data.lastSugarTag.present
          ? data.lastSugarTag.value
          : this.lastSugarTag,
      lastBpTag: data.lastBpTag.present ? data.lastBpTag.value : this.lastBpTag,
      disclaimerAccepted: data.disclaimerAccepted.present
          ? data.disclaimerAccepted.value
          : this.disclaimerAccepted,
      remindersSeeded: data.remindersSeeded.present
          ? data.remindersSeeded.value
          : this.remindersSeeded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRow(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('dateStyle: $dateStyle, ')
          ..write('glucoseUnit: $glucoseUnit, ')
          ..write('digitStyle: $digitStyle, ')
          ..write('fastingOnDate: $fastingOnDate, ')
          ..write('lastSugarTag: $lastSugarTag, ')
          ..write('lastBpTag: $lastBpTag, ')
          ..write('disclaimerAccepted: $disclaimerAccepted, ')
          ..write('remindersSeeded: $remindersSeeded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    language,
    dateStyle,
    glucoseUnit,
    digitStyle,
    fastingOnDate,
    lastSugarTag,
    lastBpTag,
    disclaimerAccepted,
    remindersSeeded,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsRow &&
          other.id == this.id &&
          other.language == this.language &&
          other.dateStyle == this.dateStyle &&
          other.glucoseUnit == this.glucoseUnit &&
          other.digitStyle == this.digitStyle &&
          other.fastingOnDate == this.fastingOnDate &&
          other.lastSugarTag == this.lastSugarTag &&
          other.lastBpTag == this.lastBpTag &&
          other.disclaimerAccepted == this.disclaimerAccepted &&
          other.remindersSeeded == this.remindersSeeded);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsRow> {
  final Value<int> id;
  final Value<AppLanguage> language;
  final Value<DateStyle> dateStyle;
  final Value<GlucoseUnit> glucoseUnit;
  final Value<DigitStyle> digitStyle;
  final Value<String?> fastingOnDate;
  final Value<String?> lastSugarTag;
  final Value<String?> lastBpTag;
  final Value<bool> disclaimerAccepted;
  final Value<bool> remindersSeeded;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.dateStyle = const Value.absent(),
    this.glucoseUnit = const Value.absent(),
    this.digitStyle = const Value.absent(),
    this.fastingOnDate = const Value.absent(),
    this.lastSugarTag = const Value.absent(),
    this.lastBpTag = const Value.absent(),
    this.disclaimerAccepted = const Value.absent(),
    this.remindersSeeded = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.dateStyle = const Value.absent(),
    this.glucoseUnit = const Value.absent(),
    this.digitStyle = const Value.absent(),
    this.fastingOnDate = const Value.absent(),
    this.lastSugarTag = const Value.absent(),
    this.lastBpTag = const Value.absent(),
    this.disclaimerAccepted = const Value.absent(),
    this.remindersSeeded = const Value.absent(),
  });
  static Insertable<AppSettingsRow> custom({
    Expression<int>? id,
    Expression<String>? language,
    Expression<String>? dateStyle,
    Expression<String>? glucoseUnit,
    Expression<String>? digitStyle,
    Expression<String>? fastingOnDate,
    Expression<String>? lastSugarTag,
    Expression<String>? lastBpTag,
    Expression<bool>? disclaimerAccepted,
    Expression<bool>? remindersSeeded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (language != null) 'language': language,
      if (dateStyle != null) 'date_style': dateStyle,
      if (glucoseUnit != null) 'glucose_unit': glucoseUnit,
      if (digitStyle != null) 'digit_style': digitStyle,
      if (fastingOnDate != null) 'fasting_on_date': fastingOnDate,
      if (lastSugarTag != null) 'last_sugar_tag': lastSugarTag,
      if (lastBpTag != null) 'last_bp_tag': lastBpTag,
      if (disclaimerAccepted != null) 'disclaimer_accepted': disclaimerAccepted,
      if (remindersSeeded != null) 'reminders_seeded': remindersSeeded,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<AppLanguage>? language,
    Value<DateStyle>? dateStyle,
    Value<GlucoseUnit>? glucoseUnit,
    Value<DigitStyle>? digitStyle,
    Value<String?>? fastingOnDate,
    Value<String?>? lastSugarTag,
    Value<String?>? lastBpTag,
    Value<bool>? disclaimerAccepted,
    Value<bool>? remindersSeeded,
  }) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      language: language ?? this.language,
      dateStyle: dateStyle ?? this.dateStyle,
      glucoseUnit: glucoseUnit ?? this.glucoseUnit,
      digitStyle: digitStyle ?? this.digitStyle,
      fastingOnDate: fastingOnDate ?? this.fastingOnDate,
      lastSugarTag: lastSugarTag ?? this.lastSugarTag,
      lastBpTag: lastBpTag ?? this.lastBpTag,
      disclaimerAccepted: disclaimerAccepted ?? this.disclaimerAccepted,
      remindersSeeded: remindersSeeded ?? this.remindersSeeded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(
        $AppSettingsTableTable.$converterlanguage.toSql(language.value),
      );
    }
    if (dateStyle.present) {
      map['date_style'] = Variable<String>(
        $AppSettingsTableTable.$converterdateStyle.toSql(dateStyle.value),
      );
    }
    if (glucoseUnit.present) {
      map['glucose_unit'] = Variable<String>(
        $AppSettingsTableTable.$converterglucoseUnit.toSql(glucoseUnit.value),
      );
    }
    if (digitStyle.present) {
      map['digit_style'] = Variable<String>(
        $AppSettingsTableTable.$converterdigitStyle.toSql(digitStyle.value),
      );
    }
    if (fastingOnDate.present) {
      map['fasting_on_date'] = Variable<String>(fastingOnDate.value);
    }
    if (lastSugarTag.present) {
      map['last_sugar_tag'] = Variable<String>(lastSugarTag.value);
    }
    if (lastBpTag.present) {
      map['last_bp_tag'] = Variable<String>(lastBpTag.value);
    }
    if (disclaimerAccepted.present) {
      map['disclaimer_accepted'] = Variable<bool>(disclaimerAccepted.value);
    }
    if (remindersSeeded.present) {
      map['reminders_seeded'] = Variable<bool>(remindersSeeded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('dateStyle: $dateStyle, ')
          ..write('glucoseUnit: $glucoseUnit, ')
          ..write('digitStyle: $digitStyle, ')
          ..write('fastingOnDate: $fastingOnDate, ')
          ..write('lastSugarTag: $lastSugarTag, ')
          ..write('lastBpTag: $lastBpTag, ')
          ..write('disclaimerAccepted: $disclaimerAccepted, ')
          ..write('remindersSeeded: $remindersSeeded')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $ConditionsTable conditions = $ConditionsTable(this);
  late final $MetricsTable metrics = $MetricsTable(this);
  late final $TargetRangesTable targetRanges = $TargetRangesTable(this);
  late final $ReadingsTable readings = $ReadingsTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedicationSlotsTable medicationSlots = $MedicationSlotsTable(
    this,
  );
  late final $DoseLogsTable doseLogs = $DoseLogsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $FoodItemsTable foodItems = $FoodItemsTable(this);
  late final $EmergencyContactsTable emergencyContacts =
      $EmergencyContactsTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    patients,
    conditions,
    metrics,
    targetRanges,
    readings,
    medications,
    medicationSlots,
    doseLogs,
    reminders,
    foodItems,
    emergencyContacts,
    appSettingsTable,
  ];
}

typedef $$PatientsTableCreateCompanionBuilder = PatientsCompanion Function({
  Value<int> id,
  required String name,
  Value<int?> birthYear,
  Value<String?> notes,
  Value<String?> allergies,
  Value<bool> softFood,
});
typedef $$PatientsTableUpdateCompanionBuilder = PatientsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int?> birthYear,
  Value<String?> notes,
  Value<String?> allergies,
  Value<bool> softFood,
});

final class $$PatientsTableReferences
    extends BaseReferences<_$AppDatabase, $PatientsTable, Patient> {
  $$PatientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ConditionsTable, List<PatientCondition>>
  _conditionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.conditions,
    aliasName: 'patients__id__conditions__patient_id',
  );

  $$ConditionsTableProcessedTableManager get conditionsRefs {
    final manager = $$ConditionsTableTableManager(
      $_db,
      $_db.conditions,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_conditionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TargetRangesTable, List<TargetRange>>
  _targetRangesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.targetRanges,
    aliasName: 'patients__id__target_ranges__patient_id',
  );

  $$TargetRangesTableProcessedTableManager get targetRangesRefs {
    final manager = $$TargetRangesTableTableManager(
      $_db,
      $_db.targetRanges,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_targetRangesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingsTable, List<Reading>> _readingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.readings,
    aliasName: 'patients__id__readings__patient_id',
  );

  $$ReadingsTableProcessedTableManager get readingsRefs {
    final manager = $$ReadingsTableTableManager(
      $_db,
      $_db.readings,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MedicationsTable, List<Medication>>
  _medicationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medications,
    aliasName: 'patients__id__medications__patient_id',
  );

  $$MedicationsTableProcessedTableManager get medicationsRefs {
    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PatientsTableFilterComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get softFood => $composableBuilder(
    column: $table.softFood,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> conditionsRefs(
    Expression<bool> Function($$ConditionsTableFilterComposer f) f,
  ) {
    final $$ConditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.conditions,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConditionsTableFilterComposer(
            $db: $db,
            $table: $db.conditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> targetRangesRefs(
    Expression<bool> Function($$TargetRangesTableFilterComposer f) f,
  ) {
    final $$TargetRangesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targetRanges,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetRangesTableFilterComposer(
            $db: $db,
            $table: $db.targetRanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingsRefs(
    Expression<bool> Function($$ReadingsTableFilterComposer f) f,
  ) {
    final $$ReadingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableFilterComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicationsRefs(
    Expression<bool> Function($$MedicationsTableFilterComposer f) f,
  ) {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PatientsTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get softFood => $composableBuilder(
    column: $table.softFood,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get birthYear =>
      $composableBuilder(column: $table.birthYear, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<bool> get softFood =>
      $composableBuilder(column: $table.softFood, builder: (column) => column);

  Expression<T> conditionsRefs<T extends Object>(
    Expression<T> Function($$ConditionsTableAnnotationComposer a) f,
  ) {
    final $$ConditionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.conditions,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConditionsTableAnnotationComposer(
            $db: $db,
            $table: $db.conditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> targetRangesRefs<T extends Object>(
    Expression<T> Function($$TargetRangesTableAnnotationComposer a) f,
  ) {
    final $$TargetRangesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targetRanges,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetRangesTableAnnotationComposer(
            $db: $db,
            $table: $db.targetRanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readingsRefs<T extends Object>(
    Expression<T> Function($$ReadingsTableAnnotationComposer a) f,
  ) {
    final $$ReadingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableAnnotationComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> medicationsRefs<T extends Object>(
    Expression<T> Function($$MedicationsTableAnnotationComposer a) f,
  ) {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PatientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatientsTable,
          Patient,
          $$PatientsTableFilterComposer,
          $$PatientsTableOrderingComposer,
          $$PatientsTableAnnotationComposer,
          $$PatientsTableCreateCompanionBuilder,
          $$PatientsTableUpdateCompanionBuilder,
          (Patient, $$PatientsTableReferences),
          Patient,
          PrefetchHooks Function({
            bool conditionsRefs,
            bool targetRangesRefs,
            bool readingsRefs,
            bool medicationsRefs,
          })
        > {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<bool> softFood = const Value.absent(),
              }) => PatientsCompanion(
                id: id,
                name: name,
                birthYear: birthYear,
                notes: notes,
                allergies: allergies,
                softFood: softFood,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> birthYear = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<bool> softFood = const Value.absent(),
              }) => PatientsCompanion.insert(
                id: id,
                name: name,
                birthYear: birthYear,
                notes: notes,
                allergies: allergies,
                softFood: softFood,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PatientsTable, Patient>(table),
                  $$PatientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                conditionsRefs = false,
                targetRangesRefs = false,
                readingsRefs = false,
                medicationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (conditionsRefs) db.conditions,
                    if (targetRangesRefs) db.targetRanges,
                    if (readingsRefs) db.readings,
                    if (medicationsRefs) db.medications,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (conditionsRefs)
                        await $_getPrefetchedData<
                          Patient,
                          $PatientsTable,
                          PatientCondition
                        >(
                          currentTable: table,
                          referencedTable: $$PatientsTableReferences
                              ._conditionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PatientsTableReferences(
                                db,
                                table,
                                p0,
                              ).conditionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (targetRangesRefs)
                        await $_getPrefetchedData<
                          Patient,
                          $PatientsTable,
                          TargetRange
                        >(
                          currentTable: table,
                          referencedTable: $$PatientsTableReferences
                              ._targetRangesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PatientsTableReferences(
                                db,
                                table,
                                p0,
                              ).targetRangesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingsRefs)
                        await $_getPrefetchedData<
                          Patient,
                          $PatientsTable,
                          Reading
                        >(
                          currentTable: table,
                          referencedTable: $$PatientsTableReferences
                              ._readingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PatientsTableReferences(
                                db,
                                table,
                                p0,
                              ).readingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (medicationsRefs)
                        await $_getPrefetchedData<
                          Patient,
                          $PatientsTable,
                          Medication
                        >(
                          currentTable: table,
                          referencedTable: $$PatientsTableReferences
                              ._medicationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PatientsTableReferences(
                                db,
                                table,
                                p0,
                              ).medicationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PatientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatientsTable,
      Patient,
      $$PatientsTableFilterComposer,
      $$PatientsTableOrderingComposer,
      $$PatientsTableAnnotationComposer,
      $$PatientsTableCreateCompanionBuilder,
      $$PatientsTableUpdateCompanionBuilder,
      (Patient, $$PatientsTableReferences),
      Patient,
      PrefetchHooks Function({
        bool conditionsRefs,
        bool targetRangesRefs,
        bool readingsRefs,
        bool medicationsRefs,
      })
    >;
typedef $$ConditionsTableCreateCompanionBuilder = ConditionsCompanion Function({
  Value<int> id,
  required int patientId,
  required String conditionKey,
  Value<bool> enabled,
});
typedef $$ConditionsTableUpdateCompanionBuilder = ConditionsCompanion Function({
  Value<int> id,
  Value<int> patientId,
  Value<String> conditionKey,
  Value<bool> enabled,
});

final class $$ConditionsTableReferences
    extends BaseReferences<_$AppDatabase, $ConditionsTable, PatientCondition> {
  $$ConditionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias('conditions__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ConditionsTableFilterComposer
    extends Composer<_$AppDatabase, $ConditionsTable> {
  $$ConditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionKey => $composableBuilder(
    column: $table.conditionKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConditionsTable> {
  $$ConditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionKey => $composableBuilder(
    column: $table.conditionKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConditionsTable> {
  $$ConditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conditionKey => $composableBuilder(
    column: $table.conditionKey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConditionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConditionsTable,
          PatientCondition,
          $$ConditionsTableFilterComposer,
          $$ConditionsTableOrderingComposer,
          $$ConditionsTableAnnotationComposer,
          $$ConditionsTableCreateCompanionBuilder,
          $$ConditionsTableUpdateCompanionBuilder,
          (PatientCondition, $$ConditionsTableReferences),
          PatientCondition,
          PrefetchHooks Function({bool patientId})
        > {
  $$ConditionsTableTableManager(_$AppDatabase db, $ConditionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> patientId = const Value.absent(),
                Value<String> conditionKey = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => ConditionsCompanion(
                id: id,
                patientId: patientId,
                conditionKey: conditionKey,
                enabled: enabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int patientId,
                required String conditionKey,
                Value<bool> enabled = const Value.absent(),
              }) => ConditionsCompanion.insert(
                id: id,
                patientId: patientId,
                conditionKey: conditionKey,
                enabled: enabled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConditionsTable, PatientCondition>(table),
                  $$ConditionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (patientId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.patientId,
                        referencedTable: $$ConditionsTableReferences
                            ._patientIdTable(db),
                        referencedColumn: $$ConditionsTableReferences
                            ._patientIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ConditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConditionsTable,
      PatientCondition,
      $$ConditionsTableFilterComposer,
      $$ConditionsTableOrderingComposer,
      $$ConditionsTableAnnotationComposer,
      $$ConditionsTableCreateCompanionBuilder,
      $$ConditionsTableUpdateCompanionBuilder,
      (PatientCondition, $$ConditionsTableReferences),
      PatientCondition,
      PrefetchHooks Function({bool patientId})
    >;
typedef $$MetricsTableCreateCompanionBuilder = MetricsCompanion Function({
  required String key,
  required String nameKey,
  required String unitOptions,
  required String tagOptions,
  required String conditionKey,
  required String readingKey,
  Value<int> rowid,
});
typedef $$MetricsTableUpdateCompanionBuilder = MetricsCompanion Function({
  Value<String> key,
  Value<String> nameKey,
  Value<String> unitOptions,
  Value<String> tagOptions,
  Value<String> conditionKey,
  Value<String> readingKey,
  Value<int> rowid,
});

final class $$MetricsTableReferences
    extends BaseReferences<_$AppDatabase, $MetricsTable, Metric> {
  $$MetricsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TargetRangesTable, List<TargetRange>>
  _targetRangesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.targetRanges,
    aliasName: 'metrics__key__target_ranges__metric_key',
  );

  $$TargetRangesTableProcessedTableManager get targetRangesRefs {
    final manager = $$TargetRangesTableTableManager(
      $_db,
      $_db.targetRanges,
    ).filter((f) => f.metricKey.key.sqlEquals($_itemColumn<String>('key')!));

    final cache = $_typedResult.readTableOrNull(_targetRangesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MetricsTableFilterComposer
    extends Composer<_$AppDatabase, $MetricsTable> {
  $$MetricsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitOptions => $composableBuilder(
    column: $table.unitOptions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagOptions => $composableBuilder(
    column: $table.tagOptions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionKey => $composableBuilder(
    column: $table.conditionKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readingKey => $composableBuilder(
    column: $table.readingKey,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> targetRangesRefs(
    Expression<bool> Function($$TargetRangesTableFilterComposer f) f,
  ) {
    final $$TargetRangesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.targetRanges,
      getReferencedColumn: (t) => t.metricKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetRangesTableFilterComposer(
            $db: $db,
            $table: $db.targetRanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MetricsTableOrderingComposer
    extends Composer<_$AppDatabase, $MetricsTable> {
  $$MetricsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitOptions => $composableBuilder(
    column: $table.unitOptions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagOptions => $composableBuilder(
    column: $table.tagOptions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionKey => $composableBuilder(
    column: $table.conditionKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readingKey => $composableBuilder(
    column: $table.readingKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetricsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetricsTable> {
  $$MetricsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<String> get unitOptions => $composableBuilder(
    column: $table.unitOptions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagOptions => $composableBuilder(
    column: $table.tagOptions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conditionKey => $composableBuilder(
    column: $table.conditionKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get readingKey => $composableBuilder(
    column: $table.readingKey,
    builder: (column) => column,
  );

  Expression<T> targetRangesRefs<T extends Object>(
    Expression<T> Function($$TargetRangesTableAnnotationComposer a) f,
  ) {
    final $$TargetRangesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.targetRanges,
      getReferencedColumn: (t) => t.metricKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetRangesTableAnnotationComposer(
            $db: $db,
            $table: $db.targetRanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MetricsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetricsTable,
          Metric,
          $$MetricsTableFilterComposer,
          $$MetricsTableOrderingComposer,
          $$MetricsTableAnnotationComposer,
          $$MetricsTableCreateCompanionBuilder,
          $$MetricsTableUpdateCompanionBuilder,
          (Metric, $$MetricsTableReferences),
          Metric,
          PrefetchHooks Function({bool targetRangesRefs})
        > {
  $$MetricsTableTableManager(_$AppDatabase db, $MetricsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetricsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetricsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetricsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> nameKey = const Value.absent(),
                Value<String> unitOptions = const Value.absent(),
                Value<String> tagOptions = const Value.absent(),
                Value<String> conditionKey = const Value.absent(),
                Value<String> readingKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetricsCompanion(
                key: key,
                nameKey: nameKey,
                unitOptions: unitOptions,
                tagOptions: tagOptions,
                conditionKey: conditionKey,
                readingKey: readingKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String nameKey,
                required String unitOptions,
                required String tagOptions,
                required String conditionKey,
                required String readingKey,
                Value<int> rowid = const Value.absent(),
              }) => MetricsCompanion.insert(
                key: key,
                nameKey: nameKey,
                unitOptions: unitOptions,
                tagOptions: tagOptions,
                conditionKey: conditionKey,
                readingKey: readingKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MetricsTable, Metric>(table),
                  $$MetricsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({targetRangesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (targetRangesRefs) db.targetRanges],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (targetRangesRefs)
                    await $_getPrefetchedData<
                      Metric,
                      $MetricsTable,
                      TargetRange
                    >(
                      currentTable: table,
                      referencedTable: $$MetricsTableReferences
                          ._targetRangesRefsTable(db),
                      managerFromTypedResult: (p0) => $$MetricsTableReferences(
                        db,
                        table,
                        p0,
                      ).targetRangesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.metricKey == item.key),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MetricsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetricsTable,
      Metric,
      $$MetricsTableFilterComposer,
      $$MetricsTableOrderingComposer,
      $$MetricsTableAnnotationComposer,
      $$MetricsTableCreateCompanionBuilder,
      $$MetricsTableUpdateCompanionBuilder,
      (Metric, $$MetricsTableReferences),
      Metric,
      PrefetchHooks Function({bool targetRangesRefs})
    >;
typedef $$TargetRangesTableCreateCompanionBuilder =
    TargetRangesCompanion Function({
      Value<int> id,
      required int patientId,
      required String metricKey,
      Value<String?> tagContext,
      Value<String?> unit,
      Value<double?> urgentLow,
      Value<double?> cautionLow,
      Value<double?> cautionHigh,
      Value<double?> urgentHigh,
      Value<String?> doctorPlanText,
      Value<String?> warningSignsText,
    });
typedef $$TargetRangesTableUpdateCompanionBuilder =
    TargetRangesCompanion Function({
      Value<int> id,
      Value<int> patientId,
      Value<String> metricKey,
      Value<String?> tagContext,
      Value<String?> unit,
      Value<double?> urgentLow,
      Value<double?> cautionLow,
      Value<double?> cautionHigh,
      Value<double?> urgentHigh,
      Value<String?> doctorPlanText,
      Value<String?> warningSignsText,
    });

final class $$TargetRangesTableReferences
    extends BaseReferences<_$AppDatabase, $TargetRangesTable, TargetRange> {
  $$TargetRangesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias('target_ranges__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MetricsTable _metricKeyTable(_$AppDatabase db) =>
      db.metrics.createAlias('target_ranges__metric_key__metrics__key');

  $$MetricsTableProcessedTableManager get metricKey {
    final $_column = $_itemColumn<String>('metric_key')!;

    final manager = $$MetricsTableTableManager(
      $_db,
      $_db.metrics,
    ).filter((f) => f.key.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_metricKeyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TargetRangesTableFilterComposer
    extends Composer<_$AppDatabase, $TargetRangesTable> {
  $$TargetRangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagContext => $composableBuilder(
    column: $table.tagContext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get urgentLow => $composableBuilder(
    column: $table.urgentLow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cautionLow => $composableBuilder(
    column: $table.cautionLow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cautionHigh => $composableBuilder(
    column: $table.cautionHigh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get urgentHigh => $composableBuilder(
    column: $table.urgentHigh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorPlanText => $composableBuilder(
    column: $table.doctorPlanText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get warningSignsText => $composableBuilder(
    column: $table.warningSignsText,
    builder: (column) => ColumnFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MetricsTableFilterComposer get metricKey {
    final $$MetricsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.metricKey,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricsTableFilterComposer(
            $db: $db,
            $table: $db.metrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TargetRangesTableOrderingComposer
    extends Composer<_$AppDatabase, $TargetRangesTable> {
  $$TargetRangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagContext => $composableBuilder(
    column: $table.tagContext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get urgentLow => $composableBuilder(
    column: $table.urgentLow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cautionLow => $composableBuilder(
    column: $table.cautionLow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cautionHigh => $composableBuilder(
    column: $table.cautionHigh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get urgentHigh => $composableBuilder(
    column: $table.urgentHigh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorPlanText => $composableBuilder(
    column: $table.doctorPlanText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get warningSignsText => $composableBuilder(
    column: $table.warningSignsText,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MetricsTableOrderingComposer get metricKey {
    final $$MetricsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.metricKey,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricsTableOrderingComposer(
            $db: $db,
            $table: $db.metrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TargetRangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TargetRangesTable> {
  $$TargetRangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tagContext => $composableBuilder(
    column: $table.tagContext,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get urgentLow =>
      $composableBuilder(column: $table.urgentLow, builder: (column) => column);

  GeneratedColumn<double> get cautionLow => $composableBuilder(
    column: $table.cautionLow,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cautionHigh => $composableBuilder(
    column: $table.cautionHigh,
    builder: (column) => column,
  );

  GeneratedColumn<double> get urgentHigh => $composableBuilder(
    column: $table.urgentHigh,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorPlanText => $composableBuilder(
    column: $table.doctorPlanText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get warningSignsText => $composableBuilder(
    column: $table.warningSignsText,
    builder: (column) => column,
  );

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MetricsTableAnnotationComposer get metricKey {
    final $$MetricsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.metricKey,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricsTableAnnotationComposer(
            $db: $db,
            $table: $db.metrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TargetRangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TargetRangesTable,
          TargetRange,
          $$TargetRangesTableFilterComposer,
          $$TargetRangesTableOrderingComposer,
          $$TargetRangesTableAnnotationComposer,
          $$TargetRangesTableCreateCompanionBuilder,
          $$TargetRangesTableUpdateCompanionBuilder,
          (TargetRange, $$TargetRangesTableReferences),
          TargetRange,
          PrefetchHooks Function({bool patientId, bool metricKey})
        > {
  $$TargetRangesTableTableManager(_$AppDatabase db, $TargetRangesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TargetRangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TargetRangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TargetRangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> patientId = const Value.absent(),
                Value<String> metricKey = const Value.absent(),
                Value<String?> tagContext = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<double?> urgentLow = const Value.absent(),
                Value<double?> cautionLow = const Value.absent(),
                Value<double?> cautionHigh = const Value.absent(),
                Value<double?> urgentHigh = const Value.absent(),
                Value<String?> doctorPlanText = const Value.absent(),
                Value<String?> warningSignsText = const Value.absent(),
              }) => TargetRangesCompanion(
                id: id,
                patientId: patientId,
                metricKey: metricKey,
                tagContext: tagContext,
                unit: unit,
                urgentLow: urgentLow,
                cautionLow: cautionLow,
                cautionHigh: cautionHigh,
                urgentHigh: urgentHigh,
                doctorPlanText: doctorPlanText,
                warningSignsText: warningSignsText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int patientId,
                required String metricKey,
                Value<String?> tagContext = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<double?> urgentLow = const Value.absent(),
                Value<double?> cautionLow = const Value.absent(),
                Value<double?> cautionHigh = const Value.absent(),
                Value<double?> urgentHigh = const Value.absent(),
                Value<String?> doctorPlanText = const Value.absent(),
                Value<String?> warningSignsText = const Value.absent(),
              }) => TargetRangesCompanion.insert(
                id: id,
                patientId: patientId,
                metricKey: metricKey,
                tagContext: tagContext,
                unit: unit,
                urgentLow: urgentLow,
                cautionLow: cautionLow,
                cautionHigh: cautionHigh,
                urgentHigh: urgentHigh,
                doctorPlanText: doctorPlanText,
                warningSignsText: warningSignsText,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TargetRangesTable, TargetRange>(table),
                  $$TargetRangesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patientId = false, metricKey = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (patientId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.patientId,
                        referencedTable: $$TargetRangesTableReferences
                            ._patientIdTable(db),
                        referencedColumn: $$TargetRangesTableReferences
                            ._patientIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (metricKey) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.metricKey,
                        referencedTable: $$TargetRangesTableReferences
                            ._metricKeyTable(db),
                        referencedColumn: $$TargetRangesTableReferences
                            ._metricKeyTable(db)
                            .key,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TargetRangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TargetRangesTable,
      TargetRange,
      $$TargetRangesTableFilterComposer,
      $$TargetRangesTableOrderingComposer,
      $$TargetRangesTableAnnotationComposer,
      $$TargetRangesTableCreateCompanionBuilder,
      $$TargetRangesTableUpdateCompanionBuilder,
      (TargetRange, $$TargetRangesTableReferences),
      TargetRange,
      PrefetchHooks Function({bool patientId, bool metricKey})
    >;
typedef $$ReadingsTableCreateCompanionBuilder = ReadingsCompanion Function({
  Value<int> id,
  required int patientId,
  required String metricKey,
  Value<double?> value,
  Value<int?> systolic,
  Value<int?> diastolic,
  Value<int?> pulse,
  required String unit,
  Value<String?> tag,
  required DateTime measuredAt,
  Value<String?> note,
});
typedef $$ReadingsTableUpdateCompanionBuilder = ReadingsCompanion Function({
  Value<int> id,
  Value<int> patientId,
  Value<String> metricKey,
  Value<double?> value,
  Value<int?> systolic,
  Value<int?> diastolic,
  Value<int?> pulse,
  Value<String> unit,
  Value<String?> tag,
  Value<DateTime> measuredAt,
  Value<String?> note,
});

final class $$ReadingsTableReferences
    extends BaseReferences<_$AppDatabase, $ReadingsTable, Reading> {
  $$ReadingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias('readings__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metricKey => $composableBuilder(
    column: $table.metricKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pulse => $composableBuilder(
    column: $table.pulse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metricKey => $composableBuilder(
    column: $table.metricKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pulse => $composableBuilder(
    column: $table.pulse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get metricKey =>
      $composableBuilder(column: $table.metricKey, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get systolic =>
      $composableBuilder(column: $table.systolic, builder: (column) => column);

  GeneratedColumn<int> get diastolic =>
      $composableBuilder(column: $table.diastolic, builder: (column) => column);

  GeneratedColumn<int> get pulse =>
      $composableBuilder(column: $table.pulse, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  GeneratedColumn<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingsTable,
          Reading,
          $$ReadingsTableFilterComposer,
          $$ReadingsTableOrderingComposer,
          $$ReadingsTableAnnotationComposer,
          $$ReadingsTableCreateCompanionBuilder,
          $$ReadingsTableUpdateCompanionBuilder,
          (Reading, $$ReadingsTableReferences),
          Reading,
          PrefetchHooks Function({bool patientId})
        > {
  $$ReadingsTableTableManager(_$AppDatabase db, $ReadingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> patientId = const Value.absent(),
                Value<String> metricKey = const Value.absent(),
                Value<double?> value = const Value.absent(),
                Value<int?> systolic = const Value.absent(),
                Value<int?> diastolic = const Value.absent(),
                Value<int?> pulse = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String?> tag = const Value.absent(),
                Value<DateTime> measuredAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => ReadingsCompanion(
                id: id,
                patientId: patientId,
                metricKey: metricKey,
                value: value,
                systolic: systolic,
                diastolic: diastolic,
                pulse: pulse,
                unit: unit,
                tag: tag,
                measuredAt: measuredAt,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int patientId,
                required String metricKey,
                Value<double?> value = const Value.absent(),
                Value<int?> systolic = const Value.absent(),
                Value<int?> diastolic = const Value.absent(),
                Value<int?> pulse = const Value.absent(),
                required String unit,
                Value<String?> tag = const Value.absent(),
                required DateTime measuredAt,
                Value<String?> note = const Value.absent(),
              }) => ReadingsCompanion.insert(
                id: id,
                patientId: patientId,
                metricKey: metricKey,
                value: value,
                systolic: systolic,
                diastolic: diastolic,
                pulse: pulse,
                unit: unit,
                tag: tag,
                measuredAt: measuredAt,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReadingsTable, Reading>(table),
                  $$ReadingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (patientId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.patientId,
                        referencedTable: $$ReadingsTableReferences
                            ._patientIdTable(db),
                        referencedColumn: $$ReadingsTableReferences
                            ._patientIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingsTable,
      Reading,
      $$ReadingsTableFilterComposer,
      $$ReadingsTableOrderingComposer,
      $$ReadingsTableAnnotationComposer,
      $$ReadingsTableCreateCompanionBuilder,
      $$ReadingsTableUpdateCompanionBuilder,
      (Reading, $$ReadingsTableReferences),
      Reading,
      PrefetchHooks Function({bool patientId})
    >;
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      Value<int> id,
      required int patientId,
      required String name,
      Value<String?> notes,
      Value<bool> active,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<int> id,
      Value<int> patientId,
      Value<String> name,
      Value<String?> notes,
      Value<bool> active,
    });

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, Medication> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias('medications__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MedicationSlotsTable, List<MedicationSlot>>
  _medicationSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicationSlots,
    aliasName: 'medications__id__medication_slots__medication_id',
  );

  $$MedicationSlotsTableProcessedTableManager get medicationSlotsRefs {
    final manager = $$MedicationSlotsTableTableManager(
      $_db,
      $_db.medicationSlots,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _medicationSlotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DoseLogsTable, List<DoseLog>> _doseLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.doseLogs,
    aliasName: 'medications__id__dose_logs__medication_id',
  );

  $$DoseLogsTableProcessedTableManager get doseLogsRefs {
    final manager = $$DoseLogsTableTableManager(
      $_db,
      $_db.doseLogs,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_doseLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> medicationSlotsRefs(
    Expression<bool> Function($$MedicationSlotsTableFilterComposer f) f,
  ) {
    final $$MedicationSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationSlots,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationSlotsTableFilterComposer(
            $db: $db,
            $table: $db.medicationSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> doseLogsRefs(
    Expression<bool> Function($$DoseLogsTableFilterComposer f) f,
  ) {
    final $$DoseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLogs,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoseLogsTableFilterComposer(
            $db: $db,
            $table: $db.doseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> medicationSlotsRefs<T extends Object>(
    Expression<T> Function($$MedicationSlotsTableAnnotationComposer a) f,
  ) {
    final $$MedicationSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationSlots,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> doseLogsRefs<T extends Object>(
    Expression<T> Function($$DoseLogsTableAnnotationComposer a) f,
  ) {
    final $$DoseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLogs,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.doseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          Medication,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (Medication, $$MedicationsTableReferences),
          Medication,
          PrefetchHooks Function({
            bool patientId,
            bool medicationSlotsRefs,
            bool doseLogsRefs,
          })
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> patientId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                patientId: patientId,
                name: name,
                notes: notes,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int patientId,
                required String name,
                Value<String?> notes = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                patientId: patientId,
                name: name,
                notes: notes,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationsTable, Medication>(table),
                  $$MedicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                patientId = false,
                medicationSlotsRefs = false,
                doseLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (medicationSlotsRefs) db.medicationSlots,
                    if (doseLogsRefs) db.doseLogs,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (patientId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.patientId,
                            referencedTable: $$MedicationsTableReferences
                                ._patientIdTable(db),
                            referencedColumn: $$MedicationsTableReferences
                                ._patientIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (medicationSlotsRefs)
                        await $_getPrefetchedData<
                          Medication,
                          $MedicationsTable,
                          MedicationSlot
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationsTableReferences
                              ._medicationSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).medicationSlotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (doseLogsRefs)
                        await $_getPrefetchedData<
                          Medication,
                          $MedicationsTable,
                          DoseLog
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationsTableReferences
                              ._doseLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).doseLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      Medication,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (Medication, $$MedicationsTableReferences),
      Medication,
      PrefetchHooks Function({
        bool patientId,
        bool medicationSlotsRefs,
        bool doseLogsRefs,
      })
    >;
typedef $$MedicationSlotsTableCreateCompanionBuilder =
    MedicationSlotsCompanion Function({
      required int medicationId,
      required DoseSlot slot,
      Value<String?> startedOn,
      Value<String?> endedOn,
      Value<int> rowid,
    });
typedef $$MedicationSlotsTableUpdateCompanionBuilder =
    MedicationSlotsCompanion Function({
      Value<int> medicationId,
      Value<DoseSlot> slot,
      Value<String?> startedOn,
      Value<String?> endedOn,
      Value<int> rowid,
    });

final class $$MedicationSlotsTableReferences
    extends
        BaseReferences<_$AppDatabase, $MedicationSlotsTable, MedicationSlot> {
  $$MedicationSlotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) => db
      .medications
      .createAlias('medication_slots__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<int>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationSlotsTable> {
  $$MedicationSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<DoseSlot, DoseSlot, String> get slot =>
      $composableBuilder(
        column: $table.slot,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get startedOn => $composableBuilder(
    column: $table.startedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endedOn => $composableBuilder(
    column: $table.endedOn,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationSlotsTable> {
  $$MedicationSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startedOn => $composableBuilder(
    column: $table.startedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endedOn => $composableBuilder(
    column: $table.endedOn,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationSlotsTable> {
  $$MedicationSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<DoseSlot, String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<String> get startedOn =>
      $composableBuilder(column: $table.startedOn, builder: (column) => column);

  GeneratedColumn<String> get endedOn =>
      $composableBuilder(column: $table.endedOn, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationSlotsTable,
          MedicationSlot,
          $$MedicationSlotsTableFilterComposer,
          $$MedicationSlotsTableOrderingComposer,
          $$MedicationSlotsTableAnnotationComposer,
          $$MedicationSlotsTableCreateCompanionBuilder,
          $$MedicationSlotsTableUpdateCompanionBuilder,
          (MedicationSlot, $$MedicationSlotsTableReferences),
          MedicationSlot,
          PrefetchHooks Function({bool medicationId})
        > {
  $$MedicationSlotsTableTableManager(
    _$AppDatabase db,
    $MedicationSlotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> medicationId = const Value.absent(),
                Value<DoseSlot> slot = const Value.absent(),
                Value<String?> startedOn = const Value.absent(),
                Value<String?> endedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationSlotsCompanion(
                medicationId: medicationId,
                slot: slot,
                startedOn: startedOn,
                endedOn: endedOn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int medicationId,
                required DoseSlot slot,
                Value<String?> startedOn = const Value.absent(),
                Value<String?> endedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationSlotsCompanion.insert(
                medicationId: medicationId,
                slot: slot,
                startedOn: startedOn,
                endedOn: endedOn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationSlotsTable, MedicationSlot>(table),
                  $$MedicationSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (medicationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicationId,
                        referencedTable: $$MedicationSlotsTableReferences
                            ._medicationIdTable(db),
                        referencedColumn: $$MedicationSlotsTableReferences
                            ._medicationIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicationSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationSlotsTable,
      MedicationSlot,
      $$MedicationSlotsTableFilterComposer,
      $$MedicationSlotsTableOrderingComposer,
      $$MedicationSlotsTableAnnotationComposer,
      $$MedicationSlotsTableCreateCompanionBuilder,
      $$MedicationSlotsTableUpdateCompanionBuilder,
      (MedicationSlot, $$MedicationSlotsTableReferences),
      MedicationSlot,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$DoseLogsTableCreateCompanionBuilder = DoseLogsCompanion Function({
  Value<int> id,
  required int medicationId,
  required DoseSlot slot,
  required String date,
  Value<bool> taken,
  Value<DateTime?> takenAt,
  Value<String?> givenBy,
});
typedef $$DoseLogsTableUpdateCompanionBuilder = DoseLogsCompanion Function({
  Value<int> id,
  Value<int> medicationId,
  Value<DoseSlot> slot,
  Value<String> date,
  Value<bool> taken,
  Value<DateTime?> takenAt,
  Value<String?> givenBy,
});

final class $$DoseLogsTableReferences
    extends BaseReferences<_$AppDatabase, $DoseLogsTable, DoseLog> {
  $$DoseLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias('dose_logs__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<int>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DoseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DoseSlot, DoseSlot, String> get slot =>
      $composableBuilder(
        column: $table.slot,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get taken => $composableBuilder(
    column: $table.taken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get givenBy => $composableBuilder(
    column: $table.givenBy,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get taken => $composableBuilder(
    column: $table.taken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get givenBy => $composableBuilder(
    column: $table.givenBy,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DoseSlot, String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get taken =>
      $composableBuilder(column: $table.taken, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get givenBy =>
      $composableBuilder(column: $table.givenBy, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoseLogsTable,
          DoseLog,
          $$DoseLogsTableFilterComposer,
          $$DoseLogsTableOrderingComposer,
          $$DoseLogsTableAnnotationComposer,
          $$DoseLogsTableCreateCompanionBuilder,
          $$DoseLogsTableUpdateCompanionBuilder,
          (DoseLog, $$DoseLogsTableReferences),
          DoseLog,
          PrefetchHooks Function({bool medicationId})
        > {
  $$DoseLogsTableTableManager(_$AppDatabase db, $DoseLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> medicationId = const Value.absent(),
                Value<DoseSlot> slot = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<bool> taken = const Value.absent(),
                Value<DateTime?> takenAt = const Value.absent(),
                Value<String?> givenBy = const Value.absent(),
              }) => DoseLogsCompanion(
                id: id,
                medicationId: medicationId,
                slot: slot,
                date: date,
                taken: taken,
                takenAt: takenAt,
                givenBy: givenBy,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medicationId,
                required DoseSlot slot,
                required String date,
                Value<bool> taken = const Value.absent(),
                Value<DateTime?> takenAt = const Value.absent(),
                Value<String?> givenBy = const Value.absent(),
              }) => DoseLogsCompanion.insert(
                id: id,
                medicationId: medicationId,
                slot: slot,
                date: date,
                taken: taken,
                takenAt: takenAt,
                givenBy: givenBy,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DoseLogsTable, DoseLog>(table),
                  $$DoseLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (medicationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicationId,
                        referencedTable: $$DoseLogsTableReferences
                            ._medicationIdTable(db),
                        referencedColumn: $$DoseLogsTableReferences
                            ._medicationIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DoseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoseLogsTable,
      DoseLog,
      $$DoseLogsTableFilterComposer,
      $$DoseLogsTableOrderingComposer,
      $$DoseLogsTableAnnotationComposer,
      $$DoseLogsTableCreateCompanionBuilder,
      $$DoseLogsTableUpdateCompanionBuilder,
      (DoseLog, $$DoseLogsTableReferences),
      DoseLog,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  required ReminderType type,
  required int hour,
  required int minute,
  Value<String> repeatRule,
  Value<bool> enabled,
  Value<String?> label,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<ReminderType> type,
  Value<int> hour,
  Value<int> minute,
  Value<String> repeatRule,
  Value<bool> enabled,
  Value<String?> label,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReminderType, ReminderType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReminderType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ReminderType> type = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<String> repeatRule = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String?> label = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                type: type,
                hour: hour,
                minute: minute,
                repeatRule: repeatRule,
                enabled: enabled,
                label: label,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required ReminderType type,
                required int hour,
                required int minute,
                Value<String> repeatRule = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String?> label = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                type: type,
                hour: hour,
                minute: minute,
                repeatRule: repeatRule,
                enabled: enabled,
                label: label,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, Reminder>(table),
                  BaseReferences<_$AppDatabase, $RemindersTable, Reminder>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;
typedef $$FoodItemsTableCreateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  required String nameEn,
  required String nameNe,
  required String category,
  Value<String> tags,
  Value<String?> notes,
});
typedef $$FoodItemsTableUpdateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  Value<String> nameEn,
  Value<String> nameNe,
  Value<String> category,
  Value<String> tags,
  Value<String?> notes,
});

class $$FoodItemsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameNe => $composableBuilder(
    column: $table.nameNe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameNe => $composableBuilder(
    column: $table.nameNe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameNe =>
      $composableBuilder(column: $table.nameNe, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$FoodItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodItemsTable,
          FoodItem,
          $$FoodItemsTableFilterComposer,
          $$FoodItemsTableOrderingComposer,
          $$FoodItemsTableAnnotationComposer,
          $$FoodItemsTableCreateCompanionBuilder,
          $$FoodItemsTableUpdateCompanionBuilder,
          (FoodItem, BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItem>),
          FoodItem,
          PrefetchHooks Function()
        > {
  $$FoodItemsTableTableManager(_$AppDatabase db, $FoodItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> nameNe = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => FoodItemsCompanion(
                id: id,
                nameEn: nameEn,
                nameNe: nameNe,
                category: category,
                tags: tags,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameEn,
                required String nameNe,
                required String category,
                Value<String> tags = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => FoodItemsCompanion.insert(
                id: id,
                nameEn: nameEn,
                nameNe: nameNe,
                category: category,
                tags: tags,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoodItemsTable, FoodItem>(table),
                  BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodItemsTable,
      FoodItem,
      $$FoodItemsTableFilterComposer,
      $$FoodItemsTableOrderingComposer,
      $$FoodItemsTableAnnotationComposer,
      $$FoodItemsTableCreateCompanionBuilder,
      $$FoodItemsTableUpdateCompanionBuilder,
      (FoodItem, BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItem>),
      FoodItem,
      PrefetchHooks Function()
    >;
typedef $$EmergencyContactsTableCreateCompanionBuilder =
    EmergencyContactsCompanion Function({
      Value<int> id,
      required String name,
      required ContactRole role,
      required String phone,
    });
typedef $$EmergencyContactsTableUpdateCompanionBuilder =
    EmergencyContactsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<ContactRole> role,
      Value<String> phone,
    });

class $$EmergencyContactsTableFilterComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ContactRole, ContactRole, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmergencyContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmergencyContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ContactRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);
}

class $$EmergencyContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmergencyContactsTable,
          EmergencyContact,
          $$EmergencyContactsTableFilterComposer,
          $$EmergencyContactsTableOrderingComposer,
          $$EmergencyContactsTableAnnotationComposer,
          $$EmergencyContactsTableCreateCompanionBuilder,
          $$EmergencyContactsTableUpdateCompanionBuilder,
          (
            EmergencyContact,
            BaseReferences<
              _$AppDatabase,
              $EmergencyContactsTable,
              EmergencyContact
            >,
          ),
          EmergencyContact,
          PrefetchHooks Function()
        > {
  $$EmergencyContactsTableTableManager(
    _$AppDatabase db,
    $EmergencyContactsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmergencyContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmergencyContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmergencyContactsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<ContactRole> role = const Value.absent(),
                Value<String> phone = const Value.absent(),
              }) => EmergencyContactsCompanion(
                id: id,
                name: name,
                role: role,
                phone: phone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required ContactRole role,
                required String phone,
              }) => EmergencyContactsCompanion.insert(
                id: id,
                name: name,
                role: role,
                phone: phone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmergencyContactsTable, EmergencyContact>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EmergencyContactsTable,
                    EmergencyContact
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmergencyContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmergencyContactsTable,
      EmergencyContact,
      $$EmergencyContactsTableFilterComposer,
      $$EmergencyContactsTableOrderingComposer,
      $$EmergencyContactsTableAnnotationComposer,
      $$EmergencyContactsTableCreateCompanionBuilder,
      $$EmergencyContactsTableUpdateCompanionBuilder,
      (
        EmergencyContact,
        BaseReferences<
          _$AppDatabase,
          $EmergencyContactsTable,
          EmergencyContact
        >,
      ),
      EmergencyContact,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<AppLanguage> language,
      Value<DateStyle> dateStyle,
      Value<GlucoseUnit> glucoseUnit,
      Value<DigitStyle> digitStyle,
      Value<String?> fastingOnDate,
      Value<String?> lastSugarTag,
      Value<String?> lastBpTag,
      Value<bool> disclaimerAccepted,
      Value<bool> remindersSeeded,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<AppLanguage> language,
      Value<DateStyle> dateStyle,
      Value<GlucoseUnit> glucoseUnit,
      Value<DigitStyle> digitStyle,
      Value<String?> fastingOnDate,
      Value<String?> lastSugarTag,
      Value<String?> lastBpTag,
      Value<bool> disclaimerAccepted,
      Value<bool> remindersSeeded,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppLanguage, AppLanguage, String>
  get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DateStyle, DateStyle, String> get dateStyle =>
      $composableBuilder(
        column: $table.dateStyle,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<GlucoseUnit, GlucoseUnit, String>
  get glucoseUnit => $composableBuilder(
    column: $table.glucoseUnit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DigitStyle, DigitStyle, String>
  get digitStyle => $composableBuilder(
    column: $table.digitStyle,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get fastingOnDate => $composableBuilder(
    column: $table.fastingOnDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSugarTag => $composableBuilder(
    column: $table.lastSugarTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastBpTag => $composableBuilder(
    column: $table.lastBpTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get disclaimerAccepted => $composableBuilder(
    column: $table.disclaimerAccepted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindersSeeded => $composableBuilder(
    column: $table.remindersSeeded,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateStyle => $composableBuilder(
    column: $table.dateStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glucoseUnit => $composableBuilder(
    column: $table.glucoseUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get digitStyle => $composableBuilder(
    column: $table.digitStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fastingOnDate => $composableBuilder(
    column: $table.fastingOnDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSugarTag => $composableBuilder(
    column: $table.lastSugarTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastBpTag => $composableBuilder(
    column: $table.lastBpTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get disclaimerAccepted => $composableBuilder(
    column: $table.disclaimerAccepted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindersSeeded => $composableBuilder(
    column: $table.remindersSeeded,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppLanguage, String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateStyle, String> get dateStyle =>
      $composableBuilder(column: $table.dateStyle, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GlucoseUnit, String> get glucoseUnit =>
      $composableBuilder(
        column: $table.glucoseUnit,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DigitStyle, String> get digitStyle =>
      $composableBuilder(
        column: $table.digitStyle,
        builder: (column) => column,
      );

  GeneratedColumn<String> get fastingOnDate => $composableBuilder(
    column: $table.fastingOnDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSugarTag => $composableBuilder(
    column: $table.lastSugarTag,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastBpTag =>
      $composableBuilder(column: $table.lastBpTag, builder: (column) => column);

  GeneratedColumn<bool> get disclaimerAccepted => $composableBuilder(
    column: $table.disclaimerAccepted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remindersSeeded => $composableBuilder(
    column: $table.remindersSeeded,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsRow,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsRow
            >,
          ),
          AppSettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AppLanguage> language = const Value.absent(),
                Value<DateStyle> dateStyle = const Value.absent(),
                Value<GlucoseUnit> glucoseUnit = const Value.absent(),
                Value<DigitStyle> digitStyle = const Value.absent(),
                Value<String?> fastingOnDate = const Value.absent(),
                Value<String?> lastSugarTag = const Value.absent(),
                Value<String?> lastBpTag = const Value.absent(),
                Value<bool> disclaimerAccepted = const Value.absent(),
                Value<bool> remindersSeeded = const Value.absent(),
              }) => AppSettingsTableCompanion(
                id: id,
                language: language,
                dateStyle: dateStyle,
                glucoseUnit: glucoseUnit,
                digitStyle: digitStyle,
                fastingOnDate: fastingOnDate,
                lastSugarTag: lastSugarTag,
                lastBpTag: lastBpTag,
                disclaimerAccepted: disclaimerAccepted,
                remindersSeeded: remindersSeeded,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AppLanguage> language = const Value.absent(),
                Value<DateStyle> dateStyle = const Value.absent(),
                Value<GlucoseUnit> glucoseUnit = const Value.absent(),
                Value<DigitStyle> digitStyle = const Value.absent(),
                Value<String?> fastingOnDate = const Value.absent(),
                Value<String?> lastSugarTag = const Value.absent(),
                Value<String?> lastBpTag = const Value.absent(),
                Value<bool> disclaimerAccepted = const Value.absent(),
                Value<bool> remindersSeeded = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                id: id,
                language: language,
                dateStyle: dateStyle,
                glucoseUnit: glucoseUnit,
                digitStyle: digitStyle,
                fastingOnDate: fastingOnDate,
                lastSugarTag: lastSugarTag,
                lastBpTag: lastBpTag,
                disclaimerAccepted: disclaimerAccepted,
                remindersSeeded: remindersSeeded,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTableTable, AppSettingsRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTableTable,
                    AppSettingsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsRow,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsTableTable, AppSettingsRow>,
      ),
      AppSettingsRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$ConditionsTableTableManager get conditions =>
      $$ConditionsTableTableManager(_db, _db.conditions);
  $$MetricsTableTableManager get metrics =>
      $$MetricsTableTableManager(_db, _db.metrics);
  $$TargetRangesTableTableManager get targetRanges =>
      $$TargetRangesTableTableManager(_db, _db.targetRanges);
  $$ReadingsTableTableManager get readings =>
      $$ReadingsTableTableManager(_db, _db.readings);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedicationSlotsTableTableManager get medicationSlots =>
      $$MedicationSlotsTableTableManager(_db, _db.medicationSlots);
  $$DoseLogsTableTableManager get doseLogs =>
      $$DoseLogsTableTableManager(_db, _db.doseLogs);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$FoodItemsTableTableManager get foodItems =>
      $$FoodItemsTableTableManager(_db, _db.foodItems);
  $$EmergencyContactsTableTableManager get emergencyContacts =>
      $$EmergencyContactsTableTableManager(_db, _db.emergencyContacts);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
}
