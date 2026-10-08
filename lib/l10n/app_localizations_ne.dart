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

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get save => 'सेभ गर्नुहोस्';

  @override
  String get back => 'पछाडि';

  @override
  String get next => 'अर्को';

  @override
  String get done => 'सकियो';

  @override
  String get edit => 'बदल्नुहोस्';

  @override
  String get saved => 'सेभ भयो';

  @override
  String get errorGeneric => 'केही गडबड भयो। कृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String get errorNeedName => 'कृपया नाम लेख्नुहोस्।';

  @override
  String get errorNumberInvalid => 'कृपया अंक लेख्नुहोस्, जस्तै १२०।';

  @override
  String homeGreeting(String name) {
    return '$nameको दिन';
  }

  @override
  String get profileTooltip => 'प्रोफाइल';

  @override
  String ageYears(String years) {
    return '$years वर्ष';
  }

  @override
  String get fastingTitle => 'आज उपवास (व्रत)';

  @override
  String get fastingYes => 'हो, आज उहाँको उपवास छ';

  @override
  String get fastingNo => 'होइन, आज उपवास छैन';

  @override
  String get fastingNote =>
      'उपवासका दिनमा औषधि र नाप कसरी गर्ने भनेर उहाँको डाक्टरसँग सोध्नुहोस्।';

  @override
  String checklistMorningTitle(String name) {
    return '$nameलाई बिहानको औषधि दिनुहोस्';
  }

  @override
  String checklistNightTitle(String name) {
    return '$nameलाई रातको औषधि दिनुहोस्';
  }

  @override
  String get doseNotGiven => 'अझै दिएको छैन';

  @override
  String doseGivenAt(String time) {
    return '$time मा दिइयो';
  }

  @override
  String get doseUndoHint => 'रद्द गर्न फेरि थिच्नुहोस्';

  @override
  String get doseAllDone => 'सबै दिइयो';

  @override
  String doseProgress(String done, String total) {
    return '$total मध्ये $done दिइयो';
  }

  @override
  String doseSemanticsGiven(String medicine) {
    return '$medicine, दिइसकियो। रद्द गर्न दुई पटक थिच्नुहोस्।';
  }

  @override
  String doseSemanticsNotGiven(String medicine) {
    return '$medicine, अझै दिएको छैन। दिएको चिन्ह लगाउन दुई पटक थिच्नुहोस्।';
  }

  @override
  String get noMedicinesTitle => 'अहिलेसम्म कुनै औषधि थपिएको छैन';

  @override
  String get noMedicinesBody => 'दैनिक सूची पाउन उहाँका औषधि थप्नुहोस्।';

  @override
  String get addMedicine => 'औषधि थप्नुहोस्';

  @override
  String get slotMorning => 'बिहान';

  @override
  String get slotNight => 'राति';

  @override
  String get medicinesListTitle => 'उहाँका औषधि';

  @override
  String get medicineNoTime => 'समय छानिएको छैन';

  @override
  String get adherenceTitle => 'पछिल्ला १४ दिन';

  @override
  String get adherenceIntro => 'हरेक दिन कति औषधि दिएको चिन्ह लगाइयो।';

  @override
  String get adherenceToday => 'आज';

  @override
  String adherenceMorning(String taken, String expected) {
    return 'बिहान: $expected मध्ये $taken';
  }

  @override
  String adherenceNight(String taken, String expected) {
    return 'राति: $expected मध्ये $taken';
  }

  @override
  String get adherenceNone => 'औषधि दिनुपर्ने थिएन';

  @override
  String get adherenceAll => 'सबै दिइयो';

  @override
  String get adherenceSome => 'केही चिन्ह लगाइएको छैन';

  @override
  String get adherenceMissed => 'कुनै चिन्ह लगाइएको छैन';

  @override
  String get adherenceEmpty => 'औषधि थपेपछि यहाँ इतिहास देखिन्छ।';

  @override
  String get medicineFormAddTitle => 'औषधि थप्नुहोस्';

  @override
  String get medicineFormEditTitle => 'औषधि बदल्नुहोस्';

  @override
  String get medicineNameLabel => 'औषधिको नाम';

  @override
  String get medicineNameHint => 'प्याकेटमा लेखिएजस्तै लेख्नुहोस्';

  @override
  String get medicineNotesLabel => 'टिपोट (ऐच्छिक)';

  @override
  String get medicineNotesHint => 'जस्तै: खाना खाएपछि';

  @override
  String get medicineWhenTitle => 'कहिले दिइन्छ?';

  @override
  String get medicineRemove => 'सूचीबाट हटाउनुहोस्';

  @override
  String medicineRemoveTitle(String name) {
    return '$name लाई सूचीबाट हटाउने?';
  }

  @override
  String get medicineRemoveBody =>
      'यसले यो एपको दैनिक सूचीबाट मात्र हटाउँछ। उहाँको औषधि बदलिँदैन। औषधि बदल्ने बारे डाक्टरसँग सोध्नुहोस्। पुराना अभिलेख रहन्छन्।';

  @override
  String get keepIt => 'राख्नुहोस्';

  @override
  String get removeIt => 'हटाउनुहोस्';

  @override
  String get errorNeedSlot => 'बिहान, राति वा दुवै छान्नुहोस्।';

  @override
  String get errorNeedMedicineName => 'कृपया औषधिको नाम लेख्नुहोस्।';

  @override
  String get profileTitle => 'प्रोफाइल';

  @override
  String profileHubIntro(String name) {
    return '$nameको बारेमा सबै कुरा। बदल्न कुनै लाइन थिच्नुहोस्।';
  }

  @override
  String get stepAboutTitle => 'उहाँको बारेमा';

  @override
  String get stepConditionsTitle => 'स्वास्थ्य अवस्था';

  @override
  String get stepFoodTitle => 'खाना र एलर्जी';

  @override
  String get stepMedicinesTitle => 'औषधि';

  @override
  String get stepRangesTitle => 'डाक्टरले दिएका अंक';

  @override
  String get stepContactsTitle => 'आपतकालीन सम्पर्क';

  @override
  String get summaryNotSet => 'अझै राखिएको छैन';

  @override
  String summaryCount(String count) {
    return '$count थपिएका';
  }

  @override
  String get summarySoftFood => 'नरम खाना';

  @override
  String get wizardSetupTitle => 'प्रोफाइल बनाउनुहोस्';

  @override
  String wizardStepOf(String current, String total) {
    return 'चरण $current / $total';
  }

  @override
  String get wizardFinish => 'पूरा गर्नुहोस्';

  @override
  String get aboutNameLabel => 'उहाँको नाम';

  @override
  String get aboutNameHint => 'उहाँको नाम लेख्नुहोस्';

  @override
  String get aboutAgeLabel => 'उहाँको उमेर (वर्ष)';

  @override
  String get aboutNotesLabel => 'टिपोट (ऐच्छिक)';

  @override
  String get errorNeedHisName => 'कृपया उहाँको नाम लेख्नुहोस्।';

  @override
  String get errorAgeInvalid => 'कृपया १ देखि १२० बीचको उमेर लेख्नुहोस्।';

  @override
  String get conditionsIntro =>
      'यीमध्ये कुन अवस्थाबारे उहाँको डाक्टरले भन्नुभएको छ? यो जुनसुकै बेला बदल्न सकिन्छ।';

  @override
  String get conditionDiabetes => 'मधुमेह (रगतमा सुगर)';

  @override
  String get conditionHypertension => 'उच्च रक्तचाप';

  @override
  String get conditionIncluded => 'समावेश छ';

  @override
  String get conditionNotIncluded => 'समावेश छैन';

  @override
  String get foodIntro =>
      'एलर्जी र चपाउने समस्याबारे बताउनुहोस्, ताकि खानाका सुझाव उहाँलाई मिल्ने होऊन्।';

  @override
  String get allergiesLabel => 'एलर्जी वा उहाँले खान नमिल्ने खाना';

  @override
  String get allergiesHint => 'जस्तै: बदाम, माछा';

  @override
  String get softFoodTitle => 'उहाँलाई नरम खाना चाहिन्छ';

  @override
  String get softFoodHint => 'चपाउन गाह्रो छ भने यो छान्नुहोस्।';

  @override
  String get medicinesStepIntro =>
      'हरेक औषधि र दिने समय थप्नुहोस्। डाक्टरले लेखेजस्तै लेख्नुहोस्।';

  @override
  String get rangesIntro =>
      'उहाँको डाक्टरले दिएका अंक लेख्नुहोस्। एपसँग आफ्नै अंक छैन। खाली छोड्नुभयो भने एपले कुनै नापको मूल्यांकन गर्दैन।';

  @override
  String get rangesNoConditions =>
      'पहिले स्वास्थ्य अवस्था छान्नुहोस् (\"स्वास्थ्य अवस्था\" मा), अनि यहाँ फर्कनुहोस्।';

  @override
  String get rangeAllTimes => 'सबै समयका लागि';

  @override
  String get rangeSpecificTimes => 'कुनै खास समयका लागि फरक अंक (ऐच्छिक)';

  @override
  String get rangeUnit => 'एकाइ';

  @override
  String get rangeUrgentLow => 'यसभन्दा तल भए तुरुन्त';

  @override
  String get rangeCautionLow => 'यसभन्दा तल भए सावधानी';

  @override
  String get rangeCautionHigh => 'यसभन्दा माथि भए सावधानी';

  @override
  String get rangeUrgentHigh => 'यसभन्दा माथि भए तुरुन्त';

  @override
  String get rangeDoctorPlan => 'डाक्टरको योजना (ऐच्छिक)';

  @override
  String get rangeDoctorPlanHint => 'डाक्टरले के गर्न भन्नुभयो, उहाँकै शब्दमा';

  @override
  String get rangeWarningSigns => 'ध्यान दिनुपर्ने लक्षण (ऐच्छिक)';

  @override
  String get rangeWarningSignsHint => 'डाक्टरले भनेअनुसार';

  @override
  String get rangeFilled => 'अंक राखिएको छ';

  @override
  String get rangeNotEntered => 'अझै राखिएको छैन';

  @override
  String get errorRangeOrder =>
      'यी अंक क्रमबद्ध छैनन्। कृपया डाक्टरले लेखेअनुसार जाँच्नुहोस्।';

  @override
  String get errorRangeImplausible => 'यो अंक गलत देखिन्छ। कृपया जाँच्नुहोस्।';

  @override
  String get contactsIntro =>
      'आपतकालमा फोन गर्ने मानिस थप्नुहोस्। एपसँग आफ्नै फोन नम्बर छैन।';

  @override
  String get contactsEmpty => 'अहिलेसम्म कुनै सम्पर्क छैन';

  @override
  String get contactAdd => 'सम्पर्क थप्नुहोस्';

  @override
  String get contactFormAddTitle => 'सम्पर्क थप्नुहोस्';

  @override
  String get contactFormEditTitle => 'सम्पर्क बदल्नुहोस्';

  @override
  String get contactNameLabel => 'नाम';

  @override
  String get contactRoleLabel => 'यो को हो?';

  @override
  String get contactPhoneLabel => 'फोन नम्बर';

  @override
  String get roleDoctor => 'डाक्टर';

  @override
  String get roleHospital => 'अस्पताल';

  @override
  String get roleAmbulance => 'एम्बुलेन्स';

  @override
  String get roleFamily => 'परिवार';

  @override
  String get errorPhoneInvalid => 'कृपया फोन नम्बर जाँच्नुहोस्।';

  @override
  String get contactDelete => 'सम्पर्क मेटाउनुहोस्';

  @override
  String contactDeleteTitle(String name) {
    return '$name लाई मेटाउने?';
  }

  @override
  String get contactDeleteBody => 'यसले यो सम्पर्क यो फोनबाट हटाउँछ।';

  @override
  String get keepContact => 'राख्नुहोस्';

  @override
  String get deleteIt => 'मेटाउनुहोस्';

  @override
  String get settingsProfileTile => 'प्रोफाइल र डाक्टरका अंक';

  @override
  String get debugLoadDemo => 'डेमो डाटा हाल्नुहोस् (परीक्षणका लागि मात्र)';

  @override
  String get debugDemoLoaded => 'डेमो डाटा हालियो';

  @override
  String get timeAm => 'पूर्वाह्न';

  @override
  String get timePm => 'अपराह्न';

  @override
  String timeFormat(String time, String period) {
    return '$time $period';
  }

  @override
  String get errorFixMarked => 'कृपया चेतावनी चिन्ह लगाइएका कुरा सच्याउनुहोस्।';
}
