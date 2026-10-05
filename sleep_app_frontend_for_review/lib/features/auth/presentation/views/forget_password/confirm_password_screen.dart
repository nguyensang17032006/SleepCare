import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';

import 'package:sleep_app_frontend/core/constants/app_size.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/core/theme/pin_theme.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';

import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/time_remaining_vm.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/forget_password/newpassword_screen.dart';

import 'package:sleep_app_frontend/features/home/presentation/widget/glass_card.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  final String email;
  final bool returnToSettings;

  const ConfirmPasswordScreen({
    super.key,
    required this.email,
    this.returnToSettings = false,
  });

  @override
  State<ConfirmPasswordScreen> createState() =>
      _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final TextEditingController pinController =
      TextEditingController();

  final FocusNode focusNode = FocusNode();

  final TimeRemainingViewModel _timeRemainingVM =
      TimeRemainingViewModel();

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

  Future<void> _verifyOtp(
    AuthViewModel authVM,
  ) async {
    final otp = pinController.text.trim();

    final isSuccess =
        await authVM.verifyResetPasswordOTP(
      email: widget.email,
      otp: otp,
    );

    if (!mounted) return;

    if (!isSuccess) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NewPasswordScreen(
          returnToSettings:
              widget.returnToSettings,
        ),
      ),
    );
  }

  Future<void> _resendOtp(
    AuthViewModel authVM,
  ) async {
    await authVM.resendOTP(
      email: widget.email,
    );

    _timeRemainingVM.startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final authVM =
        context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Xác minh email',
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: AppSizes.f16,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.bgGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p24,
              vertical: AppSizes.vGap12,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: AppSizes.vGap32,
                ),

                Container(
                  padding: EdgeInsets.all(
                    AppSizes.p24,
                  ),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.cardLightColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme
                            .primaryColor
                            .withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.email,
                    color:
                        AppTheme.textLight,
                    size: AppSizes.p32,
                  ),
                ),

                SizedBox(
                  height: AppSizes.p32,
                ),

            

                SizedBox(
                  height: AppSizes.vGap12,
                ),

                Text(
                  'Xác minh email của bạn',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(
                        fontSize:
                            AppSizes.f24,
                      ),
                ),

                SizedBox(
                  height: AppSizes.vGap16,
                ),

                Text(
                  'Chúng tôi đã gửi mã xác nhận gồm 6 chữ số đến email của bạn. Vui lòng nhập mã bên dưới để tiếp tục.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        height: 1.8,
                      ),
                  textAlign:
                      TextAlign.center,
                ),

                const SizedBox(
                  height: 40,
                ),

                Center(
                  child: Pinput(
                    length: 6,
                    controller:
                        pinController,
                    focusNode:
                        focusNode,
                    defaultPinTheme:
                        defaultPinTheme,
                    focusedPinTheme:
                        focusedPinTheme,
                    autofocus: true,
                    keyboardType:
                        TextInputType.number,
                    errorText:
                        authVM.errorMessage,
                    forceErrorState:
                        authVM.errorMessage !=
                            null,
                    errorTextStyle:
                        TextStyle(
                      color:
                          Colors.redAccent,
                      fontSize:
                          AppSizes.f12,
                    ),
                  ),
                ),

                SizedBox(
                  height: AppSizes.p32,
                ),

                authVM.isLoading
                    ? const CircularProgressIndicator(
                        color: AppTheme
                            .primaryColor,
                      )
                    : PrimaryButton(
                        text:
                            'Xác nhận và tiếp tục',
                        onPressed: () {
                          _verifyOtp(
                            authVM,
                          );
                        },
                      ),

                SizedBox(
                  height: AppSizes.p16,
                ),

                Center(
                  child: Wrap(
                    crossAxisAlignment:
                        WrapCrossAlignment
                            .center,
                    children: [
                      const Text(
                        'Chưa nhận được mã? ',
                        style: TextStyle(
                          color:
                              AppTheme.textMuted,
                        ),
                      ),

                      ListenableBuilder(
                        listenable:
                            _timeRemainingVM,
                        builder:
                            (context, child) {
                          return TextButton(
                            onPressed:
                                _timeRemainingVM
                                        .canResend
                                    ? () {
                                        _resendOtp(
                                          authVM,
                                        );
                                      }
                                    : null,
                            child: Text(
                              _timeRemainingVM
                                      .canResend
                                  ? 'Gửi lại'
                                  : 'Gửi lại sau ${_timeRemainingVM.secondsRemaining} giây',
                              style:
                                  TextStyle(
                                color: _timeRemainingVM
                                        .canResend
                                    ? AppTheme
                                        .textLight
                                    : AppTheme
                                        .textMuted,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: AppSizes.vGap32,
                ),

                GlassCard(
                  padding: EdgeInsets.all(
                    AppSizes.p16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color:
                            AppTheme.textMuted,
                        size:
                            AppSizes.p24,
                      ),

                      SizedBox(
                        width:
                            AppSizes.hGap16,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'Kiểm tra thư mục spam',
                              style:
                                  TextStyle(
                                color: AppTheme
                                    .textLight,
                                fontWeight:
                                    FontWeight
                                        .bold,
                                fontSize:
                                    AppSizes
                                        .f14,
                              ),
                            ),

                            SizedBox(
                              height:
                                  AppSizes
                                      .vGap4,
                            ),

                            Text(
                              'Đôi khi email xác nhận có thể được chuyển vào thư mục spam hoặc thư rác.',
                              style:
                                  TextStyle(
                                color: AppTheme
                                    .textMuted
                                    .withValues(
                                  alpha: 0.8,
                                ),
                                fontSize:
                                    AppSizes
                                        .f12,
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