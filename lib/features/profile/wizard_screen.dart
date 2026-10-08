import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../l10n/app_localizations.dart';
import '../common/action_bar.dart';
import 'steps/about_step.dart';
import 'steps/conditions_step.dart';
import 'steps/contacts_step.dart';
import 'steps/food_step.dart';
import 'steps/medicines_step.dart';
import 'steps/ranges_step.dart';
import 'steps/step_controller.dart';

typedef StepBuilder = Widget Function(StepController c);

class WizardStepDef {
  const WizardStepDef(this.title, this.icon, this.build);
  final String Function(AppL10n l) title;
  final IconData icon;
  final StepBuilder build;
}

/// The six profile steps, in order. The hub and the wizard share this list.
final wizardSteps = <WizardStepDef>[
  WizardStepDef((l) => l.stepAboutTitle, Icons.person, (c) => AboutStep(controller: c)),
  WizardStepDef((l) => l.stepConditionsTitle, Icons.monitor_heart,
      (c) => ConditionsStep(controller: c)),
  WizardStepDef((l) => l.stepFoodTitle, Icons.restaurant, (c) => FoodStep(controller: c)),
  WizardStepDef((l) => l.stepMedicinesTitle, Icons.medication,
      (c) => MedicinesStep(controller: c)),
  WizardStepDef((l) => l.stepRangesTitle, Icons.straighten, (c) => RangesStep(controller: c)),
  WizardStepDef((l) => l.stepContactsTitle, Icons.contact_phone,
      (c) => ContactsStep(controller: c)),
];

/// First-run setup (all six steps in a row) or, with [single] true, editing
/// just one step from the Profile hub.
class WizardScreen extends ConsumerStatefulWidget {
  const WizardScreen({super.key, this.startStep = 0, this.single = false});
  final int startStep;
  final bool single;

  @override
  ConsumerState<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends ConsumerState<WizardScreen> {
  late int _index = widget.startStep;
  var _controller = StepController();
  bool _busy = false;

  bool get _isLast => _index == wizardSteps.length - 1;

  Future<void> _next({bool skip = false}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      if (!skip) {
        final ok = await (_controller.save?.call() ?? Future.value(true));
        if (!ok) return;
      }
      if (!mounted) return;
      if (widget.single) {
        context.pop();
      } else if (_isLast) {
        context.go('/home');
      } else {
        setState(() {
          _index++;
          _controller = StepController();
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _back() {
    if (_index > 0 && !widget.single) {
      setState(() {
        _index--;
        _controller = StepController();
      });
    } else if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final fmt = ref.watch(fmtProvider);
    final theme = Theme.of(context);
    final step = wizardSteps[_index];
    final total = wizardSteps.length;
    final inSetup = !widget.single;
    final canGoBack = widget.single ? context.canPop() : _index > 0;

    return PopScope(
      canPop: widget.single || _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // Editing one step = a normal page: standard back button.
          // Setup = this arrow moves to the previous step.
          leading: !canGoBack
              ? null
              : widget.single
                  ? const BackButton()
                  : IconButton(
                      tooltip: l.back,
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _busy ? null : _back,
                    ),
          title: Text(inSetup ? l.wizardSetupTitle : step.title(l)),
        ),
        // One big button. Back is the arrow in the app bar (and the phone's
        // own back), so the bottom bar stays small at large text sizes.
        bottomNavigationBar: ActionBar(
          children: [
            Expanded(
              child: FilledButton.icon(
                icon: Icon(
                    widget.single || _isLast ? Icons.check : Icons.arrow_forward),
                label: Text(widget.single
                    ? l.done
                    : (_isLast ? l.wizardFinish : l.next)),
                onPressed: _busy ? null : _next,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            if (inSetup)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(step.icon, size: 28, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${l.wizardStepOf(fmt.n(_index + 1), fmt.n(total))}: ${step.title(l)}',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (_index + 1) / total,
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: KeyedSubtree(
                key: ValueKey('${widget.single}-$_index'),
                child: step.build(_controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
