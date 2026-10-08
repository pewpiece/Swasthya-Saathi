import '../data/db/app_database.dart';
import 'guidance_engine.dart';

/// Pure helpers shared by the History screen and the doctor report.
/// No medical numbers live here: every band and status comes from the ranges
/// the family typed in.

/// Readings measured on or after [start]'s day and up to the end of [end]'s
/// day, oldest first.
List<Reading> readingsInPeriod(
  Iterable<Reading> all, {
  required String kind,
  required DateTime start,
  required DateTime end,
}) {
  final from = DateTime(start.year, start.month, start.day);
  final to = DateTime(end.year, end.month, end.day + 1); // exclusive
  final list = [
    for (final r in all)
      if (r.metricKey == kind && !r.measuredAt.isBefore(from) && r.measuredAt.isBefore(to)) r,
  ]..sort((a, b) {
      final c = a.measuredAt.compareTo(b.measuredAt);
      return c != 0 ? c : a.id.compareTo(b.id);
    });
  return list;
}

/// What a meter shows: 1 decimal for mmol/L, whole numbers otherwise.
double roundForUnit(double v, String unit) =>
    unit == 'mmol/L' ? (v * 10).round() / 10 : v.roundToDouble();

class ChartPoint {
  const ChartPoint(this.at, this.y);
  final DateTime at;
  final double y;
}

/// One line on a chart (blood sugar, or top / bottom number of blood pressure).
class ChartSeries {
  const ChartSeries(this.metricKey, this.points);
  final String metricKey; // blood_sugar | bp_systolic | bp_diastolic
  final List<ChartPoint> points;
}

/// Lines for a reading kind, in [unit] (blood sugar is converted; pressure is
/// always mmHg).
List<ChartSeries> seriesFor(List<Reading> readings, String kind, String unit) {
  if (kind == 'blood_pressure') {
    return [
      ChartSeries('bp_systolic', [
        for (final r in readings)
          if (r.systolic != null) ChartPoint(r.measuredAt, r.systolic!.toDouble()),
      ]),
      ChartSeries('bp_diastolic', [
        for (final r in readings)
          if (r.diastolic != null) ChartPoint(r.measuredAt, r.diastolic!.toDouble()),
      ]),
    ];
  }
  return [
    ChartSeries('blood_sugar', [
      for (final r in readings)
        if (r.value != null)
          ChartPoint(
            r.measuredAt,
            roundForUnit(
                GuidanceEngine.convert('blood_sugar', r.value!, r.unit, unit), unit),
          ),
    ]),
  ];
}

class Stats {
  const Stats({required this.count, this.average, this.min, this.max});
  final int count;
  final double? average;
  final double? min;
  final double? max;
}

Stats statsOf(List<double> values, String unit) {
  if (values.isEmpty) return const Stats(count: 0);
  final sum = values.fold<double>(0, (a, b) => a + b);
  return Stats(
    count: values.length,
    average: roundForUnit(sum / values.length, unit),
    min: values.reduce((a, b) => a < b ? a : b),
    max: values.reduce((a, b) => a > b ? a : b),
  );
}

/// The doctor's "all times" numbers for one metric, converted to [unit], for
/// shading on a chart. Null when the family has not entered any numbers.
class RangeBand {
  const RangeBand({this.urgentLow, this.cautionLow, this.cautionHigh, this.urgentHigh});
  final double? urgentLow;
  final double? cautionLow;
  final double? cautionHigh;
  final double? urgentHigh;

  bool get hasShade => cautionLow != null || cautionHigh != null;
}

RangeBand? bandFor(String metricKey, List<RangeSpec> ranges, String unit) {
  final spec = GuidanceEngine.pickRange(ranges, metricKey, null);
  if (spec == null) return null;
  double? c(double? v) => v == null
      ? null
      : roundForUnit(
          GuidanceEngine.convert(metricKey, v, spec.unit ?? unit, unit), unit);
  return RangeBand(
    urgentLow: c(spec.urgentLow),
    cautionLow: c(spec.cautionLow),
    cautionHigh: c(spec.cautionHigh),
    urgentHigh: c(spec.urgentHigh),
  );
}

/// Tier of one saved reading under the CURRENT ranges (never stored).
Tier statusOf(Reading r, List<RangeSpec> ranges) => GuidanceEngine.evaluate(
      reading: ReadingInput(
        kind: r.metricKey,
        unit: r.unit,
        value: r.value,
        systolic: r.systolic,
        diastolic: r.diastolic,
        pulse: r.pulse,
        tag: r.tag,
      ),
      ranges: ranges,
      content: const [],
    ).tier;

/// Round-number axis ticks between [min] and [max] (about [target] of them),
/// e.g. 100, 200, 300 instead of 96, 148, 201.
List<double> niceTicks(double min, double max, {int target = 4}) {
  if (!(max > min)) return [min];
  final raw = (max - min) / (target - 1);
  var mag = 1.0;
  while (raw / mag >= 10) {
    mag *= 10;
  }
  while (raw / mag < 1) {
    mag /= 10;
  }
  List<double> ticksFor(double step) => [
        for (var i = (min / step).ceil(); i <= (max / step).floor(); i++)
          double.parse((i * step).toStringAsFixed(6)),
      ];
  List<double>? best;
  double bestScore = double.infinity;
  for (final m in [mag / 10, mag, mag * 10]) {
    for (final f in [1.0, 2.0, 2.5, 5.0]) {
      final t = ticksFor(f * m);
      if (t.length < 2) continue;
      final score = (t.length - target).abs() + (t.length > target ? 0.1 : 0.0); // tie: fewer labels
      if (score < bestScore) {
        bestScore = score;
        best = t;
      }
    }
  }
  return best ?? ticksFor(raw);
}
