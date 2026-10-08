import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/data_providers.dart';
import '../../data/pin_providers.dart';
import '../../l10n/app_localizations.dart';
import '../common/confirm_dialog.dart';

/// Settings -> "Your data": backup file and delete everything.
class DataSettingsScreen extends ConsumerStatefulWidget {
  const DataSettingsScreen({super.key});

  @override
  ConsumerState<DataSettingsScreen> createState() => _DataSettingsScreenState();
}

class _DataSettingsScreenState extends ConsumerState<DataSettingsScreen> {
  bool _busy = false;
  bool _exportFailed = false;

  Future<void> _export() async {
    setState(() {
      _busy = true;
      _exportFailed = false;
    });
    try {
      await ref.read(exportDataProvider)();
    } catch (_) {
      if (mounted) setState(() => _exportFailed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final l = AppL10n.of(context);
    final first = await confirmDialog(
      context,
      title: l.dataDeleteTitle,
      body: l.dataDeleteBody,
      confirmLabel: l.dataDeleteConfirm,
      cancelLabel: l.dataDeleteKeep,
    );
    if (!first || !mounted) return;
    final second = await confirmDialog(
      context,
      title: l.dataDeleteSecondTitle,
      body: l.dataDeleteSecondBody,
      confirmLabel: l.dataDeleteConfirm,
      cancelLabel: l.dataDeleteKeep,
    );
    if (!second || !mounted) return;
    await ref.read(deleteAllDataProvider)();
    if (mounted) context.go('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.dataTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            Icon(Icons.save_alt, size: 36, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(l.dataExport, style: theme.textTheme.titleLarge)),
          ]),
          const SizedBox(height: 8),
          Text(l.dataExportBody, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.share),
            label: Text(l.dataExportButton),
            onPressed: _busy ? null : _export,
          ),
          if (_exportFailed) ...[
            const SizedBox(height: 12),
            Semantics(
              liveRegion: true,
              child: Row(children: [
                Icon(Icons.error_outline, color: theme.colorScheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(l.dataExportFailed,
                      style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error)),
                ),
              ]),
            ),
          ],
          const SizedBox(height: 36),
          Row(children: [
            Icon(Icons.delete_forever, size: 36, color: theme.colorScheme.error),
            const SizedBox(width: 12),
            Expanded(child: Text(l.dataDelete, style: theme.textTheme.titleLarge)),
          ]),
          const SizedBox(height: 8),
          Text(l.dataDeleteBody, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.delete_outline),
            label: Text(l.dataDelete),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error, width: 2),
            ),
            onPressed: _delete,
          ),
        ],
      ),
    );
  }
}
