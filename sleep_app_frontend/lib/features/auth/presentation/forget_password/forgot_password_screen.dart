import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/auth/presentation/forget_password/widget/btn_back_to_login.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/app/widget/primary_button.dart';
import '../../../../core/app/widget/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textMuted),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SleepCare',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
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
              const SizedBox(height: 20),
              const Text(
                'SECURITY',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Reset your\npeace of mind',
                style: Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 16),
              Text(
                'Enter your email to receive reset instructions.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 40),
              const CustomTextField(
                label: 'Email Address',
                hint: 'name@example.com',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 40),
              PrimaryButton(text: 'Send Reset Link', onPressed: () {}),
              const SizedBox(height: 30),
              const BackToLoginWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
