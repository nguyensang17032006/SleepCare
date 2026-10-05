import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
class HeaderLogin extends StatelessWidget {
  const HeaderLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.nights_stay, color: AppTheme.primaryColor, size: AppSizes.f32),
            const SizedBox(width: 8),
            Text(
              'SleepCare',
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: AppSizes.f32),
            ),
          ],
        ),
        SizedBox(height: AppSizes.f32 + AppSizes.f12),
  
       
      ],
    );
  }
}
