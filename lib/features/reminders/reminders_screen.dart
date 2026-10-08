
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/dates/date_formatter.dart';
import '../../core/format.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../data/reminder_providers.dart';
import '../../domain/reminder_rules.dart';
import '../../l10n/app_localizations.dart';
import '../common/check_tile.dart';
import '../common/confirm_dialog.dart';
import 'reminder_labels.dart';

/// All reminders, with on/off, plus what the phone still needs (permissions)
/// and two buttons to check that reminders really arrive.
class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final reminders = ref.watch(remindersProvider).value ?? const <Reminder>[];

    return Scaffold(
      appBar: AppBar(title: Text(l.remindersTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          Text(l.remindersIntro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          const PermissionCards(),
          if (reminders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(l.remindersEmpty, style: theme.textTheme.titleMedium),
            ),
          for (final r in reminders) ...[
            ReminderCard(reminder: r),
            const SizedBox(height: 12),
          ],
          FilledButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l.remindersAdd),
            onPressed: () => context.push('/reminder/new'),
          ),
          const SizedBox(height: 32),
          const _CheckSection(),
        ],
      ),
    );
  }
}

/// Explains, in order, what the phone still needs. Shows one calm line when
/// everything is fine.
class PermissionCards extends ConsumerWidget {
  const PermissionCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final status = ref.watch(notifStatusProvider).value;
    if (status == null) return const SizedBox.shrink();
    final gateway = ref.read(notificationGatewayProvider);

    Widget card({
      required IconData icon,
      required String title,
      required String body,
      String? help,
      required String button,
      required Future<void> Function() onPressed,
    }) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(icon, size: 32, color: theme.colorScheme.onPrimaryContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(title,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Text(body,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                  if (help != null) ...[
                    const SizedBox(height: 8),
                    Text(help,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                  ],
                  const SizedBox(height: 12),
                  FilledButton(onPressed: onPressed, child: Text(button)),
                ],
              ),
            ),
          ),
        );

    if (!status.notificationsAllowed) {
      return card(
        icon: Icons.notifications_off,
        title: l.permNotifTitle,
        body: l.permNotifBody,
        help: l.permNotifHelp,
        button: l.permNotifButton,
        onPressed: () async {
          await gateway.requestNotifications();
          ref.invalidate(notifStatusProvider);
        },
      );
    }
    if (!status.exactAllowed) {
      return card(
        icon: Icons.alarm,
        title: l.permExactTitle,
        body: l.permExactBody,
        button: l.permExactButton,
        onPressed: () async {
          await gateway.requestExactAlarms();
          ref.invalidate(notifStatusProvider);
        },
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Icon(Icons.check_circle, size: 30, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(child: Text(l.permAllGood, style: theme.textTheme.titleSmall)),
      ]),
    );
  }
}

class ReminderCard extends ConsumerWidget {
  const ReminderCard({super.key, required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final settings = ref.watch(settingsProvider).value!;
    final now = ref.watch(clockProvider)();
    final rule = RepeatRule.parse(reminder.repeatRule);
    final title = reminder.type.name == 'custom' && (reminder.label ?? '').isNotEmpty
        ? reminder.label!
        : reminderTypeLabel(l, reminder.type);
    final time = timeOfDayText(l, fmt, reminder.hour, reminder.minute);
    final repeat = repeatText(l, fmt, rule);

    String? nextText;
    if (reminder.enabled) {
      final next = nextOccurrence(rule, reminder.hour, reminder.minute, now);
      final today = DateTime(now.year, now.month, now.day);
      final nextDay = DateTime(next.year, next.month, next.day);
      final f = DateFormatter(l10n: l, style: settings.dateStyle, digits: settings.digitStyle);
      final day = nextDay == today
          ? l.adherenceToday
          : nextDay == DateTime(today.year, today.month, today.day + 1)
              ? l.reminderTomorrow
              : f.format(next);
      nextText = l.reminderNext(l.reminderTimeAt(day, fmt.time(l, next)));
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            label: '$title. $time. $repeat. ${l.edit}',
            excludeSemantics: true,
            child: InkWell(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              onTap: () => context.push('/reminder/${reminder.id}'),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Icon(reminderTypeIcon(reminder.type), size: 34, color: theme.colorScheme.primary),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                        Text(time, style: theme.textTheme.headlineSmall),
                        Text(repeat, style: theme.textTheme.bodyMedium),
                        if (nextText != null) Text(nextText, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit, size: 28),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: CheckTile(
              label: reminder.enabled ? l.reminderIsOn : l.reminderIsOff,
              subtitle: reminder.enabled ? l.reminderOn : l.reminderOff,
              checked: reminder.enabled,
              semanticsLabel: '$title: ${reminder.enabled ? l.reminderIsOn : l.reminderIsOff}',
              onChanged: (v) =>
                  ref.read(reminderRepositoryProvider).setEnabled(reminder.id, v),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckSection extends ConsumerWidget {
  const _CheckSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);

    Future<void> run(Future<void> Function(Locale locale) action, String done) async {
      final status = await ref.read(notificationGatewayProvider).status();
      if (!context.mounted) return;
      if (!status.notificationsAllowed) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar(); // replace, never queue behind older ones
        messenger.showSnackBar(SnackBar(content: Text(l.remindersTestNeedsPermission)));
        return;
      }
      final language = ref.read(settingsProvider).value!.language;
      await action(Locale(language.name));
      if (context.mounted) showSavedSnack(context, done);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(l.remindersCheckTitle, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.notifications_active),
          label: Text(l.remindersTestNow),
          onPressed: () => run(
              (loc) => ref.read(reminderSchedulerProvider).sendTestNow(loc), l.remindersTestSent),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.timer),
          label: Text(l.remindersTestSoon),
          onPressed: () => run(
              (loc) => ref
                  .read(reminderSchedulerProvider)
                  .sendTestIn(const Duration(minutes: 1), loc, ref.read(clockProvider)()),
              l.remindersTestScheduled),
        ),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.battery_alert, size: 28, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(l.remindersBatteryHint, style: theme.textTheme.bodyLarge)),
        ]),
      ],
    );
  }
}
