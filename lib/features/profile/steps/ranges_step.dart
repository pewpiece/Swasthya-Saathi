import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_keys.dart';
import '../../../data/db/app_database.dart';
import '../../../data/enums.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/range_repository.dart';
import '../../../domain/number_parse.dart';
import '../../../domain/range_validation.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/choice_group.dart';
import '../../common/number_text_field.dart';
import 'step_controller.dart';

/// Text boxes for one set of the doctor's numbers (one metric, one context).
class _Block {
  final urgentLow = TextEditingController();
  final cautionLow = TextEditingController();
  final cautionHigh = TextEditingController();
  final urgentHigh = TextEditingController();
  final plan = TextEditingController();
  final warning = TextEditingController();

  List<TextEditingController> get numbers =>
      [urgentLow, cautionLow, cautionHigh, urgentHigh];

  bool get hasContent =>
      numbers.any((c) => c.text.trim().isNotEmpty) ||
      plan.text.trim().isNotEmpty ||
      warning.text.trim().isNotEmpty;

  void dispose() {
    for (final c in [...numbers, plan, warning]) {
      c.dispose();
    }
  }
}

class _BlockError {
  _BlockError({this.fields = const {}});
  final Map<int, String> fields; // field index -> message
}

/// The doctor's numbers per metric. Nothing is pre-filled: empty means "not
/// entered", and then the app gives no range-based guidance.
class RangesStep extends ConsumerStatefulWidget {
  const RangesStep({super.key, required this.controller});
  final StepController controller;

  @override
  ConsumerState<RangesStep> createState() => _RangesStepState();
}

class _RangesStepState extends ConsumerState<RangesStep> {
  final _blocks = <String, _Block>{};
  final _units = <String, String>{};
  final _errors = <String, _BlockError>{};
  List<Metric> _metrics = const [];
  bool _ready = false;
  bool _hadErrors = false;

  static String _key(String metric, String? tag) => '$metric|${tag ?? ''}';

  @override
  void initState() {
    super.initState();
    widget.controller.save = _save;
    _init();
  }

  Future<void> _init() async {
    final repo = ref.read(rangeRepositoryProvider);
    final metrics = await repo.getMetrics();
    final ranges = await repo.getAll();
    final glucose = ref.read(settingsProvider).value?.glucoseUnit;
    for (final m in metrics) {
      final unitOptions = m.unitOptions.split(',');
      final existing = ranges.where((r) => r.metricKey == m.key && r.unit != null);
      var unit = existing.isNotEmpty ? existing.first.unit! : unitOptions.first;
      if (existing.isEmpty && m.key == 'blood_sugar') {
        unit = glucose == GlucoseUnit.mmolL ? 'mmol/L' : 'mg/dL';
      }
      _units[m.key] = unit;
      for (final tag in [null, ...m.tagOptions.split(',')]) {
        final b = _blocks.putIfAbsent(_key(m.key, tag), _Block.new);
        final r = ranges
            .where((r) => r.metricKey == m.key && r.tagContext == tag)
            .firstOrNull;
        if (r != null) {
          String f(double? v) =>
              v == null ? '' : (v == v.roundToDouble() ? '${v.toInt()}' : '$v');
          b.urgentLow.text = f(r.urgentLow);
          b.cautionLow.text = f(r.cautionLow);
          b.cautionHigh.text = f(r.cautionHigh);
          b.urgentHigh.text = f(r.urgentHigh);
          b.plan.text = r.doctorPlanText ?? '';
          b.warning.text = r.warningSignsText ?? '';
        }
      }
    }
    if (mounted) {
      setState(() {
        _metrics = metrics;
        _ready = true;
      });
    }
  }

  @override
  void dispose() {
    for (final b in _blocks.values) {
      b.dispose();
    }
    super.dispose();
  }

  Set<String> _enabledConditions() => {
        for (final c in ref.read(conditionsProvider).value ?? const [])
          if (c.enabled) c.conditionKey,
      };

  Future<bool> _save() async {
    final l = AppL10n.of(context);
    final patient = ref.read(patientProvider).value;
    if (patient == null) return true;
    final inputs = <RangeInput>[];
    final errors = <String, _BlockError>{};

    for (final m in _metrics) {
      final unit = _units[m.key];
      for (final tag in [null, ...m.tagOptions.split(',')]) {
        final key = _key(m.key, tag);
        final b = _blocks[key]!;
        final fieldErrors = <int, String>{};
        final values = <double?>[];
        for (var i = 0; i < 4; i++) {
          final text = b.numbers[i].text;
          final v = parseDecimal(text);
          if (text.trim().isNotEmpty && v == null) {
            fieldErrors[i] = l.errorNumberInvalid;
          }
          values.add(v);
        }
        if (fieldErrors.isEmpty) {
          final check = validateRange(
            metricKey: m.key,
            unit: unit,
            urgentLow: values[0],
            cautionLow: values[1],
            cautionHigh: values[2],
            urgentHigh: values[3],
          );
          if (!check.isOk) {
            final msg = check.problem == RangeProblem.wrongOrder
                ? l.errorRangeOrder
                : l.errorRangeImplausible;
            fieldErrors[check.badField!] = msg;
          }
        }
        if (fieldErrors.isNotEmpty) {
          errors[key] = _BlockError(fields: fieldErrors);
        }
        inputs.add(RangeInput(
          metricKey: m.key,
          tagContext: tag,
          unit: unit,
          urgentLow: values[0],
          cautionLow: values[1],
          cautionHigh: values[2],
          urgentHigh: values[3],
          doctorPlanText: b.plan.text,
          warningSignsText: tag == null ? b.warning.text : null,
        ));
      }
    }

    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
      _hadErrors = errors.isNotEmpty;
    });
    if (errors.isNotEmpty) return false;

    final repo = ref.read(rangeRepositoryProvider);
    for (final input in inputs) {
      await repo.save(patient.id, input);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    if (!_ready) return const Center(child: CircularProgressIndicator());
    final enabled = ref.watch(conditionsProvider).value == null
        ? <String>{}
        : _enabledConditions();
    final shown = _metrics.where((m) => enabled.contains(m.conditionKey)).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.rangesIntro, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 16),
        if (_hadErrors) ...[
          _Notice(icon: Icons.warning_amber_rounded, text: l.errorFixMarked, error: true),
          const SizedBox(height: 16),
        ],
        if (shown.isEmpty)
          _Notice(icon: Icons.info_outline, text: l.rangesNoConditions),
        for (final m in shown) ...[
          _metricCard(context, m),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _metricCard(BuildContext context, Metric m) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final units = m.unitOptions.split(',');
    final tags = m.tagOptions.split(',');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(l10nByKey(l, m.nameKey), style: theme.textTheme.titleLarge),
            ),
            if (units.length > 1) ...[
              const SizedBox(height: 12),
              ChoiceGroup<String>(
                title: l.rangeUnit,
                value: _units[m.key]!,
                onChanged: (u) => setState(() => _units[m.key] = u),
                choices: [for (final u in units) Choice(u, u)],
              ),
            ],
            const SizedBox(height: 16),
            _blockFields(context, m, null, showWarning: true),
            const SizedBox(height: 8),
            Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                minTileHeight: 56,
                title: Text(l.rangeSpecificTimes,
                    style: theme.textTheme.titleSmall),
                children: [
                  for (final tag in tags)
                    _TagSection(
                      title: l10nByKey(l, tag),
                      filled: _blocks[_key(m.key, tag)]!.hasContent,
                      filledLabel: l.rangeFilled,
                      emptyLabel: l.rangeNotEntered,
                      initiallyExpanded: _blocks[_key(m.key, tag)]!.hasContent,
                      child: _blockFields(context, m, tag, showWarning: false),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blockFields(BuildContext context, Metric m, String? tag,
      {required bool showWarning}) {
    final l = AppL10n.of(context);
    final key = _key(m.key, tag);
    final b = _blocks[key]!;
    final err = _errors[key];
    final unit = _units[m.key] ?? '';
    final labels = [
      l.rangeUrgentLow,
      l.rangeCautionLow,
      l.rangeCautionHigh,
      l.rangeUrgentHigh,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tag == null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l.rangeAllTimes,
                style: Theme.of(context).textTheme.titleMedium),
          ),
        for (var i = 0; i < 4; i++) ...[
          NumberTextField(
            controller: b.numbers[i],
            label: '${labels[i]} ($unit)',
            decimal: true,
            errorText: err?.fields[i],
          ),
          const SizedBox(height: 12),
        ],
        TextField(
          controller: b.plan,
          textCapitalization: TextCapitalization.sentences,
          minLines: 2,
          maxLines: 6,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            labelText: l.rangeDoctorPlan,
            helperText: l.rangeDoctorPlanHint,
            helperMaxLines: 2,
          ),
        ),
        if (showWarning) ...[
          const SizedBox(height: 12),
          TextField(
            controller: b.warning,
            textCapitalization: TextCapitalization.sentences,
            minLines: 2,
            maxLines: 6,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: l.rangeWarningSigns,
              helperText: l.rangeWarningSignsHint,
            ),
          ),
        ],
      ],
    );
  }
}

class _TagSection extends StatelessWidget {
  const _TagSection({
    required this.title,
    required this.filled,
    required this.filledLabel,
    required this.emptyLabel,
    required this.initiallyExpanded,
    required this.child,
  });

  final String title;
  final bool filled;
  final String filledLabel;
  final String emptyLabel;
  final bool initiallyExpanded;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.only(left: 8),
        minTileHeight: 64,
        initiallyExpanded: initiallyExpanded,
        leading: Icon(filled ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 28),
        title: Text(title, style: theme.textTheme.titleSmall),
        subtitle: Text(filled ? filledLabel : emptyLabel),
        childrenPadding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [child],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, this.error = false});
  final IconData icon;
  final String text;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = error ? theme.colorScheme.onErrorContainer : theme.colorScheme.onPrimaryContainer;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: error ? theme.colorScheme.errorContainer : theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        Icon(icon, size: 32, color: fg),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: theme.textTheme.bodyLarge?.copyWith(color: fg))),
      ]),
    );
  }
}
