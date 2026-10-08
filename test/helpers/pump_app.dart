import 'package:care_companion/app.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/providers.dart';
import 'package:care_companion/domain/guidance_content.dart';
import 'package:care_companion/domain/guidance_engine.dart';
import 'dart:io';
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/repositories/medication_repository.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart' show isTest;

AppDatabase? _activeDb;

/// Use instead of `testWidgets` for tests that call [pumpApp]. Drift's stream
/// cleanup timers must be flushed *inside* the test body, so this tears the
/// widget tree and database down before the framework checks for timers.
@isTest
void appTest(String description, Future<void> Function(WidgetTester) body) {
  testWidgets(description, (tester) async {
    await body(tester);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(() async => _activeDb?.close());
    _activeDb = null;
  });
}

/// Boots the whole app on an in-memory database at a fixed date.
Future<AppDatabase> pumpApp(
  WidgetTester tester, {
  bool disclaimerAccepted = true,
  bool withPatient = true,
  String patientName = 'Ram',
  Future<void> Function(AppDatabase db)? beforeStart,
  double textScale = 1.0,
  Size size = const Size(411, 891), // typical Android phone, logical px
  DateTime? now,
  DateTime Function()? clock,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = size * 2;
  tester.view.devicePixelRatio = 2;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearAllTestValues();
  });

  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final db = AppDatabase(NativeDatabase.memory());
  if (disclaimerAccepted) {
    await db.updateSettings(
        const AppSettingsTableCompanion(disclaimerAccepted: Value(true)));
  }
  _activeDb = db;
  if (withPatient) {
    await db.into(db.patients).insert(PatientsCompanion.insert(
        name: patientName, birthYear: const Value(1940)));
  }
  if (beforeStart != null) await beforeStart(db);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        // Same JSON files + parser as the app, read from disk: real asset I/O
        // does not complete reliably under the fake test clock.
        guidanceLibraryProvider.overrideWith((ref) => diskGuidanceLibrary()),
        ...overrides,
        clockProvider.overrideWithValue(clock ?? () => now ?? DateTime(2025, 4, 14, 9)),
      ],
      child: const CareCompanionApp(),
    ),
  );
  await tester.pumpAndSettle();
  return db;
}

/// Adds a medicine for the (single) test patient.
Future<int> addMed(AppDatabase db, String name, Set<DoseSlot> slots,
    {DateTime? now}) async {
  final patient = await db.select(db.patients).getSingle();
  return MedicationRepository(db).save(
    patientId: patient.id,
    name: name,
    slots: slots,
    now: now ?? DateTime(2025, 4, 14, 9),
  );
}

/// TEST FIXTURE numbers (not medical advice) typed in as "the doctor's".
Future<void> enableDiabetes(AppDatabase db,
    {bool withRange = true,
    double? urgentLow = 60,
    double? cautionLow = 80,
    double? cautionHigh = 160,
    double? urgentHigh = 300,
    String unit = 'mg/dL',
    String? plan = 'Plan: call the clinic',
    String? warning = 'Warning: very sleepy'}) async {
  await db.into(db.conditions).insert(
      ConditionsCompanion.insert(patientId: 1, conditionKey: 'diabetes'));
  if (withRange) {
    await db.into(db.targetRanges).insert(TargetRangesCompanion.insert(
          patientId: 1,
          metricKey: 'blood_sugar',
          unit: Value(unit),
          urgentLow: Value(urgentLow),
          cautionLow: Value(cautionLow),
          cautionHigh: Value(cautionHigh),
          urgentHigh: Value(urgentHigh),
          doctorPlanText: Value(plan),
          warningSignsText: Value(warning),
        ));
  }
}

Future<void> enableHypertension(AppDatabase db) async {
  await db.into(db.conditions).insert(
      ConditionsCompanion.insert(patientId: 1, conditionKey: 'hypertension'));
  Future<void> r(String m, double ul, double cl, double ch, double uh) =>
      db.into(db.targetRanges).insert(TargetRangesCompanion.insert(
            patientId: 1,
            metricKey: m,
            unit: const Value('mmHg'),
            urgentLow: Value(ul),
            cautionLow: Value(cl),
            cautionHigh: Value(ch),
            urgentHigh: Value(uh),
          ));
  await r('bp_systolic', 80, 100, 140, 180);
  await r('bp_diastolic', 50, 60, 90, 110);
}

Future<int> addContact(AppDatabase db, String name, String phone,
        {ContactRole role = ContactRole.doctor}) =>
    db.into(db.emergencyContacts).insert(EmergencyContactsCompanion.insert(
        name: name, role: role, phone: phone));

/// The real guidance JSON files, read synchronously from disk.
GuidanceLibrary diskGuidanceLibrary() {
  final library = <String, List<GuidanceItem>>{};
  for (final f in Directory('assets/guidance').listSync().whereType<File>()) {
    if (!f.path.endsWith('.json')) continue;
    final (condition, items) = parseGuidanceFile(f.readAsStringSync());
    library.putIfAbsent(condition, () => []).addAll(items);
  }
  return library;
}
