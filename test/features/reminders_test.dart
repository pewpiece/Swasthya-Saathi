import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_gateway.dart';
import '../helpers/pump_app.dart';

Finder field(String label) => find.byWidgetPredicate(
    (w) => w is TextField && w.decoration?.labelText == label);

Future<void> tapText(WidgetTester t, String text) async {
  await t.ensureVisible(find.text(text).first);
  await t.tap(find.text(text).first);
  await t.pumpAndSettle();
}

Future<void> openReminders(WidgetTester t) async {
  await t.tap(find.descendant(
      of: find.byType(NavigationBar), matching: find.text('Settings')));
  await t.pumpAndSettle();
  await tapText(t, 'Reminders');
}

/// The app goes to the background (for example to the phone's settings page)
/// and comes back. Follows the real order of lifecycle states.
Future<void> backgroundAndReturn(WidgetTester tester, {void Function()? whileAway}) async {
  final b = tester.binding;
  for (final s in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.paused]) {
    b.handleAppLifecycleStateChanged(s);
  }
  whileAway?.call();
  for (final s in [AppLifecycleState.hidden, AppLifecycleState.inactive, AppLifecycleState.resumed]) {
    b.handleAppLifecycleStateChanged(s);
  }
  await tester.pumpAndSettle();
}

/// One tap per frame, like a person pressing a button.
Future<void> press(WidgetTester t, String tooltip, {int times = 1}) async {
  for (var i = 0; i < times; i++) {
    await t.tap(find.byTooltip(tooltip));
    await t.pumpAndSettle();
  }
}

void main() {
  const tall = Size(411, 3000);
  // The clock in tests is 2025-04-14 (Monday) 09:00.

  group('defaults and scheduling on the (fake) phone', () {
    appTest('after setup the four default reminders exist and are scheduled',
        (tester) async {
      final gw = FakeGateway();
      final db = await pumpApp(tester, size: tall, gateway: gw);
      final rows = await db.select(db.reminders).get();
      expect(rows.map((r) => r.type), unorderedEquals([
        ReminderType.medicineMorning,
        ReminderType.medicineNight,
        ReminderType.measureWeekly,
        ReminderType.measureMonthly,
      ]));
      expect(gw.initCalls, 1);
      expect(gw.scheduled.length, 4);
      final bodies = gw.scheduled.values.map((s) => s.body);
      expect(bodies, contains('Time to give Ram his morning medicine.'));
      expect(bodies, contains('Time to give Ram his night medicine.'));
      expect((await db.getSettings()).remindersSeeded, isTrue);
    });

    appTest('deleting all defaults does not bring them back on the next sync',
        (tester) async {
      final gw = FakeGateway();
      final db = await pumpApp(tester, size: tall, gateway: gw);
      await db.delete(db.reminders).go();
      await tester.pumpAndSettle();
      expect(gw.scheduled, isEmpty);
      await backgroundAndReturn(tester);
      await tester.pumpAndSettle();
      expect(await db.select(db.reminders).get(), isEmpty);
      expect(gw.scheduled, isEmpty);
    });

    appTest('survives a restart: when the app comes back, everything is re-created',
        (tester) async {
      final gw = FakeGateway();
      await pumpApp(tester, size: tall, gateway: gw);
      expect(gw.scheduled.length, 4);
      gw.scheduled.clear(); // the phone lost them (reboot / update)
      await backgroundAndReturn(tester);
      await tester.pumpAndSettle();
      expect(gw.scheduled.length, 4);
    });

    appTest('switching language or renaming him re-writes the notification text',
        (tester) async {
      final gw = FakeGateway();
      final db = await pumpApp(tester, size: tall, gateway: gw);
      await db.updateSettings(const AppSettingsTableCompanion(
          language: Value(AppLanguage.ne)));
      await tester.pumpAndSettle();
      expect(gw.scheduled.values.map((s) => s.body),
          contains('Ramलाई बिहानको औषधि दिने समय भयो।'));
      await (db.update(db.patients)).write(const PatientsCompanion(name: Value('Hari')));
      await tester.pumpAndSettle();
      expect(gw.scheduled.values.map((s) => s.body),
          contains('Hariलाई बिहानको औषधि दिने समय भयो।'));
    });

    appTest('tapping a notification opens the right screen', (tester) async {
      final gw = FakeGateway();
      await pumpApp(tester, size: tall, gateway: gw);
      gw.onTap!('/reading/new');
      await tester.pumpAndSettle();
      expect(find.text('Add reading'), findsWidgets);
      expect(find.textContaining('Choose a health condition'), findsOneWidget);
    });

    appTest('the app started by tapping a notification opens that screen',
        (tester) async {
      final gw = FakeGateway(launchedWith: '/reminders');
      await pumpApp(tester, size: tall, gateway: gw);
      expect(find.text('Choose when the phone should remind you. Tap a reminder to change it.'),
          findsOneWidget);
    });
  });

  group('permissions', () {
    appTest('notifications blocked: nothing scheduled, calm explanation, one button',
        (tester) async {
      final gw = FakeGateway(notificationsAllowed: false);
      await pumpApp(tester, size: tall, gateway: gw);
      expect(gw.scheduled, isEmpty);
      // Home explains it too.
      expect(find.text('Reminders cannot appear on this phone yet.'), findsOneWidget);
      await tapText(tester, 'Set up reminders');
      expect(find.text('Allow notifications'), findsWidgets);
      expect(find.textContaining('Settings, then Apps, then CareCompanion'), findsOneWidget);
    });

    appTest('tapping Allow grants it and the reminders appear on the phone',
        (tester) async {
      final gw = FakeGateway(notificationsAllowed: false);
      await pumpApp(tester, size: tall, gateway: gw);
      await openReminders(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Allow notifications'));
      await tester.pumpAndSettle();
      expect(gw.notificationRequests, 1);
      expect(gw.scheduled.length, 4);
      expect(find.text('Reminders are on and will arrive on time.'), findsOneWidget);
    });

    appTest('user says no: still explained, nothing scheduled, nothing breaks',
        (tester) async {
      final gw = FakeGateway(notificationsAllowed: false)..grantOnRequest = false;
      await pumpApp(tester, size: tall, gateway: gw);
      await openReminders(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Allow notifications'));
      await tester.pumpAndSettle();
      expect(gw.scheduled, isEmpty);
      expect(find.text('Allow notifications'), findsWidgets);
      expect(find.byType(FilledButton), findsWidgets);
    });

    appTest('exact alarms missing: reminders still scheduled (inexact), one clear ask',
        (tester) async {
      final gw = FakeGateway(exactAllowed: false);
      await pumpApp(tester, size: tall, gateway: gw);
      expect(gw.scheduled.length, 4);
      expect(gw.scheduled.values.every((s) => !s.exact), isTrue);
      await openReminders(tester);
      expect(find.text('Allow exact times'), findsWidgets);
      await tester.tap(find.widgetWithText(FilledButton, 'Allow exact times'));
      await tester.pumpAndSettle();
      expect(gw.exactRequests, 1);
      expect(gw.scheduled.values.every((s) => s.exact), isTrue,
          reason: 'rescheduled as exact once allowed');
      expect(find.text('Reminders are on and will arrive on time.'), findsOneWidget);
    });

    appTest('the user grants it in system settings and returns to the app',
        (tester) async {
      final gw = FakeGateway(notificationsAllowed: false);
      await pumpApp(tester, size: tall, gateway: gw);
      expect(gw.scheduled, isEmpty);
      await backgroundAndReturn(tester,
          whileAway: () => gw.notificationsAllowed = true); // changed in phone settings
      await tester.pumpAndSettle();
      expect(gw.scheduled.length, 4);
      expect(find.text('Reminders cannot appear on this phone yet.'), findsNothing);
    });
  });

  group('reminders screen', () {
    appTest('lists reminders with time, repeat, next time and on/off with words',
        (tester) async {
      await pumpApp(tester, size: tall);
      await openReminders(tester);
      expect(find.text('Morning medicine'), findsOneWidget);
      expect(find.text('8:00 AM'), findsOneWidget);
      expect(find.text('9:00 PM'), findsOneWidget);
      expect(find.text('Every day'), findsNWidgets(2));
      expect(find.text('Every Saturday'), findsOneWidget);
      expect(find.text('Day 1 of every month'), findsOneWidget);
      // Clock = Monday 9:00 AM.
      expect(find.text('Next: Tomorrow, 8:00 AM'), findsOneWidget);
      expect(find.text('Next: Today, 9:00 PM'), findsOneWidget);
      expect(find.text('Next: 19 Apr 2025, 9:00 AM'), findsOneWidget);
      expect(find.text('Reminder is on'), findsNWidgets(4));
      expect(find.text('On'), findsNWidgets(4));
    });

    appTest('switching one off cancels it on the phone; on brings it back',
        (tester) async {
      final gw = FakeGateway();
      await pumpApp(tester, size: tall, gateway: gw);
      await openReminders(tester);
      final before = gw.scheduled.length;
      final tile = find.ancestor(
          of: find.text('Reminder is on').first, matching: find.byType(InkWell));
      await tester.tap(tile.first);
      await tester.pumpAndSettle();
      expect(find.text('Reminder is off'), findsOneWidget);
      expect(find.text('Off'), findsOneWidget);
      expect(gw.scheduled.length, before - 1);
      await tester.tap(find.ancestor(
              of: find.text('Reminder is off'), matching: find.byType(InkWell)).first);
      await tester.pumpAndSettle();
      expect(gw.scheduled.length, before);
    });

    appTest('add a custom reminder with the big + buttons', (tester) async {
      final gw = FakeGateway();
      final db = await pumpApp(tester, size: tall, gateway: gw);
      await openReminders(tester);
      await tapText(tester, 'Add reminder');
      await tapText(tester, 'My own reminder');
      // A custom reminder needs a name.
      await tapText(tester, 'Save');
      expect(find.text('Please type a name for your reminder.'), findsOneWidget);
      await tester.enterText(field('Name of the reminder'), 'Eye drops');
      // 9:00 AM -> hour + 2, minutes + 3 steps, then PM.
      await press(tester, 'One hour later', times: 2);
      await press(tester, '5 minutes later', times: 3);
      expect(find.text('11:15 AM'), findsOneWidget);
      await tapText(tester, 'PM');
      expect(find.text('11:15 PM'), findsOneWidget);
      await tapText(tester, 'Save');

      final r = (await db.select(db.reminders).get()).firstWhere((r) => r.label == 'Eye drops');
      expect((r.hour, r.minute, r.repeatRule, r.enabled), (23, 15, 'daily', true));
      expect(find.text('Eye drops'), findsOneWidget);
      expect(gw.scheduled.values.map((s) => s.body), contains('Eye drops · Ram'));
    });

    appTest('weekly: pick the day; monthly: pick the date', (tester) async {
      final db = await pumpApp(tester, size: tall);
      await openReminders(tester);
      await tapText(tester, 'Add reminder');
      await tapText(tester, 'Measure again (every week)');
      await tapText(tester, 'Wednesday');
      await tapText(tester, 'Save');
      await tapText(tester, 'Add reminder');
      await tapText(tester, 'Monthly check');
      await press(tester, 'One day earlier'); // 1 -> 28 (wraps)
      expect(find.text('Day 28'), findsOneWidget);
      await press(tester, 'One day later', times: 2);
      await tapText(tester, 'Save');
      final rules = (await db.select(db.reminders).get()).map((r) => r.repeatRule);
      expect(rules, containsAll(['weekly:3', 'monthly:2']));
    });

    appTest('minutes and hours wrap around sensibly, AM/PM follows', (tester) async {
      await pumpApp(tester, size: tall);
      await openReminders(tester);
      await tapText(tester, 'Add reminder');
      await tapText(tester, 'Night medicine'); // 9:00 PM
      expect(find.text('9:00 PM'), findsWidgets);
      await press(tester, 'One hour later', times: 3);
      expect(find.text('12:00 AM'), findsOneWidget, reason: '9 PM + 3 h = midnight');
      await press(tester, '5 minutes earlier');
      expect(find.text('12:55 AM'), findsOneWidget);
    });

    appTest('change an existing reminder, then delete one with a safe confirmation',
        (tester) async {
      final gw = FakeGateway();
      final db = await pumpApp(tester, size: tall, gateway: gw);
      await openReminders(tester);
      await tapText(tester, 'Morning medicine');
      expect(find.text('Change reminder'), findsOneWidget);
      await press(tester, 'One hour earlier');
      await tapText(tester, 'Save');
      expect(find.text('7:00 AM'), findsOneWidget);
      expect(gw.scheduled.values.any((s) => s.hour == 7 && s.body.contains('morning')), isTrue);

      await tapText(tester, 'Night medicine');
      await tapText(tester, 'Delete reminder');
      expect(find.textContaining('His medicines are not changed'), findsOneWidget);
      await tapText(tester, 'Keep it');
      expect((await db.select(db.reminders).get()).length, 4);
      await tapText(tester, 'Delete reminder');
      await tapText(tester, 'Delete');
      expect((await db.select(db.reminders).get()).length, 3);
      expect(gw.scheduled.length, 3);
    });

    appTest('test buttons: now, in 1 minute, and a hint when not allowed',
        (tester) async {
      final gw = FakeGateway();
      await pumpApp(tester, size: tall, gateway: gw);
      await openReminders(tester);
      await tapText(tester, 'Send a test reminder now');
      expect(gw.shown.single.body, contains('test reminder'));
      expect(find.text('Test reminder sent. Look at the top of the screen.'), findsOneWidget);
      await tapText(tester, 'Test reminder in 1 minute');
      expect(gw.onceScheduled.single.at, DateTime(2025, 4, 14, 9, 1));
      expect(find.textContaining('You can close the app'), findsOneWidget);
      expect(find.textContaining('allow CareCompanion to run in the background'), findsOneWidget);

      gw.notificationsAllowed = false;
      await tapText(tester, 'Send a test reminder now');
      expect(gw.shown.length, 1, reason: 'not sent without permission');
      expect(find.text('Allow notifications first.'), findsOneWidget);
    });

    appTest('Nepali, Devanagari digits and BS dates', (tester) async {
      final db = await pumpApp(tester, size: tall);
      await db.updateSettings(const AppSettingsTableCompanion(
          language: Value(AppLanguage.ne),
          digitStyle: Value(DigitStyle.devanagari),
          dateStyle: Value(DateStyle.bs)));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(
          of: find.byType(NavigationBar), matching: find.text('सेटिङ')));
      await tester.pumpAndSettle();
      await tapText(tester, 'सम्झना');
      expect(find.text('८:०० पूर्वाह्न'), findsOneWidget);
      expect(find.text('हरेक शनिबार'), findsOneWidget);
      expect(find.text('हरेक महिनाको १ गते'), findsOneWidget);
      expect(find.textContaining('अर्को: भोलि, ८:००'), findsOneWidget);
    });

    appTest('screen reader: a reminder row says what it is, when, and how often',
        (tester) async {
      await pumpApp(tester, size: tall);
      await openReminders(tester);
      final handle = tester.ensureSemantics();
      expect(find.bySemanticsLabel('Morning medicine. 8:00 AM. Every day. Edit'), findsOneWidget);
      expect(find.bySemanticsLabel('Morning medicine: Reminder is on'), findsOneWidget);
      expect(find.byTooltip('One hour later'), findsNothing); // not on this screen
      handle.dispose();
    });
  });

  test('compile guard', () => expect(SystemChannels.platform, isNotNull));
}
