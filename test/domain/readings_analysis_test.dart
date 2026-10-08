import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/domain/guidance_engine.dart';
import 'package:care_companion/domain/readings_analysis.dart';
import 'package:flutter_test/flutter_test.dart';

Reading r(int id, DateTime at,
        {String kind = 'blood_sugar',
        double? value,
        int? sys,
        int? dia,
        int? pulse,
        String unit = 'mg/dL',
        String? tag}) =>
    Reading(
        id: id,
        patientId: 1,
        metricKey: kind,
        value: value,
        systolic: sys,
        diastolic: dia,
        pulse: pulse,
        unit: unit,
        tag: tag,
        measuredAt: at,
        note: null);

void main() {
  group('readingsInPeriod', () {
    final all = [
      r(1, DateTime(2026, 10, 1, 8), value: 100),
      r(2, DateTime(2026, 10, 7, 23, 59), value: 110),
      r(3, DateTime(2026, 10, 8, 0, 0), value: 120),
      r(4, DateTime(2026, 10, 8, 23, 59), value: 130),
      r(5, DateTime(2026, 10, 9, 0, 0), value: 140),
      r(6, DateTime(2026, 10, 8, 9), sys: 120, dia: 80, kind: 'blood_pressure'),
    ];
    test('whole days at both ends, only the right kind, oldest first', () {
      final p = readingsInPeriod(all,
          kind: 'blood_sugar', start: DateTime(2026, 10, 7), end: DateTime(2026, 10, 8, 3));
      expect(p.map((e) => e.id), [2, 3, 4]);
    });
    test('empty when nothing is in range', () {
      expect(
          readingsInPeriod(all,
              kind: 'blood_sugar', start: DateTime(2020), end: DateTime(2020, 2)),
          isEmpty);
    });
    test('same timestamp keeps a stable order by id', () {
      final t = DateTime(2026, 10, 8, 9);
      final p = readingsInPeriod([r(9, t, value: 1), r(8, t, value: 2)],
          kind: 'blood_sugar', start: t, end: t);
      expect(p.map((e) => e.id), [8, 9]);
    });
  });

  group('series and units', () {
    test('mixed units are converted to the chosen display unit', () {
      final readings = [
        r(1, DateTime(2026, 10, 1), value: 126, unit: 'mg/dL'),
        r(2, DateTime(2026, 10, 2), value: 7.0, unit: 'mmol/L'),
      ];
      final mmol = seriesFor(readings, 'blood_sugar', 'mmol/L').single.points.map((p) => p.y);
      expect(mmol, [7.0, 7.0]);
      final mg = seriesFor(readings, 'blood_sugar', 'mg/dL').single.points.map((p) => p.y);
      expect(mg, [126.0, 126.0]);
    });
    test('blood pressure gives a top and a bottom line', () {
      final s = seriesFor([
        r(1, DateTime(2026, 10, 1), kind: 'blood_pressure', sys: 130, dia: 85, pulse: 70),
        r(2, DateTime(2026, 10, 2), kind: 'blood_pressure', sys: 140, dia: 90),
      ], 'blood_pressure', 'mmHg');
      expect(s.map((e) => e.metricKey), ['bp_systolic', 'bp_diastolic']);
      expect(s[0].points.map((p) => p.y), [130, 140]);
      expect(s[1].points.map((p) => p.y), [85, 90]);
    });
  });

  group('stats', () {
    test('average, min, max, count; rounded like a meter', () {
      final s = statsOf([100, 101, 104], 'mg/dL');
      expect((s.count, s.average, s.min, s.max), (3, 102.0, 100, 104));
      final m = statsOf([5.5, 6.0, 6.1], 'mmol/L');
      expect(m.average, 5.9);
    });
    test('empty list', () {
      final s = statsOf([], 'mg/dL');
      expect((s.count, s.average, s.min, s.max), (0, null, null, null));
    });
  });

  group('band from the doctor\'s ranges', () {
    const mg = RangeSpec(
        metricKey: 'blood_sugar',
        unit: 'mg/dL',
        urgentLow: 60,
        cautionLow: 90,
        cautionHigh: 150,
        urgentHigh: 300);
    test('none entered -> no band (never invented)', () {
      expect(bandFor('blood_sugar', const [], 'mg/dL'), isNull);
      expect(bandFor('blood_sugar', const [RangeSpec(metricKey: 'blood_sugar', doctorPlanText: 'x')], 'mg/dL'),
          isNull);
    });
    test('same unit', () {
      final b = bandFor('blood_sugar', [mg], 'mg/dL')!;
      expect((b.cautionLow, b.cautionHigh, b.urgentLow, b.urgentHigh), (90, 150, 60, 300));
      expect(b.hasShade, isTrue);
    });
    test('converted to mmol/L for the chart', () {
      final b = bandFor('blood_sugar', [mg], 'mmol/L')!;
      expect(b.cautionLow, 5.0);
      expect(b.cautionHigh, 8.3);
    });
    test('a context-only range is not used for the band', () {
      const fasting = RangeSpec(
          metricKey: 'blood_sugar', tagContext: 'tagFasting', unit: 'mg/dL', cautionHigh: 100);
      expect(bandFor('blood_sugar', [fasting], 'mg/dL'), isNull);
    });
    test('only urgent numbers: no shaded area but lines exist', () {
      const only = RangeSpec(metricKey: 'blood_sugar', unit: 'mg/dL', urgentHigh: 300);
      final b = bandFor('blood_sugar', [only], 'mg/dL')!;
      expect(b.hasShade, isFalse);
      expect(b.urgentHigh, 300);
    });
  });

  test('status uses the current ranges', () {
    const rg = RangeSpec(
        metricKey: 'blood_sugar', unit: 'mg/dL', cautionHigh: 150, urgentHigh: 300);
    final x = r(1, DateTime(2026), value: 200);
    expect(statusOf(x, [rg]), Tier.outOfRange);
    expect(statusOf(x, const []), Tier.unknown);
    expect(statusOf(r(2, DateTime(2026), value: 400), [rg]), Tier.urgent);
  });

  group('niceTicks', () {
    test('round numbers inside the range', () {
      expect(niceTicks(29, 351), [100, 200, 300]);
      expect(niceTicks(66, 192), [75, 100, 125, 150, 175]);
      expect(niceTicks(4.2, 9.1), [5, 6, 7, 8, 9]);
      expect(niceTicks(0, 10), [0, 5, 10]);
    });
    test('always inside, never more than about 7, and a flat range gives one', () {
      for (final (a, b) in [(1.0, 2.0), (95.0, 99.0), (40.0, 400.0), (0.5, 1.5), (3.1, 3.3)]) {
        final t = niceTicks(a, b);
        expect(t, isNotEmpty);
        expect(t.every((x) => x >= a && x <= b), isTrue, reason: '$a-$b: $t');
        expect(t.length, lessThanOrEqualTo(8));
      }
      expect(niceTicks(5, 5), [5]);
    });
  });
}
