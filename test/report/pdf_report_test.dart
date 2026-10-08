import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:care_companion/core/dates/date_formatter.dart';
import 'package:care_companion/core/format.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/repositories/medication_repository.dart';
import 'package:care_companion/data/repositories/profile_repository.dart';
import 'package:care_companion/data/repositories/range_repository.dart';
import 'package:care_companion/data/repositories/reading_repository.dart';
import 'package:care_companion/domain/report_data.dart';
import 'package:care_companion/l10n/app_localizations.dart';
import 'package:care_companion/report/pdf_report.dart';
import 'package:care_companion/report/text_image.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// 1x1 PNG, stands in for a rendered Devanagari text picture.
final _tinyPng = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==');

Future<bool> _hasPdfTools() async {
  try {
    return (await Process.run('pdftotext', ['-v'])).exitCode == 0;
  } catch (_) {
    return false;
  }
}

Future<String> _text(Uint8List pdf) async {
  final f = File('${Directory.systemTemp.path}/cc_test_${pdf.length}_${pdf.hashCode}.pdf')
    ..writeAsBytesSync(pdf);
  final r = await Process.run('pdftotext', ['-layout', f.path, '-']);
  f.deleteSync();
  return r.stdout as String;
}

void main() {
  late AppDatabase db;
  late int pid;
  final now = DateTime(2026, 10, 8, 10);
  final fontBytes = File('assets/fonts/NotoSansDevanagari.ttf').readAsBytesSync();

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    pid = await ProfileRepository(db).savePatient(
        name: 'Ram', birthYear: 1940, allergies: 'Peanuts', softFood: true, notes: 'Walks daily');
  });
  tearDown(() => db.close());

  Future<ReportData> sample({
    int days = 14,
    bool ranges = true,
    String name = 'Ram',
    GlucoseUnit unit = GlucoseUnit.mgDl,
  }) async {
    final repo = ProfileRepository(db);
    await repo.savePatient(name: name, birthYear: 1940, allergies: 'Peanuts', softFood: true, notes: 'Walks daily');
    for (final k in ['diabetes', 'hypertension']) {
      await repo.setCondition(pid, k, true);
    }
    final rr = RangeRepository(db);
    if (ranges) {
      await rr.save(pid, const RangeInput(
          metricKey: 'blood_sugar', unit: 'mg/dL', urgentLow: 60, cautionLow: 80, cautionHigh: 160,
          urgentHigh: 300, doctorPlanText: 'Plan: call the clinic', warningSignsText: 'Very sleepy'));
      await rr.save(pid, const RangeInput(metricKey: 'bp_systolic', unit: 'mmHg', cautionLow: 100, cautionHigh: 140, urgentHigh: 180));
      await rr.save(pid, const RangeInput(metricKey: 'bp_diastolic', unit: 'mmHg', cautionLow: 60, cautionHigh: 90, urgentHigh: 110));
    }
    final rd = ReadingRepository(db);
    final values = [110.0, 95.0, 180.0, 130.0, 320.0, 120.0, 105.0, 140.0];
    for (var i = 0; i < values.length; i++) {
      await rd.save(
          patientId: pid, kind: 'blood_sugar', unit: 'mg/dL',
          measuredAt: DateTime(2026, 9, 27 + i, 8, 15), value: values[i],
          tag: i.isEven ? 'tagFasting' : 'tagAfterMeal', note: i == 2 ? 'after sweets' : null);
    }
    for (var i = 0; i < 6; i++) {
      await rd.save(
          patientId: pid, kind: 'blood_pressure', unit: 'mmHg',
          measuredAt: DateTime(2026, 10, 1 + i, 9), systolic: 120 + i * 6, diastolic: 78 + i * 3,
          pulse: 70 + i, tag: 'tagMorning');
    }
    final meds = MedicationRepository(db);
    final m1 = await meds.save(patientId: pid, name: 'Test tablet A', notes: 'after food',
        slots: {DoseSlot.morning, DoseSlot.night}, now: DateTime(2026, 9, 25, 9));
    for (var day = 25; day <= 30; day++) {
      await meds.setTaken(medicationId: m1, slot: DoseSlot.morning, taken: true, now: DateTime(2026, 9, day, 8));
    }
    for (var day = 1; day <= 5; day++) {
      await meds.setTaken(medicationId: m1, slot: DoseSlot.night, taken: true, now: DateTime(2026, 10, day, 21));
    }
    return buildReportData(
      patient: (await repo.getPatient())!,
      enabledConditionKeys: ['diabetes', 'hypertension'],
      metrics: await db.select(db.metrics).get(),
      ranges: await db.select(db.targetRanges).get(),
      readings: await db.select(db.readings).get(),
      meds: await meds.watchAll().first,
      logs: await db.select(db.doseLogs).get(),
      glucoseUnit: unit,
      days: days,
      now: now,
    );
  }

  Future<Uint8List> pdf(ReportData d, {bool bs = false, TextPictureRenderer? renderer}) async {
    final l = await AppL10n.delegate.load(const Locale('en'));
    return buildReportPdf(
      data: d,
      l: l,
      fmt: const Fmt(DigitStyle.latin),
      dates: DateFormatter(l10n: l, style: bs ? DateStyle.bs : DateStyle.ad, digits: DigitStyle.latin),
      fontBytes: fontBytes,
      renderer: renderer,
    );
  }

  test('is a real PDF', () async {
    final bytes = await pdf(await sample());
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(5000));
    // Keep a copy for looking at the pages by eye.
    File('${Directory.systemTemp.path}/care_companion_sample_report.pdf').writeAsBytesSync(bytes);
  });

  test('contains what a doctor needs', () async {
    if (!await _hasPdfTools()) return;
    final txt = await _text(await pdf(await sample()));
    for (final s in [
      'Health summary for Ram',
      'Period: 25 Sep 2026 to 8 Oct 2026',
      'Made on 8 Oct 2026',
      'Age: about 86 years',
      'Diabetes (blood sugar)',
      'Peanuts',
      'Needs soft food',
      'Ranges from his doctor (typed in by the family)',
      'Urgent below',
      'Plan: call the clinic',
      'Very sleepy',
      'Blood sugar: readings',
      'Blood pressure: readings',
      'Average',
      'Within range',
      'Top number (systolic): Grey band',
      'Outside range',
      'In urgent range',
      'after sweets',
      '132/84',
      'Medicines and doses marked as given',
      'Test tablet A',
      'Morning: 6 of 14 doses marked as given (43%)',
      'A dose that is not marked may still have been given',
      'not medical advice',
      'Page 1 of',
    ]) {
      expect(txt, contains(s), reason: s);
    }
  });

  test('no ranges entered: says so, compares nothing, draws no band', () async {
    if (!await _hasPdfTools()) return;
    final txt = await _text(await pdf(await sample(ranges: false)));
    expect(txt, contains('No ranges have been entered'));
    expect(txt, contains('No range entered'));
    expect(txt, contains("No doctor's range was entered, so no band is drawn."));
    expect(txt, isNot(contains('Within range')));
    expect(txt, isNot(contains('In urgent range')));
  });

  test('BS dates are added in brackets, AD stays first', () async {
    if (!await _hasPdfTools()) return;
    final txt = await _text(await pdf(await sample(), bs: true));
    expect(txt, contains('8 Oct 2026 ('));
    expect(txt, contains('BS)'));
  });

  test('mmol/L: chart and summary use the chosen unit, table shows what was typed', () async {
    if (!await _hasPdfTools()) return;
    final txt = await _text(await pdf(await sample(unit: GlucoseUnit.mmolL)));
    expect(txt, contains('shown in mmol/L'));
    expect(txt, contains('110 mg/dL'), reason: 'table keeps the typed value and unit');
  });

  test('28 days works and long reports page correctly', () async {
    if (!await _hasPdfTools()) return;
    final txt = await _text(await pdf(await sample(days: 28)));
    expect(txt, contains('Period: 11 Sep 2026 to 8 Oct 2026'));
    expect(RegExp(r'Page \d+ of \d+').hasMatch(txt), isTrue);
  });

  test('empty report (no readings, no medicines) still produces a valid PDF', () async {
    final repo = ProfileRepository(db);
    final d = buildReportData(
      patient: (await repo.getPatient())!,
      enabledConditionKeys: ['diabetes'],
      metrics: await db.select(db.metrics).get(),
      ranges: const [],
      readings: const [],
      meds: const [],
      logs: const [],
      glucoseUnit: GlucoseUnit.mgDl,
      days: 14,
      now: now,
    );
    final bytes = await pdf(d);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    if (await _hasPdfTools()) {
      final txt = await _text(bytes);
      expect(txt, contains('No readings in this period.'));
      expect(txt, contains('No medicines were listed in the app.'));
    }
  });

  group('Nepali text typed by the family', () {
    test('goes through the picture renderer instead of the PDF text engine', () async {
      final requested = <String>[];
      final d = await sample(name: 'रामबहादुर');
      final bytes = await pdf(d, renderer: (text, size, width) async {
        requested.add(text);
        return TextPicture(Uint8List.fromList(_tinyPng), 80, 14);
      });
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      expect(requested.any((t) => t.contains('रामबहादुर')), isTrue);
      expect(requested.every((t) => needsPicture(t)), isTrue,
          reason: 'only Devanagari text is rendered as a picture');
      if (await _hasPdfTools()) {
        final txt = await _text(bytes);
        expect(txt, isNot(contains('रामबहादुर')), reason: 'not written as (broken) PDF text');
        expect(txt, contains('Blood sugar: readings'), reason: 'English parts stay text');
      }
    });

    test('plain English text is never turned into a picture', () async {
      var calls = 0;
      await pdf(await sample(), renderer: (t, s, w) async {
        calls++;
        return null;
      });
      expect(calls, 0);
    });

    test('needsPicture', () {
      expect(needsPicture('Ram'), isFalse);
      expect(needsPicture('राम'), isTrue);
      expect(needsPicture('Ram राम'), isTrue);
    });
  });

  testWidgets('the real renderer draws shaped Devanagari into a PNG', (tester) async {
    final p = await tester.runAsync(() => renderTextPicture('रामबहादुर श्रेष्ठ', 12, 300));
    expect(p, isNotNull);
    expect(p!.png.take(4).toList(), [0x89, 0x50, 0x4E, 0x47]); // PNG signature
    expect(p.width, greaterThan(20));
    expect(p.height, greaterThan(8));
  });
}
