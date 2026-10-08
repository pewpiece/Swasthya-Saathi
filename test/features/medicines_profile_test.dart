import 'package:care_companion/data/enums.dart';
import 'package:care_companion/dev/demo_seed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

Finder field(String label) => find.byWidgetPredicate(
    (w) => w is TextField && w.decoration?.labelText == label);

Future<void> tapText(WidgetTester t, String text) async {
  await t.ensureVisible(find.text(text).first);
  await t.tap(find.text(text).first);
  await t.pumpAndSettle();
}

Future<void> openTab(WidgetTester t, String label) async {
  await t.tap(find.descendant(
      of: find.byType(NavigationBar), matching: find.text(label)));
  await t.pumpAndSettle();
}

void main() {
  const tall = Size(411, 1800);

  appTest('Medicines tab: add, edit and remove with a safe confirmation',
      (tester) async {
    final db = await pumpApp(tester, size: tall);
    await openTab(tester, 'Medicines');
    expect(find.text('Last 14 days'), findsOneWidget);
    expect(find.text('History will appear here after you add medicines.'),
        findsOneWidget);

    // Add
    await tapText(tester, 'Add medicine');
    await tapText(tester, 'Save'); // empty name is refused
    expect(find.text('Please type the medicine name.'), findsOneWidget);
    await tester.enterText(field('Medicine name'), 'Test tablet');
    await tester.enterText(field('Notes (optional)'), 'after food');
    await tapText(tester, 'Save');
    expect(find.text('Test tablet'), findsOneWidget);
    expect(find.text('after food'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget, reason: 'visible feedback');

    // Can't save with no time chosen
    await tapText(tester, 'Test tablet');
    await tapText(tester, 'Morning'); // untick the only time
    await tapText(tester, 'Save');
    expect(find.text('Choose morning, night, or both.'), findsOneWidget);
    await tapText(tester, 'Night');
    await tester.enterText(field('Medicine name'), 'Test tablet 2');
    await tapText(tester, 'Save');
    expect(find.text('Test tablet 2'), findsOneWidget);
    expect(find.text('Night'), findsOneWidget);

    // Remove: the dialog says it does not change his real medicine
    await tapText(tester, 'Test tablet 2');
    await tapText(tester, 'Remove from list');
    expect(find.textContaining('does not change his medicine'), findsOneWidget);
    await tapText(tester, 'Keep it');
    expect(find.text('Edit medicine'), findsOneWidget, reason: 'still editing');
    expect((await db.select(db.medications).get()).single.active, isTrue);

    await tapText(tester, 'Remove from list');
    await tapText(tester, 'Remove');
    expect(find.text('Test tablet 2'), findsNothing);
    final med = (await db.select(db.medications).get()).single;
    expect(med.active, isFalse, reason: 'hidden, not deleted');
  });

  appTest('adherence history shows days with icon + text, newest first',
      (tester) async {
    await pumpApp(tester,
        size: tall,
        withPatient: false,
        disclaimerAccepted: true,
        beforeStart: (db) async {
      await seedDemoData(db, DateTime(2025, 4, 14, 9));
    });
    await openTab(tester, 'Medicines');
    expect(find.text('Demo tablet A'), findsOneWidget);
    expect(find.textContaining('Today, 14 Apr 2025'), findsOneWidget);
    expect(find.text('13 Apr 2025'), findsOneWidget);
    // Today nothing is marked yet -> text says so (not colour alone).
    expect(find.text('None marked'), findsWidgets);
    expect(find.byIcon(Icons.cancel_outlined), findsWidgets);
    expect(find.byIcon(Icons.check_circle), findsWidgets);
  });

  appTest('profile hub shows a summary; editing the name updates Home',
      (tester) async {
    await pumpApp(tester, size: tall);
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.text('Everything about Ram. Tap a line to change it.'),
        findsOneWidget);
    expect(find.text('Ram, 85 years old'), findsOneWidget);
    expect(find.text('Not set yet'), findsWidgets);

    await tapText(tester, 'About him');
    await tester.enterText(field('His name'), 'Hari');
    await tapText(tester, 'Done');
    expect(find.text('Hari, 85 years old'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text("Hari's day"), findsOneWidget);
  });

  appTest('Settings has a way to the profile', (tester) async {
    await pumpApp(tester, size: tall);
    await openTab(tester, 'Settings');
    await tapText(tester, "Profile and doctor's numbers");
    expect(find.text('Emergency contacts'), findsOneWidget);
  });

  appTest('demo data: fake only, no ranges, no phone numbers', (tester) async {
    final db = await pumpApp(tester, withPatient: false);
    expect(await seedDemoData(db, DateTime(2025, 4, 14)), isTrue);
    expect(await seedDemoData(db, DateTime(2025, 4, 14)), isFalse,
        reason: 'never overwrites a real profile');
    expect(await db.select(db.targetRanges).get(), isEmpty);
    expect(await db.select(db.emergencyContacts).get(), isEmpty);
    final names = (await db.select(db.medications).get()).map((m) => m.name);
    expect(names.every((n) => n.startsWith('Demo')), isTrue);
    expect((await db.select(db.doseLogs).get()).every((l) => l.date != '2025-04-14'),
        isTrue, reason: 'today starts unticked');
    expect(DoseSlot.values.length, 2);
  });
}
