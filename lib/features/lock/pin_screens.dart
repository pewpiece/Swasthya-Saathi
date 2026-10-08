import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/pin_providers.dart';
import '../../data/providers.dart';
import '../../domain/pin.dart';
import '../../l10n/app_localizations.dart';
import '../common/confirm_dialog.dart';
import 'pin_pad.dart';

/// Settings -> PIN lock: explains it, and offers set / change / turn off.
class PinSettingsScreen extends ConsumerWidget {
  const PinSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final on = ref.watch(settingsProvider).value?.pinHash != null;
    return Scaffold(
      appBar: AppBar(title: Text(l.pinTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            Icon(on ? Icons.lock : Icons.lock_open, size: 40, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(on ? l.pinStateOn : l.pinStateOff, style: theme.textTheme.headlineSmall),
            ),
          ]),
          const SizedBox(height: 12),
          Text(l.pinIntro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
          if (!on)
            FilledButton.icon(
              icon: const Icon(Icons.lock),
              label: Text(l.pinSet),
              onPressed: () => context.push('/pin/set'),
            )
          else ...[
            FilledButton.icon(
              icon: const Icon(Icons.edit),
              label: Text(l.pinChange),
              onPressed: () => context.push('/pin/change'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.lock_open),
              label: Text(l.pinRemove),
              onPressed: () => context.push('/pin/remove'),
            ),
          ],
        ],
      ),
    );
  }
}

enum PinMode { set, change, remove }

enum _Step { current, fresh, confirm }

/// One PIN task at a time: type the current PIN (if needed), a new PIN, and
/// the new PIN again.
class PinFlowScreen extends ConsumerStatefulWidget {
  const PinFlowScreen({super.key, required this.mode});
  final PinMode mode;

  @override
  ConsumerState<PinFlowScreen> createState() => _PinFlowScreenState();
}

class _PinFlowScreenState extends ConsumerState<PinFlowScreen> {
  late _Step _step = widget.mode == PinMode.set ? _Step.fresh : _Step.current;
  String _pin = '';
  String _first = '';
  String? _error;

  Future<void> _changed(String v) async {
    setState(() {
      _pin = v;
      _error = null;
    });
    if (v.length < pinLength) return;
    final l = AppL10n.of(context);
    final lock = ref.read(appLockProvider.notifier);

    switch (_step) {
      case _Step.current:
        final r = await lock.verify(v);
        if (!mounted) return;
        if (r != PinResult.ok) {
          setState(() {
            _pin = '';
            _error = r == PinResult.lockedOut ? null : l.pinWrong;
          });
          if (r == PinResult.lockedOut) {
            final secs = lock.throttle.secondsLeft(ref.read(clockProvider)());
            setState(() => _error = l.pinLockedOut('$secs'));
          }
          return;
        }
        if (widget.mode == PinMode.remove) {
          await lock.clearPin();
          if (!mounted) return;
          showSavedSnack(context, l.pinRemovedMessage);
          context.pop();
        } else {
          setState(() {
            _step = _Step.fresh;
            _pin = '';
          });
        }
      case _Step.fresh:
        setState(() {
          _first = v;
          _pin = '';
          _step = _Step.confirm;
        });
      case _Step.confirm:
        if (normalizePin(v) != normalizePin(_first)) {
          setState(() {
            _pin = '';
            _first = '';
            _step = _Step.fresh;
            _error = l.pinMismatch;
          });
          return;
        }
        await lock.setPin(normalizePin(v));
        if (!mounted) return;
        showSavedSnack(context, l.pinSavedMessage);
        context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final title = switch (_step) {
      _Step.current => l.pinEnterCurrent,
      _Step.fresh => l.pinEnterNew,
      _Step.confirm => l.pinConfirmNew,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (widget.mode) {
          PinMode.set => l.pinSet,
          PinMode.change => l.pinChange,
          PinMode.remove => l.pinRemove,
        }),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Semantics(liveRegion: true, header: true, child: Text(title, style: theme.textTheme.titleLarge)),
          const SizedBox(height: 12),
          if (_error != null)
            Semantics(
              liveRegion: true,
              child: Row(children: [
                Icon(Icons.error_outline, color: theme.colorScheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_error!,
                      style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error)),
                ),
              ]),
            ),
          const SizedBox(height: 8),
          PinEntry(value: _pin, onChanged: _changed),
        ],
      ),
    );
  }
}
