import 'package:drift/drift.dart';

import '../../domain/reminder_rules.dart';
import '../db/app_database.dart';
import '../enums.dart';

class ReminderRepository {
  ReminderRepository(this._db);
  final AppDatabase _db;

  Stream<List<Reminder>> watchAll() => (_db.select(_db.reminders)
        ..orderBy([(t) => OrderingTerm.asc(t.hour), (t) => OrderingTerm.asc(t.minute), (t) => OrderingTerm.asc(t.id)]))
      .watch();

  Future<Reminder?> get(int id) =>
      (_db.select(_db.reminders)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> save({
    int? id,
    required ReminderType type,
    required int hour,
    required int minute,
    required RepeatRule rule,
    String? label,
    bool enabled = true,
  }) async {
    final cleanLabel = (label == null || label.trim().isEmpty) ? null : label.trim();
    if (id == null) {
      return _db.into(_db.reminders).insert(RemindersCompanion.insert(
            type: type,
            hour: hour,
            minute: minute,
            repeatRule: Value(rule.encoded),
            enabled: Value(enabled),
            label: Value(cleanLabel),
          ));
    }
    await (_db.update(_db.reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(
        type: Value(type),
        hour: Value(hour),
        minute: Value(minute),
        repeatRule: Value(rule.encoded),
        label: Value(cleanLabel),
      ),
    );
    return id;
  }

  Future<void> setEnabled(int id, bool enabled) =>
      (_db.update(_db.reminders)..where((t) => t.id.equals(id)))
          .write(RemindersCompanion(enabled: Value(enabled)));

  Future<void> delete(int id) =>
      (_db.delete(_db.reminders)..where((t) => t.id.equals(id))).go();

  /// Creates the default reminders exactly once (even if the user deletes
  /// them all later).
  Future<bool> seedDefaultsOnce() => _db.transaction(() async {
        final settings = await _db.getSettings();
        if (settings.remindersSeeded) return false;
        for (final d in defaultReminderPlan) {
          await _db.into(_db.reminders).insert(RemindersCompanion.insert(
                type: d.type,
                hour: d.hour,
                minute: d.minute,
                repeatRule: Value(d.rule),
              ));
        }
        await _db.updateSettings(
            const AppSettingsTableCompanion(remindersSeeded: Value(true)));
        return true;
      });
}
