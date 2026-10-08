import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Never show a red error screen (or technical text) to a caregiver, and
  // never print anything that could contain a health value: only the type.
  ErrorWidget.builder = (details) => const Material(child: _FriendlyError());
  FlutterError.onError = (details) {
    debugPrint('error: ${details.exception.runtimeType}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('error: ${error.runtimeType}');
    return true;
  };

  runApp(const ProviderScope(child: CareCompanionApp()));
}

class _FriendlyError extends StatelessWidget {
  const _FriendlyError();

  @override
  Widget build(BuildContext context) {
    // Localized text if available; this widget can appear before localizations load.
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Icon(Icons.error_outline, size: 64),
      ),
    );
  }
}
