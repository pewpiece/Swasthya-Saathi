import 'package:care_companion/core/dates/date_only.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:drift/drift.dart' show Value;
import 'package:care_companion/features/common/check_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  appTest('Home speaks about him by name and lists morning and night',
      (tester) async {
    await pumpApp(tester, beforeStart: (db) async {
      await addMed(db, 'Test tablet', {DoseSlot.morning, DoseSlot.night});
      await addMed(db, 'Another', {DoseSlot.morning});
    });
    expect(find.text("Ram's day"), findsOneWidget);
    expect(find.text('85 years old'), findsOneWidget);
    expect(find.text('Give Ram his morning medicine'), findsOneWidget);
    expect(find.text('Give Ram his night medicine'), findsOneWidget);
    expect(find.text('0 of 2 given'), findsOneWidget);
    expect(find.text('0 of 1 given'), findsOneWidget);
    expect(find.text('Not given yet'), findsNWidgets(3));
  });

  appTest('ONE tap marks a dose as given; tapping again undoes it',
      (tester) async {
    final db = await pumpApp(tester, beforeStart: (db) async {
      await addMed(db, 'Test tablet', {DoseSlot.morning});
    });
    await tester.tap(find.text('Test tablet'));
    await tester.pumpAndSettle();

    expect(find.text('Given at 9:00 AM · Tap again to undo'), findsOneWidget);
    expect(find.text('All given'), findsOneWidget);
    final tile = find.ancestor(
        of: find.text('Test tablet'), matching: find.byType(CheckTile));
    expect(find.descendant(of: tile, matching: find.byIcon(Icons.check_box)),
        findsOneWidget);
    var logs = await db.select(db.doseLogs).get();
    expect((logs.single.taken, logs.single.date), (true, '2025-04-14'));

    await tester.tap(find.text('Test tablet'));
    await tester.pumpAndSettle();
    expect(find.text('Not given yet'), findsOneWidget);
    expect(
        find.descendant(
            of: tile, matching: find.byIcon(Icons.check_box_outline_blank)),
        findsOneWidget);
    logs = await db.select(db.doseLogs).get();
    expect(logs.single.taken, isFalse);
  });

  appTest('at midnight the checklist resets and yesterday stays in the database',
      (tester) async {
    var now = DateTime(2026, 10, 8, 23, 50);
    final db = await pumpApp(tester,
        clock: () => now,
        beforeStart: (db) async {
          await addMed(db, 'Test tablet', {DoseSlot.night}, now: now);
        });
    await tester.tap(find.text('Test tablet'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Given at 11:50 PM'), findsOneWidget);

    now = DateTime(2026, 10, 9, 0, 1);
    await tester.pump(const Duration(seconds: 25)); // the app checks the clock
    await tester.pumpAndSettle();

    expect(find.text('Not given yet'), findsOneWidget, reason: 'fresh box');
    expect(
        find.descendant(
            of: find.ancestor(
                of: find.text('Test tablet'), matching: find.byType(CheckTile)),
            matching: find.byIcon(Icons.check_box_outline_blank)),
        findsOneWidget);
    final logs = await db.select(db.doseLogs).get();
    expect(logs.length, 1);
    expect((logs.single.date, logs.single.taken), ('2026-10-08', true));

    // Ticking now writes a NEW row for the new day.
    await tester.tap(find.text('Test tablet'));
    await tester.pumpAndSettle();
    final after = await db.select(db.doseLogs).get();
    expect(after.map((l) => l.date).toSet(), {'2026-10-08', '2026-10-09'});
    expect(dateKey(now), '2026-10-09');
  });

  appTest('no medicines: friendly empty state with one clear action',
      (tester) async {
    await pumpApp(tester);
    expect(find.text('No medicines added yet'), findsOneWidget);
    await tester.tap(find.text('Add medicine'));
    await tester.pumpAndSettle();
    expect(find.text('Medicine name'), findsOneWidget);
  });

  appTest('fasting today shows the doctor note and turns on/off', (tester) async {
    final db = await pumpApp(tester);
    expect(find.textContaining('Check with his doctor how to handle medicine'),
        findsNothing);
    await tester.tap(find.text('Fasting today (upabas)'));
    await tester.pumpAndSettle();
    expect(
        find.text(
            'Check with his doctor how to handle medicine and readings on fasting days.'),
        findsOneWidget);
    expect((await db.getSettings()).fastingOnDate, '2025-04-14');
    await tester.tap(find.text('Fasting today (upabas)'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Check with his doctor how to handle medicine'),
        findsNothing);
  });

  appTest('Nepali + Devanagari digits on Home', (tester) async {
    final db = await pumpApp(tester, beforeStart: (db) async {
      await addMed(db, 'Test tablet', {DoseSlot.morning});
    });
    await db.updateSettings(const AppSettingsTableCompanion(
        language: Value(AppLanguage.ne), digitStyle: Value(DigitStyle.devanagari)));
    await tester.pumpAndSettle();
    expect(find.text('Ramको दिन'), findsOneWidget);
    expect(find.text('८५ वर्ष'), findsOneWidget);
    expect(find.text('Ramलाई बिहानको औषधि दिनुहोस्'), findsOneWidget);
    expect(find.text('१ मध्ये ० दिइयो'), findsOneWidget);
    await tester.tap(find.text('Test tablet'));
    await tester.pumpAndSettle();
    expect(find.textContaining('९:००'), findsOneWidget);
  });

  appTest('screen reader: a dose says whether it was given', (tester) async {
    await pumpApp(tester, beforeStart: (db) async {
      await addMed(db, 'Test tablet', {DoseSlot.morning});
    });
    final handle = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Test tablet, not given yet. Double tap to mark as given.'),
        findsOneWidget);
    await tester.tap(find.text('Test tablet'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Test tablet, given. Double tap to undo.'),
        findsOneWidget);
    handle.dispose();
  });
}
