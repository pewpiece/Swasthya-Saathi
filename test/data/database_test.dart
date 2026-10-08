import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('creates schema with default settings', () async {
    final s = await db.getSettings();
    expect(s.language, AppLanguage.en);
    expect(s.dateStyle, DateStyle.ad);
    expect(s.glucoseUnit, GlucoseUnit.mgDl);
    expect(s.digitStyle, DigitStyle.latin);
    expect(s.disclaimerAccepted, isFalse);
    expect(s.fastingOnDate, isNull);
  });

  test('settings round-trip and stream emits changes', () async {
    final seen = <AppLanguage>[];
    final sub = db.watchSettings().listen((s) => seen.add(s.language));
    await pumpEventQueue();
    await db.updateSettings(
        const AppSettingsTableCompanion(language: Value(AppLanguage.ne)));
    await pumpEventQueue();
    await sub.cancel();
    expect(seen, [AppLanguage.en, AppLanguage.ne]);
  });

  test('metric catalogue is seeded; conditions are data', () async {
    final metrics = await db.select(db.metrics).get();
    expect(metrics.map((m) => m.key),
        unorderedEquals(['blood_sugar', 'bp_systolic', 'bp_diastolic', 'pulse']));
    final sugar = metrics.firstWhere((m) => m.key == 'blood_sugar');
    expect(sugar.unitOptions.split(','), ['mg/dL', 'mmol/L']);
    expect(sugar.conditionKey, 'diabetes');
    expect(metrics.where((m) => m.readingKey == 'blood_pressure').length, 3);
  });

  test('SAFETY: no medical thresholds or phone numbers are built in',
      () async {
    expect(await db.select(db.targetRanges).get(), isEmpty);
    expect(await db.select(db.emergencyContacts).get(), isEmpty);
    expect(await db.select(db.patients).get(), isEmpty);
  });

  test('fastingToday only holds for the day it was switched on', () async {
    await db.updateSettings(
        const AppSettingsTableCompanion(fastingOnDate: Value('2026-10-08')));
    final s = await db.getSettings();
    expect(s.fastingToday(DateTime(2026, 10, 8, 23, 59)), isTrue);
    expect(s.fastingToday(DateTime(2026, 10, 9, 0, 1)), isFalse);
  });

  test('dose log is unique per medicine, slot and day', () async {
    final pid = await db
        .into(db.patients)
        .insert(PatientsCompanion.insert(name: 'Ram'));
    final mid = await db
        .into(db.medications)
        .insert(MedicationsCompanion.insert(patientId: pid, name: 'Test med'));
    DoseLogsCompanion log(String date) => DoseLogsCompanion.insert(
        medicationId: mid, slot: DoseSlot.morning, date: date);
    await db.into(db.doseLogs).insert(log('2026-10-08'));
    await db.into(db.doseLogs).insert(log('2026-10-09')); // new day = new row
    expect(
      () => db.into(db.doseLogs).insert(log('2026-10-08')),
      throwsA(isA<Exception>()),
    );
    expect((await db.select(db.doseLogs).get()).length, 2);
  });

  test('foreign keys are enforced', () async {
    expect(
      () => db.into(db.medications).insert(
          MedicationsCompanion.insert(patientId: 999, name: 'Orphan')),
      throwsA(isA<Exception>()),
    );
  });
}
