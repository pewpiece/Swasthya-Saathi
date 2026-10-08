import 'dart:ui' show Locale;

import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/notifications/notification_gateway.dart';
import 'package:care_companion/data/notifications/reminder_scheduler.dart';
import 'package:care_companion/domain/reminder_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_gateway.dart';

ReminderSpec spec(int id, ReminderType t,
        {int h = 8, int m = 0, RepeatRule rule = const DailyRule(), bool on = true, String? label}) =>
    ReminderSpec(id: id, type: t, hour: h, minute: m, rule: rule, enabled: on, label: label);

void main() {
  const en = Locale('en');
  const ne = Locale('ne');

  late FakeGateway gw;
  late ReminderScheduler scheduler;
  setUp(() {
    gw = FakeGateway();
    scheduler = ReminderScheduler(gw);
  });

  final all = [
    spec(1, ReminderType.medicineMorning, h: 8),
    spec(2, ReminderType.medicineNight, h: 21),
    spec(3, ReminderType.measureWeekly, h: 9, rule: const WeeklyRule(6)),
    spec(4, ReminderType.measureMonthly, h: 9, rule: const MonthlyRule(1)),
  ];

  test('schedules every enabled reminder with its own id, time and rule', () async {
    final out = await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
    expect(out.length, 4);
    expect(gw.scheduled.keys, unorderedEquals([1, 2, 3, 4]));
    expect((gw.scheduled[2]!.hour, gw.scheduled[2]!.minute), (21, 0));
    expect(gw.scheduled[3]!.rule, const WeeklyRule(6));
    expect(gw.scheduled[4]!.rule, const MonthlyRule(1));
  });

  test('disabled reminders are not scheduled (and old ones are cancelled)', () async {
    await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
    await scheduler.rescheduleAll(
        reminders: [all[0], spec(2, ReminderType.medicineNight, on: false)],
        patientName: 'Ram',
        locale: en);
    expect(gw.scheduled.keys, [1]);
  });

  test('deleted reminders disappear (nothing stale is left)', () async {
    await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
    await scheduler.rescheduleAll(reminders: [all[3]], patientName: 'Ram', locale: en);
    expect(gw.scheduled.keys, [4]);
    expect(gw.cancelAllCalls, 2);
  });

  test('calling it again changes nothing (safe at every app start)', () async {
    await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
    final first = Map.of(gw.scheduled);
    await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
    expect(gw.scheduled.keys, first.keys);
    for (final id in first.keys) {
      expect(gw.scheduled[id]!.body, first[id]!.body);
    }
  });

  test('notifications NOT allowed: nothing is scheduled, nothing crashes', () async {
    gw.notificationsAllowed = false;
    final out = await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
    expect(out, isEmpty);
    expect(gw.scheduled, isEmpty);
  });

  test('exact permission decides exact vs inexact (fallback keeps reminders)', () async {
    gw.exactAllowed = false;
    await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
    expect(gw.scheduled.values.every((s) => !s.exact), isTrue);
    expect(gw.scheduled.length, 4, reason: 'still scheduled, just not exact');
    gw.exactAllowed = true;
    await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
    expect(gw.scheduled.values.every((s) => s.exact), isTrue);
  });

  group('notification text', () {
    test('English, by name, per type', () async {
      await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
      expect(gw.scheduled[1]!.title, 'Swasthya Saathi');
      expect(gw.scheduled[1]!.body, 'Time to give Ram his morning medicine.');
      expect(gw.scheduled[2]!.body, 'Time to give Ram his night medicine.');
      expect(gw.scheduled[3]!.body, "Time to measure Ram's health again.");
      expect(gw.scheduled[4]!.body, contains('Ram'));
    });
    test('Nepali', () async {
      await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: ne);
      expect(gw.scheduled[1]!.body, 'Ramलाई बिहानको औषधि दिने समय भयो।');
      expect(gw.scheduled[1]!.title, 'स्वास्थ्य साथी');
    });
    test('changing the name or language changes the text on the next sync', () async {
      await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
      await scheduler.rescheduleAll(reminders: all, patientName: 'Hari', locale: ne);
      expect(gw.scheduled[1]!.body, 'Hariलाई बिहानको औषधि दिने समय भयो।');
    });
    test('custom reminder uses its own label; hydration mentions fluid limits', () async {
      await scheduler.rescheduleAll(reminders: [
        spec(5, ReminderType.custom, label: 'Eye drops'),
        spec(6, ReminderType.custom),
        spec(7, ReminderType.hydration),
      ], patientName: 'Ram', locale: en);
      expect(gw.scheduled[5]!.body, 'Eye drops · Ram');
      expect(gw.scheduled[6]!.body, 'Reminder for Ram.');
      expect(gw.scheduled[7]!.body, contains('limited fluids'));
    });
    test('PRIVACY: no digits (no health values) in any default notification', () async {
      for (final locale in [en, ne]) {
        await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: locale);
        for (final s in gw.scheduled.values) {
          expect(RegExp(r'[0-9०-९]').hasMatch(s.body), isFalse, reason: s.body);
        }
      }
    });
    test('SAFETY: never tells anyone to start, stop or change a medicine', () async {
      await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
      for (final s in gw.scheduled.values) {
        final b = s.body.toLowerCase();
        for (final bad in ['stop', 'increase', 'double', 'extra dose', 'skip']) {
          expect(b.contains(bad) && !b.contains('skip this if'), isFalse, reason: '${s.body}: $bad');
        }
      }
    });
  });

  test('channels: medicine reminders are high priority, others normal', () async {
    await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
    expect(gw.scheduled[1]!.channel, NotificationChannelKind.medicine);
    expect(gw.scheduled[2]!.channel, NotificationChannelKind.medicine);
    expect(gw.scheduled[3]!.channel, NotificationChannelKind.checks);
    expect(gw.scheduled[1]!.channelName, 'Medicine reminders');
  });

  test('tapping opens the right screen', () async {
    await scheduler.rescheduleAll(reminders: all, patientName: 'Ram', locale: en);
    expect(gw.scheduled[1]!.payload, '/home');
    expect(gw.scheduled[3]!.payload, '/reading/new');
  });

  test('ids never collide with the test notification', () {
    expect(testNotificationId, greaterThan(1000000000));
  });

  group('test reminders', () {
    test('"now" shows immediately', () async {
      await scheduler.sendTestNow(en);
      expect(gw.shown.single.id, testNotificationId);
      expect(gw.shown.single.body, contains('test reminder'));
    });
    test('"in 1 minute" uses the scheduled path, exact only if allowed', () async {
      final now = DateTime(2026, 10, 8, 9, 0, 30);
      await scheduler.sendTestIn(const Duration(minutes: 1), en, now);
      expect(gw.onceScheduled.single.at, DateTime(2026, 10, 8, 9, 1, 30));
      expect(gw.onceScheduled.single.exact, isTrue);
      gw.exactAllowed = false;
      await scheduler.sendTestIn(const Duration(minutes: 1), en, now);
      expect(gw.onceScheduled.last.exact, isFalse);
    });
  });
}
