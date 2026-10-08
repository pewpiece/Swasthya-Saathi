import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../common/coming_soon.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.navMedicines)),
      body: const ComingSoon(),
    );
  }
}
