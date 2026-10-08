import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/pin_providers.dart';
import '../../data/providers.dart';
import '../../domain/pin.dart';
import '../../l10n/app_localizations.dart';
import '../common/confirm_dialog.dart';
import 'pin_pad.dart';

/// Shown over the whole app while it is locked.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  String _pin = '';
  bool _wrong = false;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    final left = ref.read(appLockProvider.notifier).throttle.secondsLeft(ref.read(clockProvider)());
    setState(() => _secondsLeft = left);
    _timer?.cancel();
    if (left > 0) {
      _timer = Timer(const Duration(seconds: 1), _tick);
    }
  }

  Future<void> _changed(String v) async {
    setState(() {
      _pin = v;
      _wrong = false;
    });
    if (v.length < pinLength) return;
    final r = await ref.read(appLockProvider.notifier).unlock(v);
    if (!mounted) return;
    setState(() {
      _pin = '';
      _wrong = r == PinResult.wrong;
    });
    if (r == PinResult.lockedOut) _tick();
  }

  Future<void> _forgot() async {
    final l = AppL10n.of(context);
    final ok = await confirmDialog(
      context,
      title: l.pinForgotTitle,
      body: l.pinForgotBody,
      confirmLabel: l.pinForgotConfirm,
      cancelLabel: l.pinKeepTrying,
    );
    if (ok) await ref.read(deleteAllDataProvider)();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Icon(Icons.lock, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Semantics(header: true, child: Text(l.pinUnlockTitle, style: theme.textTheme.titleLarge)),
            const SizedBox(height: 12),
            if (_secondsLeft > 0)
              Semantics(
                liveRegion: true,
                child: Row(children: [
                  Icon(Icons.timer, color: theme.colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(l.pinLockedOut(fmt.n(_secondsLeft)),
                        style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error)),
                  ),
                ]),
              )
            else if (_wrong)
              Semantics(
                liveRegion: true,
                child: Row(children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(l.pinWrong,
                        style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error)),
                  ),
                ]),
              ),
            const SizedBox(height: 8),
            PinEntry(value: _pin, onChanged: _changed, enabled: _secondsLeft == 0),
            const SizedBox(height: 12),
            TextButton(onPressed: _forgot, child: Text(l.pinForgot)),
          ],
        ),
      ),
    );
  }
}
