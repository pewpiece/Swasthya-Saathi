// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppL10nNe extends AppL10n {
  AppL10nNe([String locale = 'ne']) : super(locale);

  @override
  String get appName => 'केयरकम्प्यानियन';

  @override
  String get navHome => 'गृहपृष्ठ';

  @override
  String get navMedicines => 'औषधि';

  @override
  String get navHistory => 'इतिहास';

  @override
  String get navSettings => 'सेटिङ';

  @override
  String get welcomeTitle => 'केयरकम्प्यानियनमा स्वागत छ';

  @override
  String get welcomeIntro =>
      'यो एपले तपाईंका अभिभावकको स्याहार गर्न मद्दत गर्छ। यसमा उहाँको स्वास्थ्य नाप लेख्न, औषधि खुवाएको चिन्ह लगाउन र सम्झना पाउन सकिन्छ।';

  @override
  String get disclaimerTitle => 'यो एप चिकित्सकीय सल्लाह होइन';

  @override
  String get disclaimerBody =>
      'केयरकम्प्यानियनले उहाँको डाक्टरको ठाउँ लिँदैन। यसले कहिल्यै औषधि सुरु गर्न, बन्द गर्न वा बदल्न भन्दैन। स्वास्थ्यका सबै सीमा उहाँको डाक्टरले दिएकै हुन्छन्। चिन्ता लागे डाक्टरलाई फोन गर्नुहोस्।';

  @override
  String get disclaimerPrivacy =>
      'सबै जानकारी यही फोनमा मात्र रहन्छ। कतै पठाइँदैन।';

  @override
  String get disclaimerAccept => 'मैले बुझें';

  @override
  String get homeTitle => 'गृहपृष्ठ';

  @override
  String get comingSoonTitle => 'छिट्टै आउँदैछ';

  @override
  String get comingSoonBody => 'एपको यो भाग अझै तयार भएको छैन।';

  @override
  String get settingsTitle => 'सेटिङ';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get languageEnglish => 'English (अंग्रेजी)';

  @override
  String get languageNepali => 'नेपाली';

  @override
  String get settingsDateStyle => 'मितिको शैली';

  @override
  String get dateStyleAd => 'AD (अंग्रेजी पात्रो)';

  @override
  String get dateStyleBs => 'BS (नेपाली पात्रो)';

  @override
  String get settingsGlucoseUnit => 'सुगरको एकाइ';

  @override
  String get unitMgDl => 'mg/dL';

  @override
  String get unitMmolL => 'mmol/L';

  @override
  String get settingsDigitStyle => 'अंकको शैली';

  @override
  String get digitsLatin => 'अंग्रेजी अंक (1 2 3)';

  @override
  String get digitsDevanagari => 'नेपाली अंक (१ २ ३)';

  @override
  String get settingsTextSizeHelpTitle => 'अक्षर ठूला बनाउने तरिका';

  @override
  String get settingsTextSizeHelpBody =>
      'फोनको सेटिङ खोल्नुहोस्, त्यसपछि डिस्प्ले, त्यसपछि फन्ट साइज। केयरकम्प्यानियनले त्यही साइज पछ्याउँछ।';

  @override
  String get settingsDisclaimerTile => 'यो एप चिकित्सकीय सल्लाह होइन';

  @override
  String settingsPreviewDate(String date) {
    return 'आजको मिति: $date';
  }

  @override
  String get close => 'बन्द गर्नुहोस्';

  @override
  String get metricBloodSugar => 'रगतमा सुगर';

  @override
  String get metricBloodPressureSystolic => 'रक्तचाप (माथिको अंक)';

  @override
  String get metricBloodPressureDiastolic => 'रक्तचाप (तलको अंक)';

  @override
  String get metricPulse => 'नाडी';

  @override
  String get tagFasting => 'खाली पेट (खानुअघि)';

  @override
  String get tagBeforeMeal => 'खानाअघि';

  @override
  String get tagAfterMeal => 'खाना खाएपछि';

  @override
  String get tagBedtime => 'सुत्ने बेला';

  @override
  String get tagMorning => 'बिहान';

  @override
  String get tagEvening => 'साँझ';

  @override
  String get tagOther => 'अन्य समय';

  @override
  String get bsMonth1 => 'बैशाख';

  @override
  String get bsMonth2 => 'जेठ';

  @override
  String get bsMonth3 => 'असार';

  @override
  String get bsMonth4 => 'श्रावण';

  @override
  String get bsMonth5 => 'भदौ';

  @override
  String get bsMonth6 => 'असोज';

  @override
  String get bsMonth7 => 'कार्तिक';

  @override
  String get bsMonth8 => 'मंसिर';

  @override
  String get bsMonth9 => 'पौष';

  @override
  String get bsMonth10 => 'माघ';

  @override
  String get bsMonth11 => 'फागुन';

  @override
  String get bsMonth12 => 'चैत';

  @override
  String bsDateFormat(String day, String month, String year) {
    return '$day $month $year वि.सं.';
  }

  @override
  String adDateFormat(String day, String month, String year) {
    return '$day $month $year';
  }

  @override
  String get adMonth1 => 'जनवरी';

  @override
  String get adMonth2 => 'फेब्रुअरी';

  @override
  String get adMonth3 => 'मार्च';

  @override
  String get adMonth4 => 'अप्रिल';

  @override
  String get adMonth5 => 'मे';

  @override
  String get adMonth6 => 'जुन';

  @override
  String get adMonth7 => 'जुलाई';

  @override
  String get adMonth8 => 'अगस्ट';

  @override
  String get adMonth9 => 'सेप्टेम्बर';

  @override
  String get adMonth10 => 'अक्टोबर';

  @override
  String get adMonth11 => 'नोभेम्बर';

  @override
  String get adMonth12 => 'डिसेम्बर';
}
