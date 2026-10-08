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

  // ---- Phase 2 screens ----------------------------------------------------

  for (final nepali in [false, true]) {
    final lang = nepali ? 'ne' : 'en';

    appTest('home, medicines, profile hub @200% ($lang)',
        (tester) async {
      final db = await pumpApp(tester, textScale: 2.0, size: small,
          beforeStart: (db) async {
        await addMed(db, 'Test tablet with a rather long name for wrapping',
            {DoseSlot.morning, DoseSlot.night});
        await db.into(db.conditions).insert(ConditionsCompanion.insert(
            patientId: 1, conditionKey: 'diabetes'));
        await db.into(db.conditions).insert(ConditionsCompanion.insert(
            patientId: 1, conditionKey: 'hypertension'));
      });
      if (nepali) {
        await db.updateSettings(const AppSettingsTableCompanion(
            language: Value(AppLanguage.ne),
            dateStyle: Value(DateStyle.bs),
            digitStyle: Value(DigitStyle.devanagari)));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull, reason: 'home');

      // Fasting on shows the note.
      await tester.tap(find.byIcon(Icons.check_box_outline_blank).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'home + fasting note');

      final dest = find.descendant(
          of: find.byType(NavigationBar),
          matching: find.byType(NavigationDestination));
      await tester.tap(dest.at(1));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'medicines tab');

      await tester.tap(dest.at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'profile hub');

      // The six steps themselves are covered by 'setup wizard @200%'.
    });

    appTest('setup wizard @200% ($lang)', (tester) async {
      final db = await pumpApp(tester,
          textScale: 2.0, size: small, withPatient: false);
      if (nepali) {
        await db.updateSettings(const AppSettingsTableCompanion(
            language: Value(AppLanguage.ne)));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull, reason: 'wizard step 1');
      await tester.enterText(find.byType(TextField).first, 'Ram');
      for (var step = 2; step <= 6; step++) {
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'wizard step $step');
      }
      // The Next / Finish button is always reachable on screen.
      final btn = find.byType(FilledButton).last;
      expect(tester.getRect(btn).bottom, lessThanOrEqualTo(small.height));
    });

    appTest('medicine form + its errors @200% ($lang)', (tester) async {
      final db = await pumpApp(tester, textScale: 2.0, size: small);
      if (nepali) {
        await db.updateSettings(const AppSettingsTableCompanion(
            language: Value(AppLanguage.ne)));
        await tester.pumpAndSettle();
      }
      final dest = find.descendant(
          of: find.byType(NavigationBar),
          matching: find.byType(NavigationDestination));
      await tester.tap(dest.at(1));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.byIcon(Icons.add), 200,
          scrollable: find.byType(Scrollable).hitTestable().first);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'medicine form');
      // Trigger the error messages too.
      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'medicine form errors');
    });
  }
}
