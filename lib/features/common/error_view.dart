import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// A calm, plain-language error page. Never shows technical details or any
/// health value.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.onRetry});
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Semantics(
                  header: true,
                  liveRegion: true,
                  child: Text(l.errorStartupTitle,
                      style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
                ),
                const SizedBox(height: 12),
                Text(l.errorStartupBody,
                    style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
                if (onRetry != null) ...[
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: Text(l.errorRetry),
                    onPressed: onRetry,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
