import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:sleep_app_frontend/core/app/widget/custom_text_field.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
import 'package:sleep_app_frontend/features/auth/presentation/widgets/password_requirements.dart';
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
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool get _passwordsAreValid =>
      PasswordRequirements.isValid(_passwordController.text) &&
      _confirmPasswordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onPasswordChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().clearAllErrors();
    });
  }

  @override
  void dispose() {
    // hủy các controller khi widget bị hủy để tránh rò rỉ bộ nhớ
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.removeListener(_onPasswordChanged);
    _confirmPasswordController.removeListener(_onPasswordChanged);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.vGap24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSizes.vGap16),

                //header với logo và slogan
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.nights_stay,
                      color: AppTheme.primaryColor,
                      size: AppSizes.vGap24,
                    ),
                    SizedBox(width: AppSizes.vGap8),
                    Text(
                      'SleepCare',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: AppSizes.f24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.vGap16),
                Center(
                  child: Text(
                    'Bắt đầu hành trình chăm sóc giấc ngủ của bạn',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: AppSizes.f12),
                  ),
                ),
                SizedBox(height: AppSizes.vGap16),
                Text(
                  'Tạo tài khoản',
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: AppSizes.f18),
                ),
                SizedBox(height: AppSizes.vGap16),

                // các trường nhập liệu với errorText được bind trực tiếp từ ViewModel
                CustomTextField(
                  controller: _fullnameController,
                  label: 'Họ và tên',
                  hint: 'Nhập họ và tên của bạn',
                  prefixIcon: Icons.person_outline,
                  errorText: authVM.fullNameError,
                ),
                SizedBox(height: AppSizes.vGap16),

                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Nhập địa chỉ email của bạn',
                  prefixIcon: Icons.email_outlined,
                  errorText: authVM.emailError,
                ),
                SizedBox(height: AppSizes.vGap16),

                CustomTextField(
                  controller: _passwordController,
                  label: 'Mật khẩu',
                  hint: 'Nhập mật khẩu của bạn',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  errorText: authVM.passwordError,
                ),
                PasswordRequirements(password: _passwordController.text),
                SizedBox(height: AppSizes.vGap12),

                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Xác nhận mật khẩu',
                  hint: 'Nhập lại mật khẩu để xác nhận',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  errorText: authVM.confirmPasswordError,
                ),
                SizedBox(height: AppSizes.vGap16),

                // đang ký
                authVM.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFB39DDB),
                        ),
                      )
                    : PrimaryButton(
                        text: 'Đăng ký',
                        enabled: _passwordsAreValid,

                        onPressed: () async {
                          final isSuccess = await authVM.register(
                            fullname: _fullnameController.text.trim(),

                            email: _emailController.text.trim(),

                            password: _passwordController.text.trim(),

                            confirmPassword: _confirmPasswordController.text
                                .trim(),
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
                                  SnackBar(content: Text(authVM.errorMessage!)),
                                );
                              }
                            }
                          }
                        },
                      ),

                SizedBox(height: AppSizes.vGap16),

                // chuyển sang đăng nhập nếu đã có tài khoản
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Bạn đã có tài khoản? ',
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
                          'Đăng nhập',
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
  }
}
