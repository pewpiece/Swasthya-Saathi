import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// The doctor's numbers, exactly as the family typed them.
class RangeInput {
  const RangeInput({
    required this.metricKey,
    this.tagContext,
    this.unit,
    this.urgentLow,
    this.cautionLow,
    this.cautionHigh,
    this.urgentHigh,
    this.doctorPlanText,
    this.warningSignsText,
  });

  final String metricKey;
  final String? tagContext; // null = all times
  final String? unit;
  final double? urgentLow;
  final double? cautionLow;
  final double? cautionHigh;
  final double? urgentHigh;
  final String? doctorPlanText;
  final String? warningSignsText;

  bool get isEmpty =>
      urgentLow == null &&
      cautionLow == null &&
      cautionHigh == null &&
      urgentHigh == null &&
      (doctorPlanText == null || doctorPlanText!.trim().isEmpty) &&
      (warningSignsText == null || warningSignsText!.trim().isEmpty);
}

class RangeRepository {
  RangeRepository(this._db);
  final AppDatabase _db;

  Stream<List<TargetRange>> watchAll() => _db.select(_db.targetRanges).watch();

  Future<List<TargetRange>> getAll() => _db.select(_db.targetRanges).get();

  Future<List<Metric>> getMetrics() => _db.select(_db.metrics).get();

  Stream<List<Metric>> watchMetrics() => _db.select(_db.metrics).watch();

  /// Insert, update, or (when everything is blank) remove the row for
  /// patient + metric + time context.
  Future<void> save(int patientId, RangeInput r) async {
    final existing = await (_db.select(_db.targetRanges)
          ..where((t) =>
              t.patientId.equals(patientId) &
              t.metricKey.equals(r.metricKey) &
              (r.tagContext == null
                  ? t.tagContext.isNull()
                  : t.tagContext.equals(r.tagContext!))))
        .getSingleOrNull();

    String? clean(String? s) => (s == null || s.trim().isEmpty) ? null : s.trim();

    if (r.isEmpty) {
      if (existing != null) {
        await (_db.delete(_db.targetRanges)..where((t) => t.id.equals(existing.id))).go();
      }
      return;
    }
    final companion = TargetRangesCompanion(
      patientId: Value(patientId),
      metricKey: Value(r.metricKey),
      tagContext: Value(r.tagContext),
      unit: Value(r.unit),
      urgentLow: Value(r.urgentLow),
      cautionLow: Value(r.cautionLow),
      cautionHigh: Value(r.cautionHigh),
      urgentHigh: Value(r.urgentHigh),
      doctorPlanText: Value(clean(r.doctorPlanText)),
      warningSignsText: Value(clean(r.warningSignsText)),
    );
    if (existing == null) {
      await _db.into(_db.targetRanges).insert(companion);
    } else {
      await (_db.update(_db.targetRanges)..where((t) => t.id.equals(existing.id)))
          .write(companion);
    }
  }
}
