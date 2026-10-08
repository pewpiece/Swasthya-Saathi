import 'package:care_companion/app.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/providers.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  double textScale = 1.0,
  Size size = const Size(411, 891), // typical Android phone, logical px
  DateTime? now,
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

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now ?? DateTime(2025, 4, 14, 9)),
      ],
      child: const CareCompanionApp(),
    ),
  );
  await tester.pumpAndSettle();
  return db;
}
