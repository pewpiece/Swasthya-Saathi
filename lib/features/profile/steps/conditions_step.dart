import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_keys.dart';
import '../../../data/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/check_tile.dart';
import 'step_controller.dart';

/// Switches conditions on or off. The list comes from the Metrics catalogue,
/// so a new condition appears here without code changes.
class ConditionsStep extends ConsumerStatefulWidget {
  const ConditionsStep({super.key, required this.controller});
  final StepController controller;

  @override
  ConsumerState<ConditionsStep> createState() => _ConditionsStepState();
}

class _ConditionsStepState extends ConsumerState<ConditionsStep> {
  @override
  void initState() {
    super.initState();
    widget.controller.save = () async => true; // changes save immediately
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final metrics = ref.watch(metricsProvider).value ?? const [];
    final enabled = {
      for (final c in ref.watch(conditionsProvider).value ?? const [])
        if (c.enabled) c.conditionKey,
    };
    final keys = <String>[];
    for (final m in metrics) {
      if (!keys.contains(m.conditionKey)) keys.add(m.conditionKey);
    }
    final patient = ref.watch(patientProvider).value;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.conditionsIntro, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 16),
        for (final key in keys) ...[
          CheckTile(
            label: conditionLabel(l, key),
            subtitle: enabled.contains(key)
                ? l.conditionIncluded
                : l.conditionNotIncluded,
            checked: enabled.contains(key),
            onChanged: patient == null
                ? (_) {}
                : (v) => ref
                    .read(profileRepositoryProvider)
                    .setCondition(patient.id, key, v),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
