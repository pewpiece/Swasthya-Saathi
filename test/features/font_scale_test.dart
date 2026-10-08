import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:care_companion/data/repositories/reading_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      final box = find.byIcon(Icons.check_box_outline_blank);
      for (var n = 0; n < 15 && box.evaluate().isEmpty; n++) {
        await tester.drag(find.byType(Scrollable).hitTestable().first,
            const Offset(0, -200));
        await tester.pumpAndSettle();
      }
      await tester.ensureVisible(box.first);
      await tester.tap(box.first);
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

  // ---- Phase 3 screens ----------------------------------------------------

  for (final nepali in [false, true]) {
    final lang = nepali ? 'ne' : 'en';

    appTest('add reading forms + chooser @200% ($lang)', (tester) async {
      final db = await pumpApp(tester, textScale: 2.0, size: small,
          beforeStart: (db) async {
        await enableDiabetes(db);
        await enableHypertension(db);
      });
      if (nepali) {
        await db.updateSettings(const AppSettingsTableCompanion(
            language: Value(AppLanguage.ne)));
        await tester.pumpAndSettle();
      }
      final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
      for (final path in ['/reading/new', '/reading/new/blood_sugar', '/reading/new/blood_pressure']) {
        router.push(path);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: path);
        // Trigger every error message too.
        final save = find.byType(FilledButton);
        if (path != '/reading/new') {
          await tester.tap(save.last);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$path errors');
        }
        router.pop();
        await tester.pumpAndSettle();
      }
    });

    appTest('result screens: in range, out of range, urgent, no ranges @200% ($lang)',
        (tester) async {
      final db = await pumpApp(tester, textScale: 2.0, size: small,
          beforeStart: (db) async {
        await enableDiabetes(db);
        await addContact(db, 'Dr Test', '9800000000');
        await addContact(db, 'Test Hospital', '014444444',
            role: ContactRole.hospital);
      });
      if (nepali) {
        await db.updateSettings(const AppSettingsTableCompanion(
            language: Value(AppLanguage.ne),
            digitStyle: Value(DigitStyle.devanagari)));
        await tester.pumpAndSettle();
      }
      final repo = ReadingRepository(db);
      final ids = <int>[];
      for (final v in [120.0, 200.0, 400.0]) {
        ids.add(await repo.save(
            patientId: 1,
            kind: 'blood_sugar',
            unit: 'mg/dL',
            measuredAt: DateTime(2025, 4, 14, 9),
            value: v,
            tag: 'tagFasting'));
      }
      final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
      for (final id in ids) {
        router.push('/reading/$id');
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'reading $id');
        if (id == ids.last) {
          // URGENT: the first call button must be on screen WITHOUT scrolling.
          final call = find.byIcon(Icons.call).first;
          expect(call.hitTestable(), findsOneWidget, reason: 'call button visible');
          expect(tester.getRect(call).bottom, lessThan(small.height));
        } else {
          expect(find.byType(FilledButton).hitTestable(), findsWidgets,
              reason: 'reading $id button');
        }
        router.pop();
        await tester.pumpAndSettle();
      }
      // Home with latest reading + guidance card at 200%.
      expect(tester.takeException(), isNull, reason: 'home with readings');

      // No ranges: the explanation + button.
      await db.delete(db.targetRanges).go();
      router.push('/reading/${ids[1]}');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'no ranges');
    });
  }
}
