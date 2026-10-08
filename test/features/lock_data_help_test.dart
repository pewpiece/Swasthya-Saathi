import 'dart:convert';
import 'dart:typed_data';

import 'package:care_companion/data/data_providers.dart';
import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/domain/pin.dart';
import 'package:care_companion/features/common/error_view.dart';
import 'package:care_companion/l10n/app_localizations.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_gateway.dart';
import '../helpers/pump_app.dart';

Future<void> tapText(WidgetTester t, String text) async {
  await t.ensureVisible(find.text(text).first);
  await t.tap(find.text(text).first);
  await t.pumpAndSettle();
}

Future<void> typePin(WidgetTester t, String pin) async {
  for (final d in pin.split('')) {
    await t.tap(find.widgetWithText(FilledButton, d));
    await t.pump();
  }
  await t.pumpAndSettle();
}

Future<void> openSettings(WidgetTester t) async {
  await t.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text('Settings')));
  await t.pumpAndSettle();
}

Future<void> withPin(AppDatabase db, String pin) async {
  final salt = newSalt();
  await db.updateSettings(AppSettingsTableCompanion(
      pinHash: Value(hashPin(pin, salt)), pinSalt: Value(salt)));
}

void main() {
  const tall = Size(411, 3000);

  group('PIN lock', () {
    appTest('set a PIN: type twice; only a hash is stored', (tester) async {
      final db = await pumpApp(tester, size: tall);
      await openSettings(tester);
      expect(find.text('PIN lock'), findsOneWidget);
      await tapText(tester, 'PIN lock');
      await tapText(tester, 'Set a PIN');
      expect(find.text('Choose a 4-digit PIN'), findsOneWidget);
      await typePin(tester, '1234');
      expect(find.text('Type the same PIN again'), findsOneWidget);
      await typePin(tester, '1234');
      expect(find.text('PIN is now on.'), findsOneWidget);
      final s = await db.getSettings();
      expect(s.pinHash, isNotNull);
      expect(s.pinHash!.contains('1234'), isFalse);
      expect(pinMatches('1234', s.pinSalt!, s.pinHash!), isTrue);
    });

    appTest('two different PINs: plain message, starts again, nothing saved',
        (tester) async {
      final db = await pumpApp(tester, size: tall);
      await openSettings(tester);
      await tapText(tester, 'PIN lock');
      await tapText(tester, 'Set a PIN');
      await typePin(tester, '1234');
      await typePin(tester, '1235');
      expect(find.text('The two PINs are different. Please start again.'), findsOneWidget);
      expect(find.text('Choose a 4-digit PIN'), findsOneWidget);
      expect((await db.getSettings()).pinHash, isNull);
    });

    appTest('a PIN is asked at app start; wrong then right', (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) => withPin(db, '2468'));
      expect(find.text('Type your PIN to open Swasthya Saathi'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing, reason: 'nothing visible behind the lock');
      await typePin(tester, '1111');
      expect(find.text('That PIN is wrong. Please try again.'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      await typePin(tester, '2468');
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text("Ram's day"), findsOneWidget);
    });

    appTest('5 wrong tries: locked out for 30 seconds, then it works again',
        (tester) async {
      var now = DateTime(2026, 10, 8, 9);
      await pumpApp(tester, size: tall, clock: () => now, beforeStart: (db) => withPin(db, '2468'));
      for (var i = 0; i < 5; i++) {
        await typePin(tester, '0000');
      }
      expect(find.textContaining('Too many wrong tries. Try again in'), findsOneWidget);
      // The right PIN does not work during the lock-out.
      await typePin(tester, '2468');
      expect(find.byType(NavigationBar), findsNothing);
      now = now.add(const Duration(seconds: 40));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.textContaining('Too many wrong tries'), findsNothing);
      await typePin(tester, '2468');
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    appTest('locks again after a minute in the background, not after a few seconds',
        (tester) async {
      var now = DateTime(2026, 10, 8, 9);
      await pumpApp(tester, size: tall, clock: () => now, beforeStart: (db) => withPin(db, '2468'));
      await typePin(tester, '2468');
      expect(find.byType(NavigationBar), findsOneWidget);

      Future<void> away(Duration d) async {
        final b = tester.binding;
        for (final s in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.paused]) {
          b.handleAppLifecycleStateChanged(s);
        }
        now = now.add(d);
        for (final s in [AppLifecycleState.hidden, AppLifecycleState.inactive, AppLifecycleState.resumed]) {
          b.handleAppLifecycleStateChanged(s);
        }
        await tester.pumpAndSettle();
      }

      await away(const Duration(seconds: 10));
      expect(find.byType(NavigationBar), findsOneWidget, reason: 'short break: no lock');
      await away(const Duration(minutes: 2));
      expect(find.text('Type your PIN to open Swasthya Saathi'), findsOneWidget);
    });

    appTest('no PIN set: the app never locks', (tester) async {
      var now = DateTime(2026, 10, 8, 9);
      await pumpApp(tester, size: tall, clock: () => now);
      final b = tester.binding;
      for (final s in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.paused]) {
        b.handleAppLifecycleStateChanged(s);
      }
      now = now.add(const Duration(hours: 5));
      for (final s in [AppLifecycleState.hidden, AppLifecycleState.inactive, AppLifecycleState.resumed]) {
        b.handleAppLifecycleStateChanged(s);
      }
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    appTest('change the PIN (current first), then turn it off', (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) => withPin(db, '2468'));
      await typePin(tester, '2468');
      await openSettings(tester);
      await tapText(tester, 'PIN lock');
      expect(find.text('On'), findsWidgets);
      await tapText(tester, 'Change PIN');
      expect(find.text('Type your current PIN'), findsOneWidget);
      await typePin(tester, '9999');
      expect(find.text('That PIN is wrong. Please try again.'), findsOneWidget);
      await typePin(tester, '2468');
      expect(find.text('Choose a 4-digit PIN'), findsOneWidget);
      await typePin(tester, '1357');
      await typePin(tester, '1357');
      var s = await db.getSettings();
      expect(pinMatches('1357', s.pinSalt!, s.pinHash!), isTrue);
      expect(pinMatches('2468', s.pinSalt!, s.pinHash!), isFalse);

      await tapText(tester, 'Turn off PIN');
      await typePin(tester, '1357');
      s = await db.getSettings();
      expect((s.pinHash, s.pinSalt), (null, null));
      expect(find.text('Off'), findsWidgets);
    });

    appTest('forgot PIN: the only way is to erase everything, with a warning',
        (tester) async {
      final db = await pumpApp(tester, size: tall, beforeStart: (db) => withPin(db, '2468'));
      await tapText(tester, 'Forgot PIN?');
      expect(find.textContaining('erase everything on this phone'), findsOneWidget);
      await tapText(tester, 'Keep trying');
      expect(find.text('Type your PIN to open Swasthya Saathi'), findsOneWidget);
      expect((await db.select(db.patients).get()).length, 1);
      await tapText(tester, 'Forgot PIN?');
      await tapText(tester, 'Erase everything');
      expect(await db.select(db.patients).get(), isEmpty);
      expect((await db.getSettings()).pinHash, isNull);
      expect(find.text('This app is not medical advice'), findsOneWidget, reason: 'back to the start');
    });

    appTest('Nepali digits on the pad still produce a Latin PIN', (tester) async {
      final db = await pumpApp(tester, size: tall);
      await db.updateSettings(const AppSettingsTableCompanion(
          language: Value(AppLanguage.ne), digitStyle: Value(DigitStyle.devanagari)));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text('सेटिङ')));
      await tester.pumpAndSettle();
      await tapText(tester, 'पिन लक');
      await tapText(tester, 'पिन राख्नुहोस्');
      for (final d in '१२३४'.split('')) {
        await tester.tap(find.widgetWithText(FilledButton, d));
        await tester.pump();
      }
      await tester.pumpAndSettle();
      for (final d in '१२३४'.split('')) {
        await tester.tap(find.widgetWithText(FilledButton, d));
        await tester.pump();
      }
      await tester.pumpAndSettle();
      final s = await db.getSettings();
      expect(pinMatches('1234', s.pinSalt!, s.pinHash!), isTrue);
    });

    appTest('pad is screen-reader friendly: keys and dots are announced', (tester) async {
      await pumpApp(tester, size: tall, beforeStart: (db) => withPin(db, '2468'));
      final handle = tester.ensureSemantics();
      expect(find.bySemanticsLabel('Delete last digit'), findsOneWidget);
      expect(find.bySemanticsLabel('0 of 4 digits typed'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, '5'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('1 of 4 digits typed'), findsOneWidget);
      handle.dispose();
    });
  });

  group('Your data', () {
    appTest('save a copy: a JSON file through the share sheet, no PIN inside',
        (tester) async {
      Uint8List? sent;
      String? name;
      await pumpApp(tester, size: tall,
          overrides: [
            shareFileProvider.overrideWithValue((b, n) async {
              sent = b;
              name = n;
            }),
          ],
          beforeStart: (db) => withPin(db, '2468'));
      await typePin(tester, '2468');
      await openSettings(tester);
      await tapText(tester, 'Your data');
      expect(find.textContaining('contains health information'), findsOneWidget);
      await tapText(tester, 'Create and share the file');
      expect(name, 'care_companion_backup_2025-04-14.json');
      final json = jsonDecode(utf8.decode(sent!)) as Map<String, dynamic>;
      expect((json['patients'] as List).single['name'], 'Ram');
      expect(utf8.decode(sent!).contains('pinHash'), isFalse);
      expect(name!.toLowerCase().contains('ram'), isFalse);
    });

    appTest('export failure is explained', (tester) async {
      await pumpApp(tester, size: tall, overrides: [
        shareFileProvider.overrideWithValue((b, n) async => throw StateError('x')),
      ]);
      await openSettings(tester);
      await tapText(tester, 'Your data');
      await tapText(tester, 'Create and share the file');
      expect(find.text('The file could not be made. Please try again.'), findsOneWidget);
    });

    appTest('delete all data needs TWO confirmations; Keep cancels', (tester) async {
      final gw = FakeGateway();
      final photos = FakePhotoStore();
      final db = await pumpApp(tester, size: tall, gateway: gw, photos: photos);
      expect(gw.scheduled, isNotEmpty);
      await openSettings(tester);
      await tapText(tester, 'Your data');
      await tester.tap(find.widgetWithText(OutlinedButton, 'Delete all data'));
      await tester.pumpAndSettle();
      expect(find.text('Delete all data?'), findsOneWidget);
      await tapText(tester, 'Keep my data');
      expect((await db.select(db.patients).get()).length, 1);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Delete all data'));
      await tester.pumpAndSettle();
      await tapText(tester, 'Delete everything'); // first
      expect(find.text('Are you completely sure?'), findsOneWidget);
      await tapText(tester, 'Keep my data'); // second dialog: cancel
      expect((await db.select(db.patients).get()).length, 1);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Delete all data'));
      await tester.pumpAndSettle();
      await tapText(tester, 'Delete everything');
      await tapText(tester, 'Delete everything');
      expect(await db.select(db.patients).get(), isEmpty);
      expect(await db.select(db.reminders).get(), isEmpty);
      expect(gw.scheduled, isEmpty, reason: 'phone reminders are cancelled too');
      expect(photos.removeAllCalls, 1, reason: 'the photo file is deleted too');
      expect(find.text('This app is not medical advice'), findsOneWidget, reason: 'fresh start');
    });
  });

  group('How to use', () {
    appTest('from Home (?) and from Settings; five steps, urgent one is clear',
        (tester) async {
      await pumpApp(tester, size: tall);
      await tester.tap(find.byTooltip('Help'));
      await tester.pumpAndSettle();
      expect(find.text('How to use'), findsWidgets);
      for (final t in ['Give the medicines', 'Write down a reading', 'Get reminders',
          'Show the doctor', 'If it says Urgent']) {
        expect(find.text(t), findsOneWidget, reason: t);
      }
      expect(find.text('Step 1 of 5'), findsOneWidget);
      expect(find.textContaining('never gives treatment advice'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await openSettings(tester);
      await tapText(tester, 'How to use this app');
      expect(find.text('Give the medicines'), findsOneWidget);
    });

    appTest('Nepali with Devanagari digits', (tester) async {
      final db = await pumpApp(tester, size: tall);
      await db.updateSettings(const AppSettingsTableCompanion(
          language: Value(AppLanguage.ne), digitStyle: Value(DigitStyle.devanagari)));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('मद्दत'));
      await tester.pumpAndSettle();
      expect(find.text('कसरी प्रयोग गर्ने'), findsWidgets);
      expect(find.text('चरण १ / ५'), findsOneWidget);
    });
  });

  testWidgets('error page: calm words, retry button, no technical text', (tester) async {
    var retried = 0;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppL10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppL10n.supportedLocales,
      home: ErrorView(onRetry: () => retried++),
    ));
    await tester.pumpAndSettle();
    expect(find.text('The app could not start'), findsOneWidget);
    expect(find.textContaining('close the app and open it again'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retried, 1);
    expect(find.textContaining('Exception'), findsNothing);
  });
}
