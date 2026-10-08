import 'package:drift/drift.dart';

import '../core/dates/date_only.dart';
import '../data/db/app_database.dart';
import '../data/enums.dart';

/// DEBUG ONLY (the button is shown only when `kDebugMode`). Fills an empty
/// database with obviously fake data so screens can be tried out:
/// a made-up person, made-up medicine names and 13 days of dose history.
///
/// It adds NO doctor's ranges and NO phone numbers: those must always be
/// typed in by hand, so the "no ranges = no guidance" rule is what you test.
/// Returns false (and changes nothing) if a profile already exists.
Future<bool> seedDemoData(AppDatabase db, DateTime now) async {
  if ((await db.select(db.patients).get()).isNotEmpty) return false;
  final today = DateTime(now.year, now.month, now.day);
  String day(int back) => dateKey(DateTime(today.year, today.month, today.day - back));

  await db.transaction(() async {
    final pid = await db.into(db.patients).insert(PatientsCompanion.insert(
          name: 'Demo Parent',
          birthYear: Value(today.year - 85),
          notes: const Value('Demo data - not a real person.'),
          allergies: const Value('Demo: no known allergies'),
        ));
    for (final key in ['diabetes', 'hypertension']) {
      await db.into(db.conditions).insert(
          ConditionsCompanion.insert(patientId: pid, conditionKey: key));
    }
    const meds = <(String, Set<DoseSlot>)>[
      ('Demo tablet A', {DoseSlot.morning, DoseSlot.night}),
      ('Demo capsule B', {DoseSlot.morning}),
      ('Demo tablet C', {DoseSlot.night}),
    ];
    for (final (name, slots) in meds) {
      final id = await db
          .into(db.medications)
          .insert(MedicationsCompanion.insert(patientId: pid, name: name));
      for (final slot in slots) {
        await db.into(db.medicationSlots).insert(MedicationSlotsCompanion.insert(
            medicationId: id, slot: slot, startedOn: Value(day(13))));
        // Past 13 days: most doses given, a few missed (deterministic).
        for (var back = 1; back <= 13; back++) {
          final missed = (back + id + slot.index) % 5 == 0;
          if (missed) continue;
          final d = DateTime(today.year, today.month, today.day - back,
              slot == DoseSlot.morning ? 8 : 21);
          await db.into(db.doseLogs).insert(DoseLogsCompanion.insert(
                medicationId: id,
                slot: slot,
                date: day(back),
                taken: const Value(true),
                takenAt: Value(d),
              ));
        }
      }
    }
  });
  return true;
}
