import 'package:drift/drift.dart' show Value;
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

void main() {
  test('v1 database upgrades (v2, v3) with slot dates and keeps its rows',
      () async {
    final sqlite = raw.sqlite3.openInMemory();
    // Exactly what Phase 1 (schema v1) created for these two tables.
    sqlite.execute('''
      CREATE TABLE patients (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, birth_year INTEGER, notes TEXT, allergies TEXT, soft_food INTEGER NOT NULL DEFAULT 0);
      CREATE TABLE medications (id INTEGER PRIMARY KEY AUTOINCREMENT, patient_id INTEGER NOT NULL, name TEXT NOT NULL, notes TEXT, active INTEGER NOT NULL DEFAULT 1);
      CREATE TABLE medication_slots (medication_id INTEGER NOT NULL, slot TEXT NOT NULL, PRIMARY KEY (medication_id, slot));
      CREATE TABLE app_settings (id INTEGER NOT NULL DEFAULT 1, language TEXT NOT NULL DEFAULT 'en',
        date_style TEXT NOT NULL DEFAULT 'ad', glucose_unit TEXT NOT NULL DEFAULT 'mgDl',
        digit_style TEXT NOT NULL DEFAULT 'latin', fasting_on_date TEXT, last_sugar_tag TEXT,
        last_bp_tag TEXT, disclaimer_accepted INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (id));
      INSERT INTO medications (patient_id, name) VALUES (1, 'Old med');
      INSERT INTO medication_slots (medication_id, slot) VALUES (1, 'morning');
      PRAGMA user_version = 1;
    ''');
    final db = AppDatabase(NativeDatabase.opened(sqlite));
    final slots = await db.select(db.medicationSlots).get();
    expect(slots.length, 1);
    expect(slots.single.slot.name, 'morning');
    expect(slots.single.startedOn, isNull);
    expect(slots.single.endedOn, isNull);
    expect(await db.select(db.patients).get(), isEmpty); // v5 photo column exists
    await db.updateSettings(const AppSettingsTableCompanion(language: Value(AppLanguage.en)));
    await db.close();
  });
}
