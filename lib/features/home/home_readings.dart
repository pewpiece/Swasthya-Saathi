import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/dates/date_formatter.dart';
import '../../core/format.dart';
import '../../core/format_reading.dart';
import '../../core/l10n/l10n_keys.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../data/reminder_providers.dart';
import '../../l10n/app_localizations.dart';
import '../readings/add_reading_chooser.dart';
import '../readings/tier_banner.dart';

/// Two big shortcuts: add a reading, open the doctor report.
class HomeShortcuts extends ConsumerWidget {
  const HomeShortcuts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final kinds = ref.watch(availableKindsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          icon: const Icon(Icons.add_circle),
          label: Text(l.addReading),
          onPressed: () => kinds.length == 1
              ? context.push('/reading/new/${kinds.first}')
              : context.push('/reading/new'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.description),
          label: Text(l.homeDoctorReport),
          onPressed: () => context.push('/report'),
        ),
      ],
    );
  }
}

/// The newest reading of each kind, with its tier as icon + words.
class LatestReadings extends ConsumerWidget {
  const LatestReadings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final kinds = ref.watch(availableKindsProvider);
    final tiles = <Widget>[];
    for (final k in kinds) {
      final r = ref.watch(latestReadingProvider(k)).value;
      if (r != null) tiles.add(_LatestTile(reading: r));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(l.homeLatestReadings, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: 10),
        if (tiles.isEmpty)
          Text(l.homeNoReadings, style: theme.textTheme.bodyLarge),
        for (final t in tiles) ...[t, const SizedBox(height: 10)],
      ],
    );
  }
}

class _LatestTile extends ConsumerWidget {
  const _LatestTile({required this.reading});
  final Reading reading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final settings = ref.watch(settingsProvider).value!;
    final f = DateFormatter(l10n: l, style: settings.dateStyle, digits: settings.digitStyle);
    final tier = ref.watch(guidanceProvider(reading.id)).value?.tier;
    final value = readingValueText(l, fmt, reading);
    final when = l.readingMeasuredAt(f.format(reading.measuredAt), fmt.time(l, reading.measuredAt));
    final kind = kindLabel(l, reading.metricKey);
    return Semantics(
      button: true,
      label: '$kind. $value. ${tier == null ? '' : tierLabel(l, tier)}. $when',
      excludeSemantics: true,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/reading/${reading.id}'),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Icon(kindIcon(reading.metricKey), size: 32, color: theme.colorScheme.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kind, style: theme.textTheme.titleSmall),
                    Text(value,
                        style: theme.textTheme.headlineSmall),
                    if (reading.tag != null)
                      Text(l10nByKey(l, reading.tag!), style: theme.textTheme.bodyMedium),
                    Text(when, style: theme.textTheme.bodyMedium),
                    if (tier != null) ...[
                      const SizedBox(height: 8),
                      Align(alignment: Alignment.centerLeft, child: TierChip(tier: tier)),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 32),
            ]),
          ),
        ),
      ),
    );
  }
}

/// "Today's guidance": the newest reading's headline and a way in. Shows no
/// range-based advice when the doctor's numbers are missing.
class TodaysGuidanceCard extends ConsumerWidget {
  const TodaysGuidanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final latest = ref.watch(latestAnyReadingProvider).value;
    if (latest == null) return const SizedBox.shrink();
    final g = ref.watch(guidanceProvider(latest.id)).value;
    if (g == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(l.homeGuidanceTitle, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: 10),
        TierBanner(tier: g.tier, headline: l10nByKey(l, g.headlineKey)),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.restaurant),
          label: Text(g.showUrgentScreen ? l.tierUrgent : l.homeSeeGuidance),
          onPressed: () => context.push('/reading/${latest.id}'),
        ),
      ],
    );
  }
}

/// Shown only when reminders are switched on but the phone would not show them.
class ReminderNudge extends ConsumerWidget {
  const ReminderNudge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final status = ref.watch(notifStatusProvider).value;
    final anyOn = (ref.watch(remindersProvider).value ?? const []).any((r) => r.enabled);
    if (status == null || status.notificationsAllowed || !anyOn) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.notifications_off, size: 30, color: theme.colorScheme.onPrimaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l.homeRemindersOff,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                ),
              ]),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => context.push('/reminders'),
                child: Text(l.homeRemindersSetup),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
