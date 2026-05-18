import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_text_field.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../onboarding/questionnaire_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.nights_stay, color: AppTheme.primaryColor, size: 32),
                              const SizedBox(width: 8),
                              Text(
                                'SleepCare',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Text(
                            'Welcome back',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ready for your restorative journey?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 40),
                          const CustomTextField(
                            label: 'Email Address',
                            hint: 'name@example.com',
                            prefixIcon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 20),
                          const CustomTextField(
                            label: 'Password',
                            hint: '••••••••',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            text: 'Sign In ->',
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const QuestionnaireScreen()));
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text('OR', style: TextStyle(color: AppTheme.textMuted.withOpacity(0.5))),
                              ),
                              Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                            },
                            child: const Text(
                              'Create Account',
                              style: TextStyle(color: AppTheme.textLight, fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'By continuing, you agree to our Terms of Service',
                          style: TextStyle(color: AppTheme.textMuted.withOpacity(0.6), fontSize: 12),
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
  }
}
