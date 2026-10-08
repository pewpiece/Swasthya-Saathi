import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/dates/date_formatter.dart';
import '../../core/format.dart';
import '../../core/format_reading.dart';
import '../../core/l10n/guidance_texts.dart';
import '../../core/l10n/l10n_keys.dart';
import '../../data/db/app_database.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../domain/guidance_engine.dart';
import '../../domain/number_parse.dart';
import '../../l10n/app_localizations.dart';
import '../common/action_bar.dart';
import '../common/confirm_dialog.dart';
import '../contacts/contact_form_screen.dart';
import 'tier_banner.dart';

/// Shown right after saving a reading (and when opened from Home).
/// Urgent -> the big urgent screen only. Otherwise -> the guidance screen.
class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key, required this.readingId});
  final int readingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final reading = ref.watch(readingByIdProvider(readingId));
    final guidance = ref.watch(guidanceProvider(readingId));

    Widget message(String text) => Scaffold(
          appBar: AppBar(title: Text(l.resultTitle)),
          body: Center(
              child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          )),
        );

    if (guidance.hasError || reading.hasError) return message(l.errorGeneric);
    if (!guidance.hasValue || !reading.hasValue) {
      return Scaffold(
        appBar: AppBar(title: Text(l.resultTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final r = reading.value;
    final g = guidance.value;
    if (r == null || g == null) return message(l.readingNotFound);
    return g.showUrgentScreen
        ? UrgentView(reading: r, result: g)
        : GuidanceView(reading: r, result: g);
  }
}

/// Asks first, then removes the reading (it also leaves the history and the
/// doctor report) and goes back.
Future<void> confirmDeleteReading(BuildContext context, WidgetRef ref, int id) async {
  final l = AppL10n.of(context);
  final ok = await confirmDialog(
    context,
    title: l.readingDeleteTitle,
    body: l.readingDeleteBody,
    confirmLabel: l.deleteIt,
    cancelLabel: l.keepIt,
  );
  if (!ok || !context.mounted) return;
  await ref.read(readingRepositoryProvider).delete(id);
  if (!context.mounted) return;
  context.canPop() ? context.pop() : context.go('/home');
}

// ---------------------------------------------------------------------------

class _ReadingSummary extends ConsumerWidget {
  const _ReadingSummary({required this.reading, this.large = false});
  final Reading reading;
  final bool large;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final settings = ref.watch(settingsProvider).value!;
    final f = DateFormatter(l10n: l, style: settings.dateStyle, digits: settings.digitStyle);
    final when = l.readingMeasuredAt(f.format(reading.measuredAt), fmt.time(l, reading.measuredAt));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(readingValueText(l, fmt, reading),
            style: large ? theme.textTheme.displaySmall : theme.textTheme.headlineMedium),
        if (reading.pulse != null)
          Text(fmt.s(l.readingPulseLine('${reading.pulse}')),
              style: theme.textTheme.bodyLarge),
        if (reading.tag != null)
          Text(l10nByKey(l, reading.tag!), style: theme.textTheme.bodyLarge),
        Text(when, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Guidance (in range, out of range, or no ranges)
// ---------------------------------------------------------------------------

class GuidanceView extends ConsumerWidget {
  const GuidanceView({super.key, required this.reading, required this.result});
  final Reading reading;
  final GuidanceResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final g = result;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.resultTitle),
        actions: [
          IconButton(
            tooltip: l.readingDelete,
            iconSize: 30,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => confirmDeleteReading(context, ref, reading.id),
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: ActionBar(children: [
        Expanded(
          child: FilledButton.icon(
            icon: const Icon(Icons.home),
            label: Text(l.guidanceDone),
            onPressed: () => context.go('/home'),
          ),
        ),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ReadingSummary(reading: reading),
          const SizedBox(height: 16),
          TierBanner(tier: g.tier, headline: l10nByKey(l, g.headlineKey)),
          const SizedBox(height: 16),
          if (g.rangesMissing) ...[
            Text(l.noRangesBody, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.straighten),
              label: Text(l.enterRangesButton),
              onPressed: () => context.push('/profile/edit/4'),
            ),
          ],
          if (g.tellDoctor) ...[
            _InfoCard(
              icon: Icons.medical_services,
              title: l.guidanceTellDoctor,
            ),
            const SizedBox(height: 12),
          ],
          if ((g.doctorPlanText ?? '').isNotEmpty) ...[
            _InfoCard(
              icon: Icons.assignment,
              title: l.guidanceDoctorPlan,
              body: g.doctorPlanText,
              note: l.guidanceDoctorPlanNote,
            ),
            const SizedBox(height: 12),
          ],
          if ((g.warningSignsText ?? '').isNotEmpty && g.tier == Tier.outOfRange) ...[
            _InfoCard(
              icon: Icons.visibility,
              title: l.guidanceWarningSigns,
              body: g.warningSignsText,
            ),
            const SizedBox(height: 12),
          ],
          if (g.fastingNote) ...[
            _InfoCard(icon: Icons.info_outline, title: l.fastingNote),
            const SizedBox(height: 12),
          ],
          _ItemsCard(
              icon: Icons.restaurant, title: l.guidanceMeals, items: g.mealIdeas),
          _ItemsCard(
              icon: Icons.tune, title: l.guidanceGoEasyOn, items: g.goEasyOn),
          _ItemsCard(
              icon: Icons.lightbulb_outline, title: l.guidanceTips, items: g.extraTips),
          if (!g.rangesMissing) ...[
            const SizedBox(height: 4),
            Text(l.guidanceNotAdvice, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, this.body, this.note});
  final IconData icon;
  final String title;
  final String? body;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  if (body != null) ...[
                    const SizedBox(height: 6),
                    Text(body!, style: theme.textTheme.bodyLarge),
                  ],
                  if (note != null) ...[
                    const SizedBox(height: 6),
                    Text(note!, style: theme.textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.icon, required this.title, required this.items});
  final IconData icon;
  final String title;
  final List<GuidanceItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final unreviewed = items.any((i) => !i.reviewedByClinician);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icon, size: 30, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(title, style: theme.textTheme.titleLarge),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              for (final i in items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Icons.circle, size: 10),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(guidanceTextOrNull(l, i.textKey) ?? i.textKey,
                            style: theme.textTheme.bodyLarge),
                      ),
                    ],
                  ),
                ),
              if (unreviewed) ...[
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.pending_actions, size: 22, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(l.unreviewedLabel,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontStyle: FontStyle.italic)),
                  ),
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Urgent: one message, the emergency contacts, the doctor's warning signs.
// No meal ideas, no tips, no other advice.
// ---------------------------------------------------------------------------

/// Doctor first, then ambulance, hospital, family.
List<EmergencyContact> _urgentOrder(List<EmergencyContact> all) {
  const order = [ContactRole.doctor, ContactRole.ambulance, ContactRole.hospital, ContactRole.family];
  return [...all]..sort((a, b) => order.indexOf(a.role).compareTo(order.indexOf(b.role)));
}

class UrgentView extends ConsumerWidget {
  const UrgentView({super.key, required this.reading, required this.result});
  final Reading reading;
  final GuidanceResult result;

  Future<void> _call(BuildContext context, WidgetRef ref, EmergencyContact c) async {
    final l = AppL10n.of(context);
    final ok = await ref.read(phoneLauncherProvider)(dialableNumber(c.phone));
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.errorCannotCall(c.phone))));
    }
  }

  Widget _callButton(BuildContext context, WidgetRef ref, EmergencyContact c, Color color) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(88, 80),
        alignment: Alignment.centerLeft,
      ),
      onPressed: () => _call(context, ref, c),
      // Text is already large (24sp / 20sp); capped at 1.3x so the button
      // never grows taller than the screen allows at 200% system text.
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: Row(children: [
          const Icon(Icons.call, size: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.urgentCall(c.name),
                    style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
                Text('${roleLabel(l, c.role)} · ${c.phone}',
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final look = tierLook(context, Tier.urgent);
    final contacts =
        _urgentOrder(ref.watch(contactsProvider).value ?? const <EmergencyContact>[]);

    return Scaffold(
      backgroundColor: look.bg,
      appBar: AppBar(
        backgroundColor: look.bg,
        automaticallyImplyLeading: false,
        title: Text(l.tierUrgent),
      ),
      // The first contact (doctor first) is ALWAYS on screen, however large
      // the text is: the most important action never needs scrolling.
      bottomNavigationBar: ColoredBox(
        color: look.bg,
        child: ActionBar(children: [
          Expanded(
            child: contacts.isEmpty
                ? FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l.urgentAddContacts),
                    style: FilledButton.styleFrom(backgroundColor: look.fg),
                    onPressed: () => context.push('/profile/edit/5'),
                  )
                : _callButton(context, ref, contacts.first, look.fg),
          ),
        ]),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Icon(look.icon, size: 56, color: look.fg),
          const SizedBox(height: 8),
          // Already 36sp at normal size; capped at 1.15x so there is room
          // left for the rest of the screen at 200% system text.
          MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.15,
            child: Semantics(
              header: true,
              liveRegion: true,
              child: Text(
                l.headlineUrgent,
                style: theme.textTheme.displaySmall?.copyWith(
                    color: look.fg, fontSize: 36, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (contacts.isEmpty)
            Text(l.urgentNoContacts,
                style: theme.textTheme.titleMedium?.copyWith(color: look.fg)),
          for (final c in contacts.skip(1)) ...[
            _callButton(context, ref, c, look.fg),
            const SizedBox(height: 12),
          ],
          DefaultTextStyle.merge(
            style: TextStyle(color: look.fg),
            child: _ReadingSummary(reading: reading, large: true),
          ),
          if ((result.warningSignsText ?? '').isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.guidanceWarningSigns, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(result.warningSignsText!, style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          OutlinedButton.icon(
            icon: const Icon(Icons.home),
            label: Text(l.guidanceDone),
            onPressed: () => context.go('/home'),
          ),
          const SizedBox(height: 12),
          // A typo (400 instead of 140) must be fixable.
          TextButton.icon(
            icon: const Icon(Icons.delete_outline),
            label: Text(l.readingDelete),
            onPressed: () => confirmDeleteReading(context, ref, reading.id),
          ),
        ],
      ),
    );
  }
}
