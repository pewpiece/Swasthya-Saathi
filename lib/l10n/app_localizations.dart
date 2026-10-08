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

  /// No description provided for @gTipSitSlowly.
  ///
  /// In en, this message translates to:
  /// **'Let him sit comfortably and eat slowly.'**
  String get gTipSitSlowly;

  /// No description provided for @gTipRegularMeals.
  ///
  /// In en, this message translates to:
  /// **'Keep meal times regular. Do not skip meals.'**
  String get gTipRegularMeals;

  /// No description provided for @gTipFluids.
  ///
  /// In en, this message translates to:
  /// **'Offer water through the day, unless his doctor has limited fluids.'**
  String get gTipFluids;

  /// No description provided for @gTipWalk.
  ///
  /// In en, this message translates to:
  /// **'A gentle walk may be good, if his doctor allows it.'**
  String get gTipWalk;

  /// No description provided for @gMealSteamedVeg.
  ///
  /// In en, this message translates to:
  /// **'Steamed or boiled vegetables'**
  String get gMealSteamedVeg;

  /// No description provided for @gMealCurd.
  ///
  /// In en, this message translates to:
  /// **'A small bowl of curd'**
  String get gMealCurd;

  /// No description provided for @gMealEgg.
  ///
  /// In en, this message translates to:
  /// **'A boiled egg'**
  String get gMealEgg;

  /// No description provided for @gMealSoftDalBhat.
  ///
  /// In en, this message translates to:
  /// **'Soft, well-cooked dal-bhat with vegetables'**
  String get gMealSoftDalBhat;

  /// No description provided for @gMealGreensSoup.
  ///
  /// In en, this message translates to:
  /// **'Gundruk or sisnu soup, cooked with little salt'**
  String get gMealGreensSoup;

  /// No description provided for @gMealKhichadi.
  ///
  /// In en, this message translates to:
  /// **'Soft khichadi with vegetables'**
  String get gMealKhichadi;

  /// No description provided for @gEasyFried.
  ///
  /// In en, this message translates to:
  /// **'Deep-fried foods, such as pakoda or puri'**
  String get gEasyFried;

  /// No description provided for @gMealDalBhatMoreVeg.
  ///
  /// In en, this message translates to:
  /// **'Dal-bhat with more tarkari and a smaller helping of rice'**
  String get gMealDalBhatMoreVeg;

  /// No description provided for @gMealRotiDhido.
  ///
  /// In en, this message translates to:
  /// **'Roti or dhido, in a moderate portion'**
  String get gMealRotiDhido;

  /// No description provided for @gEasySugarChiya.
  ///
  /// In en, this message translates to:
  /// **'Sugar in chiya'**
  String get gEasySugarChiya;

  /// No description provided for @gEasySweets.
  ///
  /// In en, this message translates to:
  /// **'Sweets, especially around Dashain and Tihar'**
  String get gEasySweets;

  /// No description provided for @gEasySalt.
  ///
  /// In en, this message translates to:
  /// **'Extra salt added at the table'**
  String get gEasySalt;

  /// No description provided for @gEasyAchar.
  ///
  /// In en, this message translates to:
  /// **'Achar (pickles)'**
  String get gEasyAchar;

  /// No description provided for @gEasyNoodles.
  ///
  /// In en, this message translates to:
  /// **'Instant noodles and packaged snacks'**
  String get gEasyNoodles;

  /// No description provided for @addReading.
  ///
  /// In en, this message translates to:
  /// **'Add reading'**
  String get addReading;

  /// No description provided for @addReadingChoose.
  ///
  /// In en, this message translates to:
  /// **'What did you measure?'**
  String get addReadingChoose;

  /// No description provided for @kindBloodSugar.
  ///
  /// In en, this message translates to:
  /// **'Blood sugar'**
  String get kindBloodSugar;

  /// No description provided for @kindBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure'**
  String get kindBloodPressure;

  /// No description provided for @addReadingNeedCondition.
  ///
  /// In en, this message translates to:
  /// **'Choose a health condition in the profile first, then you can add readings.'**
  String get addReadingNeedCondition;

  /// No description provided for @readingFormSugarTitle.
  ///
  /// In en, this message translates to:
  /// **'New blood sugar reading'**
  String get readingFormSugarTitle;

  /// No description provided for @readingFormBpTitle.
  ///
  /// In en, this message translates to:
  /// **'New blood pressure reading'**
  String get readingFormBpTitle;

  /// No description provided for @readingSugarLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood sugar number'**
  String get readingSugarLabel;

  /// No description provided for @bpTopLabel.
  ///
  /// In en, this message translates to:
  /// **'Top number (systolic)'**
  String get bpTopLabel;

  /// No description provided for @bpBottomLabel.
  ///
  /// In en, this message translates to:
  /// **'Bottom number (diastolic)'**
  String get bpBottomLabel;

  /// No description provided for @bpPulseLabel.
  ///
  /// In en, this message translates to:
  /// **'Pulse (optional)'**
  String get bpPulseLabel;

  /// No description provided for @readingWhenTitle.
  ///
  /// In en, this message translates to:
  /// **'When was it measured?'**
  String get readingWhenTitle;

  /// No description provided for @readingUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get readingUnitTitle;

  /// No description provided for @readingNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get readingNoteLabel;

  /// No description provided for @readingSave.
  ///
  /// In en, this message translates to:
  /// **'Save reading'**
  String get readingSave;

  /// No description provided for @errorReadingNumber.
  ///
  /// In en, this message translates to:
  /// **'Please type the number shown on the meter.'**
  String get errorReadingNumber;

  /// No description provided for @errorReadingImplausible.
  ///
  /// In en, this message translates to:
  /// **'This number looks wrong. Please check the meter and type it again.'**
  String get errorReadingImplausible;

  /// No description provided for @errorBpOrder.
  ///
  /// In en, this message translates to:
  /// **'The top number should be larger than the bottom number. Please check.'**
  String get errorBpOrder;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// No description provided for @tierInRange.
  ///
  /// In en, this message translates to:
  /// **'Within his doctor\'s range'**
  String get tierInRange;

  /// No description provided for @tierOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Outside his doctor\'s range'**
  String get tierOutOfRange;

  /// No description provided for @tierUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get tierUrgent;

  /// No description provided for @tierUnknown.
  ///
  /// In en, this message translates to:
  /// **'No range to compare with'**
  String get tierUnknown;

  /// No description provided for @headlineInRange.
  ///
  /// In en, this message translates to:
  /// **'This reading is within the range his doctor gave.'**
  String get headlineInRange;

  /// No description provided for @headlineOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'This reading is outside the range his doctor gave. Be careful.'**
  String get headlineOutOfRange;

  /// No description provided for @headlineUrgent.
  ///
  /// In en, this message translates to:
  /// **'Contact his doctor or emergency services now'**
  String get headlineUrgent;

  /// No description provided for @headlineNoRanges.
  ///
  /// In en, this message translates to:
  /// **'Enter the doctor\'s ranges in the profile'**
  String get headlineNoRanges;

  /// No description provided for @noRangesBody.
  ///
  /// In en, this message translates to:
  /// **'Without the doctor\'s numbers the app cannot say if a reading is high or low, and it will not guess.'**
  String get noRangesBody;

  /// No description provided for @enterRangesButton.
  ///
  /// In en, this message translates to:
  /// **'Enter the doctor\'s ranges'**
  String get enterRangesButton;

  /// No description provided for @guidanceMeals.
  ///
  /// In en, this message translates to:
  /// **'Prefer'**
  String get guidanceMeals;

  /// No description provided for @guidanceGoEasyOn.
  ///
  /// In en, this message translates to:
  /// **'Go easy on'**
  String get guidanceGoEasyOn;

  /// No description provided for @guidanceTips.
  ///
  /// In en, this message translates to:
  /// **'Other tips'**
  String get guidanceTips;

  /// No description provided for @guidanceTellDoctor.
  ///
  /// In en, this message translates to:
  /// **'Tell his doctor about this reading.'**
  String get guidanceTellDoctor;

  /// No description provided for @guidanceDoctorPlan.
  ///
  /// In en, this message translates to:
  /// **'His doctor\'s plan'**
  String get guidanceDoctorPlan;

  /// No description provided for @guidanceDoctorPlanNote.
  ///
  /// In en, this message translates to:
  /// **'Written by the family from his doctor\'s words.'**
  String get guidanceDoctorPlanNote;

  /// No description provided for @guidanceWarningSigns.
  ///
  /// In en, this message translates to:
  /// **'Warning signs to watch for'**
  String get guidanceWarningSigns;

  /// No description provided for @guidanceNotAdvice.
  ///
  /// In en, this message translates to:
  /// **'This is general food guidance, not medical advice. Ask his doctor if unsure.'**
  String get guidanceNotAdvice;

  /// No description provided for @unreviewedLabel.
  ///
  /// In en, this message translates to:
  /// **'Not yet reviewed by a clinician'**
  String get unreviewedLabel;

  /// No description provided for @guidanceDone.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get guidanceDone;

  /// No description provided for @readingNotFound.
  ///
  /// In en, this message translates to:
  /// **'This reading could not be found.'**
  String get readingNotFound;

  /// No description provided for @readingValueLine.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit}'**
  String readingValueLine(String value, String unit);

  /// No description provided for @readingBpLine.
  ///
  /// In en, this message translates to:
  /// **'{top}/{bottom} mmHg'**
  String readingBpLine(String top, String bottom);

  /// No description provided for @readingPulseLine.
  ///
  /// In en, this message translates to:
  /// **'Pulse {pulse}'**
  String readingPulseLine(String pulse);

  /// No description provided for @urgentCall.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String urgentCall(String name);

  /// No description provided for @urgentNoContacts.
  ///
  /// In en, this message translates to:
  /// **'No emergency contacts are saved yet. Please call your local emergency number.'**
  String get urgentNoContacts;

  /// No description provided for @urgentAddContacts.
  ///
  /// In en, this message translates to:
  /// **'Add emergency contacts'**
  String get urgentAddContacts;

  /// No description provided for @errorCannotCall.
  ///
  /// In en, this message translates to:
  /// **'This phone could not start the call. Please dial {phone} by hand.'**
  String errorCannotCall(String phone);

  /// No description provided for @homeLatestReadings.
  ///
  /// In en, this message translates to:
  /// **'Latest readings'**
  String get homeLatestReadings;

  /// No description provided for @homeNoReadings.
  ///
  /// In en, this message translates to:
  /// **'No readings yet.'**
  String get homeNoReadings;

  /// No description provided for @homeGuidanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s guidance'**
  String get homeGuidanceTitle;

  /// No description provided for @homeSeeGuidance.
  ///
  /// In en, this message translates to:
  /// **'See meal ideas and tips'**
  String get homeSeeGuidance;

  /// No description provided for @homeDoctorReport.
  ///
  /// In en, this message translates to:
  /// **'Doctor report'**
  String get homeDoctorReport;

  /// No description provided for @readingMeasuredAt.
  ///
  /// In en, this message translates to:
  /// **'{date}, {time}'**
  String readingMeasuredAt(String date, String time);

  /// No description provided for @notifMedicineMorning.
  ///
  /// In en, this message translates to:
  /// **'Time to give {name} his morning medicine.'**
  String notifMedicineMorning(String name);

  /// No description provided for @notifMedicineNight.
  ///
  /// In en, this message translates to:
  /// **'Time to give {name} his night medicine.'**
  String notifMedicineNight(String name);

  /// No description provided for @notifMeasureWeekly.
  ///
  /// In en, this message translates to:
  /// **'Time to measure {name}\'s health again.'**
  String notifMeasureWeekly(String name);

  /// No description provided for @notifMeasureMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly check for {name}: time to measure again.'**
  String notifMeasureMonthly(String name);

  /// No description provided for @notifHydration.
  ///
  /// In en, this message translates to:
  /// **'A glass of water for {name}? Skip this if his doctor has limited fluids.'**
  String notifHydration(String name);

  /// No description provided for @notifCustom.
  ///
  /// In en, this message translates to:
  /// **'Reminder for {name}.'**
  String notifCustom(String name);

  /// No description provided for @notifTest.
  ///
  /// In en, this message translates to:
  /// **'This is a test reminder. Reminders work on this phone.'**
  String get notifTest;

  /// No description provided for @channelMedicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine reminders'**
  String get channelMedicineName;

  /// No description provided for @channelMedicineDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminds you to give his medicine'**
  String get channelMedicineDesc;

  /// No description provided for @channelChecksName.
  ///
  /// In en, this message translates to:
  /// **'Health check reminders'**
  String get channelChecksName;

  /// No description provided for @channelChecksDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminds you to measure again, and other reminders'**
  String get channelChecksDesc;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @remindersIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose when the phone should remind you. Tap a reminder to change it.'**
  String get remindersIntro;

  /// No description provided for @remindersAdd.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get remindersAdd;

  /// No description provided for @remindersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet.'**
  String get remindersEmpty;

  /// No description provided for @reminderOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get reminderOn;

  /// No description provided for @reminderOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get reminderOff;

  /// No description provided for @reminderIsOn.
  ///
  /// In en, this message translates to:
  /// **'Reminder is on'**
  String get reminderIsOn;

  /// No description provided for @reminderIsOff.
  ///
  /// In en, this message translates to:
  /// **'Reminder is off'**
  String get reminderIsOff;

  /// No description provided for @reminderNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {when}'**
  String reminderNext(String when);

  /// No description provided for @reminderTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get reminderTomorrow;

  /// No description provided for @reminderTimeAt.
  ///
  /// In en, this message translates to:
  /// **'{day}, {time}'**
  String reminderTimeAt(String day, String time);

  /// No description provided for @reminderTypeMedicineMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning medicine'**
  String get reminderTypeMedicineMorning;

  /// No description provided for @reminderTypeMedicineNight.
  ///
  /// In en, this message translates to:
  /// **'Night medicine'**
  String get reminderTypeMedicineNight;

  /// No description provided for @reminderTypeMeasureWeekly.
  ///
  /// In en, this message translates to:
  /// **'Measure again (every week)'**
  String get reminderTypeMeasureWeekly;

  /// No description provided for @reminderTypeMeasureMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly check'**
  String get reminderTypeMeasureMonthly;

  /// No description provided for @reminderTypeHydration.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get reminderTypeHydration;

  /// No description provided for @reminderTypeCustom.
  ///
  /// In en, this message translates to:
  /// **'My own reminder'**
  String get reminderTypeCustom;

  /// No description provided for @reminderRepeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get reminderRepeatDaily;

  /// No description provided for @reminderRepeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every {day}'**
  String reminderRepeatWeekly(String day);

  /// No description provided for @reminderRepeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of every month'**
  String reminderRepeatMonthly(String day);

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySun;

  /// No description provided for @reminderFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get reminderFormAddTitle;

  /// No description provided for @reminderFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Change reminder'**
  String get reminderFormEditTitle;

  /// No description provided for @reminderTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'What is it for?'**
  String get reminderTypeTitle;

  /// No description provided for @reminderTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'What time?'**
  String get reminderTimeTitle;

  /// No description provided for @reminderHourLabel.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get reminderHourLabel;

  /// No description provided for @reminderMinuteLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get reminderMinuteLabel;

  /// No description provided for @reminderMoreHours.
  ///
  /// In en, this message translates to:
  /// **'One hour later'**
  String get reminderMoreHours;

  /// No description provided for @reminderFewerHours.
  ///
  /// In en, this message translates to:
  /// **'One hour earlier'**
  String get reminderFewerHours;

  /// No description provided for @reminderMoreMinutes.
  ///
  /// In en, this message translates to:
  /// **'5 minutes later'**
  String get reminderMoreMinutes;

  /// No description provided for @reminderFewerMinutes.
  ///
  /// In en, this message translates to:
  /// **'5 minutes earlier'**
  String get reminderFewerMinutes;

  /// No description provided for @reminderMoreDays.
  ///
  /// In en, this message translates to:
  /// **'One day later'**
  String get reminderMoreDays;

  /// No description provided for @reminderFewerDays.
  ///
  /// In en, this message translates to:
  /// **'One day earlier'**
  String get reminderFewerDays;

  /// No description provided for @reminderLabelLabel.
  ///
  /// In en, this message translates to:
  /// **'Name of the reminder'**
  String get reminderLabelLabel;

  /// No description provided for @reminderLabelHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Eye drops'**
  String get reminderLabelHint;

  /// No description provided for @reminderWeekdayTitle.
  ///
  /// In en, this message translates to:
  /// **'Which day of the week?'**
  String get reminderWeekdayTitle;

  /// No description provided for @reminderMonthDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Which day of the month?'**
  String get reminderMonthDayTitle;

  /// No description provided for @reminderMonthDayValue.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String reminderMonthDayValue(String day);

  /// No description provided for @reminderDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete reminder'**
  String get reminderDelete;

  /// No description provided for @reminderDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this reminder?'**
  String get reminderDeleteTitle;

  /// No description provided for @reminderDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'It will stop reminding you. His medicines are not changed.'**
  String get reminderDeleteBody;

  /// No description provided for @errorReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Please type a name for your reminder.'**
  String get errorReminderLabel;

  /// No description provided for @permNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get permNotifTitle;

  /// No description provided for @permNotifBody.
  ///
  /// In en, this message translates to:
  /// **'Reminders cannot appear on this phone until you allow notifications.'**
  String get permNotifBody;

  /// No description provided for @permNotifHelp.
  ///
  /// In en, this message translates to:
  /// **'If nothing happens when you tap, open the phone\'s Settings, then Apps, then CareCompanion, then Notifications, and switch them on.'**
  String get permNotifHelp;

  /// No description provided for @permExactTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow exact times'**
  String get permExactTitle;

  /// No description provided for @permExactBody.
  ///
  /// In en, this message translates to:
  /// **'So reminders arrive at the right minute, allow “Alarms & reminders” for CareCompanion. Until then, reminders may come a few minutes late.'**
  String get permExactBody;

  /// No description provided for @permAllGood.
  ///
  /// In en, this message translates to:
  /// **'Reminders are on and will arrive on time.'**
  String get permAllGood;

  /// No description provided for @remindersCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Check that reminders work'**
  String get remindersCheckTitle;

  /// No description provided for @remindersTestNow.
  ///
  /// In en, this message translates to:
  /// **'Send a test reminder now'**
  String get remindersTestNow;

  /// No description provided for @remindersTestSoon.
  ///
  /// In en, this message translates to:
  /// **'Test reminder in 1 minute'**
  String get remindersTestSoon;

  /// No description provided for @remindersTestSent.
  ///
  /// In en, this message translates to:
  /// **'Test reminder sent. Look at the top of the screen.'**
  String get remindersTestSent;

  /// No description provided for @remindersTestScheduled.
  ///
  /// In en, this message translates to:
  /// **'Test reminder set for 1 minute from now. You can close the app.'**
  String get remindersTestScheduled;

  /// No description provided for @remindersTestNeedsPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications first.'**
  String get remindersTestNeedsPermission;

  /// No description provided for @remindersBatteryHint.
  ///
  /// In en, this message translates to:
  /// **'If reminders are late or missing, open the phone\'s Settings, then Battery, and allow CareCompanion to run in the background. Some phones call this “auto-start”.'**
  String get remindersBatteryHint;

  /// No description provided for @homeRemindersOff.
  ///
  /// In en, this message translates to:
  /// **'Reminders cannot appear on this phone yet.'**
  String get homeRemindersOff;

  /// No description provided for @homeRemindersSetup.
  ///
  /// In en, this message translates to:
  /// **'Set up reminders'**
  String get homeRemindersSetup;

  /// No description provided for @permNotifButton.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get permNotifButton;

  /// No description provided for @permExactButton.
  ///
  /// In en, this message translates to:
  /// **'Allow exact times'**
  String get permExactButton;

  /// No description provided for @settingsRemindersTile.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsRemindersTile;

  /// No description provided for @medicinesRemindersButton.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get medicinesRemindersButton;

  /// No description provided for @periodTitle.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get periodTitle;

  /// No description provided for @period2Weeks.
  ///
  /// In en, this message translates to:
  /// **'Last 2 weeks'**
  String get period2Weeks;

  /// No description provided for @period4Weeks.
  ///
  /// In en, this message translates to:
  /// **'Last 4 weeks'**
  String get period4Weeks;

  /// No description provided for @period3Months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get period3Months;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No readings yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a reading and it will appear here, with a chart.'**
  String get historyEmptyBody;

  /// No description provided for @historyNoneInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No readings in this time.'**
  String get historyNoneInPeriod;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get statsTitle;

  /// No description provided for @statsCount.
  ///
  /// In en, this message translates to:
  /// **'Readings: {count}'**
  String statsCount(String count);

  /// No description provided for @statsAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get statsAverage;

  /// No description provided for @statsLowest.
  ///
  /// In en, this message translates to:
  /// **'Lowest'**
  String get statsLowest;

  /// No description provided for @statsHighest.
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get statsHighest;

  /// No description provided for @statsLine.
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}'**
  String statsLine(String label, String value);

  /// No description provided for @chartTitle.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get chartTitle;

  /// No description provided for @chartBandLegend.
  ///
  /// In en, this message translates to:
  /// **'Shaded area: his doctor\'s range, {low} to {high} {unit}'**
  String chartBandLegend(String low, String high, String unit);

  /// No description provided for @chartBandNone.
  ///
  /// In en, this message translates to:
  /// **'No range from his doctor has been entered, so nothing is shaded.'**
  String get chartBandNone;

  /// No description provided for @chartUrgentLegend.
  ///
  /// In en, this message translates to:
  /// **'Dashed lines: the urgent limits his doctor gave'**
  String get chartUrgentLegend;

  /// No description provided for @chartTopLegend.
  ///
  /// In en, this message translates to:
  /// **'Top number: round dots, solid line'**
  String get chartTopLegend;

  /// No description provided for @chartBottomLegend.
  ///
  /// In en, this message translates to:
  /// **'Bottom number: square dots, dashed line'**
  String get chartBottomLegend;

  /// No description provided for @chartSummary.
  ///
  /// In en, this message translates to:
  /// **'Chart of {count} readings from {first} to {last}. Lowest {min}, highest {max}.'**
  String chartSummary(
    String count,
    String first,
    String last,
    String min,
    String max,
  );

  /// No description provided for @historyListTitle.
  ///
  /// In en, this message translates to:
  /// **'All readings in this time'**
  String get historyListTitle;

  /// No description provided for @readingDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete this reading'**
  String get readingDelete;

  /// No description provided for @readingDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this reading?'**
  String get readingDeleteTitle;

  /// No description provided for @readingDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from the history and from the doctor report. This cannot be undone.'**
  String get readingDeleteBody;

  /// No description provided for @reportIntro.
  ///
  /// In en, this message translates to:
  /// **'Make a PDF for his doctor: readings, averages, a chart and the medicines given.'**
  String get reportIntro;

  /// No description provided for @reportPeriodTitle.
  ///
  /// In en, this message translates to:
  /// **'How far back?'**
  String get reportPeriodTitle;

  /// No description provided for @reportContains.
  ///
  /// In en, this message translates to:
  /// **'The report will include {count} readings and {meds} medicines.'**
  String reportContains(String count, String meds);

  /// No description provided for @reportEnglishNote.
  ///
  /// In en, this message translates to:
  /// **'The report is written in English so any doctor can read it. His name and notes stay as you typed them.'**
  String get reportEnglishNote;

  /// No description provided for @reportShare.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get reportShare;

  /// No description provided for @reportPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview or print'**
  String get reportPreview;

  /// No description provided for @reportWorking.
  ///
  /// In en, this message translates to:
  /// **'Making the report...'**
  String get reportWorking;

  /// No description provided for @reportFailed.
  ///
  /// In en, this message translates to:
  /// **'The report could not be made. Please try again.'**
  String get reportFailed;

  /// No description provided for @reportPrivacy.
  ///
  /// In en, this message translates to:
  /// **'The PDF stays on this phone until you choose to share it.'**
  String get reportPrivacy;

  /// No description provided for @reportNeedProfile.
  ///
  /// In en, this message translates to:
  /// **'Add his name in the profile first.'**
  String get reportNeedProfile;

  /// No description provided for @pdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Health summary for {name}'**
  String pdfTitle(String name);

  /// No description provided for @pdfPeriodLine.
  ///
  /// In en, this message translates to:
  /// **'Period: {from} to {to}'**
  String pdfPeriodLine(String from, String to);

  /// No description provided for @pdfMadeOn.
  ///
  /// In en, this message translates to:
  /// **'Made on {date}'**
  String pdfMadeOn(String date);

  /// No description provided for @pdfAbout.
  ///
  /// In en, this message translates to:
  /// **'About him'**
  String get pdfAbout;

  /// No description provided for @pdfAge.
  ///
  /// In en, this message translates to:
  /// **'Age: about {age} years'**
  String pdfAge(String age);

  /// No description provided for @pdfConditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions followed in this app: {list}'**
  String pdfConditions(String list);

  /// No description provided for @pdfAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies / foods he cannot eat: {text}'**
  String pdfAllergies(String text);

  /// No description provided for @pdfSoftFood.
  ///
  /// In en, this message translates to:
  /// **'Needs soft food (chewing difficulty).'**
  String get pdfSoftFood;

  /// No description provided for @pdfNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes: {text}'**
  String pdfNotes(String text);

  /// No description provided for @pdfRangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Ranges from his doctor (typed in by the family)'**
  String get pdfRangesTitle;

  /// No description provided for @pdfRangesNone.
  ///
  /// In en, this message translates to:
  /// **'No ranges have been entered, so readings are not compared with anything.'**
  String get pdfRangesNone;

  /// No description provided for @pdfColMeasure.
  ///
  /// In en, this message translates to:
  /// **'Measure'**
  String get pdfColMeasure;

  /// No description provided for @pdfColTime.
  ///
  /// In en, this message translates to:
  /// **'Time of day'**
  String get pdfColTime;

  /// No description provided for @pdfColUrgentLow.
  ///
  /// In en, this message translates to:
  /// **'Urgent below'**
  String get pdfColUrgentLow;

  /// No description provided for @pdfColCautionLow.
  ///
  /// In en, this message translates to:
  /// **'Careful below'**
  String get pdfColCautionLow;

  /// No description provided for @pdfColCautionHigh.
  ///
  /// In en, this message translates to:
  /// **'Careful above'**
  String get pdfColCautionHigh;

  /// No description provided for @pdfColUrgentHigh.
  ///
  /// In en, this message translates to:
  /// **'Urgent above'**
  String get pdfColUrgentHigh;

  /// No description provided for @pdfAllTimes.
  ///
  /// In en, this message translates to:
  /// **'All times'**
  String get pdfAllTimes;

  /// No description provided for @pdfPlanLine.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s plan, as written by the family: {text}'**
  String pdfPlanLine(String text);

  /// No description provided for @pdfWarningLine.
  ///
  /// In en, this message translates to:
  /// **'Warning signs, as written by the family: {text}'**
  String pdfWarningLine(String text);

  /// No description provided for @pdfReadingsTitle.
  ///
  /// In en, this message translates to:
  /// **'{measure}: readings'**
  String pdfReadingsTitle(String measure);

  /// No description provided for @pdfUnitLine.
  ///
  /// In en, this message translates to:
  /// **'Chart and summary are shown in {unit}. The table shows each reading as it was typed in.'**
  String pdfUnitLine(String unit);

  /// No description provided for @pdfColDate.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get pdfColDate;

  /// No description provided for @pdfColValue.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get pdfColValue;

  /// No description provided for @pdfColWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get pdfColWhen;

  /// No description provided for @pdfColStatus.
  ///
  /// In en, this message translates to:
  /// **'Compared with doctor\'s range'**
  String get pdfColStatus;

  /// No description provided for @pdfColNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get pdfColNote;

  /// No description provided for @pdfStatusIn.
  ///
  /// In en, this message translates to:
  /// **'Within range'**
  String get pdfStatusIn;

  /// No description provided for @pdfStatusOut.
  ///
  /// In en, this message translates to:
  /// **'Outside range'**
  String get pdfStatusOut;

  /// No description provided for @pdfStatusUrgent.
  ///
  /// In en, this message translates to:
  /// **'In urgent range'**
  String get pdfStatusUrgent;

  /// No description provided for @pdfStatusNone.
  ///
  /// In en, this message translates to:
  /// **'No range entered'**
  String get pdfStatusNone;

  /// No description provided for @pdfNoReadings.
  ///
  /// In en, this message translates to:
  /// **'No readings in this period.'**
  String get pdfNoReadings;

  /// No description provided for @pdfStatsLine.
  ///
  /// In en, this message translates to:
  /// **'Readings: {count}. Average {avg}, lowest {min}, highest {max}.'**
  String pdfStatsLine(String count, String avg, String min, String max);

  /// No description provided for @pdfTopStats.
  ///
  /// In en, this message translates to:
  /// **'Top number: average {avg}, lowest {min}, highest {max}'**
  String pdfTopStats(String avg, String min, String max);

  /// No description provided for @pdfBottomStats.
  ///
  /// In en, this message translates to:
  /// **'Bottom number: average {avg}, lowest {min}, highest {max}'**
  String pdfBottomStats(String avg, String min, String max);

  /// No description provided for @pdfPulseStats.
  ///
  /// In en, this message translates to:
  /// **'Pulse: average {avg}, lowest {min}, highest {max}'**
  String pdfPulseStats(String avg, String min, String max);

  /// No description provided for @pdfChartBand.
  ///
  /// In en, this message translates to:
  /// **'Grey band: doctor\'s range {low} to {high}. Dashed lines: urgent limits.'**
  String pdfChartBand(String low, String high);

  /// No description provided for @pdfChartNoBand.
  ///
  /// In en, this message translates to:
  /// **'No doctor\'s range was entered, so no band is drawn.'**
  String get pdfChartNoBand;

  /// No description provided for @pdfMedicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicines and doses marked as given'**
  String get pdfMedicinesTitle;

  /// No description provided for @pdfMedsNone.
  ///
  /// In en, this message translates to:
  /// **'No medicines were listed in the app.'**
  String get pdfMedsNone;

  /// No description provided for @pdfMedColName.
  ///
  /// In en, this message translates to:
  /// **'Medicine (as typed by the family)'**
  String get pdfMedColName;

  /// No description provided for @pdfMedColTimes.
  ///
  /// In en, this message translates to:
  /// **'Given at'**
  String get pdfMedColTimes;

  /// No description provided for @pdfAdherenceLine.
  ///
  /// In en, this message translates to:
  /// **'{slot}: {taken} of {expected} doses marked as given ({percent}%)'**
  String pdfAdherenceLine(
    String slot,
    String taken,
    String expected,
    String percent,
  );

  /// No description provided for @pdfAdherenceNote.
  ///
  /// In en, this message translates to:
  /// **'A dose that is not marked may still have been given; the family may have forgotten to tick it.'**
  String get pdfAdherenceNote;

  /// No description provided for @pdfDayCol.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get pdfDayCol;

  /// No description provided for @pdfDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Made by the CareCompanion app from numbers typed in by the family. It is not medical advice and does not replace an examination by a doctor. The ranges are the family\'s copy of the doctor\'s instructions.'**
  String get pdfDisclaimer;

  /// No description provided for @pdfPage.
  ///
  /// In en, this message translates to:
  /// **'Page {n} of {total}'**
  String pdfPage(String n, String total);

  /// No description provided for @pdfBloodPressureUnit.
  ///
  /// In en, this message translates to:
  /// **'mmHg'**
  String get pdfBloodPressureUnit;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor report'**
  String get reportTitle;

  /// No description provided for @noteColumnFallback.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteColumnFallback;
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
