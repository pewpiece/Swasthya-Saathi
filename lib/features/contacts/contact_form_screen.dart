import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/number_parse.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../common/action_bar.dart';
import '../common/choice_group.dart';
import '../common/confirm_dialog.dart';

String roleLabel(AppL10n l, ContactRole r) => switch (r) {
      ContactRole.doctor => l.roleDoctor,
      ContactRole.hospital => l.roleHospital,
      ContactRole.ambulance => l.roleAmbulance,
      ContactRole.family => l.roleFamily,
    };

IconData roleIcon(ContactRole r) => switch (r) {
      ContactRole.doctor => Icons.medical_services,
      ContactRole.hospital => Icons.local_hospital,
      ContactRole.ambulance => Icons.emergency,
      ContactRole.family => Icons.family_restroom,
    };

/// Add or edit one emergency contact (route `/contact/:id`).
class ContactFormScreen extends ConsumerStatefulWidget {
  const ContactFormScreen({super.key, this.contactId});
  final int? contactId;

  @override
  ConsumerState<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends ConsumerState<ContactFormScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  ContactRole _role = ContactRole.doctor;
  bool _showErrors = false;
  bool _loading = true;

  bool get _isEdit => widget.contactId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.contactId;
    if (id != null) {
      final all = await ref.read(profileRepositoryProvider).watchContacts().first;
      final c = all.where((e) => e.id == id).firstOrNull;
      if (c != null) {
        _name.text = c.name;
        _phone.text = c.phone;
        _role = c.role;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _showErrors = true);
    if (_name.text.trim().isEmpty || !isPlausiblePhone(_phone.text)) return;
    await ref.read(profileRepositoryProvider).saveContact(
          id: widget.contactId,
          name: _name.text,
          role: _role,
          phone: _phone.text,
        );
    if (!mounted) return;
    showSavedSnack(context, AppL10n.of(context).saved);
    context.pop();
  }

  Future<void> _delete() async {
    final l = AppL10n.of(context);
    final ok = await confirmDialog(
      context,
      title: l.contactDeleteTitle(_name.text.trim()),
      body: l.contactDeleteBody,
      confirmLabel: l.deleteIt,
      cancelLabel: l.keepContact,
    );
    if (!ok || !mounted) return;
    await ref.read(profileRepositoryProvider).deleteContact(widget.contactId!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l.contactFormEditTitle : l.contactFormAddTitle),
      ),
      bottomNavigationBar: _loading
          ? null
          : ActionBar(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () => context.pop(), child: Text(l.cancel)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: Text(l.save),
                    onPressed: _save,
                  ),
                ),
              ],
            ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ChoiceGroup<ContactRole>(
                  title: l.contactRoleLabel,
                  value: _role,
                  onChanged: (r) => setState(() => _role = r),
                  choices: [
                    for (final r in ContactRole.values) Choice(r, roleLabel(l, r)),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  style: theme.textTheme.titleLarge,
                  decoration: InputDecoration(
                    labelText: l.contactNameLabel,
                    errorText: _showErrors && _name.text.trim().isEmpty
                        ? l.errorNeedName
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  style: theme.textTheme.titleLarge,
                  decoration: InputDecoration(
                    labelText: l.contactPhoneLabel,
                    errorText: _showErrors && !isPlausiblePhone(_phone.text)
                        ? l.errorPhoneInvalid
                        : null,
                  ),
                ),
                if (_isEdit) ...[
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l.contactDelete),
                    onPressed: _delete,
                  ),
                ],
              ],
            ),
    );
  }
}
