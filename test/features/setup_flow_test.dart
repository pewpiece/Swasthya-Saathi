import 'package:care_companion/data/db/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

Finder field(String label) => find.byWidgetPredicate(
    (w) => w is TextField && w.decoration?.labelText == label,
    description: 'field "$label"');

Future<void> tapText(WidgetTester t, String text) async {
  await t.ensureVisible(find.text(text).first);
  await t.tap(find.text(text).first);
  await t.pumpAndSettle();
}

void main() {
  const tall = Size(411, 1800);

  appTest('no profile yet: disclaimer, then the setup wizard (name required)',
      (tester) async {
    await pumpApp(tester,
        disclaimerAccepted: false, withPatient: false, size: tall);
    await tapText(tester, 'I understand');

    expect(find.text('Set up the profile'), findsOneWidget);
    expect(find.text('Step 1 of 6: About him'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing, reason: 'no tabs in setup');

    // Name is required.
    await tapText(tester, 'Next');
    expect(find.text('Please type his name.'), findsOneWidget);
    expect(find.text('Step 1 of 6: About him'), findsOneWidget);

    // Age is checked for typos.
    await tester.enterText(field('His name'), 'Ram');
    await tester.enterText(field('His age (years)'), '850');
    await tapText(tester, 'Next');
    expect(find.text('Please type an age between 1 and 120.'), findsOneWidget);
  });

  appTest('complete wizard: profile, conditions, food, medicine, ranges, contact',
      (tester) async {
    final db = await pumpApp(tester,
        disclaimerAccepted: false, withPatient: false, size: tall);
    await tapText(tester, 'I understand');

    // 1. About
    await tester.enterText(field('His name'), 'Ram');
    await tester.enterText(field('His age (years)'), '85');
    await tapText(tester, 'Next');
    expect(find.text('Step 2 of 6: Health conditions'), findsOneWidget);
    var p = await db.select(db.patients).getSingle();
    expect((p.name, p.birthYear), ('Ram', 2025 - 85));

    // 2. Conditions: tick diabetes
    await tapText(tester, 'Diabetes (blood sugar)');
    await tapText(tester, 'Next');
    expect(find.text('Step 3 of 6: Food and allergies'), findsOneWidget);
    final cond = await db.select(db.conditions).get();
    expect(cond.single.conditionKey, 'diabetes');
    expect(cond.single.enabled, isTrue);

    // 3. Food
    await tester.enterText(field('Allergies or foods he cannot eat'), 'Peanuts');
    await tapText(tester, 'He needs soft food');
    await tapText(tester, 'Next');
    p = await db.select(db.patients).getSingle();
    expect((p.allergies, p.softFood), ('Peanuts', true));

    // 4. Medicines: add one for morning and night
    expect(find.text('Step 4 of 6: Medicines'), findsOneWidget);
    await tapText(tester, 'Add medicine');
    await tester.enterText(field('Medicine name'), 'Test tablet');
    await tapText(tester, 'Night');
    await tapText(tester, 'Save');
    expect(find.text('Test tablet'), findsOneWidget);
    expect(find.text('Morning'), findsOneWidget);
    await tapText(tester, 'Next');

    // 5. Doctor's numbers: wrong order is refused with a plain message
    expect(find.text("Step 5 of 6: Doctor's numbers"), findsOneWidget);
    expect(find.text('Blood sugar'), findsOneWidget);
    expect(find.text('Blood pressure (top number)'), findsNothing,
        reason: 'hypertension not selected');
    await tester.enterText(field('Be careful if below (mg/dL)'), '150');
    await tester.enterText(field('Be careful if above (mg/dL)'), '90');
    await tapText(tester, 'Next');
    expect(find.text('Please fix the items marked with a warning sign.'),
        findsOneWidget);
    expect(find.textContaining('not in order'), findsOneWidget);
    expect(await db.select(db.targetRanges).get(), isEmpty,
        reason: 'nothing saved while invalid');

    // Fix and save, with the doctor's plan text.
    await tester.enterText(field('Be careful if below (mg/dL)'), '90');
    await tester.enterText(field('Be careful if above (mg/dL)'), '150');
    await tester.enterText(
        field('His doctor\'s plan (optional)').first, 'Call the clinic');
    await tapText(tester, 'Next');
    final ranges = await db.select(db.targetRanges).get();
    expect(ranges.length, 1);
    expect((ranges.single.cautionLow, ranges.single.cautionHigh), (90, 150));
    expect(ranges.single.urgentLow, isNull, reason: 'untouched stays empty');
    expect(ranges.single.unit, 'mg/dL');
    expect(ranges.single.doctorPlanText, 'Call the clinic');

    // 6. Contacts: bad phone refused, then saved
    expect(find.text('Step 6 of 6: Emergency contacts'), findsOneWidget);
    expect(find.text('No contacts yet'), findsOneWidget);
    await tapText(tester, 'Add contact');
    await tester.enterText(field('Name'), 'Dr Test');
    await tester.enterText(field('Phone number'), 'abc');
    await tapText(tester, 'Save');
    expect(find.text('Please check the phone number.'), findsOneWidget);
    await tester.enterText(field('Phone number'), '9800000000');
    await tapText(tester, 'Save');
    expect(find.textContaining('Dr Test'), findsOneWidget);

    await tapText(tester, 'Finish');
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text("Ram's day"), findsOneWidget);
    expect(find.text('Give Ram his morning medicine'), findsOneWidget);
  });

  appTest('leaving every doctor number empty saves no range at all',
      (tester) async {
    final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
      await db.into(db.conditions).insert(ConditionsCompanion.insert(
          patientId: 1, conditionKey: 'hypertension'));
    });
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    await tapText(tester, "Doctor's numbers");
    expect(find.text('Blood pressure (top number)'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Pulse'), 400,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Pulse'), findsOneWidget);
    await tapText(tester, 'Done');
    expect(await db.select(db.targetRanges).get(), isEmpty);
  });

  appTest('ranges step explains what to do when no condition is chosen',
      (tester) async {
    await pumpApp(tester, size: tall);
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    await tapText(tester, "Doctor's numbers");
    expect(find.textContaining('First choose a health condition'), findsOneWidget);
  });

  appTest('editing a saved range: unit and values come back', (tester) async {
    await pumpApp(tester, size: tall, beforeStart: (db) async {
      await db.into(db.conditions).insert(ConditionsCompanion.insert(
          patientId: 1, conditionKey: 'diabetes'));
      await db.into(db.targetRanges).insert(TargetRangesCompanion.insert(
            patientId: 1,
            metricKey: 'blood_sugar',
            unit: const Value('mmol/L'),
            cautionHigh: const Value(8.5),
          ));
    });
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    await tapText(tester, "Doctor's numbers");
    expect(find.text('Be careful if above (mmol/L)'), findsOneWidget);
    expect(find.widgetWithText(TextField, '8.5'), findsOneWidget);
  });
}
