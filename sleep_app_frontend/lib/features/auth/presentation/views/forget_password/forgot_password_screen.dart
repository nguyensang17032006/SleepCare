import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
import 'package:sleep_app_frontend/core/app/widget/custom_text_field.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';

import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/forget_password/confirm_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final bool returnToSettings;

  const ForgotPasswordScreen({
    super.key,
    this.returnToSettings = false,
  });

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword(
    AuthViewModel authVM,
  ) async {
    final email = _emailController.text.trim();

    final isSuccess = await authVM.resetPassword(
      email: email,
    );

    if (!mounted) return;

    if (!isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Không thể gửi mã xác nhận. Vui lòng thử lại.',
          ),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmPasswordScreen(
          email: email,
          returnToSettings: widget.returnToSettings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppTheme.textMuted,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'SleepCare',
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: AppSizes.f16,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.bgGradient,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            AppSizes.p24,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppSizes.p16,
              ),


              SizedBox(
                height: AppSizes.p8,
              ),

              Text(
                'Khôi phục mật khẩu',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(
                      fontSize: AppSizes.f24,
                    ),
              ),

              SizedBox(
                height: AppSizes.p16,
              ),

              Text(
                'Nhập email của bạn để nhận mã xác nhận đặt lại mật khẩu.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      height: 1.5,
                    ),
              ),

              SizedBox(
                height: AppSizes.p24,
              ),

              CustomTextField(
                controller: _emailController,
                label: 'Địa chỉ email',
                hint: 'name@example.com',
                prefixIcon:
                    Icons.email_outlined,
                errorText: authVM.emailError,
              ),

              SizedBox(
                height: AppSizes.p24,
              ),

              authVM.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : PrimaryButton(
                      text: 'Gửi mã xác nhận',
                      onPressed: () {
                        _handleResetPassword(
                          authVM,
                        );
                      },
                    ),

              SizedBox(
                height: AppSizes.p24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}