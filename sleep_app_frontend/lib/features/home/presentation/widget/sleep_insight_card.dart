import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme.dart';

class SleepInsightCard extends StatelessWidget {
  const SleepInsightCard({
    super.key,
    required this.psqiScore,
    this.onTap,
  });

  final int psqiScore;
  final VoidCallback? onTap;

  String get _status {
    if (psqiScore <= 5) return 'Tốt';
    if (psqiScore <= 10) return 'Cần cải thiện';
    return 'Cần chú ý';
  }

  Color get _statusColor {
    if (psqiScore <= 5) return Colors.greenAccent;
    if (psqiScore <= 10) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (psqiScore / 21).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: AppTheme.cardColor.withValues(alpha: 0.56),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'PSQI',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    _status,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$psqiScore',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.h, left: 4.w),
                  child: Text(
                    '/21',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: LinearProgressIndicator(
                minHeight: 6.h,
                value: progress,
                backgroundColor: Colors.white.withValues(alpha: 0.07),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              psqiScore <= 5
                  ? 'Chất lượng giấc ngủ của bạn đang ở mức tốt.'
                  : 'Chất lượng giấc ngủ của bạn vẫn còn có thể cải thiện.',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11.sp,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
