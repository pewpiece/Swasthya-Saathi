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
