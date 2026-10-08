import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/check_tile.dart';
import 'step_controller.dart';

class FoodStep extends ConsumerStatefulWidget {
  const FoodStep({super.key, required this.controller});
  final StepController controller;

  @override
  ConsumerState<FoodStep> createState() => _FoodStepState();
}

class _FoodStepState extends ConsumerState<FoodStep> {
  final _allergies = TextEditingController();
  bool _soft = false;

  @override
  void initState() {
    super.initState();
    widget.controller.save = () async {
      await ref
          .read(profileRepositoryProvider)
          .saveFood(allergies: _allergies.text, softFood: _soft);
      return true;
    };
    final p = ref.read(patientProvider).value;
    _allergies.text = p?.allergies ?? '';
    _soft = p?.softFood ?? false;
  }

  @override
  void dispose() {
    _allergies.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.foodIntro, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 16),
        TextField(
          controller: _allergies,
          textCapitalization: TextCapitalization.sentences,
          style: theme.textTheme.bodyLarge,
          minLines: 2,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: l.allergiesLabel,
            helperText: l.allergiesHint,
          ),
        ),
        const SizedBox(height: 16),
        CheckTile(
          label: l.softFoodTitle,
          subtitle: l.softFoodHint,
          checked: _soft,
          onChanged: (v) => setState(() => _soft = v),
        ),
      ],
    );
  }
}
