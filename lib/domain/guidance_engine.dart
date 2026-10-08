/// Pure Dart guidance engine. No Flutter, no database, no medical numbers.
///
/// The tier comes ONLY from comparing the reading with the thresholds the
/// family typed in from the doctor's instructions. With no thresholds the
/// result is [Tier.unknown] and no range-based guidance is produced.
library;

enum Tier { unknown, inRange, outOfRange, urgent }

/// Which side of the range the reading is on (decides which tips make sense).
enum Direction { none, low, high, mixed }

enum ItemKind { meal, goEasyOn, tip }

/// One set of the doctor's numbers (mirrors a TargetRange row).
class RangeSpec {
  const RangeSpec({
    required this.metricKey,
    this.tagContext,
    this.unit,
    this.urgentLow,
    this.cautionLow,
    this.cautionHigh,
    this.urgentHigh,
    this.doctorPlanText,
    this.warningSignsText,
  });

  final String metricKey;
  final String? tagContext;
  final String? unit;
  final double? urgentLow;
  final double? cautionLow;
  final double? cautionHigh;
  final double? urgentHigh;
  final String? doctorPlanText;
  final String? warningSignsText;

  bool get hasThresholds =>
      urgentLow != null ||
      cautionLow != null ||
      cautionHigh != null ||
      urgentHigh != null;
}

/// What the caregiver measured.
class ReadingInput {
  const ReadingInput({
    required this.kind,
    required this.unit,
    this.value,
    this.systolic,
    this.diastolic,
    this.pulse,
    this.tag,
  });

  /// `blood_sugar` or `blood_pressure` (the Reading.metricKey).
  final String kind;
  final String unit;
  final double? value; // blood sugar
  final int? systolic;
  final int? diastolic;
  final int? pulse;
  final String? tag;
}

/// One piece of guidance content (from assets/guidance/*.json).
class GuidanceItem {
  const GuidanceItem({
    required this.id,
    required this.textKey,
    required this.kind,
    required this.appliesToTiers,
    this.directions = const {},
    this.tags = const {},
    this.allergens = const {},
    this.reviewedByClinician = false,
  });

  final String id;
  final String textKey; // key in app_en.arb / app_ne.arb
  final ItemKind kind;
  final Set<Tier> appliesToTiers;

  /// Empty = any direction. Otherwise only when the reading is on that side.
  final Set<Direction> directions;

  /// `soft` (fine for chewing problems) or `needs_chewing`.
  final Set<String> tags;

  /// e.g. `egg`, `dairy`: hidden when the allergy text mentions it.
  final Set<String> allergens;
  final bool reviewedByClinician;
}

class Restrictions {
  const Restrictions({
    this.allergies,
    this.softFood = false,
    this.fastingToday = false,
  });
  final String? allergies;
  final bool softFood;
  final bool fastingToday;
}

class ComponentResult {
  const ComponentResult(this.metricKey, this.tier, this.direction, this.range);
  final String metricKey;
  final Tier tier;
  final Direction direction;
  final RangeSpec range;
}

class GuidanceResult {
  const GuidanceResult({
    required this.tier,
    required this.direction,
    required this.headlineKey,
    this.mealIdeas = const [],
    this.goEasyOn = const [],
    this.extraTips = const [],
    this.doctorPlanText,
    this.warningSignsText,
    this.components = const [],
    this.fastingNote = false,
  });

  final Tier tier;
  final Direction direction;

  /// l10n key: headlineInRange / headlineOutOfRange / headlineUrgent /
  /// headlineNoRanges.
  final String headlineKey;
  final List<GuidanceItem> mealIdeas;
  final List<GuidanceItem> goEasyOn;
  final List<GuidanceItem> extraTips;
  final String? doctorPlanText;
  final String? warningSignsText;
  final List<ComponentResult> components;
  final bool fastingNote;

  /// Urgent = a big "contact his doctor" screen and NOTHING else.
  bool get showUrgentScreen => tier == Tier.urgent;
  bool get rangesMissing => tier == Tier.unknown;
  bool get tellDoctor => tier == Tier.outOfRange || tier == Tier.urgent;

  bool get hasUnreviewed => [...mealIdeas, ...goEasyOn, ...extraTips]
      .any((i) => !i.reviewedByClinician);
}

class GuidanceEngine {
  const GuidanceEngine._();

  /// 1 mmol/L of glucose = 18.0182 mg/dL (molar mass conversion, not a
  /// medical threshold).
  static const mgDlPerMmolL = 18.0182;

  static const _allergenWords = <String, List<String>>{
    'egg': ['egg', 'अण्डा', 'अंडा'],
    'dairy': ['milk', 'dairy', 'curd', 'dahi', 'yogurt', 'yoghurt', 'दूध', 'दही', 'दुध'],
    'nuts': ['nut', 'peanut', 'बदाम', 'केराउ'],
    'fish': ['fish', 'माछा'],
  };

  /// Component metrics of each reading kind.
  static List<String> componentsOf(String kind) => switch (kind) {
        'blood_sugar' => ['blood_sugar'],
        'blood_pressure' => ['bp_systolic', 'bp_diastolic', 'pulse'],
        _ => const [],
      };

  static double? _valueOf(ReadingInput r, String component) => switch (component) {
        'blood_sugar' => r.value,
        'bp_systolic' => r.systolic?.toDouble(),
        'bp_diastolic' => r.diastolic?.toDouble(),
        'pulse' => r.pulse?.toDouble(),
        _ => null,
      };

  /// Converts a value between glucose units, rounded to what a meter shows
  /// (so 90 mg/dL is treated as 5.0 mmol/L, not 4.995).
  static double convert(String metricKey, double v, String from, String to) {
    if (from == to || metricKey != 'blood_sugar') return v;
    if (from == 'mg/dL' && to == 'mmol/L') {
      return (v / mgDlPerMmolL * 10).round() / 10;
    }
    if (from == 'mmol/L' && to == 'mg/dL') return (v * mgDlPerMmolL).roundToDouble();
    return v;
  }

  /// The range row to use: one for the reading's own time context if it has
  /// numbers, otherwise the "all times" row. Null if neither has numbers.
  static RangeSpec? pickRange(List<RangeSpec> ranges, String metricKey, String? tag) {
    RangeSpec? exact;
    RangeSpec? general;
    for (final r in ranges) {
      if (r.metricKey != metricKey || !r.hasThresholds) continue;
      if (r.tagContext == null) {
        general ??= r;
      } else if (r.tagContext == tag) {
        exact ??= r;
      }
    }
    return exact ?? general;
  }

  /// Tier of one number against one range, in the range's unit.
  ///
  /// Words on the screen are "urgent if below / careful if below / careful if
  /// above / urgent if above", so a number exactly ON a threshold is NOT past
  /// it: it stays in the milder tier.
  static (Tier, Direction) tierOf(double v, RangeSpec s) {
    if (s.urgentLow != null && v < s.urgentLow!) return (Tier.urgent, Direction.low);
    if (s.urgentHigh != null && v > s.urgentHigh!) return (Tier.urgent, Direction.high);
    if (s.cautionLow != null && v < s.cautionLow!) return (Tier.outOfRange, Direction.low);
    if (s.cautionHigh != null && v > s.cautionHigh!) return (Tier.outOfRange, Direction.high);
    return (Tier.inRange, Direction.none);
  }

  static int _rank(Tier t) => switch (t) {
        Tier.unknown => 0,
        Tier.inRange => 1,
        Tier.outOfRange => 2,
        Tier.urgent => 3,
      };

  /// Per-component results (only parts that have both a value and numbers).
  static List<ComponentResult> evaluateComponents(
    ReadingInput reading,
    List<RangeSpec> ranges,
  ) {
    final out = <ComponentResult>[];
    for (final c in componentsOf(reading.kind)) {
      final v = _valueOf(reading, c);
      if (v == null) continue;
      final spec = pickRange(ranges, c, reading.tag);
      if (spec == null) continue;
      final inSpecUnit = convert(c, v, reading.unit, spec.unit ?? reading.unit);
      final (tier, dir) = tierOf(inSpecUnit, spec);
      out.add(ComponentResult(c, tier, dir, spec));
    }
    return out;
  }

  /// The one entry point.
  ///
  /// For blood pressure the WORSE of systolic and diastolic (and pulse, if the
  /// family entered a pulse range) decides the tier.
  static GuidanceResult evaluate({
    required ReadingInput reading,
    required List<RangeSpec> ranges,
    required List<GuidanceItem> content,
    Restrictions restrictions = const Restrictions(),
  }) {
    final comps = evaluateComponents(reading, ranges);
    if (comps.isEmpty) {
      return GuidanceResult(
        tier: Tier.unknown,
        direction: Direction.none,
        headlineKey: 'headlineNoRanges',
        fastingNote: restrictions.fastingToday,
      );
    }

    var tier = Tier.inRange;
    for (final c in comps) {
      if (_rank(c.tier) > _rank(tier)) tier = c.tier;
    }
    final worst = comps.where((c) => c.tier == tier).toList();
    final dirs = worst.map((c) => c.direction).toSet();
    final direction = tier == Tier.inRange
        ? Direction.none
        : dirs.length == 1
            ? dirs.first
            : Direction.mixed;

    String? joinTexts(Iterable<String?> texts) {
      final seen = <String>[];
      for (final t in texts) {
        final s = t?.trim();
        if (s != null && s.isNotEmpty && !seen.contains(s)) seen.add(s);
      }
      return seen.isEmpty ? null : seen.join('\n\n');
    }

    // The doctor's own words. Warning signs live on the "all times" row.
    String? warningFor(ComponentResult c) {
      if (c.range.warningSignsText?.trim().isNotEmpty ?? false) {
        return c.range.warningSignsText;
      }
      for (final r in ranges) {
        if (r.metricKey == c.metricKey &&
            r.tagContext == null &&
            (r.warningSignsText?.trim().isNotEmpty ?? false)) {
          return r.warningSignsText;
        }
      }
      return null;
    }

    final plan = tier == Tier.outOfRange || tier == Tier.urgent
        ? joinTexts(worst.map((c) => c.range.doctorPlanText))
        : null;
    final warnings = tier == Tier.urgent || tier == Tier.outOfRange
        ? joinTexts(comps.map(warningFor))
        : null;

    if (tier == Tier.urgent) {
      // Urgent screen only: no meal ideas, no tips.
      return GuidanceResult(
        tier: tier,
        direction: direction,
        headlineKey: 'headlineUrgent',
        doctorPlanText: plan,
        warningSignsText: warnings,
        components: comps,
      );
    }

    final usable = _filter(content, tier, direction, restrictions);
    List<GuidanceItem> of(ItemKind k) => [
          for (final i in usable)
            if (i.kind == k) i,
        ];
    return GuidanceResult(
      tier: tier,
      direction: direction,
      headlineKey: tier == Tier.inRange ? 'headlineInRange' : 'headlineOutOfRange',
      mealIdeas: of(ItemKind.meal),
      goEasyOn: of(ItemKind.goEasyOn),
      extraTips: of(ItemKind.tip),
      doctorPlanText: plan,
      warningSignsText: warnings,
      components: comps,
      fastingNote: restrictions.fastingToday,
    );
  }

  static List<GuidanceItem> _filter(
    List<GuidanceItem> content,
    Tier tier,
    Direction direction,
    Restrictions r,
  ) {
    final allergyText = (r.allergies ?? '').toLowerCase();
    bool allergic(GuidanceItem i) {
      for (final a in i.allergens) {
        final words = _allergenWords[a] ?? [a];
        if (words.any((w) => allergyText.contains(w.toLowerCase()))) return true;
      }
      return false;
    }

    bool directionOk(GuidanceItem i) {
      if (tier == Tier.inRange || i.directions.isEmpty) return true;
      return i.directions.contains(direction);
    }

    return [
      for (final i in content)
        if (i.appliesToTiers.contains(tier) &&
            directionOk(i) &&
            !allergic(i) &&
            // Chewing problems: only soft items, and nothing needing chewing.
            !(r.softFood && i.tags.contains('needs_chewing')) &&
            !(r.softFood && i.kind == ItemKind.meal && !i.tags.contains('soft')))
          i,
    ];
  }
}
