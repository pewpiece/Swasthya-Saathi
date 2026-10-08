import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/dates/date_only.dart';
import '../domain/daily_checklist.dart';
import 'db/app_database.dart';
import 'enums.dart';
import 'repositories/medication_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/range_repository.dart';

/// The app database. Tests override this with an in-memory database.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.onDevice();
  ref.onDispose(db.close);
  return db;
});

/// "Now". Overridden in tests so the daily reset can be checked at midnight.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final settingsProvider = StreamProvider<AppSettingsRow>(
  (ref) => ref.watch(databaseProvider).watchSettings(),
);

final settingsActionsProvider = Provider<SettingsActions>(
  (ref) => SettingsActions(ref.watch(databaseProvider)),
);

/// Writes to the single settings row. The UI updates through the stream.
class SettingsActions {
  SettingsActions(this._db);
  final AppDatabase _db;

  Future<void> setLanguage(AppLanguage v) =>
      _db.updateSettings(AppSettingsTableCompanion(language: Value(v)));

  Future<void> setDateStyle(DateStyle v) =>
      _db.updateSettings(AppSettingsTableCompanion(dateStyle: Value(v)));

  Future<void> setGlucoseUnit(GlucoseUnit v) =>
      _db.updateSettings(AppSettingsTableCompanion(glucoseUnit: Value(v)));

  Future<void> setDigitStyle(DigitStyle v) =>
      _db.updateSettings(AppSettingsTableCompanion(digitStyle: Value(v)));

  /// Fasting (upabas) is stored as the day it was switched on, so it ends by
  /// itself the next day.
  Future<void> setFastingToday(bool on, DateTime today) => _db.updateSettings(
        AppSettingsTableCompanion(
          fastingOnDate: Value(on ? dateKey(today) : null),
        ),
      );

  Future<void> acceptDisclaimer() => _db.updateSettings(
        const AppSettingsTableCompanion(disclaimerAccepted: Value(true)),
      );
}

// ---- Today ------------------------------------------------------------------

/// The current calendar day (date only). Re-emits at midnight while the app is
/// open, so the checklist resets without a restart. Polls the clock each 20s.
final todayProvider = StreamProvider<DateTime>((ref) {
  final clock = ref.watch(clockProvider);
  final controller = StreamController<DateTime>();
  DateTime? last;
  void tick() {
    final n = clock();
    final day = DateTime(n.year, n.month, n.day);
    if (last == null || last != day) {
      last = day;
      if (!controller.isClosed) controller.add(day);
    }
  }

  tick();
  final timer = Timer.periodic(const Duration(seconds: 20), (_) => tick());
  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });
  return controller.stream;
});

// ---- Repositories -------------------------------------------------------------

final profileRepositoryProvider =
    Provider((ref) => ProfileRepository(ref.watch(databaseProvider)));
final rangeRepositoryProvider =
    Provider((ref) => RangeRepository(ref.watch(databaseProvider)));
final medicationRepositoryProvider =
    Provider((ref) => MedicationRepository(ref.watch(databaseProvider)));

final patientProvider = StreamProvider<Patient?>(
  (ref) => ref.watch(profileRepositoryProvider).watchPatient(),
);

final conditionsProvider = StreamProvider<List<PatientCondition>>(
  (ref) => ref.watch(profileRepositoryProvider).watchConditions(),
);

final contactsProvider = StreamProvider<List<EmergencyContact>>(
  (ref) => ref.watch(profileRepositoryProvider).watchContacts(),
);

final metricsProvider = StreamProvider<List<Metric>>(
  (ref) => ref.watch(rangeRepositoryProvider).watchMetrics(),
);

final rangesProvider = StreamProvider<List<TargetRange>>(
  (ref) => ref.watch(rangeRepositoryProvider).watchAll(),
);

final medicationsProvider = StreamProvider<List<MedWithSlots>>(
  (ref) => ref.watch(medicationRepositoryProvider).watchAll(),
);

final logsForDayProvider = StreamProvider.family<List<DoseLog>, String>(
  (ref, dayKey) =>
      ref.watch(medicationRepositoryProvider).watchLogsForDay(dayKey),
);

final todayChecklistProvider = Provider<AsyncValue<List<ChecklistItem>>>((ref) {
  final today = ref.watch(todayProvider);
  final meds = ref.watch(medicationsProvider);
  if (today.value == null) return const AsyncLoading();
  final key = dateKey(today.value!);
  final logs = ref.watch(logsForDayProvider(key));
  if (meds.hasError) return AsyncError(meds.error!, meds.stackTrace!);
  if (logs.hasError) return AsyncError(logs.error!, logs.stackTrace!);
  if (!meds.hasValue || !logs.hasValue) return const AsyncLoading();
  return AsyncData(buildChecklist(meds: meds.value!, logs: logs.value!, dayKey: key));
});

/// Number of past days shown in the adherence history.
const adherenceDays = 14;

final adherenceProvider = Provider<AsyncValue<List<AdherenceDay>>>((ref) {
  final today = ref.watch(todayProvider).value;
  final meds = ref.watch(medicationsProvider);
  if (today == null) return const AsyncLoading();
  final from = DateTime(today.year, today.month, today.day - (adherenceDays - 1));
  final logs = ref.watch(_logsRangeProvider((dateKey(from), dateKey(today))));
  if (!meds.hasValue || !logs.hasValue) return const AsyncLoading();
  final keys = [
    for (var i = 0; i < adherenceDays; i++)
      dateKey(DateTime(today.year, today.month, today.day - i)),
  ];
  return AsyncData(buildAdherence(meds: meds.value!, logs: logs.value!, dayKeys: keys));
});

final _logsRangeProvider =
    StreamProvider.family<List<DoseLog>, (String, String)>(
  (ref, range) => ref
      .watch(medicationRepositoryProvider)
      .watchLogsBetween(range.$1, range.$2),
);
