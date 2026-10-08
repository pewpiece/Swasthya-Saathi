import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../common/coming_soon.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.navHistory)),
      body: const ComingSoon(),
    );
  }
}
