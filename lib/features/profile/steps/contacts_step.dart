import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../contacts/contact_form_screen.dart';
import 'step_controller.dart';

class ContactsStep extends ConsumerStatefulWidget {
  const ContactsStep({super.key, required this.controller});
  final StepController controller;

  @override
  ConsumerState<ContactsStep> createState() => _ContactsStepState();
}

class _ContactsStepState extends ConsumerState<ContactsStep> {
  @override
  void initState() {
    super.initState();
    widget.controller.save = () async => true; // forms save themselves
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final contacts = ref.watch(contactsProvider).value ?? const [];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.contactsIntro, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 16),
        if (contacts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.contactsEmpty, style: theme.textTheme.titleMedium),
          ),
        for (final c in contacts) ...[
          Semantics(
            button: true,
            label: '${c.name}, ${roleLabel(l, c.role)}, ${c.phone}. ${l.edit}',
            excludeSemantics: true,
            child: Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.push('/contact/${c.id}'),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 72),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      Icon(roleIcon(c.role), size: 32, color: theme.colorScheme.primary),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.name,
                                style: theme.textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            Text('${roleLabel(l, c.role)} · ${c.phone}',
                                style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      const Icon(Icons.edit, size: 28),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        FilledButton.icon(
          icon: const Icon(Icons.add),
          label: Text(l.contactAdd),
          onPressed: () => context.push('/contact/new'),
        ),
      ],
    );
  }
}
