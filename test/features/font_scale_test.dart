import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

/// Accessibility: no overflow / clipped layout at 200% system font size, in
/// English and Nepali, on a small (360dp wide) phone.
void main() {
  const small = Size(360, 640);

  for (final nepali in [false, true]) {
    final lang = nepali ? 'ne' : 'en';

    appTest('welcome screen @200% ($lang)', (tester) async {
      final db = await pumpApp(tester,
          disclaimerAccepted: false, textScale: 2.0, size: small);
      // Switch language before checking; the welcome screen is shown first.
      if (nepali) {
        await db.updateSettings(
            const AppSettingsTableCompanion(language: Value(AppLanguage.ne)));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      // The accept button must still be on screen and tappable.
      final button = find.byType(FilledButton);
      expect(button, findsOneWidget);
      expect(tester.getRect(button).bottom, lessThanOrEqualTo(small.height));
    });

    for (final tab in ['home', 'medicines', 'history', 'settings']) {
      appTest('$tab tab @200% ($lang)', (tester) async {
        final db = await pumpApp(tester, textScale: 2.0, size: small);
        if (nepali) {
          await db.updateSettings(const AppSettingsTableCompanion(
              language: Value(AppLanguage.ne),
              dateStyle: Value(DateStyle.bs),
              digitStyle: Value(DigitStyle.devanagari)));
          await tester.pumpAndSettle();
        }
        final index = ['home', 'medicines', 'history', 'settings'].indexOf(tab);
        final dest = find.descendant(
            of: find.byType(NavigationBar),
            matching: find.byType(NavigationDestination));
        await tester.tap(dest.at(index));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
