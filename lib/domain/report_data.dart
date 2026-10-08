import '../core/dates/date_only.dart';
import '../data/db/app_database.dart';
import '../data/enums.dart';
import 'daily_checklist.dart';
import 'guidance_engine.dart';
import 'readings_analysis.dart';

/// One row of "ranges from his doctor", exactly as the family typed it.
class ReportRangeRow {
  const ReportRangeRow({
    required this.metricKey,
    this.tagContext,
    this.unit,
    this.urgentLow,
    this.cautionLow,
    this.cautionHigh,
    this.urgentHigh,
    this.plan,
    this.warning,
  });
  final String metricKey;
  final String? tagContext;
  final String? unit;
  final double? urgentLow, cautionLow, cautionHigh, urgentHigh;
  final String? plan;
  final String? warning;
}

/// One reading with how it compares with the doctor's range today.
class ReportReading {
  const ReportReading(this.reading, this.tier);
  final Reading reading;
  final Tier tier;
}

/// A measure (blood sugar / blood pressure) over the period.
class ReportSection {
  const ReportSection({
    required this.kind,
    required this.unit,
    required this.rows,
    required this.series,
    required this.band,
    required this.stats,
  });
  final String kind;
  final String unit;
  final List<ReportReading> rows; // oldest first
  final List<ChartSeries> series;
  final RangeBand? band;

  /// (metric key, stats): blood_sugar | bp_systolic, bp_diastolic, pulse.
  final List<(String, Stats)> stats;
}

class ReportMed {
  const ReportMed(this.name, this.notes, this.slots);
  final String name;
  final String? notes;
  final Set<DoseSlot> slots;
}

class SlotTotals {
  const SlotTotals(this.expected, this.taken);
  final int expected;
  final int taken;
  int get percent => expected == 0 ? 0 : (taken * 100 / expected).round();
}

/// Everything the PDF shows. Built from the database rows; contains no
/// medical thresholds of its own.
class ReportData {
  const ReportData({
    required this.patientName,
    required this.age,
    required this.conditionKeys,
    required this.allergies,
    required this.softFood,
    required this.notes,
    required this.start,
    required this.end,
    required this.generatedAt,
    required this.ranges,
    required this.sections,
    required this.meds,
    required this.days,
    required this.morning,
    required this.night,
  });

  final String patientName;
  final int? age;
  final List<String> conditionKeys;
  final String? allergies;
  final bool softFood;
  final String? notes;
  final DateTime start;
  final DateTime end;
  final DateTime generatedAt;
  final List<ReportRangeRow> ranges;
  final List<ReportSection> sections;
  final List<ReportMed> meds;

  /// Oldest day first.
  final List<AdherenceDay> days;
  final SlotTotals morning;
  final SlotTotals night;

  int get readingCount => sections.fold(0, (a, s) => a + s.rows.length);
}

const _kindOrder = ['blood_sugar', 'blood_pressure'];

ReportData buildReportData({
  required Patient patient,
  required List<String> enabledConditionKeys,
  required List<Metric> metrics,
  required List<TargetRange> ranges,
  required List<Reading> readings,
  required List<MedWithSlots> meds,
  required List<DoseLog> logs,
  required GlucoseUnit glucoseUnit,
  required int days,
  required DateTime now,
}) {
  final end = DateTime(now.year, now.month, now.day);
  final start = DateTime(end.year, end.month, end.day - (days - 1));
  final specs = [
    for (final r in ranges)
      RangeSpec(
        metricKey: r.metricKey,
        tagContext: r.tagContext,
        unit: r.unit,
        urgentLow: r.urgentLow,
        cautionLow: r.cautionLow,
        cautionHigh: r.cautionHigh,
        urgentHigh: r.urgentHigh,
        doctorPlanText: r.doctorPlanText,
        warningSignsText: r.warningSignsText,
      ),
  ];

  // Kinds: those of the conditions switched on, plus any with readings in the
  // period (so nothing the family logged is left out).
  final enabledKinds = {
    for (final m in metrics)
      if (enabledConditionKeys.contains(m.conditionKey)) m.readingKey,
  };
  final sections = <ReportSection>[];
  for (final kind in _kindOrder) {
    final inPeriod = readingsInPeriod(
      readings,
      kind: kind,
      start: start,
      end: end,
    );
    if (!enabledKinds.contains(kind) && inPeriod.isEmpty) continue;
    final isSugar = kind == 'blood_sugar';
    final unit = isSugar
        ? (glucoseUnit == GlucoseUnit.mmolL ? 'mmol/L' : 'mg/dL')
        : 'mmHg';
    final series = seriesFor(inPeriod, kind, unit);
    List<double> ys(int i) => series[i].points.map((p) => p.y).toList();
    sections.add(
      ReportSection(
        kind: kind,
        unit: unit,
        rows: [for (final r in inPeriod) ReportReading(r, statusOf(r, specs))],
        series: series,
        band: bandFor(isSugar ? 'blood_sugar' : 'bp_systolic', specs, unit),
        stats: isSugar
            ? [('blood_sugar', statsOf(ys(0), unit))]
            : [
                ('bp_systolic', statsOf(ys(0), unit)),
                ('bp_diastolic', statsOf(ys(1), unit)),
                (
                  'pulse',
                  statsOf([
                    for (final r in inPeriod)
                      if (r.pulse != null) r.pulse!.toDouble(),
                  ], 'bpm'),
                ),
              ],
      ),
    );
  }

  final dayKeys = [
    for (var i = days - 1; i >= 0; i--)
      dateKey(DateTime(end.year, end.month, end.day - i)),
  ];
  final adherence = buildAdherence(meds: meds, logs: logs, dayKeys: dayKeys);
  SlotTotals total(SlotAdherence Function(AdherenceDay) pick) => SlotTotals(
    adherence.fold(0, (a, d) => a + pick(d).expected),
    adherence.fold(0, (a, d) => a + pick(d).taken),
  );

  return ReportData(
    patientName: patient.name,
    age: patient.birthYear == null ? null : now.year - patient.birthYear!,
    conditionKeys: enabledConditionKeys,
    allergies: patient.allergies,
    softFood: patient.softFood,
    notes: patient.notes,
    start: start,
    end: end,
    generatedAt: now,
    ranges: [
      for (final r in ranges)
        if (r.urgentLow != null ||
            r.cautionLow != null ||
            r.cautionHigh != null ||
            r.urgentHigh != null ||
            (r.doctorPlanText ?? '').isNotEmpty ||
            (r.warningSignsText ?? '').isNotEmpty)
          ReportRangeRow(
            metricKey: r.metricKey,
            tagContext: r.tagContext,
            unit: r.unit,
            urgentLow: r.urgentLow,
            cautionLow: r.cautionLow,
            cautionHigh: r.cautionHigh,
            urgentHigh: r.urgentHigh,
            plan: r.doctorPlanText,
            warning: r.warningSignsText,
          ),
    ],
    sections: sections,
    meds: [
      for (final m in meds)
        // Active now, or in use at some point of the period.
        if (m.medication.active ||
            m.slots.any(
              (s) =>
                  slotExpectedOn(s, dateKey(end)) ||
                  (s.endedOn ?? '').compareTo(dateKey(start)) > 0,
            ))
          ReportMed(m.medication.name, m.medication.notes, m.activeSlots),
    ],
    days: adherence,
    morning: total((d) => d.morning),
    night: total((d) => d.night),
  );
}
