import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/widget/create_account_button.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/widget/forgot_password_button.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/widget/header_login.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/widget/sign_in_by_google_button.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/widget/sign_in_by_phone_button.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:sleep_app_frontend/core/app/widget/custom_text_field.dart';
import 'package:sleep_app_frontend/features/onboarding/questionnaire_screen.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/forget_password_vm.dart'; // Consider replacing with LoginVM if applicable

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgetPasswordVM(),
      child: Builder(
        builder: (context) {
          final authVM = context.watch<ForgetPasswordVM>();

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
                                const CustomTextField(
                                  label: 'Username',
                                  hint: 'Enter user name',
                                  prefixIcon: Icons.person_outline,
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  label: 'Password',
                                  hint: 'Enter your password',
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: authVM.isPasswordVisible,
                                  onSuffixIconPressed: () =>
                                      authVM.togglePasswordVisibility(),
                                ),
                                const SizedBox(height: 12),
                                const ForgotPasswordButton(),
                                const SizedBox(height: 24),
                                PrimaryButton(
                                  text: 'Sign In ->',
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const QuestionnaireScreen(),
                                      ),
                                    );
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
                                const SignInByPhoneButton(),
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
