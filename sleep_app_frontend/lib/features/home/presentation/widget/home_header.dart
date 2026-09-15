import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme.dart';
import '../bloc/weather_cubit.dart';
import '../bloc/weather_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.userName});

  final String userName;

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Chào buổi sáng';
    } else if (hour >= 12 && hour < 18) {
      return 'Chào buổi chiều';
    } else {
      return 'Chào buổi tối';
    }
  }

  String _formatDate(DateTime date) {
    const weekdays = [
      'Thứ hai',
      'Thứ ba',
      'Thứ tư',
      'Thứ năm',
      'Thứ sáu',
      'Thứ bảy',
      'Chủ nhật',
    ];

    return '${weekdays[date.weekday - 1]}, ${date.day} tháng ${date.month}';
  }

  IconData _weatherIcon(String condition) {
    final value = condition.toLowerCase();

    if (value.contains('rain') ||
        value.contains('mưa') ||
        value.contains('drizzle')) {
      return Icons.water_drop_outlined;
    }

    if (value.contains('cloud') ||
        value.contains('mây') ||
        value.contains('overcast')) {
      return Icons.cloud_outlined;
    }

    if (value.contains('storm') ||
        value.contains('thunder') ||
        value.contains('giông')) {
      return Icons.thunderstorm_outlined;
    }

    return Icons.wb_sunny_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final displayName = userName.trim().isEmpty ? 'bạn' : userName.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting()}, $displayName',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                _formatDate(DateTime.now()),
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoaded) {
              final weather = state.weather;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _weatherIcon(weather.condition),
                    color: AppTheme.secondaryColor,
                    size: 18.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${weather.temperatureC.toStringAsFixed(0)}°',
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            }

            if (state is WeatherError) {
              return GestureDetector(
                onTap: () => context.read<WeatherCubit>().loadWeather(),
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Icon(
                    Icons.refresh_rounded,
                    color: AppTheme.textMuted,
                    size: 20.sp,
                  ),
                ),
              );
            }

            return SizedBox(
              width: 44.w,
              height: 44.w,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.primaryColor,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
