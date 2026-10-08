import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../enums.dart';

/// Patient, conditions and emergency contacts. Single patient in the MVP.
class ProfileRepository {
  ProfileRepository(this._db);
  final AppDatabase _db;

  Stream<Patient?> watchPatient() =>
      (_db.select(_db.patients)..limit(1)).watchSingleOrNull();

  Future<Patient?> getPatient() =>
      (_db.select(_db.patients)..limit(1)).getSingleOrNull();

  /// Creates the patient on first save, updates afterwards. Returns the id.
  Future<int> savePatient({
    required String name,
    int? birthYear,
    String? notes,
    String? allergies,
    bool? softFood,
  }) async {
    final existing = await getPatient();
    String? clean(String? s) => (s == null || s.trim().isEmpty) ? null : s.trim();
    if (existing == null) {
      return _db.into(_db.patients).insert(PatientsCompanion.insert(
            name: name.trim(),
            birthYear: Value(birthYear),
            notes: Value(clean(notes)),
            allergies: Value(clean(allergies)),
            softFood: Value(softFood ?? false),
          ));
    }
    await (_db.update(_db.patients)..where((t) => t.id.equals(existing.id)))
        .write(PatientsCompanion(
      name: Value(name.trim()),
      birthYear: Value(birthYear),
      notes: Value(clean(notes)),
      allergies: allergies == null ? const Value.absent() : Value(clean(allergies)),
      softFood: softFood == null ? const Value.absent() : Value(softFood),
    ));
    return existing.id;
  }

  /// Saves allergies / soft-food (a wizard step) without touching other fields.
  Future<void> saveFood({required String? allergies, required bool softFood}) async {
    final p = await getPatient();
    if (p == null) return;
    await (_db.update(_db.patients)..where((t) => t.id.equals(p.id))).write(
      PatientsCompanion(
        allergies: Value(
          (allergies == null || allergies.trim().isEmpty) ? null : allergies.trim(),
        ),
        softFood: Value(softFood),
      ),
    );
  }

  // ---- Conditions ---------------------------------------------------------

  Stream<List<PatientCondition>> watchConditions() =>
      _db.select(_db.conditions).watch();

  /// The condition keys the app knows about, read from the Metrics catalogue
  /// (so a new condition is data, not code).
  Future<List<String>> availableConditionKeys() async {
    final rows = await _db.select(_db.metrics).get();
    final keys = <String>[];
    for (final r in rows) {
      if (!keys.contains(r.conditionKey)) keys.add(r.conditionKey);
    }
    return keys;
  }

  Future<void> setCondition(int patientId, String key, bool enabled) =>
      _db.into(_db.conditions).insert(
            ConditionsCompanion.insert(
              patientId: patientId,
              conditionKey: key,
              enabled: Value(enabled),
            ),
            onConflict: DoUpdate(
              (_) => ConditionsCompanion(enabled: Value(enabled)),
              target: [_db.conditions.patientId, _db.conditions.conditionKey],
            ),
          );

  // ---- Emergency contacts ---------------------------------------------------

  Stream<List<EmergencyContact>> watchContacts() =>
      (_db.select(_db.emergencyContacts)
            ..orderBy([(t) => OrderingTerm.asc(t.role), (t) => OrderingTerm.asc(t.id)]))
          .watch();

  Future<void> saveContact({
    int? id,
    required String name,
    required ContactRole role,
    required String phone,
  }) async {
    if (id == null) {
      await _db.into(_db.emergencyContacts).insert(
            EmergencyContactsCompanion.insert(
              name: name.trim(),
              role: role,
              phone: phone.trim(),
            ),
          );
    } else {
      await (_db.update(_db.emergencyContacts)..where((t) => t.id.equals(id)))
          .write(EmergencyContactsCompanion(
        name: Value(name.trim()),
        role: Value(role),
        phone: Value(phone.trim()),
      ));
    }
  }

  Future<void> deleteContact(int id) =>
      (_db.delete(_db.emergencyContacts)..where((t) => t.id.equals(id))).go();
}
