import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';

String kindLabel(AppL10n l, String kind) =>
    kind == 'blood_pressure' ? l.kindBloodPressure : l.kindBloodSugar;

IconData kindIcon(String kind) =>
    kind == 'blood_pressure' ? Icons.favorite : Icons.water_drop;

/// "What did you measure?" - one big button per condition that is switched on.
/// With one condition the Home button skips this screen.
class AddReadingChooser extends ConsumerWidget {
  const AddReadingChooser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final kinds = ref.watch(availableKindsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.addReading)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (kinds.isEmpty) ...[
            Icon(Icons.info_outline, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(l.addReadingNeedCondition, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.monitor_heart),
              label: Text(l.stepConditionsTitle),
              onPressed: () => context.pushReplacement('/profile/edit/1'),
            ),
          ] else ...[
            Semantics(
              header: true,
              child: Text(l.addReadingChoose, style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            for (final k in kinds) ...[
              FilledButton.icon(
                icon: Icon(kindIcon(k), size: 32),
                label: Text(kindLabel(l, k)),
                style: FilledButton.styleFrom(minimumSize: const Size(88, 80)),
                onPressed: () => context.pushReplacement('/reading/new/$k'),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ],
      ),
    );
  }
}
