import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/reminder_rules.dart';
import 'notification_gateway.dart';

/// The real thing: flutter_local_notifications + timezone. Android first;
/// iOS is wired with the basic permission calls.
class LocalNotificationsGateway implements NotificationGateway {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;
  bool get _isIos => defaultTargetPlatform == TargetPlatform.iOS;

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  IOSFlutterLocalNotificationsPlugin? get _ios => _plugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

  @override
  Future<void> init({required void Function(String? payload) onTap}) async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    await _useDeviceTimeZone();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (r) => onTap(r.payload),
    );
    _ready = true;
  }

  /// Nepal is UTC+5:45 with no daylight saving, but the phone may be anywhere,
  /// so use the phone's own zone. Falls back to a zone with the same offset.
  Future<void> _useDeviceTimeZone() async {
    try {
      final name = (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(name));
      return;
    } catch (_) {
      // fall through
    }
    final offset = DateTime.now().timeZoneOffset;
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final loc in tz.timeZoneDatabase.locations.values) {
      if (loc.timeZone(now).offset == offset) {
        tz.setLocalLocation(loc);
        return;
      }
    }
  }

  @override
  Future<String?> launchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return details!.notificationResponse?.payload;
    }
    return null;
  }

  @override
  Future<NotifStatus> status() async {
    if (_isAndroid) {
      final a = _android;
      final enabled = await a?.areNotificationsEnabled() ?? false;
      final exact = await a?.canScheduleExactNotifications() ?? false;
      return NotifStatus(notificationsAllowed: enabled, exactAllowed: exact);
    }
    if (_isIos) {
      final p = await _ios?.checkPermissions();
      return NotifStatus(notificationsAllowed: p?.isEnabled ?? false, exactAllowed: true);
    }
    return const NotifStatus(notificationsAllowed: false, exactAllowed: true);
  }

  @override
  Future<bool> requestNotifications() async {
    if (_isAndroid) return await _android?.requestNotificationsPermission() ?? false;
    if (_isIos) {
      return await _ios?.requestPermissions(alert: true, sound: true, badge: false) ?? false;
    }
    return false;
  }

  @override
  Future<void> requestExactAlarms() async {
    if (_isAndroid) await _android?.requestExactAlarmsPermission();
  }

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  @override
  Future<int> pendingCount() async => (await _plugin.pendingNotificationRequests()).length;

  NotificationDetails _details(NotificationChannelKind kind, String name, String desc) {
    final medicine = kind == NotificationChannelKind.medicine;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        medicine ? 'medicine_reminders' : 'check_reminders',
        name,
        channelDescription: desc,
        icon: 'ic_notification',
        importance: medicine ? Importance.max : Importance.high,
        priority: medicine ? Priority.max : Priority.high,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  tz.TZDateTime _tzAt(DateTime d) =>
      tz.TZDateTime(tz.local, d.year, d.month, d.day, d.hour, d.minute, d.second);

  @override
  Future<void> schedule(ScheduledReminder r) {
    final next = nextOccurrence(r.rule, r.hour, r.minute, tz.TZDateTime.now(tz.local));
    final match = switch (r.rule) {
      DailyRule() => DateTimeComponents.time,
      WeeklyRule() => DateTimeComponents.dayOfWeekAndTime,
      MonthlyRule() => DateTimeComponents.dayOfMonthAndTime,
    };
    return _plugin.zonedSchedule(
      id: r.id,
      title: r.title,
      body: r.body,
      scheduledDate: _tzAt(next),
      notificationDetails: _details(r.channel, r.channelName, r.channelDescription),
      androidScheduleMode: r.exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: match,
      payload: r.payload,
    );
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
  }) =>
      _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _details(channel, channelName, channelDescription),
        payload: payload,
      );

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
  }) =>
      _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: _tzAt(at),
        notificationDetails: _details(channel, channelName, channelDescription),
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
}
