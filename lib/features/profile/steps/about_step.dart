import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../domain/number_parse.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/number_text_field.dart';
import 'step_controller.dart';

class AboutStep extends ConsumerStatefulWidget {
  const AboutStep({super.key, required this.controller});
  final StepController controller;

  @override
  ConsumerState<AboutStep> createState() => _AboutStepState();
}

class _AboutStepState extends ConsumerState<AboutStep> {
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _notes = TextEditingController();
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    widget.controller.save = _save;
    final p = ref.read(patientProvider).value;
    if (p != null) {
      _name.text = p.name;
      _notes.text = p.notes ?? '';
      if (p.birthYear != null) {
        final year = ref.read(clockProvider)().year;
        _age.text = '${year - p.birthYear!}';
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _notes.dispose();
    super.dispose();
  }

  bool get _nameOk => _name.text.trim().isNotEmpty;
  int? get _ageValue => parseWholeNumber(_age.text);
  bool get _ageOk =>
      _age.text.trim().isEmpty || (_ageValue != null && _ageValue! >= 1 && _ageValue! <= 120);

  Future<bool> _save() async {
    setState(() => _showErrors = true);
    if (!_nameOk || !_ageOk) return false;
    final year = ref.read(clockProvider)().year;
    await ref.read(profileRepositoryProvider).savePatient(
          name: _name.text,
          birthYear: _ageValue == null ? null : year - _ageValue!,
          notes: _notes.text,
        );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          style: theme.textTheme.titleLarge,
          decoration: InputDecoration(
            labelText: l.aboutNameLabel,
            helperText: l.aboutNameHint,
            errorText: _showErrors && !_nameOk ? l.errorNeedHisName : null,
          ),
        ),
        const SizedBox(height: 16),
        NumberTextField(
          controller: _age,
          label: l.aboutAgeLabel,
          errorText: _showErrors && !_ageOk ? l.errorAgeInvalid : null,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _notes,
          textCapitalization: TextCapitalization.sentences,
          style: theme.textTheme.bodyLarge,
          minLines: 1,
          maxLines: 4,
          decoration: InputDecoration(labelText: l.aboutNotesLabel),
        ),
      ],
    );
  }
}
