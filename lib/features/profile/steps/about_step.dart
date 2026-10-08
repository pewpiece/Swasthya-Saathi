import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/photo_store.dart';
import '../../../data/providers.dart';
import '../../../domain/number_parse.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/number_text_field.dart';
import '../../common/patient_avatar.dart';
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
  String? _photo; // stored file name
  bool _photoChanged = false;
  final List<String> _replaced = []; // old/unused files to delete when saving

  @override
  void initState() {
    super.initState();
    widget.controller.save = _save;
    final p = ref.read(patientProvider).value;
    if (p != null) {
      _name.text = p.name;
      _notes.text = p.notes ?? '';
      _photo = p.photoPath;
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
      _age.text.trim().isEmpty ||
      (_ageValue != null && _ageValue! >= 1 && _ageValue! <= 120);

  Future<bool> _save() async {
    setState(() => _showErrors = true);
    if (!_nameOk || !_ageOk) return false;
    final year = ref.read(clockProvider)().year;
    await ref
        .read(profileRepositoryProvider)
        .savePatient(
          name: _name.text,
          birthYear: _ageValue == null ? null : year - _ageValue!,
          notes: _notes.text,
          setPhoto: _photoChanged,
          photoPath: _photo,
        );
    for (final old in _replaced) {
      if (old != _photo) await ref.read(photoStoreProvider).remove(old);
    }
    _replaced.clear();
    return true;
  }

  Future<void> _pick(PhotoSource source) async {
    try {
      final name = await ref.read(photoStoreProvider).pick(source);
      if (name == null || !mounted) return;
      setState(() {
        if (_photo != null) _replaced.add(_photo!);
        _photo = name;
        _photoChanged = true;
      });
    } catch (_) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(content: Text(AppL10n.of(context).photoFailed)),
      );
    }
  }

  void _removePhoto() => setState(() {
    if (_photo != null) _replaced.add(_photo!);
    _photo = null;
    _photoChanged = true;
  });

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
        const SizedBox(height: 24),
        Center(
          child: PatientAvatar(name: _name.text, photo: _photo, radius: 56),
        ),
        const SizedBox(height: 8),
        Text(
          l.photoHint,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.photo_camera),
              label: Text(l.photoTake),
              onPressed: () => _pick(PhotoSource.camera),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: Text(l.photoChoose),
              onPressed: () => _pick(PhotoSource.gallery),
            ),
            if (_photo != null)
              OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: Text(l.photoRemove),
                onPressed: _removePhoto,
              ),
          ],
        ),
      ],
    );
  }
}
