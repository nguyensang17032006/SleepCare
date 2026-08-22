import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('vi'),
  ];

  /// No description provided for @homeSoothingMelody.
  ///
  /// In en, this message translates to:
  /// **'SOOTHING MELODY SELECTION'**
  String get homeSoothingMelody;

  /// No description provided for @homeChooseMusic.
  ///
  /// In en, this message translates to:
  /// **'Choose music to your preference'**
  String get homeChooseMusic;

  /// No description provided for @homeActiveSession.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE SESSION'**
  String get homeActiveSession;

  /// No description provided for @homeOceanWaves.
  ///
  /// In en, this message translates to:
  /// **'Ocean Waves & Rain'**
  String get homeOceanWaves;

  /// No description provided for @homeRecordSleep.
  ///
  /// In en, this message translates to:
  /// **'RECORD SLEEP'**
  String get homeRecordSleep;

  /// No description provided for @homeEnterLastNightData.
  ///
  /// In en, this message translates to:
  /// **'Enter last night\'s data'**
  String get homeEnterLastNightData;

  /// No description provided for @dailySurveyTitle.
  ///
  /// In en, this message translates to:
  /// **'DAILY SURVEY'**
  String get dailySurveyTitle;

  /// No description provided for @dailySurveyGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good morning! How did you sleep last night?'**
  String get dailySurveyGreeting;

  /// No description provided for @dailySurveyQ1.
  ///
  /// In en, this message translates to:
  /// **'1. What time did you go to bed last night?'**
  String get dailySurveyQ1;

  /// No description provided for @dailySurveySelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get dailySurveySelectTime;

  /// No description provided for @dailySurveyQ2.
  ///
  /// In en, this message translates to:
  /// **'2. How many minutes did it take you to fall asleep?'**
  String get dailySurveyQ2;

  /// No description provided for @dailySurveyExample15.
  ///
  /// In en, this message translates to:
  /// **'Example: 15'**
  String get dailySurveyExample15;

  /// No description provided for @dailySurveyQ3.
  ///
  /// In en, this message translates to:
  /// **'3. What time did you wake up this morning?'**
  String get dailySurveyQ3;

  /// No description provided for @dailySurveyQ4.
  ///
  /// In en, this message translates to:
  /// **'4. How many hours of actual sleep did you get?'**
  String get dailySurveyQ4;

  /// No description provided for @dailySurveyExample75.
  ///
  /// In en, this message translates to:
  /// **'Example: 7.5'**
  String get dailySurveyExample75;

  /// No description provided for @dailySurveyQ5.
  ///
  /// In en, this message translates to:
  /// **'5. How many times did you wake up during the night?'**
  String get dailySurveyQ5;

  /// No description provided for @dailySurveyExampleCount.
  ///
  /// In en, this message translates to:
  /// **'Example: 0, 1, 2...'**
  String get dailySurveyExampleCount;

  /// No description provided for @dailySurveyQ6.
  ///
  /// In en, this message translates to:
  /// **'6. How would you rate your sleep quality?'**
  String get dailySurveyQ6;

  /// No description provided for @dailySurveyVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very good'**
  String get dailySurveyVeryGood;

  /// No description provided for @dailySurveyFairlyGood.
  ///
  /// In en, this message translates to:
  /// **'Fairly good'**
  String get dailySurveyFairlyGood;

  /// No description provided for @dailySurveyFairlyBad.
  ///
  /// In en, this message translates to:
  /// **'Fairly bad'**
  String get dailySurveyFairlyBad;

  /// No description provided for @dailySurveyVeryBad.
  ///
  /// In en, this message translates to:
  /// **'Very bad'**
  String get dailySurveyVeryBad;

  /// No description provided for @dailySurveySave.
  ///
  /// In en, this message translates to:
  /// **'Save results'**
  String get dailySurveySave;

  /// No description provided for @dailySurveyErrorFillAll.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all information!'**
  String get dailySurveyErrorFillAll;

  /// No description provided for @dailySurveySuccess.
  ///
  /// In en, this message translates to:
  /// **'Survey results saved successfully!'**
  String get dailySurveySuccess;

  /// No description provided for @dailySurveyErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again!'**
  String get dailySurveyErrorGeneric;

  /// No description provided for @loginUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get loginUsernameLabel;

  /// No description provided for @loginUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get loginUsernameHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login ->'**
  String get loginButton;

  /// No description provided for @loginOr.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get loginOr;

  /// No description provided for @loginTerms.
  ///
  /// In en, this message translates to:
  /// **'By logging in, you agree to our Terms of Service and Privacy Policy.'**
  String get loginTerms;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get loginCreateAccount;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get loginWithGoogle;

  /// No description provided for @q1SelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get q1SelectTime;

  /// No description provided for @qStep1.
  ///
  /// In en, this message translates to:
  /// **'STEP 1 OF 3 | Q1-Q4'**
  String get qStep1;

  /// No description provided for @qWelcome.
  ///
  /// In en, this message translates to:
  /// **'Hi, welcome to\nSleepCare'**
  String get qWelcome;

  /// No description provided for @qIntro.
  ///
  /// In en, this message translates to:
  /// **'Please tell us about your sleep\nduring the past month.'**
  String get qIntro;

  /// No description provided for @qQuestion1.
  ///
  /// In en, this message translates to:
  /// **'QUESTION 01'**
  String get qQuestion1;

  /// No description provided for @q1Desc.
  ///
  /// In en, this message translates to:
  /// **'During the past month, what time have you\nusually gone to bed at night?'**
  String get q1Desc;

  /// No description provided for @qQuestion2.
  ///
  /// In en, this message translates to:
  /// **'QUESTION 02'**
  String get qQuestion2;

  /// No description provided for @q2Desc.
  ///
  /// In en, this message translates to:
  /// **'How long (in minutes) has it usually taken\nyou to fall asleep each night?'**
  String get q2Desc;

  /// No description provided for @q2Hint.
  ///
  /// In en, this message translates to:
  /// **'Example: 15'**
  String get q2Hint;

  /// No description provided for @qQuestion3.
  ///
  /// In en, this message translates to:
  /// **'QUESTION 03'**
  String get qQuestion3;

  /// No description provided for @q3Desc.
  ///
  /// In en, this message translates to:
  /// **'What time have you usually gotten up in the morning?'**
  String get q3Desc;

  /// No description provided for @qQuestion4.
  ///
  /// In en, this message translates to:
  /// **'QUESTION 04'**
  String get qQuestion4;

  /// No description provided for @q4Desc.
  ///
  /// In en, this message translates to:
  /// **'How many hours of actual sleep did you\nget at night?'**
  String get q4Desc;

  /// No description provided for @q4Hint.
  ///
  /// In en, this message translates to:
  /// **'Example: 7.5'**
  String get q4Hint;

  /// No description provided for @qContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue ->'**
  String get qContinue;

  /// No description provided for @qErrorFillAll.
  ///
  /// In en, this message translates to:
  /// **'Please answer all questions'**
  String get qErrorFillAll;

  /// No description provided for @qFreq0.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get qFreq0;

  /// No description provided for @qFreq1.
  ///
  /// In en, this message translates to:
  /// **'<1 time\n/week'**
  String get qFreq1;

  /// No description provided for @qFreq2.
  ///
  /// In en, this message translates to:
  /// **'1-2 times\n/week'**
  String get qFreq2;

  /// No description provided for @qFreq3.
  ///
  /// In en, this message translates to:
  /// **'>=3 times\n/week'**
  String get qFreq3;

  /// No description provided for @qStep2.
  ///
  /// In en, this message translates to:
  /// **'STEP 2 OF 3 | Q5'**
  String get qStep2;

  /// No description provided for @qQuestion5.
  ///
  /// In en, this message translates to:
  /// **'QUESTION 05'**
  String get qQuestion5;

  /// No description provided for @q5Desc.
  ///
  /// In en, this message translates to:
  /// **'During the past month, how often have you had trouble sleeping because you...'**
  String get q5Desc;

  /// No description provided for @q5a.
  ///
  /// In en, this message translates to:
  /// **'a. Cannot get to sleep within 30 minutes'**
  String get q5a;

  /// No description provided for @q5b.
  ///
  /// In en, this message translates to:
  /// **'b. Wake up in the middle of the night or early morning'**
  String get q5b;

  /// No description provided for @q5c.
  ///
  /// In en, this message translates to:
  /// **'c. Have to get up to use the bathroom'**
  String get q5c;

  /// No description provided for @q5d.
  ///
  /// In en, this message translates to:
  /// **'d. Cannot breathe comfortably'**
  String get q5d;

  /// No description provided for @q5e.
  ///
  /// In en, this message translates to:
  /// **'e. Cough or snore loudly'**
  String get q5e;

  /// No description provided for @q5f.
  ///
  /// In en, this message translates to:
  /// **'f. Feel too cold'**
  String get q5f;

  /// No description provided for @q5g.
  ///
  /// In en, this message translates to:
  /// **'g. Feel too hot'**
  String get q5g;

  /// No description provided for @q5h.
  ///
  /// In en, this message translates to:
  /// **'h. Had bad dreams'**
  String get q5h;

  /// No description provided for @q5i.
  ///
  /// In en, this message translates to:
  /// **'i. Have pain'**
  String get q5i;

  /// No description provided for @q5jTitle.
  ///
  /// In en, this message translates to:
  /// **'j. Other reason(s)'**
  String get q5jTitle;

  /// No description provided for @q5jHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your reason...'**
  String get q5jHint;

  /// No description provided for @q5jFreq.
  ///
  /// In en, this message translates to:
  /// **'How often?'**
  String get q5jFreq;

  /// No description provided for @qStep3.
  ///
  /// In en, this message translates to:
  /// **'STEP 3 OF 3 | Q6-Q10'**
  String get qStep3;

  /// No description provided for @q6Title.
  ///
  /// In en, this message translates to:
  /// **'6. During the past month, how often have you taken medicine to help you sleep?'**
  String get q6Title;

  /// No description provided for @q7Title.
  ///
  /// In en, this message translates to:
  /// **'7. During the past month, how often have you had trouble staying awake while driving, eating meals, or engaging in social activity?'**
  String get q7Title;

  /// No description provided for @q8Title.
  ///
  /// In en, this message translates to:
  /// **'8. During the past month, how much of a problem has it been for you to keep up enough enthusiasm to get things done?'**
  String get q8Title;

  /// No description provided for @q8Opt0.
  ///
  /// In en, this message translates to:
  /// **'No problem at all'**
  String get q8Opt0;

  /// No description provided for @q8Opt1.
  ///
  /// In en, this message translates to:
  /// **'Only a very slight problem'**
  String get q8Opt1;

  /// No description provided for @q8Opt2.
  ///
  /// In en, this message translates to:
  /// **'Somewhat of a problem'**
  String get q8Opt2;

  /// No description provided for @q8Opt3.
  ///
  /// In en, this message translates to:
  /// **'A very big problem'**
  String get q8Opt3;

  /// No description provided for @q9Title.
  ///
  /// In en, this message translates to:
  /// **'9. During the past month, how would you rate your sleep quality overall?'**
  String get q9Title;

  /// No description provided for @q10Title.
  ///
  /// In en, this message translates to:
  /// **'10. Do you have a bed partner or roommate?'**
  String get q10Title;

  /// No description provided for @qYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get qYes;

  /// No description provided for @qNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get qNo;

  /// No description provided for @q10SubTitle.
  ///
  /// In en, this message translates to:
  /// **'10. If you have a roommate or bed partner, ask him/her how often in the past month you have had...'**
  String get q10SubTitle;

  /// No description provided for @q10a.
  ///
  /// In en, this message translates to:
  /// **'a. Loud snoring'**
  String get q10a;

  /// No description provided for @q10b.
  ///
  /// In en, this message translates to:
  /// **'b. Long pauses between breaths while asleep'**
  String get q10b;

  /// No description provided for @q10c.
  ///
  /// In en, this message translates to:
  /// **'c. Legs twitching or jerking while you sleep'**
  String get q10c;

  /// No description provided for @q10d.
  ///
  /// In en, this message translates to:
  /// **'d. Episodes of disorientation or confusion during sleep'**
  String get q10d;

  /// No description provided for @q10eTitle.
  ///
  /// In en, this message translates to:
  /// **'e. Other restlessness while you sleep'**
  String get q10eTitle;

  /// No description provided for @q10eHint.
  ///
  /// In en, this message translates to:
  /// **'Enter other conditions...'**
  String get q10eHint;

  /// No description provided for @q10eFreq.
  ///
  /// In en, this message translates to:
  /// **'How often?'**
  String get q10eFreq;

  /// No description provided for @qFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get qFinish;

  /// No description provided for @qErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Please answer all questions or an error occurred!'**
  String get qErrorGeneric;

  /// No description provided for @qPsqiResult.
  ///
  /// In en, this message translates to:
  /// **'Your PSQI Score: {score}'**
  String qPsqiResult(int score);

  /// No description provided for @qPsqiBad.
  ///
  /// In en, this message translates to:
  /// **'Your sleep quality seems poor, needs improvement!'**
  String get qPsqiBad;

  /// No description provided for @qPsqiGood.
  ///
  /// In en, this message translates to:
  /// **'Your sleep quality is fairly good!'**
  String get qPsqiGood;

  /// No description provided for @librarySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search frequencies, nature, or moods'**
  String get librarySearchHint;

  /// No description provided for @libraryPersonalized.
  ///
  /// In en, this message translates to:
  /// **'PERSONALIZED'**
  String get libraryPersonalized;

  /// No description provided for @libraryRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get libraryRecommended;

  /// No description provided for @libraryNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get libraryNew;

  /// No description provided for @libraryAtmosphere.
  ///
  /// In en, this message translates to:
  /// **'ATMOSPHERE 3D'**
  String get libraryAtmosphere;

  /// No description provided for @libraryNatureMusic.
  ///
  /// In en, this message translates to:
  /// **'Nature Music'**
  String get libraryNatureMusic;

  /// No description provided for @libraryViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get libraryViewAll;

  /// No description provided for @reportInsightsEngine.
  ///
  /// In en, this message translates to:
  /// **'INSIGHTS ENGINE'**
  String get reportInsightsEngine;

  /// No description provided for @reportSleepArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Your Sleep\nArchitecture'**
  String get reportSleepArchitecture;

  /// No description provided for @reportAvgDuration.
  ///
  /// In en, this message translates to:
  /// **'Average Duration'**
  String get reportAvgDuration;

  /// No description provided for @reportHours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get reportHours;

  /// No description provided for @reportMoreSleep.
  ///
  /// In en, this message translates to:
  /// **'12% more sleep than last week'**
  String get reportMoreSleep;

  /// No description provided for @reportPillowTalkTitle.
  ///
  /// In en, this message translates to:
  /// **'PILLOW TALK'**
  String get reportPillowTalkTitle;

  /// No description provided for @reportNightlyRhythms.
  ///
  /// In en, this message translates to:
  /// **'Nightly Rhythms'**
  String get reportNightlyRhythms;

  /// No description provided for @reportNightlyRhythmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Your sleep latency was noticeably improved by 15% during REM cycles. Some evening deep tones worked well for you last month.'**
  String get reportNightlyRhythmsDesc;

  /// No description provided for @reportPillowTalk.
  ///
  /// In en, this message translates to:
  /// **'Pillow Talk'**
  String get reportPillowTalk;

  /// No description provided for @reportPillowTalkDesc.
  ///
  /// In en, this message translates to:
  /// **'Consistency is key. Your 10:30 PM bed time is becoming a normal routine for your circadian body.'**
  String get reportPillowTalkDesc;

  /// No description provided for @reportGeneratePdf.
  ///
  /// In en, this message translates to:
  /// **'Generate Full PDF Report'**
  String get reportGeneratePdf;

  /// No description provided for @reportWeeklyConsistency.
  ///
  /// In en, this message translates to:
  /// **'Weekly Consistency'**
  String get reportWeeklyConsistency;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'MON'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'TUE'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'WED'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'THU'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'FRI'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'SAT'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'SUN'**
  String get daySun;

  /// No description provided for @reportSleepQualityIndex.
  ///
  /// In en, this message translates to:
  /// **'Sleep Quality Index'**
  String get reportSleepQualityIndex;

  /// No description provided for @reportWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get reportWeekly;

  /// No description provided for @reportMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get reportMonthly;

  /// No description provided for @reportNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get reportNoData;

  /// No description provided for @week1.
  ///
  /// In en, this message translates to:
  /// **'WEEK 1'**
  String get week1;

  /// No description provided for @week2.
  ///
  /// In en, this message translates to:
  /// **'WEEK 2'**
  String get week2;

  /// No description provided for @week3.
  ///
  /// In en, this message translates to:
  /// **'WEEK 3'**
  String get week3;

  /// No description provided for @week4.
  ///
  /// In en, this message translates to:
  /// **'WEEK 4'**
  String get week4;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// No description provided for @settingsSleepHygiene.
  ///
  /// In en, this message translates to:
  /// **'Sleep Hygiene'**
  String get settingsSleepHygiene;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Ngôn ngữ / Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAutomation.
  ///
  /// In en, this message translates to:
  /// **'Automation'**
  String get settingsAutomation;

  /// No description provided for @settingsOsFocus.
  ///
  /// In en, this message translates to:
  /// **'Autocall in OS Focus'**
  String get settingsOsFocus;

  /// No description provided for @settingsOsFocusDesc.
  ///
  /// In en, this message translates to:
  /// **'Mutes all notifications when active'**
  String get settingsOsFocusDesc;

  /// No description provided for @settingsMusicPlayback.
  ///
  /// In en, this message translates to:
  /// **'Music Playback'**
  String get settingsMusicPlayback;

  /// No description provided for @settingsDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get settingsDuration;

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsReminders;

  /// No description provided for @settingsSleepPrep.
  ///
  /// In en, this message translates to:
  /// **'Sleep Prep Reminder'**
  String get settingsSleepPrep;

  /// No description provided for @settingsSleepPrepDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminds at 10:30 PM (30 min \nbefore sleep)'**
  String get settingsSleepPrepDesc;

  /// No description provided for @settingsSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze Intervals'**
  String get settingsSnooze;

  /// No description provided for @settingsAudioFidelity.
  ///
  /// In en, this message translates to:
  /// **'Audio Fidelity'**
  String get settingsAudioFidelity;

  /// No description provided for @settingsLossless.
  ///
  /// In en, this message translates to:
  /// **'Lossless Playback'**
  String get settingsLossless;

  /// No description provided for @settingsLosslessDesc.
  ///
  /// In en, this message translates to:
  /// **'Higher battery usage'**
  String get settingsLosslessDesc;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of SleepCare?'**
  String get settingsLogoutConfirm;

  /// No description provided for @settingsNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get settingsNo;

  /// No description provided for @settingsYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get settingsYes;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditTitle;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileFullName;

  /// No description provided for @profileFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Alex Moore'**
  String get profileFullNameHint;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileEmailHint.
  ///
  /// In en, this message translates to:
  /// **'alex.m@example.com'**
  String get profileEmailHint;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profilePhone;

  /// No description provided for @profilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get profilePhoneHint;

  /// No description provided for @profileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGender;

  /// No description provided for @profileSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get profileSelect;

  /// No description provided for @profileNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get profileNotSelected;

  /// No description provided for @profileMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get profileMale;

  /// No description provided for @profileFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get profileFemale;

  /// No description provided for @profileDob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get profileDob;

  /// No description provided for @profileSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get profileSelectDate;

  /// No description provided for @profileSleepSettings.
  ///
  /// In en, this message translates to:
  /// **'Sleep Settings'**
  String get profileSleepSettings;

  /// No description provided for @profileSleepGoal.
  ///
  /// In en, this message translates to:
  /// **'Sleep Goal'**
  String get profileSleepGoal;

  /// No description provided for @profile8Hours.
  ///
  /// In en, this message translates to:
  /// **'8.0 hours'**
  String get profile8Hours;

  /// No description provided for @profileTarget.
  ///
  /// In en, this message translates to:
  /// **'TARGET'**
  String get profileTarget;

  /// No description provided for @profileChronotype.
  ///
  /// In en, this message translates to:
  /// **'Chronotype'**
  String get profileChronotype;

  /// No description provided for @profileEarlyBird.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get profileEarlyBird;

  /// No description provided for @profileSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSecurity;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profileChangePassword;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdateSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
