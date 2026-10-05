import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/forget_password/forgot_password_screen.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/app/widget/custom_text_field.dart';
import '../../../../core/app/widget/primary_button.dart';


class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Security & Privacy',
          style: TextStyle(color: AppTheme.textLight, fontSize: 16),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Đổi mật khẩu',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bảo vệ tài khoản của bạn bằng cách thay đổi mật khẩu định kỳ.',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 40),

              const CustomTextField(
                label: 'Mật khẩu hiện tại',
                hint: '••••••••',
                
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Mật khẩu mới',
                hint: '••••••••',
               
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Xác nhận mật khẩu mới',
                hint: '••••••••',
               
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 30),

             
              const SizedBox(height: 40),

              PrimaryButton(
                text: 'Cập nhật mật khẩu',
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                  },
                  child: const Text(
                    'Quên mật khẩu hiện tại?',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  