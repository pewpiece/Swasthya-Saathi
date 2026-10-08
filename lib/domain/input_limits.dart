/// "Typo catchers" for numbers a caregiver types. These are NOT medical
/// ranges and never decide a tier; they only stop things like BP 1300/80 from
/// being saved by accident. Anything outside is refused with a plain message.
class InputLimits {
  const InputLimits._();

  /// Returns (min, max) allowed for [metricKey] in [unit], or null if unknown.
  static ({double min, double max})? forMetric(String metricKey, String? unit) {
    switch (metricKey) {
      case 'blood_sugar':
        return unit == 'mmol/L'
            ? (min: 0.5, max: 55)
            : (min: 10, max: 1000);
      case 'bp_systolic':
        return (min: 40, max: 300);
      case 'bp_diastolic':
        return (min: 20, max: 200);
      case 'pulse':
        return (min: 20, max: 250);
    }
    return null;
  }
}
