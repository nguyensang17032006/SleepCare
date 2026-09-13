import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme.dart';

class SleepScheduleCard extends StatelessWidget {
  const SleepScheduleCard({
    super.key,
    required this.bedtime,
    required this.reminderMinutes,
    required this.isEnabled,
    required this.onTap,
  });

  final String? bedtime;
  final int reminderMinutes;
  final bool isEnabled;
  final VoidCallback onTap;

  String _displayTime(String? value) {
    if (value == null || value.isEmpty) return '--:--';

    final parts = value.split(':');
    if (parts.length < 2) return value;

    return '${parts[0]}:${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final hasSchedule = bedtime != null && bedtime!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.28),
              AppTheme.cardColor.withValues(alpha: 0.78),
              AppTheme.cardColor.withValues(alpha: 0.50),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.22),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              blurRadius: 30.r,
              spreadRadius: 2.r,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.nightlight_round,
                    color: AppTheme.primaryColor,
                    size: 21.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'GIỜ NGỦ HÔM NAY',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textMuted,
                  size: 23.sp,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            if (hasSchedule) ...[
              Text(
                _displayTime(bedtime),
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 46.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  letterSpacing: -1.5,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    isEnabled
                        ? Icons.notifications_none_rounded
                        : Icons.notifications_off_outlined,
                    color: AppTheme.secondaryColor,
                    size: 17.sp,
                  ),
                  SizedBox(width: 7.w),
                  Expanded(
                    child: Text(
                      isEnabled
                          ? 'Nhắc bạn trước $reminderMinutes phút'
                          : 'Thông báo lịch ngủ đang tắt',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                'Bạn chưa đặt lịch ngủ',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Thiết lập giờ ngủ để SleepCare nhắc bạn nghỉ ngơi đúng giờ.',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Thiết lập lịch ngủ',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
