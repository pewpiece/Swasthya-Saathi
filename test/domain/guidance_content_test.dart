import 'dart:io';

import 'package:care_companion/core/l10n/guidance_texts.dart';
import 'package:care_companion/domain/guidance_content.dart';
import 'package:care_companion/domain/guidance_engine.dart';
import 'package:care_companion/l10n/app_localizations.dart';
import 'package:care_companion/data/guidance_loader.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the app\'s asset loader finds every guidance file', (tester) async {
    final lib = await tester.runAsync(() => loadGuidanceLibrary(rootBundle));
    expect(lib!.keys, containsAll(['general', 'diabetes', 'hypertension']));
    final onDisk = {
      for (final f in Directory('assets/guidance').listSync().whereType<File>())
        if (f.path.endsWith('.json')) parseGuidanceFile(f.readAsStringSync()).$1,
    };
    expect(lib.keys.toSet(), onDisk, reason: 'every file in the folder is loaded');
    expect(lib['diabetes']!.every((i) => !i.reviewedByClinician), isTrue);
  });

  final files = Directory('assets/guidance')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList();
  final parsed = {
    for (final f in files) f.path: parseGuidanceFile(f.readAsStringSync()),
  };
  final allItems = [for (final p in parsed.values) ...p.$2];

  test('there is one file per condition, plus general', () {
    final conditions = parsed.values.map((p) => p.$1).toSet();
    expect(conditions, containsAll(['general', 'diabetes', 'hypertension']));
  });

  test('SAFETY: nothing is marked clinician-reviewed yet', () {
    expect(allItems, isNotEmpty);
    expect(allItems.where((i) => i.reviewedByClinician), isEmpty);
    for (final f in files) {
      expect(f.readAsStringSync(), contains('"reviewed_by_clinician": false'));
      expect(f.readAsStringSync(), isNot(contains('"reviewed_by_clinician": true')));
    }
  });

  test('ids are unique and every item applies to some tier', () {
    final ids = allItems.map((i) => i.id).toList();
    expect(ids.toSet().length, ids.length);
    for (final i in allItems) {
      expect(i.appliesToTiers, isNotEmpty, reason: i.id);
    }
  });

  test('SAFETY: no content for the urgent or unknown tier', () {
    for (final i in allItems) {
      expect(i.appliesToTiers.contains(Tier.urgent), isFalse, reason: i.id);
      expect(i.appliesToTiers.contains(Tier.unknown), isFalse, reason: i.id);
    }
  });

  test('SAFETY: food wording is Prefer / Go easy on, never Avoid / Forbidden',
      () async {
    for (final code in ['en', 'ne']) {
      final l = await AppL10n.delegate.load(Locale(code));
      for (final i in allItems) {
        final text = guidanceTextOrNull(l, i.textKey)!.toLowerCase();
        for (final bad in ['avoid', 'forbid', 'never eat', 'cut calories', 'eat less', 'fast ']) {
          expect(text.contains(bad), isFalse, reason: '${i.id} ($code): "$bad"');
        }
        // Never suggest skipping meals: "skip" is only allowed as "do not skip".
        if (code == 'en' && text.contains('skip')) {
          expect(text.contains('do not skip'), isTrue, reason: i.id);
        }
      }
    }
    final en = await AppL10n.delegate.load(const Locale('en'));
    expect(en.guidanceMeals, 'Prefer');
    expect(en.guidanceGoEasyOn, 'Go easy on');
  });

  test('SAFETY: no treatment, dosing or medicine-change words in any text',
      () async {
    final l = await AppL10n.delegate.load(const Locale('en'));
    for (final i in allItems) {
      final text = guidanceTextOrNull(l, i.textKey)!.toLowerCase();
      for (final bad in ['insulin', 'dose', 'tablet', 'stop taking', 'increase', 'reduce your', 'medicine']) {
        expect(text.contains(bad), isFalse, reason: '${i.id}: "$bad"');
      }
    }
  });

  for (final code in ['en', 'ne']) {
    test('every textKey resolves to real text in $code', () async {
      final l = await AppL10n.delegate.load(Locale(code));
      for (final i in allItems) {
        final text = guidanceTextOrNull(l, i.textKey);
        expect(text, isNotNull, reason: '${i.id} has no case in guidance_texts.dart');
        expect(text!.trim(), isNotEmpty, reason: i.id);
      }
    });
  }

  test('the soft-food flag has soft meals to show', () {
    final soft = allItems.where((i) => i.kind == ItemKind.meal && i.tags.contains('soft'));
    expect(soft.length, greaterThanOrEqualTo(3));
  });

  test('English and Nepali define exactly the same keys', () {
    final en = (File('lib/l10n/app_en.arb').readAsStringSync());
    final ne = (File('lib/l10n/app_ne.arb').readAsStringSync());
    Set<String> keys(String s) =>
        RegExp(r'^  "([A-Za-z0-9_]+)":', multiLine: true)
            .allMatches(s)
            .map((m) => m.group(1)!)
            .where((k) => !k.startsWith('@'))
            .toSet();
    final k1 = keys(en);
    final k2 = keys(ne);
    expect(k1.difference(k2), isEmpty, reason: 'missing in Nepali');
    expect(k2.difference(k1), isEmpty, reason: 'missing in English');
  });
}
