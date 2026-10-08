import 'dart:ui' show Locale;

import '../../data/enums.dart';
import '../../domain/reminder_rules.dart';
import '../../l10n/app_localizations.dart';
import 'notification_gateway.dart';

/// Id of the one-off "test reminder" notification (never used by a reminder).
const testNotificationId = 2000000000;

NotificationChannelKind channelFor(ReminderType t) =>
    t == ReminderType.medicineMorning || t == ReminderType.medicineNight
        ? NotificationChannelKind.medicine
        : NotificationChannelKind.checks;

/// Text shown in the notification. Contains the patient's first name and the
/// kind of reminder, and NEVER a health value (it can appear on a lock screen).
String reminderBody(AppL10n l, ReminderSpec r, String name) {
  switch (r.type) {
    case ReminderType.medicineMorning:
      return l.notifMedicineMorning(name);
    case ReminderType.medicineNight:
      return l.notifMedicineNight(name);
    case ReminderType.measureWeekly:
      return l.notifMeasureWeekly(name);
    case ReminderType.measureMonthly:
      return l.notifMeasureMonthly(name);
    case ReminderType.hydration:
      return l.notifHydration(name);
    case ReminderType.custom:
      final label = r.label?.trim();
      return (label == null || label.isEmpty) ? l.notifCustom(name) : '$label · $name';
  }
}

/// Turns the reminders in the database into phone notifications.
///
/// `rescheduleAll` is cheap and idempotent: it cancels everything and
/// schedules the enabled reminders again. The app calls it at every start and
/// whenever a reminder, the patient's name, the language or a permission
/// changes. The phone also restores them by itself after a restart.
class ReminderScheduler {
  ReminderScheduler(this.gateway);
  final NotificationGateway gateway;

  /// Returns the reminders that were scheduled (empty if notifications are not
  /// allowed or nothing is switched on).
  Future<List<ScheduledReminder>> rescheduleAll({
    required List<ReminderSpec> reminders,
    required String patientName,
    required Locale locale,
  }) async {
    await gateway.cancelAll();
    final status = await gateway.status();
    if (!status.notificationsAllowed) return const [];
    final l = lookupAppL10n(locale);
    final scheduled = <ScheduledReminder>[];
    for (final r in reminders) {
      if (!r.enabled) continue;
      final kind = channelFor(r.type);
      final s = ScheduledReminder(
        id: r.id,
        title: l.appName,
        body: reminderBody(l, r, patientName),
        hour: r.hour,
        minute: r.minute,
        rule: r.rule,
        channel: kind,
        channelName: kind == NotificationChannelKind.medicine
            ? l.channelMedicineName
            : l.channelChecksName,
        channelDescription: kind == NotificationChannelKind.medicine
            ? l.channelMedicineDesc
            : l.channelChecksDesc,
        payload: payloadFor(r.type),
        exact: status.exactAllowed,
      );
      await gateway.schedule(s);
      scheduled.add(s);
    }
    return scheduled;
  }

  Future<void> sendTestNow(Locale locale) {
    final l = lookupAppL10n(locale);
    return gateway.showNow(
      id: testNotificationId,
      title: l.appName,
      body: l.notifTest,
      channel: NotificationChannelKind.checks,
      channelName: l.channelChecksName,
      channelDescription: l.channelChecksDesc,
      payload: '/reminders',
    );
  }

  /// Uses the same scheduling path as real reminders, so it proves exact
  /// timing and the receiver work (the app may be closed meanwhile).
  Future<void> sendTestIn(Duration delay, Locale locale, DateTime now) async {
    final l = lookupAppL10n(locale);
    final status = await gateway.status();
    await gateway.scheduleOnce(
      id: testNotificationId,
      title: l.appName,
      body: l.notifTest,
      at: now.add(delay),
      channel: NotificationChannelKind.checks,
      channelName: l.channelChecksName,
      channelDescription: l.channelChecksDesc,
      exact: status.exactAllowed,
      payload: '/reminders',
    );
  }
}
