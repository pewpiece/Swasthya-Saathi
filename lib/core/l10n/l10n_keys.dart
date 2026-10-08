import '../../l10n/app_localizations.dart';

/// Resolves a data-driven l10n key (for example `Metric.nameKey` or a tag key
/// stored in the database) to text. Unknown keys return the key itself so a
/// missing translation is visible instead of crashing.
String l10nByKey(AppL10n l, String key) {
  switch (key) {
    case 'metricBloodSugar':
      return l.metricBloodSugar;
    case 'metricBloodPressureSystolic':
      return l.metricBloodPressureSystolic;
    case 'metricBloodPressureDiastolic':
      return l.metricBloodPressureDiastolic;
    case 'metricPulse':
      return l.metricPulse;
    case 'tagFasting':
      return l.tagFasting;
    case 'tagBeforeMeal':
      return l.tagBeforeMeal;
    case 'tagAfterMeal':
      return l.tagAfterMeal;
    case 'tagBedtime':
      return l.tagBedtime;
    case 'tagMorning':
      return l.tagMorning;
    case 'tagEvening':
      return l.tagEvening;
    case 'tagOther':
      return l.tagOther;
    case 'conditionDiabetes':
      return l.conditionDiabetes;
    case 'conditionHypertension':
      return l.conditionHypertension;
  }
  return key;
}

/// Label for a condition key stored in the Metrics catalogue (`diabetes`...).
/// A new condition adds one ARB key `condition<Name>` and one case here.
String conditionLabel(AppL10n l, String conditionKey) {
  switch (conditionKey) {
    case 'diabetes':
      return l10nByKey(l, 'conditionDiabetes');
    case 'hypertension':
      return l10nByKey(l, 'conditionHypertension');
  }
  return conditionKey;
}
