import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/providers.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'dart:ui' show Tristate;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

Finder field(String label) => find.byWidgetPredicate(
    (w) => w is TextField && w.decoration?.labelText == label);

Future<void> tapText(WidgetTester t, String text) async {
  await t.ensureVisible(find.text(text).first);
  await t.tap(find.text(text).first);
  await t.pumpAndSettle();
}

/// Home -> Add reading -> type the number -> Save.
Future<void> logSugar(WidgetTester t, String number) async {
  await tapText(t, 'Add reading');
  await t.enterText(field('Blood sugar number'), number);
  await tapText(t, 'Save reading');
}

void main() {
  const tall = Size(411, 4000);

  group('blood sugar, three tiers', () {
    appTest('IN RANGE: banner with icon + words, meal ideas, go easy on, tips',
        (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
      });
      await logSugar(tester, '120');

      expect(find.text('Within his doctor\'s range'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsWidgets);
      expect(find.text('120 mg/dL'), findsOneWidget);
      expect(find.text('Prefer'), findsOneWidget);
      expect(find.text('Go easy on'), findsOneWidget);
      expect(find.text('Other tips'), findsOneWidget);
      expect(find.text('Sugar in chiya'), findsOneWidget);
      expect(find.text('Dal-bhat with more tarkari and a smaller helping of rice'),
          findsOneWidget);
      expect(find.text('Not yet reviewed by a clinician'), findsWidgets);
      expect(find.textContaining('not medical advice'), findsOneWidget);
      expect(find.text('Tell his doctor about this reading.'), findsNothing);
      expect(find.textContaining('Plan: call'), findsNothing);
      final saved = await db.select(db.readings).getSingle();
      expect((saved.value, saved.unit, saved.metricKey), (120, 'mg/dL', 'blood_sugar'));
    });

    appTest('OUT OF RANGE (high): cautious, tell his doctor, the doctor\'s own plan',
        (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
      });
      await logSugar(tester, '200');
      expect(find.text('Outside his doctor\'s range'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsWidgets);
      expect(find.text('Tell his doctor about this reading.'), findsOneWidget);
      expect(find.text('Plan: call the clinic'), findsOneWidget);
      expect(find.text('His doctor\'s plan'), findsOneWidget);
      expect(find.text('Sugar in chiya'), findsOneWidget, reason: 'high -> go easy on');
      expect(find.text('A boiled egg'), findsNothing,
          reason: 'general meal ideas are for in-range readings only');
    });

    appTest('OUT OF RANGE (low): no food advice for lows, plan still shown',
        (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
      });
      await logSugar(tester, '70');
      expect(find.text('Outside his doctor\'s range'), findsOneWidget);
      expect(find.text('Plan: call the clinic'), findsOneWidget);
      expect(find.text('Go easy on'), findsNothing);
      expect(find.text('Sugar in chiya'), findsNothing);
      expect(find.text('Prefer'), findsNothing);
    });

    appTest('URGENT: only the urgent screen, tap to call, warning signs, no tips',
        (tester) async {
      final calls = <String>[];
      await pumpApp(tester,
          size: tall,
          overrides: [
            phoneLauncherProvider.overrideWithValue((n) async {
              calls.add(n);
              return true;
            }),
          ],
          beforeStart: (db) async {
        await enableDiabetes(db);
        await addContact(db, 'Dr Test', '+977 984-000-0000');
        await addContact(db, 'Test Hospital', '01 444 0000',
            role: ContactRole.hospital);
      });
      await logSugar(tester, '400');

      expect(find.text('Contact his doctor or emergency services now'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsWidgets);
      expect(find.text('Urgent'), findsWidgets);
      expect(find.text('Call Dr Test'), findsOneWidget);
      expect(find.text('Call Test Hospital'), findsOneWidget);
      expect(find.text('Warning: very sleepy'), findsOneWidget);
      // Nothing else: no meals, tips, plan, banner copy.
      for (final t in ['Prefer', 'Go easy on', 'Other tips', 'Sugar in chiya',
          'Plan: call the clinic', 'His doctor\'s plan']) {
        expect(find.text(t), findsNothing, reason: t);
      }
      expect(find.text('Not yet reviewed by a clinician'), findsNothing);

      await tapText(tester, 'Call Dr Test');
      expect(calls, ['+9779840000000'], reason: 'dialable digits only');
    });

    appTest('URGENT, call fails: tells the user the number to dial by hand',
        (tester) async {
      await pumpApp(tester,
          size: tall,
          overrides: [phoneLauncherProvider.overrideWithValue((n) async => false)],
          beforeStart: (db) async {
        await enableDiabetes(db);
        await addContact(db, 'Dr Test', '9800000000');
      });
      await logSugar(tester, '400');
      await tapText(tester, 'Call Dr Test');
      expect(find.textContaining('Please dial 9800000000 by hand.'), findsOneWidget);
    });

    appTest('URGENT with no contacts saved: says so and offers to add them',
        (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
      });
      await logSugar(tester, '400');
      expect(find.textContaining('No emergency contacts are saved yet'), findsOneWidget);
      await tapText(tester, 'Add emergency contacts');
      expect(find.text('Emergency contacts'), findsWidgets);
    });

    appTest('NO RANGES: no range-based guidance at all, only a way to enter them',
        (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db, withRange: false);
      });
      await logSugar(tester, '500');
      expect(find.text('Enter the doctor\'s ranges in the profile'), findsWidgets);
      expect(find.text('No range to compare with'), findsOneWidget);
      for (final t in ['Prefer', 'Go easy on', 'Other tips',
          'Within his doctor\'s range', 'Outside his doctor\'s range', 'Urgent']) {
        expect(find.text(t), findsNothing, reason: t);
      }
      expect(find.text('Contact his doctor or emergency services now'), findsNothing);
      // The reading itself is still saved.
      expect(find.text('500 mg/dL'), findsOneWidget);
      await tapText(tester, 'Enter the doctor\'s ranges');
      expect(find.text('Blood sugar'), findsWidgets);
    });

    appTest('changing the doctor\'s numbers changes the tier of the SAME reading',
        (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
      });
      await logSugar(tester, '150');
      expect(find.text('Within his doctor\'s range'), findsOneWidget);

      // Doctor tightens the range -> the open screen updates by itself.
      await (db.update(db.targetRanges)).write(
          const TargetRangesCompanion(cautionHigh: Value(140)));
      await tester.pumpAndSettle();
      expect(find.text('Outside his doctor\'s range'), findsOneWidget);

      await (db.update(db.targetRanges)).write(
          const TargetRangesCompanion(urgentHigh: Value(145)));
      await tester.pumpAndSettle();
      expect(find.text('Contact his doctor or emergency services now'), findsOneWidget);

      await db.delete(db.targetRanges).go();
      await tester.pumpAndSettle();
      expect(find.text('Enter the doctor\'s ranges in the profile'), findsWidgets);
      expect(find.text('Contact his doctor or emergency services now'), findsNothing);
    });
  });

  group('units, memory and checks', () {
    appTest('mmol/L toggle converts for the tier and is remembered',
        (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db); // range typed in mg/dL
      });
      await tapText(tester, 'Add reading');
      await tapText(tester, 'mmol/L');
      await tester.enterText(field('Blood sugar number'), '7,0'); // comma ok
      await tapText(tester, 'Save reading');
      expect(find.text('7 mmol/L'), findsOneWidget);
      expect(find.text('Within his doctor\'s range'), findsOneWidget); // 126 mg/dL
      expect((await db.getSettings()).glucoseUnit, GlucoseUnit.mmolL);

      await tapText(tester, 'Back to Home');
      await tapText(tester, 'Add reading');
      final selected = tester.widget<TextField>(field('Blood sugar number'));
      expect(selected.decoration!.suffixText, 'mmol/L', reason: 'remembered');
    });

    appTest('the time-of-day choice is remembered for next time', (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
      });
      await tapText(tester, 'Add reading');
      expect(find.byIcon(Icons.radio_button_checked), findsWidgets);
      await tapText(tester, 'At bedtime');
      await tester.enterText(field('Blood sugar number'), '110');
      await tapText(tester, 'Save reading');
      expect((await db.select(db.readings).getSingle()).tag, 'tagBedtime');
      expect((await db.getSettings()).lastSugarTag, 'tagBedtime');
      await tapText(tester, 'Back to Home');
      await tapText(tester, 'Add reading');
      final row = find.ancestor(
          of: find.text('At bedtime'), matching: find.byType(Semantics));
      expect(tester.getSemantics(row.first).flagsCollection.isSelected,
          Tristate.isTrue); // pre-selected
    });

    appTest('a time-specific range wins for its own context', (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
        await db.into(db.targetRanges).insert(TargetRangesCompanion.insert(
              patientId: 1,
              metricKey: 'blood_sugar',
              tagContext: const Value('tagFasting'),
              unit: const Value('mg/dL'),
              cautionHigh: const Value(100),
            ));
      });
      await tapText(tester, 'Add reading');
      await tapText(tester, 'Fasting (before eating)');
      await tester.enterText(field('Blood sugar number'), '130');
      await tapText(tester, 'Save reading');
      expect(find.text('Outside his doctor\'s range'), findsOneWidget);
    });

    appTest('empty, silly and impossible numbers are refused with a plain message',
        (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
      });
      await tapText(tester, 'Add reading');
      await tapText(tester, 'Save reading');
      expect(find.text('Please type the number shown on the meter.'), findsOneWidget);
      await tester.enterText(field('Blood sugar number'), '99999');
      await tapText(tester, 'Save reading');
      expect(find.textContaining('looks wrong'), findsOneWidget);
      expect(await db.select(db.readings).get(), isEmpty);
    });

    appTest('a note is saved with the reading', (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
      });
      await tapText(tester, 'Add reading');
      await tester.enterText(field('Blood sugar number'), '110');
      await tester.enterText(field('Note (optional)'), 'after a walk');
      await tapText(tester, 'Save reading');
      expect((await db.select(db.readings).getSingle()).note, 'after a walk');
    });
  });

  group('blood pressure', () {
    appTest('two conditions -> "What did you measure?" -> pressure form',
        (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
        await enableHypertension(db);
      });
      await tapText(tester, 'Add reading');
      expect(find.text('What did you measure?'), findsOneWidget);
      await tapText(tester, 'Blood pressure');
      await tester.enterText(field('Top number (systolic)'), '150');
      await tester.enterText(field('Bottom number (diastolic)'), '80');
      await tester.enterText(field('Pulse (optional)'), '72');
      await tapText(tester, 'Save reading');
      expect(find.text('150/80 mmHg'), findsOneWidget);
      expect(find.text('Pulse 72'), findsOneWidget);
      expect(find.text('Outside his doctor\'s range'), findsOneWidget);
      final r = await db.select(db.readings).getSingle();
      expect((r.systolic, r.diastolic, r.pulse, r.metricKey), (150, 80, 72, 'blood_pressure'));
      // BP advice has salt items, not sugar ones.
      expect(find.text('Extra salt added at the table'), findsOneWidget);
      expect(find.text('Sugar in chiya'), findsNothing);
    });

    appTest('the worse of top and bottom decides (diastolic urgent)',
        (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableHypertension(db);
        await addContact(db, 'Dr Test', '9800000000');
      });
      await tapText(tester, 'Add reading');
      await tester.enterText(field('Top number (systolic)'), '120');
      await tester.enterText(field('Bottom number (diastolic)'), '115');
      await tapText(tester, 'Save reading');
      expect(find.text('Contact his doctor or emergency services now'), findsOneWidget);
    });

    appTest('BP 1300/80 is refused, and top <= bottom is refused', (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableHypertension(db);
      });
      await tapText(tester, 'Add reading');
      await tester.enterText(field('Top number (systolic)'), '1300');
      await tester.enterText(field('Bottom number (diastolic)'), '80');
      await tapText(tester, 'Save reading');
      expect(find.textContaining('looks wrong'), findsOneWidget);

      await tester.enterText(field('Top number (systolic)'), '80');
      await tester.enterText(field('Bottom number (diastolic)'), '120');
      await tapText(tester, 'Save reading');
      expect(find.textContaining('top number should be larger'), findsOneWidget);
      expect(await db.select(db.readings).get(), isEmpty);
    });
  });

  group('restrictions and fasting', () {
    appTest('allergy text hides matching ideas; soft food keeps soft ones only',
        (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
        await (db.update(db.patients)).write(const PatientsCompanion(
            allergies: Value('Egg allergy'), softFood: Value(true)));
      });
      await logSugar(tester, '120');
      expect(find.text('A boiled egg'), findsNothing);
      expect(find.text('A small bowl of curd'), findsOneWidget);
      expect(find.text('Roti or dhido, in a moderate portion'), findsNothing,
          reason: 'needs chewing');
    });

    appTest('fasting today adds the doctor note on the result', (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
        await db.updateSettings(const AppSettingsTableCompanion(
            fastingOnDate: Value('2025-04-14')));
      });
      await logSugar(tester, '120');
      expect(
          find.text(
              'Check with his doctor how to handle medicine and readings on fasting days.'),
          findsOneWidget);
    });
  });

  group('Home', () {
    appTest('latest reading with tier chip, and today\'s guidance card',
        (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
      });
      expect(find.text('No readings yet.'), findsOneWidget);
      await logSugar(tester, '200');
      await tapText(tester, 'Back to Home');
      expect(find.text('Latest readings'), findsOneWidget);
      expect(find.text('200 mg/dL'), findsOneWidget);
      expect(find.text('Outside his doctor\'s range'), findsWidgets);
      expect(find.text('Today\'s guidance'), findsOneWidget);
      await tapText(tester, 'See meal ideas and tips');
      expect(find.text('Tell his doctor about this reading.'), findsOneWidget);
    });

    appTest('Add reading with no condition explains what to do', (tester) async {
      await pumpApp(tester, size: tall);
      await tapText(tester, 'Add reading');
      expect(find.textContaining('Choose a health condition in the profile first'),
          findsOneWidget);
    });

    appTest('Doctor report shortcut exists (report arrives in a later phase)',
        (tester) async {
      await pumpApp(tester, size: tall);
      await tapText(tester, 'Doctor report');
      expect(find.text('Coming soon'), findsOneWidget);
    });
  });

  appTest('Nepali + Devanagari digits on the result screen', (tester) async {
    final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
      await enableDiabetes(db);
    });
    await db.updateSettings(const AppSettingsTableCompanion(
        language: Value(AppLanguage.ne), digitStyle: Value(DigitStyle.devanagari)));
    await tester.pumpAndSettle();
    await tapText(tester, 'नाप थप्नुहोस्');
    await tester.enterText(field('सुगरको अंक'), '200');
    await tapText(tester, 'नाप सेभ गर्नुहोस्');
    expect(find.text('२०० mg/dL'), findsOneWidget);
    expect(find.text('डाक्टरले दिएको सीमाबाहिर'), findsOneWidget);
    expect(find.text('यो नापबारे उहाँको डाक्टरलाई भन्नुहोस्।'), findsOneWidget);
    expect(find.text('यसमा कम गर्नुहोस्'), findsOneWidget);
  });

  appTest('screen reader: tier is spoken as words', (tester) async {
    await pumpApp(tester, size: tall, beforeStart: (db) async {
      await enableDiabetes(db);
    });
    await logSugar(tester, '200');
    final handle = tester.ensureSemantics();
    expect(
        find.bySemanticsLabel(RegExp(r'^Outside his doctor.s range\. ')),
        findsOneWidget);
    handle.dispose();
  });

  // ProviderScope import is used by overrides above.
  test('compile guard', () => expect(ProviderScope, isNotNull));
}
