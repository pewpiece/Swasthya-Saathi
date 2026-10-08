import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../l10n/app_localizations.dart';

/// Short, optional "How to use": five steps, each with a big picture-icon.
class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final steps = <(IconData, String, String, bool)>[
      (Icons.medication, l.helpStep1Title, l.helpStep1Body, false),
      (Icons.add_circle, l.helpStep2Title, l.helpStep2Body, false),
      (Icons.notifications_active, l.helpStep3Title, l.helpStep3Body, false),
      (Icons.description, l.helpStep4Title, l.helpStep4Body, false),
      (Icons.error, l.helpStep5Title, l.helpStep5Body, true),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.helpTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.helpIntro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          for (var i = 0; i < steps.length; i++) ...[
            Semantics(
              container: true,
              label: '${l.helpStepLabel(fmt.n(i + 1), fmt.n(steps.length))}. ${steps[i].$2}. ${steps[i].$3}',
              excludeSemantics: true,
              child: Card(
                color: steps[i].$4 ? theme.colorScheme.errorContainer : null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: steps[i].$4
                              ? theme.colorScheme.error
                              : theme.colorScheme.primaryContainer,
                          child: Icon(steps[i].$1,
                              size: 40,
                              color: steps[i].$4 ? Colors.white : theme.colorScheme.onPrimaryContainer),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.helpStepLabel(fmt.n(i + 1), fmt.n(steps.length)),
                                  style: theme.textTheme.bodyMedium),
                              Text(steps[i].$2, style: theme.textTheme.titleLarge),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      Text(steps[i].$3, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(l.disclaimerTitle, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
