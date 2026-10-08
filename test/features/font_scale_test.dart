import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:care_companion/data/repositories/reading_repository.dart';

import '../helpers/fake_gateway.dart';

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
      final db = await pumpApp(
        tester,
        disclaimerAccepted: false,
        textScale: 2.0,
        size: small,
      );
      // Switch language before checking; the welcome screen is shown first.
      if (nepali) {
        await db.updateSettings(
          const AppSettingsTableCompanion(language: Value(AppLanguage.ne)),
        );
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
          await db.updateSettings(
            const AppSettingsTableCompanion(
              language: Value(AppLanguage.ne),
              dateStyle: Value(DateStyle.bs),
              digitStyle: Value(DigitStyle.devanagari),
            ),
          );
          await tester.pumpAndSettle();
        }
        final index = ['home', 'medicines', 'history', 'settings'].indexOf(tab);
        final dest = find.descendant(
          of: find.byType(NavigationBar),
          matching: find.byType(NavigationDestination),
        );
        await tester.tap(dest.at(index));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }

  // ---- Phase 2 screens ----------------------------------------------------

  for (final nepali in [false, true]) {
    final lang = nepali ? 'ne' : 'en';

    appTest('home, medicines, profile hub @200% ($lang)', (tester) async {
      final db = await pumpApp(
        tester,
        textScale: 2.0,
        size: small,
        beforeStart: (db) async {
          await addMed(db, 'Test tablet with a rather long name for wrapping', {
            DoseSlot.morning,
            DoseSlot.night,
          });
          await db
              .into(db.conditions)
              .insert(
                ConditionsCompanion.insert(
                  patientId: 1,
                  conditionKey: 'diabetes',
                ),
              );
          await db
              .into(db.conditions)
              .insert(
                ConditionsCompanion.insert(
                  patientId: 1,
                  conditionKey: 'hypertension',
                ),
              );
        },
      );
      if (nepali) {
        await db.updateSettings(
          const AppSettingsTableCompanion(
            language: Value(AppLanguage.ne),
            dateStyle: Value(DateStyle.bs),
            digitStyle: Value(DigitStyle.devanagari),
          ),
        );
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull, reason: 'home');

      // Fasting on shows the note.
      final box = find.byIcon(Icons.check_box_outline_blank);
      for (var n = 0; n < 15 && box.evaluate().isEmpty; n++) {
        await tester.drag(
          find.byType(Scrollable).hitTestable().first,
          const Offset(0, -200),
        );
        await tester.pumpAndSettle();
      }
      await tester.ensureVisible(box.first);
      await tester.tap(box.first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'home + fasting note');

      final dest = find.descendant(
        of: find.byType(NavigationBar),
        matching: find.byType(NavigationDestination),
      );
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
      final db = await pumpApp(
        tester,
        textScale: 2.0,
        size: small,
        withPatient: false,
      );
      if (nepali) {
        await db.updateSettings(
          const AppSettingsTableCompanion(language: Value(AppLanguage.ne)),
        );
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
        await db.updateSettings(
          const AppSettingsTableCompanion(language: Value(AppLanguage.ne)),
        );
        await tester.pumpAndSettle();
      }
      final dest = find.descendant(
        of: find.byType(NavigationBar),
        matching: find.byType(NavigationDestination),
      );
      await tester.tap(dest.at(1));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byIcon(Icons.add),
        200,
        scrollable: find.byType(Scrollable).hitTestable().first,
      );
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
      final db = await pumpApp(
        tester,
        textScale: 2.0,
        size: small,
        beforeStart: (db) async {
          await enableDiabetes(db);
          await enableHypertension(db);
        },
      );
      if (nepali) {
        await db.updateSettings(
          const AppSettingsTableCompanion(language: Value(AppLanguage.ne)),
        );
        await tester.pumpAndSettle();
      }
      final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
      for (final path in [
        '/reading/new',
        '/reading/new/blood_sugar',
        '/reading/new/blood_pressure',
      ]) {
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

    appTest(
      'result screens: in range, out of range, urgent, no ranges @200% ($lang)',
      (tester) async {
        final db = await pumpApp(
          tester,
          textScale: 2.0,
          size: small,
          beforeStart: (db) async {
            await enableDiabetes(db);
            await addContact(db, 'Dr Test', '9800000000');
            await addContact(
              db,
              'Test Hospital',
              '014444444',
              role: ContactRole.hospital,
            );
          },
        );
        if (nepali) {
          await db.updateSettings(
            const AppSettingsTableCompanion(
              language: Value(AppLanguage.ne),
              digitStyle: Value(DigitStyle.devanagari),
            ),
          );
          await tester.pumpAndSettle();
        }
        final repo = ReadingRepository(db);
        final ids = <int>[];
        for (final v in [120.0, 200.0, 400.0]) {
          ids.add(
            await repo.save(
              patientId: 1,
              kind: 'blood_sugar',
              unit: 'mg/dL',
              measuredAt: DateTime(2025, 4, 14, 9),
              value: v,
              tag: 'tagFasting',
            ),
          );
        }
        final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
        for (final id in ids) {
          router.push('/reading/$id');
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: 'reading $id');
          if (id == ids.last) {
            // URGENT: the first call button must be on screen WITHOUT scrolling.
            final call = find.byIcon(Icons.call).first;
            expect(
              call.hitTestable(),
              findsOneWidget,
              reason: 'call button visible',
            );
            expect(tester.getRect(call).bottom, lessThan(small.height));
          } else {
            expect(
              find.byType(FilledButton).hitTestable(),
              findsWidgets,
              reason: 'reading $id button',
            );
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
      },
    );
  }

  // ---- Phase 4 screens ----------------------------------------------------

  for (final nepali in [false, true]) {
    final lang = nepali ? 'ne' : 'en';

    appTest('reminders list, permission cards and forms @200% ($lang)', (
      tester,
    ) async {
      final gw = FakeGateway(notificationsAllowed: false);
      final db = await pumpApp(
        tester,
        textScale: 2.0,
        size: small,
        gateway: gw,
      );
      if (nepali) {
        await db.updateSettings(
          const AppSettingsTableCompanion(
            language: Value(AppLanguage.ne),
            digitStyle: Value(DigitStyle.devanagari),
            dateStyle: Value(DateStyle.bs),
          ),
        );
        await tester.pumpAndSettle();
      }
      expect(
        tester.takeException(),
        isNull,
        reason: 'home with reminder nudge',
      );
      final router = GoRouter.of(tester.element(find.byType(Scaffold).first));

      Future<void> visit(String path, String reason) async {
        router.push(path);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: reason);
        router.pop();
        await tester.pumpAndSettle();
      }

      await visit('/reminders', 'list + notification card');
      gw.notificationsAllowed = true;
      gw.exactAllowed = false;
      router.push('/reminders');
      await tester.pumpAndSettle();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'exact-alarm card');
      router.pop();
      await tester.pumpAndSettle();

      await visit('/reminder/new', 'add form');
      final reminders = await db.select(db.reminders).get();
      for (final r in reminders) {
        await visit('/reminder/${r.id}', 'edit ${r.type.name}');
      }
    });

    appTest('custom reminder form with its error @200% ($lang)', (
      tester,
    ) async {
      final db = await pumpApp(tester, textScale: 2.0, size: small);
      if (nepali) {
        await db.updateSettings(
          const AppSettingsTableCompanion(language: Value(AppLanguage.ne)),
        );
        await tester.pumpAndSettle();
      }
      final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
      router.push('/reminder/new');
      await tester.pumpAndSettle();
      // pick "my own reminder" (the last choice) and try to save without a name
      final choices = find.byIcon(Icons.radio_button_unchecked);
      for (var n = 0; n < 15 && choices.evaluate().length < 5; n++) {
        await tester.drag(
          find.byType(Scrollable).hitTestable().first,
          const Offset(0, -200),
        );
        await tester.pumpAndSettle();
      }
      await tester.ensureVisible(choices.last);
      await tester.tap(choices.last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'custom form error');
      expect(
        find.byType(FilledButton).hitTestable(),
        findsWidgets,
        reason: 'Save stays on screen',
      );
    });
  }

  // ---- Phase 5 screens ----------------------------------------------------

  for (final nepali in [false, true]) {
    final lang = nepali ? 'ne' : 'en';

    appTest('history (charts, both measures, list) and report @200% ($lang)', (
      tester,
    ) async {
      final gw = FakeGateway();
      final db = await pumpApp(
        tester,
        textScale: 2.0,
        size: small,
        gateway: gw,
        beforeStart: (db) async {
          await enableDiabetes(db);
          await enableHypertension(db);
        },
      );
      final repo = ReadingRepository(db);
      for (var i = 1; i <= 6; i++) {
        await repo.save(
          patientId: 1,
          kind: 'blood_sugar',
          unit: 'mg/dL',
          measuredAt: DateTime(2025, 4, 14 - i, 9),
          value: 100.0 + i * 30,
          tag: 'tagFasting',
        );
        await repo.save(
          patientId: 1,
          kind: 'blood_pressure',
          unit: 'mmHg',
          measuredAt: DateTime(2025, 4, 14 - i, 9),
          systolic: 120 + i * 5,
          diastolic: 80 + i * 2,
          pulse: 70,
        );
      }
      if (nepali) {
        await db.updateSettings(
          const AppSettingsTableCompanion(
            language: Value(AppLanguage.ne),
            digitStyle: Value(DigitStyle.devanagari),
            dateStyle: Value(DateStyle.bs),
          ),
        );
      }
      await tester.pumpAndSettle();
      final dest = find.descendant(
        of: find.byType(NavigationBar),
        matching: find.byType(NavigationDestination),
      );
      await tester.tap(dest.at(2)); // History
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'history sugar');

      // scroll through the whole screen
      for (var n = 0; n < 12; n++) {
        await tester.drag(
          find.byType(Scrollable).hitTestable().first,
          const Offset(0, -400),
        );
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull, reason: 'history list');
      for (var n = 0; n < 12; n++) {
        await tester.drag(
          find.byType(Scrollable).hitTestable().first,
          const Offset(0, 400),
        );
        await tester.pumpAndSettle();
      }
      // switch to blood pressure (second choice button)
      final choices = find.byIcon(Icons.circle_outlined);
      await tester.ensureVisible(choices.first);
      await tester.tap(choices.first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'history pressure');

      final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
      router.push('/report');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'report screen');
      expect(
        find.byType(FilledButton).hitTestable(),
        findsOneWidget,
        reason: 'Share button stays on screen',
      );
    });

    appTest('empty history and report with no profile data @200% ($lang)', (
      tester,
    ) async {
      final db = await pumpApp(tester, textScale: 2.0, size: small);
      if (nepali) {
        await db.updateSettings(
          const AppSettingsTableCompanion(language: Value(AppLanguage.ne)),
        );
        await tester.pumpAndSettle();
      }
      final dest = find.descendant(
        of: find.byType(NavigationBar),
        matching: find.byType(NavigationDestination),
      );
      await tester.tap(dest.at(2));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'empty history');
    });
  }

  // ---- Phase 6 screens ----------------------------------------------------

  for (final nepali in [false, true]) {
    final lang = nepali ? 'ne' : 'en';

    appTest('help, data, PIN settings and PIN steps @200% ($lang)', (
      tester,
    ) async {
      final db = await pumpApp(tester, textScale: 2.0, size: small);
      if (nepali) {
        await db.updateSettings(
          const AppSettingsTableCompanion(
            language: Value(AppLanguage.ne),
            digitStyle: Value(DigitStyle.devanagari),
          ),
        );
        await tester.pumpAndSettle();
      }
      final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
      for (final path in ['/help', '/data', '/pin', '/pin/set', '/settings']) {
        router.push(path);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: path);
        // scroll to the end of long pages
        for (var n = 0; n < 6; n++) {
          await tester.drag(
            find.byType(Scrollable).hitTestable().first,
            const Offset(0, -500),
          );
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull, reason: '$path (scrolled)');
        router.pop();
        await tester.pumpAndSettle();
      }
    });

    appTest('lock screen with the number pad @200% ($lang)', (tester) async {
      final db = await pumpApp(
        tester,
        textScale: 2.0,
        size: small,
        beforeStart: (db) async {
          await db.updateSettings(
            const AppSettingsTableCompanion(
              pinHash: Value('x'),
              pinSalt: Value('y'),
            ),
          );
        },
      );
      if (nepali) {
        await db.updateSettings(
          const AppSettingsTableCompanion(
            language: Value(AppLanguage.ne),
            digitStyle: Value(DigitStyle.devanagari),
          ),
        );
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull, reason: 'lock screen');
      // wrong PIN message appears too
      final keys = find.byType(FilledButton);
      for (var i = 0; i < 4; i++) {
        await tester.ensureVisible(keys.first);
        await tester.tap(keys.first);
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'lock screen after wrong PIN',
      );
    });
  }
}
