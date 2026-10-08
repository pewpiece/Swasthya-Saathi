import 'dart:convert';
import 'dart:typed_data';

import 'db/app_database.dart';

/// A backup copy of everything the family entered, as one JSON file.
/// The PIN (hash and salt) is never included. Restoring from it is not built
/// yet; the file is for the family's own safe-keeping and for a doctor or a
/// future version of the app.
class DataExporter {
  DataExporter(this._db);
  final AppDatabase _db;

  static const formatVersion = 1;

  Future<Map<String, Object?>> toMap(DateTime now) async {
    final settings = (await _db.getSettings()).toJson()
      ..remove('pinHash')
      ..remove('pinSalt');
    List<Map<String, dynamic>> rows<T>(List<dynamic> list) =>
        [for (final r in list) (r as dynamic).toJson() as Map<String, dynamic>];
    return {
      'app': 'Swasthya Saathi',
      'formatVersion': formatVersion,
      'schemaVersion': _db.schemaVersion,
      'exportedAt': now.toIso8601String(),
      'note': 'Contains health information. Keep this file private.',
      // The profile photo is a file on this phone and is not part of the backup.
      'patients': [
        for (final p in rows(await _db.select(_db.patients).get())) p..remove('photoPath'),
      ],
      'conditions': rows(await _db.select(_db.conditions).get()),
      'targetRanges': rows(await _db.select(_db.targetRanges).get()),
      'readings': rows(await _db.select(_db.readings).get()),
      'medications': rows(await _db.select(_db.medications).get()),
      'medicationSlots': rows(await _db.select(_db.medicationSlots).get()),
      'doseLogs': rows(await _db.select(_db.doseLogs).get()),
      'reminders': rows(await _db.select(_db.reminders).get()),
      'emergencyContacts': rows(await _db.select(_db.emergencyContacts).get()),
      'settings': settings,
    };
  }

  Future<Uint8List> toBytes(DateTime now) async =>
      Uint8List.fromList(utf8.encode(const JsonEncoder.withIndent('  ').convert(await toMap(now))));
}
