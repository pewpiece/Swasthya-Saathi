import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ne.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ne'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CareCompanion'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMedicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get navMedicines;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to CareCompanion'**
  String get welcomeTitle;

  /// No description provided for @welcomeIntro.
  ///
  /// In en, this message translates to:
  /// **'This app helps you look after your parent. You can write down his health readings, tick off his medicines, and get reminders.'**
  String get welcomeIntro;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'This app is not medical advice'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'CareCompanion does not replace his doctor. It never tells you to start, stop, or change a medicine. All health ranges come from his doctor. If you are worried, call his doctor.'**
  String get disclaimerBody;

  /// No description provided for @disclaimerPrivacy.
  ///
  /// In en, this message translates to:
  /// **'All information stays on this phone. Nothing is sent anywhere.'**
  String get disclaimerPrivacy;

  /// No description provided for @disclaimerAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get disclaimerAccept;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'This part of the app is not ready yet.'**
  String get comingSoonBody;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageNepali.
  ///
  /// In en, this message translates to:
  /// **'नेपाली (Nepali)'**
  String get languageNepali;

  /// No description provided for @settingsDateStyle.
  ///
  /// In en, this message translates to:
  /// **'Date style'**
  String get settingsDateStyle;

  /// No description provided for @dateStyleAd.
  ///
  /// In en, this message translates to:
  /// **'AD (English calendar)'**
  String get dateStyleAd;

  /// No description provided for @dateStyleBs.
  ///
  /// In en, this message translates to:
  /// **'BS (Nepali calendar)'**
  String get dateStyleBs;

  /// No description provided for @settingsGlucoseUnit.
  ///
  /// In en, this message translates to:
  /// **'Blood sugar unit'**
  String get settingsGlucoseUnit;

  /// No description provided for @unitMgDl.
  ///
  /// In en, this message translates to:
  /// **'mg/dL'**
  String get unitMgDl;

  /// No description provided for @unitMmolL.
  ///
  /// In en, this message translates to:
  /// **'mmol/L'**
  String get unitMmolL;

  /// No description provided for @settingsDigitStyle.
  ///
  /// In en, this message translates to:
  /// **'Number style'**
  String get settingsDigitStyle;

  /// No description provided for @digitsLatin.
  ///
  /// In en, this message translates to:
  /// **'Latin numbers (1 2 3)'**
  String get digitsLatin;

  /// No description provided for @digitsDevanagari.
  ///
  /// In en, this message translates to:
  /// **'Nepali numbers (१ २ ३)'**
  String get digitsDevanagari;

  /// No description provided for @settingsTextSizeHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'How to make text bigger'**
  String get settingsTextSizeHelpTitle;

  /// No description provided for @settingsTextSizeHelpBody.
  ///
  /// In en, this message translates to:
  /// **'Open your phone\'s Settings, then Display, then Font size. CareCompanion follows that size.'**
  String get settingsTextSizeHelpBody;

  /// No description provided for @settingsDisclaimerTile.
  ///
  /// In en, this message translates to:
  /// **'This app is not medical advice'**
  String get settingsDisclaimerTile;

  /// No description provided for @settingsPreviewDate.
  ///
  /// In en, this message translates to:
  /// **'Today\'s date: {date}'**
  String settingsPreviewDate(String date);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @metricBloodSugar.
  ///
  /// In en, this message translates to:
  /// **'Blood sugar'**
  String get metricBloodSugar;

  /// No description provided for @metricBloodPressureSystolic.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure (top number)'**
  String get metricBloodPressureSystolic;

  /// No description provided for @metricBloodPressureDiastolic.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure (bottom number)'**
  String get metricBloodPressureDiastolic;

  /// No description provided for @metricPulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get metricPulse;

  /// No description provided for @tagFasting.
  ///
  /// In en, this message translates to:
  /// **'Fasting (before eating)'**
  String get tagFasting;

  /// No description provided for @tagBeforeMeal.
  ///
  /// In en, this message translates to:
  /// **'Before a meal'**
  String get tagBeforeMeal;

  /// No description provided for @tagAfterMeal.
  ///
  /// In en, this message translates to:
  /// **'After a meal'**
  String get tagAfterMeal;

  /// No description provided for @tagBedtime.
  ///
  /// In en, this message translates to:
  /// **'At bedtime'**
  String get tagBedtime;

  /// No description provided for @tagMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get tagMorning;

  /// No description provided for @tagEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get tagEvening;

  /// No description provided for @tagOther.
  ///
  /// In en, this message translates to:
  /// **'Other time'**
  String get tagOther;

  /// No description provided for @bsMonth1.
  ///
  /// In en, this message translates to:
  /// **'Baisakh'**
  String get bsMonth1;

  /// No description provided for @bsMonth2.
  ///
  /// In en, this message translates to:
  /// **'Jestha'**
  String get bsMonth2;

  /// No description provided for @bsMonth3.
  ///
  /// In en, this message translates to:
  /// **'Ashadh'**
  String get bsMonth3;

  /// No description provided for @bsMonth4.
  ///
  /// In en, this message translates to:
  /// **'Shrawan'**
  String get bsMonth4;

  /// No description provided for @bsMonth5.
  ///
  /// In en, this message translates to:
  /// **'Bhadra'**
  String get bsMonth5;

  /// No description provided for @bsMonth6.
  ///
  /// In en, this message translates to:
  /// **'Ashwin'**
  String get bsMonth6;

  /// No description provided for @bsMonth7.
  ///
  /// In en, this message translates to:
  /// **'Kartik'**
  String get bsMonth7;

  /// No description provided for @bsMonth8.
  ///
  /// In en, this message translates to:
  /// **'Mangsir'**
  String get bsMonth8;

  /// No description provided for @bsMonth9.
  ///
  /// In en, this message translates to:
  /// **'Poush'**
  String get bsMonth9;

  /// No description provided for @bsMonth10.
  ///
  /// In en, this message translates to:
  /// **'Magh'**
  String get bsMonth10;

  /// No description provided for @bsMonth11.
  ///
  /// In en, this message translates to:
  /// **'Falgun'**
  String get bsMonth11;

  /// No description provided for @bsMonth12.
  ///
  /// In en, this message translates to:
  /// **'Chaitra'**
  String get bsMonth12;

  /// No description provided for @bsDateFormat.
  ///
  /// In en, this message translates to:
  /// **'{day} {month} {year} BS'**
  String bsDateFormat(String day, String month, String year);

  /// No description provided for @adDateFormat.
  ///
  /// In en, this message translates to:
  /// **'{day} {month} {year}'**
  String adDateFormat(String day, String month, String year);

  /// No description provided for @adMonth1.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get adMonth1;

  /// No description provided for @adMonth2.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get adMonth2;

  /// No description provided for @adMonth3.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get adMonth3;

  /// No description provided for @adMonth4.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get adMonth4;

  /// No description provided for @adMonth5.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get adMonth5;

  /// No description provided for @adMonth6.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get adMonth6;

  /// No description provided for @adMonth7.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get adMonth7;

  /// No description provided for @adMonth8.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get adMonth8;

  /// No description provided for @adMonth9.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get adMonth9;

  /// No description provided for @adMonth10.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get adMonth10;

  /// No description provided for @adMonth11.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get adMonth11;

  /// No description provided for @adMonth12.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get adMonth12;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNeedName.
  ///
  /// In en, this message translates to:
  /// **'Please type a name.'**
  String get errorNeedName;

  /// No description provided for @errorNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please type a number, like 120.'**
  String get errorNumberInvalid;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s day'**
  String homeGreeting(String name);

  /// No description provided for @profileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTooltip;

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{years} years old'**
  String ageYears(String years);

  /// No description provided for @fastingTitle.
  ///
  /// In en, this message translates to:
  /// **'Fasting today (upabas)'**
  String get fastingTitle;

  /// No description provided for @fastingYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, he is fasting today'**
  String get fastingYes;

  /// No description provided for @fastingNo.
  ///
  /// In en, this message translates to:
  /// **'No, not fasting today'**
  String get fastingNo;

  /// No description provided for @fastingNote.
  ///
  /// In en, this message translates to:
  /// **'Check with his doctor how to handle medicine and readings on fasting days.'**
  String get fastingNote;

  /// No description provided for @checklistMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Give {name} his morning medicine'**
  String checklistMorningTitle(String name);

  /// No description provided for @checklistNightTitle.
  ///
  /// In en, this message translates to:
  /// **'Give {name} his night medicine'**
  String checklistNightTitle(String name);

  /// No description provided for @doseNotGiven.
  ///
  /// In en, this message translates to:
  /// **'Not given yet'**
  String get doseNotGiven;

  /// No description provided for @doseGivenAt.
  ///
  /// In en, this message translates to:
  /// **'Given at {time}'**
  String doseGivenAt(String time);

  /// No description provided for @doseUndoHint.
  ///
  /// In en, this message translates to:
  /// **'Tap again to undo'**
  String get doseUndoHint;

  /// No description provided for @doseAllDone.
  ///
  /// In en, this message translates to:
  /// **'All given'**
  String get doseAllDone;

  /// No description provided for @doseProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} given'**
  String doseProgress(String done, String total);

  /// No description provided for @doseSemanticsGiven.
  ///
  /// In en, this message translates to:
  /// **'{medicine}, given. Double tap to undo.'**
  String doseSemanticsGiven(String medicine);

  /// No description provided for @doseSemanticsNotGiven.
  ///
  /// In en, this message translates to:
  /// **'{medicine}, not given yet. Double tap to mark as given.'**
  String doseSemanticsNotGiven(String medicine);

  /// No description provided for @noMedicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'No medicines added yet'**
  String get noMedicinesTitle;

  /// No description provided for @noMedicinesBody.
  ///
  /// In en, this message translates to:
  /// **'Add his medicines to get a daily checklist.'**
  String get noMedicinesBody;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add medicine'**
  String get addMedicine;

  /// No description provided for @slotMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get slotMorning;

  /// No description provided for @slotNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get slotNight;

  /// No description provided for @medicinesListTitle.
  ///
  /// In en, this message translates to:
  /// **'His medicines'**
  String get medicinesListTitle;

  /// No description provided for @medicineNoTime.
  ///
  /// In en, this message translates to:
  /// **'No time chosen'**
  String get medicineNoTime;

  /// No description provided for @adherenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Last 14 days'**
  String get adherenceTitle;

  /// No description provided for @adherenceIntro.
  ///
  /// In en, this message translates to:
  /// **'How many medicines were marked as given each day.'**
  String get adherenceIntro;

  /// No description provided for @adherenceToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get adherenceToday;

  /// No description provided for @adherenceMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning: {taken} of {expected}'**
  String adherenceMorning(String taken, String expected);

  /// No description provided for @adherenceNight.
  ///
  /// In en, this message translates to:
  /// **'Night: {taken} of {expected}'**
  String adherenceNight(String taken, String expected);

  /// No description provided for @adherenceNone.
  ///
  /// In en, this message translates to:
  /// **'No medicines due'**
  String get adherenceNone;

  /// No description provided for @adherenceAll.
  ///
  /// In en, this message translates to:
  /// **'All given'**
  String get adherenceAll;

  /// No description provided for @adherenceSome.
  ///
  /// In en, this message translates to:
  /// **'Some not marked'**
  String get adherenceSome;

  /// No description provided for @adherenceMissed.
  ///
  /// In en, this message translates to:
  /// **'None marked'**
  String get adherenceMissed;

  /// No description provided for @adherenceEmpty.
  ///
  /// In en, this message translates to:
  /// **'History will appear here after you add medicines.'**
  String get adherenceEmpty;

  /// No description provided for @medicineFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add medicine'**
  String get medicineFormAddTitle;

  /// No description provided for @medicineFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit medicine'**
  String get medicineFormEditTitle;

  /// No description provided for @medicineNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicine name'**
  String get medicineNameLabel;

  /// No description provided for @medicineNameHint.
  ///
  /// In en, this message translates to:
  /// **'Type it as written on the packet'**
  String get medicineNameHint;

  /// No description provided for @medicineNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get medicineNotesLabel;

  /// No description provided for @medicineNotesHint.
  ///
  /// In en, this message translates to:
  /// **'For example: after food'**
  String get medicineNotesHint;

  /// No description provided for @medicineWhenTitle.
  ///
  /// In en, this message translates to:
  /// **'When is it given?'**
  String get medicineWhenTitle;

  /// No description provided for @medicineRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from list'**
  String get medicineRemove;

  /// No description provided for @medicineRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the list?'**
  String medicineRemoveTitle(String name);

  /// No description provided for @medicineRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'This only removes it from this app\'s daily list. It does not change his medicine. Ask his doctor about any medicine change. Past records are kept.'**
  String get medicineRemoveBody;

  /// No description provided for @keepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get keepIt;

  /// No description provided for @removeIt.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeIt;

  /// No description provided for @errorNeedSlot.
  ///
  /// In en, this message translates to:
  /// **'Choose morning, night, or both.'**
  String get errorNeedSlot;

  /// No description provided for @errorNeedMedicineName.
  ///
  /// In en, this message translates to:
  /// **'Please type the medicine name.'**
  String get errorNeedMedicineName;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileHubIntro.
  ///
  /// In en, this message translates to:
  /// **'Everything about {name}. Tap a line to change it.'**
  String profileHubIntro(String name);

  /// No description provided for @stepAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About him'**
  String get stepAboutTitle;

  /// No description provided for @stepConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Health conditions'**
  String get stepConditionsTitle;

  /// No description provided for @stepFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Food and allergies'**
  String get stepFoodTitle;

  /// No description provided for @stepMedicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get stepMedicinesTitle;

  /// No description provided for @stepRangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s numbers'**
  String get stepRangesTitle;

  /// No description provided for @stepContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts'**
  String get stepContactsTitle;

  /// No description provided for @summaryNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set yet'**
  String get summaryNotSet;

  /// No description provided for @summaryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} added'**
  String summaryCount(String count);

  /// No description provided for @summarySoftFood.
  ///
  /// In en, this message translates to:
  /// **'Soft food'**
  String get summarySoftFood;

  /// No description provided for @wizardSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up the profile'**
  String get wizardSetupTitle;

  /// No description provided for @wizardStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String wizardStepOf(String current, String total);

  /// No description provided for @wizardFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get wizardFinish;

  /// No description provided for @aboutNameLabel.
  ///
  /// In en, this message translates to:
  /// **'His name'**
  String get aboutNameLabel;

  /// No description provided for @aboutNameHint.
  ///
  /// In en, this message translates to:
  /// **'Type his first name'**
  String get aboutNameHint;

  /// No description provided for @aboutAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'His age (years)'**
  String get aboutAgeLabel;

  /// No description provided for @aboutNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get aboutNotesLabel;

  /// No description provided for @errorNeedHisName.
  ///
  /// In en, this message translates to:
  /// **'Please type his name.'**
  String get errorNeedHisName;

  /// No description provided for @errorAgeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please type an age between 1 and 120.'**
  String get errorAgeInvalid;

  /// No description provided for @conditionsIntro.
  ///
  /// In en, this message translates to:
  /// **'Which of these has his doctor told you about? You can change this any time.'**
  String get conditionsIntro;

  /// No description provided for @conditionDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes (blood sugar)'**
  String get conditionDiabetes;

  /// No description provided for @conditionHypertension.
  ///
  /// In en, this message translates to:
  /// **'High blood pressure'**
  String get conditionHypertension;

  /// No description provided for @conditionIncluded.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get conditionIncluded;

  /// No description provided for @conditionNotIncluded.
  ///
  /// In en, this message translates to:
  /// **'Not included'**
  String get conditionNotIncluded;

  /// No description provided for @foodIntro.
  ///
  /// In en, this message translates to:
  /// **'Tell us about allergies and chewing, so meal ideas suit him.'**
  String get foodIntro;

  /// No description provided for @allergiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Allergies or foods he cannot eat'**
  String get allergiesLabel;

  /// No description provided for @allergiesHint.
  ///
  /// In en, this message translates to:
  /// **'For example: peanuts, shellfish'**
  String get allergiesHint;

  /// No description provided for @softFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'He needs soft food'**
  String get softFoodTitle;

  /// No description provided for @softFoodHint.
  ///
  /// In en, this message translates to:
  /// **'Choose this if chewing is hard.'**
  String get softFoodHint;

  /// No description provided for @medicinesStepIntro.
  ///
  /// In en, this message translates to:
  /// **'Add each medicine and when it is given. Type them as written by his doctor.'**
  String get medicinesStepIntro;

  /// No description provided for @rangesIntro.
  ///
  /// In en, this message translates to:
  /// **'Type the numbers his doctor gave you. The app has no numbers of its own. If you leave them empty, the app will not judge any reading.'**
  String get rangesIntro;

  /// No description provided for @rangesNoConditions.
  ///
  /// In en, this message translates to:
  /// **'First choose a health condition (in \"Health conditions\"), then come back here.'**
  String get rangesNoConditions;

  /// No description provided for @rangeAllTimes.
  ///
  /// In en, this message translates to:
  /// **'All times'**
  String get rangeAllTimes;

  /// No description provided for @rangeSpecificTimes.
  ///
  /// In en, this message translates to:
  /// **'Different numbers for a certain time (optional)'**
  String get rangeSpecificTimes;

  /// No description provided for @rangeUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get rangeUnit;

  /// No description provided for @rangeUrgentLow.
  ///
  /// In en, this message translates to:
  /// **'Urgent if below'**
  String get rangeUrgentLow;

  /// No description provided for @rangeCautionLow.
  ///
  /// In en, this message translates to:
  /// **'Be careful if below'**
  String get rangeCautionLow;

  /// No description provided for @rangeCautionHigh.
  ///
  /// In en, this message translates to:
  /// **'Be careful if above'**
  String get rangeCautionHigh;

  /// No description provided for @rangeUrgentHigh.
  ///
  /// In en, this message translates to:
  /// **'Urgent if above'**
  String get rangeUrgentHigh;

  /// No description provided for @rangeDoctorPlan.
  ///
  /// In en, this message translates to:
  /// **'His doctor\'s plan (optional)'**
  String get rangeDoctorPlan;

  /// No description provided for @rangeDoctorPlanHint.
  ///
  /// In en, this message translates to:
  /// **'What his doctor said to do, in their words'**
  String get rangeDoctorPlanHint;

  /// No description provided for @rangeWarningSigns.
  ///
  /// In en, this message translates to:
  /// **'Warning signs to watch for (optional)'**
  String get rangeWarningSigns;

  /// No description provided for @rangeWarningSignsHint.
  ///
  /// In en, this message translates to:
  /// **'As told by his doctor'**
  String get rangeWarningSignsHint;

  /// No description provided for @rangeFilled.
  ///
  /// In en, this message translates to:
  /// **'Numbers entered'**
  String get rangeFilled;

  /// No description provided for @rangeNotEntered.
  ///
  /// In en, this message translates to:
  /// **'Not entered yet'**
  String get rangeNotEntered;

  /// No description provided for @errorRangeOrder.
  ///
  /// In en, this message translates to:
  /// **'These numbers are not in order. Please check them against what his doctor wrote.'**
  String get errorRangeOrder;

  /// No description provided for @errorRangeImplausible.
  ///
  /// In en, this message translates to:
  /// **'This number looks wrong. Please check it.'**
  String get errorRangeImplausible;

  /// No description provided for @contactsIntro.
  ///
  /// In en, this message translates to:
  /// **'Add the people to call in an emergency. The app has no phone numbers of its own.'**
  String get contactsIntro;

  /// No description provided for @contactsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No contacts yet'**
  String get contactsEmpty;

  /// No description provided for @contactAdd.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get contactAdd;

  /// No description provided for @contactFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get contactFormAddTitle;

  /// No description provided for @contactFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit contact'**
  String get contactFormEditTitle;

  /// No description provided for @contactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get contactNameLabel;

  /// No description provided for @contactRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Who is this?'**
  String get contactRoleLabel;

  /// No description provided for @contactPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get contactPhoneLabel;

  /// No description provided for @roleDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get roleDoctor;

  /// No description provided for @roleHospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get roleHospital;

  /// No description provided for @roleAmbulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get roleAmbulance;

  /// No description provided for @roleFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get roleFamily;

  /// No description provided for @errorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please check the phone number.'**
  String get errorPhoneInvalid;

  /// No description provided for @contactDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete contact'**
  String get contactDelete;

  /// No description provided for @contactDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String contactDeleteTitle(String name);

  /// No description provided for @contactDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the contact from this phone.'**
  String get contactDeleteBody;

  /// No description provided for @keepContact.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get keepContact;

  /// No description provided for @deleteIt.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteIt;

  /// No description provided for @settingsProfileTile.
  ///
  /// In en, this message translates to:
  /// **'Profile and doctor\'s numbers'**
  String get settingsProfileTile;

  /// No description provided for @debugLoadDemo.
  ///
  /// In en, this message translates to:
  /// **'Load demo data (testing only)'**
  String get debugLoadDemo;

  /// No description provided for @debugDemoLoaded.
  ///
  /// In en, this message translates to:
  /// **'Demo data loaded'**
  String get debugDemoLoaded;

  /// No description provided for @timeAm.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get timeAm;

  /// No description provided for @timePm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get timePm;

  /// No description provided for @timeFormat.
  ///
  /// In en, this message translates to:
  /// **'{time} {period}'**
  String timeFormat(String time, String period);

  /// No description provided for @errorFixMarked.
  ///
  /// In en, this message translates to:
  /// **'Please fix the items marked with a warning sign.'**
  String get errorFixMarked;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ne'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'ne':
      return AppL10nNe();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
