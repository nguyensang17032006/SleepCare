import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:sleep_app_frontend/core/app/widget/primary_button.dart";
import 'package:sleep_app_frontend/core/app/widget/custom_text_field.dart';
import "package:sleep_app_frontend/core/constants/app_size.dart";
import "package:sleep_app_frontend/core/theme/theme.dart";
import "package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart";

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  late final _newPasswordController = TextEditingController();
  late final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'New Password',
          style: TextStyle(color: AppTheme.textMuted, fontSize: AppSizes.f16),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          children: [
            CustomTextField(
              controller: _newPasswordController,
              label: 'Password',
              hint: 'Nhập mật khẩu của bạn',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              errorText: authVM.passwordError,
            ),
             SizedBox(height: AppSizes.p16),

            CustomTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hint: 'Nhập lại mật khẩu để xác nhận',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              errorText: authVM.confirmPasswordError,
            ),
             SizedBox(height: AppSizes.p16),

            authVM.isLoading
                ? const CircularProgressIndicator()
                : PrimaryButton(
                    text: 'Reset Password',
                    onPressed: () async {
                      bool isSuccess = await authVM.updatePassword(
                        newPassword: _newPasswordController.text,
                        confirmPassword: _confirmPasswordController.text,
                      );
                      if (!context.mounted) {
                        return;
                      }
                      if (isSuccess) {
                        Navigator.pop(context);
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
