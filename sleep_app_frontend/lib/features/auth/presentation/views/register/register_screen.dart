import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:sleep_app_frontend/core/app/widget/custom_text_field.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/check_privacy_vm.dart';
import '../login/login_screen.dart';
import '../verify_email/verify_email_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckboxPrivacy(),
      child: Builder(
        builder: (context) {
          final checkboxVM = context.watch<CheckboxPrivacy>();
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.nights_stay,
                            color: AppTheme.primaryColor,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SleepCare',
                            style: Theme.of(
                              context,
                            ).textTheme.displayLarge?.copyWith(fontSize: 24),
                          ),
                        ],
                      ),
                      Center(
                        child: Text(
                          'Begin your journey to restorative rest',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Create Account',
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 30),
                      const CustomTextField(
                        label: 'Username',
                        hint: 'Enter user name',
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),
                      const CustomTextField(
                        label: 'Email',
                        hint: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 20),
                      const CustomTextField(
                        label: 'Password',
                        hint: 'Enter your password',
                        prefixIcon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 20),
                      const CustomTextField(
                        label: 'Confirm Password',
                        hint: 'Confirm your password',
                        prefixIcon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Checkbox(
                              value: checkboxVM.isChecked,
                              activeColor: const Color(0xFFB39DDB),
                              side: const BorderSide(color: Colors.white54),
                              onChanged: (value) {
                                checkboxVM.toggleCheckbox();
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
              child: RichText(
                text: const TextSpan(
                  text: "I agree to the ",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  children: [
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(
                        color: Color(0xFFB39DDB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        color: Color(0xFFB39DDB),
                        fontWeight: FontWeight.bold,
                        
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
                      const SizedBox(height: 30),
                      PrimaryButton(
                        text: 'Sign Up',
                        onPressed: () {
                          if (!checkboxVM.isChecked) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please agree to the Terms of Service',
                                ),
                              ),
                            );
                            return;
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VerifyEmailScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(color: AppTheme.textMuted),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign in',
                                style: TextStyle(
                                  color: AppTheme.textLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
