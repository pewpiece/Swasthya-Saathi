import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'disclaimer_card.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsDisclaimerTile)),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: DisclaimerCard(),
      ),
    );
  }
}
