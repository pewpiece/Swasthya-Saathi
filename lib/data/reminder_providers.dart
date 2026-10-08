
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/reminder_rules.dart';
import '../router.dart';
import 'db/app_database.dart';
import 'notifications/local_notifications_gateway.dart';
import 'notifications/notification_gateway.dart';
import 'notifications/reminder_scheduler.dart';
import 'providers.dart';
import 'repositories/reminder_repository.dart';

final reminderRepositoryProvider =
    Provider((ref) => ReminderRepository(ref.watch(databaseProvider)));

final remindersProvider = StreamProvider<List<Reminder>>(
  (ref) => ref.watch(reminderRepositoryProvider).watchAll(),
);

/// The phone's notification system. Tests override this with a fake.
final notificationGatewayProvider =
    Provider<NotificationGateway>((ref) => LocalNotificationsGateway());

final reminderSchedulerProvider =
    Provider((ref) => ReminderScheduler(ref.watch(notificationGatewayProvider)));

ReminderSpec reminderSpecOf(Reminder r) => ReminderSpec(
      id: r.id,
      type: r.type,
      hour: r.hour,
      minute: r.minute,
      rule: RepeatRule.parse(r.repeatRule),
      enabled: r.enabled,
      label: r.label,
    );

/// Starts the notification system once, and opens the right screen when a
/// notification is tapped (also when it started the app).
final notificationsReadyProvider = FutureProvider<void>((ref) async {
  final gateway = ref.watch(notificationGatewayProvider);

  void open(String? path) {
    if (path == null || !path.startsWith('/')) return;
    final router = ref.read(routerProvider);
    router.go('/home');
    if (path != '/home') router.push(path);
  }

  await gateway.init(onTap: open);
  open(await gateway.launchPayload());
});

/// What the phone currently allows. Invalidate after asking for a permission
/// or when the app comes back to the front.
final notifStatusProvider = FutureProvider<NotifStatus>((ref) async {
  await ref.watch(notificationsReadyProvider.future);
  return ref.watch(notificationGatewayProvider).status();
});

/// Plain-words description of the last thing that went wrong while setting up
/// reminders (null when all is well). Never contains health values.
class ReminderError extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? v) => state = v;
}

final reminderErrorProvider = NotifierProvider<ReminderError, String?>(ReminderError.new);

String describeError(Object e) {
  final text = e.toString().replaceAll(RegExp(r'\s+'), ' ');
  return text.length > 160 ? '${text.substring(0, 160)}…' : text;
}

/// Number of notifications the phone is holding. Invalidate after changes.
final pendingCountProvider = FutureProvider.autoDispose<int>((ref) async {
  await ref.watch(notificationsReadyProvider.future);
  ref.watch(remindersProvider);
  return ref.watch(notificationGatewayProvider).pendingCount();
});

/// Keeps the phone's scheduled notifications equal to the reminders in the
/// database. Runs at app start and whenever the reminders, patient name,
/// language or a permission changes, so reminders also survive app updates.
/// (After a phone restart the plugin's boot receiver restores them; this
/// re-creates them again at the next app start as a safety net.)
final reminderSyncProvider = Provider<void>((ref) {
  var queue = Future<void>.value();

  Future<void> run() async {
    await ref.read(notificationsReadyProvider.future);
    final patient = ref.read(patientProvider).value;
    final settings = ref.read(settingsProvider).value;
    if (settings == null) return;
    if (patient == null) {
      // Nothing to remind about (for example after "Delete all data").
      await ref.read(notificationGatewayProvider).cancelAll();
      return;
    }
    if (!settings.remindersSeeded) {
      // Creates the defaults once; the new rows trigger another sync.
      await ref.read(reminderRepositoryProvider).seedDefaultsOnce();
      return;
    }
    final reminders = ref.read(remindersProvider).value;
    if (reminders == null) return;
    await ref.read(reminderSchedulerProvider).rescheduleAll(
          reminders: reminders.map(reminderSpecOf).toList(),
          patientName: patient.name,
          locale: Locale(settings.language.name),
        );
    ref.read(reminderErrorProvider.notifier).set(null);
  }

  void trigger() {
    queue = queue.then((_) => run()).catchError((Object e) {
      // Never log health values; the error type is enough.
      debugPrint('reminder sync failed: ${e.runtimeType}');
      ref.read(reminderErrorProvider.notifier).set(describeError(e));
    });
  }

  ref.listen(remindersProvider, (_, _) => trigger());
  ref.listen(patientProvider, (_, _) => trigger());
  ref.listen(
    settingsProvider.select((s) => (s.value?.language, s.value?.remindersSeeded)),
    (_, _) => trigger(),
  );
  ref.listen(notifStatusProvider, (_, _) => trigger());

  // Coming back from the phone's settings page: re-read the permissions.
  final lifecycle = AppLifecycleListener(onResume: () {
    ref.invalidate(notifStatusProvider);
    trigger();
  });
  ref.onDispose(lifecycle.dispose);

  trigger();
});
