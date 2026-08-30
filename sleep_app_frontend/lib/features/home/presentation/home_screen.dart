import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sleep_app_frontend/l10n/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../data/services/location_service.dart';
import '../data/services/weather_api_service.dart';
import '../repository/weather_repository.dart';
import 'bloc/weather_cubit.dart';
import 'widget/time_circle.dart';
import 'widget/card_music.dart';
import 'widget/glass_card.dart';
import 'widget/weather_card.dart';
import '../../onboarding/daily_short_survey_screen.dart';
import '../../onboarding/questionnaire_screen.dart';
import '../../../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _psqiScore;
  bool _isLoadingPsqi = true;
  bool _shouldShowDailySurvey = true;
  bool _shouldShowMonthlySurvey = false;
  List<Map<String, dynamic>> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _fetchPsqiScore();
    _checkDailySurveyEligibility();
    _checkMonthlySurveyEligibility();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) return;

      final res = await supabaseClient
          .from('music_recommendations')
          .select(
            'recommendation_reason, tracks(id, title, description, cover_url)',
          )
          .eq('user_id', userId)
          .eq('status', 'shown')
          .order('recommendation_score', ascending: false)
          .limit(2);

      if (mounted) {
        setState(() {
          _recommendations = List<Map<String, dynamic>>.from(res);
        });
      }
    } catch (e) {
      debugPrint('Error fetching recommendations: $e');
    }
  }

  Future<void> _checkMonthlySurveyEligibility() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) return;

      final latestFullAssessment = await supabaseClient
          .from('sleep_assessments')
          .select('completed_at')
          .eq('user_id', userId)
          .inFilter('assessment_type', ['baseline_full', 'repeat_full'])
          .order('completed_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (latestFullAssessment != null &&
          latestFullAssessment['completed_at'] != null) {
        final DateTime completedAt = DateTime.parse(
          latestFullAssessment['completed_at'],
        ).toLocal();
        final int daysPassed = DateTime.now().difference(completedAt).inDays;

        if (daysPassed >= 30) {
          if (mounted) {
            setState(() {
              _shouldShowMonthlySurvey = true;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking monthly survey eligibility: $e');
    }
  }

  Future<void> _checkDailySurveyEligibility() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) return;

      final latestAssessment = await supabaseClient
          .from('sleep_assessments')
          .select('completed_at')
          .eq('user_id', userId)
          .order('completed_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (latestAssessment != null) {
        final String completedAtStr = latestAssessment['completed_at'];
        final DateTime completedAt = DateTime.parse(completedAtStr).toLocal();
        final DateTime now = DateTime.now();

        if (completedAt.year == now.year &&
            completedAt.month == now.month &&
            completedAt.day == now.day) {
          if (mounted) {
            setState(() {
              _shouldShowDailySurvey = false;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking daily survey eligibility: $e');
    }
  }

  Future<void> _fetchPsqiScore() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        if (mounted) setState(() => _isLoadingPsqi = false);
        return;
      }

      final response = await supabaseClient
          .from('sleep_assessments')
          .select('raw_total_score')
          .eq('user_id', userId)
          .inFilter('assessment_type', ['baseline_full', 'repeat_full'])
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response != null && mounted) {
        setState(() {
          final score = response['raw_total_score'];
          if (score is num) {
            _psqiScore = score.toInt();
          } else if (score is String) {
            _psqiScore = int.tryParse(score);
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching PSQI score: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingPsqi = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => WeatherCubit(
        repository: const WeatherRepository(
          locationService: LocationService(),
          weatherApiService: WeatherApiService(),
        ),
      )..loadWeather(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: size.width,
          decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                const TimeCircle(),
                SizedBox(height: 18.h),
                const WeatherCard(),
                SizedBox(height: 18.h),

                // Daily Check-in Banner
                if (_shouldShowDailySurvey) ...[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DailyShortSurveyScreen(),
                        ),
                      );
                    },
                    child: GlassCard(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.assignment_turned_in,
                              color: AppTheme.primaryColor,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.homeRecordSleep,
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 10.sp,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  l10n.homeEnterLastNightData,
                                  style: TextStyle(
                                    color: AppTheme.textLight,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppTheme.primaryColor,
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                // Monthly 30-Day Check-in Banner
                if (_shouldShowMonthlySurvey && !_shouldShowDailySurvey) ...[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuestionnaireScreen(),
                        ),
                      );
                    },
                    child: GlassCard(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.calendar_month,
                              color: AppTheme.primaryColor,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ĐÁNH GIÁ 30 NGÀY",
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 10.sp,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Làm khảo sát PSQI tháng này",
                                  style: TextStyle(
                                    color: AppTheme.textLight,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppTheme.primaryColor,
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                // PSQI Score Card
                if (!_isLoadingPsqi && _psqiScore != null) ...[
                  GlassCard(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.analytics_outlined,
                            color: AppTheme.primaryColor,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PSQI SCORE",
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 10.sp,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "${l10n.qPsqiResult(_psqiScore!)}/21",
                                style: TextStyle(
                                  color: AppTheme.textLight,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _psqiScore! <= 5
                                    ? l10n.qPsqiGood
                                    : l10n.qPsqiBad,
                                style: TextStyle(
                                  color: _psqiScore! <= 5
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                if (_recommendations.isNotEmpty) ...[
                  Text(
                    "GỢI Ý CHO RIÊNG BẠN",
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 10.sp,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ..._recommendations.map((rec) {
                    final track = rec['tracks'];
                    if (track == null) return const SizedBox.shrink();
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: GlassCard(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.music_note,
                                color: AppTheme.primaryColor,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    track['title'] ?? 'Bài hát',
                                    style: TextStyle(
                                      color: AppTheme.textLight,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    rec['recommendation_reason'] ?? '',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.play_circle_fill,
                              color: AppTheme.primaryColor,
                              size: 24.sp,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 24.h),
                ],

                Text(
                  l10n.homeSoothingMelody,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 10.sp,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.homeChooseMusic,
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.h),
                const CardMusic(),

                SizedBox(height: 30.h),
                GlassCard(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.water_drop,
                          color: AppTheme.primaryColor,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.homeActiveSession,
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 10.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              l10n.homeOceanWaves,
                              style: TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.equalizer,
                        color: AppTheme.primaryColor,
                        size: 22.sp,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
