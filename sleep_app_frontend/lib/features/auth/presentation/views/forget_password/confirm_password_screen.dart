import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/core/theme/pin_theme.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/time_remaining_vm.dart';
import 'package:sleep_app_frontend/features/home/presentation/widget/glass_card.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/forget_password/newpassword_screen.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  final String email;
  const ConfirmPasswordScreen({super.key, required this.email});

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final TimeRemainingViewModel _timeRemainingVM = TimeRemainingViewModel();

  @override
  void initState() {
    super.initState();
    _timeRemainingVM.startCountdown();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _timeRemainingVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Verify Email',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.cardLightColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.email,
                    color: AppTheme.textLight,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'SECURITY CHECK',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Verify your email',
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  "We've sent a 6-digit verification code to your email address. Please enter it below to continue.",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Center(
                  child: Pinput(
                    length: 6,
                    controller: pinController,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    autofocus: true,
                    keyboardType: TextInputType.number,

                    forceErrorState: authVM.errorMessage != null,

                    errorText: authVM.errorMessage,

                    errorTextStyle: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                authVM.isLoading
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        text: 'Verify and Continue',
                        onPressed: () async {
                          final isSuccess = await authVM.verifyResetPasswordOTP(
                            email: widget.email,
                            otp: pinController.text.trim(),
                          );

                          if (!context.mounted) {
                            return;
                          }
                          if (isSuccess) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NewPasswordScreen(),
                              ),
                            );
                          }
                        },
                      ),
                const SizedBox(height: 20),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive a code? ",
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                      ListenableBuilder(
                        listenable: _timeRemainingVM,
                        builder: (context, child) {
                          return TextButton(
                            onPressed: _timeRemainingVM.canResend
                                ? () {
                                    authVM.resendOTP(email: widget.email);
                                    _timeRemainingVM.startCountdown();
                                  }
                                : null,

                            child: Text(
                              _timeRemainingVM.canResend
                                  ? 'Resend'
                                  : 'Resend in ${_timeRemainingVM.secondsRemaining} s',
                              style: TextStyle(
                                color: _timeRemainingVM.canResend
                                    ? AppTheme.textLight
                                    : AppTheme.textMuted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppTheme.textMuted,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Check your spam folder',
                              style: TextStyle(
                                color: AppTheme.textLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sometimes the verification email might end up in your spam or junk folder.',
                              style: TextStyle(
                                color: AppTheme.textMuted.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: 12,
                              ),
                            ),
                          ],
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
