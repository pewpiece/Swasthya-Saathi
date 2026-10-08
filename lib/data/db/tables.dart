import 'package:drift/drift.dart';

import '../enums.dart';

/// The one person being cared for (single patient in the MVP).
@DataClassName('Patient')
class Patients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get birthYear => integer().nullable()();
  TextColumn get notes => text().nullable()();

  /// Free text allergies / food restrictions entered by the family.
  TextColumn get allergies => text().nullable()();

  /// "Soft food" profile flag (chewing difficulty).
  BoolColumn get softFood => boolean().withDefault(const Constant(false))();
}

/// Which conditions are switched on for the patient.
@DataClassName('PatientCondition')
class Conditions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Patients, #id)();
  TextColumn get conditionKey => text()(); // diabetes | hypertension | ...
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {patientId, conditionKey},
      ];
}

/// Catalogue of things we can measure. This is DATA: a new condition adds
/// rows here (see README, "Adding a condition"), not code.
///
/// A metric is a *range metric*: the thing a TargetRange is attached to.
/// `readingKey` is the kind of Reading it belongs to. Blood pressure is one
/// reading with two range metrics (systolic, diastolic) plus pulse.
@DataClassName('Metric')
class Metrics extends Table {
  TextColumn get key => text()();
  TextColumn get nameKey => text()(); // l10n key, see l10nByKey
  TextColumn get unitOptions => text()(); // comma separated, first = default
  TextColumn get tagOptions => text()(); // comma separated l10n tag keys
  TextColumn get conditionKey => text()();
  TextColumn get readingKey => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// The doctor's ranges. Every threshold is nullable: nothing is built in.
/// A row with no thresholds means "not entered yet" -> no range guidance.
@DataClassName('TargetRange')
class TargetRanges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Patients, #id)();
  TextColumn get metricKey => text().references(Metrics, #key)();

  /// null = applies to every context; else a tag key (fasting, bedtime...).
  TextColumn get tagContext => text().nullable()();

  /// Unit the thresholds were entered in (needed for mg/dL <-> mmol/L).
  TextColumn get unit => text().nullable()();
  RealColumn get urgentLow => real().nullable()();
  RealColumn get cautionLow => real().nullable()();
  RealColumn get cautionHigh => real().nullable()();
  RealColumn get urgentHigh => real().nullable()();
  TextColumn get doctorPlanText => text().nullable()();
  TextColumn get warningSignsText => text().nullable()();
}

@DataClassName('Reading')
class Readings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Patients, #id)();
  TextColumn get metricKey => text()(); // reading kind: blood_sugar | blood_pressure
  RealColumn get value => real().nullable()(); // blood sugar
  IntColumn get systolic => integer().nullable()();
  IntColumn get diastolic => integer().nullable()();
  IntColumn get pulse => integer().nullable()();
  TextColumn get unit => text()();
  TextColumn get tag => text().nullable()();
  DateTimeColumn get measuredAt => dateTime()(); // AD
  TextColumn get note => text().nullable()();
}

@DataClassName('Medication')
class Medications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Patients, #id)();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get notes => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

@DataClassName('MedicationSlot')
class MedicationSlots extends Table {
  IntColumn get medicationId => integer().references(Medications, #id)();
  TextColumn get slot => textEnum<DoseSlot>()();

  /// First day this slot counted (`yyyy-MM-dd`, AD). Adherence only expects a
  /// dose from this day on, so adding "night" to an old medicine does not turn
  /// every past night into a miss. Null = counted from the beginning.
  TextColumn get startedOn => text().nullable()();

  /// Day after the last day this slot counted (exclusive). Null = still in use.
  /// Removing a slot or medicine only sets this; history is never deleted.
  TextColumn get endedOn => text().nullable()();

  @override
  Set<Column> get primaryKey => {medicationId, slot};
}

/// One row per medicine + slot + calendar day. A new day simply has no row
/// yet (= not taken). Rows are never deleted or edited for past days.
@DataClassName('DoseLog')
class DoseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicationId => integer().references(Medications, #id)();
  TextColumn get slot => textEnum<DoseSlot>()();

  /// AD calendar day as `yyyy-MM-dd` (see dateKey).
  TextColumn get date => text()();
  BoolColumn get taken => boolean().withDefault(const Constant(false))();
  DateTimeColumn get takenAt => dateTime().nullable()();
  TextColumn get givenBy => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {medicationId, slot, date},
      ];
}

@DataClassName('Reminder')
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<ReminderType>()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();

  /// `daily`, `weekly:<1-7>` (Mon=1) or `monthly:<1-28>`.
  TextColumn get repeatRule => text().withDefault(const Constant('daily'))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get label => text().nullable()();
}

@DataClassName('FoodItem')
class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameEn => text()();
  TextColumn get nameNe => text()();
  TextColumn get category => text()();
  TextColumn get tags => text().withDefault(const Constant(''))(); // csv
  TextColumn get notes => text().nullable()();
}

/// Entered by the family. Never pre-filled with phone numbers.
@DataClassName('EmergencyContact')
class EmergencyContacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get role => textEnum<ContactRole>()();
  TextColumn get phone => text()();
}

/// Single row (id = 1).
@DataClassName('AppSettingsRow')
class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get language =>
      textEnum<AppLanguage>().withDefault(const Constant('en'))();
  TextColumn get dateStyle =>
      textEnum<DateStyle>().withDefault(const Constant('ad'))();
  TextColumn get glucoseUnit =>
      textEnum<GlucoseUnit>().withDefault(const Constant('mgDl'))();
  TextColumn get digitStyle =>
      textEnum<DigitStyle>().withDefault(const Constant('latin'))();

  /// "Fasting today (upabas)": holds the AD day it was switched on, so it
  /// switches itself off the next day. Use `fastingToday(now)` to read it.
  TextColumn get fastingOnDate => text().nullable()();

  /// Remembered last-used choices, so logging needs fewer taps.
  TextColumn get lastSugarTag => text().nullable()();
  TextColumn get lastBpTag => text().nullable()();

  BoolColumn get disclaimerAccepted =>
      boolean().withDefault(const Constant(false))();

  /// The default reminders are created once, so deleting them stays deleted.
  BoolColumn get remindersSeeded =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
