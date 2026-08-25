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
  /// In vi, this message translates to:
  /// **'NHẠC THƯ GIÃN'**
  String get homeSoothingMelody;

  /// No description provided for @homeChooseMusic.
  ///
  /// In vi, this message translates to:
  /// **'Chọn bản nhạc bạn thích'**
  String get homeChooseMusic;

  /// No description provided for @homeActiveSession.
  ///
  /// In vi, this message translates to:
  /// **'ĐANG PHÁT'**
  String get homeActiveSession;

  /// No description provided for @homeOceanWaves.
  ///
  /// In vi, this message translates to:
  /// **'Sóng biển & Mưa rơi'**
  String get homeOceanWaves;

  /// No description provided for @homeRecordSleep.
  ///
  /// In vi, this message translates to:
  /// **'GHI NHẬN GIẤC NGỦ'**
  String get homeRecordSleep;

  /// No description provided for @homeEnterLastNightData.
  ///
  /// In vi, this message translates to:
  /// **'Nhập dữ liệu đêm qua'**
  String get homeEnterLastNightData;

  /// No description provided for @dailySurveyTitle.
  ///
  /// In vi, this message translates to:
  /// **'KHẢO SÁT HẰNG NGÀY'**
  String get dailySurveyTitle;

  /// No description provided for @dailySurveyGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng! Đêm qua bạn ngủ thế nào?'**
  String get dailySurveyGreeting;

  /// No description provided for @dailySurveyQ1.
  ///
  /// In vi, this message translates to:
  /// **'1. Đêm qua bạn lên giường lúc mấy giờ?'**
  String get dailySurveyQ1;

  /// No description provided for @dailySurveySelectTime.
  ///
  /// In vi, this message translates to:
  /// **'Chọn giờ'**
  String get dailySurveySelectTime;

  /// No description provided for @dailySurveyQ2.
  ///
  /// In vi, this message translates to:
  /// **'2. Bạn mất bao nhiêu phút để vào giấc ngủ?'**
  String get dailySurveyQ2;

  /// No description provided for @dailySurveyExample15.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: 15'**
  String get dailySurveyExample15;

  /// No description provided for @dailySurveyQ3.
  ///
  /// In vi, this message translates to:
  /// **'3. Sáng nay bạn thức dậy lúc mấy giờ?'**
  String get dailySurveyQ3;

  /// No description provided for @dailySurveyQ4.
  ///
  /// In vi, this message translates to:
  /// **'4. Số giờ bạn thực sự ngủ là bao nhiêu?'**
  String get dailySurveyQ4;

  /// No description provided for @dailySurveyExample75.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: 7.5'**
  String get dailySurveyExample75;

  /// No description provided for @dailySurveyQ5.
  ///
  /// In vi, this message translates to:
  /// **'5. Đêm qua bạn thức giấc mấy lần?'**
  String get dailySurveyQ5;

  /// No description provided for @dailySurveyExampleCount.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: 0, 1, 2...'**
  String get dailySurveyExampleCount;

  /// No description provided for @dailySurveyQ6.
  ///
  /// In vi, this message translates to:
  /// **'6. Bạn đánh giá chất lượng giấc ngủ của mình như thế nào?'**
  String get dailySurveyQ6;

  /// No description provided for @dailySurveyVeryGood.
  ///
  /// In vi, this message translates to:
  /// **'Rất tốt'**
  String get dailySurveyVeryGood;

  /// No description provided for @dailySurveyFairlyGood.
  ///
  /// In vi, this message translates to:
  /// **'Khá tốt'**
  String get dailySurveyFairlyGood;

  /// No description provided for @dailySurveyFairlyBad.
  ///
  /// In vi, this message translates to:
  /// **'Khá tệ'**
  String get dailySurveyFairlyBad;

  /// No description provided for @dailySurveyVeryBad.
  ///
  /// In vi, this message translates to:
  /// **'Rất tệ'**
  String get dailySurveyVeryBad;

  /// No description provided for @dailySurveySave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu kết quả'**
  String get dailySurveySave;

  /// No description provided for @dailySurveyErrorFillAll.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng điền đầy đủ các thông tin!'**
  String get dailySurveyErrorFillAll;

  /// No description provided for @dailySurveySuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu kết quả khảo sát thành công!'**
  String get dailySurveySuccess;

  /// No description provided for @dailySurveyErrorGeneric.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra, vui lòng thử lại!'**
  String get dailySurveyErrorGeneric;

  /// No description provided for @loginEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email người dùng'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu của bạn'**
  String get loginPasswordHint;

  /// No description provided for @loginButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập ->'**
  String get loginButton;

  /// No description provided for @loginOr.
  ///
  /// In vi, this message translates to:
  /// **'HOẶC'**
  String get loginOr;

  /// No description provided for @loginTerms.
  ///
  /// In vi, this message translates to:
  /// **'Bằng cách đăng nhập, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật của chúng tôi.'**
  String get loginTerms;

  /// No description provided for @loginForgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get loginForgotPassword;

  /// No description provided for @loginCreateAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản mới'**
  String get loginCreateAccount;

  /// No description provided for @loginWithGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng Google'**
  String get loginWithGoogle;

  /// No description provided for @q1SelectTime.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thời gian'**
  String get q1SelectTime;

  /// No description provided for @qStep1.
  ///
  /// In vi, this message translates to:
  /// **'STEP 1 OF 3 | Q1-Q4'**
  String get qStep1;

  /// No description provided for @qWelcome.
  ///
  /// In vi, this message translates to:
  /// **'Hi, welcome to\nSleepCare'**
  String get qWelcome;

  /// No description provided for @qIntro.
  ///
  /// In vi, this message translates to:
  /// **'Hãy cho chúng tôi biết về giấc ngủ của bạn\ntrong tháng vừa qua.'**
  String get qIntro;

  /// No description provided for @qQuestion1.
  ///
  /// In vi, this message translates to:
  /// **'CÂU HỎI 01'**
  String get qQuestion1;

  /// No description provided for @q1Desc.
  ///
  /// In vi, this message translates to:
  /// **'Trong tháng vừa rồi, bạn thường đi\nngủ vào ban đêm lúc mấy giờ?'**
  String get q1Desc;

  /// No description provided for @qQuestion2.
  ///
  /// In vi, this message translates to:
  /// **'CÂU HỎI 02'**
  String get qQuestion2;

  /// No description provided for @q2Desc.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi đêm bạn thường mất khoảng bao\nnhiêu phút để ngủ được?'**
  String get q2Desc;

  /// No description provided for @q2Hint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: 15'**
  String get q2Hint;

  /// No description provided for @qQuestion3.
  ///
  /// In vi, this message translates to:
  /// **'CÂU HỎI 03'**
  String get qQuestion3;

  /// No description provided for @q3Desc.
  ///
  /// In vi, this message translates to:
  /// **'Bạn thường thức dậy lúc mấy giờ?'**
  String get q3Desc;

  /// No description provided for @qQuestion4.
  ///
  /// In vi, this message translates to:
  /// **'CÂU HỎI 04'**
  String get qQuestion4;

  /// No description provided for @q4Desc.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi đêm bạn thường ngủ thực tế\nđược mấy tiếng?'**
  String get q4Desc;

  /// No description provided for @q4Hint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: 7.5'**
  String get q4Hint;

  /// No description provided for @qContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục ->'**
  String get qContinue;

  /// No description provided for @qErrorFillAll.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng trả lời đầy đủ các câu hỏi'**
  String get qErrorFillAll;

  /// No description provided for @qFreq0.
  ///
  /// In vi, this message translates to:
  /// **'Không'**
  String get qFreq0;

  /// No description provided for @qFreq1.
  ///
  /// In vi, this message translates to:
  /// **'<1 lần\n/tuần'**
  String get qFreq1;

  /// No description provided for @qFreq2.
  ///
  /// In vi, this message translates to:
  /// **'1-2 lần\n/tuần'**
  String get qFreq2;

  /// No description provided for @qFreq3.
  ///
  /// In vi, this message translates to:
  /// **'>=3 lần\n/tuần'**
  String get qFreq3;

  /// No description provided for @qStep2.
  ///
  /// In vi, this message translates to:
  /// **'STEP 2 OF 3 | Q5'**
  String get qStep2;

  /// No description provided for @qQuestion5.
  ///
  /// In vi, this message translates to:
  /// **'CÂU HỎI 05'**
  String get qQuestion5;

  /// No description provided for @q5Desc.
  ///
  /// In vi, this message translates to:
  /// **'Tần suất bạn gặp phải những hiện tượng gây khó ngủ trong tháng vừa qua?'**
  String get q5Desc;

  /// No description provided for @q5a.
  ///
  /// In vi, this message translates to:
  /// **'a. Sau 30 phút nhắm mắt vẫn không thể ngủ được'**
  String get q5a;

  /// No description provided for @q5b.
  ///
  /// In vi, this message translates to:
  /// **'b. Tỉnh dậy lúc nửa đêm hoặc sáng sớm'**
  String get q5b;

  /// No description provided for @q5c.
  ///
  /// In vi, this message translates to:
  /// **'c. Phải dậy để đi vệ sinh'**
  String get q5c;

  /// No description provided for @q5d.
  ///
  /// In vi, this message translates to:
  /// **'d. Không thể hít thở bình thường'**
  String get q5d;

  /// No description provided for @q5e.
  ///
  /// In vi, this message translates to:
  /// **'e. Ho hoặc ngáy lớn tiếng khi ngủ'**
  String get q5e;

  /// No description provided for @q5f.
  ///
  /// In vi, this message translates to:
  /// **'f. Cảm thấy quá lạnh nên không ngủ được'**
  String get q5f;

  /// No description provided for @q5g.
  ///
  /// In vi, this message translates to:
  /// **'g. Cảm thấy quá nóng nên không ngủ được'**
  String get q5g;

  /// No description provided for @q5h.
  ///
  /// In vi, this message translates to:
  /// **'h. Gặp ác mộng khó ngủ trở lại'**
  String get q5h;

  /// No description provided for @q5i.
  ///
  /// In vi, this message translates to:
  /// **'i. Bị đau nên không ngủ được'**
  String get q5i;

  /// No description provided for @q5jTitle.
  ///
  /// In vi, this message translates to:
  /// **'j. Lý do khác khiến bạn khó ngủ'**
  String get q5jTitle;

  /// No description provided for @q5jHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lý do của bạn...'**
  String get q5jHint;

  /// No description provided for @q5jFreq.
  ///
  /// In vi, this message translates to:
  /// **'Tần suất bạn mất ngủ vì lý do trên?'**
  String get q5jFreq;

  /// No description provided for @qStep3.
  ///
  /// In vi, this message translates to:
  /// **'STEP 3 OF 3 | Q6-Q10'**
  String get qStep3;

  /// No description provided for @q6Title.
  ///
  /// In vi, this message translates to:
  /// **'6. Trong tháng vừa qua, tần suất bạn uống thuốc giúp bạn ngủ?'**
  String get q6Title;

  /// No description provided for @q7Title.
  ///
  /// In vi, this message translates to:
  /// **'7. Trong tháng vừa qua, bạn có thường xuyên gặp khó khăn trong việc tỉnh táo khi lái xe, ăn uống hoặc tham gia vào các hoạt động xã hội không?'**
  String get q7Title;

  /// No description provided for @q8Title.
  ///
  /// In vi, this message translates to:
  /// **'8. Trong tháng qua, bạn đã gặp bao nhiêu vấn đề để duy trì đủ nhiệt huyết để hoàn thành công việc?'**
  String get q8Title;

  /// No description provided for @q8Opt0.
  ///
  /// In vi, this message translates to:
  /// **'Không có vấn đề gì cả'**
  String get q8Opt0;

  /// No description provided for @q8Opt1.
  ///
  /// In vi, this message translates to:
  /// **'Hơi có vấn đề'**
  String get q8Opt1;

  /// No description provided for @q8Opt2.
  ///
  /// In vi, this message translates to:
  /// **'Khá có vấn đề'**
  String get q8Opt2;

  /// No description provided for @q8Opt3.
  ///
  /// In vi, this message translates to:
  /// **'Rất có vấn đề'**
  String get q8Opt3;

  /// No description provided for @q9Title.
  ///
  /// In vi, this message translates to:
  /// **'9. Trong tháng qua, bạn đánh giá chất lượng giấc ngủ của mình như thế nào?'**
  String get q9Title;

  /// No description provided for @q10Title.
  ///
  /// In vi, this message translates to:
  /// **'10. Bạn có bạn giường hoặc phòng không?'**
  String get q10Title;

  /// No description provided for @qYes.
  ///
  /// In vi, this message translates to:
  /// **'Có'**
  String get qYes;

  /// No description provided for @qNo.
  ///
  /// In vi, this message translates to:
  /// **'Không'**
  String get qNo;

  /// No description provided for @q10SubTitle.
  ///
  /// In vi, this message translates to:
  /// **'10. Nếu bạn có bạn cùng phòng, họ có nhận thấy bạn:'**
  String get q10SubTitle;

  /// No description provided for @q10a.
  ///
  /// In vi, this message translates to:
  /// **'a. Ngáy to'**
  String get q10a;

  /// No description provided for @q10b.
  ///
  /// In vi, this message translates to:
  /// **'b. Ngưng thở một lúc khi ngủ'**
  String get q10b;

  /// No description provided for @q10c.
  ///
  /// In vi, this message translates to:
  /// **'c. Chân co giật khi ngủ'**
  String get q10c;

  /// No description provided for @q10d.
  ///
  /// In vi, this message translates to:
  /// **'d. Bị ngã khỏi giường'**
  String get q10d;

  /// No description provided for @q10eTitle.
  ///
  /// In vi, this message translates to:
  /// **'e. Tình trạng đặc biệt khác'**
  String get q10eTitle;

  /// No description provided for @q10eHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tình trạng khác...'**
  String get q10eHint;

  /// No description provided for @q10eFreq.
  ///
  /// In vi, this message translates to:
  /// **'Tần suất xuất hiện?'**
  String get q10eFreq;

  /// No description provided for @qFinish.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get qFinish;

  /// No description provided for @qErrorGeneric.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng trả lời tất cả câu hỏi hoặc có lỗi xảy ra!'**
  String get qErrorGeneric;

  /// No description provided for @qPsqiResult.
  ///
  /// In vi, this message translates to:
  /// **'Điểm chất lượng giấc ngủ (PSQI) của bạn: {score}'**
  String qPsqiResult(Object score);

  /// No description provided for @qPsqiBad.
  ///
  /// In vi, this message translates to:
  /// **'Giấc ngủ của bạn có vẻ kém, cần cải thiện!'**
  String get qPsqiBad;

  /// No description provided for @qPsqiGood.
  ///
  /// In vi, this message translates to:
  /// **'Giấc ngủ của bạn khá tốt!'**
  String get qPsqiGood;

  /// No description provided for @librarySearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm tần số, thiên nhiên, tâm trạng'**
  String get librarySearchHint;

  /// No description provided for @libraryPersonalized.
  ///
  /// In vi, this message translates to:
  /// **'CÁ NHÂN HÓA'**
  String get libraryPersonalized;

  /// No description provided for @libraryRecommended.
  ///
  /// In vi, this message translates to:
  /// **'Đề xuất cho bạn'**
  String get libraryRecommended;

  /// No description provided for @libraryNew.
  ///
  /// In vi, this message translates to:
  /// **'MỚI'**
  String get libraryNew;

  /// No description provided for @libraryAtmosphere.
  ///
  /// In vi, this message translates to:
  /// **'BẦU KHÔNG KHÍ 3D'**
  String get libraryAtmosphere;

  /// No description provided for @libraryNatureMusic.
  ///
  /// In vi, this message translates to:
  /// **'Nhạc Thiên Nhiên'**
  String get libraryNatureMusic;

  /// No description provided for @libraryViewAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get libraryViewAll;

  /// No description provided for @reportInsightsEngine.
  ///
  /// In vi, this message translates to:
  /// **'ĐỘNG CƠ PHÂN TÍCH'**
  String get reportInsightsEngine;

  /// No description provided for @reportSleepArchitecture.
  ///
  /// In vi, this message translates to:
  /// **'Cấu trúc\nGiấc ngủ của bạn'**
  String get reportSleepArchitecture;

  /// No description provided for @reportAvgDuration.
  ///
  /// In vi, this message translates to:
  /// **'Thời lượng trung bình'**
  String get reportAvgDuration;

  /// No description provided for @reportHours.
  ///
  /// In vi, this message translates to:
  /// **'giờ'**
  String get reportHours;

  /// No description provided for @reportMoreSleep.
  ///
  /// In vi, this message translates to:
  /// **'Ngủ nhiều hơn 12% so với tuần trước'**
  String get reportMoreSleep;

  /// No description provided for @reportPillowTalkTitle.
  ///
  /// In vi, this message translates to:
  /// **'CHUYỆN BÊN GỐI'**
  String get reportPillowTalkTitle;

  /// No description provided for @reportNightlyRhythms.
  ///
  /// In vi, this message translates to:
  /// **'Nhịp điệu hàng đêm'**
  String get reportNightlyRhythms;

  /// No description provided for @reportNightlyRhythmsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Độ trễ giấc ngủ của bạn đã cải thiện rõ rệt 15% trong các chu kỳ REM. Một số âm thanh trầm vào buổi tối có tác dụng tốt với bạn trong tháng qua.'**
  String get reportNightlyRhythmsDesc;

  /// No description provided for @reportPillowTalk.
  ///
  /// In vi, this message translates to:
  /// **'Chuyện bên gối'**
  String get reportPillowTalk;

  /// No description provided for @reportPillowTalkDesc.
  ///
  /// In vi, this message translates to:
  /// **'Sự nhất quán là chìa khóa. Giờ đi ngủ 10:30 tối của bạn đang trở thành thói quen bình thường cho cơ thể bạn.'**
  String get reportPillowTalkDesc;

  /// No description provided for @reportGeneratePdf.
  ///
  /// In vi, this message translates to:
  /// **'Tạo báo cáo PDF đầy đủ'**
  String get reportGeneratePdf;

  /// No description provided for @reportWeeklyConsistency.
  ///
  /// In vi, this message translates to:
  /// **'Độ ổn định hàng tuần'**
  String get reportWeeklyConsistency;

  /// No description provided for @dayMon.
  ///
  /// In vi, this message translates to:
  /// **'T2'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In vi, this message translates to:
  /// **'T3'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In vi, this message translates to:
  /// **'T4'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In vi, this message translates to:
  /// **'T5'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In vi, this message translates to:
  /// **'T6'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In vi, this message translates to:
  /// **'T7'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get daySun;

  /// No description provided for @reportSleepQualityIndex.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số chất lượng giấc ngủ'**
  String get reportSleepQualityIndex;

  /// No description provided for @reportWeekly.
  ///
  /// In vi, this message translates to:
  /// **'Hàng tuần'**
  String get reportWeekly;

  /// No description provided for @reportMonthly.
  ///
  /// In vi, this message translates to:
  /// **'Hàng tháng'**
  String get reportMonthly;

  /// No description provided for @reportNoData.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu'**
  String get reportNoData;

  /// No description provided for @week1.
  ///
  /// In vi, this message translates to:
  /// **'TUẦN 1'**
  String get week1;

  /// No description provided for @week2.
  ///
  /// In vi, this message translates to:
  /// **'TUẦN 2'**
  String get week2;

  /// No description provided for @week3.
  ///
  /// In vi, this message translates to:
  /// **'TUẦN 3'**
  String get week3;

  /// No description provided for @week4.
  ///
  /// In vi, this message translates to:
  /// **'TUẦN 4'**
  String get week4;

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'CÀI ĐẶT'**
  String get settingsTitle;

  /// No description provided for @settingsSleepHygiene.
  ///
  /// In vi, this message translates to:
  /// **'Vệ sinh giấc ngủ'**
  String get settingsSleepHygiene;

  /// No description provided for @settingsLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ / Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAutomation.
  ///
  /// In vi, this message translates to:
  /// **'Tự động hóa'**
  String get settingsAutomation;

  /// No description provided for @settingsOsFocus.
  ///
  /// In vi, this message translates to:
  /// **'Tự động gọi trong chế độ Tập trung'**
  String get settingsOsFocus;

  /// No description provided for @settingsOsFocusDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tắt tất cả thông báo khi hoạt động'**
  String get settingsOsFocusDesc;

  /// No description provided for @settingsMusicPlayback.
  ///
  /// In vi, this message translates to:
  /// **'Phát nhạc'**
  String get settingsMusicPlayback;

  /// No description provided for @settingsDuration.
  ///
  /// In vi, this message translates to:
  /// **'Thời lượng'**
  String get settingsDuration;

  /// No description provided for @settingsReminders.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở'**
  String get settingsReminders;

  /// No description provided for @settingsSleepPrep.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở chuẩn bị ngủ'**
  String get settingsSleepPrep;

  /// No description provided for @settingsSleepPrepDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở lúc 10:30 PM (30 phút \ntrước khi ngủ)'**
  String get settingsSleepPrepDesc;

  /// No description provided for @settingsSnooze.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng thời gian báo lại'**
  String get settingsSnooze;

  /// No description provided for @settingsAudioFidelity.
  ///
  /// In vi, this message translates to:
  /// **'Chất lượng âm thanh'**
  String get settingsAudioFidelity;

  /// No description provided for @settingsLossless.
  ///
  /// In vi, this message translates to:
  /// **'Phát nhạc Lossless'**
  String get settingsLossless;

  /// No description provided for @settingsLosslessDesc.
  ///
  /// In vi, this message translates to:
  /// **'Sử dụng pin nhiều hơn'**
  String get settingsLosslessDesc;

  /// No description provided for @settingsLogout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn đăng xuất khỏi SleepCare không?'**
  String get settingsLogoutConfirm;

  /// No description provided for @settingsNo.
  ///
  /// In vi, this message translates to:
  /// **'Không'**
  String get settingsNo;

  /// No description provided for @settingsYes.
  ///
  /// In vi, this message translates to:
  /// **'Có'**
  String get settingsYes;

  /// No description provided for @profileEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa Hồ Sơ'**
  String get profileEditTitle;

  /// No description provided for @profileSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get profileSave;

  /// No description provided for @profileFullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get profileFullName;

  /// No description provided for @profileFullNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Alex Moore'**
  String get profileFullNameHint;

  /// No description provided for @profileEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'alex.m@example.com'**
  String get profileEmailHint;

  /// No description provided for @profilePhone.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get profilePhone;

  /// No description provided for @profilePhoneHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập số điện thoại của bạn'**
  String get profilePhoneHint;

  /// No description provided for @profileGender.
  ///
  /// In vi, this message translates to:
  /// **'Giới tính'**
  String get profileGender;

  /// No description provided for @profileSelect.
  ///
  /// In vi, this message translates to:
  /// **'Chọn'**
  String get profileSelect;

  /// No description provided for @profileNotSelected.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chọn'**
  String get profileNotSelected;

  /// No description provided for @profileMale.
  ///
  /// In vi, this message translates to:
  /// **'Nam'**
  String get profileMale;

  /// No description provided for @profileFemale.
  ///
  /// In vi, this message translates to:
  /// **'Nữ'**
  String get profileFemale;

  /// No description provided for @profileDob.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh'**
  String get profileDob;

  /// No description provided for @profileSelectDate.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày'**
  String get profileSelectDate;

  /// No description provided for @profileSleepSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt giấc ngủ'**
  String get profileSleepSettings;

  /// No description provided for @profileSleepGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu giấc ngủ'**
  String get profileSleepGoal;

  /// No description provided for @profile8Hours.
  ///
  /// In vi, this message translates to:
  /// **'8.0 giờ'**
  String get profile8Hours;

  /// No description provided for @profileTarget.
  ///
  /// In vi, this message translates to:
  /// **'MỤC TIÊU'**
  String get profileTarget;

  /// No description provided for @profileChronotype.
  ///
  /// In vi, this message translates to:
  /// **'Kiểu ngủ'**
  String get profileChronotype;

  /// No description provided for @profileEarlyBird.
  ///
  /// In vi, this message translates to:
  /// **'Chào mào (Dậy sớm)'**
  String get profileEarlyBird;

  /// No description provided for @profileSecurity.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật'**
  String get profileSecurity;

  /// No description provided for @profileChangePassword.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get profileChangePassword;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật Profile thành công!'**
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
