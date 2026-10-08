import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../core/dates/date_only.dart';
import '../enums.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// Metrics shipped with the app. Pure catalogue data: no medical thresholds.
const _seedMetrics = <MetricsCompanion>[
  MetricsCompanion(
    key: Value('blood_sugar'),
    nameKey: Value('metricBloodSugar'),
    unitOptions: Value('mg/dL,mmol/L'),
    tagOptions: Value('tagFasting,tagBeforeMeal,tagAfterMeal,tagBedtime'),
    conditionKey: Value('diabetes'),
    readingKey: Value('blood_sugar'),
  ),
  MetricsCompanion(
    key: Value('bp_systolic'),
    nameKey: Value('metricBloodPressureSystolic'),
    unitOptions: Value('mmHg'),
    tagOptions: Value('tagMorning,tagEvening,tagOther'),
    conditionKey: Value('hypertension'),
    readingKey: Value('blood_pressure'),
  ),
  MetricsCompanion(
    key: Value('bp_diastolic'),
    nameKey: Value('metricBloodPressureDiastolic'),
    unitOptions: Value('mmHg'),
    tagOptions: Value('tagMorning,tagEvening,tagOther'),
    conditionKey: Value('hypertension'),
    readingKey: Value('blood_pressure'),
  ),
  MetricsCompanion(
    key: Value('pulse'),
    nameKey: Value('metricPulse'),
    unitOptions: Value('bpm'),
    tagOptions: Value('tagMorning,tagEvening,tagOther'),
    conditionKey: Value('hypertension'),
    readingKey: Value('blood_pressure'),
  ),
];

@DriftDatabase(
  tables: [
    Patients,
    Conditions,
    Metrics,
    TargetRanges,
    Readings,
    Medications,
    MedicationSlots,
    DoseLogs,
    Reminders,
    FoodItems,
    EmergencyContacts,
    AppSettingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// On-device database file `care_companion.sqlite`.
  ///
  /// TODO(encryption): the file is not encrypted yet. Plan: swap to
  /// `sqlcipher_flutter_libs` + a key kept in Android Keystore
  /// (`flutter_secure_storage`). It needs a native build change, so it is left
  /// for the polish phase; see README "Privacy".
  AppDatabase.onDevice() : super(driftDatabase(name: 'care_companion'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await batch((b) => b.insertAll(metrics, _seedMetrics));
          await into(appSettingsTable).insert(
            AppSettingsTableCompanion.insert(),
          );
        },
        onUpgrade: (m, from, to) async {
          // One `if (from < N)` block per schema bump; never edit an old block.
          if (from < 2) {
            await m.addColumn(medicationSlots, medicationSlots.startedOn);
            await m.addColumn(medicationSlots, medicationSlots.endedOn);
          }
          if (from < 3) {
            await m.addColumn(appSettingsTable, appSettingsTable.remindersSeeded);
          }
          // New catalogue rows (e.g. a new condition's metrics) are inserted
          // here with insertOnConflictUpdate so upgrades stay idempotent.
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---- Settings -----------------------------------------------------------

  Stream<AppSettingsRow> watchSettings() =>
      (select(appSettingsTable)..where((t) => t.id.equals(1))).watchSingle();

  Future<AppSettingsRow> getSettings() =>
      (select(appSettingsTable)..where((t) => t.id.equals(1))).getSingle();

  Future<void> updateSettings(AppSettingsTableCompanion patch) =>
      (update(appSettingsTable)..where((t) => t.id.equals(1))).write(patch);
}

extension AppSettingsRowX on AppSettingsRow {
  /// Fasting only counts for the day it was switched on.
  bool fastingToday(DateTime now) => fastingOnDate == dateKey(now);
}
