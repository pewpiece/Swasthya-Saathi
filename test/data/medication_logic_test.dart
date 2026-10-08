import 'package:care_companion/core/dates/date_only.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/repositories/medication_repository.dart';
import 'package:care_companion/data/repositories/profile_repository.dart';
import 'package:care_companion/domain/daily_checklist.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late MedicationRepository meds;
  late int patientId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    meds = MedicationRepository(db);
    patientId = await ProfileRepository(db).savePatient(name: 'Ram', birthYear: 1940);
  });
  tearDown(() => db.close());

  Future<List<MedWithSlots>> allMeds() => meds.watchAll().first;
  Future<List<DoseLog>> allLogs() => db.select(db.doseLogs).get();

  Future<List<ChecklistItem>> checklist(DateTime day) async => buildChecklist(
        meds: await allMeds(),
        logs: await meds.watchLogsForDay(dateKey(day)).first,
        dayKey: dateKey(day),
      );

  final d1 = DateTime(2026, 10, 8, 8);
  final d2 = DateTime(2026, 10, 9, 0, 1); // just after midnight

  group('daily reset', () {
    test('a new day starts unticked and yesterday stays intact', () async {
      final id = await meds.save(
        patientId: patientId,
        name: 'Test med A',
        slots: {DoseSlot.morning, DoseSlot.night},
        now: d1,
      );
      await meds.setTaken(
          medicationId: id, slot: DoseSlot.morning, taken: true, now: DateTime(2026, 10, 8, 23, 59));

      final day1 = await checklist(d1);
      expect(day1.map((e) => (e.slot, e.taken)),
          [(DoseSlot.morning, true), (DoseSlot.night, false)]);

      final day2 = await checklist(d2);
      expect(day2.length, 2);
      expect(day2.every((e) => !e.taken), isTrue, reason: 'fresh unchecked boxes');

      // Yesterday's row was neither changed nor deleted.
      final logs = await allLogs();
      expect(logs.length, 1);
      expect(logs.single.date, '2026-10-08');
      expect(logs.single.taken, isTrue);
    });

    test('ticking on day 2 adds a new row, yesterday is not mutated', () async {
      final id = await meds.save(
          patientId: patientId, name: 'A', slots: {DoseSlot.morning}, now: d1);
      await meds.setTaken(medicationId: id, slot: DoseSlot.morning, taken: true, now: d1);
      await meds.setTaken(medicationId: id, slot: DoseSlot.morning, taken: true, now: d2);
      final logs = await allLogs();
      expect(logs.map((l) => l.date), unorderedEquals(['2026-10-08', '2026-10-09']));
      expect(logs.every((l) => l.taken), isTrue);
    });

    test('undo an accidental tick (today) keeps one row, taken=false',
        () async {
      final id = await meds.save(
          patientId: patientId, name: 'A', slots: {DoseSlot.morning}, now: d1);
      await meds.setTaken(medicationId: id, slot: DoseSlot.morning, taken: true, now: d1);
      await meds.setTaken(medicationId: id, slot: DoseSlot.morning, taken: false, now: d1);
      final logs = await allLogs();
      expect(logs.length, 1);
      expect(logs.single.taken, isFalse);
      expect(logs.single.takenAt, isNull);
      expect((await checklist(d1)).single.taken, isFalse);
    });

    test('ticking just before and just after midnight lands on the right day',
        () async {
      final id = await meds.save(
          patientId: patientId, name: 'A', slots: {DoseSlot.night}, now: d1);
      await meds.setTaken(
          medicationId: id, slot: DoseSlot.night, taken: true, now: DateTime(2026, 10, 8, 23, 59, 59));
      await meds.setTaken(
          medicationId: id, slot: DoseSlot.night, taken: true, now: DateTime(2026, 10, 9, 0, 0, 0));
      expect((await allLogs()).map((l) => l.date).toSet(),
          {'2026-10-08', '2026-10-09'});
    });
  });

  group('checklist content', () {
    test('morning before night, then by name; removed medicines are hidden',
        () async {
      final b = await meds.save(
          patientId: patientId, name: 'beta', slots: {DoseSlot.night, DoseSlot.morning}, now: d1);
      await meds.save(patientId: patientId, name: 'Alpha', slots: {DoseSlot.morning}, now: d1);
      final gone = await meds.save(
          patientId: patientId, name: 'Gone', slots: {DoseSlot.morning}, now: d1);
      await meds.remove(gone, d1);
      final list = await checklist(d1);
      expect(list.map((e) => '${e.slot.name}:${e.medication.name}'),
          ['morning:Alpha', 'morning:beta', 'night:beta']);
      expect(b, isPositive);
    });

    test('removing a medicine keeps its history and does not delete logs',
        () async {
      final id = await meds.save(
          patientId: patientId, name: 'A', slots: {DoseSlot.morning}, now: d1);
      await meds.setTaken(medicationId: id, slot: DoseSlot.morning, taken: true, now: d1);
      await meds.remove(id, d1);
      expect(await checklist(d2), isEmpty);
      expect((await allLogs()).length, 1);
      expect((await allMeds()).single.medication.active, isFalse);
    });

    test('un-selecting then re-selecting a slot restores it', () async {
      final id = await meds.save(
          patientId: patientId, name: 'A', slots: {DoseSlot.morning, DoseSlot.night}, now: d1);
      await meds.save(id: id, patientId: patientId, name: 'A', slots: {DoseSlot.morning}, now: d1);
      expect((await checklist(d2)).map((e) => e.slot), [DoseSlot.morning]);
      await meds.save(id: id, patientId: patientId, name: 'A', slots: {DoseSlot.morning, DoseSlot.night}, now: d2);
      expect((await checklist(d2)).map((e) => e.slot),
          [DoseSlot.morning, DoseSlot.night]);
    });
  });

  group('adherence', () {
    test('counts expected vs given and ignores days before a medicine existed',
        () async {
      final id = await meds.save(
          patientId: patientId,
          name: 'A',
          slots: {DoseSlot.morning, DoseSlot.night},
          now: DateTime(2026, 10, 7, 9)); // started the 7th
      for (final day in [7, 8]) {
        await meds.setTaken(
            medicationId: id, slot: DoseSlot.morning, taken: true, now: DateTime(2026, 10, day, 9));
      }
      await meds.setTaken(
          medicationId: id, slot: DoseSlot.night, taken: true, now: DateTime(2026, 10, 8, 21));

      final result = buildAdherence(
        meds: await allMeds(),
        logs: await allLogs(),
        dayKeys: ['2026-10-09', '2026-10-08', '2026-10-07', '2026-10-06'],
      );
      final byDay = {for (final d in result) d.dayKey: d};
      expect((byDay['2026-10-06']!.expected), 0, reason: 'before it existed');
      expect(byDay['2026-10-07']!.morning.taken, 1);
      expect(byDay['2026-10-07']!.night.taken, 0);
      expect(byDay['2026-10-07']!.expected, 2);
      expect(byDay['2026-10-08']!.taken, 2);
      expect(byDay['2026-10-09']!.expected, 2);
      expect(byDay['2026-10-09']!.taken, 0);
    });

    test('adding a night slot later does not create past misses', () async {
      final id = await meds.save(
          patientId: patientId,
          name: 'A',
          slots: {DoseSlot.morning},
          now: DateTime(2026, 10, 1, 9));
      await meds.save(
          id: id,
          patientId: patientId,
          name: 'A',
          slots: {DoseSlot.morning, DoseSlot.night},
          now: DateTime(2026, 10, 8, 9));
      final r = buildAdherence(
          meds: await allMeds(),
          logs: const [],
          dayKeys: ['2026-10-05', '2026-10-08']);
      expect(r[0].night.expected, 0);
      expect(r[1].night.expected, 1);
    });

    test('a removed medicine keeps counting up to its last day', () async {
      final id = await meds.save(
          patientId: patientId,
          name: 'A',
          slots: {DoseSlot.morning},
          now: DateTime(2026, 10, 1, 9));
      await meds.remove(id, DateTime(2026, 10, 5, 9));
      final r = buildAdherence(
          meds: await allMeds(),
          logs: const [],
          dayKeys: ['2026-10-05', '2026-10-06']);
      expect(r[0].expected, 1, reason: 'day it was removed still counts');
      expect(r[1].expected, 0);
    });
  });

  group('profile + conditions + contacts', () {
    test('savePatient creates once then updates the same row', () async {
      final repo = ProfileRepository(db);
      final id1 = await repo.savePatient(name: ' Ram ', birthYear: 1940);
      final id2 = await repo.savePatient(name: 'Ram P', birthYear: 1941, notes: ' ');
      expect(id2, id1);
      final p = (await repo.getPatient())!;
      expect(p.name, 'Ram P');
      expect(p.notes, isNull);
      expect((await db.select(db.patients).get()).length, 1);
    });

    test('conditions come from the metric catalogue and toggle per patient',
        () async {
      final repo = ProfileRepository(db);
      expect(await repo.availableConditionKeys(), ['diabetes', 'hypertension']);
      await repo.setCondition(patientId, 'diabetes', true);
      await repo.setCondition(patientId, 'diabetes', false);
      final rows = await db.select(db.conditions).get();
      expect(rows.length, 1);
      expect(rows.single.enabled, isFalse);
    });

    test('contacts start empty and support add/edit/delete', () async {
      final repo = ProfileRepository(db);
      expect(await repo.watchContacts().first, isEmpty);
      await repo.saveContact(name: 'Dr Test', role: ContactRole.doctor, phone: '9800000000');
      var c = (await repo.watchContacts().first).single;
      await repo.saveContact(id: c.id, name: 'Dr T2', role: ContactRole.hospital, phone: '9800000001');
      c = (await repo.watchContacts().first).single;
      expect((c.name, c.role), ('Dr T2', ContactRole.hospital));
      await repo.deleteContact(c.id);
      expect(await repo.watchContacts().first, isEmpty);
    });
  });
}
