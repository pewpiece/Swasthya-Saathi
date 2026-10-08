import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../medicines/medicine_tiles.dart';
import 'step_controller.dart';

class MedicinesStep extends ConsumerStatefulWidget {
  const MedicinesStep({super.key, required this.controller});
  final StepController controller;

  @override
  ConsumerState<MedicinesStep> createState() => _MedicinesStepState();
}

class _MedicinesStepState extends ConsumerState<MedicinesStep> {
  @override
  void initState() {
    super.initState();
    widget.controller.save = () async => true; // forms save themselves
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final meds = (ref.watch(medicationsProvider).value ?? const [])
        .where((m) => m.medication.active)
        .toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.medicinesStepIntro, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 16),
        for (final m in meds) ...[
          MedicineTile(med: m),
          const SizedBox(height: 12),
        ],
        FilledButton.icon(
          icon: const Icon(Icons.add),
          label: Text(l.addMedicine),
          onPressed: () => context.push('/medicine/new'),
        ),
      ],
    );
  }
}
