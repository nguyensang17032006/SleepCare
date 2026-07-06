import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/forget_password/forgot_password_screen.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
          );
        },
        child:  Text(
          'Quên mật khẩu?',
          style: TextStyle(color: AppTheme.textMuted, fontSize: AppSizes.f12),
        ),
      ),
    );
  }
}
