import 'package:care_companion/core/dates/date_only.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/repositories/medication_repository.dart';
import 'package:care_companion/data/repositories/profile_repository.dart';
import 'package:care_companion/data/repositories/range_repository.dart';
import 'package:care_companion/data/repositories/reading_repository.dart';
import 'package:care_companion/domain/guidance_engine.dart';
import 'package:care_companion/domain/report_data.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late int pid;
  final now = DateTime(2026, 10, 8, 10);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    pid = await ProfileRepository(db).savePatient(
        name: 'Ram', birthYear: 1940, allergies: 'Egg', softFood: true, notes: 'Walks daily');
  });
  tearDown(() => db.close());

  Future<ReportData> build({int days = 14, GlucoseUnit unit = GlucoseUnit.mgDl, List<String>? conditions}) async {
    final med = MedicationRepository(db);
    return buildReportData(
      patient: (await ProfileRepository(db).getPatient())!,
      enabledConditionKeys: conditions ?? ['diabetes'],
      metrics: await db.select(db.metrics).get(),
      ranges: await db.select(db.targetRanges).get(),
      readings: await db.select(db.readings).get(),
      meds: await med.watchAll().first,
      logs: await db.select(db.doseLogs).get(),
      glucoseUnit: unit,
      days: days,
      now: now,
    );
  }

  Future<void> sugar(DateTime at, double v, {String unit = 'mg/dL', String? tag}) =>
      ReadingRepository(db).save(
          patientId: pid, kind: 'blood_sugar', unit: unit, measuredAt: at, value: v, tag: tag);

  test('patient facts are carried over', () async {
    final d = await build();
    expect((d.patientName, d.age, d.allergies, d.softFood, d.notes), ('Ram', 86, 'Egg', true, 'Walks daily'));
    expect((d.start, d.end), (DateTime(2026, 9, 25), DateTime(2026, 10, 8)));
  });

  test('period is 14 or 28 whole days ending today; readings outside are left out', () async {
    await sugar(DateTime(2026, 9, 24, 23, 59), 100); // day before the 14-day window
    await sugar(DateTime(2026, 9, 25, 0, 0), 110); // first minute of the window
    await sugar(DateTime(2026, 10, 8, 23, 0), 120); // last day, evening
    await sugar(DateTime(2026, 10, 9, 0, 0), 130); // tomorrow
    final two = await build(days: 14);
    expect(two.sections.single.rows.map((r) => r.reading.value), [110, 120]);
    final four = await build(days: 28);
    expect(four.sections.single.rows.map((r) => r.reading.value), [100, 110, 120]);
    expect(four.start, DateTime(2026, 9, 11));
  });

  test('stats are average / min / max and units are converted', () async {
    await sugar(DateTime(2026, 10, 1, 8), 126); // mg/dL
    await sugar(DateTime(2026, 10, 2, 8), 7.0, unit: 'mmol/L'); // = 126
    await sugar(DateTime(2026, 10, 3, 8), 9.0, unit: 'mmol/L'); // = 162
    final mg = (await build()).sections.single;
    expect(mg.unit, 'mg/dL');
    final s = mg.stats.single.$2;
    expect((s.count, s.min, s.max, s.average), (3, 126, 162, 138));
    final mmol = (await build(unit: GlucoseUnit.mmolL)).sections.single;
    expect(mmol.unit, 'mmol/L');
    expect(mmol.stats.single.$2.max, 9.0);
  });

  test('status per reading uses the CURRENT ranges; none entered = no range', () async {
    await sugar(DateTime(2026, 10, 1), 200);
    expect((await build()).sections.single.rows.single.tier, Tier.unknown);
    await RangeRepository(db).save(pid, const RangeInput(
        metricKey: 'blood_sugar', unit: 'mg/dL', cautionHigh: 150, urgentHigh: 300));
    final d = await build();
    expect(d.sections.single.rows.single.tier, Tier.outOfRange);
    expect(d.sections.single.band, isNotNull);
    expect(d.ranges.single.cautionHigh, 150);
  });

  test('no ranges entered -> no band and an empty ranges list (nothing invented)', () async {
    await sugar(DateTime(2026, 10, 1), 100);
    final d = await build();
    expect(d.ranges, isEmpty);
    expect(d.sections.single.band, isNull);
  });

  test('blood pressure section: top, bottom, pulse stats', () async {
    final repo = ReadingRepository(db);
    for (final (i, s, di, p) in [(1, 130, 85, 70), (2, 150, 95, 80)]) {
      await repo.save(
          patientId: pid,
          kind: 'blood_pressure',
          unit: 'mmHg',
          measuredAt: DateTime(2026, 10, i, 8),
          systolic: s,
          diastolic: di,
          pulse: p);
    }
    final d = await build(conditions: ['hypertension']);
    final sec = d.sections.single;
    expect(sec.kind, 'blood_pressure');
    expect(sec.stats.map((e) => e.$1), ['bp_systolic', 'bp_diastolic', 'pulse']);
    expect(sec.stats[0].$2.average, 140);
    expect(sec.stats[1].$2.max, 95);
    expect(sec.stats[2].$2.min, 70);
  });

  test('sections: conditions that are on, plus any kind with readings', () async {
    expect((await build(conditions: ['diabetes'])).sections.map((s) => s.kind), ['blood_sugar']);
    expect((await build(conditions: ['diabetes', 'hypertension'])).sections.map((s) => s.kind),
        ['blood_sugar', 'blood_pressure']);
    await ReadingRepository(db).save(
        patientId: pid, kind: 'blood_pressure', unit: 'mmHg',
        measuredAt: DateTime(2026, 10, 2), systolic: 120, diastolic: 80);
    expect((await build(conditions: ['diabetes'])).sections.map((s) => s.kind),
        ['blood_sugar', 'blood_pressure'],
        reason: 'logged readings are never left out');
    expect((await build(conditions: [])).sections.map((s) => s.kind), ['blood_pressure']);
  });

  test('ranges with only text still appear (plan / warning signs); empty rows do not', () async {
    final repo = RangeRepository(db);
    await repo.save(pid, const RangeInput(
        metricKey: 'blood_sugar', doctorPlanText: 'Call clinic', warningSignsText: 'Sleepy'));
    final d = await build();
    expect(d.ranges.single.plan, 'Call clinic');
    expect(d.ranges.single.warning, 'Sleepy');
  });

  group('medicines and doses', () {
    test('adherence totals only count doses that were due', () async {
      final repo = MedicationRepository(db);
      final id = await repo.save(
          patientId: pid,
          name: 'Test tablet',
          slots: {DoseSlot.morning, DoseSlot.night},
          now: DateTime(2026, 10, 5, 9)); // started 5 Oct
      // Given: morning on 5, 6; night on 5.
      for (final (day, slot) in [(5, DoseSlot.morning), (6, DoseSlot.morning), (5, DoseSlot.night)]) {
        await repo.setTaken(
            medicationId: id, slot: slot, taken: true, now: DateTime(2026, 10, day, 9));
      }
      final d = await build();
      // Due: 5..8 Oct = 4 days each slot.
      expect((d.morning.expected, d.morning.taken, d.morning.percent), (4, 2, 50));
      expect((d.night.expected, d.night.taken, d.night.percent), (4, 1, 25));
      expect(d.days.length, 14);
      expect(d.days.first.dayKey, '2026-09-25');
      expect(d.days.last.dayKey, '2026-10-08');
      expect(d.meds.single.name, 'Test tablet');
      expect(d.meds.single.slots, {DoseSlot.morning, DoseSlot.night});
    });

    test('a removed medicine still counts for the days it was in use', () async {
      final repo = MedicationRepository(db);
      final id = await repo.save(
          patientId: pid, name: 'Old med', slots: {DoseSlot.morning}, now: DateTime(2026, 10, 1, 9));
      await repo.remove(id, DateTime(2026, 10, 3, 9));
      final d = await build();
      expect(d.morning.expected, 3, reason: '1, 2 and 3 Oct');
      expect(d.meds.map((m) => m.name), ['Old med']);
    });

    test('no medicines: zero totals, nothing divides by zero', () async {
      final d = await build();
      expect((d.morning.expected, d.morning.percent), (0, 0));
      expect(d.meds, isEmpty);
    });
  });

  test('dates in the data are plain AD (keys are yyyy-MM-dd)', () async {
    final d = await build();
    expect(dateKey(d.generatedAt), '2026-10-08');
  });
}
