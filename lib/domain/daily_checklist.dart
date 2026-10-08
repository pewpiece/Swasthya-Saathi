import '../data/db/app_database.dart';
import '../data/enums.dart';

/// A medicine with the slots it is (or was) given in.
class MedWithSlots {
  const MedWithSlots(this.medication, this.slots);
  final Medication medication;
  final List<MedicationSlot> slots;

  /// Slots currently in use (not removed).
  Set<DoseSlot> get activeSlots => {
        for (final s in slots)
          if (s.endedOn == null) s.slot,
      };
}

/// Is [slot] expected on calendar day [dayKey] (`yyyy-MM-dd`)?
/// Day keys compare correctly as text.
bool slotExpectedOn(MedicationSlot slot, String dayKey) =>
    (slot.startedOn == null || slot.startedOn!.compareTo(dayKey) <= 0) &&
    (slot.endedOn == null || dayKey.compareTo(slot.endedOn!) < 0);

/// One tick box on today's checklist.
class ChecklistItem {
  const ChecklistItem(this.medication, this.slot, this.log);
  final Medication medication;
  final DoseSlot slot;
  final DoseLog? log;

  bool get taken => log?.taken ?? false;
  DateTime? get takenAt => taken ? log?.takenAt : null;
}

/// Builds the checklist for one day. **This is the daily reset:** a new
/// [dayKey] has no [DoseLog] rows yet, so every box starts unticked, while
/// older days' rows are untouched. Only active medicines are shown.
List<ChecklistItem> buildChecklist({
  required List<MedWithSlots> meds,
  required List<DoseLog> logs,
  required String dayKey,
}) {
  final items = <ChecklistItem>[];
  for (final m in meds) {
    if (!m.medication.active) continue;
    for (final s in m.slots) {
      if (!slotExpectedOn(s, dayKey)) continue;
      DoseLog? log;
      for (final l in logs) {
        if (l.medicationId == m.medication.id &&
            l.slot == s.slot &&
            l.date == dayKey) {
          log = l;
          break;
        }
      }
      items.add(ChecklistItem(m.medication, s.slot, log));
    }
  }
  items.sort((a, b) {
    final bySlot = a.slot.index.compareTo(b.slot.index);
    if (bySlot != 0) return bySlot;
    final byName = a.medication.name
        .toLowerCase()
        .compareTo(b.medication.name.toLowerCase());
    return byName != 0 ? byName : a.medication.id.compareTo(b.medication.id);
  });
  return items;
}

/// How many doses were expected and given for one slot on one day.
class SlotAdherence {
  const SlotAdherence(this.expected, this.taken);
  final int expected;
  final int taken;
}

class AdherenceDay {
  const AdherenceDay(this.dayKey, this.morning, this.night);
  final String dayKey;
  final SlotAdherence morning;
  final SlotAdherence night;

  int get expected => morning.expected + night.expected;
  int get taken => morning.taken + night.taken;
}

/// Adherence for each of [dayKeys] (newest first or any order; kept as given).
/// Medicines added later are not counted as missed on earlier days.
List<AdherenceDay> buildAdherence({
  required List<MedWithSlots> meds,
  required List<DoseLog> logs,
  required List<String> dayKeys,
}) {
  final taken = <String>{
    for (final l in logs)
      if (l.taken) '${l.medicationId}|${l.slot.name}|${l.date}',
  };
  return [
    for (final day in dayKeys)
      () {
        final exp = {for (final s in DoseSlot.values) s: 0};
        final got = {for (final s in DoseSlot.values) s: 0};
        for (final m in meds) {
          for (final s in m.slots) {
            if (!slotExpectedOn(s, day)) continue;
            exp[s.slot] = exp[s.slot]! + 1;
            if (taken.contains('${m.medication.id}|${s.slot.name}|$day')) {
              got[s.slot] = got[s.slot]! + 1;
            }
          }
        }
        return AdherenceDay(
          day,
          SlotAdherence(exp[DoseSlot.morning]!, got[DoseSlot.morning]!),
          SlotAdherence(exp[DoseSlot.night]!, got[DoseSlot.night]!),
        );
      }(),
  ];
}
