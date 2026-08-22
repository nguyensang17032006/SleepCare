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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
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
