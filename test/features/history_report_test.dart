import 'dart:typed_data';

import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/repositories/reading_repository.dart';
import 'package:care_companion/report/report_providers.dart';
import 'package:drift/drift.dart' show Value;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

Future<void> tapText(WidgetTester t, String text) async {
  await t.ensureVisible(find.text(text).first);
  await t.tap(find.text(text).first);
  await t.pumpAndSettle();
}

Future<void> openHistory(WidgetTester t) async {
  await t.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text('History')));
  await t.pumpAndSettle();
}

/// Sugar readings at 09:00 on the given days before "today" (2025-04-14).
Future<void> sugars(AppDatabase db, Map<int, double> daysAgo, {String unit = 'mg/dL', String? tag}) async {
  final repo = ReadingRepository(db);
  for (final e in daysAgo.entries) {
    await repo.save(
        patientId: 1, kind: 'blood_sugar', unit: unit,
        measuredAt: DateTime(2025, 4, 14 - e.key, 9), value: e.value, tag: tag);
  }
}

void main() {
  const tall = Size(411, 5000);

  group('History', () {
    appTest('no conditions and no readings: friendly empty state', (tester) async {
      await pumpApp(tester, size: tall);
      await openHistory(tester);
      expect(find.text('No readings yet'), findsOneWidget);
      expect(find.text('Add a reading and it will appear here, with a chart.'), findsOneWidget);
    });

    appTest('chart, summary and list with tier words; range band is explained',
        (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
        await sugars(db, {10: 100, 5: 200, 3: 400, 1: 120}, tag: 'tagFasting');
      });
      await openHistory(tester);
      expect(find.byType(LineChart), findsOneWidget);
      expect(find.text('Chart (mg/dL)'), findsOneWidget);
      expect(find.text('Readings: 4'), findsOneWidget);
      expect(find.textContaining('Average: 205'), findsOneWidget);
      expect(find.textContaining('Lowest: 100'), findsOneWidget);
      expect(find.textContaining('Highest: 400'), findsOneWidget);
      expect(find.text("Shaded area: his doctor's range, 80 to 160 mg/dL"), findsOneWidget);
      expect(find.text('Dashed lines: the urgent limits his doctor gave'), findsOneWidget);
      // List: newest first, each with an icon + words.
      expect(find.text('Within his doctor\'s range'), findsNWidgets(2));
      expect(find.text('Outside his doctor\'s range'), findsOneWidget);
      expect(find.text('Urgent'), findsOneWidget);
      final newest = tester.getTopLeft(find.text('120 mg/dL')).dy;
      final oldest = tester.getTopLeft(find.text('100 mg/dL')).dy;
      expect(newest, lessThan(oldest));
    });

    appTest('the chart has a spoken summary for the screen reader', (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
        await sugars(db, {10: 100, 1: 120});
      });
      await openHistory(tester);
      final handle = tester.ensureSemantics();
      expect(find.bySemanticsLabel(RegExp(r'^Chart of 2 readings from 4 Apr 2025 to 13 Apr 2025\. Lowest 100, highest 120\.')),
          findsOneWidget);
      handle.dispose();
    });

    appTest('no ranges entered: nothing is shaded and it says so', (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db, withRange: false);
        await sugars(db, {2: 150});
      });
      await openHistory(tester);
      expect(find.text('No range from his doctor has been entered, so nothing is shaded.'), findsOneWidget);
      expect(find.text('No range to compare with'), findsOneWidget);
    });

    appTest('period: 2 weeks vs 4 weeks vs 3 months', (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
        await sugars(db, {2: 100, 20: 110, 60: 120, 200: 130});
      });
      await openHistory(tester);
      expect(find.text('Readings: 1'), findsOneWidget);
      await tapText(tester, 'Last 4 weeks');
      expect(find.text('Readings: 2'), findsOneWidget);
      await tapText(tester, 'Last 3 months');
      expect(find.text('Readings: 3'), findsOneWidget);
      expect(find.text('130 mg/dL'), findsNothing, reason: '200 days ago is outside 3 months');
    });

    appTest('blood sugar and blood pressure each have their own chart', (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
        await enableHypertension(db);
        await sugars(db, {1: 100});
        await ReadingRepository(db).save(
            patientId: 1, kind: 'blood_pressure', unit: 'mmHg',
            measuredAt: DateTime(2025, 4, 12, 9), systolic: 150, diastolic: 95, pulse: 70);
      });
      await openHistory(tester);
      expect(find.text('Chart (mg/dL)'), findsOneWidget);
      await tapText(tester, 'Blood pressure');
      expect(find.text('Chart (mmHg)'), findsOneWidget);
      expect(find.text('150/95 mmHg'), findsOneWidget);
      expect(find.text('Top number: round dots, solid line'), findsOneWidget);
      expect(find.text('Bottom number: square dots, dashed line'), findsOneWidget);
      expect(find.text('Outside his doctor\'s range'), findsOneWidget);
      expect(find.byType(LineChart), findsOneWidget);
      final chart = tester.widget<LineChart>(find.byType(LineChart));
      expect(chart.data.lineBarsData.length, 2, reason: 'top and bottom');
    });

    appTest('mmol/L display unit converts old mg/dL readings', (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
        await sugars(db, {1: 126});
      });
      await db.updateSettings(const AppSettingsTableCompanion(glucoseUnit: Value(GlucoseUnit.mmolL)));
      await tester.pumpAndSettle();
      await openHistory(tester);
      expect(find.text('Chart (mmol/L)'), findsOneWidget);
      expect(find.textContaining('Average: 7'), findsOneWidget);
      expect(find.text('126 mg/dL'), findsOneWidget, reason: 'the list keeps what was typed');
    });

    appTest('Nepali, BS dates and Devanagari digits', (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
        await sugars(db, {1: 120});
      });
      await db.updateSettings(const AppSettingsTableCompanion(
          language: Value(AppLanguage.ne),
          dateStyle: Value(DateStyle.bs),
          digitStyle: Value(DigitStyle.devanagari)));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text('इतिहास')));
      await tester.pumpAndSettle();
      expect(find.text('१२० mg/dL'), findsOneWidget);
      expect(find.textContaining('वि.सं.'), findsWidgets);
      expect(find.text('नाप: १'), findsOneWidget);
    });

    appTest('open a reading, delete it (with confirmation), it leaves the history',
        (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
        await sugars(db, {2: 100, 1: 120});
      });
      await openHistory(tester);
      await tapText(tester, '120 mg/dL');
      await tester.tap(find.byTooltip('Delete this reading'));
      await tester.pumpAndSettle();
      expect(find.textContaining('This cannot be undone'), findsOneWidget);
      await tapText(tester, 'Keep it');
      expect((await db.select(db.readings).get()).length, 2);
      await tester.tap(find.byTooltip('Delete this reading'));
      await tester.pumpAndSettle();
      await tapText(tester, 'Delete');
      expect((await db.select(db.readings).get()).length, 1);
      expect(find.text('120 mg/dL'), findsNothing);
      expect(find.text('100 mg/dL'), findsOneWidget);
    });

    appTest('a typo on the URGENT screen can be deleted too', (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) async {
        await enableDiabetes(db);
      });
      await tapText(tester, 'Add reading');
      await tester.enterText(
          find.byWidgetPredicate((w) => w is TextField && w.decoration?.labelText == 'Blood sugar number'), '400');
      await tapText(tester, 'Save reading');
      expect(find.text('Contact his doctor or emergency services now'), findsOneWidget);
      await tapText(tester, 'Delete this reading');
      await tapText(tester, 'Delete');
      expect(await db.select(db.readings).get(), isEmpty);
      expect(find.text("Ram's day"), findsOneWidget);
    });
  });

  group('Doctor report screen', () {
    PdfActions fake(List<({String kind, Uint8List bytes, String name})> log) => PdfActions(
          share: (b, n) async => log.add((kind: 'share', bytes: b, name: n)),
          preview: (b, n) async => log.add((kind: 'preview', bytes: b, name: n)),
        );

    appTest('Home -> Doctor report -> Share: two taps, 2 weeks already chosen',
        (tester) async {
      final log = <({String kind, Uint8List bytes, String name})>[];
      await pumpApp(tester, size: tall, overrides: [pdfActionsProvider.overrideWithValue(fake(log))],
          beforeStart: (db) async {
        await enableDiabetes(db);
        await sugars(db, {2: 100, 20: 110});
        await addMed(db, 'Test tablet', {DoseSlot.morning});
      });
      await tester.tap(find.text('Doctor report')); // tap 1
      await tester.pumpAndSettle();
      expect(find.text('The report will include 1 readings and 1 medicines.'), findsOneWidget);
      await tester.tap(find.text('Share PDF')); // tap 2
      await tester.pumpAndSettle();
      expect(log.length, 1);
      expect(log.single.kind, 'share');
      expect(String.fromCharCodes(log.single.bytes.take(5)), '%PDF-');
      expect(log.single.name, 'care_companion_report_2025-04-14.pdf');
      expect(log.single.name.toLowerCase(), isNot(contains('ram')), reason: 'no name in the file name');
    });

    appTest('4 weeks includes more; Preview uses the print/preview path', (tester) async {
      final log = <({String kind, Uint8List bytes, String name})>[];
      await pumpApp(tester, size: tall, overrides: [pdfActionsProvider.overrideWithValue(fake(log))],
          beforeStart: (db) async {
        await enableDiabetes(db);
        await sugars(db, {2: 100, 20: 110});
      });
      await tapText(tester, 'Doctor report');
      await tapText(tester, 'Last 4 weeks');
      expect(find.text('The report will include 2 readings and 0 medicines.'), findsOneWidget);
      await tapText(tester, 'Preview or print');
      expect(log.single.kind, 'preview');
    });

    appTest('explains it is English, private, and stays on the phone', (tester) async {
      await pumpApp(tester, size: tall);
      await tapText(tester, 'Doctor report');
      expect(find.textContaining('written in English so any doctor can read it'), findsOneWidget);
      expect(find.textContaining('stays on this phone until you choose to share it'), findsOneWidget);
    });

    appTest('a failure is explained in plain words and can be retried', (tester) async {
      var calls = 0;
      await pumpApp(tester, size: tall, overrides: [
        reportMakerProvider.overrideWithValue((days) async {
          calls++;
          throw StateError('boom');
        }),
      ]);
      await tapText(tester, 'Doctor report');
      await tapText(tester, 'Share PDF');
      expect(find.text('The report could not be made. Please try again.'), findsOneWidget);
      await tapText(tester, 'Share PDF');
      expect(calls, 2);
    });

    appTest('Nepali screen, English report note', (tester) async {
      final db = await pumpApp(tester, size: tall);
      await db.updateSettings(const AppSettingsTableCompanion(language: Value(AppLanguage.ne)));
      await tester.pumpAndSettle();
      await tapText(tester, 'डाक्टरको रिपोर्ट');
      expect(find.text('PDF पठाउनुहोस्'), findsOneWidget);
      expect(find.textContaining('अंग्रेजीमा लेखिन्छ'), findsOneWidget);
    });
  });
}
