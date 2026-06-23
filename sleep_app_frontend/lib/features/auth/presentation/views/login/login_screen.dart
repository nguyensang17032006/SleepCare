import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                      padding: const EdgeInsets.all(24.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 48,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 40),
                                const HeaderLogin(),
                                const SizedBox(height: 40),
                                if (authVMLogin.errorMessage != null) ...[
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
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
                                  label: 'Username',
                                  hint: 'Enter user name',
                                  prefixIcon: Icons.person_outline,
                                  errorText: authVMLogin.usernameError,
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  hint: 'Enter your password',
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: authVM.isPasswordVisible,
                                  onSuffixIconPressed: () =>
                                      authVM.togglePasswordVisibility(),
                                  errorText: authVMLogin.passwordError,
                                ),
                                const SizedBox(height: 12),
                                const ForgotPasswordButton(),
                                const SizedBox(height: 24),
                                authVMLogin.isLoading
                                    ? const CircularProgressIndicator()
                                    : PrimaryButton(
                                        text: 'Sign In ->',
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
                                const SizedBox(height: 20),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
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
                                const SizedBox(height: 20),
                                const CreateAccountButton(),
                                const SizedBox(height: 15),
                                const SignInByGoogleButton(),
                                const SizedBox(height: 15),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                'By continuing, you agree to our Terms of Service',
                                style: TextStyle(
                                  color: AppTheme.textMuted.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 12,
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
