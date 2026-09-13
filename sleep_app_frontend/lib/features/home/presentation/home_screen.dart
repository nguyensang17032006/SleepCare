import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/theme.dart';
import '../../onboarding/domain/entities/assessment_requirement.dart';
import '../../onboarding/domain/usecases/check_required_assessment.dart';
import '../../onboarding/presentation/daily_short_survey_screen.dart';
import '../../onboarding/presentation/questionnaire_screen.dart';
import '../../setting/data/sources/profile_sources.dart';
import '../../setting/presentation/views/sleep_schedule_screen.dart';
import '../data/services/location_service.dart';
import '../data/services/weather_api_service.dart';
import '../repository/weather_repository.dart';
import 'bloc/weather_cubit.dart';
import 'widget/card_music.dart';
import 'widget/home_header.dart';
import 'widget/recommendation_card.dart';
import 'widget/sleep_insight_card.dart';
import 'widget/sleep_schedule_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ProfileRemoteDataSource _profileSource = ProfileRemoteDataSource();

  int? _psqiScore;
  bool _isLoadingPsqi = true;

  AssessmentRequirement? _assessmentRequirement;
  bool _isLoadingAssessmentRequirement = true;

  List<Map<String, dynamic>> _recommendations = [];

  String _userName = '';
  String? _bedtime;
  int _reminderMinutes = 15;
  bool _scheduleNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadHome();
  }

  Future<void> _loadHome() async {
    await Future.wait([
      _fetchProfile(),
      _fetchBedtimeSchedule(),
      _fetchPsqiScore(),
      _loadAssessmentRequirement(),
      _fetchRecommendations(),
    ]);
  }

  Future<void> _fetchProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final data = await _profileSource.fetchUserProfile(user.id);

      final rawName =
          data['full_name'] ??
          data['fullname'] ??
          data['name'] ??
          user.userMetadata?['full_name'] ??
          user.userMetadata?['name'] ??
          '';

      final fullName = rawName.toString().trim();
      final displayName = fullName.isEmpty
          ? ''
          : fullName.split(RegExp(r'\s+')).last;

      if (!mounted) return;

      setState(() {
        _userName = displayName;
      });
    } catch (e) {
      debugPrint('Error fetching home profile: $e');
    }
  }

  Future<void> _fetchBedtimeSchedule() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await _supabase
          .from('bedtime_schedules')
          .select(
            'bedtime, reminder_offset_minutes, notifications_enabled, is_enabled',
          )
          .eq('user_id', user.id)
          .maybeSingle();

      if (!mounted || response == null) return;

      final bedtime = response['bedtime']?.toString();
      final reminder = response['reminder_offset_minutes'];
      final notificationsEnabled = response['notifications_enabled'];
      final isEnabled = response['is_enabled'];

      setState(() {
        _bedtime = bedtime;

        if (reminder is num) {
          _reminderMinutes = reminder.toInt();
        }

        if (notificationsEnabled is bool) {
          _scheduleNotificationsEnabled = notificationsEnabled;
        }

        if (isEnabled is bool && !isEnabled) {
          _scheduleNotificationsEnabled = false;
        }
      });
    } catch (e) {
      debugPrint('Error fetching bedtime schedule: $e');
    }
  }

  Future<void> _fetchRecommendations() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final res = await _supabase
          .from('music_recommendations')
          .select(
            'recommendation_reason, tracks(id, title, description, cover_url)',
          )
          .eq('user_id', userId)
          .eq('status', 'shown')
          .order('recommendation_score', ascending: false)
          .limit(2);

      if (!mounted) return;

      setState(() {
        _recommendations = List<Map<String, dynamic>>.from(res);
      });
    } catch (e) {
      debugPrint('Error fetching recommendations: $e');
    }
  }

  Future<void> _loadAssessmentRequirement() async {
    final useCase = context.read<CheckRequiredAssessment>();
    final result = await useCase();

    if (!mounted) return;

    result.match(
      (failure) {
        debugPrint(
          'Error checking assessment requirement: ${failure.message}',
        );

        setState(() {
          _assessmentRequirement = AssessmentRequirement.none;
          _isLoadingAssessmentRequirement = false;
        });
      },
      (requirement) {
        setState(() {
          _assessmentRequirement = requirement;
          _isLoadingAssessmentRequirement = false;
        });
      },
    );
  }

  Future<void> _fetchPsqiScore() async {
    try {
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        if (mounted) {
          setState(() => _isLoadingPsqi = false);
        }
        return;
      }

      final response = await _supabase
          .from('sleep_assessments')
          .select('raw_total_score')
          .eq('user_id', userId)
          .inFilter(
            'assessment_type',
            ['baseline_full', 'repeat_full'],
          )
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response != null && mounted) {
        final score = response['raw_total_score'];

        setState(() {
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

  Future<void> _openSleepSchedule() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SleepScheduleScreen(),
      ),
    );

    if (!mounted) return;
    await _fetchBedtimeSchedule();
  }

  Future<void> _openDailySurvey() async {
    final completed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const DailyShortSurveyScreen(),
      ),
    );

    if (completed == true && mounted) {
      await _loadAssessmentRequirement();
    }
  }

  Future<void> _openFullSurvey() async {
    final completed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const QuestionnaireScreen(),
      ),
    );

    if (completed == true && mounted) {
      await _loadAssessmentRequirement();
      await _fetchPsqiScore();
    }
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppTheme.textLight,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _assessmentBanner({
    required String eyebrow,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(17.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.11),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.17),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10.5.sp,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_rounded,
              color: AppTheme.primaryColor,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowDailySurvey =
        !_isLoadingAssessmentRequirement &&
        _assessmentRequirement == AssessmentRequirement.dailyShort;

    final shouldShowFullSurvey =
        !_isLoadingAssessmentRequirement &&
        (_assessmentRequirement == AssessmentRequirement.baselineFull ||
            _assessmentRequirement == AssessmentRequirement.repeatFull);

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
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppTheme.bgGradient,
          ),
          child: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: AppTheme.primaryColor,
              onRefresh: _loadHome,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  20.w,
                  16.h,
                  20.w,
                  32.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(
                      userName: _userName,
                    ),
                    SizedBox(height: 24.h),
                    SleepScheduleCard(
                      bedtime: _bedtime,
                      reminderMinutes: _reminderMinutes,
                      isEnabled: _scheduleNotificationsEnabled,
                      onTap: _openSleepSchedule,
                    ),
                    if (shouldShowDailySurvey || shouldShowFullSurvey) ...[
                      SizedBox(height: 24.h),
                      _sectionTitle('Việc cần làm'),
                      SizedBox(height: 12.h),
                    ],
                    if (shouldShowDailySurvey)
                      _assessmentBanner(
                        eyebrow: 'CHECK-IN GIẤC NGỦ',
                        title: 'Bạn ngủ thế nào tối qua?',
                        subtitle:
                            'Ghi lại giấc ngủ để SleepCare hiểu bạn tốt hơn.',
                        icon: Icons.nightlight_outlined,
                        onTap: _openDailySurvey,
                      ),
                    if (shouldShowDailySurvey && shouldShowFullSurvey)
                      SizedBox(height: 12.h),
                    if (shouldShowFullSurvey)
                      _assessmentBanner(
                        eyebrow: 'ĐÁNH GIÁ ĐỊNH KỲ',
                        title: 'Khảo sát PSQI đang chờ bạn',
                        subtitle:
                            'Cập nhật chất lượng giấc ngủ trong 30 ngày gần nhất.',
                        icon: Icons.assignment_turned_in_outlined,
                        onTap: _openFullSurvey,
                      ),
                    if (!_isLoadingPsqi && _psqiScore != null) ...[
                      SizedBox(height: 26.h),
                      _sectionTitle('Tình trạng giấc ngủ'),
                      SizedBox(height: 12.h),
                      SleepInsightCard(
                        psqiScore: _psqiScore!,
                      ),
                    ],
                    if (_recommendations.isNotEmpty) ...[
                      SizedBox(height: 28.h),
                      _sectionTitle('Dành cho bạn'),
                      SizedBox(height: 12.h),
                      ..._recommendations.map((rec) {
                        final track = rec['tracks'];
                        if (track == null) {
                          return const SizedBox.shrink();
                        }

                        final trackMap = Map<String, dynamic>.from(track);

                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: RecommendationCard(
                            title: trackMap['title']?.toString() ?? 'Bài hát',
                            reason:
                                rec['recommendation_reason']?.toString() ??
                                'Được đề xuất cho giấc ngủ của bạn',
                            coverUrl: trackMap['cover_url']?.toString(),
                          ),
                        );
                      }),
                    ],
                    SizedBox(height: 28.h),
                    _sectionTitle('Khám phá âm thanh ngủ'),
                    SizedBox(height: 6.h),
                    Text(
                      'Thư giãn trước khi bước vào giấc ngủ',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 13.h),
                    const CardMusic(),
                    SizedBox(height: 28.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
