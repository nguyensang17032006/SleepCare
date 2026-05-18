import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_text_field.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _agreedToTOS = false;

  @override
  Widget build(BuildContext context) {
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
                    Icon(Icons.nights_stay, color: AppTheme.primaryColor, size: 28),
                    const SizedBox(width: 8),
                    Text('SleepCare', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
                  ],
                ),
                Center(
                  child: Text('Begin your journey to restorative rest', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
                ),
                const SizedBox(height: 40),
                Text('Create Account', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 22)),
                const SizedBox(height: 30),
                const CustomTextField(label: 'Full Name', hint: 'Mark Brooks'),
                const SizedBox(height: 20),
                const CustomTextField(label: 'Email Address', hint: 'name@example.com'),
                const SizedBox(height: 20),
                const CustomTextField(label: 'Password', hint: '••••••••', isPassword: true),
                const SizedBox(height: 20),
                const CustomTextField(label: 'Confirm', hint: '••••••••', isPassword: true),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _agreedToTOS,
                        onChanged: (val) {
                          setState(() { _agreedToTOS = val ?? false; });
                        },
                        checkColor: Colors.white,
                        activeColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.textMuted.withOpacity(0.5)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'I agree to the Terms of Service and Privacy Policy.',
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  text: 'Sign Up',
                  onPressed: () {
                     if (!_agreedToTOS) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Please agree to the Terms of Service')),
                       );
                       return;
                     }
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VerifyEmailScreen()));
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text('Already have an account? ', style: TextStyle(color: AppTheme.textMuted)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                        },
                        child: const Text('Sign in', style: TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold)),
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
  }
}
