// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppL10nNe extends AppL10n {
  AppL10nNe([String locale = 'ne']) : super(locale);

  @override
  String get appName => 'स्वास्थ्य साथी';

  @override
  String get navHome => 'गृहपृष्ठ';

  @override
  String get navMedicines => 'औषधि';

  @override
  String get navHistory => 'इतिहास';

  @override
  String get navSettings => 'सेटिङ';

  @override
  String get welcomeTitle => 'स्वास्थ्य साथीमा स्वागत छ';

  @override
  String get welcomeIntro =>
      'यो एपले तपाईंका अभिभावकको स्याहार गर्न मद्दत गर्छ। यसमा उहाँको स्वास्थ्य नाप लेख्न, औषधि खुवाएको चिन्ह लगाउन र सम्झना पाउन सकिन्छ।';

  @override
  String get disclaimerTitle => 'यो एप चिकित्सकीय सल्लाह होइन';

  @override
  String get disclaimerBody =>
      'स्वास्थ्य साथीले उहाँको डाक्टरको ठाउँ लिँदैन। यसले कहिल्यै औषधि सुरु गर्न, बन्द गर्न वा बदल्न भन्दैन। स्वास्थ्यका सबै सीमा उहाँको डाक्टरले दिएकै हुन्छन्। चिन्ता लागे डाक्टरलाई फोन गर्नुहोस्।';

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
      'फोनको सेटिङ खोल्नुहोस्, त्यसपछि डिस्प्ले, त्यसपछि फन्ट साइज। स्वास्थ्य साथीले त्यही साइज पछ्याउँछ।';

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

  @override
  String get gTipSitSlowly => 'उहाँलाई आरामले बसेर बिस्तारै खान दिनुहोस्।';

  @override
  String get gTipRegularMeals =>
      'खाना खाने समय नियमित राख्नुहोस्। खाना नछुटाउनुहोस्।';

  @override
  String get gTipFluids =>
      'उहाँको डाक्टरले पानी सीमित गरेको छैन भने दिनभरि पानी दिनुहोस्।';

  @override
  String get gTipWalk =>
      'डाक्टरले मिल्छ भनेका छन् भने बिस्तारै हिँड्नु राम्रो हुन सक्छ।';

  @override
  String get gMealSteamedVeg => 'बाफमा पकाएको वा उमालेको तरकारी';

  @override
  String get gMealCurd => 'एक सानो कचौरा दही';

  @override
  String get gMealEgg => 'उमालेको अण्डा';

  @override
  String get gMealSoftDalBhat => 'राम्ररी पकाएको नरम दाल-भात र तरकारी';

  @override
  String get gMealGreensSoup =>
      'थोरै नुन हालेर पकाएको गुन्द्रुक वा सिस्नुको झोल';

  @override
  String get gMealKhichadi => 'तरकारी हालेको नरम खिचडी';

  @override
  String get gEasyFried => 'तेलमा तारेको खाना, जस्तै पकौडा वा पुरी';

  @override
  String get gMealDalBhatMoreVeg => 'भात थोरै र तरकारी धेरै भएको दाल-भात';

  @override
  String get gMealRotiDhido => 'रोटी वा ढिँडो, मध्यम मात्रामा';

  @override
  String get gEasySugarChiya => 'चियामा चिनी';

  @override
  String get gEasySweets => 'मिठाई, विशेषगरी दशैं र तिहारमा';

  @override
  String get gEasySalt => 'खाने बेला थप नुन हाल्नु';

  @override
  String get gEasyAchar => 'अचार';

  @override
  String get gEasyNoodles => 'इन्स्ट्यान्ट चाउचाउ र प्याकेटका खाजा';

  @override
  String get addReading => 'नाप थप्नुहोस्';

  @override
  String get addReadingChoose => 'के नाप्नुभयो?';

  @override
  String get kindBloodSugar => 'रगतमा सुगर';

  @override
  String get kindBloodPressure => 'रक्तचाप';

  @override
  String get addReadingNeedCondition =>
      'पहिले प्रोफाइलमा स्वास्थ्य अवस्था छान्नुहोस्, अनि नाप थप्न सकिन्छ।';

  @override
  String get readingFormSugarTitle => 'रगतमा सुगरको नयाँ नाप';

  @override
  String get readingFormBpTitle => 'रक्तचापको नयाँ नाप';

  @override
  String get readingSugarLabel => 'सुगरको अंक';

  @override
  String get bpTopLabel => 'माथिको अंक (सिस्टोलिक)';

  @override
  String get bpBottomLabel => 'तलको अंक (डायस्टोलिक)';

  @override
  String get bpPulseLabel => 'नाडी (ऐच्छिक)';

  @override
  String get readingWhenTitle => 'कहिले नापिएको हो?';

  @override
  String get readingUnitTitle => 'एकाइ';

  @override
  String get readingNoteLabel => 'टिपोट (ऐच्छिक)';

  @override
  String get readingSave => 'नाप सेभ गर्नुहोस्';

  @override
  String get errorReadingNumber => 'मिटरमा देखिएको अंक लेख्नुहोस्।';

  @override
  String get errorReadingImplausible =>
      'यो अंक गलत देखिन्छ। मिटर हेरेर फेरि लेख्नुहोस्।';

  @override
  String get errorBpOrder =>
      'माथिको अंक तलको अंकभन्दा ठूलो हुनुपर्छ। कृपया जाँच्नुहोस्।';

  @override
  String get resultTitle => 'नतिजा';

  @override
  String get tierInRange => 'डाक्टरले दिएको सीमाभित्र';

  @override
  String get tierOutOfRange => 'डाक्टरले दिएको सीमाबाहिर';

  @override
  String get tierUrgent => 'तुरुन्तै ध्यान दिनुपर्ने';

  @override
  String get tierUnknown => 'तुलना गर्ने सीमा छैन';

  @override
  String get headlineInRange => 'यो नाप उहाँको डाक्टरले दिएको सीमाभित्र छ।';

  @override
  String get headlineOutOfRange =>
      'यो नाप उहाँको डाक्टरले दिएको सीमाबाहिर छ। सावधान रहनुहोस्।';

  @override
  String get headlineUrgent =>
      'अहिले नै उहाँको डाक्टर वा आपतकालीन सेवालाई सम्पर्क गर्नुहोस्';

  @override
  String get headlineNoRanges => 'प्रोफाइलमा डाक्टरले दिएका सीमा राख्नुहोस्';

  @override
  String get noRangesBody =>
      'डाक्टरका अंक बिना एपले नाप बढी वा कम हो भनेर भन्न सक्दैन, र अनुमान पनि गर्दैन।';

  @override
  String get enterRangesButton => 'डाक्टरका सीमा राख्नुहोस्';

  @override
  String get guidanceMeals => 'यी रोज्नुहोस्';

  @override
  String get guidanceGoEasyOn => 'यसमा कम गर्नुहोस्';

  @override
  String get guidanceTips => 'अन्य सुझाव';

  @override
  String get guidanceTellDoctor => 'यो नापबारे उहाँको डाक्टरलाई भन्नुहोस्।';

  @override
  String get guidanceDoctorPlan => 'उहाँको डाक्टरको योजना';

  @override
  String get guidanceDoctorPlanNote => 'परिवारले डाक्टरको भनाइअनुसार लेखेको।';

  @override
  String get guidanceWarningSigns => 'ध्यान दिनुपर्ने लक्षण';

  @override
  String get guidanceNotAdvice =>
      'यो सामान्य खानपानको सुझाव हो, चिकित्सकीय सल्लाह होइन। शंका लागे डाक्टरसँग सोध्नुहोस्।';

  @override
  String get unreviewedLabel => 'अझै चिकित्सकले समीक्षा गरेका छैनन्';

  @override
  String get guidanceDone => 'गृहपृष्ठमा फर्कनुहोस्';

  @override
  String get readingNotFound => 'यो नाप भेटिएन।';

  @override
  String readingValueLine(String value, String unit) {
    return '$value $unit';
  }

  @override
  String readingBpLine(String top, String bottom) {
    return '$top/$bottom mmHg';
  }

  @override
  String readingPulseLine(String pulse) {
    return 'नाडी $pulse';
  }

  @override
  String urgentCall(String name) {
    return '$name लाई फोन गर्नुहोस्';
  }

  @override
  String get urgentNoContacts =>
      'अहिलेसम्म कुनै आपतकालीन सम्पर्क राखिएको छैन। कृपया आफ्नो क्षेत्रको आपतकालीन नम्बरमा फोन गर्नुहोस्।';

  @override
  String get urgentAddContacts => 'आपतकालीन सम्पर्क थप्नुहोस्';

  @override
  String errorCannotCall(String phone) {
    return 'यो फोनले कल सुरु गर्न सकेन। कृपया $phone आफैं डायल गर्नुहोस्।';
  }

  @override
  String get homeLatestReadings => 'पछिल्ला नाप';

  @override
  String get homeNoReadings => 'अहिलेसम्म कुनै नाप छैन।';

  @override
  String get homeGuidanceTitle => 'आजको सुझाव';

  @override
  String get homeSeeGuidance => 'खाना र सुझाव हेर्नुहोस्';

  @override
  String get homeDoctorReport => 'डाक्टरको रिपोर्ट';

  @override
  String readingMeasuredAt(String date, String time) {
    return '$date, $time';
  }

  @override
  String notifMedicineMorning(String name) {
    return '$nameलाई बिहानको औषधि दिने समय भयो।';
  }

  @override
  String notifMedicineNight(String name) {
    return '$nameलाई रातको औषधि दिने समय भयो।';
  }

  @override
  String notifMeasureWeekly(String name) {
    return '$nameको स्वास्थ्य फेरि नाप्ने समय भयो।';
  }

  @override
  String notifMeasureMonthly(String name) {
    return '$nameको मासिक जाँच: फेरि नाप्ने समय भयो।';
  }

  @override
  String notifHydration(String name) {
    return '$nameलाई एक गिलास पानी? डाक्टरले पानी सीमित गरेको छ भने यो वेवास्ता गर्नुहोस्।';
  }

  @override
  String notifCustom(String name) {
    return '$nameका लागि सम्झना।';
  }

  @override
  String get notifTest => 'यो परीक्षणको सम्झना हो। यो फोनमा सम्झना काम गर्छ।';

  @override
  String get channelMedicineName => 'औषधिको सम्झना';

  @override
  String get channelMedicineDesc => 'उहाँको औषधि दिन सम्झाउँछ';

  @override
  String get channelChecksName => 'स्वास्थ्य जाँचको सम्झना';

  @override
  String get channelChecksDesc => 'फेरि नाप्न र अन्य कुरा सम्झाउँछ';

  @override
  String get remindersTitle => 'सम्झना';

  @override
  String get remindersIntro =>
      'फोनले कहिले सम्झाउनुपर्छ छान्नुहोस्। बदल्न कुनै सम्झना थिच्नुहोस्।';

  @override
  String get remindersAdd => 'सम्झना थप्नुहोस्';

  @override
  String get remindersEmpty => 'अहिलेसम्म कुनै सम्झना छैन।';

  @override
  String get reminderOn => 'चालु';

  @override
  String get reminderOff => 'बन्द';

  @override
  String get reminderIsOn => 'सम्झना चालु छ';

  @override
  String get reminderIsOff => 'सम्झना बन्द छ';

  @override
  String reminderNext(String when) {
    return 'अर्को: $when';
  }

  @override
  String get reminderTomorrow => 'भोलि';

  @override
  String reminderTimeAt(String day, String time) {
    return '$day, $time';
  }

  @override
  String get reminderTypeMedicineMorning => 'बिहानको औषधि';

  @override
  String get reminderTypeMedicineNight => 'रातको औषधि';

  @override
  String get reminderTypeMeasureWeekly => 'फेरि नाप्ने (हरेक हप्ता)';

  @override
  String get reminderTypeMeasureMonthly => 'मासिक जाँच';

  @override
  String get reminderTypeHydration => 'पानी';

  @override
  String get reminderTypeCustom => 'मेरो आफ्नै सम्झना';

  @override
  String get reminderRepeatDaily => 'हरेक दिन';

  @override
  String reminderRepeatWeekly(String day) {
    return 'हरेक $day';
  }

  @override
  String reminderRepeatMonthly(String day) {
    return 'हरेक महिनाको $day गते';
  }

  @override
  String get weekdayMon => 'सोमबार';

  @override
  String get weekdayTue => 'मंगलबार';

  @override
  String get weekdayWed => 'बुधबार';

  @override
  String get weekdayThu => 'बिहीबार';

  @override
  String get weekdayFri => 'शुक्रबार';

  @override
  String get weekdaySat => 'शनिबार';

  @override
  String get weekdaySun => 'आइतबार';

  @override
  String get reminderFormAddTitle => 'सम्झना थप्नुहोस्';

  @override
  String get reminderFormEditTitle => 'सम्झना बदल्नुहोस्';

  @override
  String get reminderTypeTitle => 'यो केका लागि हो?';

  @override
  String get reminderTimeTitle => 'कति बजे?';

  @override
  String get reminderHourLabel => 'घण्टा';

  @override
  String get reminderMinuteLabel => 'मिनेट';

  @override
  String get reminderMoreHours => 'एक घण्टा पछि';

  @override
  String get reminderFewerHours => 'एक घण्टा अघि';

  @override
  String get reminderMoreMinutes => '५ मिनेट पछि';

  @override
  String get reminderFewerMinutes => '५ मिनेट अघि';

  @override
  String get reminderMoreDays => 'एक दिन पछि';

  @override
  String get reminderFewerDays => 'एक दिन अघि';

  @override
  String get reminderLabelLabel => 'सम्झनाको नाम';

  @override
  String get reminderLabelHint => 'जस्तै: आँखाको औषधि';

  @override
  String get reminderWeekdayTitle => 'हप्ताको कुन दिन?';

  @override
  String get reminderMonthDayTitle => 'महिनाको कुन गते?';

  @override
  String reminderMonthDayValue(String day) {
    return '$day गते';
  }

  @override
  String get reminderDelete => 'सम्झना मेटाउनुहोस्';

  @override
  String get reminderDeleteTitle => 'यो सम्झना मेटाउने?';

  @override
  String get reminderDeleteBody =>
      'यसले सम्झाउन छोड्नेछ। उहाँको औषधिमा कुनै परिवर्तन हुँदैन।';

  @override
  String get errorReminderLabel => 'कृपया आफ्नो सम्झनाको नाम लेख्नुहोस्।';

  @override
  String get permNotifTitle => 'सूचना अनुमति दिनुहोस्';

  @override
  String get permNotifBody => 'सूचना अनुमति नदिएसम्म यो फोनमा सम्झना देखिँदैन।';

  @override
  String get permNotifHelp =>
      'थिच्दा केही भएन भने फोनको सेटिङ, त्यसपछि एप्स, त्यसपछि स्वास्थ्य साथी, त्यसपछि सूचना खोलेर चालु गर्नुहोस्।';

  @override
  String get permExactTitle => 'ठीक समयको अनुमति दिनुहोस्';

  @override
  String get permExactBody =>
      'सम्झना ठीक समयमा आओस् भन्नका लागि स्वास्थ्य साथीलाई “Alarms & reminders” को अनुमति दिनुहोस्। नदिएसम्म सम्झना केही मिनेट ढिलो आउन सक्छ।';

  @override
  String get permAllGood => 'सम्झना चालु छ र ठीक समयमा आउनेछ।';

  @override
  String get remindersCheckTitle => 'सम्झना काम गर्छ कि जाँच्नुहोस्';

  @override
  String get remindersTestNow => 'अहिले परीक्षण सम्झना पठाउनुहोस्';

  @override
  String get remindersTestSoon => '१ मिनेटमा परीक्षण सम्झना';

  @override
  String get remindersTestSent =>
      'परीक्षण सम्झना पठाइयो। स्क्रिनको माथि हेर्नुहोस्।';

  @override
  String get remindersTestScheduled =>
      '१ मिनेटपछि आउने परीक्षण सम्झना राखियो। एप बन्द गर्न सकिन्छ।';

  @override
  String get remindersTestNeedsPermission => 'पहिले सूचना अनुमति दिनुहोस्।';

  @override
  String get remindersBatteryHint =>
      'सम्झना ढिलो आयो वा आएन भने फोनको सेटिङ, त्यसपछि ब्याट्री खोलेर स्वास्थ्य साथीलाई ब्याकग्राउन्डमा चल्न दिनुहोस्। केही फोनमा यसलाई “अटो-स्टार्ट” भनिन्छ।';

  @override
  String get homeRemindersOff => 'यो फोनमा अहिले सम्झना देखिँदैन।';

  @override
  String get homeRemindersSetup => 'सम्झना मिलाउनुहोस्';

  @override
  String get permNotifButton => 'सूचना अनुमति दिनुहोस्';

  @override
  String get permExactButton => 'ठीक समयको अनुमति दिनुहोस्';

  @override
  String get settingsRemindersTile => 'सम्झना';

  @override
  String get medicinesRemindersButton => 'सम्झना';

  @override
  String get periodTitle => 'देखाउनुहोस्';

  @override
  String get period2Weeks => 'पछिल्ला २ हप्ता';

  @override
  String get period4Weeks => 'पछिल्ला ४ हप्ता';

  @override
  String get period3Months => 'पछिल्ला ३ महिना';

  @override
  String get historyEmptyTitle => 'अहिलेसम्म कुनै नाप छैन';

  @override
  String get historyEmptyBody => 'नाप थप्नुहोस्, यहाँ चार्टसहित देखिन्छ।';

  @override
  String get historyNoneInPeriod => 'यो समयमा कुनै नाप छैन।';

  @override
  String get statsTitle => 'सारांश';

  @override
  String statsCount(String count) {
    return 'नाप: $count';
  }

  @override
  String get statsAverage => 'औसत';

  @override
  String get statsLowest => 'सबैभन्दा कम';

  @override
  String get statsHighest => 'सबैभन्दा धेरै';

  @override
  String statsLine(String label, String value) {
    return '$label: $value';
  }

  @override
  String get chartTitle => 'चार्ट';

  @override
  String chartBandLegend(String low, String high, String unit) {
    return 'छायाँ परेको भाग: डाक्टरले दिएको सीमा, $low देखि $high $unit';
  }

  @override
  String get chartBandNone =>
      'डाक्टरको सीमा राखिएको छैन, त्यसैले कुनै भाग छायाँ पारिएको छैन।';

  @override
  String get chartUrgentLegend => 'धर्सा रेखा: डाक्टरले दिएको तुरुन्तको सीमा';

  @override
  String get chartTopLegend => 'माथिको अंक: गोला थोप्ला, ठोस रेखा';

  @override
  String get chartBottomLegend => 'तलको अंक: चौकोर थोप्ला, धर्सा रेखा';

  @override
  String chartSummary(
    String count,
    String first,
    String last,
    String min,
    String max,
  ) {
    return '$first देखि $last सम्मका $count नापको चार्ट। सबैभन्दा कम $min, सबैभन्दा धेरै $max।';
  }

  @override
  String get historyListTitle => 'यो समयका सबै नाप';

  @override
  String get readingDelete => 'यो नाप मेटाउनुहोस्';

  @override
  String get readingDeleteTitle => 'यो नाप मेटाउने?';

  @override
  String get readingDeleteBody =>
      'यो इतिहास र डाक्टरको रिपोर्टबाट हट्नेछ। यो फेरि फर्काउन मिल्दैन।';

  @override
  String get reportIntro =>
      'डाक्टरका लागि PDF बनाउनुहोस्: नाप, औसत, चार्ट र दिइएको औषधि।';

  @override
  String get reportPeriodTitle => 'कति दिन पछाडिसम्म?';

  @override
  String reportContains(String count, String meds) {
    return 'रिपोर्टमा $count नाप र $meds औषधि हुनेछन्।';
  }

  @override
  String get reportEnglishNote =>
      'रिपोर्ट अंग्रेजीमा लेखिन्छ ताकि जुनसुकै डाक्टरले पढ्न सकून्। उहाँको नाम र टिपोट तपाईंले लेखेजस्तै रहन्छन्।';

  @override
  String get reportShare => 'PDF पठाउनुहोस्';

  @override
  String get reportPreview => 'हेर्नुहोस् वा प्रिन्ट गर्नुहोस्';

  @override
  String get reportWorking => 'रिपोर्ट बनाउँदै...';

  @override
  String get reportFailed =>
      'रिपोर्ट बनाउन सकिएन। कृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String get reportPrivacy => 'तपाईंले पठाउन नचाहेसम्म PDF यही फोनमा रहन्छ।';

  @override
  String get reportNeedProfile => 'पहिले प्रोफाइलमा उहाँको नाम राख्नुहोस्।';

  @override
  String pdfTitle(String name) {
    return '$nameको स्वास्थ्य सारांश';
  }

  @override
  String pdfPeriodLine(String from, String to) {
    return 'अवधि: $from देखि $to';
  }

  @override
  String pdfMadeOn(String date) {
    return 'बनाएको मिति $date';
  }

  @override
  String get pdfAbout => 'उहाँको बारेमा';

  @override
  String pdfAge(String age) {
    return 'उमेर: लगभग $age वर्ष';
  }

  @override
  String pdfConditions(String list) {
    return 'यो एपमा हेरिएका अवस्था: $list';
  }

  @override
  String pdfAllergies(String text) {
    return 'एलर्जी / खान नमिल्ने खाना: $text';
  }

  @override
  String get pdfSoftFood => 'नरम खाना चाहिन्छ (चपाउन गाह्रो)।';

  @override
  String pdfNotes(String text) {
    return 'टिपोट: $text';
  }

  @override
  String get pdfRangesTitle => 'डाक्टरले दिएका सीमा (परिवारले राखेका)';

  @override
  String get pdfRangesNone =>
      'कुनै सीमा राखिएको छैन, त्यसैले नापलाई कुनै कुरासँग तुलना गरिएको छैन।';

  @override
  String get pdfColMeasure => 'नाप';

  @override
  String get pdfColTime => 'दिनको समय';

  @override
  String get pdfColUrgentLow => 'तुरुन्त: यसभन्दा तल';

  @override
  String get pdfColCautionLow => 'सावधान: यसभन्दा तल';

  @override
  String get pdfColCautionHigh => 'सावधान: यसभन्दा माथि';

  @override
  String get pdfColUrgentHigh => 'तुरुन्त: यसभन्दा माथि';

  @override
  String get pdfAllTimes => 'सबै समय';

  @override
  String pdfPlanLine(String text) {
    return 'डाक्टरको योजना, परिवारले लेखेअनुसार: $text';
  }

  @override
  String pdfWarningLine(String text) {
    return 'लक्षण, परिवारले लेखेअनुसार: $text';
  }

  @override
  String pdfReadingsTitle(String measure) {
    return '$measure: नाप';
  }

  @override
  String pdfUnitLine(String unit) {
    return 'चार्ट र सारांश $unit मा देखाइएका छन्। तालिकामा हरेक नाप लेखिएजस्तै देखाइएको छ।';
  }

  @override
  String get pdfColDate => 'मिति र समय';

  @override
  String get pdfColValue => 'नाप';

  @override
  String get pdfColWhen => 'कहिले';

  @override
  String get pdfColStatus => 'डाक्टरको सीमासँग तुलना';

  @override
  String get pdfColNote => 'टिपोट';

  @override
  String get pdfStatusIn => 'सीमाभित्र';

  @override
  String get pdfStatusOut => 'सीमाबाहिर';

  @override
  String get pdfStatusUrgent => 'तुरुन्तको सीमामा';

  @override
  String get pdfStatusNone => 'सीमा राखिएको छैन';

  @override
  String get pdfNoReadings => 'यो अवधिमा कुनै नाप छैन।';

  @override
  String pdfStatsLine(String count, String avg, String min, String max) {
    return 'नाप: $count। औसत $avg, सबैभन्दा कम $min, सबैभन्दा धेरै $max।';
  }

  @override
  String pdfTopStats(String avg, String min, String max) {
    return 'माथिको अंक: औसत $avg, सबैभन्दा कम $min, सबैभन्दा धेरै $max';
  }

  @override
  String pdfBottomStats(String avg, String min, String max) {
    return 'तलको अंक: औसत $avg, सबैभन्दा कम $min, सबैभन्दा धेरै $max';
  }

  @override
  String pdfPulseStats(String avg, String min, String max) {
    return 'नाडी: औसत $avg, सबैभन्दा कम $min, सबैभन्दा धेरै $max';
  }

  @override
  String pdfChartBand(String low, String high) {
    return 'खैरो भाग: डाक्टरको सीमा $low देखि $high। धर्सा रेखा: तुरुन्तको सीमा।';
  }

  @override
  String get pdfChartNoBand =>
      'डाक्टरको सीमा राखिएको छैन, त्यसैले भाग बनाइएको छैन।';

  @override
  String get pdfMedicinesTitle => 'औषधि र दिएको चिन्ह लगाइएका मात्रा';

  @override
  String get pdfMedsNone => 'एपमा कुनै औषधि राखिएको छैन।';

  @override
  String get pdfMedColName => 'औषधि (परिवारले लेखेअनुसार)';

  @override
  String get pdfMedColTimes => 'दिने समय';

  @override
  String pdfAdherenceLine(
    String slot,
    String taken,
    String expected,
    String percent,
  ) {
    return '$slot: $expected मध्ये $taken मात्रा दिएको चिन्ह ($percent%)';
  }

  @override
  String get pdfAdherenceNote =>
      'चिन्ह नलागेको मात्रा दिइएको पनि हुन सक्छ; परिवारले चिन्ह लगाउन बिर्सिएको हुन सक्छ।';

  @override
  String get pdfDayCol => 'दिन';

  @override
  String get pdfDisclaimer =>
      'स्वास्थ्य साथी एपले परिवारले राखेका अंकबाट बनाएको। यो चिकित्सकीय सल्लाह होइन र डाक्टरको जाँचको विकल्प होइन। सीमाहरू डाक्टरको निर्देशनको परिवारले राखेको प्रतिलिपि हुन्।';

  @override
  String pdfPage(String n, String total) {
    return 'पृष्ठ $n / $total';
  }

  @override
  String get pdfBloodPressureUnit => 'mmHg';

  @override
  String get reportTitle => 'डाक्टरको रिपोर्ट';

  @override
  String get noteColumnFallback => 'टिपोट';

  @override
  String get pinTitle => 'पिन लक';

  @override
  String get pinStateOn => 'चालु';

  @override
  String get pinStateOff => 'बन्द';

  @override
  String get pinIntro =>
      'पिनले अरूलाई यो फोनमा एप खोल्नबाट रोक्छ। यो गोपनीयताको ताला हो, कडा सुरक्षा होइन।';

  @override
  String get pinSet => 'पिन राख्नुहोस्';

  @override
  String get pinChange => 'पिन बदल्नुहोस्';

  @override
  String get pinRemove => 'पिन बन्द गर्नुहोस्';

  @override
  String get pinEnterNew => '४ अंकको पिन छान्नुहोस्';

  @override
  String get pinConfirmNew => 'उही पिन फेरि लेख्नुहोस्';

  @override
  String get pinEnterCurrent => 'अहिलेको पिन लेख्नुहोस्';

  @override
  String get pinUnlockTitle => 'स्वास्थ्य साथी खोल्न पिन लेख्नुहोस्';

  @override
  String get pinWrong => 'त्यो पिन गलत छ। कृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String get pinMismatch => 'दुई पिन फरक छन्। कृपया फेरि सुरु गर्नुहोस्।';

  @override
  String get pinSavedMessage => 'पिन अब चालु छ।';

  @override
  String get pinRemovedMessage => 'पिन अब बन्द छ।';

  @override
  String get pinDigitDelete => 'पछिल्लो अंक मेट्नुहोस्';

  @override
  String pinDotsLabel(String count) {
    return '४ मध्ये $count अंक लेखियो';
  }

  @override
  String pinLockedOut(String seconds) {
    return 'धेरै पटक गलत भयो। $seconds सेकेन्डपछि फेरि प्रयास गर्नुहोस्।';
  }

  @override
  String get pinForgot => 'पिन बिर्सनुभयो?';

  @override
  String get pinForgotTitle => 'पिन बिर्सनुभयो?';

  @override
  String get pinForgotBody =>
      'फेरि भित्र पस्ने एउटै उपाय यो फोनको सबै कुरा मेटेर नयाँ सुरु गर्नु हो। यसले एपका सबै नाप, औषधि र सम्झना मेटाउँछ।';

  @override
  String get pinForgotConfirm => 'सबै मेटाउनुहोस्';

  @override
  String get pinKeepTrying => 'प्रयास गरिरहनुहोस्';

  @override
  String get dataTitle => 'तपाईंको डाटा';

  @override
  String get dataExport => 'सबै डाटाको प्रतिलिपि सुरक्षित गर्नुहोस्';

  @override
  String get dataExportBody =>
      'यो एपका सबै कुरा भएको एउटा फाइल बनाउँछ। यसमा स्वास्थ्य जानकारी हुन्छ, त्यसैले गोप्य राख्नुहोस्। यो फाइलबाट फर्काउने सुविधा अझै बनेको छैन।';

  @override
  String get dataExportButton => 'फाइल बनाएर पठाउनुहोस्';

  @override
  String get dataExportFailed =>
      'फाइल बनाउन सकिएन। कृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String get dataDelete => 'सबै डाटा मेटाउनुहोस्';

  @override
  String get dataDeleteBody =>
      'यो फोनबाट सबै कुरा हटाउँछ: उहाँको प्रोफाइल, नाप, औषधि, सम्झना र सेटिङ। यो फर्काउन मिल्दैन।';

  @override
  String get dataDeleteTitle => 'सबै डाटा मेटाउने?';

  @override
  String get dataDeleteSecondTitle => 'के तपाईं पक्का हुनुहुन्छ?';

  @override
  String get dataDeleteSecondBody =>
      'अहिले सबै मेटिनेछ। प्रतिलिपि चाहिन्छ भने पहिले सुरक्षित गर्नुहोस्।';

  @override
  String get dataDeleteConfirm => 'सबै मेटाउनुहोस्';

  @override
  String get dataDeleteKeep => 'मेरो डाटा राख्नुहोस्';

  @override
  String get helpTitle => 'कसरी प्रयोग गर्ने';

  @override
  String get helpIntro => 'हरेक दिन गर्न सकिने केही सरल कुरा।';

  @override
  String get helpStep1Title => 'औषधि दिनुहोस्';

  @override
  String get helpStep1Body =>
      'गृहपृष्ठमा औषधि दिएपछि त्यसलाई थिच्नुहोस्। गल्ती भयो भने फेरि थिच्नुहोस्।';

  @override
  String get helpStep2Title => 'नाप लेख्नुहोस्';

  @override
  String get helpStep2Body =>
      'नाप थप्नुहोस् थिच्नुहोस्, मिटरको अंक लेख्नुहोस्, अनि सेभ गर्नुहोस्। एपले यसलाई डाक्टरले दिएको सीमासँग तुलना गर्छ।';

  @override
  String get helpStep3Title => 'सम्झना पाउनुहोस्';

  @override
  String get helpStep3Body =>
      'सेटिङमा सम्झना खोलेर समय छान्नुहोस्। फोनले सम्झाउनेछ।';

  @override
  String get helpStep4Title => 'डाक्टरलाई देखाउनुहोस्';

  @override
  String get helpStep4Body =>
      'गृहपृष्ठमा डाक्टरको रिपोर्ट, त्यसपछि PDF पठाउनुहोस् थिच्नुहोस्। डाक्टरले नाप र दिइएको औषधि हेर्न सक्छन्।';

  @override
  String get helpStep5Title => '\"तुरुन्तै ध्यान दिनुपर्ने\" देखिएमा';

  @override
  String get helpStep5Body =>
      'अहिले नै उहाँको डाक्टर वा आपतकालीन सेवालाई फोन गर्नुहोस्। एपले कहिल्यै उपचारको सल्लाह दिँदैन र औषधि बदल्न भन्दैन।';

  @override
  String helpStepLabel(String n, String total) {
    return 'चरण $n / $total';
  }

  @override
  String get settingsHelpTile => 'यो एप कसरी प्रयोग गर्ने';

  @override
  String get helpTooltip => 'मद्दत';

  @override
  String get errorStartupTitle => 'एप सुरु हुन सकेन';

  @override
  String get errorStartupBody =>
      'एपको डाटा खोल्दा केही गडबड भयो। कृपया एप बन्द गरेर फेरि खोल्नुहोस्।';

  @override
  String get errorRetry => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get errorWidgetBody =>
      'यो स्क्रिनमा केही गडबड भयो। कृपया पछाडि गएर फेरि प्रयास गर्नुहोस्।';

  @override
  String remindersTestFailed(String reason) {
    return 'परीक्षण सम्झना पठाउन सकिएन। कारण: $reason';
  }

  @override
  String get remindersDiagTitle => 'सम्झना जाँच';

  @override
  String remindersDiagPending(int count) {
    return 'यो फोनमा पर्खिरहेका सम्झनाहरू: $count';
  }

  @override
  String remindersDiagError(String reason) {
    return 'समस्या भेटियो: $reason';
  }

  @override
  String get remindersDiagOk => 'कुनै समस्या भेटिएन।';

  @override
  String get settingsPrivacyScreen => 'स्क्रिनसट र हालका एपमा एप लुकाउनुहोस्';

  @override
  String get settingsPrivacyOn =>
      'चालु: स्क्रिनसट लिन मिल्दैन। स्क्रिनसट लिन बन्द गर्नुहोस्।';

  @override
  String get settingsPrivacyOff =>
      'बन्द: स्क्रिनसट लिन मिल्छ। हालका एपमा जसले पनि देख्न सक्छ।';

  @override
  String photoOf(String name) {
    return '$name को फोटो';
  }

  @override
  String get photoTake => 'फोटो खिच्नुहोस्';

  @override
  String get photoChoose => 'ग्यालरीबाट छान्नुहोस्';

  @override
  String get photoRemove => 'फोटो हटाउनुहोस्';

  @override
  String get photoHint => 'ऐच्छिक। फोटो यही फोनमा मात्र रहन्छ।';

  @override
  String get photoFailed => 'फोटो राख्न सकिएन। कृपया फेरि प्रयास गर्नुहोस्।';
}
