import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/repositories/reminder_repository.dart';
import 'package:care_companion/domain/reminder_rules.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

void main() {
  late AppDatabase db;
  late ReminderRepository repo;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ReminderRepository(db);
  });
  tearDown(() => db.close());

  test('defaults are created exactly once, even after the user deletes them', () async {
    expect(await repo.seedDefaultsOnce(), isTrue);
    var rows = await repo.watchAll().first;
    expect(rows.length, 4);
    expect(rows.every((r) => r.enabled), isTrue);
    expect(await repo.seedDefaultsOnce(), isFalse);
    for (final r in rows) {
      await repo.delete(r.id);
    }
    expect(await repo.seedDefaultsOnce(), isFalse, reason: 'deleted stays deleted');
    rows = await repo.watchAll().first;
    expect(rows, isEmpty);
  });

  test('save, edit, enable/disable, delete', () async {
    final id = await repo.save(
        type: ReminderType.custom,
        hour: 7,
        minute: 30,
        rule: const DailyRule(),
        label: '  Eye drops ');
    var r = (await repo.get(id))!;
    expect((r.hour, r.minute, r.label, r.repeatRule, r.enabled), (7, 30, 'Eye drops', 'daily', true));

    await repo.save(
        id: id,
        type: ReminderType.measureWeekly,
        hour: 10,
        minute: 15,
        rule: const WeeklyRule(3));
    r = (await repo.get(id))!;
    expect((r.type, r.hour, r.minute, r.repeatRule, r.label),
        (ReminderType.measureWeekly, 10, 15, 'weekly:3', null));

    await repo.setEnabled(id, false);
    expect((await repo.get(id))!.enabled, isFalse);
    await repo.save(id: id, type: ReminderType.custom, hour: 1, minute: 0, rule: const DailyRule(), label: 'x');
    expect((await repo.get(id))!.enabled, isFalse, reason: 'editing keeps it switched off');

    await repo.delete(id);
    expect(await repo.get(id), isNull);
  });

  test('list is in time order', () async {
    await repo.save(type: ReminderType.custom, hour: 21, minute: 0, rule: const DailyRule(), label: 'b');
    await repo.save(type: ReminderType.custom, hour: 8, minute: 30, rule: const DailyRule(), label: 'a');
    await repo.save(type: ReminderType.custom, hour: 8, minute: 0, rule: const DailyRule(), label: 'c');
    final labels = (await repo.watchAll().first).map((r) => r.label).toList();
    expect(labels, ['c', 'a', 'b']);
  });

  test('v2 database upgrades to v3 and the defaults flag starts false', () async {
    final sqlite = raw.sqlite3.openInMemory();
    sqlite.execute('''
      CREATE TABLE patients (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, birth_year INTEGER, notes TEXT, allergies TEXT, soft_food INTEGER NOT NULL DEFAULT 0);
      CREATE TABLE app_settings (id INTEGER NOT NULL DEFAULT 1, language TEXT NOT NULL DEFAULT 'en',
        date_style TEXT NOT NULL DEFAULT 'ad', glucose_unit TEXT NOT NULL DEFAULT 'mgDl',
        digit_style TEXT NOT NULL DEFAULT 'latin', fasting_on_date TEXT, last_sugar_tag TEXT,
        last_bp_tag TEXT, disclaimer_accepted INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (id));
      INSERT INTO app_settings (id, language, disclaimer_accepted) VALUES (1, 'ne', 1);
      PRAGMA user_version = 2;
    ''');
    final upgraded = AppDatabase(NativeDatabase.opened(sqlite));
    final s = await upgraded.getSettings();
    expect(s.remindersSeeded, isFalse);
    expect(s.language, AppLanguage.ne, reason: 'existing settings are kept');
    expect(s.disclaimerAccepted, isTrue);
    await upgraded.close();
  });
}
