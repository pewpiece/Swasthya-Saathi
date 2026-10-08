import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/dates/date_formatter.dart';
import '../../core/dates/date_only.dart';
import '../../core/format.dart';
import '../../data/providers.dart';
import '../../domain/daily_checklist.dart';
import '../../l10n/app_localizations.dart';
import 'medicine_tiles.dart';

/// His medicines (add / edit) and the last 14 days of "given" history.
class MedicinesScreen extends ConsumerWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final meds = (ref.watch(medicationsProvider).value ?? const [])
        .where((m) => m.medication.active)
        .toList();
    final adherence = ref.watch(adherenceProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l.navMedicines)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Semantics(
            header: true,
            child: Text(l.medicinesListTitle, style: theme.textTheme.titleLarge),
          ),
          const SizedBox(height: 12),
          if (meds.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(l.noMedicinesBody, style: theme.textTheme.bodyLarge),
            ),
          for (final m in meds) ...[
            MedicineTile(med: m),
            const SizedBox(height: 12),
          ],
          FilledButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l.addMedicine),
            onPressed: () => context.push('/medicine/new'),
          ),
          const SizedBox(height: 32),
          Semantics(
            header: true,
            child: Text(l.adherenceTitle, style: theme.textTheme.titleLarge),
          ),
          const SizedBox(height: 4),
          Text(l.adherenceIntro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 12),
          if (adherence == null || adherence.every((d) => d.expected == 0))
            Text(l.adherenceEmpty, style: theme.textTheme.bodyLarge)
          else
            for (final d in adherence) ...[
              _AdherenceRow(day: d),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _AdherenceRow extends ConsumerWidget {
  const _AdherenceRow({required this.day});
  final AdherenceDay day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final settings = ref.watch(settingsProvider).value!;
    final formatter = DateFormatter(
        l10n: l, style: settings.dateStyle, digits: settings.digitStyle);
    final date = parseDateKey(day.dayKey);
    final todayKey = dateKey(ref.watch(todayProvider).value ?? date);
    final dateText = day.dayKey == todayKey
        ? '${l.adherenceToday}, ${formatter.format(date)}'
        : formatter.format(date);

    final IconData icon;
    final String status;
    if (day.expected == 0) {
      icon = Icons.remove_circle_outline;
      status = l.adherenceNone;
    } else if (day.taken == day.expected) {
      icon = Icons.check_circle;
      status = l.adherenceAll;
    } else if (day.taken == 0) {
      icon = Icons.cancel_outlined;
      status = l.adherenceMissed;
    } else {
      icon = Icons.warning_amber_rounded;
      status = l.adherenceSome;
    }

    final lines = [
      if (day.morning.expected > 0)
        l.adherenceMorning(fmt.n(day.morning.taken), fmt.n(day.morning.expected)),
      if (day.night.expected > 0)
        l.adherenceNight(fmt.n(day.night.taken), fmt.n(day.night.expected)),
    ];

    return Semantics(
      container: true,
      label: '$dateText. $status. ${lines.join('. ')}',
      excludeSemantics: true,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dateText,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    Text(status, style: theme.textTheme.titleSmall),
                    for (final line in lines)
                      Text(line, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
