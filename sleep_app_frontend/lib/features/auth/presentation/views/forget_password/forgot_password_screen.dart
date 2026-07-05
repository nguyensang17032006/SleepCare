import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
import 'package:sleep_app_frontend/core/app/widget/custom_text_field.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/forget_password/confirm_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textMuted),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SleepCare',
          style: TextStyle(color: AppTheme.textMuted, fontSize: AppSizes.f16),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.p16),
              const Text(
                'SECURITY',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: AppSizes.p8),
              Text(
                'Reset your\npeace of mind',
                style: Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(fontSize: AppSizes.f24),
              ),
              SizedBox(height: AppSizes.p16),
              Text(
                'Enter your email to receive reset instructions.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              SizedBox(height: AppSizes.p24),
              CustomTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'name@example.com',
                prefixIcon: Icons.email_outlined,
                errorText: authVM.emailError,
              ),
              SizedBox(height: AppSizes.p24),
              authVM.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : PrimaryButton(
                      text: 'Gửi mã xác nhận',

                      onPressed: () async {
                        bool isSuccess = await authVM.resetPassword(
                          email: _emailController.text.trim(),
                        );

                        if (context.mounted) {
                          if (isSuccess) {
                            Navigator.pushReplacement(
                              context,

                              MaterialPageRoute(
                                builder: (_) => ConfirmPasswordScreen(
                                  email: _emailController.text.trim(),
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Failed to send reset link. Please try again.',
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),

              SizedBox(height: AppSizes.p24),
            ],
          ),
        ),
      ),
    );
  }
}
