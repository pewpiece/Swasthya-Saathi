import 'package:drift/drift.dart';

import '../db/app_database.dart';

class ReadingRepository {
  ReadingRepository(this._db);
  final AppDatabase _db;

  Future<int> save({
    required int patientId,
    required String kind, // blood_sugar | blood_pressure
    required String unit,
    required DateTime measuredAt,
    double? value,
    int? systolic,
    int? diastolic,
    int? pulse,
    String? tag,
    String? note,
  }) =>
      _db.into(_db.readings).insert(ReadingsCompanion.insert(
            patientId: patientId,
            metricKey: kind,
            unit: unit,
            measuredAt: measuredAt,
            value: Value(value),
            systolic: Value(systolic),
            diastolic: Value(diastolic),
            pulse: Value(pulse),
            tag: Value(tag),
            note: Value((note == null || note.trim().isEmpty) ? null : note.trim()),
          ));

  Stream<List<Reading>> watchAll() => (_db.select(_db.readings)
        ..orderBy([(t) => OrderingTerm.desc(t.measuredAt), (t) => OrderingTerm.desc(t.id)]))
      .watch();

  Future<void> delete(int id) =>
      (_db.delete(_db.readings)..where((t) => t.id.equals(id))).go();

  Stream<Reading?> watchById(int id) =>
      (_db.select(_db.readings)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Stream<Reading?> watchLatest(String kind) => (_db.select(_db.readings)
        ..where((t) => t.metricKey.equals(kind))
        ..orderBy([(t) => OrderingTerm.desc(t.measuredAt), (t) => OrderingTerm.desc(t.id)])
        ..limit(1))
      .watchSingleOrNull();

  Stream<Reading?> watchLatestAny() => (_db.select(_db.readings)
        ..orderBy([(t) => OrderingTerm.desc(t.measuredAt), (t) => OrderingTerm.desc(t.id)])
        ..limit(1))
      .watchSingleOrNull();
}
