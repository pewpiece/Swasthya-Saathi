import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/pin.dart';
import 'db/app_database.dart';
import 'photo_store.dart';
import 'providers.dart';
import 'reminder_providers.dart';

/// Is the app locked right now? True from a cold start when a PIN is set, and
/// again when the app has been in the background for [relockAfter].
class AppLock extends Notifier<bool> {
  static const relockAfter = Duration(seconds: 60);

  final PinThrottle _throttle = PinThrottle();
  bool _started = false;
  DateTime? _wentAway;

  PinThrottle get throttle => _throttle;

  @override
  bool build() {
    ref.listen<String?>(
      settingsProvider.select((s) => s.value?.pinHash),
      (prev, next) {
        final loaded = ref.read(settingsProvider).hasValue;
        if (!loaded) return;
        if (!_started) {
          _started = true;
          state = next != null; // first look at the settings: lock if a PIN is set
        } else if (next == null) {
          state = false; // PIN removed
        }
      },
      fireImmediately: true,
    );
    final lifecycle = AppLifecycleListener(
      onHide: () => _wentAway ??= ref.read(clockProvider)(),
      onResume: () {
        final away = _wentAway;
        _wentAway = null;
        final hasPin = ref.read(settingsProvider).value?.pinHash != null;
        if (hasPin && away != null && ref.read(clockProvider)().difference(away) >= relockAfter) {
          state = true;
        }
      },
    );
    ref.onDispose(lifecycle.dispose);
    return false;
  }

  /// After everything was erased there is nothing left to protect.
  void forceUnlock() => state = false;

  void lockNow() {
    if (ref.read(settingsProvider).value?.pinHash != null) state = true;
  }

  /// Checks a typed PIN (also used before changing / removing the PIN).
  Future<PinResult> verify(String pin) async {
    final now = ref.read(clockProvider)();
    if (_throttle.isLocked(now)) return PinResult.lockedOut;
    final s = await ref.read(databaseProvider).getSettings();
    final ok = s.pinHash != null && s.pinSalt != null && pinMatches(pin, s.pinSalt!, s.pinHash!);
    return _throttle.record(correct: ok, now: now);
  }

  /// Verify and, if right, unlock.
  Future<PinResult> unlock(String pin) async {
    final r = await verify(pin);
    if (r == PinResult.ok) state = false;
    return r;
  }

  Future<void> setPin(String pin) async {
    final salt = newSalt();
    await ref.read(databaseProvider).updateSettings(AppSettingsTableCompanion(
          pinHash: Value(hashPin(pin, salt)),
          pinSalt: Value(salt),
        ));
    _started = true;
    state = false; // the person who just set it is using the app
  }

  Future<void> clearPin() async {
    await ref.read(databaseProvider).updateSettings(
        const AppSettingsTableCompanion(pinHash: Value(null), pinSalt: Value(null)));
    state = false;
  }
}

final appLockProvider = NotifierProvider<AppLock, bool>(AppLock.new);

/// Erases everything on this phone (data, PIN, reminders on the phone).
final deleteAllDataProvider = Provider<Future<void> Function()>((ref) => () async {
      await ref.read(notificationGatewayProvider).cancelAll();
      await ref.read(databaseProvider).deleteAllData();
      await ref.read(photoStoreProvider).removeAll();
      ref.read(appLockProvider.notifier).forceUnlock();
    });
