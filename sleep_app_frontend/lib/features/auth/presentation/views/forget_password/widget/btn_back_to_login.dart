import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

class BackToLoginWidget extends StatelessWidget {
  const BackToLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.chevron_left,
          color: AppTheme.textLight,
          size: 20,
        ),
        label: const Text(
          'Back to Login',
          style: TextStyle(color: AppTheme.textLight, fontSize: 14),
        ),
      ),
    );
  }
}
