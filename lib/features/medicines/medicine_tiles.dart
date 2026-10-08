import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/enums.dart';
import '../../domain/daily_checklist.dart';
import '../../l10n/app_localizations.dart';

String slotLabel(AppL10n l, DoseSlot s) =>
    s == DoseSlot.morning ? l.slotMorning : l.slotNight;

IconData slotIcon(DoseSlot s) =>
    s == DoseSlot.morning ? Icons.wb_sunny : Icons.nights_stay;

/// One medicine: name, notes and its times (icon + text). Tap to edit.
class MedicineTile extends StatelessWidget {
  const MedicineTile({super.key, required this.med});
  final MedWithSlots med;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final slots = DoseSlot.values.where(med.activeSlots.contains).toList();
    final summary = slots.isEmpty
        ? l.medicineNoTime
        : slots.map((s) => slotLabel(l, s)).join(', ');
    return Semantics(
      button: true,
      label: '${med.medication.name}. $summary. ${l.edit}',
      excludeSemantics: true,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/medicine/${med.medication.id}'),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.medication, size: 32, color: theme.colorScheme.primary),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(med.medication.name,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            for (final s in slots)
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(slotIcon(s), size: 22),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(slotLabel(l, s),
                                      style: theme.textTheme.bodyMedium),
                                ),
                              ]),
                            if (slots.isEmpty)
                              Text(summary, style: theme.textTheme.bodyMedium),
                          ],
                        ),
                        if ((med.medication.notes ?? '').isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(med.medication.notes!, style: theme.textTheme.bodyMedium),
                        ],
                      ],
                    ),
                  ),
                  const Icon(Icons.edit, size: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
