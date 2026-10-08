import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n_keys.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../domain/input_limits.dart';
import '../../domain/number_parse.dart';
import '../../l10n/app_localizations.dart';
import '../common/action_bar.dart';
import '../common/choice_group.dart';
import '../common/number_text_field.dart';

/// Log one reading in a few seconds: the number pad is already open, the time
/// of day and unit are remembered from last time, and there is one Save button.
class ReadingFormScreen extends ConsumerStatefulWidget {
  const ReadingFormScreen({super.key, required this.kind});
  final String kind; // blood_sugar | blood_pressure

  @override
  ConsumerState<ReadingFormScreen> createState() => _ReadingFormScreenState();
}

class _ReadingFormScreenState extends ConsumerState<ReadingFormScreen> {
  final _value = TextEditingController();
  final _top = TextEditingController();
  final _bottom = TextEditingController();
  final _pulse = TextEditingController();
  final _note = TextEditingController();
  String? _tag;
  late String _unit;
  bool _showErrors = false;
  bool _saving = false;
  List<String> _tags = const [];

  bool get _isSugar => widget.kind == 'blood_sugar';

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider).value;
    _unit = _isSugar
        ? (settings?.glucoseUnit == GlucoseUnit.mmolL ? 'mmol/L' : 'mg/dL')
        : 'mmHg';
    final metrics = ref.read(metricsProvider).value ?? const [];
    final metric = metrics.where((m) =>
        m.readingKey == widget.kind &&
        (_isSugar ? m.key == 'blood_sugar' : m.key == 'bp_systolic'));
    _tags = metric.isEmpty ? const [] : metric.first.tagOptions.split(',');
    final last = _isSugar ? settings?.lastSugarTag : settings?.lastBpTag;
    _tag = _tags.contains(last) ? last : (_tags.isEmpty ? null : _tags.first);
  }

  @override
  void dispose() {
    for (final c in [_value, _top, _bottom, _pulse, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  // ---- validation: plain messages, nothing saved if wrong ------------------

  String? _sugarError(AppL10n l) {
    final v = parseDecimal(_value.text);
    if (v == null) return l.errorReadingNumber;
    final lim = InputLimits.forMetric('blood_sugar', _unit)!;
    if (v < lim.min || v > lim.max) return l.errorReadingImplausible;
    return null;
  }

  String? _numError(AppL10n l, TextEditingController c, String metric,
      {bool optional = false}) {
    if (c.text.trim().isEmpty && optional) return null;
    final v = parseWholeNumber(c.text);
    if (v == null) return l.errorReadingNumber;
    final lim = InputLimits.forMetric(metric, 'mmHg')!;
    if (v < lim.min || v > lim.max) return l.errorReadingImplausible;
    return null;
  }

  String? _orderError(AppL10n l) {
    final s = parseWholeNumber(_top.text);
    final d = parseWholeNumber(_bottom.text);
    if (s != null && d != null && s <= d) return l.errorBpOrder;
    return null;
  }

  Future<void> _save() async {
    final l = AppL10n.of(context);
    setState(() => _showErrors = true);
    final errors = _isSugar
        ? [_sugarError(l)]
        : [
            _numError(l, _top, 'bp_systolic'),
            _numError(l, _bottom, 'bp_diastolic'),
            _numError(l, _pulse, 'pulse', optional: true),
            _orderError(l),
          ];
    if (errors.any((e) => e != null)) return;
    final patient = ref.read(patientProvider).value;
    if (patient == null) return;

    setState(() => _saving = true);
    final repo = ref.read(readingRepositoryProvider);
    final id = await repo.save(
      patientId: patient.id,
      kind: widget.kind,
      unit: _unit,
      measuredAt: ref.read(clockProvider)(),
      value: _isSugar ? parseDecimal(_value.text) : null,
      systolic: _isSugar ? null : parseWholeNumber(_top.text),
      diastolic: _isSugar ? null : parseWholeNumber(_bottom.text),
      pulse: _isSugar ? null : parseWholeNumber(_pulse.text),
      tag: _tag,
      note: _note.text,
    );
    // Remember the choices for next time (fewer taps).
    await ref.read(settingsActionsProvider).setGlucoseUnitAndTag(
          unit: _isSugar
              ? (_unit == 'mmol/L' ? GlucoseUnit.mmolL : GlucoseUnit.mgDl)
              : null,
          sugarTag: _isSugar ? _tag : null,
          bpTag: _isSugar ? null : _tag,
        );
    if (mounted) context.pushReplacement('/reading/$id');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final show = _showErrors;
    final orderErr = show && !_isSugar ? _orderError(l) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSugar ? l.readingFormSugarTitle : l.readingFormBpTitle),
      ),
      bottomNavigationBar: ActionBar(children: [
        Expanded(
          child: FilledButton.icon(
            icon: const Icon(Icons.check),
            label: Text(l.readingSave),
            onPressed: _saving ? null : _save,
          ),
        ),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          if (_isSugar) ...[
            TextField(
              controller: _value,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: theme.textTheme.displaySmall,
              decoration: InputDecoration(
                labelText: l.readingSugarLabel,
                suffixText: _unit,
                suffixStyle: theme.textTheme.titleLarge,
                errorText: show ? _sugarError(l) : null,
                errorMaxLines: 3,
              ),
            ),
            const SizedBox(height: 16),
            ChoiceGroup<String>(
              title: l.readingUnitTitle,
              value: _unit,
              onChanged: (u) => setState(() => _unit = u),
              choices: const [Choice('mg/dL', 'mg/dL'), Choice('mmol/L', 'mmol/L')],
            ),
          ] else ...[
            TextField(
              controller: _top,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: theme.textTheme.displaySmall,
              decoration: InputDecoration(
                labelText: l.bpTopLabel,
                suffixText: 'mmHg',
                errorText: show ? _numError(l, _top, 'bp_systolic') : null,
                errorMaxLines: 3,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bottom,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: theme.textTheme.displaySmall,
              decoration: InputDecoration(
                labelText: l.bpBottomLabel,
                suffixText: 'mmHg',
                errorText: show ? (_numError(l, _bottom, 'bp_diastolic') ?? orderErr) : null,
                errorMaxLines: 3,
              ),
            ),
            const SizedBox(height: 16),
            NumberTextField(
              controller: _pulse,
              label: l.bpPulseLabel,
              errorText: show ? _numError(l, _pulse, 'pulse', optional: true) : null,
              textInputAction: TextInputAction.done,
            ),
          ],
          const SizedBox(height: 16),
          if (_tags.isNotEmpty)
            ChoiceGroup<String>(
              title: l.readingWhenTitle,
              value: _tag ?? _tags.first,
              onChanged: (t) => setState(() => _tag = t),
              choices: [for (final t in _tags) Choice(t, l10nByKey(l, t))],
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _note,
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.bodyLarge,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(labelText: l.readingNoteLabel),
          ),
        ],
      ),
    );
  }
}
