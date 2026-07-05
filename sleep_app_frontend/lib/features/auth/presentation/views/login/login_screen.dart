import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/widget/create_account_button.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/widget/forgot_password_button.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/widget/header_login.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/widget/sign_in_by_google_button.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:sleep_app_frontend/core/app/widget/custom_text_field.dart';
import 'package:sleep_app_frontend/features/onboarding/questionnaire_screen.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/toggle_password_vm.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().clearAllErrors();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TogglePasswordVM(),
      child: Builder(
        builder: (context) {
          final authVM = context.watch<TogglePasswordVM>();
          final authVMLogin = context.watch<AuthViewModel>();

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding:  EdgeInsets.all(AppSizes.p24),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 48,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                 SizedBox(height: AppSizes.vGap32),
                                const HeaderLogin(),
                                 SizedBox(height: AppSizes.vGap32),
                                if (authVMLogin.errorMessage != null) ...[
                                  Container(
                                    width: double.infinity,
                                    padding:  EdgeInsets.all(AppSizes.p12),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.redAccent.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: Colors.redAccent,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            authVMLogin.errorMessage!,
                                            style: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ), // Tạo khoảng cách với ô nhập liệu bên dưới
                                ],
                                CustomTextField(
                                  controller: _usernameController,
                                  label: 'Tài khoản',
                                  hint: 'Nhập tên người dùng',
                                  prefixIcon: Icons.person_outline,
                                  errorText: authVMLogin.usernameError,
                                ),
                                 SizedBox(height: AppSizes.vGap12),
                                CustomTextField(
                                  controller: _passwordController,
                                  label: 'Mật khẩu',
                                  hint: 'Nhập mật khẩu của bạn',
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: authVM.isPasswordVisible,
                                  onSuffixIconPressed: () =>
                                      authVM.togglePasswordVisibility(),
                                  errorText: authVMLogin.passwordError,
                                ),
                                 SizedBox(height: AppSizes.vGap12),
                                const ForgotPasswordButton(),
                                 SizedBox(height: AppSizes.vGap12),
                                authVMLogin.isLoading
                                    ? const CircularProgressIndicator()
                                    : PrimaryButton(
                                        text: 'Đăng nhập ->',
                                        onPressed: () async {
                                          bool isSuccess = await authVMLogin
                                              .signInWithUsername(
                                                username:
                                                    _usernameController.text,
                                                password:
                                                    _passwordController.text,
                                              );
                                          if (!context.mounted) {
                                            return;
                                          }
                                            if (isSuccess) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const QuestionnaireScreen(),
                                                ),
                                              );
                                            }
                                          
                                        },
                                      ),
                                 SizedBox(height: AppSizes.vGap12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSizes.p12,
                                      ),
                                      child: Text(
                                        'OR',
                                        style: TextStyle(
                                          color: AppTheme.textMuted.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                 SizedBox(height: AppSizes.vGap12),
                                const CreateAccountButton(),
                                 SizedBox(height: AppSizes.vGap12),
                                const SignInByGoogleButton(),
                                SizedBox(height: AppSizes.vGap12),
                              ],
                            ),
                            SizedBox(height: AppSizes.vGap12),
                            Padding(
                              padding: EdgeInsets.only(bottom: AppSizes.p16),
                              child: Text(
                                'Bằng cách đăng nhập, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật của chúng tôi.',
                                style: TextStyle(
                                  color: AppTheme.textMuted.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: AppSizes.f10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
