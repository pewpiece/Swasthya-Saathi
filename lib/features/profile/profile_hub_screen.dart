import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/l10n/l10n_keys.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import 'wizard_screen.dart';

/// Everything about him in one list. Tap a line to edit just that part.
class ProfileHubScreen extends ConsumerWidget {
  const ProfileHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final patient = ref.watch(patientProvider).value;
    final year = ref.watch(clockProvider)().year;
    final conditions = [
      for (final c in ref.watch(conditionsProvider).value ?? const [])
        if (c.enabled) conditionLabel(l, c.conditionKey),
    ];
    final meds = (ref.watch(medicationsProvider).value ?? const [])
        .where((m) => m.medication.active)
        .length;
    final rangeCount = ref.watch(rangesProvider).value?.length ?? 0;
    final contacts = ref.watch(contactsProvider).value?.length ?? 0;

    String count(int n) => n == 0 ? l.summaryNotSet : l.summaryCount(fmt.n(n));
    final summaries = <String>[
      patient == null
          ? l.summaryNotSet
          : [
              patient.name,
              if (patient.birthYear != null) l.ageYears(fmt.n(year - patient.birthYear!)),
            ].join(', '),
      conditions.isEmpty ? l.summaryNotSet : conditions.join(', '),
      [
        if ((patient?.allergies ?? '').isNotEmpty) patient!.allergies!,
        if (patient?.softFood ?? false) l.summarySoftFood,
      ].join(' · ').isEmpty
          ? l.summaryNotSet
          : [
              if ((patient?.allergies ?? '').isNotEmpty) patient!.allergies!,
              if (patient?.softFood ?? false) l.summarySoftFood,
            ].join(' · '),
      count(meds),
      count(rangeCount),
      count(contacts),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (patient != null) ...[
            Text(l.profileHubIntro(patient.name), style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
          ],
          for (var i = 0; i < wizardSteps.length; i++) ...[
            Semantics(
              button: true,
              label: '${wizardSteps[i].title(l)}. ${summaries[i]}',
              excludeSemantics: true,
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push('/profile/edit/$i'),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 72),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        Icon(wizardSteps[i].icon, size: 32, color: theme.colorScheme.primary),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(wizardSteps[i].title(l),
                                  style: theme.textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                              Text(summaries[i], style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 32),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
