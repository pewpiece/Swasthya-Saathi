import 'package:care_companion/data/notifications/notification_gateway.dart';

/// A pretend phone: remembers what was scheduled so tests can look at it.
class FakeGateway implements NotificationGateway {
  FakeGateway({
    this.notificationsAllowed = true,
    this.exactAllowed = true,
    this.launchedWith,
  });

  /// When set, showing a notification fails with this error (like a phone problem).
  Object? failShowWith;

  bool notificationsAllowed;
  bool exactAllowed;
  String? launchedWith;

  int initCalls = 0;
  int cancelAllCalls = 0;
  int exactRequests = 0;
  int notificationRequests = 0;
  void Function(String? payload)? onTap;

  /// What the "phone" currently has scheduled, by notification id.
  final Map<int, ScheduledReminder> scheduled = {};
  final List<({int id, String title, String body})> shown = [];
  final List<({int id, DateTime at, bool exact})> onceScheduled = [];

  @override
  Future<void> init({required void Function(String? payload) onTap}) async {
    initCalls++;
    this.onTap = onTap;
  }

  @override
  Future<String?> launchPayload() async => launchedWith;

  @override
  Future<NotifStatus> status() async => NotifStatus(
      notificationsAllowed: notificationsAllowed, exactAllowed: exactAllowed);

  /// When true, requesting the permission grants it (like tapping "Allow").
  bool grantOnRequest = true;

  @override
  Future<bool> requestNotifications() async {
    notificationRequests++;
    if (grantOnRequest) notificationsAllowed = true;
    return notificationsAllowed;
  }

  @override
  Future<void> requestExactAlarms() async {
    exactRequests++;
    if (grantOnRequest) exactAllowed = true;
  }

  @override
  Future<void> cancelAll() async {
    cancelAllCalls++;
    scheduled.clear();
    onceScheduled.clear();
  }

  @override
  Future<int> pendingCount() async => scheduled.length + onceScheduled.length;

  @override
  Future<void> schedule(ScheduledReminder reminder) async {
    scheduled[reminder.id] = reminder;
  }

  @override
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    required NotificationChannelKind channel,
    required String channelName,
    required String channelDescription,
    String? payload,
  }) async {
    if (failShowWith != null) throw failShowWith!;
    shown.add((id: id, title: title, body: body));
  }

  @override
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
  }) async {
    onceScheduled.add((id: id, at: at, exact: exact));
  }
}
