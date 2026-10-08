import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db/app_database.dart';
import 'enums.dart';

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

  Future<void> acceptDisclaimer() => _db.updateSettings(
        const AppSettingsTableCompanion(disclaimerAccepted: Value(true)),
      );
}
