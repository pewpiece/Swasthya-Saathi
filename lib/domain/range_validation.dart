import 'input_limits.dart';

enum RangeProblem {
  /// A number is outside what a person could plausibly type (probable typo).
  implausible,

  /// The numbers are not in order: urgent low < low < high < urgent high.
  wrongOrder,
}

class RangeCheck {
  const RangeCheck.ok()
      : problem = null,
        badField = null;
  const RangeCheck.bad(this.problem, this.badField);

  final RangeProblem? problem;

  /// Index 0..3 of the field to focus: urgentLow, cautionLow, cautionHigh,
  /// urgentHigh.
  final int? badField;

  bool get isOk => problem == null;
}

/// Checks the doctor's four numbers. Any may be empty (null), but the ones
/// entered must be in strictly increasing order. Never supplies a default.
RangeCheck validateRange({
  required String metricKey,
  required String? unit,
  required double? urgentLow,
  required double? cautionLow,
  required double? cautionHigh,
  required double? urgentHigh,
}) {
  final values = [urgentLow, cautionLow, cautionHigh, urgentHigh];
  final limits = InputLimits.forMetric(metricKey, unit);
  if (limits != null) {
    for (var i = 0; i < values.length; i++) {
      final v = values[i];
      if (v != null && (v < limits.min || v > limits.max)) {
        return RangeCheck.bad(RangeProblem.implausible, i);
      }
    }
  }
  double? previous;
  for (var i = 0; i < values.length; i++) {
    final v = values[i];
    if (v == null) continue;
    if (previous != null && v <= previous) {
      return RangeCheck.bad(RangeProblem.wrongOrder, i);
    }
    previous = v;
  }
  return const RangeCheck.ok();
}
