import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/dates/date_only.dart';
import 'data_export.dart';
import 'providers.dart';

/// Hands a file to the phone's share sheet. Overridden in tests.
final shareFileProvider = Provider<Future<void> Function(Uint8List bytes, String filename)>(
  (ref) => (bytes, filename) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  },
);

/// No patient name in the file name (a share sheet shows it).
String backupFileName(DateTime now) => 'care_companion_backup_${dateKey(now)}.json';

final exportDataProvider = Provider<Future<void> Function()>((ref) => () async {
      final now = ref.read(clockProvider)();
      final bytes = await DataExporter(ref.read(databaseProvider)).toBytes(now);
      await ref.read(shareFileProvider)(bytes, backupFileName(now));
    });
