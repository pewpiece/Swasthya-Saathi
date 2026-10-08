// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CareCompanion';

  @override
  String get navHome => 'Home';

  @override
  String get navMedicines => 'Medicines';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get welcomeTitle => 'Welcome to CareCompanion';

  @override
  String get welcomeIntro =>
      'This app helps you look after your parent. You can write down his health readings, tick off his medicines, and get reminders.';

  @override
  String get disclaimerTitle => 'This app is not medical advice';

  @override
  String get disclaimerBody =>
      'CareCompanion does not replace his doctor. It never tells you to start, stop, or change a medicine. All health ranges come from his doctor. If you are worried, call his doctor.';

  @override
  String get disclaimerPrivacy =>
      'All information stays on this phone. Nothing is sent anywhere.';

  @override
  String get disclaimerAccept => 'I understand';

  @override
  String get homeTitle => 'Home';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get comingSoonBody => 'This part of the app is not ready yet.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageNepali => 'नेपाली (Nepali)';

  @override
  String get settingsDateStyle => 'Date style';

  @override
  String get dateStyleAd => 'AD (English calendar)';

  @override
  String get dateStyleBs => 'BS (Nepali calendar)';

  @override
  String get settingsGlucoseUnit => 'Blood sugar unit';

  @override
  String get unitMgDl => 'mg/dL';

  @override
  String get unitMmolL => 'mmol/L';

  @override
  String get settingsDigitStyle => 'Number style';

  @override
  String get digitsLatin => 'Latin numbers (1 2 3)';

  @override
  String get digitsDevanagari => 'Nepali numbers (१ २ ३)';

  @override
  String get settingsTextSizeHelpTitle => 'How to make text bigger';

  @override
  String get settingsTextSizeHelpBody =>
      'Open your phone\'s Settings, then Display, then Font size. CareCompanion follows that size.';

  @override
  String get settingsDisclaimerTile => 'This app is not medical advice';

  @override
  String settingsPreviewDate(String date) {
    return 'Today\'s date: $date';
  }

  @override
  String get close => 'Close';

  @override
  String get metricBloodSugar => 'Blood sugar';

  @override
  String get metricBloodPressureSystolic => 'Blood pressure (top number)';

  @override
  String get metricBloodPressureDiastolic => 'Blood pressure (bottom number)';

  @override
  String get metricPulse => 'Pulse';

  @override
  String get tagFasting => 'Fasting (before eating)';

  @override
  String get tagBeforeMeal => 'Before a meal';

  @override
  String get tagAfterMeal => 'After a meal';

  @override
  String get tagBedtime => 'At bedtime';

  @override
  String get tagMorning => 'Morning';

  @override
  String get tagEvening => 'Evening';

  @override
  String get tagOther => 'Other time';

  @override
  String get bsMonth1 => 'Baisakh';

  @override
  String get bsMonth2 => 'Jestha';

  @override
  String get bsMonth3 => 'Ashadh';

  @override
  String get bsMonth4 => 'Shrawan';

  @override
  String get bsMonth5 => 'Bhadra';

  @override
  String get bsMonth6 => 'Ashwin';

  @override
  String get bsMonth7 => 'Kartik';

  @override
  String get bsMonth8 => 'Mangsir';

  @override
  String get bsMonth9 => 'Poush';

  @override
  String get bsMonth10 => 'Magh';

  @override
  String get bsMonth11 => 'Falgun';

  @override
  String get bsMonth12 => 'Chaitra';

  @override
  String bsDateFormat(String day, String month, String year) {
    return '$day $month $year BS';
  }

  @override
  String adDateFormat(String day, String month, String year) {
    return '$day $month $year';
  }

  @override
  String get adMonth1 => 'Jan';

  @override
  String get adMonth2 => 'Feb';

  @override
  String get adMonth3 => 'Mar';

  @override
  String get adMonth4 => 'Apr';

  @override
  String get adMonth5 => 'May';

  @override
  String get adMonth6 => 'Jun';

  @override
  String get adMonth7 => 'Jul';

  @override
  String get adMonth8 => 'Aug';

  @override
  String get adMonth9 => 'Sep';

  @override
  String get adMonth10 => 'Oct';

  @override
  String get adMonth11 => 'Nov';

  @override
  String get adMonth12 => 'Dec';
}
