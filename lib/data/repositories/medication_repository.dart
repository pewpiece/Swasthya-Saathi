import 'package:drift/drift.dart';

import '../../core/dates/date_only.dart';
import '../../domain/daily_checklist.dart';
import '../db/app_database.dart';
import '../enums.dart';

class MedicationRepository {
  MedicationRepository(this._db);
  final AppDatabase _db;

  /// All medicines (including removed ones, for history) with their slots.
  Stream<List<MedWithSlots>> watchAll() {
    final query = _db.select(_db.medications).join([
      leftOuterJoin(
        _db.medicationSlots,
        _db.medicationSlots.medicationId.equalsExp(_db.medications.id),
      ),
    ])
      ..orderBy([OrderingTerm.asc(_db.medications.id)]);
    return query.watch().map((rows) {
      final byId = <int, (Medication, List<MedicationSlot>)>{};
      for (final r in rows) {
        final m = r.readTable(_db.medications);
        final entry = byId.putIfAbsent(m.id, () => (m, <MedicationSlot>[]));
        final s = r.readTableOrNull(_db.medicationSlots);
        if (s != null) entry.$2.add(s);
      }
      return [for (final e in byId.values) MedWithSlots(e.$1, e.$2)];
    });
  }

  Future<Medication?> getMedication(int id) =>
      (_db.select(_db.medications)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Set<DoseSlot>> activeSlotsOf(int id) async {
    final rows = await (_db.select(_db.medicationSlots)
          ..where((t) => t.medicationId.equals(id) & t.endedOn.isNull()))
        .get();
    return {for (final r in rows) r.slot};
  }

  /// Creates or updates a medicine and its slots. Removed slots keep their
  /// row (with `endedOn`) so past adherence stays correct.
  Future<int> save({
    int? id,
    required int patientId,
    required String name,
    String? notes,
    required Set<DoseSlot> slots,
    required DateTime now,
  }) async {
    final today = dateKey(now);
    final tomorrow = dateKey(DateTime(now.year, now.month, now.day + 1));
    final cleanNotes = (notes == null || notes.trim().isEmpty) ? null : notes.trim();
    return _db.transaction(() async {
      late final int medId;
      if (id == null) {
        medId = await _db.into(_db.medications).insert(
              MedicationsCompanion.insert(
                patientId: patientId,
                name: name.trim(),
                notes: Value(cleanNotes),
              ),
            );
      } else {
        medId = id;
        await (_db.update(_db.medications)..where((t) => t.id.equals(id))).write(
          MedicationsCompanion(name: Value(name.trim()), notes: Value(cleanNotes)),
        );
      }
      final existing = await (_db.select(_db.medicationSlots)
            ..where((t) => t.medicationId.equals(medId)))
          .get();
      for (final slot in DoseSlot.values) {
        final row = existing.where((e) => e.slot == slot).firstOrNull;
        final want = slots.contains(slot);
        if (want && row == null) {
          await _db.into(_db.medicationSlots).insert(
                MedicationSlotsCompanion.insert(
                  medicationId: medId,
                  slot: slot,
                  startedOn: Value(today),
                ),
              );
        } else if (want && row!.endedOn != null) {
          await _updateSlot(medId, slot, const MedicationSlotsCompanion(endedOn: Value(null)));
        } else if (!want && row != null && row.endedOn == null) {
          // Hide from the checklist from tomorrow; today's tick (if any) stays.
          await _updateSlot(medId, slot, MedicationSlotsCompanion(endedOn: Value(tomorrow)));
        }
      }
      return medId;
    });
  }

  Future<void> _updateSlot(int medId, DoseSlot slot, MedicationSlotsCompanion c) =>
      (_db.update(_db.medicationSlots)
            ..where((t) => t.medicationId.equals(medId) & t.slot.equalsValue(slot)))
          .write(c);

  /// Removes a medicine from this app's list. Never deletes history, and does
  /// not (and cannot) change the real medicine.
  Future<void> remove(int id, DateTime now) async {
    final tomorrow = dateKey(DateTime(now.year, now.month, now.day + 1));
    await _db.transaction(() async {
      await (_db.update(_db.medications)..where((t) => t.id.equals(id)))
          .write(const MedicationsCompanion(active: Value(false)));
      await (_db.update(_db.medicationSlots)
            ..where((t) => t.medicationId.equals(id) & t.endedOn.isNull()))
          .write(MedicationSlotsCompanion(endedOn: Value(tomorrow)));
    });
  }

  // ---- Dose logs ------------------------------------------------------------

  Stream<List<DoseLog>> watchLogsForDay(String dayKey) =>
      (_db.select(_db.doseLogs)..where((t) => t.date.equals(dayKey))).watch();

  Stream<List<DoseLog>> watchLogsBetween(String fromKey, String toKey) =>
      (_db.select(_db.doseLogs)
            ..where((t) => t.date.isBiggerOrEqualValue(fromKey) & t.date.isSmallerOrEqualValue(toKey)))
          .watch();

  /// Ticks or un-ticks one dose. **Only today can be changed**: yesterday's
  /// logs are history and are never edited or deleted.
  Future<void> setTaken({
    required int medicationId,
    required DoseSlot slot,
    required bool taken,
    required DateTime now,
    String? givenBy,
  }) async {
    final today = dateKey(now);
    final companion = DoseLogsCompanion(
      medicationId: Value(medicationId),
      slot: Value(slot),
      date: Value(today),
      taken: Value(taken),
      takenAt: Value(taken ? now : null),
      givenBy: Value(taken ? givenBy : null),
    );
    await _db.into(_db.doseLogs).insert(
          companion,
          onConflict: DoUpdate(
            (_) => companion,
            target: [_db.doseLogs.medicationId, _db.doseLogs.slot, _db.doseLogs.date],
          ),
        );
  }
}
