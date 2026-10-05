import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

final defaultPinTheme = PinTheme(
  width: AppSizes.p64,
  height: AppSizes.p64,
  textStyle: TextStyle(
    fontSize: AppSizes.f20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
  decoration: BoxDecoration(
    color: const Color(0xFF2A2A2A),
    border: Border.all(color: const Color(0xFF444444)),
    borderRadius: BorderRadius.circular(AppSizes.r8),
  ),
);

final focusedPinTheme = defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration!.copyWith(
    border: Border.all(color: AppTheme.primaryColor),
  ),
);
