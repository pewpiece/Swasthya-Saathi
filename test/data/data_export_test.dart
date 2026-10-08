import 'dart:convert';

import 'package:care_companion/data/data_export.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/repositories/medication_repository.dart';
import 'package:care_companion/data/repositories/profile_repository.dart';
import 'package:care_companion/data/repositories/range_repository.dart';
import 'package:care_companion/data/repositories/reading_repository.dart';
import 'package:care_companion/data/repositories/reminder_repository.dart';
import 'package:care_companion/domain/pin.dart';
import 'package:care_companion/domain/reminder_rules.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> fill() async {
    final profile = ProfileRepository(db);
    final pid = await profile.savePatient(name: 'Ram', birthYear: 1940, allergies: 'Peanuts');
    await profile.setCondition(pid, 'diabetes', true);
    await profile.saveContact(name: 'Dr Test', role: ContactRole.doctor, phone: '9800000000');
    await RangeRepository(db).save(pid, const RangeInput(metricKey: 'blood_sugar', unit: 'mg/dL', cautionHigh: 150));
    await ReadingRepository(db).save(
        patientId: pid, kind: 'blood_sugar', unit: 'mg/dL', measuredAt: DateTime(2026, 10, 1, 9), value: 120);
    final meds = MedicationRepository(db);
    final m = await meds.save(patientId: pid, name: 'Test tablet', slots: {DoseSlot.morning}, now: DateTime(2026, 10, 1, 9));
    await meds.setTaken(medicationId: m, slot: DoseSlot.morning, taken: true, now: DateTime(2026, 10, 1, 9));
    await ReminderRepository(db).save(type: ReminderType.custom, hour: 7, minute: 0, rule: const DailyRule(), label: 'Eye drops');
    final salt = newSalt();
    await db.updateSettings(AppSettingsTableCompanion(
        pinHash: Value(hashPin('4321', salt)), pinSalt: Value(salt), disclaimerAccepted: const Value(true)));
  }

  test('export is valid JSON with every table and NO PIN data', () async {
    await fill();
    final bytes = await DataExporter(db).toBytes(DateTime(2026, 10, 8, 10));
    final text = utf8.decode(bytes);
    final json = jsonDecode(text) as Map<String, dynamic>;
    expect(json['app'], 'Swasthya Saathi');
    expect(json['formatVersion'], 1);
    expect(json['schemaVersion'], db.schemaVersion);
    expect(json['exportedAt'], '2026-10-08T10:00:00.000');
    expect((json['patients'] as List).single['name'], 'Ram');
    expect((json['patients'] as List).single.containsKey('photoPath'), isFalse,
        reason: 'the photo stays on the phone');
    expect((json['readings'] as List).single['value'], 120);
    expect((json['medications'] as List).single['name'], 'Test tablet');
    expect((json['medicationSlots'] as List).length, 1);
    expect((json['doseLogs'] as List).single['taken'], true);
    expect((json['reminders'] as List).single['label'], 'Eye drops');
    expect((json['emergencyContacts'] as List).single['phone'], '9800000000');
    expect((json['targetRanges'] as List).single['cautionHigh'], 150);
    final settings = json['settings'] as Map<String, dynamic>;
    expect(settings.containsKey('pinHash'), isFalse);
    expect(settings.containsKey('pinSalt'), isFalse);
    expect(text.contains('4321'), isFalse);
    expect(settings['disclaimerAccepted'], true);
  });

  test('empty database still exports', () async {
    final json = jsonDecode(utf8.decode(await DataExporter(db).toBytes(DateTime(2026)))) as Map;
    expect(json['patients'], isEmpty);
    expect(json['readings'], isEmpty);
  });

  test('delete all data empties everything, resets settings and the PIN', () async {
    await fill();
    await db.deleteAllData();
    for (final rows in [
      await db.select(db.patients).get(),
      await db.select(db.conditions).get(),
      await db.select(db.targetRanges).get(),
      await db.select(db.readings).get(),
      await db.select(db.medications).get(),
      await db.select(db.medicationSlots).get(),
      await db.select(db.doseLogs).get(),
      await db.select(db.reminders).get(),
      await db.select(db.emergencyContacts).get(),
    ]) {
      expect(rows, isEmpty);
    }
    final s = await db.getSettings();
    expect((s.disclaimerAccepted, s.pinHash, s.pinSalt, s.remindersSeeded), (false, null, null, false));
    expect(await db.select(db.metrics).get(), isNotEmpty, reason: 'the measure catalogue stays');
    // and the app can start again from scratch
    expect(await ProfileRepository(db).savePatient(name: 'New'), isPositive);
  });

  test('v3 database upgrades to v4 with PIN columns, keeping settings', () async {
    final sqlite = raw.sqlite3.openInMemory();
    sqlite.execute('''
      CREATE TABLE patients (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, birth_year INTEGER, notes TEXT, allergies TEXT, soft_food INTEGER NOT NULL DEFAULT 0);
      CREATE TABLE app_settings (id INTEGER NOT NULL DEFAULT 1, language TEXT NOT NULL DEFAULT 'en',
        date_style TEXT NOT NULL DEFAULT 'ad', glucose_unit TEXT NOT NULL DEFAULT 'mgDl',
        digit_style TEXT NOT NULL DEFAULT 'latin', fasting_on_date TEXT, last_sugar_tag TEXT,
        last_bp_tag TEXT, disclaimer_accepted INTEGER NOT NULL DEFAULT 0,
        reminders_seeded INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (id));
      INSERT INTO app_settings (id, language, disclaimer_accepted, reminders_seeded) VALUES (1, 'ne', 1, 1);
      PRAGMA user_version = 3;
    ''');
    final upgraded = AppDatabase(NativeDatabase.opened(sqlite));
    final s = await upgraded.getSettings();
    expect((s.pinHash, s.pinSalt, s.language, s.remindersSeeded), (null, null, AppLanguage.ne, true));
    await upgraded.close();
  });
}
