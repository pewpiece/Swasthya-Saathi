import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/guidance_engine.dart';
import '../../l10n/app_localizations.dart';

String tierLabel(AppL10n l, Tier t) => switch (t) {
      Tier.inRange => l.tierInRange,
      Tier.outOfRange => l.tierOutOfRange,
      Tier.urgent => l.tierUrgent,
      Tier.unknown => l.tierUnknown,
    };

/// Icon + text + colour for a tier. Colour is never the only signal.
({Color fg, Color bg, IconData icon}) tierLook(BuildContext context, Tier t) {
  final styles = Theme.of(context).extension<TierStyles>()!;
  switch (t) {
    case Tier.inRange:
      return (fg: styles.inRange.fg, bg: styles.inRange.bg, icon: styles.inRange.icon);
    case Tier.outOfRange:
      return (fg: styles.outOfRange.fg, bg: styles.outOfRange.bg, icon: styles.outOfRange.icon);
    case Tier.urgent:
      return (fg: styles.urgent.fg, bg: styles.urgent.bg, icon: styles.urgent.icon);
    case Tier.unknown:
      final s = Theme.of(context).colorScheme;
      return (fg: s.onSurface, bg: s.surfaceContainerHighest, icon: Icons.help_outline);
  }
}

/// Big banner: icon, tier word, and (optionally) the sentence below it.
class TierBanner extends StatelessWidget {
  const TierBanner({super.key, required this.tier, this.headline});
  final Tier tier;
  final String? headline;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final look = tierLook(context, tier);
    return Semantics(
      container: true,
      label: '${tierLabel(l, tier)}. ${headline ?? ''}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: look.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: look.fg, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(look.icon, size: 44, color: look.fg),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tierLabel(l, tier),
                      style: theme.textTheme.titleLarge?.copyWith(color: look.fg)),
                  if (headline != null) ...[
                    const SizedBox(height: 6),
                    Text(headline!,
                        style: theme.textTheme.bodyLarge?.copyWith(color: look.fg)),
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

/// Small version for lists: icon + word in a pill.
class TierChip extends StatelessWidget {
  const TierChip({super.key, required this.tier});
  final Tier tier;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final look = tierLook(context, tier);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: look.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: look.fg, width: 1.5),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(look.icon, size: 22, color: look.fg),
        const SizedBox(width: 6),
        Flexible(
          child: Text(tierLabel(l, tier),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: look.fg, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}
