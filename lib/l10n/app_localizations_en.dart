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

  @override
  String get gTipSitSlowly => 'Let him sit comfortably and eat slowly.';

  @override
  String get gTipRegularMeals => 'Keep meal times regular. Do not skip meals.';

  @override
  String get gTipFluids =>
      'Offer water through the day, unless his doctor has limited fluids.';

  @override
  String get gTipWalk => 'A gentle walk may be good, if his doctor allows it.';

  @override
  String get gMealSteamedVeg => 'Steamed or boiled vegetables';

  @override
  String get gMealCurd => 'A small bowl of curd';

  @override
  String get gMealEgg => 'A boiled egg';

  @override
  String get gMealSoftDalBhat => 'Soft, well-cooked dal-bhat with vegetables';

  @override
  String get gMealGreensSoup =>
      'Gundruk or sisnu soup, cooked with little salt';

  @override
  String get gMealKhichadi => 'Soft khichadi with vegetables';

  @override
  String get gEasyFried => 'Deep-fried foods, such as pakoda or puri';

  @override
  String get gMealDalBhatMoreVeg =>
      'Dal-bhat with more tarkari and a smaller helping of rice';

  @override
  String get gMealRotiDhido => 'Roti or dhido, in a moderate portion';

  @override
  String get gEasySugarChiya => 'Sugar in chiya';

  @override
  String get gEasySweets => 'Sweets, especially around Dashain and Tihar';

  @override
  String get gEasySalt => 'Extra salt added at the table';

  @override
  String get gEasyAchar => 'Achar (pickles)';

  @override
  String get gEasyNoodles => 'Instant noodles and packaged snacks';

  @override
  String get addReading => 'Add reading';

  @override
  String get addReadingChoose => 'What did you measure?';

  @override
  String get kindBloodSugar => 'Blood sugar';

  @override
  String get kindBloodPressure => 'Blood pressure';

  @override
  String get addReadingNeedCondition =>
      'Choose a health condition in the profile first, then you can add readings.';

  @override
  String get readingFormSugarTitle => 'New blood sugar reading';

  @override
  String get readingFormBpTitle => 'New blood pressure reading';

  @override
  String get readingSugarLabel => 'Blood sugar number';

  @override
  String get bpTopLabel => 'Top number (systolic)';

  @override
  String get bpBottomLabel => 'Bottom number (diastolic)';

  @override
  String get bpPulseLabel => 'Pulse (optional)';

  @override
  String get readingWhenTitle => 'When was it measured?';

  @override
  String get readingUnitTitle => 'Unit';

  @override
  String get readingNoteLabel => 'Note (optional)';

  @override
  String get readingSave => 'Save reading';

  @override
  String get errorReadingNumber => 'Please type the number shown on the meter.';

  @override
  String get errorReadingImplausible =>
      'This number looks wrong. Please check the meter and type it again.';

  @override
  String get errorBpOrder =>
      'The top number should be larger than the bottom number. Please check.';

  @override
  String get resultTitle => 'Result';

  @override
  String get tierInRange => 'Within his doctor\'s range';

  @override
  String get tierOutOfRange => 'Outside his doctor\'s range';

  @override
  String get tierUrgent => 'Urgent';

  @override
  String get tierUnknown => 'No range to compare with';

  @override
  String get headlineInRange =>
      'This reading is within the range his doctor gave.';

  @override
  String get headlineOutOfRange =>
      'This reading is outside the range his doctor gave. Be careful.';

  @override
  String get headlineUrgent => 'Contact his doctor or emergency services now';

  @override
  String get headlineNoRanges => 'Enter the doctor\'s ranges in the profile';

  @override
  String get noRangesBody =>
      'Without the doctor\'s numbers the app cannot say if a reading is high or low, and it will not guess.';

  @override
  String get enterRangesButton => 'Enter the doctor\'s ranges';

  @override
  String get guidanceMeals => 'Prefer';

  @override
  String get guidanceGoEasyOn => 'Go easy on';

  @override
  String get guidanceTips => 'Other tips';

  @override
  String get guidanceTellDoctor => 'Tell his doctor about this reading.';

  @override
  String get guidanceDoctorPlan => 'His doctor\'s plan';

  @override
  String get guidanceDoctorPlanNote =>
      'Written by the family from his doctor\'s words.';

  @override
  String get guidanceWarningSigns => 'Warning signs to watch for';

  @override
  String get guidanceNotAdvice =>
      'This is general food guidance, not medical advice. Ask his doctor if unsure.';

  @override
  String get unreviewedLabel => 'Not yet reviewed by a clinician';

  @override
  String get guidanceDone => 'Back to Home';

  @override
  String get readingNotFound => 'This reading could not be found.';

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
    return 'Pulse $pulse';
  }

  @override
  String urgentCall(String name) {
    return 'Call $name';
  }

  @override
  String get urgentNoContacts =>
      'No emergency contacts are saved yet. Please call your local emergency number.';

  @override
  String get urgentAddContacts => 'Add emergency contacts';

  @override
  String errorCannotCall(String phone) {
    return 'This phone could not start the call. Please dial $phone by hand.';
  }

  @override
  String get homeLatestReadings => 'Latest readings';

  @override
  String get homeNoReadings => 'No readings yet.';

  @override
  String get homeGuidanceTitle => 'Today\'s guidance';

  @override
  String get homeSeeGuidance => 'See meal ideas and tips';

  @override
  String get homeDoctorReport => 'Doctor report';

  @override
  String readingMeasuredAt(String date, String time) {
    return '$date, $time';
  }

  @override
  String notifMedicineMorning(String name) {
    return 'Time to give $name his morning medicine.';
  }

  @override
  String notifMedicineNight(String name) {
    return 'Time to give $name his night medicine.';
  }

  @override
  String notifMeasureWeekly(String name) {
    return 'Time to measure $name\'s health again.';
  }

  @override
  String notifMeasureMonthly(String name) {
    return 'Monthly check for $name: time to measure again.';
  }

  @override
  String notifHydration(String name) {
    return 'A glass of water for $name? Skip this if his doctor has limited fluids.';
  }

  @override
  String notifCustom(String name) {
    return 'Reminder for $name.';
  }

  @override
  String get notifTest =>
      'This is a test reminder. Reminders work on this phone.';

  @override
  String get channelMedicineName => 'Medicine reminders';

  @override
  String get channelMedicineDesc => 'Reminds you to give his medicine';

  @override
  String get channelChecksName => 'Health check reminders';

  @override
  String get channelChecksDesc =>
      'Reminds you to measure again, and other reminders';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get remindersIntro =>
      'Choose when the phone should remind you. Tap a reminder to change it.';

  @override
  String get remindersAdd => 'Add reminder';

  @override
  String get remindersEmpty => 'No reminders yet.';

  @override
  String get reminderOn => 'On';

  @override
  String get reminderOff => 'Off';

  @override
  String get reminderIsOn => 'Reminder is on';

  @override
  String get reminderIsOff => 'Reminder is off';

  @override
  String reminderNext(String when) {
    return 'Next: $when';
  }

  @override
  String get reminderTomorrow => 'Tomorrow';

  @override
  String reminderTimeAt(String day, String time) {
    return '$day, $time';
  }

  @override
  String get reminderTypeMedicineMorning => 'Morning medicine';

  @override
  String get reminderTypeMedicineNight => 'Night medicine';

  @override
  String get reminderTypeMeasureWeekly => 'Measure again (every week)';

  @override
  String get reminderTypeMeasureMonthly => 'Monthly check';

  @override
  String get reminderTypeHydration => 'Water';

  @override
  String get reminderTypeCustom => 'My own reminder';

  @override
  String get reminderRepeatDaily => 'Every day';

  @override
  String reminderRepeatWeekly(String day) {
    return 'Every $day';
  }

  @override
  String reminderRepeatMonthly(String day) {
    return 'Day $day of every month';
  }

  @override
  String get weekdayMon => 'Monday';

  @override
  String get weekdayTue => 'Tuesday';

  @override
  String get weekdayWed => 'Wednesday';

  @override
  String get weekdayThu => 'Thursday';

  @override
  String get weekdayFri => 'Friday';

  @override
  String get weekdaySat => 'Saturday';

  @override
  String get weekdaySun => 'Sunday';

  @override
  String get reminderFormAddTitle => 'Add reminder';

  @override
  String get reminderFormEditTitle => 'Change reminder';

  @override
  String get reminderTypeTitle => 'What is it for?';

  @override
  String get reminderTimeTitle => 'What time?';

  @override
  String get reminderHourLabel => 'Hour';

  @override
  String get reminderMinuteLabel => 'Minutes';

  @override
  String get reminderMoreHours => 'One hour later';

  @override
  String get reminderFewerHours => 'One hour earlier';

  @override
  String get reminderMoreMinutes => '5 minutes later';

  @override
  String get reminderFewerMinutes => '5 minutes earlier';

  @override
  String get reminderMoreDays => 'One day later';

  @override
  String get reminderFewerDays => 'One day earlier';

  @override
  String get reminderLabelLabel => 'Name of the reminder';

  @override
  String get reminderLabelHint => 'For example: Eye drops';

  @override
  String get reminderWeekdayTitle => 'Which day of the week?';

  @override
  String get reminderMonthDayTitle => 'Which day of the month?';

  @override
  String reminderMonthDayValue(String day) {
    return 'Day $day';
  }

  @override
  String get reminderDelete => 'Delete reminder';

  @override
  String get reminderDeleteTitle => 'Delete this reminder?';

  @override
  String get reminderDeleteBody =>
      'It will stop reminding you. His medicines are not changed.';

  @override
  String get errorReminderLabel => 'Please type a name for your reminder.';

  @override
  String get permNotifTitle => 'Allow notifications';

  @override
  String get permNotifBody =>
      'Reminders cannot appear on this phone until you allow notifications.';

  @override
  String get permNotifHelp =>
      'If nothing happens when you tap, open the phone\'s Settings, then Apps, then CareCompanion, then Notifications, and switch them on.';

  @override
  String get permExactTitle => 'Allow exact times';

  @override
  String get permExactBody =>
      'So reminders arrive at the right minute, allow “Alarms & reminders” for CareCompanion. Until then, reminders may come a few minutes late.';

  @override
  String get permAllGood => 'Reminders are on and will arrive on time.';

  @override
  String get remindersCheckTitle => 'Check that reminders work';

  @override
  String get remindersTestNow => 'Send a test reminder now';

  @override
  String get remindersTestSoon => 'Test reminder in 1 minute';

  @override
  String get remindersTestSent =>
      'Test reminder sent. Look at the top of the screen.';

  @override
  String get remindersTestScheduled =>
      'Test reminder set for 1 minute from now. You can close the app.';

  @override
  String get remindersTestNeedsPermission => 'Allow notifications first.';

  @override
  String get remindersBatteryHint =>
      'If reminders are late or missing, open the phone\'s Settings, then Battery, and allow CareCompanion to run in the background. Some phones call this “auto-start”.';

  @override
  String get homeRemindersOff => 'Reminders cannot appear on this phone yet.';

  @override
  String get homeRemindersSetup => 'Set up reminders';

  @override
  String get permNotifButton => 'Allow notifications';

  @override
  String get permExactButton => 'Allow exact times';

  @override
  String get settingsRemindersTile => 'Reminders';

  @override
  String get medicinesRemindersButton => 'Reminders';
}
