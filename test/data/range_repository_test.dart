import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/repositories/profile_repository.dart';
import 'package:care_companion/data/repositories/range_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late RangeRepository repo;
  late int pid;
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = RangeRepository(db);
    pid = await ProfileRepository(db).savePatient(name: 'Ram');
  });
  tearDown(() => db.close());

  test('saves exactly what was typed, one row per metric + context', () async {
    await repo.save(pid, const RangeInput(
        metricKey: 'blood_sugar', unit: 'mg/dL', cautionLow: 90, cautionHigh: 150));
    await repo.save(pid, const RangeInput(
        metricKey: 'blood_sugar', tagContext: 'tagFasting', unit: 'mg/dL', cautionHigh: 130));
    var rows = await repo.watchAll().first;
    expect(rows.length, 2);
    // Update, not duplicate.
    await repo.save(pid, const RangeInput(
        metricKey: 'blood_sugar', unit: 'mg/dL', cautionLow: 95, cautionHigh: 150));
    rows = await repo.watchAll().first;
    expect(rows.length, 2);
    final all = rows.firstWhere((r) => r.tagContext == null);
    expect((all.cautionLow, all.cautionHigh, all.urgentLow), (95, 150, null));
  });

  test('clearing every field removes the row (back to "not entered")', () async {
    await repo.save(pid, const RangeInput(metricKey: 'pulse', unit: 'bpm', urgentHigh: 180));
    expect((await repo.watchAll().first).length, 1);
    await repo.save(pid, const RangeInput(metricKey: 'pulse', unit: 'bpm', doctorPlanText: '  '));
    expect(await repo.watchAll().first, isEmpty);
  });

  test('doctor plan and warning signs are stored as free text', () async {
    await repo.save(pid, const RangeInput(
        metricKey: 'bp_systolic',
        unit: 'mmHg',
        doctorPlanText: ' Call the clinic ',
        warningSignsText: 'Chest pain'));
    final r = (await repo.watchAll().first).single;
    expect(r.doctorPlanText, 'Call the clinic');
    expect(r.warningSignsText, 'Chest pain');
    expect(r.cautionHigh, isNull);
  });
}
