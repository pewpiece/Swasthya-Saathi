import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../data/enums.dart';
import '../../data/reminder_providers.dart';
import '../../domain/reminder_rules.dart';
import '../../l10n/app_localizations.dart';
import '../common/action_bar.dart';
import '../common/choice_group.dart';
import '../common/confirm_dialog.dart';
import '../common/stepper_row.dart';
import 'reminder_labels.dart';
import 'time_stepper.dart';

/// Add or change one reminder (route `/reminder/:id`, id = `new` or a number).
class ReminderFormScreen extends ConsumerStatefulWidget {
  const ReminderFormScreen({super.key, this.reminderId});
  final int? reminderId;

  @override
  ConsumerState<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  ReminderType _type = ReminderType.medicineMorning;
  int _hour = 8;
  int _minute = 0;
  int _weekday = DateTime.saturday;
  int _monthDay = 1;
  final _label = TextEditingController();
  bool _loading = true;
  bool _showErrors = false;
  bool _saving = false;

  bool get _isEdit => widget.reminderId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.reminderId;
    if (id != null) {
      final r = await ref.read(reminderRepositoryProvider).get(id);
      if (r != null) {
        _type = r.type;
        _hour = r.hour;
        _minute = r.minute;
        _label.text = r.label ?? '';
        final rule = RepeatRule.parse(r.repeatRule);
        if (rule is WeeklyRule) _weekday = rule.weekday;
        if (rule is MonthlyRule) _monthDay = rule.day;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  RepeatRule get _rule => switch (_type) {
        ReminderType.measureWeekly => WeeklyRule(_weekday),
        ReminderType.measureMonthly => MonthlyRule(_monthDay),
        _ => const DailyRule(),
      };

  void _pickType(ReminderType t) {
    setState(() {
      _type = t;
      // A fresh type starts at its usual time (only when adding).
      if (!_isEdit) {
        final (h, m) = switch (t) {
          ReminderType.medicineMorning => (8, 0),
          ReminderType.medicineNight => (21, 0),
          ReminderType.hydration => (11, 0),
          _ => (9, 0),
        };
        _hour = h;
        _minute = m;
      }
    });
  }

  Future<void> _save() async {
    setState(() => _showErrors = true);
    if (_type == ReminderType.custom && _label.text.trim().isEmpty) return;
    setState(() => _saving = true);
    await ref.read(reminderRepositoryProvider).save(
          id: widget.reminderId,
          type: _type,
          hour: _hour,
          minute: _minute,
          rule: _rule,
          label: _type == ReminderType.custom ? _label.text : null,
        );
    if (!mounted) return;
    showSavedSnack(context, AppL10n.of(context).saved);
    context.pop();
  }

  Future<void> _delete() async {
    final l = AppL10n.of(context);
    final ok = await confirmDialog(
      context,
      title: l.reminderDeleteTitle,
      body: l.reminderDeleteBody,
      confirmLabel: l.deleteIt,
      cancelLabel: l.keepIt,
    );
    if (!ok || !mounted) return;
    await ref.read(reminderRepositoryProvider).delete(widget.reminderId!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l.reminderFormEditTitle : l.reminderFormAddTitle),
      ),
      bottomNavigationBar: _loading
          ? null
          : ActionBar(children: [
              Expanded(
                child: OutlinedButton(
                    onPressed: () => context.pop(), child: Text(l.cancel)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.check),
                  label: Text(l.save),
                  onPressed: _saving ? null : _save,
                ),
              ),
            ]),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ChoiceGroup<ReminderType>(
                  title: l.reminderTypeTitle,
                  value: _type,
                  onChanged: _pickType,
                  choices: [
                    for (final t in ReminderType.values) Choice(t, reminderTypeLabel(l, t)),
                  ],
                ),
                if (_type == ReminderType.custom) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _label,
                    textCapitalization: TextCapitalization.sentences,
                    style: theme.textTheme.titleLarge,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: l.reminderLabelLabel,
                      helperText: l.reminderLabelHint,
                      errorText: _showErrors && _label.text.trim().isEmpty
                          ? l.errorReminderLabel
                          : null,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Semantics(
                  header: true,
                  child: Text(l.reminderTimeTitle, style: theme.textTheme.titleLarge),
                ),
                const SizedBox(height: 12),
                TimeStepper(
                  hour: _hour,
                  minute: _minute,
                  onChanged: (h, m) => setState(() {
                    _hour = h;
                    _minute = m;
                  }),
                ),
                if (_type == ReminderType.measureWeekly) ...[
                  const SizedBox(height: 20),
                  ChoiceGroup<int>(
                    title: l.reminderWeekdayTitle,
                    value: _weekday,
                    onChanged: (d) => setState(() => _weekday = d),
                    choices: [
                      for (var d = 1; d <= 7; d++) Choice(d, weekdayName(l, d)),
                    ],
                  ),
                ],
                if (_type == ReminderType.measureMonthly) ...[
                  const SizedBox(height: 20),
                  StepperRow(
                    label: l.reminderMonthDayTitle,
                    value: l.reminderMonthDayValue(fmt.n(_monthDay)),
                    minusLabel: l.reminderFewerDays,
                    plusLabel: l.reminderMoreDays,
                    onMinus: () => setState(() => _monthDay = _monthDay == 1 ? 28 : _monthDay - 1),
                    onPlus: () => setState(() => _monthDay = _monthDay == 28 ? 1 : _monthDay + 1),
                  ),
                ],
                const SizedBox(height: 12),
                Text(repeatText(l, fmt, _rule), style: theme.textTheme.bodyLarge),
                if (_isEdit) ...[
                  const SizedBox(height: 28),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l.reminderDelete),
                    onPressed: _delete,
                  ),
                ],
              ],
            ),
    );
  }
}
