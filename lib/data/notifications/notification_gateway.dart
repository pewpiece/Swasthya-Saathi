import '../../domain/reminder_rules.dart';

enum NotificationChannelKind { medicine, checks }

/// What the phone currently lets us do.
class NotifStatus {
  const NotifStatus({required this.notificationsAllowed, required this.exactAllowed});
  final bool notificationsAllowed;

  /// Android 12+ "Alarms & reminders". Without it reminders may be a few
  /// minutes late, but still arrive.
  final bool exactAllowed;

  static const none = NotifStatus(notificationsAllowed: false, exactAllowed: false);
}

/// One repeating reminder, ready to hand to the phone.
class ScheduledReminder {
  const ScheduledReminder({
    required this.id,
    required this.title,
    required this.body,
    required this.hour,
    required this.minute,
    required this.rule,
    required this.channel,
    required this.channelName,
    required this.channelDescription,
    required this.payload,
    required this.exact,
  });

  final int id;
  final String title;
  final String body;
  final int hour;
  final int minute;
  final RepeatRule rule;
  final NotificationChannelKind channel;
  final String channelName;
  final String channelDescription;
  final String payload; // route to open when tapped
  final bool exact;
}

/// The phone's notification system, behind an interface so the scheduling
/// logic can be tested without a phone.
abstract class NotificationGateway {
  /// Call once. [onTap] receives the payload (a route) of a tapped notification.
  Future<void> init({required void Function(String? payload) onTap});

  /// Payload of the notification that started the app, if any.
  Future<String?> launchPayload();

  Future<NotifStatus> status();
  Future<bool> requestNotifications();

  /// Opens the system "Alarms & reminders" page (Android 12+).
  Future<void> requestExactAlarms();

  Future<void> cancelAll();
  Future<void> schedule(ScheduledReminder reminder);

  /// Shows a notification right now.
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    required NotificationChannelKind channel,
    required String channelName,
    required String channelDescription,
    String? payload,
  });

  /// One-time notification at [at] (device local time).
  Future<void> scheduleOnce({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    required NotificationChannelKind channel,
    required String channelName,
    required String channelDescription,
    required bool exact,
    String? payload,
  });
}
