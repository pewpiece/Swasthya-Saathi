import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../common/action_bar.dart';
import '../common/check_tile.dart';
import '../common/confirm_dialog.dart';

/// Add or edit one medicine and the times it is given (route `/medicine/:id`,
/// where id is `new` or a number).
class MedicineFormScreen extends ConsumerStatefulWidget {
  const MedicineFormScreen({super.key, this.medicationId});
  final int? medicationId;

  @override
  ConsumerState<MedicineFormScreen> createState() => _MedicineFormScreenState();
}

class _MedicineFormScreenState extends ConsumerState<MedicineFormScreen> {
  final _name = TextEditingController();
  final _notes = TextEditingController();
  final _slots = <DoseSlot>{DoseSlot.morning};
  bool _loading = true;
  bool _saving = false;
  bool _showErrors = false;

  bool get _isEdit => widget.medicationId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.medicationId;
    if (id != null) {
      final repo = ref.read(medicationRepositoryProvider);
      final med = await repo.getMedication(id);
      final slots = await repo.activeSlotsOf(id);
      if (med != null) {
        _name.text = med.name;
        _notes.text = med.notes ?? '';
        _slots
          ..clear()
          ..addAll(slots);
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _name.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _showErrors = true);
    if (_name.text.trim().isEmpty || _slots.isEmpty) return;
    final patient = ref.read(patientProvider).value;
    if (patient == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(medicationRepositoryProvider).save(
            id: widget.medicationId,
            patientId: patient.id,
            name: _name.text,
            notes: _notes.text,
            slots: _slots,
            now: ref.read(clockProvider)(),
          );
      if (!mounted) return;
      final l = AppL10n.of(context);
      showSavedSnack(context, l.saved);
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppL10n.of(context).errorGeneric)));
    }
  }

  Future<void> _remove() async {
    final l = AppL10n.of(context);
    final ok = await confirmDialog(
      context,
      title: l.medicineRemoveTitle(_name.text.trim()),
      body: l.medicineRemoveBody,
      confirmLabel: l.removeIt,
      cancelLabel: l.keepIt,
    );
    if (!ok || !mounted) return;
    await ref
        .read(medicationRepositoryProvider)
        .remove(widget.medicationId!, ref.read(clockProvider)());
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l.medicineFormEditTitle : l.medicineFormAddTitle),
      ),
      // Buttons live in the bottom slot so a "Saved" message appears above
      // them instead of covering them.
      bottomNavigationBar: _loading
          ? null
          : ActionBar(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: Text(l.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: Text(l.save),
                    onPressed: _saving ? null : _save,
                  ),
                ),
              ],
            ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  style: theme.textTheme.titleLarge,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: l.medicineNameLabel,
                    helperText: l.medicineNameHint,
                    helperMaxLines: 2,
                    errorText: _showErrors && _name.text.trim().isEmpty
                        ? l.errorNeedMedicineName
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notes,
                  textCapitalization: TextCapitalization.sentences,
                  style: theme.textTheme.bodyLarge,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l.medicineNotesLabel,
                    helperText: l.medicineNotesHint,
                  ),
                ),
                const SizedBox(height: 24),
                Semantics(
                  header: true,
                  child: Text(l.medicineWhenTitle,
                      style: theme.textTheme.titleMedium),
                ),
                const SizedBox(height: 8),
                CheckTile(
                  label: l.slotMorning,
                  checked: _slots.contains(DoseSlot.morning),
                  onChanged: (v) => setState(() => v
                      ? _slots.add(DoseSlot.morning)
                      : _slots.remove(DoseSlot.morning)),
                ),
                const SizedBox(height: 8),
                CheckTile(
                  label: l.slotNight,
                  checked: _slots.contains(DoseSlot.night),
                  onChanged: (v) => setState(() => v
                      ? _slots.add(DoseSlot.night)
                      : _slots.remove(DoseSlot.night)),
                ),
                if (_showErrors && _slots.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(children: [
                      Icon(Icons.error_outline, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(l.errorNeedSlot,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: theme.colorScheme.error)),
                      ),
                    ]),
                  ),
                if (_isEdit) ...[
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l.medicineRemove),
                    onPressed: _remove,
                  ),
                ],
              ],
            ),
    );
  }
}
