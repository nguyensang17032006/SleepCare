import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme.dart';
import '../bloc/weather_cubit.dart';
import '../bloc/weather_state.dart';
import 'glass_card.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading || state is WeatherInitial) {
          return const GlassCard(
            child: SizedBox(
              height: 88,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          );
        }

        if (state is WeatherError) {
          return GlassCard(
            child: Row(
              children: [
                const Icon(Icons.cloud_off, color: Colors.orangeAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state.message,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => context.read<WeatherCubit>().loadWeather(),
                  icon: const Icon(Icons.refresh, color: AppTheme.primaryColor),
                ),
              ],
            ),
          );
        }

        final loadedState = state as WeatherLoaded;
        final weather = loadedState.weather;

        return GlassCard(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: SizedBox(
            height: 78.h,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wb_sunny_outlined,
                    color: AppTheme.secondaryColor,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CURRENT LOCATION',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 9.sp,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        weather.city,
                        style: TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        weather.condition,
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${weather.temperatureC.toStringAsFixed(1)}°C',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
