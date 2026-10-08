import 'dart:convert';

import 'guidance_engine.dart';

/// Guidance content grouped by condition (`general`, `diabetes`, ...).
typedef GuidanceLibrary = Map<String, List<GuidanceItem>>;

Tier _tier(String s) => Tier.values.firstWhere(
      (t) => t.name == s,
      orElse: () => throw FormatException('Unknown tier "$s"'),
    );

Direction _dir(String s) => Direction.values.firstWhere(
      (d) => d.name == s,
      orElse: () => throw FormatException('Unknown direction "$s"'),
    );

ItemKind _kind(String s) => ItemKind.values.firstWhere(
      (k) => k.name == s,
      orElse: () => throw FormatException('Unknown kind "$s"'),
    );

/// Parses one `assets/guidance/<condition>.json` file.
/// `reviewed_by_clinician` defaults to false when missing.
(String, List<GuidanceItem>) parseGuidanceFile(String jsonText) {
  final map = jsonDecode(jsonText) as Map<String, dynamic>;
  final condition = map['condition'] as String;
  final items = <GuidanceItem>[];
  for (final raw in (map['items'] as List)) {
    final m = raw as Map<String, dynamic>;
    List<String> list(String k) => [for (final v in (m[k] as List? ?? const [])) v as String];
    items.add(GuidanceItem(
      id: m['id'] as String,
      textKey: m['textKey'] as String,
      kind: _kind(m['kind'] as String),
      appliesToTiers: list('appliesToTiers').map(_tier).toSet(),
      directions: list('directions').map(_dir).toSet(),
      tags: list('tags').toSet(),
      allergens: list('allergens').toSet(),
      reviewedByClinician: m['reviewed_by_clinician'] == true,
    ));
  }
  return (condition, items);
}
