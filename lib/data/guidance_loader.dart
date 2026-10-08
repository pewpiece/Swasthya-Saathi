import 'package:flutter/services.dart';

import '../domain/guidance_content.dart';
import '../domain/guidance_engine.dart';

/// Loads every `assets/guidance/*.json`. A new condition = a new file there
/// (plus its texts in the .arb files); no code change.
Future<GuidanceLibrary> loadGuidanceLibrary(AssetBundle bundle) async {
  final manifest = await AssetManifest.loadFromAssetBundle(bundle);
  final paths = manifest
      .listAssets()
      .where((p) => p.startsWith('assets/guidance/') && p.endsWith('.json'))
      .toList()
    ..sort();
  final library = <String, List<GuidanceItem>>{};
  for (final path in paths) {
    final (condition, items) = parseGuidanceFile(await bundle.loadString(path));
    library.putIfAbsent(condition, () => []).addAll(items);
  }
  return library;
}
