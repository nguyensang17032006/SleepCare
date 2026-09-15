import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:sleep_app_frontend/core/app/widget/custom_text_field.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  final bool returnToSettings;

  const NewPasswordScreen({
    super.key,
    this.returnToSettings = false,
  });

  @override
  State<NewPasswordScreen> createState() =>
      _NewPasswordScreenState();
}

class _NewPasswordScreenState
    extends State<NewPasswordScreen> {
  final TextEditingController
      _newPasswordController =
      TextEditingController();

  final TextEditingController
      _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _resetPassword(
    AuthViewModel authVM,
  ) async {
    final isSuccess =
        await authVM.updatePassword(
      newPassword:
          _newPasswordController
              .text
              .trim(),
      confirmPassword:
          _confirmPasswordController
              .text
              .trim(),
      logoutAfterUpdate:
          !widget.returnToSettings,
    );

    if (!mounted) return;

    if (!isSuccess) return;

    if (widget.returnToSettings) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM =
        context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mật khẩu mới',
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
            AppSizes.p16,
          ),
          child: Column(
            children: [
              CustomTextField(
                controller:
                    _newPasswordController,
                label: 'Mật khẩu mới',
                hint:
                    'Nhập mật khẩu mới',
                prefixIcon:
                    Icons.lock_outline,
                obscureText: true,
                errorText:
                    authVM.passwordError,
              ),

              SizedBox(
                height: AppSizes.p16,
              ),

              CustomTextField(
                controller:
                    _confirmPasswordController,
                label:
                    'Xác nhận mật khẩu',
                hint:
                    'Nhập lại mật khẩu mới',
                prefixIcon:
                    Icons.lock_outline,
                obscureText: true,
                errorText: authVM
                    .confirmPasswordError,
              ),

              SizedBox(
                height: AppSizes.p24,
              ),

              authVM.isLoading
                  ? const CircularProgressIndicator(
                      color: AppTheme
                          .primaryColor,
                    )
                  : PrimaryButton(
                      text:
                          'Đặt lại mật khẩu',
                      onPressed: () {
                        _resetPassword(
                          authVM,
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}