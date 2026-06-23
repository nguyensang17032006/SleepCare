import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:sleep_app_frontend/core/app/widget/custom_text_field.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/check_privacy_vm.dart';
import '../login/login_screen.dart';
import '../verify_email/verify_email_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Khởi tạo controller cố định bên trong State
  late final TextEditingController _fullnameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().clearAllErrors();
    });
  }

  @override
  void dispose() {
    // hủy các controller khi widget bị hủy để tránh rò rỉ bộ nhớ
    _fullnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckboxPrivacy(),
      builder: (context, child) {
        final checkboxVM = context.watch<CheckboxPrivacy>();
        final authVM = context.watch<AuthViewModel>();

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

                    //header với logo và slogan
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

                    // các trường nhập liệu với errorText được bind trực tiếp từ ViewModel
                    CustomTextField(
                      controller: _fullnameController,
                      label: 'Họ và tên',
                      hint: 'Nhập họ và tên của bạn',
                      prefixIcon: Icons.person_outline,
                      errorText: authVM.fullNameError,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _usernameController,
                      label: 'Tài khoản',
                      hint: 'Nhập tên tài khoản',
                      prefixIcon: Icons.account_circle_outlined,
                      errorText: authVM.usernameError,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Nhập địa chỉ email của bạn',
                      prefixIcon: Icons.email_outlined,
                      errorText: authVM.emailError,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Nhập mật khẩu của bạn',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      errorText: authVM.passwordError,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Nhập lại mật khẩu để xác nhận',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      errorText: authVM.confirmPasswordError,
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
                            onChanged: (value) => checkboxVM.toggleCheckbox(),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              text: "I agree to the ",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
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

                    // đang ký
                    authVM.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFB39DDB),
                            ),
                          )
                        : PrimaryButton(
                            text: 'Sign Up',
                            onPressed: () async {
                              final isSuccess = await authVM.register(
                                fullname: _fullnameController.text.trim(),
                                username: _usernameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                confirmPassword: _confirmPasswordController.text
                                    .trim(),
                                isTermsChecked: checkboxVM.isChecked,
                              );

                              if (context.mounted) {
                                if (isSuccess) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => VerifyEmailScreen(
                                        email: _emailController.text.trim(),
                                      ),
                                    ),
                                  );
                                } else {
                                  if (authVM.errorMessage != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(authVM.errorMessage!),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                    const SizedBox(height: 30),

                    // chuyển sang đăng nhập nếu đã có tài khoản
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
    );
  }
}
