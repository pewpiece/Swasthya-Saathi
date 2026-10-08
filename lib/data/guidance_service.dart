import '../domain/guidance_content.dart';
import '../domain/guidance_engine.dart';
import 'db/app_database.dart';

RangeSpec rangeSpecOf(TargetRange r) => RangeSpec(
      metricKey: r.metricKey,
      tagContext: r.tagContext,
      unit: r.unit,
      urgentLow: r.urgentLow,
      cautionLow: r.cautionLow,
      cautionHigh: r.cautionHigh,
      urgentHigh: r.urgentHigh,
      doctorPlanText: r.doctorPlanText,
      warningSignsText: r.warningSignsText,
    );

ReadingInput readingInputOf(Reading r) => ReadingInput(
      kind: r.metricKey,
      unit: r.unit,
      value: r.value,
      systolic: r.systolic,
      diastolic: r.diastolic,
      pulse: r.pulse,
      tag: r.tag,
    );

/// Guidance for a stored reading, computed NOW from the doctor's current
/// numbers (the tier is never stored, so editing a range updates it at once).
GuidanceResult computeGuidance({
  required Reading reading,
  required List<TargetRange> ranges,
  required List<Metric> metrics,
  required GuidanceLibrary library,
  required Patient? patient,
  required bool fastingToday,
}) {
  final condition = metrics
      .where((m) => m.readingKey == reading.metricKey)
      .map((m) => m.conditionKey)
      .firstOrNull;
  return GuidanceEngine.evaluate(
    reading: readingInputOf(reading),
    ranges: ranges.map(rangeSpecOf).toList(),
    content: [
      ...?library['general'],
      if (condition != null) ...?library[condition],
    ],
    restrictions: Restrictions(
      allergies: patient?.allergies,
      softFood: patient?.softFood ?? false,
      fastingToday: fastingToday,
    ),
  );
}
