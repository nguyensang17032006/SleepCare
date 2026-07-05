import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/core/theme/pin_theme.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/time_remaining_vm.dart';
import 'package:sleep_app_frontend/features/home/presentation/widget/glass_card.dart';
import 'package:sleep_app_frontend/features/onboarding/questionnaire_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
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
        title: Text(
          'Verify Email',
          style: TextStyle(color: AppTheme.textMuted, fontSize: AppSizes.f16),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p24,
              vertical: AppSizes.vGap12,
            ),
            child: Column(
              children: [
                SizedBox(height: AppSizes.vGap32),
                Container(
                  padding: EdgeInsets.all(AppSizes.p24),
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
                  child: Icon(
                    Icons.email,
                    color: AppTheme.textLight,
                    size: AppSizes.p32,
                  ),
                ),
                SizedBox(height: AppSizes.p32),
                Text(
                  'SECURITY CHECK',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: AppSizes.f12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: AppSizes.vGap12),
                Text(
                  'Verify your email',
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: AppSizes.f24),
                ),
                SizedBox(height: AppSizes.vGap16),
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

                    errorTextStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: AppSizes.f12,
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.p32),

                authVM.isLoading
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        text: 'Verify and Continue',
                        onPressed: () async {
                          final isSuccess = await authVM.verifyEmail(
                            email: widget.email,
                            token: pinController.text.trim(),
                          );
                          if (!context.mounted) {
                            return;
                          }
                          if (isSuccess) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const QuestionnaireScreen(),
                              ),
                            );
                          }
                        },
                      ),
                SizedBox(height: AppSizes.p16),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
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
                SizedBox(height: AppSizes.vGap32),
                GlassCard(
                  padding: EdgeInsets.all(AppSizes.p16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.textMuted,
                        size: AppSizes.p24,
                      ),
                      SizedBox(width: AppSizes.hGap16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Check your spam folder',
                              style: TextStyle(
                                color: AppTheme.textLight,
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.f14,
                              ),
                            ),
                            SizedBox(height: AppSizes.vGap4),
                            Text(
                              'Sometimes the verification email might end up in your spam or junk folder.',
                              style: TextStyle(
                                color: AppTheme.textMuted.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: AppSizes.f12,
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
