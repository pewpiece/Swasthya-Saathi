import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

/// Android only: blocks screenshots and hides the recent-apps preview.
/// The phone side starts "secure"; this tells it when the family switched
/// that off (so they can take screenshots).
class PrivacyScreen {
  static const _channel = MethodChannel('org.carecompanion/privacy');

  Future<void> set(bool secure) async {
    try {
      await _channel.invokeMethod<void>('setSecure', secure);
    } on MissingPluginException {
      // Tests and non-Android platforms have no native side.
    } on PlatformException {
      // Not worth bothering the family; the setting is still saved.
    }
  }
}

final privacyScreenProvider = Provider((ref) => PrivacyScreen());

/// Keeps the phone window in step with the setting.
final privacyScreenSyncProvider = Provider<void>((ref) {
  ref.listen(settingsProvider.select((s) => s.value?.privacyScreen), (_, on) {
    if (on != null) ref.read(privacyScreenProvider).set(on);
  }, fireImmediately: true);
});
