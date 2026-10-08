import 'package:care_companion/data/db/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

void main() {
  test('v1 database upgrades to v2 with slot dates and keeps its rows',
      () async {
    final sqlite = raw.sqlite3.openInMemory();
    // Exactly what Phase 1 (schema v1) created for these two tables.
    sqlite.execute('''
      CREATE TABLE medications (id INTEGER PRIMARY KEY AUTOINCREMENT, patient_id INTEGER NOT NULL, name TEXT NOT NULL, notes TEXT, active INTEGER NOT NULL DEFAULT 1);
      CREATE TABLE medication_slots (medication_id INTEGER NOT NULL, slot TEXT NOT NULL, PRIMARY KEY (medication_id, slot));
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
    await db.close();
  });
}
