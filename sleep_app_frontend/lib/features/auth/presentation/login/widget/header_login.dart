import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

class HeaderLogin extends StatelessWidget {
  const HeaderLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.nights_stay, color: AppTheme.primaryColor, size: 32),
            const SizedBox(width: 8),
            Text(
              'SleepCare',
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 28),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Text(
          'Welcome back',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Ready for your restorative journey?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
