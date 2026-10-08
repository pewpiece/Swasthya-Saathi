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

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get edit => 'Edit';

  @override
  String get saved => 'Saved';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNeedName => 'Please type a name.';

  @override
  String get errorNumberInvalid => 'Please type a number, like 120.';

  @override
  String homeGreeting(String name) {
    return '$name\'s day';
  }

  @override
  String get profileTooltip => 'Profile';

  @override
  String ageYears(String years) {
    return '$years years old';
  }

  @override
  String get fastingTitle => 'Fasting today (upabas)';

  @override
  String get fastingYes => 'Yes, he is fasting today';

  @override
  String get fastingNo => 'No, not fasting today';

  @override
  String get fastingNote =>
      'Check with his doctor how to handle medicine and readings on fasting days.';

  @override
  String checklistMorningTitle(String name) {
    return 'Give $name his morning medicine';
  }

  @override
  String checklistNightTitle(String name) {
    return 'Give $name his night medicine';
  }

  @override
  String get doseNotGiven => 'Not given yet';

  @override
  String doseGivenAt(String time) {
    return 'Given at $time';
  }

  @override
  String get doseUndoHint => 'Tap again to undo';

  @override
  String get doseAllDone => 'All given';

  @override
  String doseProgress(String done, String total) {
    return '$done of $total given';
  }

  @override
  String doseSemanticsGiven(String medicine) {
    return '$medicine, given. Double tap to undo.';
  }

  @override
  String doseSemanticsNotGiven(String medicine) {
    return '$medicine, not given yet. Double tap to mark as given.';
  }

  @override
  String get noMedicinesTitle => 'No medicines added yet';

  @override
  String get noMedicinesBody => 'Add his medicines to get a daily checklist.';

  @override
  String get addMedicine => 'Add medicine';

  @override
  String get slotMorning => 'Morning';

  @override
  String get slotNight => 'Night';

  @override
  String get medicinesListTitle => 'His medicines';

  @override
  String get medicineNoTime => 'No time chosen';

  @override
  String get adherenceTitle => 'Last 14 days';

  @override
  String get adherenceIntro =>
      'How many medicines were marked as given each day.';

  @override
  String get adherenceToday => 'Today';

  @override
  String adherenceMorning(String taken, String expected) {
    return 'Morning: $taken of $expected';
  }

  @override
  String adherenceNight(String taken, String expected) {
    return 'Night: $taken of $expected';
  }

  @override
  String get adherenceNone => 'No medicines due';

  @override
  String get adherenceAll => 'All given';

  @override
  String get adherenceSome => 'Some not marked';

  @override
  String get adherenceMissed => 'None marked';

  @override
  String get adherenceEmpty =>
      'History will appear here after you add medicines.';

  @override
  String get medicineFormAddTitle => 'Add medicine';

  @override
  String get medicineFormEditTitle => 'Edit medicine';

  @override
  String get medicineNameLabel => 'Medicine name';

  @override
  String get medicineNameHint => 'Type it as written on the packet';

  @override
  String get medicineNotesLabel => 'Notes (optional)';

  @override
  String get medicineNotesHint => 'For example: after food';

  @override
  String get medicineWhenTitle => 'When is it given?';

  @override
  String get medicineRemove => 'Remove from list';

  @override
  String medicineRemoveTitle(String name) {
    return 'Remove $name from the list?';
  }

  @override
  String get medicineRemoveBody =>
      'This only removes it from this app\'s daily list. It does not change his medicine. Ask his doctor about any medicine change. Past records are kept.';

  @override
  String get keepIt => 'Keep it';

  @override
  String get removeIt => 'Remove';

  @override
  String get errorNeedSlot => 'Choose morning, night, or both.';

  @override
  String get errorNeedMedicineName => 'Please type the medicine name.';

  @override
  String get profileTitle => 'Profile';

  @override
  String profileHubIntro(String name) {
    return 'Everything about $name. Tap a line to change it.';
  }

  @override
  String get stepAboutTitle => 'About him';

  @override
  String get stepConditionsTitle => 'Health conditions';

  @override
  String get stepFoodTitle => 'Food and allergies';

  @override
  String get stepMedicinesTitle => 'Medicines';

  @override
  String get stepRangesTitle => 'Doctor\'s numbers';

  @override
  String get stepContactsTitle => 'Emergency contacts';

  @override
  String get summaryNotSet => 'Not set yet';

  @override
  String summaryCount(String count) {
    return '$count added';
  }

  @override
  String get summarySoftFood => 'Soft food';

  @override
  String get wizardSetupTitle => 'Set up the profile';

  @override
  String wizardStepOf(String current, String total) {
    return 'Step $current of $total';
  }

  @override
  String get wizardFinish => 'Finish';

  @override
  String get aboutNameLabel => 'His name';

  @override
  String get aboutNameHint => 'Type his first name';

  @override
  String get aboutAgeLabel => 'His age (years)';

  @override
  String get aboutNotesLabel => 'Notes (optional)';

  @override
  String get errorNeedHisName => 'Please type his name.';

  @override
  String get errorAgeInvalid => 'Please type an age between 1 and 120.';

  @override
  String get conditionsIntro =>
      'Which of these has his doctor told you about? You can change this any time.';

  @override
  String get conditionDiabetes => 'Diabetes (blood sugar)';

  @override
  String get conditionHypertension => 'High blood pressure';

  @override
  String get conditionIncluded => 'Included';

  @override
  String get conditionNotIncluded => 'Not included';

  @override
  String get foodIntro =>
      'Tell us about allergies and chewing, so meal ideas suit him.';

  @override
  String get allergiesLabel => 'Allergies or foods he cannot eat';

  @override
  String get allergiesHint => 'For example: peanuts, shellfish';

  @override
  String get softFoodTitle => 'He needs soft food';

  @override
  String get softFoodHint => 'Choose this if chewing is hard.';

  @override
  String get medicinesStepIntro =>
      'Add each medicine and when it is given. Type them as written by his doctor.';

  @override
  String get rangesIntro =>
      'Type the numbers his doctor gave you. The app has no numbers of its own. If you leave them empty, the app will not judge any reading.';

  @override
  String get rangesNoConditions =>
      'First choose a health condition (in \"Health conditions\"), then come back here.';

  @override
  String get rangeAllTimes => 'All times';

  @override
  String get rangeSpecificTimes =>
      'Different numbers for a certain time (optional)';

  @override
  String get rangeUnit => 'Unit';

  @override
  String get rangeUrgentLow => 'Urgent if below';

  @override
  String get rangeCautionLow => 'Be careful if below';

  @override
  String get rangeCautionHigh => 'Be careful if above';

  @override
  String get rangeUrgentHigh => 'Urgent if above';

  @override
  String get rangeDoctorPlan => 'His doctor\'s plan (optional)';

  @override
  String get rangeDoctorPlanHint =>
      'What his doctor said to do, in their words';

  @override
  String get rangeWarningSigns => 'Warning signs to watch for (optional)';

  @override
  String get rangeWarningSignsHint => 'As told by his doctor';

  @override
  String get rangeFilled => 'Numbers entered';

  @override
  String get rangeNotEntered => 'Not entered yet';

  @override
  String get errorRangeOrder =>
      'These numbers are not in order. Please check them against what his doctor wrote.';

  @override
  String get errorRangeImplausible =>
      'This number looks wrong. Please check it.';

  @override
  String get contactsIntro =>
      'Add the people to call in an emergency. The app has no phone numbers of its own.';

  @override
  String get contactsEmpty => 'No contacts yet';

  @override
  String get contactAdd => 'Add contact';

  @override
  String get contactFormAddTitle => 'Add contact';

  @override
  String get contactFormEditTitle => 'Edit contact';

  @override
  String get contactNameLabel => 'Name';

  @override
  String get contactRoleLabel => 'Who is this?';

  @override
  String get contactPhoneLabel => 'Phone number';

  @override
  String get roleDoctor => 'Doctor';

  @override
  String get roleHospital => 'Hospital';

  @override
  String get roleAmbulance => 'Ambulance';

  @override
  String get roleFamily => 'Family';

  @override
  String get errorPhoneInvalid => 'Please check the phone number.';

  @override
  String get contactDelete => 'Delete contact';

  @override
  String contactDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get contactDeleteBody => 'This removes the contact from this phone.';

  @override
  String get keepContact => 'Keep it';

  @override
  String get deleteIt => 'Delete';

  @override
  String get settingsProfileTile => 'Profile and doctor\'s numbers';

  @override
  String get debugLoadDemo => 'Load demo data (testing only)';

  @override
  String get debugDemoLoaded => 'Demo data loaded';

  @override
  String get timeAm => 'AM';

  @override
  String get timePm => 'PM';

  @override
  String timeFormat(String time, String period) {
    return '$time $period';
  }

  @override
  String get errorFixMarked =>
      'Please fix the items marked with a warning sign.';
}
