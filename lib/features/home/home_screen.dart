import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../data/db/app_database.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../domain/daily_checklist.dart';
import '../../l10n/app_localizations.dart';
import '../common/check_tile.dart';
import '../medicines/medicine_tiles.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final patient = ref.watch(patientProvider).value;
    final checklist = ref.watch(todayChecklistProvider);
    final today = ref.watch(todayProvider).value ?? ref.watch(clockProvider)();
    final settings = ref.watch(settingsProvider).value;
    final name = patient?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(l.homeGreeting(name)),
        actions: [
          IconButton(
            tooltip: l.profileTooltip,
            iconSize: 32,
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          if (patient?.birthYear != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(l.ageYears(fmt.n(today.year - patient!.birthYear!)),
                  style: theme.textTheme.bodyLarge),
            ),
          if (settings != null) _FastingTile(settings: settings, today: today),
          const SizedBox(height: 16),
          checklist.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Text(l.errorGeneric, style: theme.textTheme.bodyLarge),
            data: (items) => items.isEmpty
                ? _NoMedicines()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final slot in DoseSlot.values)
                        _SlotSection(
                          slot: slot,
                          name: name,
                          items: items.where((i) => i.slot == slot).toList(),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _NoMedicines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.medication_outlined, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(l.noMedicinesTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(l.noMedicinesBody, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: Text(l.addMedicine),
              onPressed: () => context.push('/medicine/new'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotSection extends ConsumerWidget {
  const _SlotSection({required this.slot, required this.name, required this.items});
  final DoseSlot slot;
  final String name;
  final List<ChecklistItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const SizedBox.shrink();
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final done = items.where((i) => i.taken).length;
    final allDone = done == items.length;
    final title = slot == DoseSlot.morning
        ? l.checklistMorningTitle(name)
        : l.checklistNightTitle(name);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(slotIcon(slot), size: 30, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Semantics(
                header: true,
                child: Text(title, style: theme.textTheme.titleLarge),
              ),
            ),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Icon(allDone ? Icons.check_circle : Icons.pending_outlined,
                size: 24, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                allDone
                    ? l.doseAllDone
                    : l.doseProgress(fmt.n(done), fmt.n(items.length)),
                style: theme.textTheme.titleSmall,
              ),
            ),
          ]),
          const SizedBox(height: 10),
          for (final item in items) ...[
            _DoseTile(item: item),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _DoseTile extends ConsumerWidget {
  const _DoseTile({required this.item});
  final ChecklistItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final fmt = ref.watch(fmtProvider);
    final status = item.taken
        ? [
            if (item.takenAt != null) l.doseGivenAt(fmt.time(l, item.takenAt!)),
            l.doseUndoHint,
          ].join(' · ')
        : l.doseNotGiven;
    return CheckTile(
      label: item.medication.name,
      subtitle: status,
      checked: item.taken,
      semanticsLabel: item.taken
          ? l.doseSemanticsGiven(item.medication.name)
          : l.doseSemanticsNotGiven(item.medication.name),
      onChanged: (v) => ref.read(medicationRepositoryProvider).setTaken(
            medicationId: item.medication.id,
            slot: item.slot,
            taken: v,
            now: ref.read(clockProvider)(),
          ),
    );
  }
}

class _FastingTile extends ConsumerWidget {
  const _FastingTile({required this.settings, required this.today});
  final AppSettingsRow settings;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fasting = settings.fastingToday(today);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckTile(
          label: l.fastingTitle,
          subtitle: fasting ? l.fastingYes : l.fastingNo,
          checked: fasting,
          onChanged: (v) => ref.read(settingsActionsProvider).setFastingToday(v, today),
        ),
        if (fasting)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 28, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(child: Text(l.fastingNote, style: theme.textTheme.bodyLarge)),
              ],
            ),
          ),
      ],
    );
  }
}
