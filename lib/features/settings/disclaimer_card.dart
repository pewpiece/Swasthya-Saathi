import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// The "This app is not medical advice" notice. Shown on first launch and in
/// Settings, so the wording lives in exactly one place.
class DisclaimerCard extends StatelessWidget {
  const DisclaimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline,
                    size: 32, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(l.disclaimerTitle,
                        style: theme.textTheme.titleMedium),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(l.disclaimerBody, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 12),
            Text(l.disclaimerPrivacy, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
